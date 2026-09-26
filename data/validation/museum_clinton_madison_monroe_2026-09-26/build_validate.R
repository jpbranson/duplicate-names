# Refresh only museum review/export targets; never rebuild the labelling sheet.
p <- 'data/validation/museum_clinton_madison_monroe_2026-09-26'
if(!'--verify-only'%in%commandArgs(trailingOnly=TRUE)){
  targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
    museum_records_file, dup_museums, multisite_review, entities_file))
  source('tests/testthat.R')
}
for (f in list.files('R', pattern = '[.]R$', full.names = TRUE)) source(f)
before <- readRDS('data/processed/museum_clinton_madison_monroe_before.rds')
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
check('861 earlier evidence files and human labels preserved', nrow(protected) == 861L && identical(unname(actual), protected$sha256))
old_ids <- readr::read_csv(file.path(p, 'identity_decisions_before.csv'), show_col_types = FALSE)
new_keys <- setdiff(ids$source_id, old_ids$source_id)
changed <- records$source_id %in% new_keys
check('Identity rows outside the new cases unchanged', identical(records[!changed, ], before$records[!changed, ]))
check('Threshold remains 0.85', identical(DN_NAME_SIM_MIN, 0.85))
check('Current counts match reviewed dry run',sum(analysis$counted)==52493L && sum(analysis$analysis_eligible)==52361L && sum(records$counted)==57202L)
check('243 identity rows in 98 cases',nrow(ids)==243L && dplyr::n_distinct(ids$case_id)==98L)
check('101 complete reviews and 18 not-museum decisions',sum(analysis$review_status=='verified')==101L && sum(analysis$category_decision=='not_museum')==18L)
check('Bare Clinton zero, Madison zero, Monroe three non-chain candidates',all(vapply(c('clinton county historical society','madison county historical society','monroe county historical society'),function(n)sum(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded==n),integer(1))==c(0L,0L,3L)))
conflict_keys <- c('8401700996','8402601015','8403900180','8403900507','8401900205','8403600173','8401300059','d51232cf-1765-45e2-abc8-82e16ef0f6ac')
conflicts <- records[records$source_id%in%conflict_keys,]
check('Eight new conflicts isolated; nineteen total; no aliases',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==19L && nrow(conflicts)==8L && !any(conflicts$counted) && dplyr::n_distinct(conflicts$entity_id)==8L && all(!nzchar(dplyr::coalesce(conflicts$alt_names,''))))
parent <- analysis[analysis$source_id=='8405100703',]
check('Virginia clean parent remains pending separately from Madison Museum',nrow(parent)==1L && parent$counted && parent$review_status=='pending' && parent$affiliation_status=='chain' && parent$entity_id!=analysis$entity_id[match('b758f752-a896-47f0-b99b-79383393538e',analysis$source_id)])
exclusions <- analysis[analysis$source_id%in%c('8402100133','ff252148-2b3e-4774-b482-eb4c429e9a62'),]
check('Kentucky society and Ohio office excluded on affirmative roles',nrow(exclusions)==2L && all(exclusions$category_decision=='not_museum') && all(!exclusions$counted) && all(exclusions$review_status=='verified'))
pending <- analysis[analysis$source_id%in%c('8404700484','8405500216','8402900602','8401900392'),]
check('Unresolved Tennessee Wisconsin Missouri and Iowa remain pending counted unknown',nrow(pending)==4L && all(pending$counted) && all(pending$review_status=='pending') && all(pending$affiliation_status=='unknown'))
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
stopifnot(nrow(followup)==15L, nrow(dispositions)==27L, !anyNA(dispositions$reviewed_entity_id))
stopifnot(file.copy('data/processed/museum_review/identity_audit.csv',file.path(p,'identity_audit_after.csv'),overwrite=TRUE))
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(tibble::tibble(source_rows=nrow(records),counted_source_rows=sum(records$counted),counted_institutions=sum(analysis$counted),eligible=sum(analysis$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(analysis$review_status=='verified'),pending_in_this_followup=nrow(followup)),file.path(p,'counts.csv'))
message(length(checks),' integrity checks passed; ',nrow(protected),' earlier files unchanged.')
