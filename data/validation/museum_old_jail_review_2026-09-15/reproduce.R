# Run from the repository root with pinned dependencies and the saved entities target.
# Reads archived decisions only; does not rebuild targets or rewrite labels.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_old_jail_review_2026-09-15"
baseline <- targets::tar_read(entities)
rules <- dn_read_museum_review(file.path(packet, "chain_rules.csv"), dn_schema_chain_rules())
replay <- function(stage) {
  identities <- dn_read_museum_review(file.path(packet, paste0("identity_decisions_", stage, ".csv")),
                                      dn_schema_museum_identity_decisions())
  decisions <- dn_read_museum_review(file.path(packet, paste0("name_decisions_", stage, ".csv")),
                                     dn_schema_museum_decisions())
  records <- dn_reconcile_museums(baseline, identities)$records
  list(records = records, analysis = dn_museum_analysis(records, rules, decisions))
}
before <- replay("before")
after <- replay("after")
measure <- function(x) c(nrow(x$records), sum(x$records$counted), sum(x$analysis$counted),
  sum(x$analysis$analysis_eligible),
  sum(x$analysis$analysis_eligible & x$analysis$name_expanded == "old jail museum", na.rm = TRUE),
  sum(x$analysis$analysis_eligible & x$analysis$name_expanded == "washington county historical society", na.rm = TRUE),
  sum(x$analysis$review_status == "verified", na.rm = TRUE))
expected <- readr::read_csv(file.path(packet, "count_effects.csv"), show_col_types = FALSE)
stopifnot(identical(as.integer(measure(before)), as.integer(expected$before)),
          identical(as.integer(measure(after)), as.integer(expected$after)),
          identical(after$records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
added <- readr::read_csv(file.path(packet, "applied_identity_decisions.csv"), show_col_types = FALSE)
affected <- paste(baseline$source, baseline$source_id) %in% paste(added$source, added$source_id)
stopifnot(identical(before$records[!affected, ], after$records[!affected, ]))
protected <- readr::read_csv(file.path(packet, "preserved_input_checksums.csv"), show_col_types = FALSE)
actual <- vapply(protected$path, function(p) digest::digest(file = p, algo = "sha256"), character(1))
stopifnot(identical(unname(actual), protected$sha256))
ready <- tryCatch({dn_assert_museum_publication_ready(after$analysis, "old jail museum"); TRUE}, error = function(e) FALSE)
stopifnot(!ready)
print(expected)
message("Archived counts, original fields, unaffected records, protected files and publication hold reproduced.")
