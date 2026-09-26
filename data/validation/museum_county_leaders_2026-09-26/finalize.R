# Archive the validated county checkpoint without claiming complete headline review.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_county_leaders_2026-09-26"
analysis <- targets::tar_read(museum_analysis)
records <- targets::tar_read(museum_records)
before <- readr::read_csv(file.path(packet, "candidates_before.csv"), show_col_types = FALSE)
idx <- match(before$source_id, records$source_id)
current <- analysis[match(records$entity_id[idx], analysis$entity_id), ]
disposition <- tibble::tibble(start_source_id = before$source_id, start_name = before$name_raw,
  current_source_id = current$source_id, current_entity_id = current$entity_id,
  current_name = current$name_raw, counted = current$counted, analysis_eligible = current$analysis_eligible,
  affiliation_status = current$affiliation_status, review_status = current$review_status,
  exclusion = current$analysis_exclusion, evidence = current$review_evidence, next_review = current$review_note)
readr::write_csv(disposition, file.path(packet, "candidate_dispositions.csv"), na = "")
pending <- disposition[disposition$review_status != "verified", ]
readr::write_csv(pending, file.path(packet, "follow_up.csv"), na = "")
readr::write_csv(dn_museum_ranking(analysis), file.path(packet, "ranking_after.csv"), na = "")
outputs <- list.files("data/processed/museum_review", pattern = "[.]csv$", full.names = TRUE)
readr::write_csv(tibble::tibble(file = basename(outputs), rows = vapply(outputs, function(p) nrow(readr::read_csv(p, show_col_types = FALSE)), integer(1))), file.path(packet, "review_output_counts.csv"))
stopifnot(file.copy("data/raw/MANIFEST.json", file.path(packet, "manifest_after.json"), overwrite = TRUE))
message("Archived dispositions for ", nrow(disposition), " starting county candidates; ", nrow(pending), " remain pending.")
