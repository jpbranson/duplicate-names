"""Assemble factual source decisions without changing live pipeline inputs."""
import json
from pathlib import Path
p=Path(__file__).parent
sources={r['id']:r['url'] for f in sorted(p.glob('sources*.json')) for r in json.loads(f.read_text())}
spec={'evidence':{},'identities':[],'decisions':[],'names':[]}
def evidence(case, ids, note):
    urls=[sources.get(s,s) for s in ids]
    assert urls[0].startswith('https://')
    spec['evidence'][case]={'url':' | '.join(urls),'note':note}
def identity(case,keys,roles,groups=None):
    spec['identities'].append(dict(case=case,keys=keys,roles=roles,groups=groups or [case.lower()]*len(keys)))
def decision(key,case,aff='unknown',status='pending',category='not_flagged',chain=None):
    spec['decisions'].append(dict(key=key,case=case,aff=aff,status=status,category=category,chain=chain))
def preferred(key,case,name):
    spec['names'].append(dict(key=key,case=case,name=name))

evidence('CASS_IA',['cass_ia_home','cass_ia_history','https://www.irs.gov/pub/irs-soi/eo_ia.csv'],
 'One volunteer-governed Cass County Historical Museum in the historic Griswold bank. Operator history identifies its dedicated board and one museum building, opened in 1963 and renovated/reopened in 2007. Current header gives the preferred public name and 410 Main Street, phone 712-778-5040; Overture has 412 Main and the same phone. IMLS EIN 421409956 and IRS extract identify the society at PO Box 254, Griswold. Consolidate the physical and mailing records, preserving the 410/412 address variation and original point. Homepage and history page disagree about weekly hours; recheck visitor access and exact entrance before publication. No second museum or common parent is established by county-wide collecting scope.')
identity('CASS_IA',['19afcb03-d4fb-4878-bc68-d12874e52616','8401900502'],['canonical','mailing_address'])
decision('19afcb03-d4fb-4878-bc68-d12874e52616','CASS_IA','independent','verified')
preferred('19afcb03-d4fb-4878-bc68-d12874e52616','CASS_IA','Cass County Historical Museum')

evidence('CASS_MN',['cass_mn_home','cass_mn_state'],
 'One Cass County Museum at 201 Minnesota Avenue West, Walker, with mailing PO Box 505 and telephone 218-547-7251, as recorded by the operator and Minnesota Historical Society directory. These exact contacts bridge the IMLS East-direction address to the Overture West-address record. The operator publishes its own historical-society board meetings and 2026 museum season. Huset School on the museum grounds belongs to this campus, not an additional inferred institution. Prefer the current operator public name; retain the IMLS erroneous direction and all source coordinates. State local-history association membership is not common museum ownership. Visitor map pin still requires publication checking.')
identity('CASS_MN',['c854d500-634e-4b15-b507-521957786076','8402700339'],['canonical','mislocated'])
decision('c854d500-634e-4b15-b507-521957786076','CASS_MN','independent','verified')
preferred('c854d500-634e-4b15-b507-521957786076','CASS_MN','Cass County Museum')

evidence('CASS_MO',['cass_mo_city','cass_mo_about','cass_mo_board','cass_mo_cabin','https://www.irs.gov/pub/irs-soi/eo_mo.csv'],
 'The city identifies the Burnt District Museum within the Cass County Public Library at 400 East Mechanic. The historical society operator gives Suite 203, the same phone 816-380-4396, its own board, archives and the Sharp-Hopper Cabin on the office grounds. IRS EIN 237357777 matches the current street; IMLS PO Box 406 is a mailing alternative. Three records describe this one museum/research campus, not three institutions. Preserve the cabin on the same campus and the library co-location without inferring library ownership. Prefer the named museum Overture row and current public name; IMLS source point is displaced and is not a visitor pin.')
