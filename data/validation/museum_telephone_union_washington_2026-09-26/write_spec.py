"""Create a reviewable proposal; apply.R alone changes live decision inputs."""
import csv, json
from pathlib import Path
p = Path(__file__).parent
spec = {'evidence': {}, 'identities': [], 'decisions': [], 'names': [], 'human_review': [],
        'replace_identity_cases': ['Union_County_IL'], 'replace_decision_keys': []}
prior = {r['source_id'] for r in csv.DictReader((p/'museum_decisions_before.csv').open(encoding='utf-8-sig'))}
def case(code, key, url, note, *, keys=None, roles=None, case_id=None, group=None,
         aff='unknown', status='pending', chain=None, name=None, action=None):
    spec['evidence'][code] = {'url': url, 'note': note + ' Evidence packet: data/validation/' + p.name + '; source fields and coordinates retained.'}
    if keys:
        spec['identities'].append({'case': code, 'case_id': case_id or 'TUW_'+code,
            'keys': keys, 'roles': roles,
            'groups': [(group or code.lower()) + ('_former' if r == 'former_site' else '') for r in roles]})
    spec['decisions'].append({'case': code, 'key': key, 'aff': aff, 'status': status,
                              'chain': chain, 'category': 'not_flagged'})
    if key in prior: spec['replace_decision_keys'].append(key)
    if name: spec['names'].append({'case': code, 'key': key, 'name': name})
    if action: spec['human_review'].append({'case': code, 'source_id': key,
        'status': 'pending', 'action': action, 'evidence_url': url})

case('TELEPHONE_ME', '8f64cf55-4a72-416e-bddb-f5b203ef486f', 'https://thetelephonemuseum.org/news/',
     'The operator identifies its museum at 166 Winkumpaugh Road, matching both source descriptions and domain. The IMLS street is in its mailing fields with a displaced coordinate; it does not establish another site. The 2026 seasonal program, working exhibits and president of the New England Museum of Telephony establish one locally governed volunteer museum. Collaboration with the Seattle museum is not common ownership. Consolidate the pair; seasonal opening ends in September and visitor access must be rechecked for publication.',
     keys=['8f64cf55-4a72-416e-bddb-f5b203ef486f','8402300020'], roles=['canonical','mailing_address'], aff='independent', status='verified')
case('TELEPHONE_GA', 'cbbf5b38-52ca-497d-890e-1ebac163a768', 'https://www.telecompioneers.org/',
     'Overture describes Telephone Museum at 675 W Peachtree Street, Atlanta, without an operator URL. Historical and travel-directory leads associate it with a telephone-company museum, but no reliable current operator evidence established continued operation, closure or relocation. The Pioneers parent site is a research lead, not evidence that this specific source belongs to that organization. Retain unknown affiliation and pending status; no exclusion or closure is inferred from search absence.',
     action='Obtain current operator or building-owner evidence for the Atlanta 675 W Peachtree telephone collection, including location, museum scope, access and governing parent; verify any claimed closure or relocation.')
case('TELEPHONE_TX', '8404800048', 'https://www.telecompioneers.org/',
     'IMLS describes the Houston telephone museum at 1714 Ashland with an old museum domain and no EIN. Secondary reports suggest closure or relocation and a telephone-volunteer connection, but no current primary source establishes the disposition of this collection. The parent website is only a research lead. Preserve the row and uncertainty; do not substitute another Texas museum or mark the source closed from directory text.',
     action='Resolve the Houston collection formerly at 1714 Ashland through its operator/property custodian, including the suggested Bellaire move, current governance, exhibitions and access.')
case('TELEPHONE_MA_OVT', '3b0a337a-1535-4a1a-a9b9-cc80ced83338', 'https://www.lexingtonma.gov/DocumentCenter/View/2502/Stone-Building-Final-Report-PDF?bidId=',
     'The town 2022 Stone Building report PDF page 56 is a proposal by Vincent Valentine using the source museum domain and phone, seeking space for artifacts and teaching. It is not evidence that the proposal was accepted. Overture gives 1661 Massachusetts Avenue number 488; current operator text describes educational and digital activity without resolving a visitor gallery. IRS EIN 901113082 names the same proponent and Lincoln PO Box 643, but the IMLS EIN differs. Retain both Massachusetts source identities pending rather than inventing a public site or inferring not_museum from a mailing address.',
     action='Document the current physical museum and legal/address history connecting Lexington number 488, Lincoln PO Box 643 and the differing EIN; obtain the Stone Building proposal outcome and current visitor access.')
