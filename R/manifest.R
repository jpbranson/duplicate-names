# manifest.R --------------------------------------------------------------
# Every raw download is recorded with its URL, fetch date and SHA-256.
# Sources shift under you — HIFLD reposts, Overture cuts a new release, GNIS
# archives get reorganized — and the manifest is what makes a number published
# today still defensible a year from now.

DN_MANIFEST <- "data/raw/MANIFEST.json"

dn_manifest_read <- function(path = DN_MANIFEST) {
  if (!file.exists(path)) return(list(downloads = list()))
  jsonlite::fromJSON(path, simplifyDataFrame = FALSE)
}

dn_manifest_write <- function(m, path = DN_MANIFEST) {
  jsonlite::write_json(m, path, auto_unbox = TRUE, pretty = TRUE)
  invisible(path)
}

#' Fetch a URL once, verify it, and record it
#'
#' Re-running is cheap: an existing file whose SHA-256 still matches the
#' manifest is left alone. A mismatch is an error rather than a silent
#' re-download, because a source changing underneath a published figure is
#' exactly the event this machinery exists to catch.
#'
#' @param label short stable key, e.g. "gnis_church_2021"
#' @param expect_sha256 optional; supply once known to pin the file forever
dn_fetch <- function(url, label, dest = NULL, expect_sha256 = NULL,
                     force = FALSE, path = DN_MANIFEST) {

  dest <- dest %||% file.path("data/raw", basename(sub("\\?.*$", "", url)))
  dir.create(dirname(dest), showWarnings = FALSE, recursive = TRUE)

  m   <- dn_manifest_read(path)
  idx <- which(vapply(m$downloads, function(d) identical(d$label, label), logical(1)))

  if (file.exists(dest) && !force) {
    sha <- digest::digest(dest, algo = "sha256", file = TRUE)

    if (length(idx) == 1L) {
      recorded <- m$downloads[[idx]]$sha256
      if (!identical(sha, recorded)) {
        stop(sprintf(
          paste0("[%s] on-disk file does not match the manifest.\n",
                 "  file:     %s\n  recorded: %s\n",
                 "Investigate before overwriting: a changed source may invalidate published numbers.\n",
                 "Use force = TRUE once you have decided the new version is what you want."),
          label, sha, recorded), call. = FALSE)
      }
      message(sprintf("[%s] cached, checksum verified", label))
      return(invisible(dest))
    }
  }

  message(sprintf("[%s] downloading %s", label, url))
  curl::curl_download(url, dest, quiet = TRUE, mode = "wb")

  sha <- digest::digest(dest, algo = "sha256", file = TRUE)
  if (!is.null(expect_sha256) && !identical(sha, expect_sha256)) {
    stop(sprintf("[%s] checksum mismatch.\n  expected: %s\n  got:      %s",
                 label, expect_sha256, sha), call. = FALSE)
  }

  entry <- list(
    label     = label,
    url       = url,
    path      = dest,
    sha256    = sha,
    bytes     = unname(file.size(dest)),
    retrieved = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")
  )
  if (length(idx) == 1L) m$downloads[[idx]] <- entry else m$downloads <- c(m$downloads, list(entry))
  dn_manifest_write(m, path)

  invisible(dest)
}

#' Record a remote QUERY the way dn_fetch() records a download
#'
#' Overture is queried in place rather than downloaded, so there is no file at
#' a URL to checksum — but "which release, which filter, how many rows, when"
#' is exactly what makes a published count defensible later. Without this, a
#' figure built on the 2026-08-19.0 release is indistinguishable from one built
#' on any other.
dn_record_query <- function(label, source, detail, path, n_rows,
                            manifest = DN_MANIFEST) {
  m   <- dn_manifest_read(manifest)
  idx <- which(vapply(m$queries %||% list(),
                      function(d) identical(d$label, label), logical(1)))

  entry <- list(
    label     = label,
    source    = source,
    detail    = detail,
    path      = path,
    n_rows    = n_rows,
    sha256    = digest::digest(path, algo = "sha256", file = TRUE),
    bytes     = unname(file.size(path)),
    retrieved = format(Sys.time(), "%Y-%m-%dT%H:%M:%S%z")
  )

  if (is.null(m$queries)) m$queries <- list()
  if (length(idx) == 1L) m$queries[[idx]] <- entry else m$queries <- c(m$queries, list(entry))
  dn_manifest_write(m, manifest)
  invisible(entry)
}

#' Path of a previously fetched file, by label
dn_raw_path <- function(label, path = DN_MANIFEST) {
  m   <- dn_manifest_read(path)
  idx <- which(vapply(m$downloads, function(d) identical(d$label, label), logical(1)))
  if (length(idx) != 1L) {
    stop("No manifest entry for label '", label, "'. Fetch it first.", call. = FALSE)
  }
  m$downloads[[idx]]$path
}
