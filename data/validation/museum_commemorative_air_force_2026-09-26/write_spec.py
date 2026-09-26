"""Prepare factual decisions without writing live inputs."""
import csv,json
from pathlib import Path
from datetime import datetime,timezone
p=Path(__file__).parent
spec={'evidence':{},'identities':[],'decisions':[],'names':[],'human_review':[]}
common=' CAF unit policy (April 2024) and NAEC nonprofit disclosure establish common control of headquarters, chartered units and museum/fleet corporations. Chain ID commemorative_air_force denotes this control, not a completed count of its museums.'
def case(code,url,note,key=None,keys=None,roles=None,name=None,status='verified',action=None):
    spec['evidence'][code]={'url':url,'note':note+common+' Evidence packet: data/validation/'+p.name+'; original source fields and coordinates retained.'}
    if keys:
        spec['identities'].append({'case':code,'keys':keys,'roles':roles,'groups':[code.lower()]*len(keys)})
        key=keys[0]
    spec['decisions'].append({'case':code,'key':key,'aff':'chain','status':status,'chain':'commemorative_air_force','category':'not_flagged'})
    if name:spec['names'].append({'case':code,'key':key,'name':name})
    if action:spec['human_review'].append({'case':code,'source_id':key,'status':'pending','action':action,'evidence_url':url})

case('FLORIDA','https://commemorativeairforce.org/units/32',
     'National and local operator identify the Florida Wing at 1570 Old NDB Road, DeLand, matching both descriptions and CAFFL.ORG. The national page expressly documents the Robbins Memorial library/museum collection in the hangar and Wednesday/Saturday visitor access. Consolidate the two source rows; the IMLS point is displaced from its stated physical address. Retain the existing Florida Wing public name. Do not repeat the stale statement that it is the only Florida unit.',
     keys=['89353c26-6e4a-4d3a-966e-8ce322acd71e','8401200445'],roles=['canonical','mislocated'])
case('MINNESOTA','https://www.cafmn.org/visit.html',
     'National unit directory and operator identify the Minnesota Wing WWII aircraft museum at 310 Airport Road, Hangar 3, South St Paul/Fleming Field. Both source rows describe this campus, including the old CAFSMW.ORG domain; the IMLS point is several kilometres away despite the same address. Consolidate with Overture canonical and IMLS mislocated. Operator describes aircraft, vehicles, artifacts and public Wednesday/Saturday hours. Retain the wing public name.',
     keys=['2010433e-2547-4097-8454-eb198c388407','8402700201'],roles=['canonical','mislocated'])
case('GEORGIA','https://airbasegeorgia.org/museum/',
     'CAF Airbase Georgia occupies 1200 Echo Court, Peachtree City. Current IRS EIN 263607856, matching IMLS, confirms Echo Court; the older IMLS Echo Street spelling and displaced coordinates are not another museum. The national February 18, 2021 announcement explicitly renames Dixie Wing to Airbase Georgia. Consolidate with the current Overture record and retain its public name. The operator says the museum is open but smaller artifact tours are suspended during redesign; aircraft, Link Trainer, ball turret and some uniform exhibits remain accessible. This is not a full-access promise: recheck visitor conditions before publication.',
     keys=['a9fee0cd-202c-47af-8a73-37acc154a566','8401300232'],roles=['canonical','mislocated'])
case('KANSAS','https://www.cafhoa.org/',
     'National unit directory and local operator identify Heart of America Wing at the exact Overture address, 6 Aero Plaza, New Century, Kansas. The operator explicitly describes its museum and appointment-only opening, with phone 913-907-7902. Apply the more specific public name CAF Heart of America Wing to the generic source description. No second baseline museum description was found in the scoped context.',
     key='888da035-0c62-418f-ac74-d6a19ff57698',name='CAF Heart of America Wing')
case('NEW_MEXICO','https://www.lobowing.org/history-of-the-lobo-wing/',
     'IMLS 8403500123 names Commemorative Air Force, EIN 263043783, at 994 Lynx Loop NE, Albuquerque. Current IRS identifies the same legal entity as CAF group 5545/affiliation 9 at another Albuquerque officer contact, supporting parent affiliation. Lobo Wing documents its restoration hangar at 50 George Applebay Way/Hangar 80, Moriarty, but a primary bridge from the older Lynx Loop record to that public site is missing. Its history distinguishes its own 1989 wing charter from the earlier New Mexico Wing; do not merge the separate Hobbs source row by state or organizational ancestry. Museum scope and precise physical identity remain pending.',
     key='8403500123',status='pending',action='Establish the exact relationship of EIN 263043783/994 Lynx Loop NE to Lobo Wing at Moriarty, with a dated operator/legal address bridge and current museum scope. Keep the separate Hobbs New Mexico Wing description unmerged.')
case('MIDLAND_GENERIC','https://www.commemorativeairforce.org/caf_documents/229',
     'The generic CAF Overture record at 9600 Wright Drive overlaps the High Sky Wing museum address but could describe the former national headquarters campus. CAF 2019 audit PDF page 20 (printed 18) records return of two former Midland properties while supporting-unit leases continued. The national policy distinguishes the static museum corporation from the fleet-title corporation. Parent affiliation is established; the source record role and museum succession are not. Keep its identity separate pending a primary provenance/transfer bridge, without a not_museum inference.',
     key='c0977330-6883-49f3-ace1-67f47fc19958',status='pending',action='Resolve whether the generic 9600 Wright Drive source represents current High Sky museum, former national headquarters museum or another facility, using source provenance and dated property/museum transfer records.')
