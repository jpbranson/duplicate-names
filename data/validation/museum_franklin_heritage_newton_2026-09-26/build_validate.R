# Selective review/export rebuild; never rebuild the completed labelling sheet.
p <- 'data/validation/museum_franklin_heritage_newton_2026-09-26'
stopifnot(file.exists(file.path(p,'applied.json')))
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)) {
  targets::tar_make(names=c(museum_review_files,museum_identity_audit_file,
    museum_records_file,dup_museums,multisite_review,entities_file))
  source('tests/testthat.R')
}
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
before <- readRDS('data/processed/museum_franklin_heritage_newton_before.rds')
baseline <- targets::tar_read(entities)
records <- targets::tar_read(museum_records)
analysis <- targets::tar_read(museum_analysis)
ids <- targets::tar_read(museum_identity_decisions)
decisions <- targets::tar_read(museum_decisions)
overrides <- targets::tar_read(museum_name_overrides)
rules <- targets::tar_read(museum_chain_rules)
gazetteer <- targets::tar_read(gazetteer)
replay <- dn_reconcile_museums(baseline,ids)
checks <- list()
check <- function(label,result) {
  checks[[length(checks)+1L]] <<- tibble::tibble(check=label,passed=isTRUE(result))
  readr::write_csv(dplyr::bind_rows(checks),file.path(p,'integrity_checks.csv'))
  if(!isTRUE(result))stop(label)
}
check('Automatic baseline unchanged',identical(baseline,before$entities))
check('Baseline multisite queue unchanged',identical(targets::tar_read(multisite_review),before$multisite_review))
check('All source rows and normalized fields preserved',nrow(records)==60002L &&
  identical(records[names(dn_schema_normalized())],baseline[names(dn_schema_normalized())]))
