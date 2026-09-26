"""Finalize only after tests and saved-output verification pass."""
import csv
from pathlib import Path
from datetime import datetime,timezone
p=Path(__file__).parent
rows=lambda f:list(csv.DictReader((p/f).open(encoding='utf-8-sig')))
checks=rows('integrity_checks.csv');n=len(checks)
assert n==28 and all(x['passed']=='TRUE' for x in checks)
log=(p/'build_validate.log').read_text(encoding='utf-8',errors='replace')
assert all(x in log for x in ['FAIL 0','WARN 0','SKIP 0','PASS 340','28 integrity checks passed'])
c=rows('counts.csv')[0]
assert c['counted_institutions']=='52413' and c['eligible']=='52281' and c['complete_reviews']=='166'
cache=rows('cache_status.csv');assert len(cache)==48 and sum(x['status']=='cached' for x in cache)==39
report=f'''# Franklin / Heritage / Newton factual review — September 26, 2026

This checkpoint reviews the 21 candidates in three seven-count name groups and
related source identities. Eight factual reviews are complete; fifteen cases
remain explicitly pending. It does not certify a national museum headline.

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,126 | 57,111 |
| Counted institutions | 52,426 | 52,413 |
| Eligible for L2 analysis | 52,294 | 52,281 |
| Guarded identity rows / cases | 370 / 157 | 396 / 168 |
| Complete factual reviews, including exclusions | 158 | 166 |
| Sourced not-museum exclusions | 24 | 24 |
| Preferred names | 97 | 100 |
| Isolated source conflicts | 31 | 33 |

All 340 assertions pass with zero failures, warnings or skips. All 28 integrity
checks pass. The 1,667 protected prior files remain unchanged. Baseline, multisite
queue, source coordinates, human labels and the 0.85 threshold are preserved.
Reviewed Parquet, analysis and source-level identity audit match guarded replay.

The batch adds 26 identity rows in eleven cases, 23 factual decisions and three
names. [Evidence]({p.name}/evidence.csv), [candidate dispositions]({p.name}/candidate_dispositions.csv)
and [fifteen open actions]({p.name}/human_review.csv) preserve the reasoning.

- Maine and Wisconsin: society physical and mailing descriptions reconcile.
  Wisconsin's single museum village and board are established; Maine's separately
  located interpretive park and current governance remain unresolved.
- Connecticut: the generic municipal-department row at 387 Route 32 is the Ashbel
  Woodward Museum contact and reconciles with that museum. The society/history
  room and newly announced schoolhouse campus remain separate questions.
- New Hampshire: current Webster/Tay museum identity and 2026 season are supported.
  Its final relationship to the firefighters museum remains unresolved. A 2019
  discussion is not treated as completed ownership.
- New Jersey/Indiana: one IMLS row mixes New Jersey museum/address with Indiana
  legal identity and coordinates. It is isolated uncounted. Both clean Indiana
  baseline members are explicitly retained under Franklin Heritage without the
  disputed New Jersey museum alias. Indiana museum scope and New Jersey's current
  museum operation after property transfers remain pending.
- Falfurrias: two descriptions reconcile as Heritage Museum at Falfurrias, with
  independently governed museum status supported. The 415/515 street-number
  disagreement and conflicting hours remain publication-access checks.
- Libby: local membership/board governance and museum campus are supported.
  Galleries ended their 2026 season September 12; archives remain by appointment.
- Virginia: Rocktown History, the old Heritage Museum name, society and integrated
  welcome center reconcile to one independently governed campus. The nearby
  Virginia Quilt Museum is not merged.
- Austin: the school-operated museum receives its public name Heritage Center
  Museum. The school's own board is supported; no multi-museum chain is inferred.
  Visitor arrangements and campus entrance need rechecking before map export.
- Astoria: specific Heritage Museum affiliation with the four-museum Clatsop
  County Historical Society is established. The IMLS parent mailing row remains
  pending rather than being arbitrarily assigned to one branch.
- Iowa/New Jersey: the mixed Iowa Heritage Museum row carries New Jersey legal
  identity/coordinates and is isolated uncounted. Only the clean Freehold pair
  reconciles as Jewish Heritage Museum of Monmouth County, with its own board.
- Arkansas: Bradley House's documented 403 W Clark campus reconciles three source
  descriptions. The older 601 W Clark row remains separate pending primary
  address history; identical coordinates alone do not resolve it.
- Indiana: Newton County Historical Society Museum and Resource Center reconciles
  its physical/mail descriptions. Common control with the separate Scott-Lucas
  House is supported by the nomination and current county visitor directory.
  The latter's north/south Main Street discrepancy requires separate visitor-point
  verification; neither that house nor Hazelden is merged into Kentland.
- Missouri: Neosho physical/mail descriptions reconcile. Current governance
  remains pending. Georgia and Mississippi society/archives sources likewise
  need current curated-museum scope evidence; none is excluded from search absence.
- Baltimore: historical state-directory identity is supported; current operation
  and governance remain pending.

Thirty-nine of 48 downloads were cached. Nine certificate, timeout or 404 failures
remain in the ledger; security checks were not disabled. Seven PDF pages were
rendered and visually inspected; see [inspection log]({p.name}/pdf_visual_review.md).
Indexed-only operator observations are identified in [web observations]({p.name}/web_observations.json).
The first dry runs caught an HTTP evidence URL and incomplete Indiana cluster
membership. Both were corrected with inspected sources and explicit membership;
no validation rule was weakened.

Old Jail Museum still leads provisionally at eight with four pending reviews; its
explicit publication gate fails. Next are Telephone Museum, Union County
Historical Society and Washington Historical Society, then earlier/M2 questions.
The local post/explorer still show the older Clinton/Madison/Monroe checkpoint.
Publishing destination and independent church labels remain outstanding.

Cloud spending remains **USD 0**, below USD 5. No outreach or external publication.
'''
p.with_suffix('.md').write_text(report,encoding='utf-8')
(p/'README.md').write_text(f'''# Franklin / Heritage / Newton evidence packet

Applied and validated checkpoint; see [report](../{p.name}.md).
Do not rerun `prepare.R` or `apply.R`.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: verification.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: decisions and open cases.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: audit.
- `ranking_before.csv`, `ranking_after.csv`, `analysis_after.csv`: dated counts.
- `protected_files.csv`, `*_before.csv`: hashes and snapshots.
- `sources*.json`, `cache_status.csv`, `*.txt`, `web_observations.json`: provenance.
- `pdf_visual_review.md`, `*_p*.png`: inspected PDF evidence.
- `source_dossier.json`, `imls_context.csv`, `overture_context.csv`, `irs_selected.json`: context.
- `headline_publication_gate.txt`: national headline remains blocked.

Before snapshot: `data/processed/museum_franklin_heritage_newton_before.rds`.
`build_validate.R --verify-only` applies only while this is the live checkpoint.
Do not overwrite this historical packet after another snapshot protects it.
No independent matching labels were created.
''',encoding='utf-8')
checkpoint=f'The [Franklin/Heritage/Newton checkpoint](data/validation/{p.name}.md) validates 52,413 counted / 52,281 eligible museum institutions, 396 identity rows in 168 cases and 166 complete factual reviews (including exclusions). All 340 assertions and 28 integrity checks pass; 1,667 earlier evidence/label files remain unchanged. Eight batch reviews are complete and fifteen remain pending; two mixed IMLS rows are isolated without disputed aliases.'
f=Path('HANDOFF.md');t=f.read_text(encoding='utf-8');a=t.index('**Active continuation:**');b=t.index('\n\n',a)
t=t[:a]+'**Active continuation:** See [FLIGHT_LOG.md](FLIGHT_LOG.md). '+checkpoint+' Next: Telephone Museum, Union County Historical Society and Washington Historical Society, then earlier unresolved/M2 queues. Old Jail still has four pending reviews; no national winner is certified. Cloud spending USD 0, strictly below USD 5.'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('README.md');t=f.read_text(encoding='utf-8');a=t.index('The [Commemorative Air Force checkpoint]');b=t.index('\n\n',a)
t=t[:a]+checkpoint+' Historical counts below describe earlier checkpoints. Local post/explorer retain the older Clinton/Madison/Monroe checkpoint; CSV filesystem saving remains unverified. Both drafts remain unpublished. Follow [FLIGHT_LOG.md](FLIGHT_LOG.md).'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('data/validation/README.md');t=f.read_text(encoding='utf-8');a=t.index('**Current checkpoint:');b=t.index('## Church work in progress',a)
t=t[:a]+f'''**Current checkpoint: 2026-09-26 [Franklin/Heritage/Newton review]({p.name}.md).**
Reviewed outputs preserve 60,002 rows, with 57,111 counted source rows, 52,413 institutions and 52,281 eligible for L2 analysis. There are 166 complete factual reviews, including exclusions. All 340 assertions and 28 integrity checks pass; 1,667 earlier files are preserved. Counts remain provisional; unknown affiliation is not independence.

Eight batch reviews are complete and fifteen remain pending. Two mixed IMLS rows are isolated with no alias transfer. Continue Telephone Museum, Union County Historical Society and Washington Historical Society, then earlier/M2 queues. See [ranking]({p.name}/ranking_after.csv), [open actions]({p.name}/human_review.csv), [preceding checkpoint](museum_commemorative_air_force_2026-09-26.md) and [handoff](../../HANDOFF.md). Old Jail's four pending reviews prevent certification; local post/explorer retain the older Clinton/Madison/Monroe checkpoint.

'''+t[b:]
t=t.replace('370 rows in 157 cases','396 rows in 168 cases');f.write_text(t,encoding='utf-8')
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape');a=t.index('Current next action:');b=t.index('\n\n',a)
t=t[:a]+'Current next action: Franklin/Heritage/Newton checkpoint validated: 52,413 counted / 52,281 eligible, 396 identity rows / 168 cases, 166 complete factual reviews. All 340 assertions and 28 integrity checks pass; 1,667 prior files preserved. Fifteen batch cases remain pending. Never rerun its prepare or apply. Continue Telephone Museum, Union County Historical Society and Washington Historical Society, then earlier/M2 queues. Old Jail still has four pending reviews. Local post/explorer retain the older Clinton/Madison/Monroe checkpoint. Cloud spending USD 0.'+t[b:]
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+''' - Franklin/Heritage/Newton checkpoint validated

- Selective exports rebuilt. All 340 assertions and 28 integrity checks pass, zero failures/warnings/skips. All 1,667 prior protected files, baseline, source coordinates, human labels and threshold preserved.
- Counts validated: 60,002 rows; 57,111 counted rows; 52,413 institutions; 52,281 eligible; 396 identity rows / 168 cases; 166 complete reviews; 24 not-museum exclusions; 100 names; 33 isolated source conflicts.
- Eight reviews completed; fifteen open actions retained. Two cross-state source conflicts isolated. Report and pointers updated; never rerun prepare/apply.
- Continue remaining three seven-count groups, then earlier/M2 questions. National headline gate still fails. Local artifacts need later refresh. USD 0 cloud spending.
'''
f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Packet and live pointers finalized after verification.')
