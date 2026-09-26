# Validate a saved county sub-batch after selective target refresh.
args <- commandArgs(trailingOnly = TRUE)
stage <- if (length(args)) args[1] else stop("Supply stage: greene or jackson")
stopifnot(stage %in% c("greene", "jackson"))
packet <- "data/validation/museum_county_leaders_2026-09-26"
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
  museum_records_file, dup_museums, multisite_review, entities_file))
source("tests/testthat.R")
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
before <- readRDS("data/processed/county_leaders_before.rds")
baseline <- targets::tar_read(entities)
records <- targets::tar_read(museum_records)
analysis <- targets::tar_read(museum_analysis)
checks <- list()
check <- function(label, value) {
  checks[[length(checks) + 1L]] <<- tibble::tibble(check = label, passed = isTRUE(value))
  readr::write_csv(dplyr::bind_rows(checks), file.path(packet, paste0(stage, "_integrity_checks.csv")))
  if (!isTRUE(value)) stop(label)
}
ids <- dn_read_museum_review(file.path(packet, paste0(stage, "_identity_decisions_after.csv")), dn_schema_museum_identity_decisions())
decisions <- dn_read_museum_review(file.path(packet, paste0(stage, "_name_decisions_after.csv")), dn_schema_museum_decisions())
rules <- dn_read_museum_review(file.path(packet, "chain_rules.csv"), dn_schema_chain_rules())
replay <- dn_reconcile_museums(baseline, ids)
check("Automatic baseline unchanged", identical(baseline, before$entities))
check("Baseline multisite queue unchanged", identical(targets::tar_read(multisite_review), before$multisite_review))
check("All 60002 original rows and normalized fields preserved", nrow(records) == 60002L &&
  identical(records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
check("Saved records match guarded replay", identical(records, replay$records))
check("Saved analysis matches replay", identical(analysis, dn_museum_analysis(replay$records, rules, decisions)))
check("Reviewed Parquet refreshed", identical(tibble::as_tibble(arrow::read_parquet("data/processed/museum_records.parquet")), records))
check("Baseline Parquet unchanged", identical(tibble::as_tibble(arrow::read_parquet("data/processed/entities.parquet")), baseline))
protected <- readr::read_csv(file.path(packet, "preserved_input_checksums.csv"), show_col_types = FALSE)
actual <- vapply(protected$path, function(p) digest::digest(file = p, algo = "sha256"), character(1))
check("Earlier packets and original human labels preserved", identical(unname(actual), protected$sha256))
added_keys <- setdiff(ids$source_id, readr::read_csv(file.path(packet, "identity_decisions_before.csv"), show_col_types = FALSE)$source_id)
changed <- records$source_id %in% added_keys
check("Rows outside county identity cases unchanged", identical(records[!changed, ], before$records[!changed, ]))
check("Threshold remains 0.85", identical(DN_NAME_SIM_MIN, 0.85))
check("Franklin remains six provisional bare-name institutions", sum(analysis$analysis_eligible & analysis$name_expanded == "franklin county historical society") == 6L)
check("Greene has six provisional bare-name institutions", sum(analysis$analysis_eligible & analysis$name_expanded == "greene county historical society") == 6L)
if (stage == "greene") {
  check("57278 counted source rows", sum(records$counted) == 57278L)
  check("52568 counted institutions and 52436 eligible", sum(analysis$counted) == 52568L && sum(analysis$analysis_eligible) == 52436L)
  check("114 identity rows in 46 cases", nrow(ids) == 114L && dplyr::n_distinct(ids$case_id) == 46L)
  check("24 verified reviews and five not-museum records", sum(analysis$review_status == "verified") == 24L && sum(analysis$category_decision == "not_museum") == 5L)
  check("Jackson remains at 11", sum(analysis$analysis_eligible & analysis$name_expanded == "jackson county historical society") == 11L)
}
if (stage == "jackson") {
  check("57274 counted source rows", sum(records$counted) == 57274L)
  check("52563 counted institutions and 52431 eligible", sum(analysis$counted) == 52563L && sum(analysis$analysis_eligible) == 52431L)
  check("121 identity rows in 49 cases", nrow(ids) == 121L && dplyr::n_distinct(ids$case_id) == 49L)
  check("28 verified reviews and seven not-museum records", sum(analysis$review_status == "verified") == 28L && sum(analysis$category_decision == "not_museum") == 7L)
  check("Jackson has six provisional non-chain bare-name institutions", sum(analysis$analysis_eligible & analysis$name_expanded == "jackson county historical society" & !analysis$is_franchise %in% TRUE) == 6L)
  mo <- records[records$source_id %in% c("c4d698e3-5e35-45c6-a955-46e6af9bfca3", "3dd7d9f9-6688-44d7-a4ce-210205555063", "8402900125", "8402900687"), ]
  check("Missouri history center and jail remain two counted institutions", nrow(mo) == 4L && sum(mo$counted) == 2L && dplyr::n_distinct(mo$entity_id) == 2L)
  check("Jail aliases do not contaminate History Center", mo$alt_names[mo$source_id == "8402900687"] == "")
  baldwin <- records[records$source_id == "8401900708", ]
  check("Baldwin mixed source isolated without aliases", nrow(baldwin) == 1L && !baldwin$counted && baldwin$exclusion_reason == "reviewed_source_conflict" && baldwin$alt_names == "")
}
conflict <- records$source_id == "8bdc4b3c-69de-4f5e-bfda-3f7e5090fc63"
check("Iowa source conflict isolated and uncounted", sum(conflict) == 1L && !records$counted[conflict] &&
  records$exclusion_reason[conflict] == "reviewed_source_conflict" && records$alt_names[conflict] == "")
accepted <- analysis$source_id == "ceb2f204-b657-4768-88fb-be45ca156056"
check("Disputed museum name not propagated to accepted Iowa record", sum(accepted) == 1L &&
  !grepl("Greene County Historical Museum", analysis$alt_names[accepted], fixed = TRUE))
gate_error <- tryCatch({dn_assert_museum_publication_ready(analysis, paste(stage, "county historical society")); ""}, error = conditionMessage)
check("Unfinished headline group cannot pass publication gate", nzchar(gate_error))
writeLines(gate_error, file.path(packet, paste0(stage, "_publication_gate.txt")))
stopifnot(file.copy("data/processed/museum_review/identity_audit.csv", file.path(packet, paste0("identity_audit_", stage, "_checkpoint.csv")), overwrite = TRUE))
readr::write_csv(analysis[analysis$entity_id %in% records$entity_id[changed], ], file.path(packet, paste0(stage, "_reviewed_institutions.csv")), na = "")
readr::write_csv(records[changed, ], file.path(packet, paste0(stage, "_records_after.csv")), na = "")
readr::write_csv(tibble::tibble(source_records = nrow(records), counted_source_records = sum(records$counted),
  counted_institutions = sum(analysis$counted), eligible = sum(analysis$analysis_eligible),
  identity_rows = nrow(ids), identity_cases = dplyr::n_distinct(ids$case_id),
  verified = sum(analysis$review_status == "verified")), file.path(packet, paste0(stage, "_counts.csv")))
message(length(checks), " integrity checks passed; ", nrow(protected), " protected files unchanged.")
