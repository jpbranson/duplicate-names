# src_overture.R ----------------------------------------------------------
# Overture Maps Places, the primary spine (DESIGN.md §3).
#
# Overture publishes cloud-native GeoParquet, so with httpfs and predicate
# pushdown we read only the row groups that match. Measured: a categories +
# bbox filter over the 73.6M-row global places table returns in ~20 seconds.
# That is the whole reason this is the spine — no bulk download, no local copy
# of the planet.
#
# The filters must be expressed against `bbox` (a STRUCT of xmin/xmax/ymin/ymax)
# rather than ST_ functions. Only the former pushes down to the Parquet
# row-group statistics; an ST_Intersects predicate scans everything.

DN_OVERTURE_RELEASE <- "2026-08-19.0"   # verified current; pin, never "latest"

# Rough North America box, used only to cut row groups. The authoritative
# country filter is the address field below; this just makes the scan cheap.
DN_BBOX_NA <- c(xmin = -180, xmax = -66, ymin = 17, ymax = 72)

dn_overture_path <- function(release = DN_OVERTURE_RELEASE,
                             theme = "places", type = "place") {
  sprintf("s3://overturemaps-us-west-2/release/%s/theme=%s/type=%s/*",
          release, theme, type)
}

#' DuckDB connection with the extensions this project needs
#'
#' shared_home = TRUE keeps downloaded extensions between sessions; without it
#' httpfs and spatial are re-fetched on every run.
dn_duckdb <- function() {
  con <- DBI::dbConnect(duckdb::duckdb(shared_home = TRUE))
  DBI::dbExecute(con, "INSTALL httpfs; LOAD httpfs;")
  DBI::dbExecute(con, "INSTALL spatial; LOAD spatial;")
  DBI::dbExecute(con, "SET s3_region='us-west-2';")
  con
}

#' Pull places from Overture into the raw schema
#'
#' @param category_like SQL ILIKE pattern against categories.primary
#' @param category      value for the schema's `category` column
#' @param country       ISO alpha-2 to keep; NULL keeps everything in the bbox
#' @param cache         local parquet path; re-used unless refresh = TRUE
src_overture <- function(category_like = "%museum%",
                         category = "museum",
                         country = "US",
                         bbox = DN_BBOX_NA,
                         release = DN_OVERTURE_RELEASE,
                         cache = NULL,
                         refresh = FALSE) {

  cache <- cache %||% sprintf("data/raw/overture_%s_%s.parquet", category, release)

  if (file.exists(cache) && !refresh) {
    message(sprintf("[overture] cached: %s", cache))
    return(dn_validate(tibble::as_tibble(arrow::read_parquet(cache)),
                       dn_schema_raw(), label = "src_overture"))
  }

  con <- dn_duckdb()
  on.exit(DBI::dbDisconnect(con), add = TRUE)

  sql <- sprintf("
    SELECT
      'overture'                     AS source,
      id                             AS source_id,
      '%s'                           AS category,
      categories.primary             AS category_raw,
      names.primary                  AS name_raw,
      ST_X(geometry)                 AS lon,
      ST_Y(geometry)                 AS lat,
      addresses[1].country           AS country,
      -- Cast explicitly: a bare NULL literal types as INTEGER in DuckDB and
      -- the schema check rejects it.
      CAST(NULL AS VARCHAR)          AS denomination,
      CAST(NULL AS VARCHAR)          AS religion,
      -- Overture has no operator field; brand is the nearest thing, and it is
      -- exactly what franchise detection (§4.4) needs.
      brand.names.primary            AS operator,
      brand.wikidata                 AS wikidata_id,
      confidence                     AS confidence,
      operating_status               AS operating_status
    FROM read_parquet('%s')
    WHERE bbox.xmin BETWEEN %f AND %f
      AND bbox.ymin BETWEEN %f AND %f
      AND categories.primary ILIKE '%s'
      %s",
    category, dn_overture_path(release),
    bbox[["xmin"]], bbox[["xmax"]], bbox[["ymin"]], bbox[["ymax"]],
    category_like,
    if (is.null(country)) "" else sprintf("AND addresses[1].country = '%s'", country)
  )

  message(sprintf("[overture] querying release %s (%s)...", release, category_like))
  t0  <- Sys.time()
  out <- tibble::as_tibble(DBI::dbGetQuery(con, sql))
  message(sprintf("[overture] %s rows in %.1f min",
                  format(nrow(out), big.mark = ","),
                  as.numeric(difftime(Sys.time(), t0, units = "mins"))))

  out$retrieved <- Sys.Date()
  out <- dn_validate(out, dn_schema_raw(), label = "src_overture")

  dir.create(dirname(cache), showWarnings = FALSE, recursive = TRUE)
  arrow::write_parquet(out, cache)
  dn_record_query(
    label   = sprintf("overture_%s", category),
    source  = "overture",
    detail  = list(release = release, category_like = category_like,
                   country = country %||% "any", bbox = as.list(bbox)),
    path    = cache,
    n_rows  = nrow(out)
  )

  out
}
