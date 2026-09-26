# Refresh only museum review/export targets; never rebuild the labelling sheet.
p <- 'data/validation/museum_veterans_carroll_2026-09-26'
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)){
  targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
    museum_records_file, dup_museums, multisite_review, entities_file))
  source('tests/testthat.R')
}
for (f in list.files('R', pattern = '[.]R$', full.names = TRUE)) source(f)
before <- readRDS('data/processed/museum_veterans_carroll_before.rds')
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
check('754 earlier evidence files and human labels preserved', nrow(protected) == 754L && identical(unname(actual), protected$sha256))
old_ids <- readr::read_csv(file.path(p, 'identity_decisions_before.csv'), show_col_types = FALSE)
new_keys <- setdiff(ids$source_id, old_ids$source_id)
changed <- records$source_id %in% new_keys
check('Identity rows outside the new cases unchanged', identical(records[!changed, ], before$records[!changed, ]))
check('Threshold remains 0.85', identical(DN_NAME_SIM_MIN, 0.85))
check('Current counts match reviewed dry run',sum(analysis$counted)==52506L && sum(analysis$analysis_eligible)==52374L && sum(records$counted)==57216L)
check('220 identity rows in 86 cases',nrow(ids)==220L && dplyr::n_distinct(ids$case_id)==86L)
check('85 complete reviews and 16 not-museum decisions',sum(analysis$review_status=='verified')==85L && sum(analysis$category_decision=='not_museum')==16L)
check('Veterans three and Carroll one non-chain bare-name candidates',sum(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded=='veterans memorial museum')==3L && sum(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded=='carroll county historical society')==1L)
conflicts <- records[records$source_id%in%c('a15fd930-6e3e-4b94-8684-9031b725dbc6','9b1cdbf2-c365-4958-8d48-1030c850d56e'),]
check('Two new conflicts isolated; eleven total; no aliases',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==11L && nrow(conflicts)==2L && !any(conflicts$counted) && dplyr::n_distinct(conflicts$entity_id)==2L && all(!nzchar(dplyr::coalesce(conflicts$alt_names,''))))
ga <- analysis[analysis$source_id%in%c('8401300407','8401300461'),]
check('Georgia legal identities split and only genealogy excluded',nrow(ga)==2L && dplyr::n_distinct(ga$entity_id)==2L && identical(ga$counted,ga$source_id=='8401300407') && all(!nzchar(dplyr::coalesce(ga$alt_names,''))))
check('Centralia former site retained',records$exclusion_reason[match('33f88b41-b933-445c-b212-e8710d3bbd0e',records$source_id)]=='reviewed_former_site')
parents <- analysis[analysis$source_id%in%c('8403900313','8404700375'),]
check('Ohio and Tennessee parent records remain pending and separate',nrow(parents)==2L && all(parents$counted) && all(parents$review_status=='pending') && all(parents$affiliation_status=='chain'))
old_decisions <- dn_read_museum_review(file.path(p,'museum_decisions_before.csv'),dn_schema_museum_decisions())
check('Every prior factual decision preserved',identical(decisions[match(old_decisions$source_id,decisions$source_id),],old_decisions))
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
stopifnot(nrow(followup)==10L)
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
