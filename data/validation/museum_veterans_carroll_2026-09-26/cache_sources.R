# Bounded public downloads. Save per-source progress so interruption is resumable.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_veterans_carroll_2026-09-26"
args <- commandArgs(trailingOnly = TRUE)
sources <- jsonlite::fromJSON(file.path(packet, if (length(args)) args[1] else "sources.json"))
status_path <- file.path(packet, "cache_status.csv")
status <- if (file.exists(status_path)) readr::read_csv(status_path, show_col_types = FALSE) else tibble::tibble()
for (i in seq_len(nrow(sources))) {
  id <- sources$id[i]
  if (nrow(status) && id %in% status$id) next
  url <- sources$url[i]
  ext <- if ("extension" %in% names(sources) && !is.na(sources$extension[i])) sources$extension[i] else
    if (grepl("[.]pdf$", url)) "pdf" else "html"
  dest <- sprintf("data/raw/veterans_carroll_%s_2026-09-26.%s", id, ext)
  label <- paste0("veterans_carroll_", id, "_2026-09-26")
  sha <- NA_character_
  result <- tryCatch({
    m <- dn_manifest_read()
    idx <- which(vapply(m$downloads, function(d) identical(d$label, label), logical(1)))
    if (file.exists(dest) && length(idx) == 1L) {
      sha <- digest::digest(file = dest, algo = "sha256")
      stopifnot(identical(sha, m$downloads[[idx]]$sha256))
    } else {
      curl::curl_download(url, dest, quiet = TRUE, mode = "wb",
        handle = curl::new_handle(timeout = 45L, connecttimeout = 15L, followlocation = TRUE))
      sha <- digest::digest(file = dest, algo = "sha256")
      entry <- list(label = label, url = url, path = dest, sha256 = sha,
        bytes = unname(file.size(dest)), retrieved = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z"))
      if (length(idx) == 1L) m$downloads[[idx]] <- entry else m$downloads <- c(m$downloads, list(entry))
      dn_manifest_write(m)
    }
    "cached"
  }, error = function(e) gsub("[\r\n]+", " ", conditionMessage(e)))
  if (nrow(status)) status <- status[status$id != id, ]
  status <- dplyr::bind_rows(status, tibble::tibble(id = id, url = url, path = dest, sha256 = sha, status = result))
  readr::write_csv(status, status_path, na = "")
  message(id, ": ", result)
}