case('TELEPHONE_MA_IMLS', '8409400650', 'https://telephone-museum.org/about/',
     'IMLS legal name The Telephone Museum Inc and PO Box 643 Lincoln resemble current IRS name/mail fields, but its EIN 001082436 differs from current IRS 901113082. The operator about page does not resolve the discrepancy or physical location. Leave this source separate from the Lexington record pending primary legal/source provenance; matching name and mailbox alone do not settle the conflicting identifier.',
     action='Resolve IMLS EIN 001082436 versus IRS 901113082 and confirm whether this is the same institution as the Lexington source before merging or changing museum status.')
case('TELEPHONE_WV', '9abeaf89-2d00-4142-ac48-e5d853225ab2', 'https://marioncvb.com/company/telephone-museum/',
     'The county visitor bureau confirms a telephone-history collection and guided tours at 214 Monroe Street, Fairmont, matching Overture. This supports museum scope and location. It does not establish current ownership or whether a telephone-company/Pioneers network controls this institution. Leave affiliation and complete factual review pending; historical founders are not treated as proof of current parent control.',
     action='Obtain current legal/operator governance for the Fairmont museum and distinguish local volunteers from any multi-museum parent; recheck appointments and visitor point.')

case('WASHINGTON_MO', 'a2a013bd-c40d-4a08-abe5-57ca44154440', 'https://washmohistorical.org/about-us/',
     'The operator documents one museum and integrated research library at 113 E Fourth Street under its elected local trustees. Both source descriptions use the operator domain; IRS EIN 431259237 connects the IMLS society to that current street. Consolidate the Overture physical description and IMLS PO Box 146 description. Preserve the society public label rather than replacing it with the generic webpage heading History Museum. One independently governed museum campus is supported.',
     keys=['a2a013bd-c40d-4a08-abe5-57ca44154440','8402900387'], roles=['canonical','mailing_address'], aff='independent', status='verified')
case('WASHINGTON_IL', '0238dc29-0af9-4018-a940-1c69babb73d4', 'https://washingtonilhs.com/wp-content/uploads/2021/02/history-of-WHS-012921.pdf',
     'The society history explicitly documents the former Dement-Zinser museum and its November 2020 purchase of 128 Washington Square for offices, archives and displays. The current operator homepage confirms 105 Zinser is again a private family home and gives 128 Washington Square/PO Box 54, matching IMLS EIN 363495031 and IRS. Reconcile former and current descriptions, retaining the current source canonical. Own officers and board support independence, but current permanent curated exhibition scope at 128 remains pending; public hours and occasional exhibits alone do not complete that question.',
     keys=['0238dc29-0af9-4018-a940-1c69babb73d4','8401700698'], roles=['canonical','former_site'], aff='independent',
     action='Confirm current curated museum displays and visitor arrangements at 128 Washington Square after the Dement-Zinser house became a private residence; distinguish archive/event space from a continuing museum.')
case('WASHINGTON_NH', '511d6c9e-0b9b-48ae-9411-50c5d1a9a999', 'https://www.wnhhs.org/museums',
     'The operator explicitly maintains its main museum and barn together at 100 Halfmoon Pond Road, matching Overture, and a separate furnished District 5 Schoolhouse museum at 2570 East Washington Road. The barn is part of the main campus, not another institution there. Record common parent affiliation washington_new_hampshire_historical_society without merging the separately located schoolhouse or inventing an additional source row. The published summer season ends at Labor Day; appointments require recheck.',
     aff='chain', chain='washington_new_hampshire_historical_society', status='verified')
case('WASHINGTON_ME', '8402300363', 'https://www.washingtonhistorical.org/razorville-hall-museum/',
     'The local operator describes curated Razorville Hall displays and its bylaws establish member/officer governance. The town 2023 annual report PDF page 50 documents museum visits and further displays planned for the Old Town House. These sources do not settle whether the IMLS PO Box 408 description represents the same integrated campus, a parent or a separate site; the current society mailbox differs. Preserve the IMLS description and unresolved affiliation/count scope rather than assigning its mailbox to a selected building.',
     action='Bridge IMLS EIN 020627108/PO Box 408 to the current society and determine the current museum-count relationship of Razorville Hall and Old Town House, their locations and access.')
