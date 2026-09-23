# Archive provenance after a successful build_and_check.R run.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_methodology_2026-09-23"
manifest <- dn_manifest_read()
items <- c(Filter(function(x) x$label == "leaders_moi_directory_2026-09-23", manifest$downloads),
           Filter(function(x) x$label == "overture_moi_suffixed_context", manifest$queries))
hashes <- dplyr::bind_rows(lapply(items, function(x) tibble::tibble(label = x$label, path = x$path, sha256 = x$sha256)))
stopifnot(nrow(hashes) == 2L,
  all(vapply(seq_len(nrow(hashes)), function(i) identical(digest::digest(file = hashes$path[i], algo = "sha256"), hashes$sha256[i]), logical(1))))
readr::write_csv(hashes, file.path(packet, "acquisition_checksums.csv"))
stopifnot(file.copy("data/raw/MANIFEST.json", file.path(packet, "MANIFEST.json"), overwrite = TRUE),
          file.copy("data/processed/methodology_review_validation.log", file.path(packet, "validation.log"), overwrite = TRUE))
message(nrow(hashes), " acquisition hashes verified.")
