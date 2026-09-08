# _targets.R --------------------------------------------------------------
# Pipeline DAG. Run with targets::tar_make(); inspect with targets::tar_visnetwork().
#
# Shape: expensive cacheable stages up front (source pulls, normalization,
# resolution), cheap metrics fanning out behind them. Change a metric and only
# that metric re-runs.

library(targets)

tar_option_set(
  packages = c("dplyr", "tibble", "tidyr", "stringi", "arrow", "jsonlite", "digest"),
  format   = "rds",
  seed     = 20260907L
)

tar_source("R")

list(

  ## --- acquisition -------------------------------------------------------
  # Phase 0: every src_*() returns a schema-valid empty table.
  tar_target(raw_overture, src_overture()),
  tar_target(raw_osm,      src_osm()),
  tar_target(raw_gnis,     src_gnis()),
  tar_target(raw_imls,     src_imls()),
  tar_target(raw_hifld,    src_hifld()),

  tar_target(
    raw_all,
    dn_bind_sources(raw_overture, raw_osm, raw_gnis, raw_imls, raw_hifld)
  ),

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
  tar_target(dup_museums,  metric_duplicate_counts(entities, category = "museum")),
  tar_target(dup_churches, metric_duplicate_counts(entities, category = "place_of_worship"))
)
