# _targets.R --------------------------------------------------------------
# Pipeline DAG. Run with targets::tar_make(); inspect with targets::tar_visnetwork().
#
# Shape: expensive cacheable stages up front (source pulls, normalization,
# resolution), cheap metrics fanning out behind them. Change a metric and only
# that metric re-runs.
#
# PHASE 1a — MUSEUMS. Churches are queued, not cancelled; see the block at the
# bottom and DESIGN.md §9 decision 5.

library(targets)

tar_option_set(
  packages = c("dplyr", "tibble", "tidyr", "stringi", "arrow", "jsonlite",
               "digest", "readr", "DBI", "duckdb", "curl"),
  format   = "rds",
  seed     = 20260907L
)

tar_source("R")

list(

  ## --- acquisition: museums ---------------------------------------------
  # Both cache to data/raw/*.parquet, so a re-run does not re-query S3 or
  # re-download. Pass refresh = TRUE to force.
  tar_target(raw_overture_museums, src_overture(category_like = "%museum%",
                                                category = "museum",
                                                country = "US")),
  tar_target(raw_imls, src_imls()),

  tar_target(raw_all, dn_bind_sources(raw_overture_museums, raw_imls)),

  ## --- normalization + resolution ---------------------------------------
  tar_target(normalized, dn_normalize(raw_all)),
  tar_target(resolved,   dn_resolve(normalized)),
  tar_target(entities,   dn_attach_places(dn_flag_franchises(resolved))),

  # The publishable derived dataset (D7). Parquet so it is usable outside R.
  tar_target(
    entities_file,
    {
      dir.create("data/processed", showWarnings = FALSE, recursive = TRUE)
      path <- "data/processed/entities.parquet"
      arrow::write_parquet(entities, path)
      path
    },
    format = "file"
  ),

  ## --- metrics -----------------------------------------------------------
  tar_target(dup_museums, metric_duplicate_counts(entities, category = "museum"))
)

## --- PHASE 1b: CHURCHES (queued) ----------------------------------------
## Add back when 1b starts. The stubs already exist in R/src_others.R.
##
##   tar_target(raw_overture_worship, src_overture(
##     category_like = "%religious%", category = "place_of_worship", country = "US")),
##   tar_target(raw_gnis,  src_gnis()),
##   tar_target(raw_hifld, src_hifld()),
##   tar_target(raw_osm,   src_osm()),
##   tar_target(census_places, tigris::places(cb = TRUE)),   # C2 denominator
##
## and extend dn_bind_sources() plus add:
##   tar_target(dup_churches, metric_duplicate_counts(entities,
##                                                    category = "place_of_worship"))
