"""Finalize only after successful saved-output checks and test summary."""
import csv, json
from pathlib import Path
from datetime import datetime, timezone

p = Path(__file__).parent
readcsv = lambda f: list(csv.DictReader((p/f).open(encoding='utf-8-sig')))
checks = readcsv('integrity_checks.csv')
assert len(checks) == 27 and all(r['passed'] == 'TRUE' for r in checks)
log = (p/'build_validate.log').read_text(encoding='utf-8', errors='replace')
assert 'FAIL 0' in log and 'WARN 0' in log and 'SKIP 0' in log and 'PASS 340' in log
assert '27 integrity checks passed' in log
counts = readcsv('counts.csv')[0]
assert counts['counted_institutions']=='52437' and counts['eligible']=='52305'
spec=json.loads((p/'decisions_spec.json').read_text(encoding='utf-8'))
report = '''# Madison, Marion County and Milton museum review — September 26, 2026

This checkpoint applies supported factual corrections after reviewing 24 starting
exact-name candidates and their related records. It does **not** certify a national
winner, dataset-wide matching accuracy, or publication-ready map points.

## Validated result

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,156 | 57,136 |
| Counted institutions | 52,455 | 52,437 |
| Eligible for L2 analysis | 52,323 | 52,305 |
| Guarded identity rows / cases | 319 / 134 | 351 / 147 |
| Complete factual reviews, including exclusions | 132 | 146 |
| Sourced not-museum exclusions | 22 | 23 |
| Preferred-name overrides | 80 | 91 |
| Isolated source conflicts | 29 | 30 |

All 340 assertions pass, with zero failures, warnings or skips. All 27 saved-output
and integrity checks pass. The 1,351 protected earlier evidence files and human
labels are unchanged. Baseline entities, baseline multi-site queue, source fields,
coordinates and the 0.85 matching threshold are unchanged. Reviewed Parquet and
the source-level identity audit match the guarded replay.

## Scope and decisions

The batch adds 32 identity rows in 13 cases, 22 factual decisions and 11 public
names. Fourteen reviews are complete; eight are explicitly pending. The three
bare-name non-chain groups fall from eight each to Madison one, Marion County two,
and Milton zero. These are corrections to source identities and names, not claims
that the places no longer exist.

- New Hampshire Madison records reconcile to the public museum. Connecticut keeps
  its two separate museums under the same society. Louisiana's society mailbox
  reconciles to Hermione Museum.
- New Jersey's research office is excluded using its current operator description
  and explicit future museum plans. New York receives its full public name but
  remains pending. The older Ohio address cluster remains separate pending a
  specific historical address bridge.
- Ohio Heritage Hall is affiliated with its society's other operated sites. The
  co-located Popcorn Museum remains a separate institution with unresolved
  affiliation. Iowa's single historical village receives its public name.
- Oregon's documented merger reconciles the predecessor records to Willamette
  Heritage Center. Georgia's historical operator mailbox and transfer history
  reconcile to university-affiliated Pasaquan. Alabama, Missouri and current
  Mississippi operator scope remain pending.
- Milton's Pennsylvania, Vermont, Wisconsin and Massachusetts museum records are
  reconciled. Delaware's institution receives its public museum name. The mixed
  Massachusetts IMLS row remains separately uncounted, supplying no aliases to
  either state's accepted museum.

Per-case primary links, precise rationale and source keys are in
[evidence.csv](museum_madison_marion_milton_2026-09-26/evidence.csv).
All 24 original candidates have a
[recorded disposition](museum_madison_marion_milton_2026-09-26/candidate_dispositions.csv).
The [eight follow-ups](museum_madison_marion_milton_2026-09-26/human_review.csv)
describe exactly what evidence is still needed. A similar Iowa 210 Union Street
field is retained as a separate, unreviewed source-quality lead.

## Evidence and limits

The snapshot preserves 606 related baseline rows; the broad name search also
includes Hamilton strings and does not imply that all 606 were reviewed. Public
downloads attempted 64 sources, caching 56; eight failures are recorded, including
403/404, timeout, certificate and HTTP/2 errors. No certificate protection was
disabled. [Web observations](museum_madison_marion_milton_2026-09-26/web_observations.json)
clearly distinguish inspected web text from uncached native bytes. IRS contact
records are identity bridges, not proof by themselves of museum scope or
independent governance.

Louisiana guide page 11, New York trail page 2 and New Hampshire annual report
page 116 were visually checked. Font substitutions did not obscure the evidence.
Publication still requires current access and sourced visitor coordinates, notably
for mailing or discrepant points. All proposed changes passed the dry run before
the one-time application; no identity guard was changed.

Old Jail Museum remains the provisional non-chain leader at eight, with four
reviews pending; its explicit publication gate fails. Continue the seven-count
groups, beginning Bedford, Belmont and Chatham Historical Society, and preserve
earlier unresolved and M2 queues. Post and explorer artifacts still contain the
older Clinton/Madison/Monroe checkpoint and need a later refresh. Independent
church labels and the publishing destination remain outstanding.

Cloud spending remains **USD 0**, below the USD 5 cap. No outreach, external
publication or paid service was used.
'''
p.with_suffix('.md').write_text(report,encoding='utf-8')
(p/'README.md').write_text('''# Madison / Marion County / Milton evidence packet

Applied and validated checkpoint; see [report](../museum_madison_marion_milton_2026-09-26.md).
Do not rerun `prepare.R` or `apply.R`. Their one-time outputs are evidence.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: saved-output validation.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: factual decisions and open actions.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: source-level audit.
- `ranking_before.csv`, `ranking_after.csv`, `analysis_after.csv`: count checkpoints.
- `protected_files.csv`: unchanged earlier files; `*_before.csv`: input snapshots.
- `cache_status.csv`, `sources*.json`, `*.txt`, `web_observations.json`: source provenance and failures.
- `source_dossier.json`, `imls_context.csv`, `overture_context.csv`, `irs_selected.json`: identity context.
- `headline_publication_gate.txt`: national headline remains blocked.

Read-only replay against this same live input checkpoint:

```powershell
$env:RENV_PATHS_ROOT='C:/Developer/duplicate-names/data/processed/renv-runtime'
$env:RENV_PATHS_SANDBOX='C:/Developer/duplicate-names/data/processed/renv-runtime/sandbox'
& 'C:/Program Files/R/R-4.4.2/bin/Rscript.exe' data/validation/museum_madison_marion_milton_2026-09-26/build_validate.R --verify-only
```

After subsequent decisions, use the dated CSVs and before RDS for historical
comparison; do not rerun this script against changed live inputs or overwrite a
packet protected by a newer checkpoint. No independent matching labels were made.
''',encoding='utf-8')

