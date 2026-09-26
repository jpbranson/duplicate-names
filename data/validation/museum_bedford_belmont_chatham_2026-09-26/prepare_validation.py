"""Copy reusable validation scaffolding and supply this batch's invariant checks."""
from pathlib import Path
p=Path(__file__).parent
old=Path('data/validation/museum_madison_marion_milton_2026-09-26/build_validate.R').read_text()
start=old[:old.index("check('Counts match reviewed dry run'")]
tail=old[old.index('old_decisions <-'):]
checks="""check('Counts match reviewed dry run',sum(analysis$counted)==52429L && sum(analysis$analysis_eligible)==52297L && sum(records$counted)==57129L)
check('364 identity rows in 154 cases',nrow(ids)==364L && dplyr::n_distinct(ids$case_id)==154L && length(new_keys)==13L)
check('154 complete reviews 24 exclusions 95 names',sum(analysis$review_status=='verified')==154L && sum(analysis$category_decision=='not_museum')==24L && nrow(overrides)==95L)
leaders <- c('bedford historical society','belmont historical society','chatham historical society')
group_counts <- vapply(leaders,function(n)sum(analysis$analysis_eligible & !analysis$is_franchise%in%TRUE & analysis$name_expanded==n),integer(1))
print(group_counts)
check('Selected non-chain groups now three two and four',all(group_counts==c(3L,2L,4L)))
conflict <- records[records$source_id=='8403300202',]
check('New Hampshire conflict isolated with no aliases; 31 total',sum(records$exclusion_reason=='reviewed_source_conflict',na.rm=TRUE)==31L && nrow(conflict)==1L && !conflict$counted && !nzchar(dplyr::coalesce(conflict$alt_names,'')))
canon_keys <- ids$source_id[!ids$source_id%in%old_ids$source_id & ids$role=='canonical']
check('Six accepted identity cases each have one counted source',length(canon_keys)==6L && all(vapply(records$entity_id[match(canon_keys,records$source_id)],function(id)sum(records$counted[records$entity_id==id])==1L,logical(1))))
ny <- analysis[analysis$source_id%in%c('8403601012','9116ffbc-43e1-4602-8761-7222cd344728'),]
check('New York museum and excluded office remain separate under shared operator',nrow(ny)==2L && dplyr::n_distinct(ny$entity_id)==2L && sum(ny$counted)==1L && all(ny$chain_id=='bedford_new_york_historical_society') && all(ny$review_status=='verified') && ny$category_decision[ny$source_id=='9116ffbc-43e1-4602-8761-7222cd344728']=='not_museum')
ca <- analysis[analysis$source_id=='3875709e-2b41-41a2-b2e5-300efca2915d',]
check('California identity resolved but affiliation remains pending',nrow(ca)==1L && ca$counted && ca$primary_name=='Belmont History Room' && ca$review_status=='pending' && ca$affiliation_status=='unknown')
ma <- analysis[analysis$source_id=='8402500663',]
check('Claflin Room retains sourced multi-museum society affiliation',nrow(ma)==1L && ma$counted && ma$primary_name=='Claflin Room' && ma$chain_id=='belmont_massachusetts_historical_society' && ma$review_status=='verified')
ct <- records[records$source_id%in%c('a6157c3a-f4d4-4d6d-bbba-d4ca7b66ddc5','8400900271'),]
ct_a <- analysis[analysis$entity_id%in%ct$entity_id,]
check('Connecticut officer mailbox reconciles with one independent campus',nrow(ct)==2L && sum(ct$counted)==1L && nrow(ct_a)==1L && ct_a$review_status=='verified' && ct_a$affiliation_status=='independent')
at <- records[records$source_id%in%c('930cf7e2-44ea-46a5-937b-e94bef330b36','8402500622'),]
at_a <- analysis[analysis$entity_id%in%at$entity_id,]
check('Atwood Museum and society description count once',nrow(at)==2L && sum(at$counted)==1L && nrow(at_a)==1L && at_a$primary_name=='Atwood Museum' && at_a$review_status=='verified')
nh <- analysis[analysis$source_id%in%c('4ff2c6ed-44f6-4c27-b766-14a5db5b0f91','49631799-c101-497b-a804-eac4fa00bada'),]
check('Unresolved Chatham New Hampshire addresses remain separate and pending',nrow(nh)==2L && all(nh$counted) && dplyr::n_distinct(nh$entity_id)==2L && all(nh$review_status=='pending'))
"""
s=start+checks+tail
s=s.replace('museum_madison_marion_milton_2026-09-26',p.name).replace('museum_madison_marion_milton_before','museum_bedford_belmont_chatham_before').replace('1351','1467').replace('All 24 starting candidates','All 21 starting candidates').replace('nrow(dispositions)==24L','nrow(dispositions)==21L')
(p/'build_validate.R').write_text(s,encoding='utf-8')
assert not (p/'applied.json').exists()
(p/'expected_counts.csv').write_bytes((p/'proposed_summary.csv').read_bytes())
print('Saved expected counts and batch-specific validation checks.')
