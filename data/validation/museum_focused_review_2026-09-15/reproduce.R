# Run from the repository root after restoring the pinned R environment and
# baseline targets. Reads archived decisions; does not write pipeline outputs.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_focused_review_2026-09-15"
baseline <- targets::tar_read(entities)
rules <- dn_read_museum_review(file.path(packet, "chain_rules.csv"), dn_schema_chain_rules())
replay <- function(stage) {
  identities <- dn_read_museum_review(file.path(packet, paste0("identity_decisions_", stage, ".csv")),
                                      dn_schema_museum_identity_decisions())
  names <- dn_read_museum_review(file.path(packet, paste0("name_decisions_", stage, ".csv")),
                                 dn_schema_museum_decisions())
  records <- dn_reconcile_museums(baseline, identities)$records
  analysis <- dn_museum_analysis(records, rules, names)
  list(records = records, analysis = analysis)
}
before <- replay("before")
after <- replay("after")
measure <- function(x) c(nrow(x$records), sum(x$records$counted), sum(x$analysis$counted),
  sum(x$analysis$analysis_eligible),
  sum(x$analysis$analysis_eligible & x$analysis$name_expanded == "washington county historical society", na.rm = TRUE),
  sum(x$analysis$analysis_eligible & x$analysis$name_expanded == "national vietnam war museum", na.rm = TRUE))
expected <- readr::read_csv(file.path(packet, "count_effects.csv"), show_col_types = FALSE)
stopifnot(identical(as.integer(measure(before)), expected$before |> as.integer()),
          identical(as.integer(measure(after)), expected$after |> as.integer()),
          identical(after$records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
added <- readr::read_csv(file.path(packet, "applied_identity_decisions.csv"), show_col_types = FALSE)
affected <- paste(baseline$source, baseline$source_id) %in% paste(added$source, added$source_id)
stopifnot(identical(before$records[!affected, ], after$records[!affected, ]))
print(expected)
message("Archived before/after counts, original fields and unaffected records reproduced.")
