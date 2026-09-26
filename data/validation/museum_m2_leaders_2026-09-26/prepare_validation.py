from pathlib import Path
from datetime import datetime,timezone
import csv,json
p=Path(__file__).parent
assert (p/'proposed_summary.csv').read_text(encoding='utf-8').splitlines()[1]=='60002,57083,52387,52255,440,185,174,25,105'
(p/'expected_counts.csv').write_bytes((p/'proposed_summary.csv').read_bytes())
old=Path('data/validation/museum_telephone_union_washington_2026-09-26/build_validate.R').read_text(encoding='utf-8')
t=old[:old.index('spec <-')].replace('museum_telephone_union_washington','museum_m2_leaders').replace('1781','1887')
t+='''spec <- jsonlite::fromJSON(file.path(p,'decisions_spec.json'),simplifyVector=FALSE)
added <- dn_read_museum_review(file.path(p,'proposed_added.csv'),dn_schema_museum_identity_decisions())
changed <- records$source_id%in%added$source_id
check('Records outside fourteen explicit cases unchanged',identical(records[!changed,],before$records[!changed,]))
check('All prior identity decisions preserved',identical(ids[match(old_ids$source_id,ids$source_id),],old_ids))
check('All 37 proposed identity rows applied exactly',nrow(added)==37L && identical(ids[match(added$source_id,ids$source_id),],added))
check('Threshold remains 0.85',identical(DN_NAME_SIM_MIN,0.85))
check('Reviewed expected counts',sum(analysis$counted)==52387L && sum(analysis$analysis_eligible)==52255L && sum(records$counted)==57083L)
check('440 identity rows in 185 cases',nrow(ids)==440L && dplyr::n_distinct(ids$case_id)==185L)
check('174 complete reviews 25 exclusions 105 names',sum(analysis$review_status=='verified')==174L && sum(analysis$category_decision=='not_museum')==25L && nrow(overrides)==105L)
check('35 source conflicts stay isolated and uncounted',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==35L && all(!records$counted[records$exclusion_reason%in%'reviewed_source_conflict']))
canon_keys <- added$source_id[added$role=='canonical']
check('Thirteen reconciled groups each have one source representative',length(canon_keys)==13L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
old_decisions <- dn_read_museum_review(file.path(p,'museum_decisions_before.csv'),dn_schema_museum_decisions())
retired <- unlist(spec$retire_decision_keys)
old_keep <- old_decisions[!old_decisions$source_id%in%retired,]
check('Prior factual decisions unchanged except two absorbed pending Smithsonian rows',length(retired)==2L && all(old_decisions$review_status[old_decisions$source_id%in%retired]=='pending') && identical(decisions[match(old_keep$source_id,decisions$source_id),],old_keep))
check('Retired decisions belong only to explicitly absorbed uncounted rows',all(retired%in%added$source_id) && all(!records$counted[match(retired,records$source_id)]))
expected_decisions <- dn_read_museum_review(file.path(p,'proposed_new_decisions.csv'),dn_schema_museum_decisions())
check('All 29 new factual decisions applied exactly',nrow(expected_decisions)==29L && identical(decisions[match(expected_decisions$source_id,decisions$source_id),],expected_decisions))
old_names <- dn_read_museum_review(file.path(p,'museum_name_overrides_before.csv'),dn_schema_museum_name_overrides())
check('Prior names preserved',identical(overrides[match(old_names$source_id,overrides$source_id),],old_names))
new_ids <- records$entity_id[match(expected_decisions$source_id,records$source_id)]
sa <- analysis[match(new_ids,analysis$entity_id),]
check('Four newly complete and 25 pending factual reviews',nrow(sa)==29L && sum(sa$review_status=='verified')==4L && sum(sa$review_status=='pending')==25L)
check('Foundation is a positive not-museum exclusion',!analysis$counted[analysis$source_id=='8405500038'] && analysis$category_decision[analysis$source_id=='8405500038']=='not_museum')
conflict <- records[records$source_id%in%c('8401100034','8401900298'),]
check('Two new mixed sources isolated from accepted museum aliases',nrow(conflict)==2L && all(conflict$exclusion_reason=='reviewed_source_conflict') && all(conflict$alt_names==''))
'''
tail=old[old.index('rank <- dn_museum_ranking(analysis)'):]
tail=tail.replace('All 21 starting','All 48 starting').replace('nrow(dispositions)==21L','nrow(dispositions)==48L')
tail=tail.replace('Fourteen incomplete reviews','Twenty-five newly reviewed incomplete institutions').replace('nrow(followup)==14L','nrow(followup)==25L')
(p/'build_validate.R').write_text(t+tail,encoding='utf-8')
obs=json.loads((p/'web_observations.json').read_text(encoding='utf-8'))
obs += [
 {'url':'https://naturalhistory.si.edu/about/press-office','observed_on':'2026-09-26','retrieval':'web search official contact content','finding':'National Museum of Natural History contact gives 10th Street and Constitution Avenue NW. Supports source-field conflict, not a current visitor-access guarantee.'},
 {'url':'https://americanhistory.si.edu/es/visita','observed_on':'2026-09-26','retrieval':'web search official visitor content','finding':'American History museum visitor address is 1300 Constitution Avenue NW. English /visit request failed; that failure is retained.'},
 {'url':'https://blackiowa.org/event/prayer-pop-up-presented-by-renee-bryant-moore-shavon-webb/','observed_on':'2026-09-26','retrieval':'web search official event content','finding':'October 3 2026 venue is African American Museum of Iowa, 55 12th Ave SE, Cedar Rapids IA 52401. Confirms a distinct Iowa museum, not the Washington Smithsonian institution.'},
 {'url':'https://nmaahc.si.edu/visit/accessibility-options','observed_on':'2026-09-26','retrieval':'web open redirects to generic si.edu/visit; native 403','finding':'The current open did not independently confirm NMAAHC access details. Use the cached contract only for historical address roles; current visitor access remains unverified.'}]