identity('CASS_MO',['8296e2ba-12e2-42cd-aeff-628d8fd3deca','09462bff-d0a6-437b-8001-c1fdb490ea66','8402900203'],['canonical','same_site','mislocated'])
decision('8296e2ba-12e2-42cd-aeff-628d8fd3deca','CASS_MO','independent','verified')
preferred('8296e2ba-12e2-42cd-aeff-628d8fd3deca','CASS_MO','Burnt District Museum')

evidence('CASS_IL',['cass_il_home','cass_il_about','cass_il_museum','cass_il_library','illinois_museum_directory'],
 'Retain the museum of the Cass County Historical & Genealogical Society, 109 South Front Street, Virginia. Its operator history gives its own nonprofit society and officers; the museum page identifies museum displays, and the state museum directory (physical PDF page 9) identifies this institution at the same address. The university newspaper directory independently matches the society and address. Prefer the full operator public name. Office/research hours do not negate its museum role; no not_museum exclusion is inferred. The Virginia city tourism page was web-readable but its native cache failed certificate validation and is not relied on as the sole evidence.')
decision('8401701038','CASS_IL','independent','verified')
preferred('8401701038','CASS_IL','Cass County Historical & Genealogical Society')

evidence('CASS_IN',['cass_in_home','cass_in_contact'],
 'The operator explicitly runs two museums: Long Home Museum at 1004 East Market Street (with an adjacent reconstructed cabin) and Cass County Museum at 421 East Broadway, acquired in 2019, with the Castaldi Family History Center and staff offices. Retain two institutions under the same Cass County Indiana Historical Society affiliation; Broadway is not merely a replacement address for the Long Home. Reconcile the two Long Home source rows to one canonical record. Apply each museum public name. The operator gives current gallery and construction restrictions and closes both museums in January; recheck access before publication. The cabin is part of the Long Home campus, not a third inferred museum.')
identity('CASS_IN_LONG',['b3d41abe-793a-4a9b-891e-a3b49138fe79','8401800637'],['canonical','same_site'])
spec['evidence']['CASS_IN_LONG']=spec['evidence']['CASS_IN']
for k,n in [('b3d41abe-793a-4a9b-891e-a3b49138fe79','Long Home Museum'),('cbd74505-213f-4b6c-a478-d10e20ed48e0','Cass County Museum')]:
    decision(k,'CASS_IN','chain','verified',chain='cass_county_indiana_historical_society');preferred(k,'CASS_IN',n)

evidence('CASS_MI_CONFLICT',['cass_mi_city_governance','cass_mi_dowagiac','cass_mi_home','cass_mi_newton','cass_mi_school','cass_mi_cabin'],
 'Source conflict: IMLS 8402600506 combines Cass County Historical Society legal identity/EIN 382132651 and Fosdick mailing address with the 201 East Division Street address and dowagiacmuseum.info website of Dowagiac Area History Museum. The latter explicitly identifies itself as a City of Dowagiac department. The separate society site identifies Newton House, Red Brick School and Pioneer Log Cabin with different addresses. Isolate this mixed IMLS row uncounted, with no aliases transferred to the clean municipal museum or any society site. Pending: provider provenance and precise legal/site membership. No society closure or not_museum conclusion is inferred.')
identity('CASS_MI_CONFLICT',['8402600506'],['source_conflict'],['unresolved_source'])
decision('8402600506','CASS_MI_CONFLICT')

evidence('CHESTER_CT',['chester_ct_home','chester_ct_history','chester_ct_visit','chester_ct_newsletter'],
 'One Chester Museum at The Mill, 9 West Main Street. Operator history identifies the historical society founded in 1970, purchase of the mill in 2000 and museum opening in 2010, with offices and archives in the museum. Current visitor page bridges the named museum and society Overture records; the society newsletter explicitly describes an independent all-volunteer organization outside the town budget and PO Box 204. Reconcile the three source records, retaining the displaced IMLS point as mislocated support. Use the named Overture museum and current public name; no new town-owned chain inferred.')
