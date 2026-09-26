for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
p<-'data/validation/church_phase1_2026-09-26'
status<-readr::read_csv(file.path(p,'osm_status.csv'),show_col_types=FALSE)
if(!file.exists(file.path(p,'osm_initial_status.csv'))) file.copy(file.path(p,'osm_status.csv'),file.path(p,'osm_initial_status.csv'))
regions<-list(seattle=c(47.50,-122.40,47.72,-122.25),san_francisco=c(37.70,-122.53,37.82,-122.35),honolulu=c(21.25,-157.95,21.40,-157.75))
new<-list()
for(region in names(regions)) {
  i<-match(region,status$region)
  if(status$status[i]=='downloaded') next
  message('[OSM paced retry] ',region)
  ok<-tryCatch({x<-src_osm(regions[[region]],paste0(region,'_20260926'));new[[region]]<-x;
    status$status[i]<-'downloaded';status$n[i]<-nrow(x);status$error[i]<-NA_character_;TRUE},
    error=function(e) {status$error[i]<<-conditionMessage(e);FALSE})
  readr::write_csv(status,file.path(p,'osm_status.csv'))
  if(!ok) {message('Retry failed; stop to respect service limits.');break}
  if(region!=tail(names(regions),1)) Sys.sleep(35)
}
if(length(new)) {
  old<-arrow::read_parquet('data/raw/osm_validation_regions_20260926.parquet')
  x<-dplyr::bind_rows(old,dplyr::bind_rows(new)) |> dplyr::distinct(source,source_id,.keep_all=TRUE)
  arrow::write_parquet(x,'data/raw/osm_validation_regions_20260926_v2.parquet')
  dn_record_query('osm_bounded_validation_regions','osm',list(scope='eight selected metros; internal only',license='ODbL; excluded from permissive outputs'),
    'data/raw/osm_validation_regions_20260926_v2.parquet',nrow(x))
}

