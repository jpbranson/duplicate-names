"""Export concrete evidence gaps; every row remains incomplete."""
import csv,json
from pathlib import Path
p=Path(__file__).resolve().parent
spec=json.loads((p/'decisions_spec.json').read_text(encoding='utf-8'))
by_key={s['key']:s for s in spec['decisions']}
gaps={
 'CL_IL':('Contradictory Illinois/Pennsylvania source fields','Inspect original IMLS source lineage for 8401700996. Keep it isolated unless independent evidence resolves every conflicting field.'),
 'CL_MI':('Contradictory Michigan/Pennsylvania source fields','Inspect original IMLS source lineage for 8402601015. The clean Michigan museum is already separately reviewed.'),
 'CL_OH':('Mixed Ohio, Michigan, Pennsylvania or Iowa source fields','Inspect each IMLS record separately; the current Ohio museum is already reviewed. Do not transfer disputed aliases or physical addresses.'),
 'MAD_IA':('Iowa address and New York website in one archived row','Resolve the original IMLS source lineage; keep the mixed row isolated from both accepted institutions.'),
 'MAD_VA':('Virginia parent attribution or Virginia/New York source conflict','For clean 8405100703, establish whether it represents one museum or only the multi-museum parent. For 8403600173, resolve the contradictory New York address and Virginia legal identity; keep isolated.'),
 'MON_TN':('Legal/address bridge and present museum role unknown','Obtain an authoritative current operator or legal record connecting EIN 621729962 and the Loudon mailing address to a public museum or a clearly defined non-museum role. Legacy Sweetwater society listing is insufficient.'),
 'MON_OH_OFFICE':('Current Parry museum governance and visitor access incomplete','Confirm the current lease/operator arrangement and seasonal access for the museum at 217 Eastern Avenue. The separate 118 Home Avenue office is excluded on its documented records-room role.'),
 'MON_WI':('Society role at Brackett School and other projects unresolved','Establish current ownership, programming and counting scope for the society and Brackett School. Keep the independently county-run Local History Room separate; transport grants do not prove common ownership.'),
 'MON_MO':('Generic parent could represent research center or courthouse museum','Determine which institution the IMLS parent record represents; confirm public museum name, access and relationship to Nancy Stone Research Center. Exact EIN is established, but site attribution is not.'),
 'MON_GA':('Forsyth address paired with Wisconsin museum domain','Resolve IMLS 8401300059 source lineage; keep the mixed row separate from the accepted Georgia depot museum and the Wisconsin institution.'),
 'MON_IA':('Portuguese website conflict; accepted Iowa museum governance incomplete','For Overture, resolve the erroneous sports-publication domain before removing the conflict hold. For clean IMLS, obtain current governance, campus scope, access and a verified visitor point.'),
 'MON_WV':('Operator inaccessible; full property scope and access unresolved','Recheck the operator website or obtain equivalent current authoritative evidence about governance, museum campus versus other properties, opening times and visitor point. No unsupported chain or independence claim.'),
}
with (p/'follow_up.csv').open(encoding='utf-8-sig') as f: pending=list(csv.DictReader(f))
rows=[]
for row in pending:
 key=row['source_id']; item=by_key[key]; gap,action=gaps[item['case']]
 rows.append(dict(source_id=key,entity_id=row['entity_id'],name=row['primary_name'],status='incomplete',
   gap=gap,next_action=action,evidence_url=spec['evidence'][item['case']]['url'],
   outreach_authorized='no',cloud_spend_usd='0'))
assert len(rows)==15
with (p/'human_review.csv').open('w',encoding='utf-8',newline='') as f:
 w=csv.DictWriter(f,fieldnames=list(rows[0]));w.writeheader();w.writerows(rows)
print('15 incomplete human-review items exported; no decisions changed.')
