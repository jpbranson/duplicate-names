# Refresh the local draft only after build_validate.R passes.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p <- 'data/validation/museum_next_leaders_2026-09-26'
checks <- readr::read_csv(file.path(p,'integrity_checks.csv'),show_col_types=FALSE)
stopifnot(nrow(checks)==19L,all(checks$passed))
a <- targets::tar_read(museum_analysis)
r <- targets::tar_read(museum_records)
rank <- dn_museum_ranking(a)
bundle <- 'posts/duplicate-museum-names'
selected <- unique(c(head(rank$name_expanded,20), 'franklin county historical society','greene county historical society',
  'jackson county historical society','old jail museum','smithsonian institution','museum of illusions',
  'wayne county historical society','international cryptozoology museum','pea river museum'))
gates <- dplyr::bind_rows(lapply(selected,function(n) {
  reason <- tryCatch({dn_assert_museum_publication_ready(a,n);''},error=conditionMessage)
  tibble::tibble(name_expanded=n,gate_passed=!nzchar(reason),reason=reason)
}))
dn_assert_museum_publication_ready(a,'international cryptozoology museum')
readr::write_csv(a[a$analysis_eligible & a$name_expanded=='international cryptozoology museum',],file.path(bundle,'payload/seed_institution.csv'),na='')
groups <- c('Franklin County Historical Society','Greene County Historical Society','Jackson County Historical Society',
  'Old Jail Museum','Wayne County Historical Society','Depot Museum')
current <- vapply(tolower(groups),function(n)sum(a$analysis_eligible & a$name_expanded==n & !a$is_franchise%in%TRUE),integer(1))
stopifnot(identical(unname(current),c(6L,6L,6L,8L,1L,0L)))
changes <- tibble::tibble(group=rep(groups,each=2),checkpoint=rep(c('Before review','Current provisional'),length(groups)),
  count=as.integer(rbind(c(11L,11L,11L,11L,10L,10L),current)),status='provisional; national review incomplete')
blockers <- readr::read_csv('data/validation/museum_publication_2026-09-26/publication_blockers.csv',show_col_types=FALSE)
blockers <- dplyr::bind_rows(blockers,tibble::tibble(step='Depot and Wayne follow-up',status='incomplete',
  remaining_work='Remaining affiliation/address cases and Tennessee society identity; newly exposed nine-member leading groups require factual review',
  evidence='museum_next_leaders_2026-09-26/follow_up.csv and ranking_after.csv'))
counts <- tibble::tibble(original_source_rows=nrow(r),counted_source_rows=sum(r$counted),
  provisional_institutions=sum(a$counted),eligible_l2=sum(a$analysis_eligible),complete_factual_reviews=sum(a$review_status=='verified'),national_winner_certified=FALSE)
for(pair in list(c('gates','publication_gates.csv'),c('changes','review_count_changes.csv'),c('blockers','publication_blockers.csv'),c('counts','checkpoint.csv'))) {
  readr::write_csv(get(pair[1]),file.path(bundle,'payload',pair[2]),na='')
  readr::write_csv(get(pair[1]),file.path(p,paste0('publication_',pair[2])),na='')
}
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
message('Local draft payloads refreshed. M1/M2 and deployment remain incomplete.')
