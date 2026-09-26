# Refresh only museum review/export targets; never rebuild the labelling sheet.
p <- 'data/validation/museum_discovery_pioneer_2026-09-26'
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)){
  targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
    museum_records_file, dup_museums, multisite_review, entities_file))
  source('tests/testthat.R')
}
for (f in list.files('R', pattern = '[.]R$', full.names = TRUE)) source(f)
before <- readRDS('data/processed/museum_discovery_pioneer_before.rds')
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
check('693 earlier evidence files and human labels preserved', nrow(protected) == 693L && identical(unname(actual), protected$sha256))
old_ids <- readr::read_csv(file.path(p, 'identity_decisions_before.csv'), show_col_types = FALSE)
new_keys <- setdiff(ids$source_id, old_ids$source_id)
changed <- records$source_id %in% new_keys
check('Identity rows outside the new cases unchanged', identical(records[!changed, ], before$records[!changed, ]))
check('Threshold remains 0.85', identical(DN_NAME_SIM_MIN, 0.85))
check('Current counts match reviewed dry run',sum(analysis$counted)==52516L && sum(analysis$analysis_eligible)==52384L && sum(records$counted)==57228L)
check('198 identity rows in 77 cases',nrow(ids)==198L && dplyr::n_distinct(ids$case_id)==77L)
check('76 complete reviews; prior 15 not-museum decisions unchanged',sum(analysis$review_status=='verified')==76L && sum(analysis$category_decision=='not_museum')==15L)
check('Discovery and Pioneer bare-name groups each retain four non-chain candidates',all(vapply(c("children's discovery museum",'pioneer village'),function(n)sum(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded==n)==4L,logical(1))))
fair <- records[records$source_id%in%c('90018e18-3b5c-4249-b6bd-beaa99fdad8f','4036b550-cca1-49b6-a063-3c5b2087d80a'),]
check('Ninth source conflict isolated with separate ID and no alias leakage',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==9L && dplyr::n_distinct(fair$entity_id)==2L && sum(fair$counted)==1L && all(!nzchar(dplyr::coalesce(fair$alt_names,''))))
check('Victoria and Maine retain four former-address rows',all(records$exclusion_reason[match(c('df712c0d-03f1-4990-b7ef-b1e8690cb477','8404801300','610b7843-a5a0-4929-92e0-f7802f154620','8402300222'),records$source_id)]=='reviewed_former_site'))
nobles <- analysis[analysis$source_id%in%c('fbc00187-2ae2-4edf-86cb-52d3891b10ec','3f1cd435-4026-4003-96f9-94ed74382c19'),]
check('Nobles preserves two distinct affiliated institutions',nrow(nobles)==2L && dplyr::n_distinct(nobles$entity_id)==2L && all(nobles$chain_id=='nobles_county_historical_society'))
ca <- analysis[analysis$source_id%in%c('8400600510','8400601269'),]
check('California records remain pending separate and unknown',nrow(ca)==2L && all(ca$review_status=='pending') && all(ca$affiliation_status=='unknown') && all(ca$counted))
rank <- dn_museum_ranking(analysis)
gate <- tryCatch({dn_assert_museum_publication_ready(analysis,rank$name_expanded[1]);''},error=conditionMessage)
check('Remaining leader fails explicit publication gate',nzchar(gate))
writeLines(gate,file.path(p,'headline_publication_gate.txt'))
readr::write_csv(rank,file.path(p,'ranking_after.csv'),na='')
readr::write_csv(records[changed,],file.path(p,'records_after.csv'),na='')
readr::write_csv(analysis,file.path(p,'analysis_after.csv'),na='')
candidates <- readr::read_csv(file.path(p,'candidates_before.csv'),show_col_types=FALSE)
record_index <- match(candidates$source_id,records$source_id)
final_index <- match(records$entity_id[record_index],analysis$entity_id)
dispositions <- tibble::tibble(original_entity_id=candidates$entity_id,original_source_id=candidates$source_id,original_name=candidates$primary_name,reviewed_entity_id=analysis$entity_id[final_index],reviewed_name=analysis$primary_name[final_index],counted=analysis$counted[final_index],affiliation_status=analysis$affiliation_status[final_index],review_status=analysis$review_status[final_index],evidence_url=analysis$review_evidence[final_index],note=analysis$review_note[final_index])
readr::write_csv(dispositions,file.path(p,'candidate_dispositions.csv'),na='')
selected <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
selected_entities <- records$entity_id[match(selected,records$source_id)]
followup <- analysis[analysis$entity_id%in%selected_entities & analysis$review_status!='verified',]
readr::write_csv(followup,file.path(p,'follow_up.csv'),na='')
stopifnot(nrow(followup)==8L)
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
