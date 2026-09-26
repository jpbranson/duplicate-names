"""Write checkpoint only after all saved integrity checks have passed."""
import csv, json, re
from pathlib import Path
p=Path(__file__).parent
def rows(n): return list(csv.DictReader((p/n).open(encoding='utf-8-sig')))
checks=rows('integrity_checks.csv')
assert len(checks)==25 and all(r['passed']=='TRUE' for r in checks)
counts=rows('counts.csv')[0]
assert counts['counted_institutions']=='52455' and counts['pending_in_this_followup']=='8'
log=(p/'validation.log').read_text(errors='replace')
assert re.search(r'PASS\s+340',log), 'Full regression result is missing'
spec=json.loads((p/'decisions_spec.json').read_text())
human=rows('human_review.csv')
assert len(human)==8
report='''# Jefferson and Lincoln County review - September 26, 2026

This is a factual source/identity checkpoint, not an independent matching evaluation
or a certified national headline. All 16 starting candidates have saved dispositions.
Nine additional institutions have complete factual reviews; eight reviewed outcomes
remain pending, including the isolated Iowa record. Seventeen outcomes are reviewed
because Newport has two distinct museums, both of which have complete factual reviews.

## Validated outputs

| Measure | Count |
|---|---:|
| Original source rows retained | 60,002 |
| Counted source rows | 57,156 |
| Counted museum institutions | 52,455 |
| Eligible for L2 analysis | 52,323 |
| Explicit identity rows / cases | 319 / 134 |
| Complete factual reviews, including exclusions | 132 |
| Sourced not-museum decisions | 22 |
| Preferred public names | 80 |
| Isolated source-conflict rows | 29 |

This batch adds 27 identity rows in 13 cases, 17 factual decisions and 11 preferred
names. It adds no not-museum exclusion. Jefferson County Historical Society's bare-name
non-chain group falls from eight to two; Lincoln County Historical Society falls from
eight to three. Current counts remain provisional.

The selective target/export build and **340 test assertions** pass. All **25 integrity
checks** pass, including hashes for **1,235 prior evidence/label files**, unchanged
automatic baseline and baseline multisite queue, unchanged source names/coordinates,
reviewed Parquet equality, full guarded replay and the 0.85 threshold. No algorithm or
schema changed in this batch. The first dry run rejected a former site sharing its
canonical site group; the draft was corrected before the successful one-time apply.

The explicit publication gate still rejects the leading group. Complete factual
reviews do not certify visitor access, map points, M2 semantics or independent
matching accuracy. Prior pending queues remain active. Post/explorer payloads still
reflect the older Clinton/Madison/Monroe checkpoint and have not been refreshed here.

## Decisions and evidence

'''
for d in spec['decisions']:
    e=spec['evidence'][d['case']]
    report+=f"### {d['case']} - {d['status']}; affiliation {d['aff']}\n\n{e['note']}\n\n[Primary source or recorded research lead]({e['url']}).\n\n"
report+='''## Pending human actions

See [human_review.csv](museum_jefferson_lincoln_2026-09-26/human_review.csv) for stable
source/entity keys, evidence and precise actions. No outreach has been sent.

'''
for x in human:report+=f"- **{x['case']}:** {x['human_action']}\n"
report+='''
## Acquisition and preservation

The packet contains 175 initially related baseline records plus Hedlund House, which
lies outside the old society mailbox's spatial neighborhood. Separate pinned Overture
queries preserve the institution address context, and IMLS physical/mailing fields
remain distinct. The extra Hedlund query is recorded in the raw manifest.

Fifty-one of 55 public downloads succeeded; four failures remain recorded (two DNS,
one HTTP 404 and one HTTP 403). Two successful Davenport HTML downloads contain only
parked-page redirect scripts and are expressly **not substantive operator evidence**.
No access restriction was bypassed and no advertising redirect was followed. Search
extracts whose native source failed are research leads, not certification evidence.
Existing state IRS caches were reused; five new public state files were cached.

Fairbury guide page 18, the Hedlund operator notice on page 12 and the EMAHS rename
newsletter page 2 were rendered and visually inspected. Source PDFs, hashes and text
extractions are indexed in the evidence register. Original caches are ignored raw
files; tracked extracts, selected IRS records, manifest snapshots and page images
preserve the evidence for review.

The applied marker prevents rerunning the correction batch. Do not rerun `prepare.R`,
`acquire_hedlund.R` or `apply.R`. The saved scripts and before/after artifacts document
the operation; a new review requires a new snapshot. Cloud resource spending remains
**USD 0**. No correspondence, commit, push or external publication was initiated.

## Resume

Continue Madison Historical Society, Marion County Historical Society and Milton
Historical Society (eight each), then earlier unresolved and M2 queues. Keep the four
Old Jail blockers visible. Review final counts and explicit publication gates before
refreshing and exporting the provisional post/explorer; a deployment destination and
independent church labels are still missing.
'''
(p.parent/(p.name+'.md')).write_text(report,encoding='utf-8')
(p/'README.md').write_text('# Evidence packet\n\nSee the [checkpoint report](../'+p.name+'.md). All 25 integrity checks and 340 assertions pass; eight reviews remain pending. The applied marker is final. Do not rerun snapshot or apply scripts.\n',encoding='utf-8')
print('Validated report written; eight pending actions retained')