check('Guarded identity replay matches pipeline',identical(records,replay$records))
check('Preferred-name analysis matches replay',identical(analysis,dn_museum_analysis(records,rules,decisions,overrides,gazetteer)))
check('Reviewed Parquet matches pipeline',identical(tibble::as_tibble(arrow::read_parquet('data/processed/museum_records.parquet')),records))
check('Baseline Parquet unchanged',identical(tibble::as_tibble(arrow::read_parquet('data/processed/entities.parquet')),baseline))
protected <- readr::read_csv(file.path(p,'protected_files.csv'),show_col_types=FALSE)
actual <- vapply(protected$path,function(path)digest::digest(file=path,algo='sha256'),character(1))
check('1667 earlier evidence files and human labels preserved',nrow(protected)==1667L && identical(unname(actual),protected$sha256))
old_ids <- dn_read_museum_review(file.path(p,'identity_decisions_before.csv'),dn_schema_museum_identity_decisions())
new_keys <- setdiff(ids$source_id,old_ids$source_id)
changed <- records$source_id%in%new_keys
check('Identity rows outside new cases unchanged',identical(records[!changed,],before$records[!changed,]))
check('Prior identity decisions unchanged',identical(ids[match(old_ids$source_id,ids$source_id),],old_ids))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Counts match reviewed dry run',sum(analysis$counted)==52413L && sum(analysis$analysis_eligible)==52281L && sum(records$counted)==57111L)
check('396 identity rows in 168 cases',nrow(ids)==396L && dplyr::n_distinct(ids$case_id)==168L && length(new_keys)==26L)
check('166 complete reviews 24 exclusions 100 names',sum(analysis$review_status=='verified')==166L && sum(analysis$category_decision=='not_museum')==24L && nrow(overrides)==100L)
check('33 source-conflict holds retained uncounted',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==33L && all(!records$counted[records$exclusion_reason%in%'reviewed_source_conflict']))
canon_keys <- ids$source_id[!ids$source_id%in%old_ids$source_id & ids$role=='canonical']
check('Ten accepted case groups count one source representative each',length(canon_keys)==10L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
sel <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
sa <- analysis[analysis$source_id%in%sel,]
check('All 23 factual decisions represented in analysis',nrow(sa)==23L)
check('Eight complete and fifteen pending without new exclusions',sum(sa$review_status=='verified')==8L && sum(sa$review_status=='pending')==15L && all(sa$category_decision=='not_flagged'))
mixed <- records[records$source_id%in%c('8403400077','8401900081'),]
fi <- analysis[analysis$source_id=='1cbdadb2-913f-427e-b0cf-6e2e6dd9c499',]
check('Mixed rows isolated and New Jersey alias removed from Indiana',nrow(mixed)==2L && all(!mixed$counted) && all(mixed$alt_names=='') && nrow(fi)==1L && fi$primary_name=='Franklin Heritage' && !grepl('museum',fi$alt_names,ignore.case=TRUE) && fi$review_status=='pending')
jew <- records[records$source_id%in%c('5e1afd1f-bf13-48b3-9f08-4936e81d27c5','8403400166'),]
check('Clean Jewish museum pair excludes mixed Iowa membership',nrow(jew)==2L && dplyr::n_distinct(jew$entity_id)==1L && !any(jew$entity_id%in%mixed$entity_id) && sum(jew$counted)==1L)
va <- records[records$source_id%in%c('8378f398-13e7-4e0b-b764-52ce05a943da','b4323a53-17f7-4436-9bca-0e82ee139771','4c10b642-27e3-484c-8603-91a9312b01e1','8405100619','4dc40b24-03e8-483b-a719-7fe15906f546'),]
check('Five Rocktown descriptions retain one current canonical',nrow(va)==5L && sum(va$counted)==1L && all(va$primary_name=='Rocktown History'))
ar <- analysis[analysis$source_id%in%c('23141362-d61e-42a0-8b56-49952643a25a','8400500046'),]
check('Unresolved Arkansas 403 and 601 descriptions remain separate pending',nrow(ar)==2L && dplyr::n_distinct(ar$entity_id)==2L && all(ar$counted) && all(ar$review_status=='pending'))
chain <- analysis[analysis$source_id%in%c('710d0bf4-30ce-4ced-bcff-7761f12f0f23','8404100102','68298af8-35dc-4355-b21c-88bb971e19df'),]
check('Three specifically sourced chain affiliations retained',nrow(chain)==3L && all(chain$is_franchise) && sum(chain$chain_id=='clatsop_county_historical_society')==2L && sum(chain$review_status=='pending')==1L)
ct <- analysis[analysis$source_id%in%c('8c6b6a79-2e47-4a50-b801-317c3341988e','8400900244'),]
check('Connecticut society and museum remain separate pending',nrow(ct)==2L && dplyr::n_distinct(ct$entity_id)==2L && all(ct$review_status=='pending'))
old_decisions <- dn_read_museum_review(file.path(p,'museum_decisions_before.csv'),dn_schema_museum_decisions())
check('Every prior factual decision preserved',identical(decisions[match(old_decisions$source_id,decisions$source_id),],old_decisions))
rank <- dn_museum_ranking(analysis)
gate <- tryCatch({dn_assert_museum_publication_ready(analysis,rank$name_expanded[1]);''},error=conditionMessage)
check('National leader still fails explicit publication gate',nzchar(gate))
writeLines(gate,file.path(p,'headline_publication_gate.txt'))
readr::write_csv(rank,file.path(p,'ranking_after.csv'),na='')
readr::write_csv(records[changed,],file.path(p,'records_after.csv'),na='')
readr::write_csv(analysis,file.path(p,'analysis_after.csv'),na='')
candidates <- readr::read_csv(file.path(p,'candidates_before.csv'),show_col_types=FALSE)
record_index <- match(candidates$source_id,records$source_id)
final_index <- match(records$entity_id[record_index],analysis$entity_id)
dispositions <- tibble::tibble(original_entity_id=candidates$entity_id,original_source_id=candidates$source_id,original_name=candidates$primary_name,reviewed_entity_id=analysis$entity_id[final_index],reviewed_name=analysis$primary_name[final_index],counted=analysis$counted[final_index],affiliation_status=analysis$affiliation_status[final_index],review_status=analysis$review_status[final_index],evidence_url=analysis$review_evidence[final_index],note=analysis$review_note[final_index])
check('All 21 starting candidates have recorded dispositions',nrow(dispositions)==21L && !anyNA(dispositions$reviewed_entity_id))
readr::write_csv(dispositions,file.path(p,'candidate_dispositions.csv'),na='')
selected <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
selected_entities <- records$entity_id[match(selected,records$source_id)]
followup <- analysis[analysis$entity_id%in%selected_entities & analysis$review_status!='verified',]
check('Fifteen incomplete reviews remain explicitly pending',nrow(followup)==15L)
readr::write_csv(followup,file.path(p,'follow_up.csv'),na='')
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
