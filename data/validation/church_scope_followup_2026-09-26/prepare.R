# One-time checkpoint. Never rerun after changes.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
p <- 'data/validation/church_scope_followup_2026-09-26'
stopifnot(!file.exists(file.path(p,'protected_files.csv')))
mutable <- c(file.path('data/validation',paste0(c('museum_identity_decisions','museum_decisions','museum_name_overrides','museum_chain_rules','church_name_overrides','church_scope_decisions'),'.csv')),'data/validation/README.md')
protected <- list.files('data/validation',recursive=TRUE,full.names=TRUE)
protected <- protected[!startsWith(protected,p)&!protected%in%mutable]
readr::write_csv(tibble::tibble(path=protected,sha256=vapply(protected,digest::digest,character(1),algo='sha256',file=TRUE)),file.path(p,'protected_files.csv'))
for(f in mutable[file.exists(mutable)]) stopifnot(file.copy(f,file.path(p,paste0(basename(f),'.before'))))
store <- '_targets_churches'
a <- targets::tar_read(church_named_analysis,store=store)
r <- targets::tar_read(church_records,store=store)
stopifnot(nrow(a)==540778L,sum(a$analysis_eligible)==442832L)
saveRDS(a,'data/processed/church_scope_followup_analysis_before.rds')
selected <- readr::read_csv('data/validation/church_ordinal_review_2026-09-26/cogasoc_followup.csv',show_col_types=FALSE)
selected <- a[a$entity_id%in%selected$entity_id,]
rr <- r[r$entity_id%in%selected$entity_id,]
readr::write_csv(selected,file.path(p,'candidates_before.csv'),na='')
readr::write_csv(rr,file.path(p,'related_records.csv'),na='')
context <- tibble::as_tibble(arrow::read_parquet('data/raw/overture_worship_2026-08-19.0_context.parquet'))
context <- context[context$id%in%rr$source_id,]
for(n in names(context)) if(is.list(context[[n]])) context[[n]] <- vapply(context[[n]],function(z)jsonlite::toJSON(z,auto_unbox=TRUE,na='null'),character(1))
readr::write_csv(context,file.path(p,'overture_context.csv'),na='')
hash_targets <- c('church_raw','church_normalized','church_pairs','church_records','church_analysis')
readr::write_csv(tibble::tibble(target=hash_targets,sha256=vapply(hash_targets,function(n)digest::digest(targets::tar_read_raw(n,store=store),algo='sha256'),character(1))),file.path(p,'targets_before.csv'))
dir.create(file.path(p,'working_labels_before'))
for(n in c('matching_labels_blank','classifier_labels_blank')) stopifnot(file.copy(file.path('data/processed/church_review',paste0(n,'.csv')),file.path(p,'working_labels_before',paste0(n,'.csv'))))
message(nrow(selected),' candidates; ',nrow(rr),' members; ',length(protected),' protected files.')
