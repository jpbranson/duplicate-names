for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p <- 'data/validation/museum_jefferson_lincoln_2026-09-26'
b <- targets::tar_read(entities)
key <- '73ea2bcc-faca-4b28-a784-328b816b98f5'
x <- b[b$entity_id==b$entity_id[match(key,b$source_id)],]
readr::write_csv(x,file.path(p,'hedlund_baseline_records.csv'),na='')
path <- 'data/raw/overture_jefferson_lincoln_hedlund_context_2026-09-26.csv'
sql <- sprintf("SELECT id AS source_id,names.primary AS name_raw,CAST(addresses AS VARCHAR) AS addresses,CAST(websites AS VARCHAR) AS websites,CAST(phones AS VARCHAR) AS phones FROM read_parquet('%s') WHERE bbox.xmin BETWEEN -105 AND -102 AND bbox.ymin BETWEEN 38 AND 41 AND id='%s'",dn_overture_path(),key)
if(!file.exists(path)){
 con<-dn_duckdb();r<-DBI::dbGetQuery(con,sql);DBI::dbDisconnect(con)
 stopifnot(nrow(r)==1L,r$source_id==key)
 readr::write_csv(r,path,na='')
 dn_record_query(label='overture_jefferson_lincoln_hedlund_context',source='overture',detail=list(release=DN_OVERTURE_RELEASE,sql=sql),path=path,n_rows=1L)
}
stopifnot(file.copy(path,file.path(p,'hedlund_overture_context.csv'),overwrite=FALSE))
