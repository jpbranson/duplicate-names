# One-time preservation before the current Old Jail follow-up and M4 consistency pass.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_jail_followup_2026-09-26"
stopifnot(!file.exists(file.path(packet, "identity_decisions_before.csv")))
analysis <- targets::tar_read(museum_analysis)
baseline <- targets::tar_read(entities)
records <- targets::tar_read(museum_records)
stopifnot(sum(analysis$counted) == 52563L)
for (pair in list(c("museum_identity_decisions.csv", "identity_decisions_before.csv"), c("museum_decisions.csv", "name_decisions_before.csv"), c("museum_chain_rules.csv", "chain_rules.csv"))) {
  stopifnot(file.copy(file.path("data/validation", pair[1]), file.path(packet, pair[2])))
}
stopifnot(file.copy("data/raw/MANIFEST.json", file.path(packet, "manifest_before.json")))
stopifnot(file.copy("data/processed/museum_review/identity_audit.csv", file.path(packet, "identity_audit_before.csv")))
protected <- c(list.files("data/validation", recursive = TRUE, full.names = TRUE), "data/processed/resolution_labelling.csv")
protected <- protected[!startsWith(protected, packet) & file.exists(protected) &
  !protected %in% c("data/validation/museum_decisions.csv", "data/validation/museum_identity_decisions.csv", "data/validation/museum_chain_rules.csv", "data/validation/README.md")]
readr::write_csv(tibble::tibble(path = protected, sha256 = vapply(protected, function(p) digest::digest(file = p, algo = "sha256"), character(1))), file.path(packet, "preserved_input_checksums.csv"))
readr::write_csv(analysis[analysis$name_expanded == "old jail museum", ], file.path(packet, "candidates_before.csv"), na = "")
readr::write_csv(dn_museum_ranking(analysis), file.path(packet, "ranking_before.csv"), na = "")
saveRDS(list(entities = baseline, records = records, analysis = analysis, multisite_review = targets::tar_read(multisite_review)), "data/processed/jail_followup_before.rds")
writeLines(readLines("R/museum_identity.R"), file.path(packet, "museum_identity_before.R"))
message("Old Jail snapshot saved; ", length(protected), " files protected.")
