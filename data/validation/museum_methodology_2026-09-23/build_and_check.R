Sys.setlocale("LC_COLLATE", "C")
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file, museum_records_file,
  dup_museums, museum_chains, museum_chain_overlap, multisite_review, entities_file), callr_function = NULL)
source("tests/testthat.R")
source("data/validation/museum_methodology_2026-09-23/validate.R")
packet <- "data/validation/museum_methodology_2026-09-23"
readr::write_csv(counts, file.path(packet, "count_effects.csv"))
readr::write_csv(dplyr::bind_rows(checks), file.path(packet, "integrity_checks.csv"))
new_names <- dn_read_museum_review(file.path(packet, "applied_name_decisions.csv"), dn_schema_museum_decisions())
ids <- unique(c(new_names$source_id, added$source_id))
j <- match(ids, after$records$source_id)
k <- match(after$records$entity_id[j], after$analysis$entity_id)
reviewed <- tibble::tibble(source = after$records$source[j], source_id = ids,
  before_entity_id = before$records$entity_id[j], after_entity_id = after$records$entity_id[j],
  name_raw = after$records$name_raw[j], resulting_name = after$analysis$primary_name[k],
  source_row_counted_after = after$records$counted[j],
  institution_counted_after = after$analysis$counted[k],
  exclusion_after = after$analysis$exclusion_reason[k],
  category_decision = after$analysis$category_decision[k],
  affiliation_status = after$analysis$affiliation_status[k], chain_id = after$analysis$chain_id[k],
  review_status = after$analysis$review_status[k], note = after$analysis$review_note[k])
stopifnot(nrow(reviewed) == 18L)
readr::write_csv(reviewed, file.path(packet, "candidate_review.csv"), na = "")
for (name in c("ranking.csv", "chain_summary.csv", "chain_overlap.csv", "not_museum_review.csv",
               "singularity_candidates.csv", "identity_audit.csv")) {
  file.copy(file.path("data/processed/museum_review", name), file.path(packet, name), overwrite = TRUE)
}