identity('CHESTER_CT',['6c468d2c-c9e2-4111-912a-6c7b95dacacf','d576ac84-3a7c-410c-b868-9c5ed5e04cef','8400900425'],['canonical','same_site','mislocated'])
decision('6c468d2c-c9e2-4111-912a-6c7b95dacacf','CHESTER_CT','independent','verified')
preferred('6c468d2c-c9e2-4111-912a-6c7b95dacacf','CHESTER_CT','Chester Museum at The Mill')

evidence('CHESTER_NY',['chester_ny_about','chestertown_about','https://www.irs.gov/pub/irs-soi/eo_ny.csv'],
 'The Orange County operator identifies 1915 Erie Station as Chester local history museum at 19 Winkler Place, with a separate society office/archive at the C. Z. Winters House, 93 Brookside Avenue. Its old 47 Main Street mailing address is retained in the website and IRS EIN 133486416. Reconcile Overture and IMLS 8403600862 as one museum; the office is not an extra museum. Isolate IMLS 8403601088: its EIN 141585890, Chestertown PO Box 34 and 12817 ZIP belong to the Historical Society Town of Chester in Warren County, whose operator museum is at the municipal center on State Route 9. The mixed Chester physical address does not justify merging or counting that contradictory row. Keep full three-member baseline membership and no disputed aliases. Prefer the operator name 1915 Erie Station. Pending for the isolated row: provider correction and clean Chestertown source identity.')
identity('CHESTER_NY',['2ad511aa-be3f-4500-9201-4b756ec64e56','8403600862','8403601088'],['canonical','mailing_address','source_conflict'],['erie_station','erie_station','unresolved_source'])
decision('2ad511aa-be3f-4500-9201-4b756ec64e56','CHESTER_NY','independent','verified')
decision('8403601088','CHESTER_NY')
preferred('2ad511aa-be3f-4500-9201-4b756ec64e56','CHESTER_NY','1915 Erie Station')

evidence('CHESTER_VT',['chester_vt_home','chester_vt_town','chester_vt_release'],
 'Reconcile two records of the Chester Vermont Historical Society at 230 Main Street, PO Box 118. The operator website matches the mailing contact, the town identifies the Old Central High School/Academy Building as its present home, and the society September 23, 2026 event announcement places its October program at that address. Retain the original IMLS displaced point as mislocated support. Pending: current museum exhibit/access scope and governing/operating relationship to the town-owned building. Nearby Hearse House and Yosemite Firehouse are separately described town projects, not proven society sites. Do not infer a municipal chain or exclude the museum merely from sparse operator information.')
identity('CHESTER_VT',['63263595-1d45-4eee-89f3-2898132d2546','8405000105'],['canonical','mislocated'])
decision('63263595-1d45-4eee-89f3-2898132d2546','CHESTER_VT')

evidence('CHESTER_NH',['chester_nh_town','chester_nh_report2017'],
 'One Chester Historical Society museum at Stevens Memorial Hall, 1 Chester Street. The current municipal community-club page identifies its membership, own officers, bimonthly meetings and public office/exhibits on the second Saturday monthly. The historical town report describes the nonprofit membership museum; its download now returns 404, recorded explicitly. Reconcile Overture/IMLS with the same address and former operator domain, retaining the Overture point and IMLS support. The old chesternhhistorical.org domain now serves gambling material and is not used as current museum evidence; this alone does not make two consistent historic records a mixed-institution source conflict. Retain the society public name and independent membership governance. Visitor entrance/access still needs publication recheck.')
identity('CHESTER_NH',['3386eeb8-89b1-499a-aaa7-c113ebab34c2','8403300113'],['canonical','same_site'])
decision('3386eeb8-89b1-499a-aaa7-c113ebab34c2','CHESTER_NH','independent','verified')

