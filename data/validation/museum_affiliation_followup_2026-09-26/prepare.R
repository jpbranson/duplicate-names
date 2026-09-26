# One-time snapshot before supported affiliation updates.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
p <- "data/validation/museum_affiliation_followup_2026-09-26"
stopifnot(!file.exists(file.path(p, "museum_decisions_before.csv")))
a <- targets::tar_read(museum_analysis); e <- targets::tar_read(entities); r <- targets::tar_read(museum_records)
stopifnot(sum(a$counted) == 52560L)
for (n in c("museum_decisions", "museum_identity_decisions", "museum_name_overrides", "museum_chain_rules")) stopifnot(file.copy(paste0("data/validation/", n, ".csv"), file.path(p, paste0(n, "_before.csv"))))
stopifnot(file.copy("data/raw/MANIFEST.json", file.path(p, "manifest_before.json")))
stopifnot(file.copy("data/processed/museum_review/identity_audit.csv", file.path(p, "identity_audit_before.csv")))
protected <- c(list.files("data/validation", recursive = TRUE, full.names = TRUE), "data/processed/resolution_labelling.csv")
protected <- protected[!startsWith(protected, p) & !protected %in% c(paste0("data/validation/", c("museum_decisions", "museum_identity_decisions", "museum_name_overrides", "museum_chain_rules"), ".csv"), "data/validation/README.md")]
readr::write_csv(tibble::tibble(path = protected, sha256 = vapply(protected, function(f) digest::digest(file = f, algo = "sha256"), character(1))), file.path(p, "preserved_input_checksums.csv"))
selected <- a[grepl("smithsonian|madame tussaud", a$name_expanded), ]
readr::write_csv(selected, file.path(p, "candidates_before.csv"), na = "")
near <- vapply(seq_len(nrow(selected)), function(i) abs(e$lat - selected$lat[i]) < 0.006 & abs(e$lon - selected$lon[i]) < 0.008, logical(nrow(e)))
related <- e[rowSums(near, na.rm = TRUE) > 0 | e$entity_id %in% selected$entity_id, ]
readr::write_csv(related, file.path(p, "related_baseline_records.csv"), na = "")
readr::write_csv(dn_museum_ranking(a), file.path(p, "ranking_before.csv"))
readr::write_csv(a[a$analysis_eligible & !is.na(a$scope_claim), ], file.path(p, "scope_candidates.csv"), na = "")
saveRDS(list(entities = e, records = r, analysis = a, multisite_review = targets::tar_read(multisite_review)), "data/processed/affiliation_followup_before.rds")
message(nrow(selected), " candidates, ", nrow(related), " related records, ", length(protected), " protected files")

