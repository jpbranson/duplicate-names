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
  packages = c("dplyr", "stringdist", "sf", "units", "tigris", "tibble", "tidyr", "stringi", "arrow", "jsonlite",
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
  tar_target(gazetteer, dn_gazetteer()),
  tar_target(normalized, dn_normalize(raw_all, gazetteer)),
  tar_target(resolved,   dn_resolve(normalized)),
  tar_target(museum_chain_rules_file, "data/validation/museum_chain_rules.csv", format = "file"),
  tar_target(museum_chain_rules, dn_read_museum_review(museum_chain_rules_file, dn_schema_chain_rules())),
  tar_target(museum_decisions_file, "data/validation/museum_decisions.csv", format = "file"),
  tar_target(museum_decisions, dn_read_museum_review(museum_decisions_file, dn_schema_museum_decisions())),
  tar_target(entities, dn_apply_counting_policy(dn_flag_franchises(resolved, museum_chain_rules))),
  tar_target(multisite_review, dn_flag_multisite_review(entities)),

  # Preserve the automatic baseline; curated corrections carry a source-level audit.
  tar_target(museum_identity_decisions_file, "data/validation/museum_identity_decisions.csv", format = "file"),
  tar_target(museum_identity_decisions, dn_read_museum_review(
    museum_identity_decisions_file, dn_schema_museum_identity_decisions())),
  tar_target(museum_identity_review, dn_reconcile_museums(entities, museum_identity_decisions)),
  tar_target(museum_records, museum_identity_review$records),
  tar_target(museum_identity_audit_file, dn_export_museum_identity(museum_identity_review), format = "file"),
  tar_target(museum_records_file, {
    path <- "data/processed/museum_records.parquet"
    dir.create(dirname(path), recursive = TRUE, showWarnings = FALSE)
    arrow::write_parquet(museum_records, path)
    path
  }, format = "file"),

  # Phase 1a exit criterion: a MEASURED resolution error rate.
  # Writes a CSV for hand labelling; dn_score_labels() reads it back.
  tar_target(labelling_sheet, dn_build_labelling_sample(normalized), format = "file"),

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
  tar_target(museum_analysis, dn_museum_analysis(museum_records, museum_chain_rules, museum_decisions)),
  tar_target(dup_museums, metric_duplicate_counts(museum_analysis, category = "museum")),
  tar_target(museum_ranking, dn_museum_ranking(museum_analysis)),
  tar_target(museum_singularity, metric_singularity_collisions(museum_analysis)),
  tar_target(museum_subjects, metric_museum_subjects(museum_analysis)),
  tar_target(imls_review_archive, { raw_imls; "data/raw/2018_csv_museum_data_files.zip" }, format = "file"),
  tar_target(imls_review_context, dn_imls_review_context(imls_review_archive)),
  tar_target(museum_review, dn_museum_review_sheets(museum_analysis, museum_records, museum_ranking,
                                                  imls_context = imls_review_context)),
  tar_target(museum_review_files, dn_export_museum_review(
    museum_analysis, museum_ranking, museum_singularity, museum_subjects, museum_review), format = "file")
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
