for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p<-'data/validation/museum_clinton_madison_monroe_2026-09-26'
related<-readr::read_csv(file.path(p,'related_baseline_records.csv'),show_col_types=FALSE)
ids<-related$source_id[related$source=='overture']
sql<-sprintf("SELECT id AS source_id,names.primary AS name_raw,CAST(addresses AS VARCHAR) AS addresses,
  CAST(websites AS VARCHAR) AS websites,CAST(phones AS VARCHAR) AS phones,CAST(sources AS VARCHAR) AS sources
  FROM read_parquet('%s') WHERE bbox.xmin BETWEEN -180 AND -65 AND bbox.ymin BETWEEN 17 AND 72
  AND id IN (%s)",dn_overture_path(),paste(sprintf("'%s'",ids),collapse=','))
path<-'data/raw/overture_clinton_madison_monroe_context_2026-09-26.csv'
if(!file.exists(path)){
  con<-dn_duckdb();context<-DBI::dbGetQuery(con,sql);DBI::dbDisconnect(con)
  stopifnot(setequal(context$source_id,ids));readr::write_csv(context,path,na='')
  dn_record_query(label='overture_clinton_madison_monroe_context',source='overture',
    detail=list(release=DN_OVERTURE_RELEASE,source_ids=ids,sql=sql),path=path,n_rows=nrow(context))
}
if(!file.exists(file.path(p,'overture_context.csv')))stopifnot(file.copy(path,file.path(p,'overture_context.csv')))
message(length(ids),' context rows available')
