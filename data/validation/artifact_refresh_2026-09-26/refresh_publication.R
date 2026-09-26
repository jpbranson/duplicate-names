# Refresh the local draft only after build_validate.R passes.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p <- 'data/validation/artifact_refresh_2026-09-26'
checks <- readr::read_csv('data/validation/museum_m2_leaders_2026-09-26/integrity_checks.csv',show_col_types=FALSE)
stopifnot(nrow(checks)==27L,all(checks$passed))
a <- targets::tar_read(museum_analysis)
r <- targets::tar_read(museum_records)
rank <- dn_museum_ranking(a)
bundle <- 'posts/duplicate-museum-names'
m2 <- readr::read_csv('data/validation/museum_m2_leaders_2026-09-26/scope_word_review.csv',show_col_types=FALSE)
selected <- unique(c(m2$name_expanded,head(rank$name_expanded,20), 'franklin county historical society','greene county historical society',
  'jackson county historical society','old jail museum','smithsonian institution','museum of illusions',
  'wayne county historical society','international cryptozoology museum','pea river museum',
  'adams county historical society','brown county historical society',
  "children's discovery museum",'pioneer village','veterans memorial museum','carroll county historical society','clinton county historical society','madison county historical society','monroe county historical society'))
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
blockers <- tibble::tribble(
 ~step,~status,~remaining_work,~evidence,
 'M1 leaders','incomplete','Old Jail has four pending factual reviews; new six-count groups remain unreviewed. No national winner certified.','current_ranking.csv',
 'Old Jail evidence','human_review_needed','Hayesville current operator/name; Winchester governance; Thompson Falls governance/address; Greenwood campus scope.','museum_jail_followup_2026-09-26/human_review.csv',
 'M2 identities and meanings','incomplete','Twelve leading groups have semantic review; 28 related actions remain. Other scope-word groups are unreviewed.','museum_m2_leaders_2026-09-26/scope_word_review.csv',
 'Reviewed unresolved cases','incomplete','Use current pending decisions; older action lists may have been superseded.','current_review_followup.csv',
 'Visitor locations/access','incomplete','Three sourced points and dated access checks exist; these do not certify all selected institutions or reopen Mandeville.','museum_publication_2026-09-26/publication_points.csv',
 'Publication destination','configuration_needed','DUPNAMES_BLOG_DIR unset and ../blog absent; no destination supplied.','R/config_blog.R',
 'Church evaluation','human_labels_needed','Independent v2 has 300 matching and 500 style items awaiting labels; factual leader/ordinal checks remain.','church_phase1_2026-09-26/independent_review_v2',
 'Explorer CSV saving','unverified','Data/export checks pass; actual filesystem saving from browser remains unverified.','artifact_QA.md')
readr::write_csv(rank,file.path(p,'current_ranking.csv'),na='')
pending <- dplyr::filter(a,.data$review_status!='verified',!is.na(.data$review_evidence))
readr::write_csv(pending,file.path(p,'current_review_followup.csv'),na='')
readr::write_csv(a[a$analysis_eligible & a$review_status!='verified' & is.na(a$review_evidence),],file.path(p,'unreviewed_institutions.csv'),na='')
stopifnot(file.copy('data/processed/museum_review/singularity_candidates.csv',file.path(p,'m2_candidates.csv')))
recent_groups <- c('Adams County Historical Society','Brown County Historical Society',
  "Children's Discovery Museum",'Pioneer Village','Veterans Memorial Museum','Carroll County Historical Society','Clinton County Historical Society','Madison County Historical Society','Monroe County Historical Society')
recent_current <- vapply(tolower(recent_groups),function(n)sum(a$analysis_eligible & a$name_expanded==n & !a$is_franchise%in%TRUE),integer(1))
stopifnot(identical(unname(recent_current),c(2L,1L,4L,4L,3L,1L,0L,0L,3L)))
recent <- tibble::tibble(group=recent_groups,before=9L,current=recent_current)
readr::write_csv(recent,file.path(bundle,'payload/recent_review_counts.csv'))
readr::write_csv(recent,file.path(p,'publication_recent_review_counts.csv'))
counts <- tibble::tibble(original_source_rows=nrow(r),counted_source_rows=sum(r$counted),
  provisional_institutions=sum(a$counted),eligible_l2=sum(a$analysis_eligible),complete_factual_reviews=sum(a$review_status=='verified'),national_winner_certified=FALSE)
for(pair in list(c('gates','publication_gates.csv'),c('changes','review_count_changes.csv'),c('blockers','publication_blockers.csv'),c('counts','checkpoint.csv'))) {
  readr::write_csv(get(pair[1]),file.path(bundle,'payload',pair[2]),na='')
  readr::write_csv(get(pair[1]),file.path(p,paste0('publication_',pair[2])),na='')
}
stopifnot(file.copy('data/raw/MANIFEST.json',file.path(p,'manifest_after.json'),overwrite=TRUE))
readr::write_csv(m2,file.path(bundle,'payload/scope_word_review.csv'),na='')
message('Local draft payloads refreshed. M1/M2 and deployment remain incomplete.')
