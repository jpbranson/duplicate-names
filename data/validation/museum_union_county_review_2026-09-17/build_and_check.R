Sys.setlocale("LC_COLLATE", "C")
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
  museum_records_file, dup_museums, multisite_review, entities_file), callr_function = NULL)
source("tests/testthat.R")
source("data/validation/museum_union_county_review_2026-09-17/validate.R")
readr::write_csv(counts, file.path(packet, "count_effects.csv"))
readr::write_csv(dplyr::bind_rows(checks), file.path(packet, "integrity_checks.csv"))
candidates <- readr::read_csv(file.path(packet, "candidates_before.csv"), show_col_types = FALSE)
j <- match(candidates$source_id, after$records$source_id)
k <- match(after$records$entity_id[j], after$analysis$entity_id)
locations <- c("Marysville OH", "Blairsville GA", "Maynardville TN", "Liberty IN", "Cobden IL",
  "Lake Butler FL", "Lewisburg PA", "Maynardville TN", "Creston IA", "Clayton NM", "Union/La Grande OR",
  "Blairsville GA", "Blairsville GA", "Monroe NC")
# Candidate order comes from canonical analysis; attach geography by immutable source key.
location_map <- stats::setNames(locations, c("59527f3f-99ff-4f83-b235-2d5f3b11f93b",
  "cc2a936a-b634-4b3b-a818-7ee5859ab8f2", "8404700288", "8401800453",
  "e7510f8e-0832-445f-9683-c41138639bf9", "8401200927", "020cc712-f2e4-47a4-aa1e-8d83179974b6",
  "fcdc3086-3d5b-43a2-a461-64033d84e849", "8401900650", "8403500111", "8404100121", "8401300409",
  "4a28b958-9a96-445f-93b5-cc21803391e0", "8403700530"))
candidate_review <- tibble::tibble(location = unname(location_map[candidates$source_id]),
  source = candidates$source, source_id = candidates$source_id,
  before_entity_id = candidates$entity_id, after_entity_id = after$analysis$entity_id[k],
  resulting_name = after$analysis$primary_name[k],
  remains_in_exact_name_group = after$analysis$name_expanded[k] == "union county historical society",
  source_row_counted_after = after$records$counted[j],
  review_status = after$analysis$review_status[k], affiliation_status = after$analysis$affiliation_status[k],
  evidence_url = after$analysis$review_evidence[k], note = after$analysis$review_note[k])
stopifnot(nrow(candidate_review) == 14L, !anyNA(candidate_review$location), !anyNA(candidate_review$evidence_url))
readr::write_csv(candidate_review, file.path(packet, "candidate_review.csv"), na = "")
readr::write_csv(after$records[affected, ], file.path(packet, "affected_records_after.csv"), na = "")
readr::write_csv(before$records[affected, ], file.path(packet, "affected_records_before.csv"), na = "")
readr::write_csv(after$analysis[k, ] |> dplyr::distinct(), file.path(packet, "reviewed_institutions_after.csv"), na = "")
for (name in c("institutions.csv", "source_records.csv", "nearby_pairs.csv", "identity_audit.csv")) {
  file.copy(file.path("data/processed/museum_review", name), file.path(packet, name), overwrite = TRUE)
}
file.copy("data/raw/MANIFEST.json", file.path(packet, "MANIFEST.json"), overwrite = TRUE)