case('WASHINGTON_NY', '8403602191', 'https://www.millbrookhistoricalsociety.org/contact',
     'Current operator contact at Village Hall, 35 Merritt Avenue and PO Box 135 matches IMLS. IRS EIN 320052695 now names Millbrook Historical Society, confirming continuity with the IMLS Town of Washington society. Apply the current public name and independently governed board evidence. Current archives, an outdoor interpretive trail and a temporary library exhibition are documented, but curated museum scope for this source remains unresolved. A name correction is not a completed museum review or an exclusion.',
     aff='independent', name='Millbrook Historical Society',
     action='Establish whether the Village Hall source represents a currently curated museum, archives, or the outdoor interpretation program; document collection/display access and counting scope before any exclusion or certification.')

case('UNION_OH', '59527f3f-99ff-4f83-b235-2d5f3b11f93b', 'https://www.uchsohio.org/Museum',
     'The operator documents its ownership of the Morey house at 246 W Sixth Street, a restored museum with an integrated annex and local-history collections. This matches the baseline physical/IMLS society descriptions. The Ohio Genealogical Society May 9 2026 program identifies Robert W Parrott as the society president; IRS EIN 316050290 identifies the local organization. One locally governed museum is supported. Promotion of other county open-house events does not establish ownership of those sites. Preserve the existing baseline pair and mark the factual review complete.',
     aff='independent', status='verified')
case('UNION_GA', 'cc2a936a-b634-4b3b-a818-7ee5859ab8f2', 'https://www.unioncountyhistory.org/',
     'The operator explicitly names Old Courthouse Museum on Town Square and Mountain Life Museum at the separate Veterans Memorial Drive campus; its board controls both. Apply Old Courthouse Museum to the already reconciled society/courthouse group and record union_county_georgia_historical_society affiliation. The additional generic town-square record has inconsistent street context, and the Heritage Center/Mountain Life descriptions still need exact source-role resolution. Do not merge those rows from proximity or the shared operator alone; overall review stays pending.',
     aff='chain', chain='union_county_georgia_historical_society', name='Old Courthouse Museum',
     action='Resolve Overture generic Town Square/62 Blue Ridge record and Heritage Center versus Mountain Life campus membership; retain the two documented museum campuses separately and verify visitor points.')
case('UNION_IN', '8401800453', 'https://uchistory.org/about-2/',
     'The society operator describes its Depot Museum, Templeton Cabin and Waterworks displays at separate sites. Record union_county_indiana_historical_society affiliation for this umbrella source. Its IMLS 488 S County Road 10 mailing context, current IRS PO Box 143, Depot at 1 Liberty Street and another Overture museum at 156 E County Road 300 S have not been individually bridged. Keep identity/count pending; neither ownership of multiple properties nor the society name assigns an umbrella record to a chosen museum. The active church is not automatically a museum.',
     aff='chain', chain='union_county_indiana_historical_society',
     action='Resolve the umbrella IMLS record and rural-address Overture museum against the Depot, Cabin and Waterworks institutions; establish current museum scope/access and preserve separate campuses.')
case('UNION_IL', 'e7510f8e-0832-445f-9683-c41138639bf9', 'https://www.unioncountyilmuseum.com/',
     'The operator expressly traces the Cobden Museum collection to its 2006 donation and reopening as Union County Museum in the DuBois building. Extend the earlier two-row case to retain the old Cobden description as a former-site supporting row, with one current institution and the supported public name. Preserve the prior case ID and site group. The independently governed society also acquired 103 N Appleknocker for a research/cultural center with planned special exhibits; undated pages do not settle its current museum role. Overall review remains pending and affiliation unknown until that separate-site scope is resolved. Original source points are not validated visitor coordinates.',
     keys=['e7510f8e-0832-445f-9683-c41138639bf9','8401701115','45b47613-6224-41a1-8c7c-dbf1f7f8139e'], roles=['canonical','mailing_address','former_site'], case_id='Union_County_IL', group='il', name='Union County Museum',
     action='Confirm current exhibition versus research-only role of the 103 N Appleknocker resource center, and validate the Union County Museum visitor point at 117 S Appleknocker; do not publish old source coordinates as checked locations.')
case('UNION_PA', '020cc712-f2e4-47a4-aa1e-8d83179974b6', 'https://www.unioncopahistory.com/facilities',
     'The operator owns the Dale-Engle-Walker house museum and acquired the separate Packwood/Annex campus in 2023; the Annex gallery now has exhibits while the former Packwood building is planned for a future Union County Museum. Record union_county_pennsylvania_historical_society affiliation. The source society/library at 103 S Second Street is not assigned to a selected museum, and the existing Packwood source is not silently relabelled as already reopened. Retain pending review for current source roles and transitions.',
     aff='chain', chain='union_county_pennsylvania_historical_society',
     action='Resolve the 103 S Second Street library/parent source and current Packwood/Annex reopening and count scope; preserve Dale-Engle-Walker as a separate campus and obtain current public access.')
