"""Assemble sourced factual decisions; this does not modify live inputs."""
import json
from pathlib import Path

p = Path(__file__).parent
spec = {'evidence': {}, 'identities': [], 'decisions': [], 'names': []}

def evidence(case, urls, note):
    spec['evidence'][case] = {'url': ' | '.join(urls), 'note': note}

def identity(case, keys, roles, groups):
    spec['identities'].append(dict(case=case, keys=keys, roles=roles, groups=groups))

def decision(key, case, aff='unknown', status='pending', category='not_flagged', chain=None):
    spec['decisions'].append(dict(key=key, case=case, aff=aff, status=status, category=category, chain=chain))

def preferred(key, case, name):
    spec['names'].append(dict(key=key, case=case, name=name))

evidence('TACOMA', ['https://historictacoma.org/watchlist',
    'https://antoinettebroussard.com/wp-content/uploads/2024/05/columbiamagazinearticle-1.pdf'],
    'Pending: IMLS 8405300735 (EIN 943227432) and its baseline Overture partner identify 925 Court C, Tacoma. Historic Tacoma describes the African American Museum in the Merit Building at 951 Market/former 315 S 11th during 1996-2005; that history alone does not reconcile 925 Court C or establish current closure, relocation or governance. The author-hosted Columbia article download failed TLS validation, and no bypass was attempted. Retain the counted pair and unknown affiliation. Do not merge into Seattle NAAM, whose address and EIN differ. Human follow-up: establish the Tacoma institution address history and present status from an operator/archive source.')
decision('8405300735', 'TACOMA')

evidence('GALVESTON', ['https://www.visitgalveston.com/directory/african-american-museum/',
    'https://gamma-pi-lambda.com/james-josey/'],
    'Pending: the official destination directory identifies the house museum at 3427 Sealy Avenue and curator Clarence Josey. The fraternity chapter biography says James Josey Sr created the museum in 1999. These sources establish the named museum/address but do not resolve current management, ownership, visitor access or the founder/curator succession. Retain this institution and unknown affiliation; do not infer closure from reviews or missing hours. Human follow-up: current operator confirmation of governance, access and whether the collection remains at Sealy Avenue.')
decision('e847cc46-6a72-4405-8916-2ff27f3353ea', 'GALVESTON')

evidence('MONROE', ['https://www.monroeblackheritagemuseum.org/history',
    'https://www.monroeblackheritagemuseum.org/visit',
    'https://www.monroeblackheritagemuseum.org/board-of-directors',
    'https://www.ulm.edu/cbss/cber/documents/2006efb.pdf',
    'https://bayoulifemag.com/finishing-the-dream/'],
    'One Northeast Louisiana Delta African American Heritage Museum: its own history and board establish the locally governed institution, and its current visitor page gives 1051 Chennault Park Drive and 318-342-8889. The ULM 2006 factbook identifies the earlier 503 Plum Street/318-323-1167 museum; the 2019 operator/board interview traces the Plum Street opening to the new Chennault facility opening in August 2011. Consolidate the old Plum row as former_site and the two clean Chennault rows at one current site. Prefer the Overture row with the current operator URL and telephone. Government land/capital support is not common museum ownership. Retain original coordinates; these source points differ and are not certified publication map pins. Isolate the separate Dallas-domain Monroe row; its disputed alias does not enter this institution.')
identity('MONROE', ['f426349b-22f0-4454-9dde-fbb94a11f5f9','6f04fee0-d8f6-499f-bed2-96c1eacb1433','b77eb5bd-97e4-4369-a1d0-0dc7aaa2a019'],
    ['canonical','same_site','former_site'], ['chennault','chennault','plum_former'])
decision('f426349b-22f0-4454-9dde-fbb94a11f5f9', 'MONROE', 'independent', 'verified')

evidence('MONROE_CONFLICT', ['https://www.monroeblackheritagemuseum.org/visit','https://aamdallas.org/'],
    'Source conflict: Overture 11d33303 has Monroe address 1051 Chennault Park Drive and 318-342-8889 but the Dallas museum domain aamdallas.org. The two operators identify different cities and institutions. Preserve this mixed row with its own uncounted ID, unknown affiliation and pending review; contribute no aliases to the accepted Monroe or Dallas museum. Human follow-up: provider lineage for the misassigned website before reconsidering membership.')
