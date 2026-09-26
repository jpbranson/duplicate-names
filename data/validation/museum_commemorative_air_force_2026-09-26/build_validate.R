# Selective review/export rebuild; never rebuild the completed labelling sheet.
p <- 'data/validation/museum_commemorative_air_force_2026-09-26'
stopifnot(file.exists(file.path(p,'applied.json')))
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)) {
  targets::tar_make(names=c(museum_review_files,museum_identity_audit_file,
    museum_records_file,dup_museums,multisite_review,entities_file))
  source('tests/testthat.R')
}
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
before <- readRDS('data/processed/museum_commemorative_air_force_before.rds')
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
check('1578 earlier evidence files and human labels preserved',nrow(protected)==1578L && identical(unname(actual),protected$sha256))
old_ids <- dn_read_museum_review(file.path(p,'identity_decisions_before.csv'),dn_schema_museum_identity_decisions())
new_keys <- setdiff(ids$source_id,old_ids$source_id)
changed <- records$source_id%in%new_keys
check('Identity rows outside new cases unchanged',identical(records[!changed,],before$records[!changed,]))
check('Prior identity decisions unchanged',identical(ids[match(old_ids$source_id,ids$source_id),],old_ids))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Counts match reviewed dry run',sum(analysis$counted)==52426L && sum(analysis$analysis_eligible)==52294L && sum(records$counted)==57126L)
check('370 identity rows in 157 cases',nrow(ids)==370L && dplyr::n_distinct(ids$case_id)==157L && length(new_keys)==6L)
check('158 complete reviews 24 exclusions 97 names',sum(analysis$review_status=='verified')==158L && sum(analysis$category_decision=='not_museum')==24L && nrow(overrides)==97L)
check('Bare generic CAF removed from non-chain ranking',!any(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded=='commemorative air force'))
check('31 source-conflict holds unchanged',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==31L)
canon_keys <- ids$source_id[!ids$source_id%in%old_ids$source_id & ids$role=='canonical']
check('Three paired museums count once each',length(canon_keys)==3L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
sel <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
sa <- analysis[analysis$source_id%in%sel,]
check('All ten reviewed institutions have sourced CAF affiliation',nrow(sa)==10L && all(sa$chain_id=='commemorative_air_force') && all(sa$is_franchise))
check('Four complete and six pending without not-museum inference',sum(sa$review_status=='verified')==4L && sum(sa$review_status=='pending')==6L && all(sa$category_decision=='not_flagged'))
mid <- analysis[analysis$source_id%in%c('c0977330-6883-49f3-ace1-67f47fc19958','2bc38465-4592-48dc-a55b-fa7956634c28','8404801178'),]
check('Three unresolved Midland roles remain distinct and pending',nrow(mid)==3L && dplyr::n_distinct(mid$entity_id)==3L && all(mid$counted) && all(mid$review_status=='pending'))
dal <- analysis[analysis$source_id%in%c('b212bf54-f6a3-47bd-bd9f-94956f73b5f9','a616fb3c-641e-4bc5-8871-fccbaf8ea5ae'),]
check('Dallas campus identities remain distinct and pending',nrow(dal)==2L && dplyr::n_distinct(dal$entity_id)==2L && all(dal$counted) && all(dal$review_status=='pending'))
ks <- analysis[analysis$source_id=='888da035-0c62-418f-ac74-d6a19ff57698',]
check('Kansas public wing name is complete',nrow(ks)==1L && ks$primary_name=='CAF Heart of America Wing' && ks$review_status=='verified')
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
check('All 7 starting candidates have recorded dispositions',nrow(dispositions)==7L && !anyNA(dispositions$reviewed_entity_id))
readr::write_csv(dispositions,file.path(p,'candidate_dispositions.csv'),na='')
selected <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
selected_entities <- records$entity_id[match(selected,records$source_id)]
followup <- analysis[analysis$entity_id%in%selected_entities & analysis$review_status!='verified',]
check('Six incomplete reviews remain explicitly pending',nrow(followup)==6L)
readr::write_csv(followup,file.path(p,'follow_up.csv'),na='')
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