case('MIDLAND_HIGH_SKY','https://highskywing.org/?page_id=3699',
     'The High Sky Wing operator identifies its Midland Army Air Field Museum inside the main hangar at 9600 Wright Drive, with WWII regional exhibits and wing aircraft. Apply that public museum name to the explicit High Sky Wing source. Parent affiliation is supported. Overall identity review remains pending because the generic CAF and fleet-corporation source descriptions at the same address are unresolved. Saturday/group access is dated observation requiring publication recheck. Indexed operator content was inspected; native download failed certificate verification and no security protection was bypassed.',
     key='2bc38465-4592-48dc-a55b-fa7956634c28',name='Midland Army Air Field Museum',status='pending',action='Resolve the other two Midland CAF source roles against the current High Sky museum before certifying the institution count; verify the visitor entrance and current access.')
case('MIDLAND_FLYING_CORPORATION','https://www.commemorativeairforce.org/caf_documents/229',
     'IMLS American Airpower Heritage Flying Museum at 9600 Wright Drive/PO Box 62000 carries EIN 742554138. CAF policy describes AAHFM as the corporation holding the distributed aircraft fleet, distinct from AAHM, whose NAEC disclosure gives EIN 742553763. Common control is explicit but does not make every legal corporation a separate museum site. The historical IMLS physical row has not been linked reliably to a present public museum. Preserve it pending without merging it into NAEC/High Sky or excluding it solely for an administrative role.',
     key='8404801178',status='pending',action='Identify the public museum/site represented by historical IMLS 8404801178 and fleet-owner EIN 742554138; distinguish it from static-museum EIN 742553763 and determine the correct former-site or administrative role.')
case('DALLAS_HQ','https://www.commemorativeairforce.org/pages/contacts',
     'CAF currently identifies headquarters at 5661 Mariner Drive and NAEC separately publishes 5657 Mariner Drive. Common control is explicit. The unit policy also describes periodic public aircraft exhibits at headquarters, so office wording alone cannot establish not_museum. Whether these source rows represent one integrated visitor campus or separately counted museums is unresolved. Retain the headquarters row pending without an unsupported exclusion or merger.',
     key='b212bf54-f6a3-47bd-bd9f-94956f73b5f9',status='pending',action='Document the current public exhibition boundary and integrated-campus relationship of headquarters 5661 and NAEC 5657 Mariner Drive; determine whether headquarters is a separate museum description or supporting campus row.')
case('DALLAS_NAEC','https://flynaec.org/non-profit-information/',
     'NAEC is the flagship of American Airpower Heritage Museum and its own nonprofit disclosure explicitly states common control across CAF headquarters, units, static museum, foundation and flying museum. The visitor page confirms the public museum at 5657 Mariner Drive. Preserve its specific public name and supported affiliation. Overall identity review remains pending until the adjoining headquarters source at 5661 Mariner Drive is resolved; a public visitor page alone does not settle whether both rows should count.',
     key='a616fb3c-641e-4bc5-8871-fccbaf8ea5ae',status='pending',action='Resolve the adjoining headquarters source role before certifying NAEC campus count; use operator campus documentation showing whether the aircraft exhibitions are part of a single admission/interpretive institution.')

(p/'decisions_spec.json').write_text(json.dumps(spec,indent=2),encoding='utf-8')
for fn,rows,fields in [('evidence.csv',[dict(case=k,**v) for k,v in spec['evidence'].items()],['case','url','note']),('human_review.csv',spec['human_review'],['case','source_id','status','action','evidence_url'])]:
    with (p/fn).open('w',newline='',encoding='utf-8') as f:
        w=csv.DictWriter(f,fieldnames=fields);w.writeheader();w.writerows(rows)
(p/'web_observations.json').write_text(json.dumps([
    {'url':'https://highskywing.org/?page_id=3699','observed_utc':'2026-09-26','method':'indexed primary operator text; direct web 502 and native untrusted certificate retained','note':'Public Midland Army Air Field Museum in High Sky main hangar at 9600 Wright Drive; Saturday and group access. Page API indexed modification June 12, 2026. No security bypass.'},
    {'url':'https://commemorativeairforce.org/news/caf-dixie-wing-becomes-caf-airbase-georgia','observed_utc':'2026-09-26','method':'direct web primary source','note':'Official Dixie Wing transition to Airbase Georgia effective February 18, 2021. Historical aircraft/member numbers not treated as current.'}
],indent=2),encoding='utf-8')
(p/'pdf_visual_review.md').write_text('# PDF evidence check\n\nCAF 2019 audit PDF page 20 (printed 18) rendered and read at 1500px. Notes 4 and 5 document Midland returned facilities, continuing unit leases, and the Dallas headquarters/museum lease. Font substitution warnings did not obscure the text. This supports distinct property roles, not a final museum identity merger.\n',encoding='utf-8')
old=Path('data/validation/museum_bedford_belmont_chatham_2026-09-26/apply.R').read_text()
(p/'apply.R').write_text(old.replace('museum_bedford_belmont_chatham','museum_commemorative_air_force').replace("paste0('BBC_',case)","paste0('CAF_',case)"))
print('6 identity rows / 3 cases; 10 decisions; 2 names; 4 complete and 6 pending proposed.')
