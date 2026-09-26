# Selective review/export rebuild; never rebuild the completed labelling sheet.
p <- 'data/validation/museum_cass_chester_crawford_2026-09-26'
stopifnot(file.exists(file.path(p,'applied.json')))
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)) {
  targets::tar_make(names=c(museum_review_files,museum_identity_audit_file,
    museum_records_file,dup_museums,multisite_review,entities_file))
  source('tests/testthat.R')
}
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
before <- readRDS('data/processed/museum_cass_chester_crawford_before.rds')
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
check('1097 earlier evidence files and human labels preserved',nrow(protected)==1097L && identical(unname(actual),protected$sha256))
old_ids <- dn_read_museum_review(file.path(p,'identity_decisions_before.csv'),dn_schema_museum_identity_decisions())
new_keys <- setdiff(ids$source_id,old_ids$source_id)
changed <- records$source_id%in%new_keys
check('Identity rows outside new cases unchanged',identical(records[!changed,],before$records[!changed,]))
check('Prior identity decisions unchanged',identical(ids[match(old_ids$source_id,ids$source_id),],old_ids))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Counts match reviewed dry run',sum(analysis$counted)==52466L && sum(analysis$analysis_eligible)==52334L && sum(records$counted)==57171L)
check('292 identity rows in 121 cases',nrow(ids)==292L && dplyr::n_distinct(ids$case_id)==121L && length(new_keys)==34L)
check('123 complete reviews 22 exclusions 69 names',sum(analysis$review_status=='verified')==123L && sum(analysis$category_decision=='not_museum')==22L && nrow(overrides)==69L)
leaders <- c('cass county historical society','chester historical society','crawford county historical society')
group_counts <- vapply(leaders,function(n)sum(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded==n),integer(1))
check('Selected non-chain groups now zero three three',all(group_counts==c(0L,3L,3L)))
conflict_keys <- c('8402600506','8403601088','8400500089','8401701082','8404201088')
conflicts <- records[records$source_id%in%conflict_keys,]
check('Five new conflicts isolated with no aliases; 28 total',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==28L && nrow(conflicts)==5L && !any(conflicts$counted) && dplyr::n_distinct(conflicts$entity_id)==5L && all(!nzchar(dplyr::coalesce(conflicts$alt_names,''))))
canon_keys <- ids$source_id[!ids$source_id%in%old_ids$source_id & ids$role%in%c('canonical','reselected_canonical')]
check('Accepted cases each have one counted source',all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
in_keys <- c('b3d41abe-793a-4a9b-891e-a3b49138fe79','cbd74505-213f-4b6c-a478-d10e20ed48e0')
indiana <- analysis[analysis$source_id%in%in_keys,]
check('Two distinct Indiana museums retained with shared affiliation',nrow(indiana)==2L && all(indiana$counted) && all(indiana$review_status=='verified') && all(indiana$chain_id=='cass_county_indiana_historical_society') && dplyr::n_distinct(indiana$entity_id)==2L)
pa_keys <- c('1583cde5-a948-4caf-b7c0-28cb8ed9bf64','6eefcd2e-0ef9-46ef-871b-d88eb2c0f35c')
pam <- analysis[analysis$source_id%in%pa_keys,]
check('Two distinct Pennsylvania museums retained with shared affiliation',nrow(pam)==2L && all(pam$counted) && all(pam$review_status=='verified') && all(pam$chain_id=='crawford_county_pennsylvania_historical_society') && dplyr::n_distinct(pam$entity_id)==2L)
terrace <- match(pa_keys[1],records$source_id)
check('Sourced Terrace site reselected without changing source point',!before$records$counted[terrace] && records$counted[terrace] && records$is_primary_site[terrace] && identical(records$lon[terrace],before$records$lon[terrace]) && identical(records$lat[terrace],before$records$lat[terrace]))
archive <- analysis[analysis$source_id=='8404201097',]
check('Society archive excluded while museums remain',nrow(archive)==1L && !archive$counted && archive$category_decision=='not_museum' && archive$review_status=='verified')
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
check('All 24 starting candidates have recorded dispositions',nrow(dispositions)==24L && !anyNA(dispositions$reviewed_entity_id))
readr::write_csv(dispositions,file.path(p,'candidate_dispositions.csv'),na='')
selected <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
selected_entities <- records$entity_id[match(selected,records$source_id)]
followup <- analysis[analysis$entity_id%in%selected_entities & analysis$review_status!='verified',]
check('Twelve incomplete reviews remain explicitly pending',nrow(followup)==12L)
readr::write_csv(followup,file.path(p,'follow_up.csv'),na='')
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
