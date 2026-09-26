# Bounded follow-up discovery only; no additional decisions or identity changes.
p<-'data/validation/church_ordinal_review_2026-09-26'
a<-targets::tar_read(church_named_analysis,store='_targets_churches')
take<-grepl('tabernacle beth el|church of god and saints of christ',a$name_expanded,ignore.case=TRUE)
context<-tibble::as_tibble(arrow::read_parquet('data/raw/overture_worship_2026-08-19.0_context.parquet'))
sites<-vapply(context$websites,function(z)paste(z,collapse=' | '),character(1))
linked<-context$id[grepl('cogasoc[.]org',sites,ignore.case=TRUE)]
take<-take|a$source_id%in%linked
queue<-a[take,]
readr::write_csv(queue,file.path(p,'cogasoc_followup.csv'),na='')
ctx<-context[context$id%in%queue$source_id,]
for(n in names(ctx))if(is.list(ctx[[n]]))ctx[[n]]<-vapply(ctx[[n]],function(z)jsonlite::toJSON(z,auto_unbox=TRUE,na='null'),character(1))
readr::write_csv(ctx,file.path(p,'cogasoc_followup_context.csv'),na='')
message(nrow(queue),' candidate descriptions, ',sum(queue$analysis_eligible),' eligible; investigate exact directory linkage before further scope decisions.')
