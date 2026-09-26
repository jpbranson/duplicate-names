# Selective review/export rebuild; never rebuild the completed labelling sheet.
p <- 'data/validation/museum_telephone_union_washington_2026-09-26'
stopifnot(file.exists(file.path(p,'applied.json')))
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)) {
  targets::tar_make(names=c(museum_review_files,museum_identity_audit_file,
    museum_records_file,dup_museums,multisite_review,entities_file))
  source('tests/testthat.R')
}
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
before <- readRDS('data/processed/museum_telephone_union_washington_before.rds')
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
check('1781 earlier evidence files and human labels preserved',nrow(protected)==1781L && identical(unname(actual),protected$sha256))
old_ids <- dn_read_museum_review(file.path(p,'identity_decisions_before.csv'),dn_schema_museum_identity_decisions())
spec <- jsonlite::fromJSON(file.path(p,'decisions_spec.json'),simplifyVector=FALSE)
added <- dn_read_museum_review(file.path(p,'proposed_added.csv'),dn_schema_museum_identity_decisions())
changed <- records$source_id%in%added$source_id
check('Source records outside four reviewed cases unchanged',identical(records[!changed,],before$records[!changed,]))
prior_unchanged <- old_ids[!old_ids$case_id%in%unlist(spec$replace_identity_cases),]
check('Prior identity decisions outside explicit Illinois extension unchanged',identical(ids[match(prior_unchanged$source_id,ids$source_id),],prior_unchanged))
check('All nine proposed identity rows applied exactly',identical(ids[match(added$source_id,ids$source_id),],added))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Counts match reviewed dry run',sum(analysis$counted)==52409L && sum(analysis$analysis_eligible)==52277L && sum(records$counted)==57107L)
check('403 identity rows in 171 cases',nrow(ids)==403L && dplyr::n_distinct(ids$case_id)==171L && sum(changed)==9L)
check('170 complete reviews 24 exclusions 103 names',sum(analysis$review_status=='verified')==170L && sum(analysis$category_decision=='not_museum')==24L && nrow(overrides)==103L)
check('33 source-conflict holds preserved',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==33L && all(!records$counted[records$exclusion_reason%in%'reviewed_source_conflict']))
canon_keys <- added$source_id[added$role=='canonical']
check('Four reconciled cases each count one representative',length(canon_keys)==4L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
sel <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
sa <- analysis[analysis$source_id%in%sel,]
check('18 factual decisions give four complete and fourteen pending',nrow(sa)==18L && sum(sa$review_status=='verified')==4L && sum(sa$review_status=='pending')==14L)
chain_keys <- c('511d6c9e-0b9b-48ae-9411-50c5d1a9a999','cc2a936a-b634-4b3b-a818-7ee5859ab8f2','8401800453','020cc712-f2e4-47a4-aa1e-8d83179974b6')
chain <- analysis[analysis$source_id%in%chain_keys,]
check('Four sourced affiliations with three still pending',nrow(chain)==4L && all(chain$is_franchise) && sum(chain$review_status=='pending')==3L)
ma <- analysis[analysis$source_id%in%c('8409400650','3b0a337a-1535-4a1a-a9b9-cc80ced83338'),]
check('Massachusetts conflicting identifiers remain separate pending',nrow(ma)==2L && dplyr::n_distinct(ma$entity_id)==2L && all(ma$review_status=='pending'))
old_decisions <- dn_read_museum_review(file.path(p,'museum_decisions_before.csv'),dn_schema_museum_decisions())
replace_keys <- unlist(spec$replace_decision_keys)
old_keep <- old_decisions[!old_decisions$source_id%in%replace_keys,]
check('Only seven explicitly listed prior factual decisions updated',length(replace_keys)==7L && identical(decisions[match(old_keep$source_id,decisions$source_id),],old_keep))
expected_decisions <- dn_read_museum_review(file.path(p,'proposed_new_decisions.csv'),dn_schema_museum_decisions())
check('All proposed factual decisions applied exactly',identical(decisions[match(expected_decisions$source_id,decisions$source_id),],expected_decisions))
old_names <- dn_read_museum_review(file.path(p,'museum_name_overrides_before.csv'),dn_schema_museum_name_overrides())
check('All prior preferred names preserved',identical(overrides[match(old_names$source_id,overrides$source_id),],old_names))
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
check('Fourteen incomplete reviews remain explicitly pending',nrow(followup)==14L)
readr::write_csv(followup,file.path(p,'follow_up.csv'),na='')
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
