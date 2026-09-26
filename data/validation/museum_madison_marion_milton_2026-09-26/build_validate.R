# Selective review/export rebuild; never rebuild the completed labelling sheet.
p <- 'data/validation/museum_madison_marion_milton_2026-09-26'
stopifnot(file.exists(file.path(p,'applied.json')))
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)) {
  targets::tar_make(names=c(museum_review_files,museum_identity_audit_file,
    museum_records_file,dup_museums,multisite_review,entities_file))
  source('tests/testthat.R')
}
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
before <- readRDS('data/processed/museum_madison_marion_milton_before.rds')
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
check('1351 earlier evidence files and human labels preserved',nrow(protected)==1351L && identical(unname(actual),protected$sha256))
old_ids <- dn_read_museum_review(file.path(p,'identity_decisions_before.csv'),dn_schema_museum_identity_decisions())
new_keys <- setdiff(ids$source_id,old_ids$source_id)
changed <- records$source_id%in%new_keys
check('Identity rows outside new cases unchanged',identical(records[!changed,],before$records[!changed,]))
check('Prior identity decisions unchanged',identical(ids[match(old_ids$source_id,ids$source_id),],old_ids))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Counts match reviewed dry run',sum(analysis$counted)==52437L && sum(analysis$analysis_eligible)==52305L && sum(records$counted)==57136L)
check('351 identity rows in 147 cases',nrow(ids)==351L && dplyr::n_distinct(ids$case_id)==147L && length(new_keys)==32L)
check('146 complete reviews 23 exclusions 91 names',sum(analysis$review_status=='verified')==146L && sum(analysis$category_decision=='not_museum')==23L && nrow(overrides)==91L)
leaders <- c('madison historical society','marion county historical society','milton historical society')
group_counts <- vapply(leaders,function(n)sum(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded==n),integer(1))
print(group_counts)
check('Selected non-chain groups now one two and zero',all(group_counts==c(1L,2L,0L)))
conflict <- records[records$source_id=='8402500617',]
check('Massachusetts conflict isolated with no aliases; 30 total',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==30L && nrow(conflict)==1L && !conflict$counted && !nzchar(dplyr::coalesce(conflict$alt_names,'')))
canon_keys <- ids$source_id[!ids$source_id%in%old_ids$source_id & ids$role=='canonical']
check('Twelve accepted identity cases each have one counted source',length(canon_keys)==12L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
ct <- analysis[analysis$source_id%in%c('3f349f47-5ac7-404e-861e-6dd74c75c10a','6e3a1797-06d7-4c68-9d06-8ea6f95c728e'),]
check('Two Connecticut museums retain separate institutions and shared affiliation',nrow(ct)==2L && all(ct$counted) && all(ct$review_status=='verified') && all(ct$chain_id=='madison_connecticut_historical_society') && dplyr::n_distinct(ct$entity_id)==2L)
oh <- analysis[analysis$source_id%in%c('1d29d4f1-1a7f-44f8-b0f9-fdac2b74004f','7765f614-0bdc-4e58-ba16-62708537b500'),]
check('Heritage Hall and Popcorn remain separate with distinct review outcomes',nrow(oh)==2L && all(oh$counted) && dplyr::n_distinct(oh$entity_id)==2L && identical(sort(oh$affiliation_status),c('chain','unknown')) && identical(sort(oh$review_status),c('pending','verified')))
nj <- analysis[analysis$source_id=='8403400620',]
check('New Jersey research office excluded; future museum not counted',nrow(nj)==1L && !nj$counted && nj$category_decision=='not_museum' && nj$review_status=='verified')
oldoh <- records[records$source_id%in%c('79d48647-afd8-4d44-87c1-37a471ff77a8','8403900089','8403900960'),]
oldoh_a <- analysis[analysis$entity_id%in%oldoh$entity_id,]
check('Madison Ohio unresolved address groups remain separate and pending',nrow(oldoh)==3L && all(oldoh$counted) && dplyr::n_distinct(oldoh$entity_id)==2L && nrow(oldoh_a)==2L && all(oldoh_a$review_status=='pending'))
ga <- records[records$source_id%in%c('cb40c1f9-e78b-4bb7-aadb-c7d3c5a70db7','8401300292','8401300511'),]
ga_a <- analysis[analysis$entity_id%in%ga$entity_id,]
check('Pasaquan predecessors reconcile to one university-affiliated museum',nrow(ga)==3L && sum(ga$counted)==1L && nrow(ga_a)==1L && ga_a$primary_name=='Pasaquan' && ga_a$chain_id=='columbus_state_university' && ga_a$review_status=='verified')
ma <- records[records$source_id%in%c('caef0a68-a7ac-4186-a96d-110d4bf38b41','e44e8222-e4ca-4141-be5a-3808d9ae88ab'),]
check('Accepted Massachusetts museum excludes mixed IMLS identity',nrow(ma)==2L && sum(ma$counted)==1L && dplyr::n_distinct(ma$entity_id)==1L && !any(ma$entity_id==conflict$entity_id))
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
check('Eight incomplete reviews remain explicitly pending',nrow(followup)==8L)
readr::write_csv(followup,file.path(p,'follow_up.csv'),na='')
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