evidence('CHESTER_NJ',['chester_nj_home','chester_nj_constitution','chester_nj_present','chester_nj_newsletter'],
 'The operator matches PO Box 376, Chester New Jersey. Its constitution establishes a nonprofit membership society governed by its own elected trustees, supporting independent affiliation. Museum/site scope remains pending: its work includes archives, programs and temporary exhibits, and a 2023 newsletter describes Rockefeller Center open-house displays. The newsletter native cache fails an expired-certificate check; no bypass. The operator explicitly attributes Cooper Mill, Willowwood and Bamboo Brook to Morris County Park Commission, so they are not merged into this society. Retain the counted record; neither a mailbox nor failure to find a permanent museum is evidence for not_museum. Follow-up: which public collection/site this source represents, current address and display access.')
decision('8403400571','CHESTER_NJ','independent')

evidence('CRAWFORD_IA',['crawford_ia_destination','https://www.irs.gov/pub/irs-soi/eo_ia.csv'],
 'Pending: the destination organization identifies the Crawford County Historical Society as maintaining W. A. McHenry House in Denison. IMLS 8401900180 gives 2531 Donna Reed Road and PO Box 741, EIN 237161933; the cached IRS row gives 1424 4th Avenue North, while the separate museum Overture row is at 1428 First Avenue North. No primary address-history or legal-to-site bridge was found for these differences. Retain the society and McHenry House records separately until that relationship is documented. Do not merge solely on an operator name, or exclude a mailbox/address as not_museum. Follow-up: current operator address history, institutional scope and governance.')
decision('8401900180','CRAWFORD_IA')

evidence('CRAWFORD_AR_CONFLICT',['crawford_ar_directory','crawford_ar_history'],
 'Source conflict: IMLS 8400500089 Historical Society/EIN 237425902 and PO Box 1317 Van Buren are combined with 614 Fayetteville Street/PO Box 276 Alma. The Arkansas Historical Association identifies the latter as Crawford County Genealogical Society and its library; separate IMLS 8400500123 has that society EIN 522456816 and matching Alma address. The state encyclopedia distinguishes the historical and genealogical societies and their publications. Isolate the mixed historical-society row uncounted, with no aliases to the genealogical institution. Pending: historical-society current legal/site identity and provider provenance. Absence from the cached IRS file does not establish closure, independence or not_museum.')
identity('CRAWFORD_AR_CONFLICT',['8400500089'],['source_conflict'],['unresolved_source'])
decision('8400500089','CRAWFORD_AR_CONFLICT')

evidence('CRAWFORD_MO',['crawford_mo_city','crawford_mo_state'],
 'One Crawford County Historical Society Museum at 308 North Smith Street, Cuba, as identified by city destination and state tourism sources. Two source records share this exact museum address and phone/domain; reconcile to the Overture canonical row, preserving IMLS support. Prefer the full public museum name from the current destination sources. Pending: current governance and access confirmation, because the legacy operator domain now includes extensive unrelated gambling content and is not reliable current operator evidence. The on-site veterans memorial and nearby library/auditorium are not additional inferred museum branches. No closure or not_museum conclusion follows from website contamination.')
identity('CRAWFORD_MO',['826b2713-db91-4819-813b-9d69e9f26cd8','8402900678'],['canonical','same_site'])
decision('826b2713-db91-4819-813b-9d69e9f26cd8','CRAWFORD_MO')
preferred('826b2713-db91-4819-813b-9d69e9f26cd8','CRAWFORD_MO','Crawford County Historical Society Museum')

evidence('CRAWFORD_WI',['crawford_wi_state'],
 'Pending: Wisconsin Historical Society gives the source address 17933 State Highway 27 South, Mount Sterling, with named local officers, but separately lists Hauge Norwegian History Center resources at Ferryville/Town of Freeman, two miles west of Rising Sun on County Road B, open by appointment for genealogical research. The source-to-visitor-site relationship, museum role/current public name and operating scope are unresolved. Retain the record and unknown affiliation; do not rename or relocate it from an ambiguous directory resource section. State affiliate membership represents support/networking, not demonstrated common museum ownership. Follow-up: official site/collection and operator relationship to Hauge Center.')
