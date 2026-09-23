# Archive auxiliary evidence after a successful build_and_check.R run.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_leaders_review_2026-09-23"
read_bmf <- function(path) readr::read_csv(path, col_types = readr::cols(.default = readr::col_character()))
ks <- read_bmf("data/raw/leaders_irs_eo_ks_2026-09-23.csv")
ms <- read_bmf("data/raw/leaders_irs_eo_ms_2026-09-23.csv")
selected <- dplyr::bind_rows(ks[ks$EIN == "480882253", ], ms[ms$EIN %in% c("640594458", "475558530"), ])
readr::write_csv(selected, file.path(packet, "irs_selected.csv"), na = "")
rev_dir <- file.path(tempdir(), "irs_revocations")
utils::unzip("data/raw/leaders_irs_revocations_2026-09-23.zip", exdir = rev_dir)
rev_lines <- unlist(lapply(list.files(rev_dir, full.names = TRUE), function(p) {
  x <- readLines(p, warn = FALSE, encoding = "latin1")
  x[startsWith(x, "640594458")]
}))
writeLines(rev_lines, file.path(packet, "irs_revocation_selected.txt"))
ein_check <- tibble::tibble(ein = c("480882253", "640594458", "475558530"),
  state = c("KS", "MS", "MS"),
  n_rows_in_state_bmf = c(sum(ks$EIN == "480882253"), sum(ms$EIN == "640594458"), sum(ms$EIN == "475558530")),
  n_revocation_rows = c(0L, length(rev_lines), 0L))
stopifnot(identical(ein_check$n_rows_in_state_bmf, c(1L, 0L, 1L)), ein_check$n_revocation_rows[2] >= 1L)
readr::write_csv(ein_check, file.path(packet, "irs_ein_lookup.csv"))
manifest <- dn_manifest_read()
items <- c(Filter(function(x) startsWith(x$label, "leaders_") && grepl("2026-09-23", x$label), manifest$downloads),
           Filter(function(x) x$label %in% c("overture_leaders_context", "overture_leaders_nearby_context"), manifest$queries))
hashes <- dplyr::bind_rows(lapply(items, function(x) tibble::tibble(label = x$label, path = x$path, sha256 = x$sha256)))
stopifnot(nrow(hashes) == 48L,
  all(vapply(seq_len(nrow(hashes)), function(i) identical(digest::digest(file = hashes$path[i], algo = "sha256"), hashes$sha256[i]), logical(1))))
readr::write_csv(hashes, file.path(packet, "acquisition_checksums.csv"))
stopifnot(file.copy("data/raw/MANIFEST.json", file.path(packet, "MANIFEST.json"), overwrite = TRUE),
          file.copy("data/processed/leaders_review_validation.log", file.path(packet, "validation.log"), overwrite = TRUE))
message(nrow(hashes), " acquisition hashes verified.")
