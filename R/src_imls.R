# src_imls.R --------------------------------------------------------------
# IMLS Museum Universe Data File (DESIGN.md §3).
#
# ~30k US museums, last updated 2018 and explicitly never again. Stale, so it
# misses everything founded since — including, quite possibly, some of the
# collisions post 1 is about. Its job is to catch institutions that commercial
# POI feeds miss, and to provide DISCIPL, an independently assigned museum type
# that checks the name-derived `subject` in §4.2.
#
# The file carries FOUR name fields — COMMONNAME, LEGALNAME, ALTNAME, AKADBA.
# That is the signage-vs-legal-name distinction (§6.1) handed over directly:
# "Springfield Art Museum" vs "SPRINGFIELD ART MUSEUM ASSOCIATION INC". We key
# on COMMONNAME because a duplicate-name analysis is about the name on the
# building, and carry LEGALNAME separately for the Phase 2 write-up.

DN_IMLS_URL <- "https://www.imls.gov/sites/default/files/2018_csv_museum_data_files.zip"

src_imls <- function(cache = "data/raw/imls_museums.parquet", refresh = FALSE) {

  if (file.exists(cache) && !refresh) {
    message(sprintf("[imls] cached: %s", cache))
    return(dn_validate(tibble::as_tibble(arrow::read_parquet(cache)),
                       dn_schema_raw(), label = "src_imls"))
  }

  zip <- dn_fetch(DN_IMLS_URL, label = "imls_mudf_2018")

  ex <- file.path(tempdir(), "imls_mudf")
  dir.create(ex, showWarnings = FALSE, recursive = TRUE)
  utils::unzip(zip, exdir = ex)

  files <- list.files(ex, pattern = "[.]csv$", full.names = TRUE)
  if (!length(files)) stop("[imls] no CSVs found in the archive.", call. = FALSE)

  parts <- lapply(files, function(f) {
    x <- readr::read_csv(f, show_col_types = FALSE, progress = FALSE,
                         col_types = readr::cols(.default = readr::col_character()))
    # File 1 names the column DISCIPL; files 2 and 3 name it DISCIPLINE.
    if (!"DISCIPLINE" %in% names(x) && "DISCIPL" %in% names(x)) {
      x$DISCIPLINE <- x$DISCIPL
    }
    x[, c("MID", "DISCIPLINE", "COMMONNAME", "LEGALNAME",
          "LONGITUDE", "LATITUDE")]
  })
  raw <- dplyr::bind_rows(parts)

  # COMMONNAME is the name on the building; fall back to the legal name only
  # when it is absent.
  nm <- dplyr::coalesce(raw$COMMONNAME, raw$LEGALNAME)

  out <- tibble::tibble(
    source           = "imls",
    source_id        = raw$MID,
    category         = "museum",
    category_raw     = raw$DISCIPLINE,
    name_raw         = nm,
    lon              = suppressWarnings(as.numeric(raw$LONGITUDE)),
    lat              = suppressWarnings(as.numeric(raw$LATITUDE)),
    country          = "US",
    denomination     = NA_character_,
    religion         = NA_character_,
    operator         = NA_character_,
    wikidata_id      = NA_character_,
    confidence       = NA_real_,
    # The file is a 2018 snapshot with no liveness flag: every record was
    # believed open then, and nothing here says whether it still is. NA is the
    # honest value — claiming "open" would launder a 2018 belief into a 2026
    # fact and quietly inflate duplicate counts with institutions that closed.
    operating_status = NA_character_,
    # The CSVs are dated 2018-11-09 and will never be updated. Recording that
    # honestly is what stops IMLS from being treated as evidence that a museum
    # exists NOW — it is evidence that one existed in 2018. Resolution uses
    # this to prefer a fresher source when two disagree about a location.
    source_update_time = as.Date("2018-11-09"),
    retrieved        = Sys.Date()
  )

  dropped <- sum(is.na(out$name_raw) | !nzchar(out$name_raw) |
                   is.na(out$lon) | is.na(out$lat))
  if (dropped > 0L) {
    message(sprintf("[imls] dropping %d row(s) with no usable name or coordinates", dropped))
    out <- out[!(is.na(out$name_raw) | !nzchar(out$name_raw) |
                   is.na(out$lon) | is.na(out$lat)), ]
  }

  out <- dn_validate(out, dn_schema_raw(), label = "src_imls")

  dir.create(dirname(cache), showWarnings = FALSE, recursive = TRUE)
  arrow::write_parquet(out, cache)
  dn_record_query(label = "imls_museums", source = "imls",
                  detail = list(files = basename(files), keyed_on = "COMMONNAME"),
                  path = cache, n_rows = nrow(out))

  message(sprintf("[imls] %s rows", format(nrow(out), big.mark = ",")))
  out
}
