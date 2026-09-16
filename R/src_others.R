# src_others.R ------------------------------------------------------------
# PHASE 1b — CHURCHES. Deferred, not dropped (DESIGN.md §9, decision 5).
#
# Phase 1 runs museums-first, so these three sources are still stubs returning
# schema-valid empty tables. They stay here with their notes intact because
# the schema is already church-shaped (denomination, religion, ordinal,
# place_geoid) — Phase 1b extends the pipeline rather than reopening it.
#
# When 1b starts, note that a normalizer tuned only on museum names will have
# museum-shaped blind spots: re-run the gold set with church cases ADDED
# rather than assuming the L3 gazetteer generalizes.

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
