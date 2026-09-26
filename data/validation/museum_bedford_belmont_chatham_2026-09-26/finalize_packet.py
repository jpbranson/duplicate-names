"""Finalize only after the saved outputs and unit tests pass."""
import csv,json
from pathlib import Path
from datetime import datetime,timezone
p=Path(__file__).parent
rows=lambda f:list(csv.DictReader((p/f).open(encoding='utf-8-sig')))
checks=rows('integrity_checks.csv')
assert len(checks)==27 and all(r['passed']=='TRUE' for r in checks)
log=(p/'build_validate.log').read_text(encoding='utf-8',errors='replace')
assert all(t in log for t in ['FAIL 0','WARN 0','SKIP 0','PASS 340','27 integrity checks passed'])
c=rows('counts.csv')[0]
assert c['counted_institutions']=='52429' and c['eligible']=='52297'
cache=rows('cache_status.csv');good=sum(r['status']=='cached' for r in cache)
assert len(cache)==47 and good==42
report=f'''# Bedford, Belmont and Chatham museum review — September 26, 2026

This checkpoint applies supported factual corrections to 21 starting exact-name
candidates and related museum records. It does not certify a national winner,
dataset-wide matching accuracy or visitor-ready map coordinates.

## Validated result

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,136 | 57,129 |
| Counted institutions | 52,437 | 52,429 |
| Eligible for L2 analysis | 52,305 | 52,297 |
| Guarded identity rows / cases | 351 / 147 | 364 / 154 |
| Complete factual reviews, including exclusions | 146 | 154 |
| Sourced not-museum exclusions | 23 | 24 |
| Preferred-name overrides | 91 | 95 |
| Isolated source conflicts | 30 | 31 |

All 340 assertions pass, with zero failures, warnings or skips. All 27 saved-output
and integrity checks pass. The 1,467 protected earlier evidence files and human
labels are unchanged. The automatic baseline, baseline multisite queue, source
fields and coordinates, and 0.85 matching threshold are unchanged. Reviewed
Parquet and the source-level identity audit match the guarded replay.

## Factual decisions

The batch adds 13 identity rows in seven cases, 16 factual decisions and four
public names. Eight reviews are complete and eight remain explicitly pending.
The bare-name non-chain groups change from seven each to Bedford three, Belmont
two and Chatham four.

- New York Bedford Museum receives its public name and society affiliation,
  supported by the operator's two separate museums. Its office/store at 612 Old
  Post Road is excluded using the operator's positive description. Neither a
  second museum source row nor an arbitrary office-to-branch merger is invented.
- Massachusetts Bedford's documented move reconciles its old and current
  addresses. Job Lane Farm Museum's separately elected Friends board is preserved
  as a different operator. New Hampshire Bedford is one integrated museum campus.
  Virginia's present Wharton House museum scope remains pending.
- California Belmont's park-address and museum-address records reconcile, with
  current governance still pending. North Carolina's museum and mailbox reconcile
  under its elected society board. Massachusetts Claflin Room receives its public
  name and shared affiliation with the society's offsite Wellington Station exhibits.
- New Hampshire Belmont's IMLS row mixes local legal/mail identity with the North
  Carolina physical address and website. It is separately uncounted and supplies
  no aliases. It is not a not-museum decision. Dayton Belmont's museum scope remains
  pending.
- Connecticut Chatham's officer mailbox reconciles with the museum/schoolhouse
  campus through an official state directory. Massachusetts society and museum
  descriptions reconcile to Atwood Museum. The two New Hampshire Chatham addresses
  remain separate pending a primary bridge. New Jersey's permanent museum scope
  and Ohio's old address/campus relationship remain pending.

Precise source keys and primary links are in [evidence.csv]({p.name}/evidence.csv).
All 21 starting candidates have a [recorded disposition]({p.name}/candidate_dispositions.csv).
The [eight human-review actions]({p.name}/human_review.csv) state what evidence is
missing; they are not completion claims. The broad 886-row context includes
unrelated institutions and does not imply all 886 received factual review.

## Evidence and limitations

Public downloads attempted {len(cache)} sources and cached {good}. Five failures
remain recorded: a 404, a timeout, two expired-certificate errors and an HTTP 522.
No certificate protections were disabled. [Web observations]({p.name}/web_observations.json)
distinguish indexed or directly inspected pages from cached original bytes.
IRS contact rows support identity, not by themselves museum scope or governance.

Visually checked Bedford's February 2022 move newsletter pages 1–2, Job Lane
bylaws page 3, Connecticut Register PDF page 747 (printed 737), and New Hampshire
registry page 56. The registry original was updated September 21, 2026; its data
supersede stale indexed text. Minor font substitution did not obscure the evidence.
The newsletter text extraction has an encoding defect; the rendered pages were
read directly to verify the move.

The related context also exposed possible unrelated quality leads: New Bedford
Whaling Museum and Fishing Heritage Center sharing a baseline entity, and Chatham
Railroad Museum appearing at two Massachusetts addresses. Neither is adjudicated
here; preserve them for a separate scoped audit. No unsupported change is applied.

Old Jail Museum remains the provisional non-chain leader at eight, with four
reviews pending and an explicit failed publication gate. Continue the remaining
seven-count groups and earlier/M2 queues. Local post/explorer artifacts retain the
older Clinton/Madison/Monroe checkpoint until a later refresh. Independent church
labels and publishing destination remain outstanding.

Cloud spending remains **USD 0**, below the USD 5 cap. No outreach, external
publication or paid service was used.
'''
p.with_suffix('.md').write_text(report,encoding='utf-8')
(p/'README.md').write_text(f'''# Bedford / Belmont / Chatham evidence packet

Applied and validated checkpoint; see [report](../{p.name}.md).
Do not rerun `prepare.R` or `apply.R`. Their one-time outputs are evidence.

- `counts.csv`, `integrity_checks.csv`, `build_validate.log`: verified saved outputs.
- `decisions_spec.json`, `evidence.csv`, `human_review.csv`: factual decisions and open actions.
- `candidate_dispositions.csv`, `records_after.csv`, `identity_audit_after.csv`: source-level audit.
- `ranking_before.csv`, `ranking_after.csv`, `analysis_after.csv`: count checkpoints.
- `protected_files.csv`, `*_before.csv`: earlier-file hashes and input snapshots.
- `cache_status.csv`, `sources*.json`, `*.txt`, `web_observations.json`: source provenance/failures.
- `source_dossier.json`, `imls_context.csv`, `overture_context.csv`, `irs_selected.json`: identity context.
- `headline_publication_gate.txt`: national headline still blocked.

The before RDS is `data/processed/museum_bedford_belmont_chatham_before.rds`.
`build_validate.R --verify-only` can replay checks only against this exact live
checkpoint. After subsequent decisions, use dated outputs for historical comparison;
do not overwrite a packet protected by a newer checkpoint. No independent matching
labels were created. Eight pending actions remain open.
''',encoding='utf-8')

