# Selective review/export rebuild; never rebuild the completed labelling sheet.
p <- 'data/validation/museum_jefferson_lincoln_2026-09-26'
stopifnot(file.exists(file.path(p,'applied.json')))
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)) {
  targets::tar_make(names=c(museum_review_files,museum_identity_audit_file,
    museum_records_file,dup_museums,multisite_review,entities_file))
  source('tests/testthat.R')
}
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
before <- readRDS('data/processed/museum_jefferson_lincoln_before.rds')
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
check('1235 earlier evidence files and human labels preserved',nrow(protected)==1235L && identical(unname(actual),protected$sha256))
old_ids <- dn_read_museum_review(file.path(p,'identity_decisions_before.csv'),dn_schema_museum_identity_decisions())
new_keys <- setdiff(ids$source_id,old_ids$source_id)
changed <- records$source_id%in%new_keys
check('Identity rows outside new cases unchanged',identical(records[!changed,],before$records[!changed,]))
check('Prior identity decisions unchanged',identical(ids[match(old_ids$source_id,ids$source_id),],old_ids))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Counts match reviewed dry run',sum(analysis$counted)==52455L && sum(analysis$analysis_eligible)==52323L && sum(records$counted)==57156L)
check('319 identity rows in 134 cases',nrow(ids)==319L && dplyr::n_distinct(ids$case_id)==134L && length(new_keys)==27L)
check('132 complete reviews 22 exclusions 80 names',sum(analysis$review_status=='verified')==132L && sum(analysis$category_decision=='not_museum')==22L && nrow(overrides)==80L)
leaders <- c('jefferson county historical society','lincoln county historical society')
group_counts <- vapply(leaders,function(n)sum(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded==n),integer(1))
check('Selected non-chain groups now two and three',all(group_counts==c(2L,3L)))
conflicts <- records[records$source_id=='8401900383',]
check('Iowa conflict isolated with no aliases; 29 total',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==29L && nrow(conflicts)==1L && !any(conflicts$counted) && all(!nzchar(dplyr::coalesce(conflicts$alt_names,''))))
canon_keys <- ids$source_id[!ids$source_id%in%old_ids$source_id & ids$role=='canonical']
check('Twelve accepted cases each have one counted source',length(canon_keys)==12L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
or_keys <- c('0da3daff-4282-4612-8117-cda5d43d319e','5d39cb0a-7d43-4c33-828d-cf6ab02f1358')
orm <- analysis[analysis$source_id%in%or_keys,]
check('Two distinct Newport museums retained with shared affiliation',nrow(orm)==2L && all(orm$counted) && all(orm$review_status=='verified') && all(orm$chain_id=='lincoln_county_oregon_historical_society') && dplyr::n_distinct(orm$entity_id)==2L)
check('North Lincoln museum untouched',identical(analysis[analysis$entity_id=='4097693c8d3d',],before$analysis[before$analysis$entity_id=='4097693c8d3d',]))
ks <- records[records$source_id%in%c('8402000142','84c30f36-4633-4f6c-a0c6-9b20edebac3a'),]
check('Unresolved Kansas contact not merged with Old Jefferson Town',nrow(ks)==2L && dplyr::n_distinct(ks$entity_id)==2L && all(ks$counted))
nm <- analysis[analysis$source_id=='3cb6a75b-de6f-4a06-92d9-2097b3964472',]
check('New Mexico identity reconciliation does not certify museum scope',nrow(nm)==1L && nm$counted && nm$review_status=='pending' && nm$affiliation_status=='independent')
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
check('All 16 starting candidates have recorded dispositions',nrow(dispositions)==16L && !anyNA(dispositions$reviewed_entity_id))
readr::write_csv(dispositions,file.path(p,'candidate_dispositions.csv'),na='')
selected <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
selected_entities <- records$entity_id[match(selected,records$source_id)]
followup <- analysis[analysis$entity_id%in%selected_entities & analysis$review_status!='verified',]
check('Eight incomplete reviews remain explicitly pending',nrow(followup)==8L)
readr::write_csv(followup,file.path(p,'follow_up.csv'),na='')
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