obs[2]['retrieval']='Cached native PDF; page 6 rendered and visually inspected'
(p/'web_observations.json').write_text(json.dumps(obs,indent=2),encoding='utf-8')
groups=[
 ('african american museum','cultural_subject','African American identifies a cultural/history subject, not geographic monopoly; preserve earlier factual uncertainties.','https://aambg.squarespace.com/'),
 ('american civil war museum','historical_subject','American modifies Civil War; exact name does not establish exclusive national jurisdiction.','https://acwm.org/about/'),
 ('american museum of natural history','ambiguous_institutional_scope','American may style institutional reach; no uniqueness assertion established, identity checks remain pending.','https://www.amnh.org/plan-your-visit'),
 ('crystal bridges museum of american art','collection_subject','American Art describes the collection; parent affiliation and duplicate records are separate questions.','https://crystalbridges.org/news/crystal-bridges-and-the-momentary-announce-key-leadership-appointments-26'),
 ('international police museum','collection_subject','Oregon operator describes uniforms and policing objects from multiple countries; other institutions remain separately pending.','https://www.internationalpolicemuseum.org/'),
 ('museum of american armor','collection_subject','American Armor describes the military collection.','https://www.museumofamericanarmor.com/our-mission'),
 ('museum of international folk art','collection_subject','International Folk Art describes collection subject/geographic breadth, not exclusive global museum authority.','https://www.moifa.org/'),
 ('national medal of honor museum','institutional_scope_requires_context','Distinct Texas and Tennessee organizations; national subject/ambition is not proof of an exclusivity claim.','https://www.mohhc.org/center-history/'),
 ('national museum of african american history and culture','national_institution','Smithsonian national institution; apparent duplicates include labs and conflicting source rows, with unresolved identities.','https://nmaahc.si.edu/sites/default/files/downloads/nmaahc_digitalarchivesspecialist_package.pdf'),
 ('national museum of the american indian','national_institution_multiple_campuses','Two Smithsonian public campuses share one parent; no independent competition inferred.','https://americanindian.si.edu/about/contact'),
 ('old world wisconsin','geographic_idiom','Old World is a historical/cultural idiom, not a claim to represent the entire world.','https://oldworldwisconsin.wisconsinhistory.org/'),
 ('seneca iroquois national museum','tribal_national_context','National refers to Seneca Nation heritage/governance, not a US-wide exclusivity claim.','https://senecamuseum.org/about/')]
with (p/'scope_word_review.csv').open('w',newline='',encoding='utf-8') as f:
 w=csv.writer(f);w.writerow(['name_expanded','interpretation','note','evidence_url']);w.writerows(groups)
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape')
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+''' - M2 proposal reviewed

- Dry run passes: 60,002 source rows, 57,083 counted source rows, 52,387 institutions, 52,255 eligible, 440 identity rows / 185 cases, 174 complete reviews, 25 exclusions, 105 preferred names and 35 isolated conflicts.
- Proposed 37 identity rows in fourteen cases, 29 factual decisions, two current names, four newly complete reviews and 25 new pending reviews. Three earlier African American Museum actions are carried forward: 28 open actions total. Two absorbed Smithsonian pending decisions are deliberately retired with guards and their original snapshots preserved.
- Thirty-one public documents cached. Three PDF pages visually checked and legible despite font warnings. Twelve group-level semantic interpretations recorded separately from identity/count certification. All 1,887 prior protected files unchanged. No live input changes yet.
- Next apply once, rebuild selectively and verify. Cloud spending USD 0.
''';f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Expected counts and independent integrity checks saved.')
