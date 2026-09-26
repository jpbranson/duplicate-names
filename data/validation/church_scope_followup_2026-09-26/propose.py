"""Explicit per-record research ledger; create proposal, never apply live inputs."""
from pathlib import Path
import csv,json
p=Path(__file__).parent
read=lambda f:list(csv.DictReader(f.open(encoding='utf-8-sig')))
rows=read(p/'candidates_before.csv'); records=read(p/'related_records.csv')
old=read(p/'church_scope_decisions.csv.before')
directory='https://www.cogasoc.org/tabernacles/'
parent='https://www.cogasoc.org/'
org={
 '01c30062':('https://richmond.cogasoc.org/','Source-linked operator and parent directory match 500 N 31st Street, Richmond VA; operator identifies Fourth Tabernacle Beth El. A separate canonical Fourth Tabernacle description is retained without merging.'),
 '0c47e79e':(directory,'Parent directory matches First Tabernacle at 3561 Independence Road, Cleveland. Its source phone differs from the listed pastor contact and also appears on Central Avenue records; no identity consolidation or phone-based affiliation inference.'),
 '115de75c':('https://jacksonville.cogasoc.org/','Source-linked operator matches 3401 Stuart Street, Jacksonville and explicitly identifies its religious organization as adhering to Judaism.'),
 '13797795':(directory,'Parent directory matches Seventh Tabernacle at 812 Seminole Boulevard, Salisbury; source website is cogasoc.org. Earlier organization-only eligibility hold remains.'),
 '3bea6fb5':('https://cincinnati.cogasoc.org/','Operator matches 3944 Cass Avenue in page body (Cass Street in header) and 5135414276. This direct match establishes affiliation despite the generic churchofgod.cc source URL.'),
 '5a82705e':(directory,'Source-linked zanesville.cogasoc.org and directory match Second Tabernacle at 516 Cliffwood Avenue. The source names its prison ministry, so existing organization-only hold remains; no worship-site promotion.'),
 '5f865525':('https://baltimore.cogasoc.org/','Source-linked operator matches First Tabernacle at 1606 Ashland Avenue and 4102762761, Baltimore.'),
 '6a96da9b':(directory,'Parent directory matches First Tabernacle, 571 Irwin Street, Atlanta. Source website is cogasoc.org; distinct from the separate Christian branch in Lithonia.'),
 '6c1d8936':(parent,'Source website, address 3927 Bridge Road, Suffolk and phone 7574841161 match the parent headquarters. Separate Temple Beth El canonical description retained without merging.'),
 '75472d3f':('https://charlotte.cogasoc.org/','Source-linked operator matches Second Tabernacle, 2816 N Graham Street, Charlotte and 9807719734.'),
 '8209e2d4':(directory,'Parent directory matches Third Tabernacle at 829 Albany Avenue, Hartford; source website is cogasoc.org.'),
 '9deed732':('https://washingtondc.cogasoc.org/','Operator matches First Tabernacle, 401 New York Avenue NW, Washington and 2026386530. Source suffix #7 remains uninterpreted; no coordinate correction.'),
 'a589582a':(parent,'Temple Beth El source website, 3927 Bridge Road, Suffolk and 7574841161 match headquarters. Separate generic canonical description retained without merging.'),
 'a6cb8af1':(directory,'Parent directory matches Fifteenth Tabernacle at 19 Harrison Street, Rochester and names the Church of God and Saints of Christ parent. Source has no operator URL; address/name link supports only scope.'),
 'b91469cb':('https://atlanticcity.cogasoc.org/','Source-linked local page matches Fifth Tabernacle at 2601 Pacific Avenue and 6094852043. Parent directory instead lists 2005 Morningside Avenue. Affiliation supported; current location and access remain unresolved.'),
 'c4cab613':(directory,'Parent directory matches First Tabernacle at 602-14 S Broad Street, Philadelphia; source is 602 S Broad and cogasoc.org. Earlier organization-only hold remains.'),
 'c5815b44':(directory,'Parent directory matches Second Tabernacle at 1614 E 41st Street, Los Angeles; source website is cogasoc.org.'),
 'ced1af5b':(directory,'Parent directory matches Third Tabernacle at 1006 Dunbar Street, Greensboro; source website is cogasoc.org. Earlier organization-only hold remains.'),
 'e05f5896':('https://richmond.cogasoc.org/','Source-linked operator and directory match Fourth Tabernacle, 500 N 31st Street, Richmond VA. Earlier organization-only hold and separate generic canonical description remain.'),
 'f217d1e3':('https://southernpines.cogasoc.org/','Source-linked operator matches 580 W New Hampshire Avenue and 9106848392, Southern Pines, and explicitly states its members adhere to Judaism.'),
 'fcb798ea':('https://wilmington.cogasoc.org/','Source-linked local page matches 717 E 7th Street and 3026525495; local history also lists it. Parent directory instead lists 300-302 West Matson Run Parkway. Affiliation supported; current location and access remain unresolved.')
}
netdir='https://www.cogasoc.net/locations-1'
netbelief='https://www.cogasoc.net/about-us-1'
keep={
 '093745d0':('retain_supported_christian_branch',netdir+' | '+netbelief,'3825 Central Avenue matches the Cleveland headquarters of the separately governed, self-described Judaic Christian branch. Generic churchofgod.cc and duplicated 2164293179 source phone do not establish Judaism-branch affiliation. Resolve duplicate/phone context before full review.'),
 '3bdf437b':('retain_supported_christian_branch',netdir+' | '+netbelief,'Columbus directory lists 700 Athens Street; source says 700 Athens Avenue. Name, city and street-number match support the separate Christian branch; street suffix and Tab #4 semantics need checking.'),
 '483b28c9':('retain_supported_christian_branch',netdir+' | '+netbelief,'Hyattsville directory matches 4203 Farragut Street and 3017797497 in the separate Christian branch. The source-specific domain does not resolve; no exclusion inferred from that failure.'),
 '582a7355':('retain_supported_christian_branch',netdir+' | '+netbelief,'Source-linked cogasoc.net directory lists Suffolk at 4937 Towne Point Road, matching source 4937 Townpoint Road. It is separate from Judaism-identifying headquarters at Bridge Road.'),
 '9e0e8b9d':('retain_pending_identity',netdir+' | '+netbelief,'Separate Christian branch lists Richmond IN at 1002 Perry Street; source says 1002 Parry Street. Possible street spelling conflict remains unresolved. Existing organization-only hold preserved.'),
 'a803b59c':('retain_pending_identity',netdir+' | '+netbelief,'Separate Christian branch lists Newark at 5153 Jones Street; source says 51 Jones Street #53 and uses Independent in its name. Address formatting and affiliation require confirmation; no unsupported exclusion or merger.'),
 'c21cdaa6':('retain_supported_christian_branch',netdir+' | '+netbelief+' | https://churchofgod1931.org/','New Haven directory matches 109 Beers Street in the separate Christian branch. Source-linked churchofgod1931.org identifies the Cleveland-led body and Christian ministry. Do not transfer the other parent directory\'s closed New Haven status.'),
 'deed2b2c':('retain_supported_christian_branch','https://cogsoconline.org/ | https://cogsoconline.org/about/who-we-are','Operator matches 15615 Chagrin Boulevard, Shaker Heights and links the source Facebook identifier. Its beliefs explicitly describe Jesus as Lord and Saviour and distinguish multiple governing bodies. No Judaism-only exclusion.'),
 'e42f55b6':('retain_supported_christian_branch',netdir+' | '+netbelief,'Source-linked separate Christian directory exactly matches 300 East 37th Street, Brooklyn and 7182846710.'),
 'eaf5a1ed':('retain_pending_identity',netdir+' | '+netbelief+' | https://cogsoconline.org/','3825 Central Avenue matches the separate Christian branch headquarters, but source-linked cogsoconline.org gives 15615 Chagrin Boulevard. Both describe Christian faith; source address/domain conflict and possible duplicate remain unresolved. No scope exclusion or merger.')
}
unresolved={
 '4ebfd6a8':('https://detroit.cogasoc.org/ | '+directory,'Source 15511 Dexter Avenue differs from parent directory 18515 Wyoming Street. Local operator home/history could not be fetched because its certificate expired. Historical city record supports former worship use but does not link this row to that parent today. Human review needs current operator/relocation evidence.'),
 '723a7255':('https://newark.cogasoc.org/ | '+directory,'Source 343 Meeker Avenue differs from parent directory mailing address and Plainfield worship notice. Local operator home/history certificate expired; historical funeral notice alone does not establish current affiliation. Human review needs an authoritative link and current status.'),
 'b09eb986':(directory,'No matching 21 Montour Street Binghamton entry in either operator directory. Historical references at different Binghamton addresses and third-party tax listings do not establish current identity or faith. Human review needs direct operator/address evidence; existing organization-only hold remains.')
}
ledger=[]; proposed=old.copy()
fields=list(old[0])
for a in rows:
 prefix=a['source_id'][:8]; entry={'entity_id':a['entity_id'],'source_id':a['source_id'],'name_raw':a['name_raw'],'eligible_before':a['analysis_eligible'],'full_review_status':'pending'}
 if prefix in org:
  url,note=org[prefix]
  urls=' | '.join(dict.fromkeys([url,directory,parent]))
  note+=' The linked cogasoc.org parent explicitly describes its faith as Judaism. Narrow scope correction only; source religion, identity and coordinates remain unchanged.'
  entry.update(scope_disposition='exclude_new',evidence_url=urls,evidence_note=note,next_action='Complete identity, current-name, point and worship-status review separately; no full review certified.')
  members=[r for r in records if r['entity_id']==a['entity_id']]
  assert members
  for r in members:
   proposed.append(dict(source=r['source'],source_id=r['source_id'],expected_name=r['name_raw'],expected_entity_id=r['entity_id'],expected_coordinates=f"{float(r['lon']):.7f},{float(r['lat']):.7f}",decision='outside_christian_scope',evidence_url=urls,evidence_note=note,reviewed_by='assistant_official_source_review',reviewed_on='2026-09-26'))
 elif any(d['source_id']==a['source_id'] for d in old):
  d=next(d for d in old if d['source_id']==a['source_id'])
  entry.update(scope_disposition='excluded_prior',evidence_url=d['evidence_url'],evidence_note=d['evidence_note'],next_action='Prior scope decision preserved; overall identity/number semantics review remains pending.')
 elif prefix in keep:
  status,url,note=keep[prefix]
  entry.update(scope_disposition=status,evidence_url=url,evidence_note=note,next_action='Resolve any stated source conflict and complete institution/point/name review; retain existing analytical eligibility meanwhile.')
 else:
  assert prefix in unresolved,prefix
  url,note=unresolved[prefix]
  entry.update(scope_disposition='retain_unresolved_human_review',evidence_url=url,evidence_note=note,next_action=note)
 ledger.append(entry)
assert len(org)==21 and len(keep)==10 and len(unresolved)==3 and len(ledger)==36 and len(proposed)==23
def write(name,rs,fs=None):
 with (p/name).open('w',encoding='utf-8',newline='') as f:
  w=csv.DictWriter(f,fieldnames=fs or list(rs[0]));w.writeheader();w.writerows(rs)
write('review_ledger.csv',ledger)
write('scope_decisions_proposed.csv',proposed,fields)
write('human_review.csv',[r for r in ledger if r['scope_disposition']=='retain_unresolved_human_review'])
write('identity_followup.csv',[r for r in ledger if r['scope_disposition']=='retain_pending_identity' or r['source_id'][:8] in ('01c30062','0c47e79e','6c1d8936','a589582a','b91469cb','e05f5896','fcb798ea','093745d0','3bdf437b')])
print('Proposal: 21 additional scope decisions; 14 newly ineligible, seven earlier holds enriched; 23 total decisions. All 36 full reviews pending.')
