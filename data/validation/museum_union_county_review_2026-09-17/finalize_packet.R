# Archive auxiliary evidence after a successful build_and_check.R run.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_union_county_review_2026-09-17"
for (stage in c("before", "after")) {
  path <- file.path(packet, paste0("ranking_", stage, ".csv"))
  ranking <- readr::read_csv(path, show_col_types = FALSE)
  excerpt <- dplyr::filter(ranking, .data$n_entities >= ranking$n_entities[20L] |
    .data$name_expanded == "union county historical society")
  readr::write_csv(excerpt, path, na = "")
}
fl <- readr::read_csv("data/raw/irs_eo_fl_2026-09-15.csv",
  col_types = readr::cols(.default = readr::col_character()))
readr::write_csv(fl[fl$EIN == "593163681", ], file.path(packet, "irs_fl_selected.csv"), na = "")
oregon <- readr::read_csv("data/raw/union_irs_or_2026-09-17.csv",
  col_types = readr::cols(.default = readr::col_character()))
ein_check <- tibble::tibble(ein = c("010975044", "930836487", "237031662"))
ein_check$n_rows_in_oregon_bmf <- vapply(ein_check$ein, function(ein) sum(oregon$EIN == ein, na.rm = TRUE), integer(1))
stopifnot(identical(unname(ein_check$n_rows_in_oregon_bmf), c(0L, 0L, 1L)))
readr::write_csv(ein_check, file.path(packet, "oregon_ein_lookup.csv"))
manifest <- dn_manifest_read()
items <- c(Filter(function(x) startsWith(x$label, "union_") && grepl("2026-09-17", x$label), manifest$downloads),
           Filter(function(x) x$label == "overture_union_county_context", manifest$queries),
           Filter(function(x) x$label == "irs_eo_fl_2026-09-15", manifest$downloads))
hashes <- dplyr::bind_rows(lapply(items, function(x) tibble::tibble(label = x$label, path = x$path, sha256 = x$sha256)))
stopifnot(nrow(hashes) == 32L,
  all(vapply(seq_len(nrow(hashes)), function(i) identical(digest::digest(file = hashes$path[i], algo = "sha256"), hashes$sha256[i]), logical(1))))
readr::write_csv(hashes, file.path(packet, "acquisition_checksums.csv"))
stopifnot(file.copy("data/raw/MANIFEST.json", file.path(packet, "MANIFEST.json"), overwrite = TRUE),
          file.copy("data/processed/union_review_validation.log", file.path(packet, "validation.log"), overwrite = TRUE))
message("32 acquisition hashes verified, including reused Florida source; rankings trimmed to top-20 ties plus Union County.")
