# Cache the public evidence cited by this review. Failures are recorded, not hidden.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_leaders_review_2026-09-23"
sources <- jsonlite::fromJSON(file.path(packet, "sources.json"))
status_path <- file.path(packet, "cache_status.csv")
old_status <- if (file.exists(status_path)) readr::read_csv(status_path, show_col_types = FALSE) else tibble::tibble()
if (nrow(old_status)) sources <- sources[!sources$id %in% old_status$id[old_status$status == "cached"], ]
status <- lapply(seq_len(nrow(sources)), function(i) {
  id <- sources$id[i]
  url <- sources$url[i]
  ext <- if (grepl("[.]zip$", url)) "zip" else if (grepl("[.]csv$", url)) "csv" else if (grepl("[.]json$", url)) "json" else "html"
  dest <- sprintf("data/raw/leaders_%s_2026-09-23.%s", id, ext)
  result <- tryCatch({
    dn_fetch(url, sprintf("leaders_%s_2026-09-23", id), dest = dest)
    "cached"
  }, error = function(e) gsub("[\r\n]+", " ", conditionMessage(e)))
  tibble::tibble(id = id, url = url, path = dest, status = result)
})
status <- dplyr::bind_rows(old_status[old_status$status == "cached", ], dplyr::bind_rows(status))
readr::write_csv(status, status_path)
print(table(status$status == "cached"))
print(status[status$status != "cached", c("id", "status")], width = Inf)
