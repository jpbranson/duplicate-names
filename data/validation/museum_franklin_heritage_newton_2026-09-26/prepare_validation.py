from pathlib import Path
from datetime import datetime,timezone
p=Path(__file__).parent
old=Path('data/validation/museum_commemorative_air_force_2026-09-26/build_validate.R').read_text()
start=old[:old.index("check('Counts match reviewed dry run'")]
tail=old[old.index('old_decisions <-'):]
checks="""check('Counts match reviewed dry run',sum(analysis$counted)==52413L && sum(analysis$analysis_eligible)==52281L && sum(records$counted)==57111L)
check('396 identity rows in 168 cases',nrow(ids)==396L && dplyr::n_distinct(ids$case_id)==168L && length(new_keys)==26L)
check('166 complete reviews 24 exclusions 100 names',sum(analysis$review_status=='verified')==166L && sum(analysis$category_decision=='not_museum')==24L && nrow(overrides)==100L)
check('33 source-conflict holds retained uncounted',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==33L && all(!records$counted[records$exclusion_reason%in%'reviewed_source_conflict']))
canon_keys <- ids$source_id[!ids$source_id%in%old_ids$source_id & ids$role=='canonical']
check('Ten accepted case groups count one source representative each',length(canon_keys)==10L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
sel <- readr::read_csv(file.path(p,'proposed_new_decisions.csv'),show_col_types=FALSE)$source_id
sa <- analysis[analysis$source_id%in%sel,]
check('All 23 factual decisions represented in analysis',nrow(sa)==23L)
check('Eight complete and fifteen pending without new exclusions',sum(sa$review_status=='verified')==8L && sum(sa$review_status=='pending')==15L && all(sa$category_decision=='not_flagged'))
mixed <- records[records$source_id%in%c('8403400077','8401900081'),]
fi <- analysis[analysis$source_id=='1cbdadb2-913f-427e-b0cf-6e2e6dd9c499',]
check('Mixed rows isolated and New Jersey alias removed from Indiana',nrow(mixed)==2L && all(!mixed$counted) && all(mixed$alt_names=='') && nrow(fi)==1L && fi$primary_name=='Franklin Heritage' && !grepl('museum',fi$alt_names,ignore.case=TRUE) && fi$review_status=='pending')
jew <- records[records$source_id%in%c('5e1afd1f-bf13-48b3-9f08-4936e81d27c5','8403400166'),]
check('Clean Jewish museum pair excludes mixed Iowa membership',nrow(jew)==2L && dplyr::n_distinct(jew$entity_id)==1L && !any(jew$entity_id%in%mixed$entity_id) && sum(jew$counted)==1L)
va <- records[records$source_id%in%c('8378f398-13e7-4e0b-b764-52ce05a943da','b4323a53-17f7-4436-9bca-0e82ee139771','4c10b642-27e3-484c-8603-91a9312b01e1','8405100619','4dc40b24-03e8-483b-a719-7fe15906f546'),]
check('Five Rocktown descriptions retain one current canonical',nrow(va)==5L && sum(va$counted)==1L && all(va$primary_name=='Rocktown History'))
ar <- analysis[analysis$source_id%in%c('23141362-d61e-42a0-8b56-49952643a25a','8400500046'),]
check('Unresolved Arkansas 403 and 601 descriptions remain separate pending',nrow(ar)==2L && dplyr::n_distinct(ar$entity_id)==2L && all(ar$counted) && all(ar$review_status=='pending'))
chain <- analysis[analysis$source_id%in%c('710d0bf4-30ce-4ced-bcff-7761f12f0f23','8404100102','68298af8-35dc-4355-b21c-88bb971e19df'),]
check('Three specifically sourced chain affiliations retained',nrow(chain)==3L && all(chain$is_franchise) && sum(chain$chain_id=='clatsop_county_historical_society')==2L && sum(chain$review_status=='pending')==1L)
ct <- analysis[analysis$source_id%in%c('8c6b6a79-2e47-4a50-b801-317c3341988e','8400900244'),]
check('Connecticut society and museum remain separate pending',nrow(ct)==2L && dplyr::n_distinct(ct$entity_id)==2L && all(ct$review_status=='pending'))
"""
t=(start+checks+tail).replace('museum_commemorative_air_force','museum_franklin_heritage_newton').replace('1578','1667').replace('All 7 starting candidates','All 21 starting candidates').replace('nrow(dispositions)==7L','nrow(dispositions)==21L').replace('Six incomplete reviews','Fifteen incomplete reviews').replace('nrow(followup)==6L','nrow(followup)==15L')
(p/'build_validate.R').write_text(t)
assert (p/'proposed_summary.csv').read_text().splitlines()[1]=='60002,57111,52413,52281,396,168,166,24,100'
(p/'expected_counts.csv').write_bytes((p/'proposed_summary.csv').read_bytes())
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape')
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+''' - Franklin/Heritage/Newton dry run reviewed

- Twenty-six identity rows / eleven cases, twenty-three factual decisions and three names prepared. Guarded output CSVs inspected: eight complete and fifteen pending. Two mixed IMLS rows isolated, no new not-museum exclusion.
- Initial dry run rejected an HTTP evidence URL, then incomplete Indiana cluster membership. Both failures are retained. Used already-inspected municipal HTTPS source and explicitly researched/added both clean Indiana members; no guard was weakened. Indiana museum scope remains pending.
- Proposed counts: 60,002 rows; 57,111 counted rows; 52,413 institutions; 52,281 eligible; 396 identity rows / 168 cases; 166 complete reviews; 24 not-museum decisions; 100 names. No live changes yet.
- Forty-eight downloads attempted; 39 cached and nine failures retained without security bypass. Seven PDF pages visually inspected; indexed-only sources are labeled. All prior 1,667 protected files unchanged in dry run.
- Next apply once, rebuild selective exports and validate. Cloud spending USD 0.
'''
f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Saved expected counts and validation script; live inputs not changed.')
