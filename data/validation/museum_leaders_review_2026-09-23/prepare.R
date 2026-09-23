# Snapshot the pre-review state for the two co-leading L2 names. Run once from the repository root.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_leaders_review_2026-09-23"
leaders <- c("museum of illusions", "washington county historical society")
stopifnot(!file.exists(file.path(packet, "identity_decisions_before.csv")))
for (pair in list(c("museum_identity_decisions.csv", "identity_decisions_before.csv"),
                  c("museum_decisions.csv", "name_decisions_before.csv"),
                  c("museum_chain_rules.csv", "chain_rules.csv"))) {
  stopifnot(file.copy(file.path("data/validation", pair[1]), file.path(packet, pair[2])))
}
protected <- c(list.files("data/validation", recursive = TRUE, full.names = TRUE),
               "data/processed/resolution_labelling.csv")
protected <- protected[!startsWith(protected, packet) & file.exists(protected) &
                       !protected %in% c("data/validation/museum_decisions.csv",
                                         "data/validation/museum_identity_decisions.csv",
                                         "data/validation/README.md")]
readr::write_csv(tibble::tibble(path = protected,
  sha256 = vapply(protected, function(p) digest::digest(file = p, algo = "sha256"), character(1))),
  file.path(packet, "preserved_input_checksums.csv"))
baseline <- targets::tar_read(entities)
before <- targets::tar_read(museum_records)
analysis <- targets::tar_read(museum_analysis)
candidates <- dplyr::filter(analysis, .data$analysis_eligible, .data$name_expanded %in% leaders)
stopifnot(nrow(candidates) == 26L)
readr::write_csv(candidates, file.path(packet, "candidates_before.csv"), na = "")
ranking <- dn_museum_ranking(analysis)
readr::write_csv(dplyr::filter(ranking, .data$n_entities >= ranking$n_entities[20L]),
                 file.path(packet, "ranking_before.csv"), na = "")
file.copy("data/processed/museum_review/identity_audit.csv", file.path(packet, "identity_audit_before.csv"))
saveRDS(list(entities = baseline, records = before, analysis = analysis,
             multisite_review = targets::tar_read(multisite_review)), "data/processed/leaders_review_before.rds")
# Related baseline records: anything within ~5 km of a candidate, or sharing a leader's name stem.
near <- vapply(seq_len(nrow(baseline)), function(i) {
  any(abs(baseline$lat[i] - candidates$lat) < 0.045 & abs(baseline$lon[i] - candidates$lon) < 0.065)
}, logical(1))
named <- grepl("illusion|washington county|washington co\b", baseline$name_raw, ignore.case = TRUE)
related <- baseline[baseline$entity_id %in% baseline$entity_id[(near & grepl("illusion|washington|histor", baseline$name_raw, ignore.case = TRUE)) | named], ]
readr::write_csv(related, file.path(packet, "related_baseline_records.csv"), na = "")
imls <- dn_imls_review_context("data/raw/2018_csv_museum_data_files.zip")
readr::write_csv(dplyr::filter(imls, .data$source_id %in% related$source_id),
                 file.path(packet, "imls_context.csv"), na = "")
message(nrow(related), " related baseline records in ", dplyr::n_distinct(related$entity_id), " entities")
