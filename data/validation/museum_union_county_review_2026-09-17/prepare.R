for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_union_county_review_2026-09-17"
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
candidates <- dplyr::filter(analysis, .data$analysis_eligible,
                            .data$name_expanded == "union county historical society")
stopifnot(nrow(candidates) == 14L)
readr::write_csv(candidates, file.path(packet, "candidates_before.csv"), na = "")
ranking <- dn_museum_ranking(analysis)
readr::write_csv(dplyr::filter(ranking, .data$n_entities >= ranking$n_entities[20L]),
                 file.path(packet, "ranking_before.csv"), na = "")
file.copy("data/processed/museum_review/identity_audit.csv", file.path(packet, "identity_audit_before.csv"))
saveRDS(list(entities = baseline, records = before, analysis = analysis,
             multisite_review = targets::tar_read(multisite_review)), "data/processed/union_review_before.rds")
near <- vapply(seq_len(nrow(baseline)), function(i) {
  any(abs(baseline$lat[i] - candidates$lat) < 0.045 &
      abs(baseline$lon[i] - candidates$lon) < 0.065)
}, logical(1))
related <- baseline[near | grepl("Union County|Herzstein|Maynardville|Daugherty|Linn Cove", baseline$name_raw, ignore.case = TRUE), ]
related <- baseline[baseline$entity_id %in% related$entity_id, ]
readr::write_csv(related, file.path(packet, "related_baseline_records.csv"), na = "")
print(related[, c("entity_id", "source", "source_id", "name_raw", "lon", "lat", "counted")], n = 180, width = Inf)
raw <- arrow::read_parquet("data/raw/overture_museum_2026-08-19.0.parquet")
print(names(raw))