decision('8405500383','CRAWFORD_WI')

evidence('CRAWFORD_IL',['illinois_museum_directory','crawford_il_chamber','irs_il'],
 'The state museum directory (PDF physical page 14) explicitly joins Crawford County Historical Society PO Box 554 Robinson to the actual 408 South Cross site. This reconciles IMLS EIN 370913492 with the clean Overture museum. The chamber calls it Crawford County Historical Society Museum. Isolate IMLS 8401701082, which combines that Robinson physical address with EIN 371236980 and PO Box 87 Palestine. IRS identifies the second legal row with sort-name Palestine Preservation Society; the state directory separately places its Fife Opera House at 125 South Main, Palestine (page 21). The IRS records share exemption group 9411 (central/subordinate), so they are not evidence of unrelated legal status or proof of common museum ownership. Pending: practical governance/ownership between Robinson and Palestine and provider correction. Keep the mixed row uncounted without disputed aliases and do not invent a Fife institution from it.')
identity('CRAWFORD_IL',['e53b9219-4540-45f8-9bc1-8b6e20800951','8401700986','8401701082'],['canonical','mailing_address','source_conflict'],['robinson_museum','robinson_museum','unresolved_source'])
decision('e53b9219-4540-45f8-9bc1-8b6e20800951','CRAWFORD_IL')
decision('8401701082','CRAWFORD_IL')
preferred('e53b9219-4540-45f8-9bc1-8b6e20800951','CRAWFORD_IL','Crawford County Historical Society Museum')

evidence('CRAWFORD_MI',['crawford_mi_home','crawford_mi_board'],
 'One Crawford County Historical Museum at 97 East Michigan Avenue, Grayling, mailing PO Box 218. The current operator contacts match IMLS and the Overture museum; its page metadata and source name identify the public museum name. The society treasurer letter in the county December 14, 2023 board packet, physical PDF page 29, explicitly identifies the society board and president managing museum building upgrades. The scanned page was visually inspected. Reconcile the two source records to the museum Overture row and independent local society; county support is not common ownership. Current operator hours are Friday and Saturday 10-4, closing October 1; search excerpts with older Tuesday-Saturday hours are stale. Recheck visitor access before publication.')
identity('CRAWFORD_MI',['502fa6d4-d462-42b4-9d1e-790557ddcbdc','8402600322'],['canonical','same_site'])
decision('502fa6d4-d462-42b4-9d1e-790557ddcbdc','CRAWFORD_MI','independent','verified')
preferred('502fa6d4-d462-42b4-9d1e-790557ddcbdc','CRAWFORD_MI','Crawford County Historical Museum')

evidence('CRAWFORD_GA',['crawford_ga_home','crawford_ga_pottery','crawford_ga_indians','crawford_ga_jail'],
 'Pending: the operator matches PO Box 622 Roberta and describes its nonprofit historical society, administrative office/pottery museum and plans to move exhibits to the restored old courthouse. It also lists Museum of Southeastern Indians and the Old Jail. The pages carry a January 2018 update, and their current site membership, governance/access and whether the named museums are separate institutions or one campus are unresolved. Retain the counted society record without an unsupported merge, name override, chain or not_museum decision. Follow-up: current addresses, completed moves/restoration, operational ownership and museum counting scope.')
decision('8401300136','CRAWFORD_GA')

evidence('CRAWFORD_PA_ARCHIVE',['crawford_pa_contact','crawford_pa_archive','crawford_pa_repository','crawford_pa_about','https://www.irs.gov/pub/irs-soi/eo_pa.csv'],
 'The generic IMLS society row is its former 411 Chestnut Street research archive/administrative address, documented in the 2012 state genealogical repository guide. Current operator pages and exact EIN 251099964 identify the office/archive and store at 869 Diamond Park, mailing PO Box 871, separately from named museums at Terrace/Chestnut and other sites. Affirmatively exclude this umbrella/archive record as not_museum in the institution count, while preserving the society-operated museums separately. This is not a conclusion that the society operates no museums; it prevents counting the administrative/archive parent as another museum. No inference is made from an IRS absence or mailbox.')
