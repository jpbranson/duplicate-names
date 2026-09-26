# Selective review/export rebuild; never rebuild the completed labelling sheet.
p <- 'data/validation/museum_bedford_belmont_chatham_2026-09-26'
stopifnot(file.exists(file.path(p,'applied.json')))
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)) {
  targets::tar_make(names=c(museum_review_files,museum_identity_audit_file,
    museum_records_file,dup_museums,multisite_review,entities_file))
  source('tests/testthat.R')
}
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
before <- readRDS('data/processed/museum_bedford_belmont_chatham_before.rds')
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
check('1467 earlier evidence files and human labels preserved',nrow(protected)==1467L && identical(unname(actual),protected$sha256))
old_ids <- dn_read_museum_review(file.path(p,'identity_decisions_before.csv'),dn_schema_museum_identity_decisions())
new_keys <- setdiff(ids$source_id,old_ids$source_id)
changed <- records$source_id%in%new_keys
check('Identity rows outside new cases unchanged',identical(records[!changed,],before$records[!changed,]))
check('Prior identity decisions unchanged',identical(ids[match(old_ids$source_id,ids$source_id),],old_ids))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Counts match reviewed dry run',sum(analysis$counted)==52429L && sum(analysis$analysis_eligible)==52297L && sum(records$counted)==57129L)
check('364 identity rows in 154 cases',nrow(ids)==364L && dplyr::n_distinct(ids$case_id)==154L && length(new_keys)==13L)
check('154 complete reviews 24 exclusions 95 names',sum(analysis$review_status=='verified')==154L && sum(analysis$category_decision=='not_museum')==24L && nrow(overrides)==95L)
leaders <- c('bedford historical society','belmont historical society','chatham historical society')
group_counts <- vapply(leaders,function(n)sum(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded==n),integer(1))
print(group_counts)
check('Selected non-chain groups now three two and four',all(group_counts==c(3L,2L,4L)))
conflict <- records[records$source_id=='8403300202',]
check('New Hampshire conflict isolated with no aliases; 31 total',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==31L && nrow(conflict)==1L && !conflict$counted && !nzchar(dplyr::coalesce(conflict$alt_names,'')))
canon_keys <- ids$source_id[!ids$source_id%in%old_ids$source_id & ids$role=='canonical']
check('Six accepted identity cases each have one counted source',length(canon_keys)==6L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
ny <- analysis[analysis$source_id%in%c('8403601012','9116ffbc-43e1-4602-8761-7222cd344728'),]
check('New York museum and excluded office remain separate under shared operator',nrow(ny)==2L && dplyr::n_distinct(ny$entity_id)==2L && sum(ny$counted)==1L && all(ny$chain_id=='bedford_new_york_historical_society') && all(ny$review_status=='verified') && ny$category_decision[ny$source_id=='9116ffbc-43e1-4602-8761-7222cd344728']=='not_museum')
ca <- analysis[analysis$source_id=='3875709e-2b41-41a2-b2e5-300efca2915d',]
check('California identity resolved but affiliation remains pending',nrow(ca)==1L && ca$counted && ca$primary_name=='Belmont History Room' && ca$review_status=='pending' && ca$affiliation_status=='unknown')
ma <- analysis[analysis$source_id=='8402500663',]
check('Claflin Room retains sourced multi-museum society affiliation',nrow(ma)==1L && ma$counted && ma$primary_name=='Claflin Room' && ma$chain_id=='belmont_massachusetts_historical_society' && ma$review_status=='verified')
ct <- records[records$source_id%in%c('a6157c3a-f4d4-4d6d-bbba-d4ca7b66ddc5','8400900271'),]
ct_a <- analysis[analysis$entity_id%in%ct$entity_id,]
check('Connecticut officer mailbox reconciles with one independent campus',nrow(ct)==2L && sum(ct$counted)==1L && nrow(ct_a)==1L && ct_a$review_status=='verified' && ct_a$affiliation_status=='independent')
at <- records[records$source_id%in%c('930cf7e2-44ea-46a5-937b-e94bef330b36','8402500622'),]
at_a <- analysis[analysis$entity_id%in%at$entity_id,]
check('Atwood Museum and society description count once',nrow(at)==2L && sum(at$counted)==1L && nrow(at_a)==1L && at_a$primary_name=='Atwood Museum' && at_a$review_status=='verified')
nh <- analysis[analysis$source_id%in%c('4ff2c6ed-44f6-4c27-b766-14a5db5b0f91','49631799-c101-497b-a804-eac4fa00bada'),]
check('Unresolved Chatham New Hampshire addresses remain separate and pending',nrow(nh)==2L && all(nh$counted) && dplyr::n_distinct(nh$entity_id)==2L && all(nh$review_status=='pending'))
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
check('Eight incomplete reviews remain explicitly pending',nrow(followup)==8L)
readr::write_csv(followup,file.path(p,'follow_up.csv'),na='')
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
