# Refresh only museum review/export targets; never rebuild the labelling sheet.
p <- 'data/validation/museum_next_leaders_2026-09-26'
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
  museum_records_file, dup_museums, multisite_review, entities_file))
source('tests/testthat.R')
for (f in list.files('R', pattern = '[.]R$', full.names = TRUE)) source(f)
before <- readRDS('data/processed/museum_next_leaders_before.rds')
baseline <- targets::tar_read(entities)
records <- targets::tar_read(museum_records)
analysis <- targets::tar_read(museum_analysis)
ids <- targets::tar_read(museum_identity_decisions)
decisions <- targets::tar_read(museum_decisions)
overrides <- targets::tar_read(museum_name_overrides)
rules <- targets::tar_read(museum_chain_rules)
gazetteer <- targets::tar_read(gazetteer)
replay <- dn_reconcile_museums(baseline, ids)
checks <- list()
check <- function(label, result) {
  checks[[length(checks) + 1L]] <<- tibble::tibble(check = label, passed = isTRUE(result))
  readr::write_csv(dplyr::bind_rows(checks), file.path(p, 'integrity_checks.csv'))
  if (!isTRUE(result)) stop(label)
}
check('Automatic baseline unchanged', identical(baseline, before$entities))
check('Baseline multisite queue unchanged', identical(targets::tar_read(multisite_review), before$multisite_review))
check('All source rows and normalized fields preserved', nrow(records) == 60002L &&
  identical(records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
check('Guarded identity replay matches pipeline', identical(records, replay$records))
check('Analysis with preferred names matches replay', identical(analysis, dn_museum_analysis(records, rules, decisions, overrides, gazetteer)))
check('Reviewed Parquet matches pipeline', identical(tibble::as_tibble(arrow::read_parquet('data/processed/museum_records.parquet')), records))
check('Baseline Parquet unchanged', identical(tibble::as_tibble(arrow::read_parquet('data/processed/entities.parquet')), baseline))
protected <- readr::read_csv(file.path(p, 'protected_files.csv'), show_col_types = FALSE)
actual <- vapply(protected$path, function(path) digest::digest(file = path, algo = 'sha256'), character(1))
check('553 earlier evidence files and human labels preserved', nrow(protected) == 553L && identical(unname(actual), protected$sha256))
old_ids <- readr::read_csv(file.path(p, 'identity_decisions_before.csv'), show_col_types = FALSE)
new_keys <- setdiff(ids$source_id, old_ids$source_id)
changed <- records$source_id %in% new_keys
check('Identity rows outside the new cases unchanged', identical(records[!changed, ], before$records[!changed, ]))
check('Threshold remains 0.85', identical(DN_NAME_SIM_MIN, 0.85))
check('Final reviewed count checkpoint', sum(analysis$counted) == 52539L && sum(analysis$analysis_eligible) == 52407L && sum(records$counted) == 57250L)
check('160 identity rows in 63 cases', nrow(ids) == 160L && dplyr::n_distinct(ids$case_id) == 63L)
check('53 complete reviews and 12 not-museum decisions', sum(analysis$review_status == 'verified') == 53L && sum(analysis$category_decision == 'not_museum') == 12L)
check('One unresolved Wayne bare-name record; no bare Depot names', sum(analysis$analysis_eligible & analysis$name_expanded == 'wayne county historical society') == 1L &&
  sum(analysis$analysis_eligible & analysis$name_expanded == 'depot museum') == 0L)
ky <- records[records$source_id == '8402100284', ]
accepted_ky <- records[records$source_id == 'd6592999-2949-4d3b-8cc4-a81fb3e3a02d', ]
check('Kentucky mixed legal identity remains isolated', nrow(ky) == 1L && !ky$counted && ky$exclusion_reason == 'reviewed_source_conflict' && ky$alt_names == '' && ky$entity_id != accepted_ky$entity_id)
check('Eight isolated source conflicts retained', sum(records$exclusion_reason == 'reviewed_source_conflict', na.rm = TRUE) == 8L)
stratford <- records[records$source_id %in% c('1c3d4cc1-1e28-4eac-827b-f295fc5c55fc','8404800059','8404801538'), ]
check('Stratford unresolved society remains separate from museum', nrow(stratford) == 3L && sum(stratford$counted) == 2L && dplyr::n_distinct(stratford$entity_id) == 2L &&
  stratford$entity_id[stratford$source_id == '8404800059'] != stratford$entity_id[stratford$source_id == '8404801538'])
rank <- dn_museum_ranking(analysis)
gate <- tryCatch({dn_assert_museum_publication_ready(analysis, rank$name_expanded[1]); ''}, error = conditionMessage)
check('Unfinished leading name fails explicit publication gate', nzchar(gate))
writeLines(gate, file.path(p, 'headline_publication_gate.txt'))
example_gate <- tryCatch({dn_assert_museum_publication_ready(analysis, 'pea river museum'); TRUE}, error = function(e) FALSE)
check('Reviewed Pea River name passes status gate', example_gate)
# Passing the gate does not validate access, map points, scope meaning or maxima.
readr::write_csv(rank, file.path(p, 'ranking_after.csv'), na = '')
readr::write_csv(records[changed, ], file.path(p, 'records_after.csv'), na = '')
candidates <- readr::read_csv(file.path(p, 'candidates_before.csv'), show_col_types = FALSE)
record_index <- match(candidates$source_id, records$source_id)
final_index <- match(records$entity_id[record_index], analysis$entity_id)
dispositions <- tibble::tibble(original_entity_id = candidates$entity_id, original_source_id = candidates$source_id,
  original_name = candidates$primary_name, reviewed_entity_id = analysis$entity_id[final_index],
  reviewed_name = analysis$primary_name[final_index], counted = analysis$counted[final_index],
  affiliation_status = analysis$affiliation_status[final_index], review_status = analysis$review_status[final_index],
  evidence_url = analysis$review_evidence[final_index], note = analysis$review_note[final_index])
readr::write_csv(dispositions, file.path(p, 'candidate_dispositions.csv'), na = '')
selected <- c(readr::read_csv(file.path(p, 'wayne_new_decisions.csv'), show_col_types = FALSE)$source_id,
  readr::read_csv(file.path(p, 'depot_new_decisions.csv'), show_col_types = FALSE)$source_id)
followup <- analysis[analysis$source_id %in% selected & analysis$review_status != 'verified', ]
tn <- analysis[analysis$source_id == '8404700410', ]
readr::write_csv(dplyr::bind_rows(followup, tn), file.path(p, 'follow_up.csv'), na = '')
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv', file.path(p, 'identity_audit_after.csv'), overwrite = TRUE))
readr::write_csv(tibble::tibble(source_rows = nrow(records), counted_source_rows = sum(records$counted),
  counted_institutions = sum(analysis$counted), eligible = sum(analysis$analysis_eligible),
  identity_rows = nrow(ids), identity_cases = dplyr::n_distinct(ids$case_id),
  complete_reviews = sum(analysis$review_status == 'verified'), pending_in_this_followup = nrow(followup) + nrow(tn)), file.path(p, 'counts.csv'))
message(length(checks), ' integrity checks passed; ', nrow(protected), ' earlier files unchanged.')
