"""Build the reviewed proposal, without modifying live inputs."""
import json
from pathlib import Path

p = Path(__file__).parent
spec = {'evidence': {}, 'identities': [], 'decisions': [], 'names': [], 'human_review': []}

def case(code, url, note, keys=None, roles=None, groups=None, key=None,
         name=None, aff='independent', status='verified', chain=None,
         category='not_flagged', action=None):
    spec['evidence'][code] = {'url': url, 'note': note + ' Evidence packet: data/validation/' + p.name + '; original source fields and coordinates retained.'}
    if keys:
        spec['identities'].append({'case': code, 'keys': keys, 'roles': roles,
                                  'groups': groups or [code.lower()] * len(keys)})
        key = key or keys[0]
    spec['decisions'].append({'case': code, 'key': key, 'aff': aff, 'status': status,
                              'chain': chain, 'category': category})
    if name:
        spec['names'].append({'case': code, 'key': key, 'name': name})
    if action:
        spec['human_review'].append({'case': code, 'source_id': key, 'status': 'pending', 'action': action, 'evidence_url': url})

case('MADISON_NH', 'https://www.madisonnhhistoricalsociety.org/about.html',
     'The operator and its signed report in the 2023 town annual report (PDF page 116) link Madison Historical Society Museum, 19 East Madison Road and PO Box 505. The town owns the original town hall; the local society board runs the museum. IRS EIN 026013118 agrees. The Rt. 113 Madison Corner Overture row points to the old Madison town website but is misplaced in Tamworth. Consolidate the three records. The separately described Madison Corner School restoration is a preservation project, not an established second museum. Summer hours and appointments require recheck before visitor publication.',
     ['e64db9ed-4c66-4d35-96b8-5a3504133196','4f5df17f-c080-4993-b107-8e7018d1c57f','8403300249'],
     ['canonical','mislocated','mailing_address'], name='Madison Historical Society Museum')
case('MADISON_CT_LEE', 'https://www.madisonhistory.org/bylaws/2025-strategic-plan/',
     'The society strategic plan approved May 20, 2025 expressly identifies Lee\'s Academy as headquarters, administrative office, archives and public exhibition center. Attach the generic IMLS PO Box 17 record (EIN 066038865, matching IRS) to this headquarters at 14 Meetinghouse Lane. Preserve the separately operated Allis-Bushnell House Museum at 853 Boston Post Road; both have public exhibitions and separate hours, under one society board. The Smallpox Burying Ground is not inferred to be another museum. Use the public visit-page name without the parenthetical operator suffix.',
     ['3f349f47-5ac7-404e-861e-6dd74c75c10a','8400900306'],['canonical','mailing_address'],
     name="Madison Center for Culture & History at Lee's Academy",aff='chain',chain='madison_connecticut_historical_society')
case('MADISON_CT_ALLIS','https://www.madisonhistory.org/bylaws/2025-strategic-plan/',
     'The same operator plan identifies the Allis-Bushnell House as an interpreted historic house museum, distinct from the Lee\'s Academy headquarters/exhibition center. Current town June 2026 event listing uses Allis-Bushnell House Museum, 853 Boston Post Road. Retain one separate institution with the same society affiliation; do not collapse the two public museum sites or count the cemetery as another museum.',
     key='6e3a1797-06d7-4c68-9d06-8ea6f95c728e',name='Allis-Bushnell House Museum',aff='chain',chain='madison_connecticut_historical_society')
case('MADISON_LA','https://www.museumsusa.org/museums/info/21666',
     'The museum profile links Hermione Museum at 315 N Mulberry Street, PO Box 268 and Madison Historical Society ownership, elected officers and board. IRS EIN 721258830 repeats PO Box 268 care of the profile\'s assistant curator John Earl Martin. LSU AgCenter\'s 2021 parish guide (PDF page 11) confirms the society museum at 315 Mulberry. Consolidate the society mailbox and two museum descriptions. Overture says 305 rather than 315; retain that original value, with the exact visitor point needing export review. Native profile download timed out, but the substantive web-rendered profile was inspected and a paraphrased observation saved; the separate tourism page failed certificate verification and was not used.',
     ['c959f19d-692a-4f22-80a4-cbd0f56ed903','8402200065','8402200310'],['canonical','same_site','mailing_address'])
