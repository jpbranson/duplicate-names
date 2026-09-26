from pathlib import Path
from datetime import datetime,timezone
p=Path(__file__).parent
assert (p/'proposed_summary.csv').read_text().splitlines()[1]=='60002,57107,52409,52277,403,171,170,24,103'
(p/'expected_counts.csv').write_bytes((p/'proposed_summary.csv').read_bytes())
old=Path('data/validation/museum_franklin_heritage_newton_2026-09-26/build_validate.R').read_text()
t=old[:old.index("new_keys <-")]
t+='''spec <- jsonlite::fromJSON(file.path(p,'decisions_spec.json'),simplifyVector=FALSE)
added <- dn_read_museum_review(file.path(p,'proposed_added.csv'),dn_schema_museum_identity_decisions())
changed <- records$source_id%in%added$source_id
check('Source records outside four reviewed cases unchanged',identical(records[!changed,],before$records[!changed,]))
prior_unchanged <- old_ids[!old_ids$case_id%in%unlist(spec$replace_identity_cases),]
check('Prior identity decisions outside explicit Illinois extension unchanged',identical(ids[match(prior_unchanged$source_id,ids$source_id),],prior_unchanged))
check('All nine proposed identity rows applied exactly',identical(ids[match(added$source_id,ids$source_id),],added))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Counts match reviewed dry run',sum(analysis$counted)==52409L && sum(analysis$analysis_eligible)==52277L && sum(records$counted)==57107L)
check('403 identity rows in 171 cases',nrow(ids)==403L && dplyr::n_distinct(ids$case_id)==171L && sum(changed)==9L)
check('170 complete reviews 24 exclusions 103 names',sum(analysis$review_status=='verified')==170L && sum(analysis$category_decision=='not_museum')==24L && nrow(overrides)==103L)
check('33 source-conflict holds preserved',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==33L && all(!records$counted[records$exclusion_reason%in%'reviewed_source_conflict']))
canon_keys <- added$source_id[added$role=='canonical']
check('Four reconciled cases each count one representative',length(canon_keys)==4L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
sel <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
sa <- analysis[analysis$source_id%in%sel,]
check('18 factual decisions give four complete and fourteen pending',nrow(sa)==18L && sum(sa$review_status=='verified')==4L && sum(sa$review_status=='pending')==14L)
chain_keys <- c('511d6c9e-0b9b-48ae-9411-50c5d1a9a999','cc2a936a-b634-4b3b-a818-7ee5859ab8f2','8401800453','020cc712-f2e4-47a4-aa1e-8d83179974b6')
chain <- analysis[analysis$source_id%in%chain_keys,]
check('Four sourced affiliations with three still pending',nrow(chain)==4L && all(chain$is_franchise) && sum(chain$review_status=='pending')==3L)
ma <- analysis[analysis$source_id%in%c('8409400650','3b0a337a-1535-4a1a-a9b9-cc80ced83338'),]
check('Massachusetts conflicting identifiers remain separate pending',nrow(ma)==2L && dplyr::n_distinct(ma$entity_id)==2L && all(ma$review_status=='pending'))
old_decisions <- dn_read_museum_review(file.path(p,'museum_decisions_before.csv'),dn_schema_museum_decisions())
replace_keys <- unlist(spec$replace_decision_keys)
old_keep <- old_decisions[!old_decisions$source_id%in%replace_keys,]
check('Only seven explicitly listed prior factual decisions updated',length(replace_keys)==7L && identical(decisions[match(old_keep$source_id,decisions$source_id),],old_keep))
expected_decisions <- dn_read_museum_review(file.path(p,'proposed_new_decisions.csv'),dn_schema_museum_decisions())
check('All proposed factual decisions applied exactly',identical(decisions[match(expected_decisions$source_id,decisions$source_id),],expected_decisions))
old_names <- dn_read_museum_review(file.path(p,'museum_name_overrides_before.csv'),dn_schema_museum_name_overrides())
check('All prior preferred names preserved',identical(overrides[match(old_names$source_id,overrides$source_id),],old_names))
'''
tail=old[old.index('rank <- dn_museum_ranking(analysis)'):]
tail=tail.replace('Fifteen incomplete reviews','Fourteen incomplete reviews').replace('nrow(followup)==15L','nrow(followup)==14L')
t=(t+tail).replace('museum_franklin_heritage_newton','museum_telephone_union_washington').replace('1667','1781')
(p/'build_validate.R').write_text(t)
f=Path('FLIGHT_LOG.md');log=f.read_text(encoding='utf-8',errors='surrogateescape')
log+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+''' - Telephone/Union/Washington dry run reviewed

- Guarded output rows, decisions, names and counts inspected. Proposed 60,002 source rows, 57,107 counted rows, 52,409 institutions, 52,277 eligible, 403 identity rows / 171 cases, 170 complete reviews, 24 exclusions and 103 names.
- Initial dry run correctly rejected former-site roles sharing the canonical site group. Corrected the two draft former-site groups; no guard changed, original failure retained.
- All 1,781 prior protected files unchanged. Nine identity rows replace/extend one old two-row case and add three cases; seven prior factual decisions deliberately updated. Four complete reviews, fourteen pending actions. No live changes yet; expected counts saved.
- Next apply once, selectively rebuild and verify exports. Cloud spending USD 0.
'''
f.write_bytes(log.encode('utf-8',errors='surrogateescape'))
print('Expected counts and validation saved; proposed inputs reviewed.')