identity('MONROE_CONFLICT',['11d33303-171f-4d9e-8128-3bac109e573c'],['source_conflict'],['unresolved_source'])
decision('11d33303-171f-4d9e-8128-3bac109e573c','MONROE_CONFLICT')

evidence('DALLAS', ['https://aamdallas.org/history/','https://aamdallas.org/about/',
    'https://aamdallas.org/nelson-mandela-exhibition-plan-your-visit/'],
    'One African American Museum of Dallas at 3536 Grand Avenue in Fair Park. Operator history documents independence from Bishop College in 1979 under the Foundation of African American Art and the Fair Park building opening in 1993; current leadership and the dated June 13-November 1, 2026 exhibition establish continuing museum activity. Consolidate the exact-address IMLS row and the coarse Fair Park Overture point with the current-address Overture canonical row. The IMLS 65473-8910 physical ZIP is inconsistent with Dallas 75210 and is preserved as a source anomaly; its name, street, city and EIN 751678200 identify this institution, with no separate institution supported by the ZIP alone. The site retains a stale reopening header; recheck visitor access before publication. Original source coordinates are preserved, not certified as visitor pins.')
identity('DALLAS',['3e0f85d0-3213-4bc9-a0a0-1bbccc701df5','8404801487','c26105b0-3fba-4900-8100-0c2e16e3775e'],
    ['canonical','same_site','mislocated'],['fair_park','fair_park','fair_park'])
decision('3e0f85d0-3213-4bc9-a0a0-1bbccc701df5','DALLAS','independent','verified')

evidence('BOWLING_GREEN', ['https://aambg.squarespace.com/about-us','https://aambg.squarespace.com/board-of-directors',
    'https://aambg.squarespace.com/','https://www.wku.edu/mediarelations/2023/august/aug30/museum_dn.pdf'],
    'The native operator host, also recorded in the current Overture row, explicitly identifies an independent 501(c)(3), its own board, the former 301 State Street location and the July 2014 lease of the Erskine House at 1783 Chestnut Street. Three buildings are one museum property, not three institutions; university tenancy and WROTE organizational assistance do not imply chain ownership. Consolidate both State Street records as former_site under the current Chestnut row. Use the operator homepage public name African American Museum rather than append locality solely to distinguish it. Visits are by appointment; the WKU-hosted 2023 operator interview corroborates reopening after tornado damage. The aambg.org TLS failures were not bypassed, and the unrelated-looking Museedu/Louvre domain was not used for the decision. Retain source coordinates for separate publication review.')
identity('BOWLING_GREEN',['3a87c63f-98f0-4876-9ade-7e6ad7f8a1fa','df256160-3087-49eb-a5d1-8de8fceabc70','8402100230'],
    ['canonical','former_site','former_site'],['chestnut','state_former','state_former'])
decision('3a87c63f-98f0-4876-9ade-7e6ad7f8a1fa','BOWLING_GREEN','independent','verified')
preferred('3a87c63f-98f0-4876-9ade-7e6ad7f8a1fa','BOWLING_GREEN','African American Museum')

evidence('CARBONDALE',['https://aamsi.org/','https://aamsi.org/about-us/','https://www.sicf.org/ourfunds/aamsi/'],
    'Use the operator public name African American Museum of Southern Illinois. Its own history identifies the McDaniel founders, Southern Illinois Achievers, the museum board/volunteers and continuous University Mall site since 1997; the fund administrator independently describes the museum as a volunteer nonprofit and beneficiary of a donor-created endowment. One institution at 1237 East Main, with PO Box 3187 as mail. The community foundation endowment and University Mall location do not establish common ownership with other museums or the nearby Science Center. Body text lists Tuesday-Saturday 11am-5pm; the footer has an 11pm typo, so recheck access before publication. Baseline name/nearby checks found no additional source record requiring consolidation.')
decision('fd4788af-0255-4cb3-b7d1-96483e7f632d','CARBONDALE','independent','verified')
preferred('fd4788af-0255-4cb3-b7d1-96483e7f632d','CARBONDALE','African American Museum of Southern Illinois')