case('MADISON_NJ','https://www.madisonnjhistoricalsociety.org/museum',
     'The current operator identifies 39 Keep Street as its research office in Madison Public Library, with a Local History Center, collections and programs. Its museum page and April 2026 fundraising report explicitly describe the separate Madison History Museum as planned for 2027 in the Hartley Dodge Memorial east wing. Exclude this research-office record as not_museum at this checkpoint; do not treat a future museum as already open. The local board and IRS EIN 237409331/PO Box 148 support independent society governance. This does not exclude the separately operated Museum of Early Trades and Crafts or any later newly opened museum.',
     key='8403400620',category='not_museum')
case('MADISON_NY','https://www.madisoncounty.ny.gov/DocumentCenter/View/1000/The-Madison-County-History-Trail-PDF?bidId=',
     'County history trail (PDF page 2) and current county directory identify Town of Madison Historical Society, 3606 South Street, PO Box 393. IRS EIN 161542854 uses that full legal name and mailbox. Apply the supported name rather than conflating it with the county society at Cottage Lawn in Oneida. The trail photograph shows the building, but current curated museum scope, access and operator governance still require direct evidence; preserve the counted row and leave overall/affiliation review pending.',
     key='8403601538',name='Town of Madison Historical Society',aff='unknown',status='pending',
     action='Confirm current exhibitions, visitor access and governance at 3606 South Street with the town/society; distinguish museum from meeting or research space.')
case('MADISON_OH_CURRENT','https://madisonohiohistoricalsociety.org/about/',
     'Current operator describes its purchased permanent home at 126 W Main Street since July 2020, after several temporary locations; it gives PO Box 515, museum hours and its independent executive board. The chamber confirms the current museum. Native operator downloads returned 403; web-rendered operator text was inspected. The two older IMLS records at 13 W Main and 45 N Lake share a baseline entity, but their exact historical address roles have not been bridged by a primary record. Leave current and old entity separate and overall review pending despite the sourced independent affiliation.',
     key='79d48647-afd8-4d44-87c1-37a471ff77a8',status='pending',
     action='Find a dated operator or municipal record connecting 13 W Main and 45 N Lake to the society that moved to 126 W Main in 2020 before consolidating all three rows.')
case('MADISON_OH_OLD','https://madisonohiohistoricalsociety.org/about/',
     'IMLS 8403900089 (13 W Main) and 8403900960 (45 N Lake, EIN 341301854, PO Box 515) share a baseline entity. IRS and current operator retain PO Box 515, but the exact former-site/address history is not yet primary-sourced. Preserve both source rows and the baseline relationship, without merging into the current 126 W Main institution or marking the old group verified. No exclusion is inferred from old addresses or 403 responses.',
     key='8403900960',aff='unknown',status='pending',
     action='Resolve each old street address and date against society/municipal records; retain both rows until their roles are established.')
case('MARION_OH','https://www.marionhistory.com/',
     'The operator identifies Heritage Hall at 169 E Church Street, matching both source descriptions and IRS EIN 237403820. Consolidate the two rows and use the public museum name. The operator separately documents its ownership and public operation of Linn School at 2473 Marion-Bucyrus Road and donated historic structures at the fairgrounds. Apply society affiliation to Heritage Hall. Wyandot Popcorn Museum shares the building but has separate EIN 341491155; do not merge it into Heritage Hall from co-location. No Linn School or John Ford Home museum row was found in the unchanged baseline by exact-name inspection; do not invent source records.',
     ['1d29d4f1-1a7f-44f8-b0f9-fdac2b74004f','8403900382'],['canonical','mislocated'],
     name='Heritage Hall',aff='chain',chain='marion_county_ohio_historical_society')
case('MARION_OH_POPCORN','https://www.marionhistory.com/explore/wyandot-popcorn-museum/',
     'Operator-hosted exhibit history identifies Wyandot Popcorn Museum at Heritage Hall, relocated from the Wyandot company in 1989. Current IRS EIN 341491155 uses 169 E Church Street and George Brown, connecting the older IMLS same-named record at 3453 Mautz Yeager Road to the public Overture museum. Consolidate its two descriptions, retaining its institution separately from Heritage Hall. The separate legal organization and shared visitor operation leave the precise current affiliation/ownership relationship unresolved; do not assume independence or common ownership from co-location.',
     ['7765f614-0bdc-4e58-ba16-62708537b500','8403901035'],['canonical','mailing_address'],aff='unknown',status='pending',
     action='Obtain current Wyandot Popcorn Museum governance/ownership or operating agreement to determine whether it is independent or affiliated with the historical society.')
