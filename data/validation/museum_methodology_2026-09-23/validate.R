# Read-only replay and preservation checks. Run from the repository root.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
Sys.setlocale("LC_COLLATE", "C")
packet <- "data/validation/museum_methodology_2026-09-23"
baseline <- targets::tar_read(entities)
rules <- dn_read_museum_review(file.path(packet, "chain_rules.csv"), dn_schema_chain_rules())
replay <- function(stage) {
  ids <- dn_read_museum_review(file.path(packet, paste0("identity_decisions_", stage, ".csv")),
                               dn_schema_museum_identity_decisions())
  decisions <- dn_read_museum_review(file.path(packet, paste0("name_decisions_", stage, ".csv")),
                                    dn_schema_museum_decisions())
  review <- dn_reconcile_museums(baseline, ids)
  list(records = review$records, audit = review$audit,
       analysis = dn_museum_analysis(review$records, rules, decisions))
}
before <- replay("before")
after <- replay("after")
checks <- list()
check <- function(label, value) {
  checks[[length(checks) + 1L]] <<- tibble::tibble(check = label, passed = isTRUE(value))
  if (!isTRUE(value)) stop(label)
}
headline <- function(x, nm) {
  r <- dn_museum_ranking(x$analysis)
  if (nm %in% r$name_expanded) r$n_entities[r$name_expanded == nm] else 0L
}
chain_locations <- function(x, id) {
  s <- dn_museum_chain_summary(x$analysis)
  if (id %in% s$chain_id) s$n_locations[s$chain_id == id] else 0L
}
measure <- function(x) c(source_rows = nrow(x$records), counted_source_rows = sum(x$records$counted),
  counted_institutions = sum(x$analysis$counted), eligible_institutions = sum(x$analysis$analysis_eligible),
  headline_leader = dn_museum_ranking(x$analysis)$n_entities[1],
  washington_county_headline = headline(x, "washington county historical society"),
  museum_of_illusions_headline = headline(x, "museum of illusions"),
  museum_of_illusions_chain_locations = chain_locations(x, "museum_of_illusions_global"),
  chain_locations = sum(dn_museum_chain_summary(x$analysis)$n_locations),
  not_museum_records = sum(x$analysis$exclusion_reason == "reviewed_not_museum", na.rm = TRUE),
  verified_institutions = sum(x$analysis$review_status == "verified"))
expected_before <- c(60002L, 57293L, 52588L, 52456L, 11L, 7L, 1L, 11L, 79L, 0L, 16L)
expected_after <- c(60002L, 57292L, 52584L, 52452L, 11L, 4L, 1L, 25L, 93L, 3L, 19L)
check("Before counts replay", identical(as.integer(measure(before)), expected_before))
check("After counts replay", identical(as.integer(measure(after)), expected_after))
added <- dn_read_museum_review(file.path(packet, "applied_identity_decisions.csv"), dn_schema_museum_identity_decisions())
affected <- paste(baseline$source, baseline$source_id) %in% paste(added$source, added$source_id)
check("All normalized source fields unchanged", identical(after$records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
check("Records outside the Atlanta case unchanged", identical(before$records[!affected, ], after$records[!affected, ]))
check("Atlanta counts once", sum(after$records$counted[after$records$source_id %in% added$source_id]) == 1L)
check("Headline ranking has no chain-affiliated counts", all(dn_museum_ranking(after$analysis)$n_entities ==
  vapply(dn_museum_ranking(after$analysis)$name_expanded, function(nm) sum(after$analysis$analysis_eligible &
    after$analysis$name_expanded == nm & after$analysis$affiliation_status != "chain"), integer(1))))
nm <- after$analysis[after$analysis$category_decision == "not_museum", ]
check("Three verified not-a-museum records leave the count", nrow(nm) == 3L && all(!nm$counted) &&
  all(nm$review_status == "verified") && all(nm$exclusion_reason == "reviewed_not_museum"))
check("Not-a-museum source rows retained in museum_records",
  all(after$records$counted[after$records$source_id %in% nm$source_id]))
check("All original source keys retained", identical(paste(after$records$source, after$records$source_id), paste(baseline$source, baseline$source_id)))
check("Saved reviewed target matches replay", identical(targets::tar_read(museum_records), after$records))
check("Saved analysis target matches replay", identical(targets::tar_read(museum_analysis), after$analysis))
check("Saved chain targets match replay", identical(targets::tar_read(museum_chains), dn_museum_chain_summary(after$analysis)) &&
  identical(targets::tar_read(museum_chain_overlap), dn_museum_chain_overlap(after$analysis)))
check("Reviewed Parquet matches target", identical(tibble::as_tibble(arrow::read_parquet("data/processed/museum_records.parquet")), after$records))
check("Baseline Parquet matches baseline target", identical(tibble::as_tibble(arrow::read_parquet("data/processed/entities.parquet")), baseline))
protected <- readr::read_csv(file.path(packet, "preserved_input_checksums.csv"), show_col_types = FALSE)
actual <- vapply(protected$path, function(p) digest::digest(file = p, algo = "sha256"), character(1))
check("Prior packets, human labels and chain rules preserved", identical(unname(actual), protected$sha256))
gate <- function(nm) tryCatch({dn_assert_museum_publication_ready(after$analysis, nm); TRUE}, error = function(e) FALSE)
check("Publication gate rejects chain-only name", !gate("play street museum"))
check("Publication gate rejects pending headline leader", !gate(dn_museum_ranking(after$analysis)$name_expanded[1]))
live_ids <- dn_read_museum_review("data/validation/museum_identity_decisions.csv", dn_schema_museum_identity_decisions())
check("Live identity decisions match archive", identical(live_ids,
  dn_read_museum_review(file.path(packet, "identity_decisions_after.csv"), dn_schema_museum_identity_decisions())))
live_names <- dn_read_museum_review("data/validation/museum_decisions.csv", dn_schema_museum_decisions())
check("Live name decisions match archive", identical(live_names,
  dn_read_museum_review(file.path(packet, "name_decisions_after.csv"), dn_schema_museum_decisions())))
check("92 identity rows in 37 cases", nrow(live_ids) == 92L && dplyr::n_distinct(live_ids$case_id) == 37L)
check("Matching threshold remains 0.85", identical(DN_NAME_SIM_MIN, 0.85))
if (file.exists("data/processed/methodology_review_before.rds")) {
  saved_before <- readRDS("data/processed/methodology_review_before.rds")
  check("Automatic baseline unchanged", identical(baseline, saved_before$entities))
  check("Baseline multisite queue unchanged", identical(targets::tar_read(multisite_review), saved_before$multisite_review))
}
counts <- tibble::tibble(measure = names(measure(before)), before = as.integer(measure(before)), after = as.integer(measure(after)))
print(counts, n = Inf)
print(dplyr::bind_rows(checks), n = Inf)
message(nrow(protected), " protected files verified; ", length(checks), " integrity checks passed.")