handoff=Path('HANDOFF.md');t=handoff.read_text(encoding='utf-8')
start=t.index('**Active continuation:**');end=t.index('\n\n',start)
t=t[:start]+'''**Active continuation:** See [FLIGHT_LOG.md](FLIGHT_LOG.md). The [Madison/Marion/Milton checkpoint](data/validation/museum_madison_marion_milton_2026-09-26.md) validates 52,437 counted / 52,305 eligible museum institutions, 351 identity rows in 147 cases and 146 complete factual reviews (including exclusions). All 340 assertions and 27 integrity checks pass; 1,351 earlier evidence/label files are unchanged. The three bare-name non-chain groups fall from eight each to one, two and zero. Eight batch reviews remain pending, with precise actions. New Jersey's research office is excluded; the Massachusetts mixed IMLS row is isolated without aliases. Next: Bedford, Belmont and Chatham Historical Society (seven each), then earlier unresolved/M2 queues. Old Jail Museum remains the provisional leader with four pending reviews; no national winner is certified. Cloud spending USD 0, strictly below USD 5.'''+t[end:]
handoff.write_text(t,encoding='utf-8')
root=Path('README.md');t=root.read_text(encoding='utf-8')
start=t.index('The [Jefferson/Lincoln checkpoint]');end=t.index('\n\n',start)
t=t[:start]+'''The [Madison/Marion/Milton checkpoint](data/validation/museum_madison_marion_milton_2026-09-26.md) supersedes the historical counts below: 52,437 counted / 52,305 eligible museum institutions, 351 identity rows in 147 cases and 146 complete factual reviews (including exclusions). All 340 assertions and 27 integrity checks pass; 1,351 earlier evidence/label files are unchanged. Eight batch reviews remain incomplete. The museum draft and explorer retain the older Clinton/Madison/Monroe checkpoint pending an artifact refresh; the CSV filesystem-save check remains unverified. Both remain unpublished. Follow [FLIGHT_LOG.md](FLIGHT_LOG.md) for active work and budget tracking.'''+t[end:]
root.write_text(t,encoding='utf-8')
index=Path('data/validation/README.md');t=index.read_text(encoding='utf-8')
start=t.index('**Current checkpoint:');end=t.index('\n\n',t.index('The Jefferson and Lincoln',start))
t=t[:start]+'''**Current checkpoint: 2026-09-26 [Madison/Marion/Milton review](museum_madison_marion_milton_2026-09-26.md).**
Reviewed outputs preserve 60,002 source rows, with 57,136 counted rows, 52,437 counted institutions and 52,305 eligible for L2 name analysis. There are 146 complete factual reviews, including exclusions. All 340 assertions and 27 integrity checks pass; 1,351 earlier evidence/label files are preserved. Counts remain provisional; chains are reported separately and unknown affiliation is not independence.

The Madison, Marion County and Milton Historical Society bare-name non-chain groups fall from eight each to one, two and zero. Eight batch reviews remain incomplete. Bedford, Belmont and Chatham Historical Society are next at seven each; earlier/M2 queues remain open. See the [latest ranking](museum_madison_marion_milton_2026-09-26/ranking_after.csv), [eight human-review actions](museum_madison_marion_milton_2026-09-26/human_review.csv), [previous Jefferson/Lincoln checkpoint](museum_jefferson_lincoln_2026-09-26.md), and [project handoff](../../HANDOFF.md). Earlier dated queues retain their evidence. Old Jail Museum's four pending reviews still prevent certification; post/explorer payloads retain the older Clinton/Madison/Monroe checkpoint.'''+t[end:]
index.write_text(t,encoding='utf-8')
flight=Path('FLIGHT_LOG.md');t=flight.read_text(encoding='utf-8',errors='surrogateescape')
start=t.index('Current next action:');end=t.index('\n\n',start)
t=t[:start]+'''Current next action: Madison/Marion/Milton is applied and validated: 52,437 counted / 52,305 eligible, 351 identity rows / 147 cases, 146 complete factual reviews. All 340 assertions and 27 integrity checks pass; 1,351 prior files preserved. Eight incomplete reviews have concrete human actions. Never rerun its prepare or apply scripts. Next: Bedford, Belmont and Chatham Historical Society (seven each), then earlier/M2 queues. Old Jail's four pending reviews still block the national headline. Generated analysis is current; local post/explorer payloads still reflect the older Clinton/Madison/Monroe checkpoint. Cloud spending USD 0.'''+t[end:]
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+''' - Madison/Marion/Milton checkpoint validated

- Selective targets, reviewed Parquet and identity audit rebuilt successfully. All 340 assertions pass with zero failures, warnings or skips; all 27 integrity checks pass. The 1,351 protected files and baseline/labels/source coordinates/0.85 threshold are unchanged.
- The applied counts are now validated saved outputs. Fourteen complete factual reviews added, eight pending actions retained. Bare-name non-chain groups fall from eight each to one, two and zero. No national headline certification.
- Final report, evidence ledger, packet index, HANDOFF, README and validation index updated. Do not rerun one-time scripts. Post/explorer remain at the older artifact checkpoint.
- Continue Bedford/Belmont/Chatham (seven each), earlier factual blockers and M2 queues. Publishing destination and independent church labels still missing. USD 0 cloud spending.
'''
flight.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Finalized report, packet index and live resume pointers after verified checks.')
