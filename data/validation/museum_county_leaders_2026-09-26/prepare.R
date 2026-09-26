# One-time snapshot before Franklin, Greene and Jackson County source review.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_county_leaders_2026-09-26"
stopifnot(!file.exists(file.path(packet, "identity_decisions_before.csv")))
leaders <- paste(c("franklin", "greene", "jackson"), "county historical society")
baseline <- targets::tar_read(entities)
records <- targets::tar_read(museum_records)
analysis <- targets::tar_read(museum_analysis)
stopifnot(nrow(baseline) == 60002L, sum(analysis$counted) == 52584L)
for (pair in list(c("museum_identity_decisions.csv", "identity_decisions_before.csv"),
                  c("museum_decisions.csv", "name_decisions_before.csv"),
                  c("museum_chain_rules.csv", "chain_rules.csv"))) {
  stopifnot(file.copy(file.path("data/validation", pair[1]), file.path(packet, pair[2])))
}
stopifnot(file.copy("data/raw/MANIFEST.json", file.path(packet, "manifest_before.json")))
protected <- c(list.files("data/validation", recursive = TRUE, full.names = TRUE),
               "data/processed/resolution_labelling.csv")
protected <- protected[!startsWith(protected, packet) & file.exists(protected) &
  !protected %in% c("data/validation/museum_decisions.csv", "data/validation/museum_identity_decisions.csv",
                    "data/validation/museum_chain_rules.csv", "data/validation/README.md")]
readr::write_csv(tibble::tibble(path = protected,
  sha256 = vapply(protected, function(p) digest::digest(file = p, algo = "sha256"), character(1))),
  file.path(packet, "preserved_input_checksums.csv"))
candidates <- dplyr::filter(analysis, .data$analysis_eligible, .data$name_expanded %in% leaders)
stopifnot(nrow(candidates) == 33L)
readr::write_csv(candidates, file.path(packet, "candidates_before.csv"), na = "")
readr::write_csv(dn_museum_ranking(analysis), file.path(packet, "ranking_before.csv"), na = "")
stopifnot(file.copy("data/processed/museum_review/identity_audit.csv", file.path(packet, "identity_audit_before.csv")))
saveRDS(list(entities = baseline, records = records, analysis = analysis,
  multisite_review = targets::tar_read(multisite_review)), "data/processed/county_leaders_before.rds")
near <- vapply(seq_len(nrow(baseline)), function(i) {
  any(abs(baseline$lat[i] - candidates$lat) < 0.09 & abs(baseline$lon[i] - candidates$lon) < 0.13)
}, logical(1))
named <- grepl("franklin|greene|jackson", baseline$name_raw, ignore.case = TRUE)
related <- baseline[baseline$entity_id %in% baseline$entity_id[near | named], ]
readr::write_csv(related, file.path(packet, "related_baseline_records.csv"), na = "")
imls <- dn_imls_review_context("data/raw/2018_csv_museum_data_files.zip")
readr::write_csv(dplyr::filter(imls, .data$source_id %in% related$source_id),
  file.path(packet, "imls_context.csv"), na = "")
message("Snapshot saved: ", nrow(candidates), " candidates, ", nrow(related), " related source records.")