case('UNION_OR', '8404100121', 'https://unioncountymuseum.org/',
     'Preserve the earlier documented mixed source context: IMLS uses Union County Historical Society EIN 010975044 at the museum street with La Grande PO Box 3361; the automatic group also contains Historical Treasure EIN 930836487, while the museum operator has separate EIN 237031662. This pass establishes no additional primary bridge among those organizations. Retain the existing identity and pending unknown affiliation. Do not equate a shared address or county name with common ownership.',
     action='Resolve original source/legal membership for the Oregon society, Historical Treasure and museum operator, including the mixed street/mail fields and distinct EINs, before any merge, exclusion or count certification.')
case('UNION_NC', '8403700530', 'https://www.unioncountync.gov/',
     'Current cached IRS EIN 561400088 retains the Monroe society name and PO Box 397, matching IMLS. This is legal/mail continuity, not evidence of a current public museum. No current primary museum/operator bridge was established for the source; county government is a research lead, not a verified owner. Preserve pending unknown affiliation and the existing source, without substituting another Union County museum or inferring not_museum from a mailbox.',
     action='Obtain current society museum/collection location, curated exhibition scope, governance and visitor access for EIN 561400088; distinguish the preservation commission and other county museums.')

(p/'decisions_spec.json').write_text(json.dumps(spec,indent=2),encoding='utf-8')
for fn,rows,fields in [('evidence.csv',[dict(case=k,**v) for k,v in spec['evidence'].items()],['case','url','note']),('human_review.csv',spec['human_review'],['case','source_id','status','action','evidence_url'])]:
    with (p/fn).open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
old=Path('data/validation/museum_franklin_heritage_newton_2026-09-26/apply.R').read_text()
t=old.replace('museum_franklin_heritage_newton','museum_telephone_union_washington')
t=t.replace("identity <- function(case,keys,roles,groups=rep(tolower(case),length(keys))) {", "identity <- function(case,keys,roles,groups,case_id) {")
t=t.replace("case_id=paste0('FHN_',case)", "case_id=case_id")
t=t.replace('unlist(s$groups))))', 'unlist(s$groups),s$case_id)))')
t=t.replace('ids <- dplyr::bind_rows(ids,added)', "replaced_cases <- unlist(spec$replace_identity_cases)\nstopifnot(all(replaced_cases%in%ids$case_id))\nold_replaced <- ids[ids$case_id%in%replaced_cases,]\nstopifnot(all(old_replaced$source_id%in%added$source_id))\nids <- dplyr::bind_rows(ids[!ids$case_id%in%replaced_cases,],added)")
t=t.replace("stopifnot(!any(new_decisions$source_id%in%decisions$source_id))\ndecisions <- dplyr::bind_rows(decisions,new_decisions)", "replace_keys <- unlist(spec$replace_decision_keys)\nstopifnot(setequal(intersect(new_decisions$source_id,decisions$source_id),replace_keys))\ndecisions <- dplyr::bind_rows(decisions[!decisions$source_id%in%replace_keys,],new_decisions)")
assert "stopifnot(!any(new_decisions$source_id%in%decisions$source_id))" not in t
(p/'apply.R').write_text(t)
(p/'pdf_visual_review.md').write_text('''# PDF evidence inspection — 2026-09-26

- Lexington Stone Building report PDF page 56 (printed 55): visually inspected the Telephone Museum proposal, proponent/domain/phone and conditional request. No completed tenancy is asserted.
- Washington Maine 2023 annual report PDF page 50 (printed 49): visually inspected society museum visits and proposed Old Town House displays. These are dated observations, not a 2026 operating guarantee.
- Washington Illinois society history PDF page 1: visually inspected former museum and November 2020 acquisition/move description. Current scope remains pending.

Rendered PNGs retained beside this log. No illegible evidence or obscuring render defects observed.
''',encoding='utf-8')
print('Proposed',sum(len(s['keys']) for s in spec['identities']),'identity rows in',len(spec['identities']),'cases;',len(spec['decisions']),'decisions;',len(spec['names']),'names;',len(spec['human_review']),'pending; replacements',len(spec['replace_decision_keys']))
