for (f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
p <- 'data/validation/church_phase1_2026-09-26'
regions <- list(bangor=c(44.70,-68.88,44.88,-68.68),atlanta=c(33.65,-84.50,33.85,-84.30),
  detroit=c(42.25,-83.25,42.48,-82.95),new_york=c(40.60,-74.05,40.85,-73.85),
  seattle=c(47.50,-122.40,47.72,-122.25),san_francisco=c(37.70,-122.53,37.82,-122.35),
  honolulu=c(21.25,-157.95,21.40,-157.75),anchorage=c(61.08,-150.05,61.25,-149.70))
rows<-list();status<-list()
for (region in names(regions)) {
  message('[OSM bounded sample] ',region)
  tryCatch({
    x<-src_osm(regions[[region]],paste0(region,'_20260926'))
    rows[[region]]<-x
    status[[region]]<-tibble::tibble(region=region,status='downloaded',n=nrow(x),error=NA_character_)
  },error=function(e) {status[[region]]<<-tibble::tibble(region=region,status='failed',n=NA_integer_,error=conditionMessage(e))})
  readr::write_csv(dplyr::bind_rows(status),file.path(p,'osm_status.csv'))
}
x<-dplyr::bind_rows(rows)
if(nrow(x)) arrow::write_parquet(x,'data/raw/osm_validation_regions_20260926.parquet')
readr::write_csv(tibble::tibble(region=names(regions),bbox=vapply(regions,paste,collapse=',',character(1))),file.path(p,'osm_sample_regions.csv'))
