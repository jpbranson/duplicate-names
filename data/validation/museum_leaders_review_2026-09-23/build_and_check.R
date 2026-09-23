Sys.setlocale("LC_COLLATE", "C")
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
  museum_records_file, dup_museums, multisite_review, entities_file), callr_function = NULL)
source("tests/testthat.R")
source("data/validation/museum_leaders_review_2026-09-23/validate.R")
packet <- "data/validation/museum_leaders_review_2026-09-23"
readr::write_csv(counts, file.path(packet, "count_effects.csv"))
readr::write_csv(dplyr::bind_rows(checks), file.path(packet, "integrity_checks.csv"))
candidates <- readr::read_csv(file.path(packet, "candidates_before.csv"), show_col_types = FALSE)
j <- match(candidates$source_id, after$records$source_id)
k <- match(after$records$entity_id[j], after$analysis$entity_id)
candidate_review <- tibble::tibble(name_group = candidates$name_expanded,
  source = candidates$source, source_id = candidates$source_id,
  before_entity_id = candidates$entity_id, after_entity_id = after$records$entity_id[j],
  resulting_name = after$analysis$primary_name[k],
  remains_in_exact_name_group = after$records$counted[j] & after$analysis$name_expanded[k] == candidates$name_expanded,
  source_row_counted_after = after$records$counted[j],
  exclusion_after = after$records$exclusion_reason[j],
  review_status = after$analysis$review_status[k], affiliation_status = after$analysis$affiliation_status[k],
  evidence_url = after$analysis$review_evidence[k], note = after$analysis$review_note[k])
stopifnot(nrow(candidate_review) == 26L)
readr::write_csv(candidate_review, file.path(packet, "candidate_review.csv"), na = "")
readr::write_csv(after$records[affected, ], file.path(packet, "affected_records_after.csv"), na = "")
readr::write_csv(before$records[affected, ], file.path(packet, "affected_records_before.csv"), na = "")
reviewed <- after$analysis[unique(stats::na.omit(k)), ]
readr::write_csv(reviewed, file.path(packet, "reviewed_institutions_after.csv"), na = "")
for (name in c("institutions.csv", "source_records.csv", "nearby_pairs.csv", "identity_audit.csv")) {
  file.copy(file.path("data/processed/museum_review", name), file.path(packet, name), overwrite = TRUE)
}
