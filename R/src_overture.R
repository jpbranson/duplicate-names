# src_overture.R ----------------------------------------------------------
# Overture Maps Places, the primary spine (DESIGN.md §3).
#
# The point of using DuckDB here is that Overture publishes cloud-native
# GeoParquet: with httpfs + predicate pushdown we read only the row groups that
# match, so a US-only museum/church pull never downloads the planet.
#
# STUB — Phase 1. Returns a schema-valid empty table so the DAG runs end to end.

DN_OVERTURE_RELEASE <- "2026-08-21.0"  # pin explicitly; "latest" is not reproducible

dn_overture_s3 <- function(release = DN_OVERTURE_RELEASE, theme = "places", type = "place") {
  sprintf("s3://overturemaps-us-west-2/release/%s/theme=%s/type=%s/*",
          release, theme, type)
}

#' Open a DuckDB connection with the extensions this project needs
dn_duckdb <- function() {
  con <- DBI::dbConnect(duckdb::duckdb())
  DBI::dbExecute(con, "INSTALL httpfs; LOAD httpfs;")
  DBI::dbExecute(con, "INSTALL spatial; LOAD spatial;")
  DBI::dbExecute(con, "SET s3_region='us-west-2';")
  con
}

#' @param categories Overture category slugs to keep
#' @param bbox named numeric: xmin, ymin, xmax, ymax. NULL = no spatial filter.
src_overture <- function(categories = c("museum", "religious_organization"),
                         bbox = NULL,
                         release = DN_OVERTURE_RELEASE) {

  # TODO(phase-1): the real query, roughly
  #   SELECT id, names.primary AS name_raw,
  #          categories.primary AS category_raw,
  #          confidence,
  #          ST_X(geometry) AS lon, ST_Y(geometry) AS lat,
  #          addresses[1].country AS country
  #   FROM read_parquet('<s3 glob>', filename = true, hive_partitioning = 1)
  #   WHERE categories.primary IN (...) AND bbox.xmin BETWEEN ... etc
  # Filter on the bbox STRUCT columns, not on ST_ functions — only the former
  # pushes down to the row-group statistics, and that is the whole point.

  dn_schema_raw()
}
