# Dry run only: apply proposed scope decisions in memory. Writes nothing live.
for(f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
p <- 'data/validation/church_scope_followup_2026-09-26'
store <- '_targets_churches'
tb <- readr::read_csv(file.path(p,'targets_before.csv'),show_col_types=FALSE)
now <- vapply(tb$target,function(n)digest::digest(targets::tar_read_raw(n,store=store),algo='sha256'),character(1))
stopifnot(identical(unname(now),tb$sha256))
pf <- readr::read_csv(file.path(p,'protected_files.csv'),show_col_types=FALSE)
stopifnot(all(file.exists(pf$path)),identical(unname(vapply(pf$path,digest::digest,character(1),algo='sha256',file=TRUE)),pf$sha256))
live <- readr::read_csv('data/validation/church_scope_decisions.csv',col_types=readr::cols(.default='c'))
stopifnot(identical(tools::md5sum('data/validation/church_scope_decisions.csv')[[1]],
  tools::md5sum(file.path(p,'church_scope_decisions.csv.before'))[[1]]))
proposed <- readr::read_csv(file.path(p,'scope_decisions_proposed.csv'),col_types=readr::cols(.default='c'))
stopifnot(identical(as.data.frame(proposed[seq_len(nrow(live)),]),as.data.frame(live)))
records <- targets::tar_read(church_records,store=store)
named <- dn_apply_church_names(targets::tar_read(church_analysis,store=store),records,
  targets::tar_read(church_name_overrides,store=store),targets::tar_read(church_gazetteer,store=store))
before <- readRDS('data/processed/church_scope_followup_analysis_before.rds')
stopifnot(identical(dn_apply_church_scope(named,records,live),before))
after <- dn_apply_church_scope(named,records,proposed)
keep <- setdiff(names(before),c('analysis_eligible','analysis_exclusion','scope_review_evidence'))
stopifnot(identical(after[,keep],before[,keep]))
changed <- which(before$analysis_eligible!=after$analysis_eligible |
  dplyr::coalesce(before$analysis_exclusion!=after$analysis_exclusion,is.na(before$analysis_exclusion)!=is.na(after$analysis_exclusion)) |
  dplyr::coalesce(before$scope_review_evidence!=after$scope_review_evidence,is.na(before$scope_review_evidence)!=is.na(after$scope_review_evidence)))
impact <- tibble::tibble(entity_id=after$entity_id[changed],name=after$name_raw[changed],
  eligible_before=before$analysis_eligible[changed],eligible_after=after$analysis_eligible[changed],
  exclusion_before=before$analysis_exclusion[changed],exclusion_after=after$analysis_exclusion[changed],
  evidence_after=after$scope_review_evidence[changed])
readr::write_csv(impact,file.path(p,'dry_run_impact.csv'),na='')
ledger <- readr::read_csv(file.path(p,'review_ledger.csv'),show_col_types=FALSE)
ex <- ledger$entity_id[ledger$scope_disposition=='exclude_new']
stopifnot(setequal(impact$entity_id,ex),all(!after$analysis_eligible[after$entity_id%in%ex]),
  all(after$review_status[after$entity_id%in%ledger$entity_id]!='verified'))
summary <- list(canonical=nrow(after),eligible_before=sum(before$analysis_eligible),eligible_after=sum(after$analysis_eligible),
  decisions=nrow(proposed),entities_changed=nrow(impact),newly_ineligible=sum(impact$eligible_before&!impact$eligible_after),
  prior_holds_enriched=sum(!impact$eligible_before),protected_files=nrow(pf),targets_unchanged=TRUE,status='dry_run_only')
jsonlite::write_json(summary,file.path(p,'dry_run_summary.json'),pretty=TRUE,auto_unbox=TRUE)
print(summary)
