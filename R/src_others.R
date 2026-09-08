# src_others.R ------------------------------------------------------------
# The four supporting spine sources (DESIGN.md §3). All STUBS for Phase 0 —
# each returns a schema-valid empty table so the DAG runs end to end, and each
# carries the notes needed to implement it in Phase 1.

#' GNIS — the retired Church feature class, 2021 archive
#'
#' USGS removed Church (with Cemetery, School, Building and others) from the
#' active gazetteer in 2021 and has not touched the archive since. ~230k US
#' churches. Its staleness is a feature: it predates the modern church-plant
#' naming wave, which makes it the natural "before" panel if post 3 ever gets a
#' "now" panel from Overture.
#'
#' Caveat: GNIS names are often historical and sometimes the name of a building
#' rather than a congregation. Expect a lower match rate to HIFLD than to OSM.
src_gnis <- function() {
  # TODO(phase-1): fetch the archived national file via dn_fetch(), filter
  # FEATURE_CLASS == "Church", map PRIM_LAT_DEC / PRIM_LONG_DEC -> lat/lon.
  dn_schema_raw()
}

#' IMLS Museum Universe Data File
#'
#' ~30k US museums. Last updated FY2015Q3 and explicitly not maintained, so it
#' misses everything founded since — including, quite possibly, some of the
#' collisions the museums post is about. Use it to catch institutions that
#' commercial POI feeds miss, not as the population.
src_imls <- function() {
  # TODO(phase-1): DISCIPL code carries the museum type (ART, HST, NAT, ...),
  # which is a ready-made check on the name-derived `subject` field in §4.2.
  dn_schema_raw()
}

#' HIFLD All Places of Worship
#'
#' 254,740 records, July 2024, built from IRS 501(c)(3) filings. That lineage
#' is the interesting part: these are LEGAL names, so they carry "INC" and the
#' full "OF <PLACE>" tail that signage drops. The gap between this and the OSM
#' name for the same congregation is itself worth a paragraph in post 2.
src_hifld <- function() {
  # TODO(phase-1): pull from the ArcGIS FeatureServer layer as GeoJSON, paged.
  dn_schema_raw()
}

#' OpenStreetMap
#'
#' ODbL. Kept as an internal enrichment and validation layer whose contribution
#' stays out of the released tables (DESIGN.md §7) — it is here for the tags the
#' permissive sources lack: denomination, religion, operator, start_date,
#' wikidata. If any of those become load-bearing in a published figure, the
#' release has to be relicensed and attributed.
src_osm <- function() {
  # TODO(phase-1): Geofabrik north-america extract, or Overpass for a bbox.
  # amenity=place_of_worship, tourism=museum.
  dn_schema_raw()
}

#' Bind all sources into one raw table
dn_bind_sources <- function(...) {
  parts <- list(...)
  parts <- lapply(seq_along(parts), function(i) {
    dn_validate(parts[[i]], dn_schema_raw(), label = paste0("source[", i, "]"))
  })
  out <- dplyr::bind_rows(parts)

  # source_id must be unique within a source; a duplicate here means a paging
  # bug in the fetcher, and it would masquerade downstream as a duplicate NAME,
  # which is precisely the thing this project measures.
  dup <- out |>
    dplyr::count(source, source_id) |>
    dplyr::filter(n > 1L)
  if (nrow(dup) > 0L) {
    stop(sprintf("Duplicate source_id in: %s. Likely a paging bug in the fetcher.",
                 paste(unique(dup$source), collapse = ", ")), call. = FALSE)
  }

  dn_validate(out, dn_schema_raw(), label = "raw_all")
}