case('MARION_IA','https://www.marioncountyhistory.org/index.php/contact/index.html',
     'Operator contact page links PO Box 21 to its Historical Village, volunteer president/curator and public tours. Its board/history pages describe society operation of the single village campus. County park materials locate it at 306 Willetts Drive and distinguish the society lease from county park management; IRS EIN 421066795 matches the mailbox. Use Marion County Historical Village as its public name and independent society affiliation. The village buildings form one museum campus. The IMLS point is a mailing location; a sourced visitor coordinate must be supplied before map publication.',
     key='8401900355',name='Marion County Historical Village')
case('MARION_AL','https://mcalhs.org/',
     'Current operator establishes the county historical society but provides no primary address-to-museum link for IMLS PO Box 492, Hamilton, EIN 352278120. IRS now lists a Hackleburg contact. The Hamilton-Sullins House is a plausible museum operated with the city, described in the Encyclopedia of Alabama and a 2025 local news report, but a specific primary bridge to this source and current visitor operation remains missing. Preserve the row pending; neither the mailbox nor sparse website justifies not_museum.',
     key='8400100188',aff='unknown',status='pending',
     action='Obtain society/city confirmation linking EIN 352278120 and old PO Box 492 to Hamilton-Sullins House, including current site address, ownership and museum access.')
case('MARION_OR','https://www.willametteheritage.org/organizational-history/',
     'Current operator expressly documents the 2010 merger of Marion County Historical Society and Mission Mill Museum into Willamette Heritage Center. The old society museum occupied the mill store on this campus; its collection now forms the center archives. IMLS Mission Mill and current center share EIN 936031792, also current IRS, at 1313 Mill Street SE. Consolidate all four descriptions as one museum campus with the current public name and independent nonprofit governance. The old society 260 12th Street listing is retained as the predecessor campus contact, not a second institution or an unsupported historical-name hold.',
     ['0573c6fb-46d1-488c-a613-4d35eba03bae','8404100562','8404100061','8404100561'],['canonical','same_site','same_site','same_site'])
case('MARION_GA','https://www.columbusstate.edu/archives/findingaids/mc327.php',
     'University archival history documents successive Pasaquan custodians: Marion County Historical Society, Pasaquan Preservation Society, Kohler Foundation restoration, then a 2015 deed to Columbus State University Foundation. Smithsonian\'s 1993 artwork survey explicitly connects the former society to PO Box 564, matching IMLS; its native 403 is recorded, while the indexed catalog text was inspected. Consolidate that old operator mailbox, the preservation-society row at 238 Eddie Martin Road and Overture St Eom\'s Pasaquan. Current university site gives public hours/address, and art-department directory identifies a shared director with the separately located Bo Bartlett Center. Record university affiliation and current name Pasaquan; retain all predecessor evidence.',
     ['cb40c1f9-e78b-4bb7-aadb-c7d3c5a70db7','8401300292','8401300511'],['canonical','same_site','mailing_address'],
     name='Pasaquan',aff='chain',chain='columbus_state_university')
case('MARION_MO','https://www.jimsjourney.org/mission-leadership-and-partners',
     'Jim\'s Journey thanks the county society for giving up space in the Old Welshman House at 509 N Third Street. This does not identify what the IMLS society contact at 5021 College Avenue (EIN 431170017) currently represents. Preserve it pending specific museum/operator evidence. Do not merge it into Jim\'s Journey, Hannibal History Museum or Molly Brown Birthplace from historical support or shared locality; no exclusion is inferred from IRS absence or failed searches.',
     key='8402900356',aff='unknown',status='pending',
     action='Confirm the present role of the society at 5021 College Avenue and whether its collections operate as a museum or were transferred to another named institution.')
case('MARION_MS','https://www.mshumanities.org/event/crossroads-columbia-main-street-historic-tour/',
     'Mississippi Humanities Council\'s 2021 Columbia exhibit event identifies Marion County Museum at 200 Second Street in partnership with the society. Current state historical-society directory and IRS EIN 581355410 retain 200 Second Street, matching the existing two-row baseline institution. Apply the supported museum name. State historic-property records document society ownership of John Ford House, and appropriations record later restoration support, but current operation/access at both sites remains unresolved. Leave affiliation and overall review pending; the obsolete Weebly 404 is not closure evidence.',
     key='a49eb110-5e1e-4df2-8b65-c3f07406c1f9',name='Marion County Museum',aff='unknown',status='pending',
     action='Verify present operation and access at the depot museum and John Ford Home; establish current shared ownership/operation before setting affiliation.')
