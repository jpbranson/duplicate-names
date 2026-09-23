# Read-only replay and preservation checks. Run from the repository root.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
Sys.setlocale("LC_COLLATE", "C")
packet <- "data/validation/museum_union_county_review_2026-09-17"
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
measure <- function(x) c(source_rows = nrow(x$records), counted_source_rows = sum(x$records$counted),
  counted_institutions = sum(x$analysis$counted), eligible_institutions = sum(x$analysis$analysis_eligible),
  union_county_name = sum(x$analysis$analysis_eligible & x$analysis$name_expanded == "union county historical society", na.rm = TRUE),
  washington_county_name = sum(x$analysis$analysis_eligible & x$analysis$name_expanded == "washington county historical society", na.rm = TRUE),
  old_jail_name = sum(x$analysis$analysis_eligible & x$analysis$name_expanded == "old jail museum", na.rm = TRUE),
  verified_institutions = sum(x$analysis$review_status == "verified"))
expected_before <- c(60002L, 57313L, 52605L, 52473L, 14L, 13L, 12L, 2L)
expected_after <- c(60002L, 57305L, 52597L, 52465L, 7L, 13L, 12L, 3L)
check("Before counts replay", identical(as.integer(measure(before)), expected_before))
check("After counts replay", identical(as.integer(measure(after)), expected_after))
added <- dn_read_museum_review(file.path(packet, "applied_identity_decisions.csv"), dn_schema_museum_identity_decisions())
affected <- paste(baseline$source, baseline$source_id) %in% paste(added$source, added$source_id)
check("All normalized source fields unchanged", identical(after$records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
check("Records outside 15 reviewed members unchanged", identical(before$records[!affected, ], after$records[!affected, ]))
check("Six complete identity cases", nrow(added) == 15L && dplyr::n_distinct(added$case_id) == 6L)
check("Every affected baseline member explicitly listed", setequal(paste(baseline$source[baseline$entity_id %in% added$expected_entity_id], baseline$source_id[baseline$entity_id %in% added$expected_entity_id]), paste(added$source, added$source_id)))
canonical <- added$source_id[added$role == "canonical"]
check("One counted representative per added case", all(vapply(split(added$source_id, added$case_id), function(ids) sum(after$records$counted[after$records$source_id %in% ids]) == 1L, logical(1))))
check("All original source keys retained", identical(paste(after$records$source, after$records$source_id), paste(baseline$source, baseline$source_id)))
check("Saved reviewed target matches replay", identical(targets::tar_read(museum_records), after$records))
check("Saved analysis target matches replay", identical(targets::tar_read(museum_analysis), after$analysis))
check("Reviewed Parquet matches target", identical(tibble::as_tibble(arrow::read_parquet("data/processed/museum_records.parquet")), after$records))
check("Baseline Parquet matches baseline target", identical(tibble::as_tibble(arrow::read_parquet("data/processed/entities.parquet")), baseline))
protected <- readr::read_csv(file.path(packet, "preserved_input_checksums.csv"), show_col_types = FALSE)
actual <- vapply(protected$path, function(p) digest::digest(file = p, algo = "sha256"), character(1))
check("Prior packets, human labels and chain rules preserved", identical(unname(actual), protected$sha256))
ready <- tryCatch({dn_assert_museum_publication_ready(after$analysis, "union county historical society"); TRUE}, error = function(e) FALSE)
check("Union County publication gate rejects pending group", !ready)
ia <- after$analysis[after$analysis$source_id == "6144cfa5-647e-4aac-a4be-8300a2f04644", ]
check("Iowa has supported independent factual review", nrow(ia) == 1L && ia$affiliation_status == "independent" && ia$review_status == "verified")
check("Other reviewed candidates stay pending", sum(after$analysis$review_status == "verified") == sum(before$analysis$review_status == "verified") + 1L)
live_ids <- dn_read_museum_review("data/validation/museum_identity_decisions.csv", dn_schema_museum_identity_decisions())
check("Live identity decisions match archive", identical(live_ids, dn_read_museum_review(file.path(packet, "identity_decisions_after.csv"), dn_schema_museum_identity_decisions())))
check("71 identity rows in 28 cases", nrow(live_ids) == 71L && dplyr::n_distinct(live_ids$case_id) == 28L)
check("Existing four source conflicts remain isolated", sum(after$records$exclusion_reason == "reviewed_source_conflict", na.rm = TRUE) == 4L)
check("Matching threshold remains 0.85", identical(DN_NAME_SIM_MIN, 0.85))
new_names <- dn_read_museum_review(file.path(packet, "applied_name_decisions.csv"), dn_schema_museum_decisions())
check("Eleven resulting institutions have factual review notes", nrow(new_names) == 11L)
if (file.exists("data/processed/union_review_before.rds")) {
  saved_before <- readRDS("data/processed/union_review_before.rds")
  check("Automatic baseline unchanged", identical(baseline, saved_before$entities))
  check("Baseline multisite queue unchanged", identical(targets::tar_read(multisite_review), saved_before$multisite_review))
}
counts <- tibble::tibble(measure = names(measure(before)), before = as.integer(measure(before)), after = as.integer(measure(after)))
print(counts)
print(dplyr::bind_rows(checks), n = Inf)
message(nrow(protected), " protected files verified; ", length(checks), " integrity checks passed.")
