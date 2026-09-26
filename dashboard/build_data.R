# Static, compressed, name-bucketed payloads. No hosted queries or raw OSM data.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
library(dplyr)
dir.create('dashboard/data',recursive=TRUE,showWarnings=FALSE)
destination <- 'dashboard/data'
evidence <- Sys.getenv('DUPNAMES_DASHBOARD_EVIDENCE', 'data/processed/dashboard_validation')
dir.create(evidence, recursive = TRUE, showWarnings = FALSE)
write_gz <- function(x,path,dataframe='rows') {
  con<-gzfile(path,'wt',compression=9);on.exit(close(con))
  text<-jsonlite::toJSON(x,auto_unbox=TRUE,na='null',null='null',dataframe=dataframe,digits=9)
  writeLines(text,con,useBytes=TRUE)
}
fields<-c('entity_id','primary_name','name_expanded','name_core','lon','lat','alt_names',
  'analysis_eligible','review_status','affiliation','source','source_id','analysis_exclusion','denom_norm','ordinal')
collection<-function(x,key) {
  stopifnot(!anyDuplicated(x$entity_id))
  # Source coordinates remain unchanged. Invalid locations are recorded separately
  # rather than making up a map point; current inputs should have none.
  invalid<-!is.finite(x$lon)|!is.finite(x$lat)|abs(x$lon)>180|abs(x$lat)>90
  if(any(invalid)) readr::write_csv(x[invalid,],file.path(destination,paste0(key,'-unmapped.csv')))
  x<-x[!invalid,]
  x$affiliation<-ifelse(is.na(x$is_franchise),'unknown',ifelse(x$is_franchise,'affiliated','independent'))
  for(field in c('alt_names','analysis_exclusion','denom_norm'))if(!field %in% names(x))x[[field]]<-NA_character_
  if(!'review_status' %in% names(x))x$review_status<-'pending'
  x$review_status[is.na(x$review_status)|!nzchar(x$review_status)]<-'pending'
  x$analysis_eligible<-x$analysis_eligible %in% TRUE & x$counted %in% TRUE
  x<-as.data.frame(x[,fields])
  for(field in c('name_expanded','name_core'))x[[field]][is.na(x[[field]])|!nzchar(x[[field]])]<-paste0('[empty ',if(field=='name_expanded')'L2' else 'L3',' name]')
  for(level in c(l2='name_expanded',l3='name_core')) {
    label<-if(level=='name_expanded')'l2' else 'l3'
    groups<-x |>
      group_by(name=.data[[level]]) |>
      summarise(nonchain=sum(.data$analysis_eligible & .data$affiliation!='affiliated'),
        eligible=sum(.data$analysis_eligible),affiliated=sum(.data$analysis_eligible & .data$affiliation=='affiliated'),
        total=n(),.groups='drop')
    groups$bucket<-substr(vapply(groups$name,digest::digest,character(1),algo='xxhash32',serialize=FALSE),1,2)
    groups<-groups[,c('name','bucket','nonchain','eligible','affiliated','total')]
    stopifnot(sum(groups$total)==nrow(x),sum(groups$eligible)==sum(x$analysis_eligible))
    write_gz(groups,file.path(destination,paste0(key,'-',label,'-index.json.gz')),dataframe='values')
    buckets<-groups$bucket[match(x[[level]],groups$name)]
    for(b in unique(buckets))write_gz(x[buckets==b,],file.path(destination,paste0(key,'-',label,'-',b,'.json.gz')),dataframe='values')
    message(key,' ',label,': ',nrow(groups),' name groups; ',nrow(x),' records')
  }
  list(records=nrow(x),eligible=sum(x$analysis_eligible),unmapped=sum(invalid),
    aliases=sum(!is.na(x$alt_names)&nzchar(x$alt_names)),verified=sum(x$review_status=='verified'))
}
museum<-targets::tar_read(museum_analysis)
church<-targets::tar_read(church_named_analysis,store='_targets_churches')
stopifnot(all(church$source=='overture'))
summary<-list(museums=collection(museum,'museums'),churches=collection(church,'churches'))
states<-targets::tar_read(church_states,store='_targets_churches')
display<-sf::st_simplify(states,dTolerance=2500,preserveTopology=TRUE)
geo<-geojsonsf::sf_geojson(display[,c('STATEFP','NAME')])
con<-gzfile(file.path(destination,'states.geojson.gz'),'wt',compression=9)
writeLines(geo,con,useBytes=TRUE);close(con)
manifest<-list(schema_version=1L,built_utc=format(Sys.time(),tz='UTC',usetz=TRUE),
  overture_release=DN_OVERTURE_RELEASE,cloud_cost_usd=0,publication_ready=FALSE,fields=fields,
  collections=summary,maplibre_version='5.24.0',mapgl_package_version=as.character(packageVersion('mapgl')),
  osm_data_included=FALSE,remote_tiles=FALSE)
jsonlite::write_json(manifest,file.path(destination,'manifest.json'),auto_unbox=TRUE,pretty=TRUE)
jsonlite::write_json(manifest,file.path(evidence,'data_build.json'),auto_unbox=TRUE,pretty=TRUE)
files<-list.files(destination,full.names=TRUE)
hashes<-tibble::tibble(file=basename(files),bytes=file.size(files),sha256=vapply(files,digest::digest,character(1),algo='sha256',file=TRUE))
readr::write_csv(hashes,file.path(evidence,'payload_checksums.csv'))
message('Static data build complete; ',sum(hashes$bytes)/1024^2,' MiB compressed')
