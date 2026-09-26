# Local impact analysis only. Does not write live code or targets.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p<-'data/validation/church_ordinal_review_2026-09-26'
store<-'_targets_churches'
old<-targets::tar_read(church_normalized,store=store)
np<-targets::tar_read(church_pairs,store=store)
records<-targets::tar_read(church_records,store=store)
original<-readLines('R/church_normalize.R',warn=FALSE)
candidate<-gsub("'section','hour')","'section','hour','day')",original,fixed=TRUE)
stopifnot(sum(original!=candidate)==1L)
writeLines(candidate,file.path(p,'church_normalize_proposed.R'))
source(file.path(p,'church_normalize_proposed.R'))
new<-old
new$ordinal<-dn_church_parse_ordinal(new$name_core)
new$name_style<-dn_church_name_style(new$name_expanded,new$name_core,new$ordinal)
changed<-which(!dplyr::coalesce(new$ordinal==old$ordinal,is.na(new$ordinal)&is.na(old$ordinal)))
rows<-new[changed,c('source','source_id','name_raw','name_core','ordinal','name_style')]
rows$ordinal_before<-old$ordinal[changed];rows$style_before<-old$name_style[changed]
readr::write_csv(rows,file.path(p,'parser_impact_records.csv'),na='')
a<-np$row_a;b<-np$row_b
np$ordinal_conflict<-!is.na(new$ordinal[a])&!is.na(new$ordinal[b])&new$ordinal[a]!=new$ordinal[b]
np$would_merge<-np$similarity>=DN_NAME_SIM_MIN & !np$ordinal_conflict & !np$denom_conflict &
 !is.na(new$name_expanded[b]) & nzchar(new$name_expanded[b])
oldp<-targets::tar_read(church_pairs,store=store)
pair_changes<-which(np$would_merge!=oldp$would_merge | np$ordinal_conflict!=oldp$ordinal_conflict)
pc<-np[pair_changes,];pc$merge_before<-oldp$would_merge[pair_changes]
pc$name_a<-new$name_raw[pc$row_a];pc$name_b<-new$name_raw[pc$row_b]
readr::write_csv(pc,file.path(p,'parser_impact_pairs.csv'),na='')
after<-dn_resolve_churches(new,np)
j<-match(paste(records$source,records$source_id),paste(after$source,after$source_id))
stopifnot(!anyNA(j))
membership<-records$entity_id!=after$entity_id[j] | records$counted!=after$counted[j]
readr::write_csv(records[membership,],file.path(p,'parser_impact_membership.csv'),na='')
summary<-list(source_rows=nrow(new),parser_changes=length(changed),pair_changes=length(pair_changes),
 merge_changes=sum(np$would_merge!=oldp$would_merge),membership_changes=sum(membership),
 raw_fields_unchanged=identical(new[,names(dn_schema_raw())],old[,names(dn_schema_raw())]),
 threshold=DN_NAME_SIM_MIN,status='dry_run_only')
jsonlite::write_json(summary,file.path(p,'parser_impact.json'),pretty=TRUE,auto_unbox=TRUE)
print(summary)
