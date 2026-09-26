"""Keep exact unresolved questions distinct from completed factual decisions."""
import csv,json
from pathlib import Path
p=Path(__file__).parent
s=json.loads((p/'decisions_spec.json').read_text())
by_key={d['key']:d for d in s['decisions']}
gaps={
 '8402600506':('Society identity mixed with municipal museum address and website','Obtain provider lineage and source evidence separating the Cass County society from Dowagiac Area History Museum. Do not merge the isolated row into any site until every conflicting field is reconciled.'),
 '8403601088':('Chestertown legal identity mixed with Orange County Chester address','Resolve the IMLS provenance and identify a clean record for the Warren County museum; preserve its isolated ID and do not leak aliases into Erie Station.'),
 '63263595-1d45-4eee-89f3-2898132d2546':('Vermont museum role, access and governing relationship unresolved','Obtain current exhibit/site documentation and the society-town operating agreement for 230 Main. Keep neighboring Hearse and Yosemite museums separate unless common ownership is established.'),
 '8403400571':('New Jersey archive and temporary-display scope unresolved','Establish which public museum collection/site the PO Box 376 record represents, current visitor address and access. Independent society governance is sourced, but a permanent museum role has not been established.'),
 '8401900180':('Denison parent and McHenry House address relationship unresolved','Find primary address history linking 2531 Donna Reed Road/PO Box 741 and EIN 237161933 to the McHenry House site. Explain the IRS Fourth Avenue versus visitor First Avenue contacts before merging.'),
 '8400500089':('Van Buren historical society identity mixed with Alma genealogy library','Resolve provider lineage and the historical society current legal/site identity; retain the separate genealogical-society record and do not infer closure from IRS absence.'),
 '826b2713-db91-4819-813b-9d69e9f26cd8':('Cuba current governance and visitor access need reliable operator evidence','Obtain an authoritative current operating/governance source; the old museum domain includes gambling spam. State and city tourism establish museum name/address, but do not finish affiliation review.'),
 '8405500383':('Wisconsin source address versus Hauge Center resource unresolved','Document the relation between 17933 Highway 27 and the Ferryville/Town of Freeman history center, museum role, current public name and operating structure. State affiliate membership alone is not ownership.'),
 'e53b9219-4540-45f8-9bc1-8b6e20800951':('Robinson and Palestine actual governance relationship unresolved','Establish whether shared IRS group 9411 denotes common museum operation or fiscal affiliation only. Keep the clean Robinson museum counted with unknown affiliation meanwhile.'),
 '8401701082':('Palestine EIN and mailbox mixed with Robinson museum address','Resolve the IMLS source mapping using operator/provider documents. Keep the conflicting row isolated from Robinson and Fife Opera House; shared IRS exemption group does not repair its physical-site mismatch.'),
 '8401300136':('Georgia museum/site scope and completed moves unresolved','Obtain current site addresses, museum/courthouse relocation and restoration status, governance and visitor access; decide whether pottery and Southeastern Indians museums are separate institutions or one campus from evidence.'),
 '8404201088':('Baldwin-Reynolds museum fields mixed with public library EIN','Request or locate source-provider correction linking each museum/library field to its institution. Preserve the conflict without aliases to the accepted Terrace Street museum.'),
}
pending=list(csv.DictReader((p/'follow_up.csv').open(encoding='utf-8-sig')))
rows=[]
for r in pending:
 d=by_key[r['source_id']];gap,action=gaps[r['source_id']]
 rows.append(dict(source_id=r['source_id'],entity_id=r['entity_id'],name=r['primary_name'],status='incomplete',gap=gap,next_action=action,evidence_url=s['evidence'][d['case']]['url'],outreach_authorized='no',cloud_spend_usd=0))
assert len(rows)==12 and {r['source_id'] for r in rows}==set(gaps)
with (p/'human_review.csv').open('w',encoding='utf-8',newline='') as f:
 w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
print('Twelve incomplete evidence reviews exported.')