evidence('STMARTINVILLE',['https://stmartinville.gov/attractions/',
    'https://stmartinville.gov/wp-content/uploads/2025/08/af6bd-8-01-22-minutes.pdf',
    'https://stmartinville.gov/wp-content/uploads/2025/08/fef6e-10-07-24-minutes.pdf',
    'https://stmartinville.gov/wp-content/uploads/2025/08/8cade-6-02-25minutes.pdf',
    'https://stmartinville.gov/weddings/','https://acadianmemorial.org/area-attractions/'],
    'Municipal affiliation is supported by city hiring/pay decisions for museum docents in 2022 and Acadian Memorial museum staffing in 2024, current city museum services, and the city CRT director organizing the African American Museum event in June 2025. Record City of St. Martinville museum affiliation, not independence. Factual review remains pending: the nearby Cultural Heritage Center row at 101 S New Market describes a campus housing both the African American Museum and Museum of the Acadian Memorial, while the African American row lists 125 S New Market. Preserve both rows separately until institution/campus counting and current visitor entrances are reconciled; do not merge two named museums into one merely because they share a center. The legacy .org domain is now privately operated. The scanned city budget gives tourism totals but no museum-specific attribution, so it is not the affiliation basis.')
for key in ['5213c117-6203-49e7-8d01-da6627b370d9','c362bcd2-b1cc-4e02-85c2-2f1f0feb9275']:
    decision(key,'STMARTINVILLE','chain','pending',chain='city_st_martinville_museums')

evidence('MARSHFIELD',['https://imaginationstationmarshfield.com/',
    'https://imaginationstationmarshfield.com/wp-content/uploads/2023/08/ISM-Policies-2023-Aug-Update.pdf',
    'https://education.mdc.mo.gov/reports/child-care-facilities?page=13'],
    'Verified not_museum: the operator policies describe a licensed childcare facility for ages 2-12, preschool enrollment, tuition and after-school care at 110 Commercial Street #102, with the same 417-859-6055 telephone. The state childcare listing corroborates this role/address. Exclusion rests on affirmative childcare evidence, not its name or lack of search results. Preserve the original museum-category source record; affiliation remains unknown because it is unnecessary to classify this non-museum.')
decision('abf900f3-7689-4fd4-8140-c2c3949273bb','MARSHFIELD',status='verified',category='not_museum')

evidence('MISSOULA_CONFLICT',['https://scienceandhistory.org/'],
    'Source conflict: the Overture row at 721 N 4th Street W, Missoula, with 406-830-3024 uses scienceandhistory.org, whose operator identifies Imagination Station Science and History Museum at 224 Nash Street SE, Wilson, North Carolina, 252-291-5113. Preserve the mixed Missoula row under its own uncounted ID with no aliases contributed to Wilson. The local entity role is unresolved; secondary childcare leads are not a verified not_museum decision. Human follow-up: authoritative provider/local-operator lineage for the Montana name/address and foreign website.')
identity('MISSOULA_CONFLICT',['7d036ce3-6450-4717-a025-f47f3302347e'],['source_conflict'],['unresolved_source'])
decision('7d036ce3-6450-4717-a025-f47f3302347e','MISSOULA_CONFLICT')

evidence('ZEELAND',['https://www.istation.org/'],
    'Verified not_museum: the operator describes Imagination Station as a nonprofit Child Care Learning Center offering care from six weeks through school age, with enrollment and educational programs at 396 Allied Court, Zeeland and 616-772-KIDZ (5439), matching the Overture row. This affirmative childcare function supports exclusion; nonprofit status alone is not an independence finding. Preserve the source row and unknown affiliation.')
decision('6ddcc3a6-7d46-4184-9c80-0db96cb932dd','ZEELAND',status='verified',category='not_museum')

evidence('STRATFORD_CONFLICT',['https://highplainsobserverstratford.com/index198.htm',
    'http://www.scribblesdesigns.net/index.html',
    'https://meetings.boardbook.org/Public/Projector/2533?meeting=738692'],
    'Source conflict: IMLS 8404802033 names Imagination Station, EIN 954619037, 202 N Main/PO Box 1126 in Stratford, but its supplied website describes Scribbles Print and Web Design with an Oregon-area telephone and marketing services. Preserve the mixed record as an uncounted source_conflict, not a verified non-museum or a fabricated clean record. First-person board columns in 2021 describe a local nonprofit educational organization, and the April 2026 school board approves class visits; these establish continuing local program evidence but do not resolve source lineage, current museum scope or governance. Human follow-up: official current operator/site and museum function, then reconsider the conflicted row.')
identity('STRATFORD_CONFLICT',['8404802033'],['source_conflict'],['unresolved_source'])
decision('8404802033','STRATFORD_CONFLICT')

