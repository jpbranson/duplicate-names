# Run after the selective build in README.md, including multisite_review.
# Reads saved targets; refuses to overwrite a dated review.
# Example: Rscript scripts/archive_museum_review.R 2026-09-15
args <- commandArgs(trailingOnly = TRUE)
if (length(args) != 1L || !grepl("^[0-9]{4}-[0-9]{2}-[0-9]{2}$", args[1])) {
  stop("Supply one review date: YYYY-MM-DD")
}
directory <- file.path("data/validation", paste0("museum_review_", args[1]))
if (dir.exists(directory)) stop("Review archive already exists; preserve completed work: ", directory)
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
analysis <- targets::tar_read(museum_analysis)
sheets <- targets::tar_read(museum_review)
top_with_ties <- function(x, n = 20L) {
  if (!nrow(x)) return(x)
  dplyr::filter(x, .data$n_entities >= x$n_entities[min(n, nrow(x))])
}
institutions <- sheets$institutions |>
  dplyr::select("review_scope", "entity_id", "source", "source_id", "name_raw", "primary_name",
    "alt_names", "name_expanded", "lon", "lat", "map_url", "imls_location_2018", "imls_parent_2018",
    "imls_ein_2018", "imls_physical_address_2018", "imls_mailing_address_2018",
    "source_set", "n_sources", "n_sites", "category_only", "category_decision", "analysis_eligible",
    "analysis_exclusion", "affiliation_status", "chain_id", "affiliation_evidence", "chain_candidate",
    "naming_template", "subject", "imls_disciplines", "subject_check", "scope_claim",
    "review_status", "review_evidence", "review_note") |>
  dplyr::mutate(reviewed_by = NA_character_, reviewed_on = NA_character_) |>
  dplyr::arrange(.data$review_scope, .data$name_expanded, .data$entity_id)
source_columns <- c("entity_id", "site_id", "source", "source_id", "name_raw", "primary_name", "alt_names",
  "name_expanded", "lon", "lat", "source_update_time", "operating_status", "confidence",
  "operator", "n_sites", "is_primary_site", "counted", "exclusion_reason",
  setdiff(names(dn_schema_imls_context()), c("source", "source_id")))
tables <- list(
  ranking = top_with_ties(targets::tar_read(museum_ranking)),
  ranking_before_category_review = top_with_ties(dn_museum_ranking(analysis, FALSE)),
  institutions = institutions,
  source_records = dplyr::select(sheets$source_records, dplyr::all_of(source_columns)),
  multisite_records = dplyr::select(sheets$multisite_records, dplyr::all_of(source_columns)),
  nearby_pairs = sheets$nearby_pairs,
  category_review = dplyr::filter(analysis, .data$category_only) |>
    dplyr::select("entity_id", "source", "source_id", "name_raw", "primary_name", "name_expanded",
      "lon", "lat", "counted", "category_decision", "analysis_eligible", "analysis_exclusion",
      "review_status", "review_evidence", "review_note"),
  singularity_candidates = targets::tar_read(museum_singularity),
  subjects = targets::tar_read(museum_subjects),
  multisite_queue = targets::tar_read(multisite_review)
)
dir.create(directory, recursive = TRUE)
for (name in names(tables)) readr::write_csv(tables[[name]], file.path(directory, paste0(name, ".csv")), na = "")
inputs <- c("data/raw/MANIFEST.json", "data/validation/museum_chain_rules.csv",
            "data/validation/museum_decisions.csv", "data/validation/resolution_labelling_2026-09-15.csv")
provenance <- tibble::tibble(path = inputs, sha256 = vapply(inputs,
  function(path) digest::digest(file = path, algo = "sha256"), character(1)),
  review_snapshot = args[1])
readr::write_csv(provenance, file.path(directory, "input_checksums.csv"))
cat("Archived review packet in", directory, "\n")
