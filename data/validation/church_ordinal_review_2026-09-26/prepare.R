# One-time source/analysis snapshot. Never rerun after changes.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p<-'data/validation/church_ordinal_review_2026-09-26'
stopifnot(!file.exists(file.path(p,'protected_files.csv')))
protected<-list.files('data/validation',recursive=TRUE,full.names=TRUE)
mutable<-c(file.path('data/validation',paste0(c('museum_identity_decisions','museum_decisions','museum_name_overrides','museum_chain_rules','church_name_overrides'),'.csv')),'data/validation/README.md')
protected<-c(protected[!startsWith(protected,p)&!protected%in%mutable], 'data/processed/resolution_labelling.csv')
readr::write_csv(tibble::tibble(path=protected,sha256=vapply(protected,digest::digest,character(1),algo='sha256',file=TRUE)),file.path(p,'protected_files.csv'))
for(f in c('R/church_normalize.R','R/church_names.R','R/church_analysis.R','tests/testthat/test-church-normalize.R','data/validation/church_name_overrides.csv'))
 if(file.exists(f))stopifnot(file.copy(f,file.path(p,paste0(basename(f),'.before'))))
store<-'_targets_churches'
a<-targets::tar_read(church_named_analysis,store=store)
r<-targets::tar_read(church_records,store=store)
stopifnot(nrow(a)==540778L,sum(a$analysis_eligible)==442834L)
saveRDS(a,'data/processed/church_ordinal_analysis_before.rds')
selected<-a[a$analysis_eligible & (a$ordinal%in%10:200 | grepl('(^| )(seventh|eighth) day ',a$name_expanded)),]
readr::write_csv(selected,file.path(p,'candidates_before.csv'),na='')
rr<-r[r$entity_id%in%selected$entity_id,]
readr::write_csv(rr,file.path(p,'related_records.csv'),na='')
context<-tibble::as_tibble(arrow::read_parquet('data/raw/overture_worship_2026-08-19.0_context.parquet'))
context<-context[context$id%in%rr$source_id,]
for(n in names(context))if(is.list(context[[n]]))context[[n]]<-vapply(context[[n]],function(z)jsonlite::toJSON(z,auto_unbox=TRUE,na='null'),character(1))
readr::write_csv(context,file.path(p,'overture_context.csv'),na='')
hash_targets<-c('church_records','church_pairs','church_raw','church_normalized')
readr::write_csv(tibble::tibble(target=hash_targets,sha256=vapply(hash_targets,function(n)digest::digest(targets::tar_read_raw(n,store=store),algo='sha256'),character(1))),file.path(p,'targets_before.csv'))
for(n in c('ordinal_ladders','high_ordinal_review','naming_style_profile','territory_summary','publication_gates'))
 stopifnot(file.copy(file.path('data/processed/church_review',paste0(n,'.csv')),file.path(p,paste0(n,'_before.csv'))))
message(nrow(selected),' candidates; ',nrow(rr),' source rows; ',length(protected),' prior files preserved.')