evidence('TOLEDO',['https://www.imaginationstationtoledo.org/','https://www.imaginationstationtoledo.org/about',
    'https://www.imaginationstationtoledo.org/about/timeline'],
    'One locally governed nonprofit science museum at 1 Discovery Way, 419-244-2674. The operator timeline traces COSI Toledo opening in 1997, funding-related closure in 2007, the board-selected Imagination Station name in 2009 and reopening in October 2009. Both Overture rows have the same street address and phone; consolidate COSI Toledo as a same_site historical name under current Imagination Station. The current operator describes its own leadership and museum programs. Lucas County levy support and the old COSI name do not establish present common ownership with COSI Columbus. No additional institution is created for its internal theater or exhibit areas.')
identity('TOLEDO',['4a06db8a-1c1f-45b1-9f07-a169ab0649a5','7501a491-b22b-4926-a466-c218d99284fd'],
    ['canonical','same_site'],['discovery_way','discovery_way'])
decision('4a06db8a-1c1f-45b1-9f07-a169ab0649a5','TOLEDO','independent','verified')

evidence('LAFAYETTE',['https://www.imagination-station.org/','https://www.imagination-station.org/mission-history',
    'https://www.imagination-station.org/about-1'],
    'One Imagination Station science museum at 600 N 4th Street, Lafayette, 765-420-7780. Its operator identifies ASSET (Association for Science, Space, Engineering and Technology), founded as a nonprofit in 1992, and the current building donated in 1999. Its own board and executive director govern the museum; Purdue employment of individual board members does not imply university ownership. Current visitor information and educational exhibits establish the museum function. Full-baseline ASSET/name and nearby-source checks found no additional row requiring consolidation. Preserve this current source name and coordinates; map/access export still requires its separate check.')
decision('aec2a735-6b80-4f39-9047-84ed624ce286','LAFAYETTE','independent','verified')

evidence('PENSACOLA',['https://pensacolastate.smartcatalogiq.com/en/2016-2017/catalog/academic-and-student-services/wsre',
    'https://www.milb.com/news/blue-wahoos-stadium-improvements'],
    'Verified not_museum for the present stadium-space record: Pensacola State College identifies the former WSRE/PSC Learning Lab and Imagination Station educational outreach at Wahoos Stadium, matching the source telephone 850-484-1200. The stadium operator article dated March 6, 2025 explicitly documents that the former Imagination Station area had been gutted and connected to the visiting-team clubhouse for a weight room, dining and coaches offices. That affirmative repurposing supports excluding this stale site from the current museum count. This does not claim it never offered exhibits or that all closed museums are non-museums. Preserve the historical source row and name; no replacement institution or relocated museum is invented. The WSRE annual-report URL returned HTML rather than a PDF and was not used as a PDF source.')
decision('2e676c65-b170-42f1-a565-dbb834052856','PENSACOLA',status='verified',category='not_museum')

evidence('WOODSTOCK_CONFLICT',['https://scienceandhistory.org/',
    'https://www.woodstockct.gov/planning-and-zoning-commission/minutes/planning-zoning-minutes-9'],
    'Source conflict: Overture Imagination Station at 11 Beeches Lane, Woodstock, Connecticut, 860-963-7655 uses the Wilson, North Carolina museum website scienceandhistory.org (224 Nash Street SE, 252-291-5113). Keep this mixed row uncounted with a separate ID and no aliases to Wilson. Search-indexed 2018 municipal minutes refer to a daycare proposal at 11 Beeches, but the government download returned 403; no verified not_museum inference is based on that incomplete local evidence. Human follow-up: primary current local operator/permit evidence and provider website lineage. A failed page request is not an exclusion reason.')
identity('WOODSTOCK_CONFLICT',['46a9f87e-a76f-4e67-b202-272c9acb12a7'],['source_conflict'],['unresolved_source'])
decision('46a9f87e-a76f-4e67-b202-272c9acb12a7','WOODSTOCK_CONFLICT')

assert sum(len(x['keys']) for x in spec['identities']) == 15
assert len(spec['identities']) == 8
assert len(spec['decisions']) == 17
assert len(spec['names']) == 2
(p / 'decisions_spec.json').write_text(json.dumps(spec, indent=2), encoding='utf-8')
print('15 identity rows / 8 cases; 17 factual decisions; 2 preferred names')
