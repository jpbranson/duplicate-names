for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
p<-'data/validation/church_phase1_2026-09-26'
urls<-c(avenue38='https://38thavenuebaptist.org/contact-us',twelfth_home='https://www.tbcboston.org/',
  twelfth_history='https://www.tbcboston.org/our-history',alexandria_home='https://alexandria.cogasoc.org/',
  alexandria_history='https://alexandria.cogasoc.org/history-of-the-tabernacle/')
status<-lapply(names(urls),function(id) {
  dest<-paste0('data/raw/church_ordinal_',id,'_20260926.html')
  tryCatch({dn_fetch(urls[[id]],paste0('church_ordinal_',id),dest)
    tibble::tibble(id=id,url=urls[[id]],path=dest,status='cached',error=NA_character_)},
    error=function(e) tibble::tibble(id=id,url=urls[[id]],path=dest,status='failed',error=conditionMessage(e)))
})
readr::write_csv(dplyr::bind_rows(status),file.path(p,'ordinal_source_cache.csv'))
# Supported public-name correction, not a new matching label or a verified identity.
x<-readr::read_csv(file.path(p,'early_high_ordinals.csv'),show_col_types=FALSE)
x<-x[x$name_raw=='Thirty Eighth Baptist Church',]
stopifnot(nrow(x)==2L,all(grepl('38thavenuebaptist.org',x$websites)))
x<-x |> dplyr::transmute(source,source_id,expected_name=name_raw,
  expected_coordinates=sprintf('%.7f,%.7f',lon,lat),preferred_name='38th Avenue Baptist Church',
  evidence_url='https://38thavenuebaptist.org/contact-us',
  evidence_note='Operator identifies 38th Avenue Baptist Church at 419 N 38th Avenue; both source records link its domain. The raw name omits Avenue; identity and point review remain pending.',
  reviewed_by='assistant_official_source_review',reviewed_on='2026-09-26')
path<-'data/validation/church_name_overrides.csv'
if(file.exists(path)) stop('Do not overwrite existing live church decisions')
readr::write_csv(x,path)
readr::write_csv(x,file.path(p,'church_name_overrides_initial.csv'))
