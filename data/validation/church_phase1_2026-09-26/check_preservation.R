for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
p<-'data/validation/church_phase1_2026-09-26'
old<-readRDS('data/processed/church_museum_before.rds')
checks<-c(museum_baseline=identical(old$entities,targets::tar_read(entities)),
  museum_records=identical(old$museum_records,targets::tar_read(museum_records)),
  museum_analysis=identical(old$museum_analysis,targets::tar_read(museum_analysis)),
  museum_multisite=identical(old$multisite,targets::tar_read(multisite_review)),
  threshold_unchanged=identical(DN_NAME_SIM_MIN,0.85))
f<-readr::read_csv(file.path(p,'protected_files.csv'),show_col_types=FALSE)
sha<-vapply(f$path,function(path) digest::digest(path,file=TRUE,algo='sha256'),character(1))
checks<-c(checks,protected_453=identical(unname(sha),f$sha256))
readr::write_csv(tibble::tibble(check=names(checks),passed=unname(checks)),file.path(p,'museum_preservation_checks.csv'))
stopifnot(all(checks))
cat('Museum preservation checks: ',sum(checks),' passed; ',nrow(f),' protected files unchanged\n')
urls<-c(usgs_download='https://www.usgs.gov/us-board-on-geographic-names/download-gnis-data',
  overture_taxonomy='https://docs.overturemaps.org/guides/places/taxonomy-explorer/',
  hifld_item='https://www.arcgis.com/sharing/rest/content/items/4dba295e62e64b4d9ca53bd90b35c2c7?f=json',
  hifld_original='https://services1.arcgis.com/Hp6G80Pky0om7QvQ/arcgis/rest/services/AllPlacesOfWorship/FeatureServer?f=json',
  gnis_archive_list='https://prd-tnm.s3.amazonaws.com/?list-type=2&prefix=StagedProducts/GeographicNames/Archive/&max-keys=1000',
  overture_repo_tree='https://api.github.com/repos/OvertureMaps/schema/git/trees/main?recursive=1',
  hifld_rapt_layer=paste0(DN_HIFLD_SERVICE,'?f=pjson'),
  hifld_search='https://www.arcgis.com/sharing/rest/search?q=title%3A%22All%20Places%20of%20Worship%22%20AND%20owner%3Ageoplatform&f=json&num=20')
for(id in names(urls)) {
  file<-paste0('data/raw/church_metadata_',id,'_2026-09-26.txt')
  if(file.exists(file)) dn_record_query(paste0('church_metadata_',id),'official_source_metadata',
    list(url=urls[[id]],method='Decoded-text PowerShell cache; unavailable/error responses retained as attempted evidence'),file,NA_integer_)
}
for(id in c('02934d1d566c4ce6b48887f767e3cfab','495cc33ef490462ab2d8933247a66a87')) {
  file<-paste0('data/raw/church_metadata_',id,'.json')
  dn_record_query(paste0('church_arcgis_item_',id),'arcgis_metadata',list(url=paste0('https://www.arcgis.com/sharing/rest/content/items/',id,'?f=pjson'),
    method='PowerShell JSON metadata cache; public owner and licensing fields'),file,1L)
}
file.copy(DN_MANIFEST,file.path(p,'manifest_acquisition_checkpoint.json'),overwrite=TRUE)
