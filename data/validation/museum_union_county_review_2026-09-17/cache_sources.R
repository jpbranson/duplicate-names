for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_union_county_review_2026-09-17"
sources <- jsonlite::fromJSON(file.path(packet, "sources.json"))
status_path <- file.path(packet, "cache_status.csv")
old_status <- if (file.exists(status_path)) readr::read_csv(status_path, show_col_types = FALSE) else tibble::tibble()
if (nrow(old_status)) sources <- sources[!sources$id %in% old_status$id, ]
status <- lapply(seq_len(nrow(sources)), function(i) {
  id <- sources$id[i]
  url <- sources$url[i]
  ext <- if (grepl("[.]pdf$", url)) "pdf" else if (grepl("[.]csv$", url)) "csv" else "html"
  dest <- sprintf("data/raw/union_%s_2026-09-17.%s", id, ext)
  result <- tryCatch({
    dn_fetch(url, sprintf("union_%s_2026-09-17", id), dest = dest)
    "cached"
  }, error = function(e) conditionMessage(e))
  tibble::tibble(id = id, url = url, path = dest, status = result)
})
readr::write_csv(dplyr::bind_rows(old_status, dplyr::bind_rows(status)), status_path)
for (state in c("or", "in")) {
  path <- sprintf("data/raw/union_irs_%s_2026-09-17.csv", state)
  if (file.exists(path)) {
    x <- readr::read_csv(path, col_types = readr::cols(.default = readr::col_character()))
    selected <- x[grepl("UNION COUNTY HIST|UNION COUNTY MUSEUM", x$NAME), ]
    readr::write_csv(selected, file.path(packet, paste0("irs_", state, "_selected.csv")), na = "")
    print(selected[, c("EIN", "NAME", "STREET", "CITY", "AFFILIATION")], width = Inf)
  }
}
