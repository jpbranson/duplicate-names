"""Write concrete incomplete evidence gaps after the validated build."""
import csv, json
from pathlib import Path
p = Path(__file__).parent
spec = json.loads((p/'decisions_spec.json').read_text(encoding='utf-8'))
by_key = {r['key']: r for r in spec['decisions']}
gaps = {
    'TACOMA': ('Present status and address history unresolved', 'Find authoritative operator/archive evidence connecting 925 Court C to the historical museum at Merit Building and establishing present operation, relocation or closure and governance. Keep Seattle NAAM separate.'),
    'GALVESTON': ('Current operator succession and access unresolved', 'Confirm current governance and public access for 3427 Sealy Avenue from the operator or equivalent authoritative record; reconcile the Josey founder/curator history.'),
    'MONROE_CONFLICT': ('Monroe address with unrelated Dallas museum website', 'Resolve provider lineage for the Dallas domain. Preserve this source conflict separately from the reviewed Monroe and Dallas institutions until all conflicting fields are reconciled.'),
    'STMARTINVILLE': ('Two named museums and their generic campus overlap', 'Resolve whether the 101 S New Market Cultural Heritage Center row denotes the two-museum campus or a separate countable institution; verify the African American Museum visitor entrance at the source 125 S New Market. Keep municipal affiliation, separate rows and pending status meanwhile.'),
    'MISSOULA_CONFLICT': ('Montana address with Wilson North Carolina website', 'Establish the local name/address role from primary operator or government evidence and trace the foreign website field. Do not merge into Wilson or infer not_museum from secondary childcare listings.'),
    'STRATFORD_CONFLICT': ('Museum archive row points to unrelated web-design firm', 'Resolve original source lineage and obtain current official local operator, governance and museum-function evidence. School visits and historical board columns do not finish that review.'),
    'WOODSTOCK_CONFLICT': ('Connecticut address with Wilson North Carolina website', 'Resolve provider lineage and obtain primary local operator or permit evidence. The government minutes URL returned 403; the indexed daycare proposal alone is not a complete current-role review.'),
}
pending = list(csv.DictReader((p/'follow_up.csv').open(encoding='utf-8-sig')))
rows = []
for r in pending:
    item = by_key[r['source_id']]
    gap, action = gaps[item['case']]
    rows.append(dict(source_id=r['source_id'], entity_id=r['entity_id'], name=r['primary_name'],
                     status='incomplete', gap=gap, next_action=action,
                     evidence_url=spec['evidence'][item['case']]['url'],
                     outreach_authorized='no', cloud_spend_usd=0))
assert len(rows) == 8
with (p/'human_review.csv').open('w', encoding='utf-8', newline='') as f:
    w = csv.DictWriter(f, fieldnames=list(rows[0])); w.writeheader(); w.writerows(rows)
print('Eight incomplete evidence reviews exported; no decisions changed.')
