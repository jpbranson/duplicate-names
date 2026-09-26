"""Finalize only after saved outputs and tests have passed."""
import csv
from pathlib import Path
from datetime import datetime,timezone
p=Path(__file__).parent
rows=lambda f:list(csv.DictReader((p/f).open(encoding='utf-8-sig')))
checks=rows('integrity_checks.csv');n=len(checks)
assert n==26 and all(x['passed']=='TRUE' for x in checks)
log=(p/'build_validate.log').read_text(encoding='utf-8',errors='replace')
assert all(x in log for x in ['FAIL 0','WARN 0','SKIP 0','PASS 340','26 integrity checks passed'])
c=rows('counts.csv')[0]
assert c['counted_institutions']=='52426' and c['eligible']=='52294' and c['complete_reviews']=='158'
cache=rows('cache_status.csv');assert len(cache)==26 and sum(x['status']=='cached' for x in cache)==25
report=f'''# Commemorative Air Force factual review — September 26, 2026

This checkpoint resolves the parent-affiliation question for the seven generic
CAF candidates and three related records. It does not certify the total CAF
museum count or a national non-chain winner.

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,129 | 57,126 |
| Counted institutions | 52,429 | 52,426 |
| Eligible for L2 analysis | 52,297 | 52,294 |
| Guarded identity rows / cases | 364 / 154 | 370 / 157 |
| Complete factual reviews, including exclusions | 154 | 158 |
| Sourced not-museum exclusions | 24 | 24 |
| Preferred names | 95 | 97 |
| Isolated source conflicts | 31 | 31 |

All 340 assertions pass with zero failures, warnings or skips. All 26 integrity
checks pass. The 1,578 protected prior evidence/label files remain unchanged.
Automatic baseline, multisite queue, source fields/coordinates and the 0.85
threshold are preserved. Reviewed Parquet and identity audit match guarded replay.

CAF's [unit policy](https://www.commemorativeairforce.org/caf_documents/229) and
[NAEC disclosure](https://flynaec.org/non-profit-information/) establish common
control across the parent, units and supporting museum corporations. The ten
reviewed institutions receive the affiliation `commemorative_air_force`; three
supported duplicate pairs count once each. No blanket identity rule is applied
to the broader CAF directory or the 222-row research context.

- Florida: two descriptions of the DeLand wing hangar and its museum collection
  reconcile to one institution. The IMLS point is displaced from its address.
- Minnesota: the two Fleming Field descriptions reconcile to one museum.
- Georgia: IMLS Echo Street and the current Echo Court wing museum reconcile,
  supported by matching EIN and the official Dixie Wing rename. The operator
  currently restricts smaller artifact tours during redesign; aircraft and some
  large displays remain available. Recheck access before publication.
- Kansas: the generic source at 6 Aero Plaza receives the public name CAF Heart
  of America Wing. Its museum opens by appointment.
- Midland: the explicit High Sky row receives the name Midland Army Air Field
  Museum. All three source roles remain separately pending. Former headquarters,
  the current wing museum and a fleet-title corporation cannot be merged solely
  because their records share 9600 Wright Drive.
- Dallas: NAEC and adjacent headquarters retain separate pending identities;
  common control is established but the integrated-campus count is unresolved.
  Periodic public aircraft exhibits prevent an office-only exclusion inference.
- New Mexico: affiliation is established, but the old Albuquerque contact needs
  a primary bridge to a physical museum. The separate Hobbs description is not
  merged with Lobo Wing from shared state or organizational ancestry.

The batch adds six identity rows in three cases, ten decisions and two names.
Four reviews are complete and [six actions remain pending]({p.name}/human_review.csv).
Every starting candidate has a [recorded disposition]({p.name}/candidate_dispositions.csv).
The generic exact-name CAF group falls from seven to zero in the non-chain ranking
because affiliation is known. This does not mean all CAF identities are resolved.

Twenty-five of 26 public downloads were cached. High Sky's native download failed
certificate verification; indexed primary text was inspected and the failure was
retained without disabling security. [Web observations]({p.name}/web_observations.json)
and the [evidence ledger]({p.name}/evidence.csv) preserve sources and distinctions.
CAF 2019 audit PDF page 20 (printed 18) was rendered and inspected; minor font
substitution did not obscure its property-history evidence. The flying-museum
corporation's EIN 742554138 is kept distinct from static-museum EIN 742553763.

Old Jail Museum remains the provisional non-chain leader at eight with four
pending reviews. Its explicit publication gate still fails. Continue remaining
seven-count groups and earlier/M2 questions. The local post/explorer still show
the older Clinton/Madison/Monroe artifact checkpoint pending refresh. Publishing
destination and independent church labels remain outstanding.

Cloud spending remains **USD 0**, below USD 5. No outreach or external publication.
'''
p.with_suffix('.md').write_text(report,encoding='utf-8')
(p/'README.md').write_text(f'''# CAF evidence packet

Applied and validated checkpoint; see [report](../{p.name}.md).
Do not rerun `prepare.R` or `apply.R`.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: saved-output verification.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: decisions and six open actions.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: source audit.
- `ranking_before.csv`, `ranking_after.csv`, `analysis_after.csv`: dated count checkpoint.
- `protected_files.csv`, `*_before.csv`: prior-file hashes and input snapshots.
- `sources*.json`, `cache_status.csv`, `*.txt`, `web_observations.json`: provenance and failures.
- `source_dossier.json`, `imls_context.csv`, `overture_context.csv`, `irs_selected.json`: context.
- `headline_publication_gate.txt`: national headline remains blocked.

Before snapshot: `data/processed/museum_commemorative_air_force_before.rds`.
`build_validate.R --verify-only` applies only while this is the live checkpoint;
do not overwrite this historical packet after another snapshot protects it.
No independent matching labels were created.
''',encoding='utf-8')
checkpoint=f'The [Commemorative Air Force checkpoint](data/validation/{p.name}.md) validates 52,426 counted / 52,294 eligible museum institutions, 370 identity rows in 157 cases and 158 complete factual reviews (including exclusions). All 340 assertions and 26 integrity checks pass; 1,578 earlier evidence/label files remain unchanged. Four batch reviews are complete and six remain pending. CAF parent affiliation is supported; its total museum count is not certified.'
f=Path('HANDOFF.md');t=f.read_text(encoding='utf-8');a=t.index('**Active continuation:**');b=t.index('\n\n',a)
t=t[:a]+'**Active continuation:** See [FLIGHT_LOG.md](FLIGHT_LOG.md). '+checkpoint+' Next: remaining seven-count groups, then earlier unresolved/M2 queues. Old Jail Museum still leads provisionally with four pending reviews; no national winner is certified. Cloud spending USD 0, strictly below USD 5.'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('README.md');t=f.read_text(encoding='utf-8');a=t.index('The [Bedford/Belmont/Chatham checkpoint]');b=t.index('\n\n',a)
t=t[:a]+checkpoint+' Historical counts below describe earlier checkpoints. Local post/explorer still show the older Clinton/Madison/Monroe checkpoint; CSV filesystem saving remains unverified. Both drafts remain unpublished. Follow [FLIGHT_LOG.md](FLIGHT_LOG.md).'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('data/validation/README.md');t=f.read_text(encoding='utf-8');a=t.index('**Current checkpoint:');b=t.index('## Church work in progress',a)
t=t[:a]+f'''**Current checkpoint: 2026-09-26 [Commemorative Air Force review]({p.name}.md).**
Reviewed outputs preserve 60,002 source rows, with 57,126 counted rows, 52,426 counted institutions and 52,294 eligible for L2 analysis. There are 158 complete factual reviews, including exclusions. All 340 assertions and 26 integrity checks pass; 1,578 earlier evidence/label files are preserved. Counts remain provisional; unknown affiliation is not independence.

CAF parent affiliation is established. Three museum pairs reconcile; four reviews are complete and six remain pending. Continue the remaining seven-count groups and earlier/M2 queues. See [ranking]({p.name}/ranking_after.csv), [open actions]({p.name}/human_review.csv), [preceding checkpoint](museum_bedford_belmont_chatham_2026-09-26.md) and [handoff](../../HANDOFF.md). Old Jail Museum's four pending reviews still prevent certification; local post/explorer payloads retain the older Clinton/Madison/Monroe checkpoint.

'''+t[b:]
t=t.replace('364 rows in 154 cases','370 rows in 157 cases');f.write_text(t,encoding='utf-8')
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape');a=t.index('Current next action:');b=t.index('\n\n',a)
t=t[:a]+'Current next action: CAF checkpoint applied and validated: 52,426 counted / 52,294 eligible, 370 identity rows / 157 cases, 158 complete factual reviews. All 340 assertions and 26 integrity checks pass; 1,578 prior files preserved. Six CAF identity reviews remain pending. Never rerun its prepare or apply. Continue remaining seven-count groups, then earlier/M2 queues. Old Jail still has four pending reviews. Local post/explorer retain the older Clinton/Madison/Monroe checkpoint. Cloud spending USD 0.'+t[b:]
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+''' - CAF checkpoint validated

- Selective targets, reviewed Parquet and identity audit rebuilt. All 340 assertions and 26 integrity checks pass; zero failures, warnings or skips. The 1,578 prior files, baseline, source coordinates, human labels and threshold remain unchanged.
- Counts now validated: 60,002 rows, 57,126 counted rows, 52,426 institutions, 52,294 eligible, 370 identity rows / 157 cases, 158 complete reviews. Four new complete reviews; six explicit pending actions. No new not-museum or source-conflict decisions.
- Report and live pointers updated. Never rerun prepare/apply. CAF parent affiliation is resolved; its total museum count and national headlines remain uncertified.
- Continue Franklin Historical Society, Heritage Museum and Newton County Historical Society, then other seven-count groups and earlier/M2 queues. Local artifacts need a later refresh. USD 0 cloud spending.
'''
f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('CAF packet and live pointers finalized after verification.')