case('MILTON_PA','https://www.miltonpahistoricalsociety.com/',
     'Current operator gives Cameron House at 5340 State Route 405, PO Box 5, and an elected society board; primary destination listing describes its public historical exhibits. IRS EIN 222453223 matches the mailbox. Consolidate the two descriptions at this independent local museum. The separate Milton Model Train Museum identifies TIME (The Improved Milton Experience) as its owner, with a different address and mailbox; do not infer a society chain from local promotion. Tours are by arrangement and require access recheck.',
     ['784c78cf-81bc-491d-bb40-e61c5525ac47','8404200400'],['canonical','mailing_address'],name='Cameron House')
case('MILTON_VT','https://www.miltonvthistory.org/milton-historical-museum.html',
     'Current operator names Milton Historical Museum at 13 School Street, a town-owned former church acquired in 1997 and opened as museum in 2001. Both source descriptions and IRS EIN 030270369 match. Consolidate them; society volunteer board and town support establish local independent operation. The current 2026 program advertises a Colchester schoolhouse and Georgia museum as partners operated by their separate historical societies, not additional Milton branches. Public seasonal hours end October 31, 2026 and must be rechecked for publication.',
     ['aee53e20-43b5-4cfe-a618-1fdc4d1252ce','8405000086'],['canonical','mislocated'],name='Milton Historical Museum')
case('MILTON_WI','https://miltonhouse.org/milton-house-history',
     'Museum operator states that Milton Historical Society purchased and restored Milton House, opening the museum in 1954; current board page names its staff and directors. Both IMLS descriptions share EIN 391095660, matching current IRS PO Box 245 and director Keighton Klos. Consolidate the Overture museum at 18 S Janesville Street, IMLS museum and society mailbox as one independently governed museum campus. Network to Freedom participation is designation/support, not NPS ownership. Appointment requirements remain visitor-export checks.',
     ['dffbbc6f-758a-4ba5-bc5f-fb54af1cae48','8405500074','8405500368'],['canonical','same_site','mailing_address'])
case('MILTON_MA','https://www.miltonhistoricalsociety.org/suffolk-resolves-house',
     'Current operator explicitly identifies society ownership by bequest and public exhibits/tours at Suffolk Resolves House, 1370 Canton Avenue. IRS EIN 046038657 agrees. Consolidate the two Overture descriptions at that address as one independent museum. The separate mixed IMLS row is excluded from this accepted identity group and supplies no aliases. Preserve its conflicting physical and mailing fields for correction instead of silently treating the Delaware address as a Massachusetts site.',
     ['caef0a68-a7ac-4186-a96d-110d4bf38b41','e44e8222-e4ca-4141-be5a-3808d9ae88ab'],['canonical','same_site'])
case('MILTON_MA_CONFLICT','https://www.miltonhistoricalsociety.org/visiting',
     'IMLS 8402500617 combines Massachusetts EIN 046038657 and mailing address 1370 Canton Avenue with physical address 210 Union Street, Milton. The Massachusetts operator and IRS identify Suffolk Resolves House at Canton Avenue; the Delaware operator and destination bureau instead substantiate its museum at 210 Union Street. Isolate this contradictory row as source_conflict, uncounted with no aliases, pending source repair. This is not a not_museum decision and not a cross-state merger. A similar 210 Union field in IMLS Milton Heritage Society Iowa is a separate unreviewed audit lead, not corrected in this batch.',
     ['8402500617'],['source_conflict'],groups=['unresolved_source'],aff='unknown',status='pending',
     action='Resolve the mixed Massachusetts legal/mail identity and Delaware-like physical address in the IMLS provenance; review the analogous Iowa source separately.')
case('MILTON_DE','https://www.historicmilton.org/about/',
     'The Delaware operator describes its own board and museum in the donated former Methodist church at 210 Union Street; the primary destination bureau names it Lydia Black Cannon Museum at the same address and phone 302-684-1010. IMLS EIN 237158119 uses 210 Union and PO Box 112; its current Overture society row matches. Consolidate those with the Overture Lydia B. Cannon Museum row placed at 404 Chestnut, retaining that discrepant source point as mislocated. No second public museum at Chestnut is established. Use the complete public museum name and independent society governance; preserve the unrelated Massachusetts mixed row separately.',
     ['0ef7969b-c68c-41bf-a346-ec6ce43c1cb5','8401000036','6769d9b7-a585-47ac-a984-a6f36db60b71'],['canonical','same_site','mislocated'],name='Lydia Black Cannon Museum')

(p/'decisions_spec.json').write_text(json.dumps(spec,indent=2,ensure_ascii=False),encoding='utf-8')
print('Cases',len(spec['evidence']),'identity rows',sum(len(s['keys']) for s in spec['identities']),
      'identity cases',len(spec['identities']),'decisions',len(spec['decisions']),
      'names',len(spec['names']),'pending',len(spec['human_review']))