checkpoint=f'The [Bedford/Belmont/Chatham checkpoint](data/validation/{p.name}.md) validates 52,429 counted / 52,297 eligible museum institutions, 364 identity rows in 154 cases and 154 complete factual reviews (including exclusions). All 340 assertions and 27 integrity checks pass; 1,467 earlier evidence/label files are unchanged. Eight batch reviews remain pending. The three bare-name non-chain groups now have three, two and four institutions.'
f=Path('HANDOFF.md');t=f.read_text(encoding='utf-8');a=t.index('**Active continuation:**');b=t.index('\n\n',a)
t=t[:a]+'**Active continuation:** See [FLIGHT_LOG.md](FLIGHT_LOG.md). '+checkpoint+' Next: remaining seven-count groups, then earlier unresolved/M2 queues. Old Jail Museum remains the provisional leader with four pending reviews; no national winner is certified. New York office/store is excluded; the mixed New Hampshire row is isolated without aliases. Cloud spending USD 0, strictly below USD 5.'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('README.md');t=f.read_text(encoding='utf-8');a=t.index('The [Madison/Marion/Milton checkpoint]');b=t.index('\n\n',a)
t=t[:a]+checkpoint+' Historical counts below describe earlier checkpoints. The museum draft and explorer retain the older Clinton/Madison/Monroe checkpoint pending refresh; the CSV filesystem-save check remains unverified. Both remain unpublished. Follow [FLIGHT_LOG.md](FLIGHT_LOG.md) for active work and budget tracking.'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('data/validation/README.md');t=f.read_text(encoding='utf-8');a=t.index('**Current checkpoint:');b=t.index('## Church work in progress',a)
t=t[:a]+f'''**Current checkpoint: 2026-09-26 [Bedford/Belmont/Chatham review]({p.name}.md).**
Reviewed outputs preserve 60,002 source rows, with 57,129 counted rows, 52,429 counted institutions and 52,297 eligible for L2 analysis. There are 154 complete factual reviews, including exclusions. All 340 assertions and 27 integrity checks pass; 1,467 earlier evidence/label files are preserved. Counts remain provisional; unknown affiliation is not independence.

The three bare-name non-chain groups fall from seven each to three, two and four. Eight batch reviews remain incomplete. Continue the remaining seven-count groups and earlier/M2 queues. See [ranking]({p.name}/ranking_after.csv), [open actions]({p.name}/human_review.csv), [preceding checkpoint](museum_madison_marion_milton_2026-09-26.md) and [handoff](../../HANDOFF.md). Old Jail Museum's four pending reviews still prevent certification; local post/explorer payloads retain the older Clinton/Madison/Monroe checkpoint.

'''+t[b:]
t=t.replace('319 rows in 134 cases, including twenty-nine source-conflict holdouts','364 rows in 154 cases, including thirty-one source-conflict holdouts')
f.write_text(t,encoding='utf-8')
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape');a=t.index('Current next action:');b=t.index('\n\n',a)
t=t[:a]+'Current next action: Bedford/Belmont/Chatham is applied and validated: 52,429 counted / 52,297 eligible, 364 identity rows / 154 cases, 154 complete factual reviews. All 340 assertions and 27 integrity checks pass; 1,467 prior files preserved. Eight pending actions remain. Never rerun its prepare or apply. Continue remaining seven-count groups, then earlier/M2 queues. Old Jail\'s four pending reviews still block the national headline. Local post/explorer payloads retain the older Clinton/Madison/Monroe checkpoint. Cloud spending USD 0.'+t[b:]
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+''' - Bedford/Belmont/Chatham checkpoint validated

- Selective targets, reviewed Parquet and identity audit rebuilt successfully. All 340 assertions pass with zero failures, warnings or skips; all 27 integrity checks pass. The 1,467 protected files and baseline/labels/source coordinates/0.85 threshold are unchanged.
- Applied counts are now validated saved outputs. Eight complete factual reviews added; eight actions remain pending. No national headline certification. New Bedford and Chatham Railroad baseline anomalies remain separate unreviewed leads.
- Report, packet index, HANDOFF, README and validation index updated. Never rerun one-time scripts. Local post/explorer remain at the older artifact checkpoint.
- Continue remaining seven-count groups, earlier factual blockers and M2 queues. Publishing destination and independent church labels still missing. USD 0 cloud spending.
'''
f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Finalized report and live resume pointers after all verified checks.')
