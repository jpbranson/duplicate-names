for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
p <- "data/validation/museum_publication_2026-09-26"
stopifnot(!file.exists(file.path(p, "museum_decisions_before.csv")))
a <- targets::tar_read(museum_analysis)
stopifnot(sum(a$counted) == 52557L, sum(a$review_status == "verified") == 39L)
for (n in c("museum_decisions", "museum_identity_decisions", "museum_name_overrides", "museum_chain_rules")) stopifnot(file.copy(paste0("data/validation/", n, ".csv"), file.path(p, paste0(n, "_before.csv"))))
stopifnot(file.copy("data/raw/MANIFEST.json", file.path(p, "manifest_before.json")))
stopifnot(file.copy("data/processed/museum_review/identity_audit.csv", file.path(p, "identity_audit_before.csv")))
protected <- c(list.files("data/validation", recursive = TRUE, full.names = TRUE), "data/processed/resolution_labelling.csv")
protected <- protected[!startsWith(protected, p) & !protected %in% c(paste0("data/validation/", c("museum_decisions", "museum_identity_decisions", "museum_name_overrides", "museum_chain_rules"), ".csv"), "data/validation/README.md")]
readr::write_csv(tibble::tibble(path = protected, sha256 = vapply(protected, function(f) digest::digest(file = f, algo = "sha256"), character(1))), file.path(p, "preserved_input_checksums.csv"))
saveRDS(list(entities = targets::tar_read(entities), records = targets::tar_read(museum_records), analysis = a), "data/processed/publication_before.rds")
e <- targets::tar_read(museum_records)
x <- a[a$name_expanded == "international cryptozoology museum", ]
readr::write_csv(x, file.path(p, "seed_before.csv"), na = "")
readr::write_csv(e[e$entity_id %in% x$entity_id, ], file.path(p, "seed_records.csv"), na = "")
message(length(protected), " protected files saved")
