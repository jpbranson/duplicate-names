from pathlib import Path
from datetime import datetime,timezone
p=Path(__file__).parent
old=Path('data/validation/museum_bedford_belmont_chatham_2026-09-26/build_validate.R').read_text()
start=old[:old.index("check('Counts match reviewed dry run'")]
tail=old[old.index('old_decisions <-'):]
checks="""check('Counts match reviewed dry run',sum(analysis$counted)==52426L && sum(analysis$analysis_eligible)==52294L && sum(records$counted)==57126L)
check('370 identity rows in 157 cases',nrow(ids)==370L && dplyr::n_distinct(ids$case_id)==157L && length(new_keys)==6L)
check('158 complete reviews 24 exclusions 97 names',sum(analysis$review_status=='verified')==158L && sum(analysis$category_decision=='not_museum')==24L && nrow(overrides)==97L)
check('Bare generic CAF removed from non-chain ranking',!any(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded=='commemorative air force'))
check('31 source-conflict holds unchanged',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==31L)
canon_keys <- ids$source_id[!ids$source_id%in%old_ids$source_id & ids$role=='canonical']
check('Three paired museums count once each',length(canon_keys)==3L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
sel <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
sa <- analysis[analysis$source_id%in%sel,]
check('All ten reviewed institutions have sourced CAF affiliation',nrow(sa)==10L && all(sa$chain_id=='commemorative_air_force') && all(sa$is_franchise))
check('Four complete and six pending without not-museum inference',sum(sa$review_status=='verified')==4L && sum(sa$review_status=='pending')==6L && all(sa$category_decision=='not_flagged'))
mid <- analysis[analysis$source_id%in%c('c0977330-6883-49f3-ace1-67f47fc19958','2bc38465-4592-48dc-a55b-fa7956634c28','8404801178'),]
check('Three unresolved Midland roles remain distinct and pending',nrow(mid)==3L && dplyr::n_distinct(mid$entity_id)==3L && all(mid$counted) && all(mid$review_status=='pending'))
dal <- analysis[analysis$source_id%in%c('b212bf54-f6a3-47bd-bd9f-94956f73b5f9','a616fb3c-641e-4bc5-8871-fccbaf8ea5ae'),]
check('Dallas campus identities remain distinct and pending',nrow(dal)==2L && dplyr::n_distinct(dal$entity_id)==2L && all(dal$counted) && all(dal$review_status=='pending'))
ks <- analysis[analysis$source_id=='888da035-0c62-418f-ac74-d6a19ff57698',]
check('Kansas public wing name is complete',nrow(ks)==1L && ks$primary_name=='CAF Heart of America Wing' && ks$review_status=='verified')
"""
t=(start+checks+tail).replace('museum_bedford_belmont_chatham','museum_commemorative_air_force').replace('1467','1578').replace('All 21 starting candidates','All 7 starting candidates').replace('nrow(dispositions)==21L','nrow(dispositions)==7L').replace('Eight incomplete reviews','Six incomplete reviews').replace('nrow(followup)==8L','nrow(followup)==6L')
(p/'build_validate.R').write_text(t)
assert (p/'proposed_summary.csv').read_text().splitlines()[1]=='60002,57126,52426,52294,370,157,158,24,97'
(p/'expected_counts.csv').write_bytes((p/'proposed_summary.csv').read_bytes())
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape')
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+''' - CAF dry run reviewed

- Six identity rows / three cases, ten decisions and two names prepared. Dry run passed and the guarded output CSVs were inspected. Four complete reviews and six explicit pending actions; no new exclusions or source-conflict holds.
- Proposed replay: 60,002 source rows; 57,126 counted rows; 52,426 institutions; 52,294 eligible; 370 identity rows / 157 cases; 158 complete reviews; 24 not-museum exclusions; 97 preferred names. No live changes yet.
- Twenty-five of 26 primary downloads cached; untrusted-certificate failure retained for High Sky. Indexed operator page and CAF rename announcement observations saved. Audit PDF page 20 visually inspected; minor font substitution did not obscure text. Georgia artifact-tour restrictions preserved.
- Next apply once, selective rebuild and validation. Six specific identity questions remain for human review. USD 0 cloud spending.
'''
f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Prepared validation and saved reviewed expected counts.')
