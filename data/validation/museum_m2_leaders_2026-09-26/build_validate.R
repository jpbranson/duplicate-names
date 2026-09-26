# Selective review/export rebuild; never rebuild the completed labelling sheet.
p <- 'data/validation/museum_m2_leaders_2026-09-26'
stopifnot(file.exists(file.path(p,'applied.json')))
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)) {
  targets::tar_make(names=c(museum_review_files,museum_identity_audit_file,
    museum_records_file,dup_museums,multisite_review,entities_file))
  source('tests/testthat.R')
}
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
before <- readRDS('data/processed/museum_m2_leaders_before.rds')
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
check('1887 earlier evidence files and human labels preserved',nrow(protected)==1887L && identical(unname(actual),protected$sha256))
old_ids <- dn_read_museum_review(file.path(p,'identity_decisions_before.csv'),dn_schema_museum_identity_decisions())
spec <- jsonlite::fromJSON(file.path(p,'decisions_spec.json'),simplifyVector=FALSE)
added <- dn_read_museum_review(file.path(p,'proposed_added.csv'),dn_schema_museum_identity_decisions())
changed <- records$source_id%in%added$source_id
check('Records outside fourteen explicit cases unchanged',identical(records[!changed,],before$records[!changed,]))
check('All prior identity decisions preserved',identical(ids[match(old_ids$source_id,ids$source_id),],old_ids))
check('All 37 proposed identity rows applied exactly',nrow(added)==37L && identical(ids[match(added$source_id,ids$source_id),],added))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Reviewed expected counts',sum(analysis$counted)==52387L && sum(analysis$analysis_eligible)==52255L && sum(records$counted)==57083L)
check('440 identity rows in 185 cases',nrow(ids)==440L && dplyr::n_distinct(ids$case_id)==185L)
check('174 complete reviews 25 exclusions 105 names',sum(analysis$review_status=='verified')==174L && sum(analysis$category_decision=='not_museum')==25L && nrow(overrides)==105L)
check('35 source conflicts stay isolated and uncounted',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==35L && all(!records$counted[records$exclusion_reason%in%'reviewed_source_conflict']))
canon_keys <- added$source_id[added$role=='canonical']
check('Thirteen reconciled groups each have one source representative',length(canon_keys)==13L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
old_decisions <- dn_read_museum_review(file.path(p,'museum_decisions_before.csv'),dn_schema_museum_decisions())
retired <- unlist(spec$retire_decision_keys)
old_keep <- old_decisions[!old_decisions$source_id%in%retired,]
check('Prior factual decisions unchanged except two absorbed pending Smithsonian rows',length(retired)==2L && all(old_decisions$review_status[old_decisions$source_id%in%retired]=='pending') && identical(decisions[match(old_keep$source_id,decisions$source_id),],old_keep))
check('Retired decisions belong only to explicitly absorbed uncounted rows',all(retired%in%added$source_id) && all(!records$counted[match(retired,records$source_id)]))
expected_decisions <- dn_read_museum_review(file.path(p,'proposed_new_decisions.csv'),dn_schema_museum_decisions())
check('All 29 new factual decisions applied exactly',nrow(expected_decisions)==29L && identical(decisions[match(expected_decisions$source_id,decisions$source_id),],expected_decisions))
old_names <- dn_read_museum_review(file.path(p,'museum_name_overrides_before.csv'),dn_schema_museum_name_overrides())
check('Prior names preserved',identical(overrides[match(old_names$source_id,overrides$source_id),],old_names))
new_ids <- records$entity_id[match(expected_decisions$source_id,records$source_id)]
sa <- analysis[match(new_ids,analysis$entity_id),]
check('Four newly complete and 25 pending factual reviews',nrow(sa)==29L && sum(sa$review_status=='verified')==4L && sum(sa$review_status=='pending')==25L)
check('Foundation is a positive not-museum exclusion',!analysis$counted[analysis$source_id=='8405500038'] && analysis$category_decision[analysis$source_id=='8405500038']=='not_museum')
conflict <- records[records$source_id%in%c('8401100034','8401900298'),]
check('Two new mixed sources isolated from accepted museum aliases',nrow(conflict)==2L && all(conflict$exclusion_reason=='reviewed_source_conflict') && all(conflict$alt_names==''))
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
check('All 48 starting candidates have recorded dispositions',nrow(dispositions)==48L && !anyNA(dispositions$reviewed_entity_id))
readr::write_csv(dispositions,file.path(p,'candidate_dispositions.csv'),na='')
selected <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
selected_entities <- records$entity_id[match(selected,records$source_id)]
followup <- analysis[analysis$entity_id%in%selected_entities & analysis$review_status!='verified',]
check('Twenty-five newly reviewed incomplete institutions remain explicitly pending',nrow(followup)==25L)
readr::write_csv(followup,file.path(p,'follow_up.csv'),na='')
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
