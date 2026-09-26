# Factual correction batch. First run without arguments to inspect proposed outputs;
# run once with --apply only after reviewing those outputs. No human labels created.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p <- 'data/validation/museum_m2_leaders_2026-09-26'
stopifnot(!file.exists(file.path(p,'applied.json')))
baseline <- targets::tar_read(entities)
ids <- dn_read_museum_review('data/validation/museum_identity_decisions.csv',dn_schema_museum_identity_decisions())
decisions <- dn_read_museum_review('data/validation/museum_decisions.csv',dn_schema_museum_decisions())
overrides <- dn_read_museum_review('data/validation/museum_name_overrides.csv',dn_schema_museum_name_overrides())
for(n in c('museum_identity_decisions','museum_decisions','museum_name_overrides')) {
 live <- readBin(file.path('data/validation',paste0(n,'.csv')),'raw',n=file.size(file.path('data/validation',paste0(n,'.csv'))))
 old <- readBin(file.path(p,paste0(n,'_before.csv')),'raw',n=file.size(file.path(p,paste0(n,'_before.csv'))))
 stopifnot(identical(live,old))
}
spec <- jsonlite::fromJSON(file.path(p,'decisions_spec.json'),simplifyVector=FALSE)
e <- spec$evidence
identity <- function(case,keys,roles,groups,case_id) {
 x <- baseline[match(keys,baseline$source_id),]
 stopifnot(!anyNA(x$source_id),length(roles)==nrow(x))
 tibble::tibble(case_id=case_id,source=x$source,source_id=x$source_id,expected_name=x$name_raw,
 expected_entity_id=x$entity_id,expected_coordinates=dn_identity_coordinates(x),role=roles,site_group=groups,
 evidence_url=e[[case]]$url,evidence_note=e[[case]]$note,reviewed_by='Codex source review',reviewed_on='2026-09-26')
}
added <- dplyr::bind_rows(lapply(spec$identities,function(s)identity(s$case,unlist(s$keys),unlist(s$roles),unlist(s$groups),s$case_id)))
replaced_cases <- unlist(spec$replace_identity_cases)
stopifnot(all(replaced_cases%in%ids$case_id))
old_replaced <- ids[ids$case_id%in%replaced_cases,]
stopifnot(all(old_replaced$source_id%in%added$source_id))
ids <- dplyr::bind_rows(ids[!ids$case_id%in%replaced_cases,],added)
review <- dn_reconcile_museums(baseline,ids)
decision <- function(key,case,aff='unknown',status='pending',chain=NA_character_,category='not_flagged') {
 x<-baseline[match(key,baseline$source_id),];stopifnot(!is.na(x$source_id))
 tibble::tibble(source=x$source,source_id=key,expected_name=x$name_raw,category_decision=category,affiliation_status=aff,
 chain_id=chain,review_status=status,evidence_url=e[[case]]$url,note=e[[case]]$note,reviewed_by='Codex source review',reviewed_on='2026-09-26')
}
new_decisions <- dplyr::bind_rows(lapply(spec$decisions,function(s)decision(s$key,s$case,s$aff,s$status,if(is.null(s$chain))NA_character_ else s$chain,s$category)))
replace_keys <- unlist(spec$replace_decision_keys)
stopifnot(setequal(intersect(new_decisions$source_id,decisions$source_id),replace_keys))
retired <- unlist(spec$retire_decision_keys)
stopifnot(all(retired%in%decisions$source_id),all(retired%in%added$source_id),all(!review$records$counted[match(retired,review$records$source_id)]),!any(retired%in%new_decisions$source_id))
decisions <- dplyr::bind_rows(decisions[!decisions$source_id%in%c(replace_keys,retired),],new_decisions)
preferred <- function(key,case,name) {
 x<-review$records[match(key,review$records$source_id),];stopifnot(!is.na(x$source_id),x$counted)
 tibble::tibble(source=x$source,source_id=key,expected_name=x$name_raw,expected_entity_id=x$entity_id,preferred_name=name,
 evidence_url=e[[case]]$url,evidence_note=e[[case]]$note,reviewed_by='Codex source review',reviewed_on='2026-09-26')
}
new_overrides <- dplyr::bind_rows(lapply(spec$names,function(s)preferred(s$key,s$case,s$name)))
overrides <- dplyr::bind_rows(overrides,new_overrides)
after <- dn_museum_analysis(review$records,targets::tar_read(museum_chain_rules),decisions,overrides,targets::tar_read(gazetteer))
protected<-readr::read_csv(file.path(p,'protected_files.csv'),show_col_types=FALSE)
stopifnot(identical(unname(vapply(protected$path,digest::digest,character(1),algo='sha256',file=TRUE)),protected$sha256))
summary <- tibble::tibble(source_rows=nrow(review$records),counted_rows=sum(review$records$counted),institutions=sum(after$counted),eligible=sum(after$analysis_eligible),identity_rows=nrow(ids),identity_cases=dplyr::n_distinct(ids$case_id),complete_reviews=sum(after$review_status=='verified'),not_museum=sum(after$category_decision=='not_museum'),overrides=nrow(overrides))
print(summary,width=Inf)
print(dn_museum_ranking(after)[1:12,],width=Inf)
stopifnot(nrow(added)==sum(vapply(spec$identities,function(s)length(s$keys),integer(1))),nrow(new_decisions)==length(spec$decisions),nrow(new_overrides)==length(spec$names),summary$source_rows==60002L)
for(n in c('added','new_decisions','new_overrides','after','ids','decisions','overrides','summary'))
 readr::write_csv(get(n),file.path(p,paste0('proposed_',n,'.csv')),na='')
readr::write_csv(review$audit,file.path(p,'proposed_identity_audit.csv'),na='')
if('--apply'%in%commandArgs(trailingOnly=TRUE)){
 stopifnot(file.exists(file.path(p,'expected_counts.csv')))
 expected <- readr::read_csv(file.path(p,'expected_counts.csv'),show_col_types=FALSE)
 stopifnot(identical(names(summary),names(expected)),isTRUE(all.equal(summary,expected,check.attributes=FALSE)))
 readr::write_csv(ids,'data/validation/museum_identity_decisions.csv',na='')
 readr::write_csv(decisions,'data/validation/museum_decisions.csv',na='')
 readr::write_csv(overrides,'data/validation/museum_name_overrides.csv',na='')
 jsonlite::write_json(list(applied_utc=format(Sys.time(),tz='UTC',usetz=TRUE),summary=summary,cloud_cost_usd=0),file.path(p,'applied.json'),pretty=TRUE,auto_unbox=TRUE)
 message('Factual decisions applied. Pipeline exports still require selective rebuild.')
}else message('Dry run passed; no live decision inputs changed.')
