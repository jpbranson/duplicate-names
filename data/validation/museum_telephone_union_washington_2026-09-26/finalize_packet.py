"""Run once after the selective build, tests and integrity checks pass."""
import csv,json
from pathlib import Path
from datetime import datetime,timezone
p=Path(__file__).parent
rows=lambda f:list(csv.DictReader((p/f).open(encoding='utf-8-sig')))
checks=rows('integrity_checks.csv');n=len(checks)
assert n==26 and all(x['passed']=='TRUE' for x in checks)
log=(p/'build_validate.log').read_text(encoding='utf-8',errors='replace')
assert all(x in log for x in ['FAIL 0','WARN 0','SKIP 0','PASS 340',f'{n} integrity checks passed'])
c=rows('counts.csv')[0]
assert c['counted_institutions']=='52409' and c['eligible']=='52277' and c['complete_reviews']=='170'
cache=rows('cache_status.csv');assert len(cache)==38 and all(x['status']=='cached' for x in cache)
report=f'''# Telephone / Union / Washington factual review — September 26, 2026

The 21 starting candidates now map to eighteen reviewed institution descriptions.
Four factual reviews are complete; fourteen remain explicitly pending. This
checkpoint does not certify a national winner or a complete museum census.

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,111 | 57,107 |
| Counted institutions | 52,413 | 52,409 |
| Eligible for L2 analysis | 52,281 | 52,277 |
| Guarded identity rows / cases | 396 / 168 | 403 / 171 |
| Complete factual reviews, including exclusions | 166 | 170 |
| Sourced not-museum exclusions | 24 | 24 |
| Preferred names | 100 | 103 |
| Isolated source conflicts | 33 | 33 |

All 340 assertions and {n} integrity checks pass with no failures, warnings or
skips. All 1,781 protected prior evidence/label files remain unchanged. Original
source fields and coordinates, automatic baseline, multisite queue and 0.85
threshold are preserved. Reviewed Parquet and source-level audit match replay.

Nine proposed identity rows cover three new cases and the explicit extension of
the earlier two-row Union County Illinois case. Its original case identifier and
canonical site group are preserved. Seven earlier pending factual decisions are
deliberately updated; their original contents remain in the dated snapshots.
All other prior identity decisions, factual decisions and preferred names remain
unchanged. The first dry run correctly rejected former sites sharing a canonical
site group. The draft groups were corrected; no guard was weakened.

- Maine's Telephone Museum physical/mail descriptions reconcile to one locally
  governed museum. Houston, Atlanta, the two Massachusetts records and Fairmont
  retain specific identity, operation or governance questions. A 2022 Lexington
  tenancy proposal is not treated as an accepted move. Conflicting Massachusetts
  legal identifiers remain separate and visible.
- Washington, Missouri's physical/mail descriptions reconcile to one museum with
  its own trustees. In Illinois, the former Dement-Zinser site reconciles with
  the current society; permanent curated exhibition scope remains pending.
- Washington, New Hampshire's main museum/barn campus has sourced common
  operation with its separately located schoolhouse. Maine's building/source
  scope remains unresolved. New York receives its supported current name,
  Millbrook Historical Society, while museum versus archives scope stays pending.
- Union County Ohio's Morey house/annex museum has a complete factual review.
  Georgia receives its current Old Courthouse Museum name and sourced affiliation;
  additional generic town-square and Heritage Center records remain unresolved.
- The Cobden collection's documented 2006 transfer supports the Illinois identity
  extension and current Union County Museum name. The separate resource center's
  exhibition role and visitor point still need confirmation.
- Indiana and Pennsylvania umbrella descriptions receive supported affiliations
  while source-to-site roles remain pending. Pennsylvania's planned Packwood
  reopening is not reported as completed. Oregon's mixed legal/source context
  remains intact, and North Carolina's legal/mail continuity does not establish
  a public museum. No record is excluded merely for a mailbox or failed search.

See [evidence]({p.name}/evidence.csv), [all starting dispositions]({p.name}/candidate_dispositions.csv),
[fourteen human-review actions]({p.name}/human_review.csv) and
[source-level audit]({p.name}/identity_audit_after.csv). Thirty-eight public documents
were cached with checksums; three PDF pages were rendered and visually inspected.
The source dossier retains 526 pinned Overture context rows and selected IRS rows.
Research-lead URLs in pending decisions are explicitly identified as leads, not
proof of specific museum ownership.

Old Jail Museum remains the provisional non-chain leader at eight with four pending
reviews. Its explicit publication gate still fails. Remaining earlier identity and
M2 questions require further work or human evidence; the local post and explorer
still need to be refreshed from their older Clinton/Madison/Monroe checkpoint.
Church independent labels and the publication destination remain missing.

Cloud resource spending: **USD 0**, below USD 5. No outreach or external publication.
'''
p.with_suffix('.md').write_text(report,encoding='utf-8')
(p/'README.md').write_text(f'''# Telephone / Union / Washington evidence packet

Applied and validated; [report](../{p.name}.md). Do not rerun `prepare.R`,
`apply.R`, `prepare_validation.py` or `finalize_packet.py`.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: validated checkpoint.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: reasoning and open work.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: audit.
- `*_before.csv`, `protected_files.csv`: original inputs and prior-file hashes.
- `sources*.json`, `cache_status.csv`, `*.txt`, `manifest_after.json`: provenance.
- `pdf_visual_review.md`, rendered PNGs: visual evidence checks.
- `source_dossier.json`, `overture_context.csv`, `imls_context.csv`, `irs_selected.json`: context.
- `headline_publication_gate.txt`: unfinished national headline gate.

Before RDS: `data/processed/museum_telephone_union_washington_before.rds`.
Read-only `build_validate.R --verify-only` is valid only while this is the current
live checkpoint. Never overwrite this dated packet after a successor protects it.
No independent matching labels were created.
''',encoding='utf-8')
checkpoint=f'The [Telephone/Union/Washington checkpoint](data/validation/{p.name}.md) validates 52,409 counted / 52,277 eligible museum institutions, 403 identity rows in 171 cases and 170 complete factual reviews (including exclusions). All 340 assertions and {n} integrity checks pass; 1,781 earlier evidence/label files remain unchanged. Four batch reviews are complete and fourteen remain pending.'
f=Path('HANDOFF.md');t=f.read_text(encoding='utf-8');a=t.index('**Active continuation:**');b=t.index('\n\n',a)
t=t[:a]+'**Active continuation:** See [FLIGHT_LOG.md](FLIGHT_LOG.md). '+checkpoint+' Next: remaining M2/earlier identity questions, then refresh post/explorer. Old Jail has four pending reviews; no national winner is certified. Cloud spending USD 0, strictly below USD 5.'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('README.md');t=f.read_text(encoding='utf-8');a=t.index('The [Franklin/Heritage/Newton checkpoint]');b=t.index('\n\n',a)
t=t[:a]+checkpoint+' Historical counts below describe earlier checkpoints. Local post/explorer retain the older Clinton/Madison/Monroe checkpoint. Both drafts remain unpublished. Follow [FLIGHT_LOG.md](FLIGHT_LOG.md).'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('data/validation/README.md');t=f.read_text(encoding='utf-8');a=t.index('**Current checkpoint:');b=t.index('## Church work in progress',a)
t=t[:a]+f'''**Current checkpoint: 2026-09-26 [Telephone/Union/Washington review]({p.name}.md).**
Reviewed outputs retain 60,002 rows, with 57,107 counted source rows, 52,409 institutions and 52,277 eligible for L2 analysis. There are 170 complete factual reviews, including exclusions. All 340 assertions and {n} integrity checks pass; 1,781 prior files are preserved. Counts remain provisional; unknown affiliation is not independence.

Four batch reviews are complete and fourteen remain pending. See [ranking]({p.name}/ranking_after.csv), [open actions]({p.name}/human_review.csv), [preceding checkpoint](museum_franklin_heritage_newton_2026-09-26.md) and [handoff](../../HANDOFF.md). Earlier identity and M2 questions remain; Old Jail's four pending reviews prevent certification. Local artifacts need a later refresh.

'''+t[b:];t=t.replace('396 rows in 168 cases','403 rows in 171 cases');f.write_text(t,encoding='utf-8')
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape');a=t.index('Current next action:');b=t.index('\n\n',a)
t=t[:a]+f'Current next action: Telephone/Union/Washington checkpoint validated: 52,409 counted / 52,277 eligible, 403 identity rows / 171 cases, 170 complete factual reviews. All 340 assertions and {n} integrity checks pass; 1,781 prior files preserved. Four complete and fourteen pending batch reviews. Never rerun its prepare or apply. Continue remaining M2/earlier identity questions, then refresh post/explorer. Old Jail has four pending reviews. Cloud spending USD 0.'+t[b:]
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+f''' - Telephone/Union/Washington checkpoint validated

- Selective targets, reviewed Parquet and audit rebuilt. All 340 assertions and {n} integrity checks pass, zero failures/warnings/skips. All 1,781 protected prior files remain unchanged.
- Validated counts: 60,002 rows; 57,107 counted rows; 52,409 institutions; 52,277 eligible; 403 identity rows / 171 cases; 170 complete reviews; 24 exclusions; 103 names; 33 source conflicts.
- Four factual reviews completed; fourteen remain pending with exact human actions. Three new identity cases and one deliberate extension. Seven prior pending decisions updated; all original inputs archived. Never rerun prepare/apply.
- Report and live pointers updated. Remaining M2/earlier identity work precedes artifact refresh. Museum and church final gates and deployment remain incomplete. USD 0 cloud spending.
''';f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Packet and live pointers finalized after verification.')
