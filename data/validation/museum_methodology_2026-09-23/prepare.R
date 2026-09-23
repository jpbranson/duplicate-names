# Snapshot the pre-decision state for the chain-separation and not-a-museum checkpoint.
# Run once from the repository root, after the code change and before apply_review.R.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_methodology_2026-09-23"
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
records <- targets::tar_read(museum_records)
rules <- dn_read_museum_review(file.path(packet, "chain_rules.csv"), dn_schema_chain_rules())
decisions <- dn_read_museum_review(file.path(packet, "name_decisions_before.csv"), dn_schema_museum_decisions())
# The saved analysis target predates the code change; recompute it with the new
# headline rules so before/after differ only by this checkpoint's decisions.
analysis <- dn_museum_analysis(records, rules, decisions)
ranking <- dn_museum_ranking(analysis)
readr::write_csv(dplyr::filter(ranking, .data$n_entities >= ranking$n_entities[20L]),
                 file.path(packet, "ranking_before.csv"), na = "")
readr::write_csv(dn_museum_chain_summary(analysis), file.path(packet, "chain_summary_before.csv"), na = "")
saveRDS(list(entities = baseline, records = records, analysis = analysis,
             multisite_review = targets::tar_read(multisite_review)), "data/processed/methodology_review_before.rds")
message("Snapshot saved; top headline name: ", ranking$name_expanded[1], " (", ranking$n_entities[1], ")")
