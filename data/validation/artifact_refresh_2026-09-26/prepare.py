"""One-time artifact snapshot and refresh preparation."""
from pathlib import Path
import csv,hashlib,shutil
from datetime import datetime,timezone
p=Path(__file__).parent
assert not (p/'protected_files.csv').exists()
mutable={'museum_identity_decisions.csv','museum_decisions.csv','museum_chain_rules.csv','museum_name_overrides.csv','README.md'}
files=[x for x in Path('data/validation').rglob('*') if x.is_file() and p not in x.parents and not(x.parent==Path('data/validation') and x.name in mutable)]
files.append(Path('data/processed/resolution_labelling.csv'))
with (p/'protected_files.csv').open('w',newline='',encoding='utf-8') as f:
 w=csv.writer(f);w.writerow(['path','sha256']);w.writerows((x.as_posix(),hashlib.sha256(x.read_bytes()).hexdigest()) for x in files)
for name in ['museum_identity_decisions','museum_decisions','museum_name_overrides','museum_chain_rules']:
 shutil.copyfile('data/validation/'+name+'.csv',p/(name+'_before.csv'))
shutil.copyfile('posts/duplicate-museum-names/index.Rmd',p/'post_before.Rmd')
old=Path('data/validation/museum_clinton_madison_monroe_2026-09-26/refresh_publication.R').read_text(encoding='utf-8')
old=old.replace("p <- 'data/validation/museum_clinton_madison_monroe_2026-09-26'","p <- 'data/validation/artifact_refresh_2026-09-26'")
old=old.replace("file.path(p,'integrity_checks.csv')","'data/validation/museum_m2_leaders_2026-09-26/integrity_checks.csv'").replace('nrow(checks)==20L','nrow(checks)==27L')
start=old.index("blockers <- readr::read_csv");end=old.index("recent_groups <-",start)
old=old[:start]+'''blockers <- tibble::tribble(
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
''' +old[end:]
old=old.replace("selected <- unique(c(head(rank$name_expanded,20),", "m2 <- readr::read_csv('data/validation/museum_m2_leaders_2026-09-26/scope_word_review.csv',show_col_types=FALSE)\nselected <- unique(c(m2$name_expanded,head(rank$name_expanded,20),")
old=old.replace("message('Local draft payloads refreshed.","readr::write_csv(m2,file.path(bundle,'payload/scope_word_review.csv'),na='')\nmessage('Local draft payloads refreshed.")
(p/'refresh_publication.R').write_text(old,encoding='utf-8')
r=Path('data/validation/museum_clinton_madison_monroe_2026-09-26/render_standalone.R').read_text(encoding='utf-8').replace('museum_clinton_madison_monroe','artifact_refresh')
(p/'render_standalone.R').write_text(r,encoding='utf-8')
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape');t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+f''' - Artifact refresh snapshot

- Saved {len(files)} prior-file hashes and post/decision-input snapshots in artifact_refresh_2026-09-26. M2 packet frozen; never rerun prepare.
- Refresh local artifacts from 52,387 counted / 52,255 eligible museum checkpoint. No new factual decisions or labels in this artifact step. Pending reviewed cases and unreviewed groups remain separate and incomplete.
- Initial patch could not create the new directory; native New-Item succeeded, with no permission change or data loss. Cloud spending USD 0.
''';f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Protected',len(files),'files; scripts prepared.')