decision('8404201097','CRAWFORD_PA_ARCHIVE',status='verified',category='not_museum')

evidence('CRAWFORD_PA_BALDWIN',['crawford_pa_contact','crawford_pa_baldwin','crawford_pa_home','crawford_pa_repository','https://www.irs.gov/pub/irs-soi/eo_pa.csv'],
 'One Mount Hope: The Baldwin-Reynolds House Museum at 639 Terrace Street, owned and operated by Crawford County Historical Society since 1963. Select the currently uncounted Terrace Overture point as canonical; the 411 Chestnut museum Overture row uses the former society archive address and becomes mislocated support, not a second museum. Isolate IMLS 8404201088: its museum name/URL and archive physical address are combined with Meadville Public Library legal name/EIN 250990592 and 848 North Main mailing address, confirmed by IRS. The conflicting library row gets its own uncounted ID and contributes no aliases. Keep full three-member baseline membership. The museum shares a documented operator with Johnson-Shaw and other named museums; tag common affiliation while preserving institutions. Pending on the isolated source: provider legal/address correction. Current source point is retained but not certified as a publication entrance.')
identity('CRAWFORD_PA_BALDWIN',['1583cde5-a948-4caf-b7c0-28cb8ed9bf64','ca965b2e-bec6-4a25-8686-2a92efee3f25','8404201088'],['reselected_canonical','mislocated','source_conflict'],['baldwin_terrace','baldwin_terrace','unresolved_source'])
decision('1583cde5-a948-4caf-b7c0-28cb8ed9bf64','CRAWFORD_PA_BALDWIN','chain','verified',chain='crawford_county_pennsylvania_historical_society')
decision('8404201088','CRAWFORD_PA_BALDWIN')
preferred('1583cde5-a948-4caf-b7c0-28cb8ed9bf64','CRAWFORD_PA_BALDWIN','Mount Hope: The Baldwin-Reynolds House Museum')

evidence('CRAWFORD_PA_JOHNSON',['crawford_pa_johnson','crawford_pa_contact','crawford_pa_home','crawford_pa_about'],
 'One Johnson-Shaw Stereoscopic Museum at 423 Chestnut Street, Meadville. Two IMLS records have the same EIN 233062207 and museum address/domain, but one point is displaced; reconcile both with the clean Overture visitor-site row. The current historical-society operator lists this named museum in its portfolio and provides its staff contact, visitor address and April-November Saturday hours, establishing common operating affiliation with the separately counted Baldwin-Reynolds museum. Preserve the full three-row source membership, old telephone/mailing alternatives and coordinates. Absence of the former EIN from the current IRS extract is not used as closure evidence.')
identity('CRAWFORD_PA_JOHNSON',['6eefcd2e-0ef9-46ef-871b-d88eb2c0f35c','8404200894','8404200168'],['canonical','same_site','mislocated'])
decision('6eefcd2e-0ef9-46ef-871b-d88eb2c0f35c','CRAWFORD_PA_JOHNSON','chain','verified',chain='crawford_county_pennsylvania_historical_society')

assert len({k for i in spec['identities'] for k in i['keys']})==sum(len(i['keys']) for i in spec['identities'])
assert len({d['key'] for d in spec['decisions']})==len(spec['decisions'])
(p/'decisions_spec.json').write_text(json.dumps(spec,indent=2),encoding='utf-8')
print({'identity_rows':sum(len(i['keys']) for i in spec['identities']),'identity_cases':len(spec['identities']),'decisions':len(spec['decisions']),'names':len(spec['names'])})
