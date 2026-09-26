"""Finalize only after selective rebuild and validation succeed."""
import csv,json
from pathlib import Path
from datetime import datetime,timezone
p=Path(__file__).parent
rows=lambda f:list(csv.DictReader((p/f).open(encoding='utf-8-sig')))
checks=rows('integrity_checks.csv');n=len(checks)
assert n>=25 and all(r['passed']=='TRUE' for r in checks)
log=(p/'build_validate.log').read_text(encoding='utf-8',errors='replace')
assert all(s in log for s in ['FAIL 0','WARN 0','SKIP 0','PASS 340',f'{n} integrity checks passed'])
c=rows('counts.csv')[0];assert c['counted_institutions']=='52387' and c['eligible']=='52255' and c['complete_reviews']=='174'
assert len(rows('candidate_dispositions.csv'))==48 and len(rows('human_review.csv'))==28
cache=rows('cache_status.csv');assert len(cache)==47 and sum(r['status']=='cached' for r in cache)==31
report=f'''# Leading M2 groups: identity and meaning — September 26, 2026

This bounded pass examined 48 starting records across twelve leading scope-word
name groups. It applies 37 explicit identity rows in fourteen new cases, 29 factual
decisions and two current public names. Four reviews are newly complete; 25 newly
reviewed institutions remain pending. Three earlier African American Museum
questions are carried forward, giving **28 open actions**. The separately verified
Bowling Green review remains unchanged. No national headline is certified.

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,107 | 57,083 |
| Counted institutions | 52,409 | 52,387 |
| Eligible for L2 analysis | 52,277 | 52,255 |
| Guarded identity rows / cases | 403 / 171 | 440 / 185 |
| Complete factual reviews, including exclusions | 170 | 174 |
| Positive not-museum exclusions | 24 | 25 |
| Preferred public names | 103 | 105 |
| Isolated source conflicts | 33 | 35 |

All **340 assertions and {n} integrity checks pass**, with no failures, warnings or
skips. All **1,887 earlier evidence/label files remain unchanged**. The automatic
baseline, source names/coordinates, multisite queue and 0.85 threshold are intact.
Reviewed Parquet and source-level identity audit match replay. Two pending generic
Smithsonian decisions are deliberately retired because their rows are absorbed
into the named New York museum; their original decisions are archived. No other
prior factual, identity or preferred-name decisions change.

- The Oregon International Police Museum's former and current descriptions
  reconcile using its move history, current operator and local visitor bureau.
  Its factual review is complete. California and Pennsylvania remain unresolved.
- The two Old World Wisconsin campus descriptions reconcile under Wisconsin
  Historical Society ownership. Three foundation/office descriptions reconcile
  separately and are excluded on the foundation's affirmative fundraising mission.
  Both reviews are complete; a mailbox is not the exclusion basis.
- Appomattox has a complete review as an American Civil War Museum location.
  The Tredegar physical/mail pair reconciles, but predecessor/office source roles
  remain pending. Gettysburg receives its documented current Heritage Center name;
  the separate learning barn's counting role still needs confirmation.
- AMNH, Crystal Bridges, the Museum of American Armor and International Folk Art
  receive supported physical/mail or displaced-record corrections. Ambiguous
  additional addresses stay separate. Crystal Bridges/Momentary and New Mexico
  parent affiliations are supported independently of those pending identities.
- Chattanooga's former Northgate and current Aquarium Plaza descriptions reconcile
  under the current **Coolidge National Medal of Honor Heritage Center** name.
  Texas remains distinct. The 400 Georgia description and a TN-storage/SC-foundation
  baseline cluster need further work; neither is silently assigned to a museum.
- NMAAHC's public museum, IMLS counterpart and conservation-lab description
  reconcile. A mixed Smithsonian row combining different museums' addresses is
  isolated. A second row combining the DC title and Iowa source context is also
  isolated. Neither contributes disputed aliases to an accepted institution.
- NMAI's New York and Washington descriptions reconcile within their separate
  campuses, including two generic Smithsonian records at One Bowling Green with
  the exact museum phone. Other ambiguous historical/address/venue records remain
  pending. Shared Smithsonian operation does not merge the two public campuses.
- Seneca-Iroquois Museum's documented 2018 move and current duplicate reconcile.
  Its malformed IMLS mailing description and legal identifier remain separately
  pending. The county move notice and current tribal operator are retained.

The [scope-word review]({p.name}/scope_word_review.csv) separates linguistic meaning
from source identity. American Art, American Armor and international collections
describe subjects; National can reflect tribal governance or institutional reach;
Old World is an idiom. These interpretations neither certify the counts nor establish
that any institution claims exclusive national/global authority.

See [all starting dispositions]({p.name}/candidate_dispositions.csv),
[factual evidence]({p.name}/evidence.csv), [open actions]({p.name}/human_review.csv),
[audit]({p.name}/identity_audit_after.csv) and [integrity checks]({p.name}/integrity_checks.csv).
The packet contains 1,458 pinned Overture context rows and selected cached IRS rows.
Of 47 requested public documents, 31 were cached; 16 failures remain documented.
Separately recorded official web observations support limited facts where native
requests failed. Three PDF pages were rendered and visually inspected; relevant
text is legible despite Poppler font warnings. Historical evidence is not a current
access guarantee. All generated source points require separate publication checks.

Old Jail remains the provisional non-chain leader at eight, with four pending
reviews and a failing publication gate. Remaining M2 groups, prior identity actions,
church independent labels and the missing publication destination remain unfinished.
The post and explorer still need to be refreshed from their earlier checkpoint.

Cloud resource spending **USD 0**, strictly below USD 5. No outreach or publication.
'''
p.with_suffix('.md').write_text(report,encoding='utf-8')
(p/'README.md').write_text(f'''# M2 leading-group evidence packet

Applied and validated; [report](../{p.name}.md). Do not rerun prepare.R, apply.R,
prepare_validation.py or finalize_packet.py. Preserve this packet after a successor
records its hashes. Before RDS: data/processed/museum_m2_leaders_before.rds.

- counts.csv, integrity_checks.csv, build_validate.log: verified checkpoint.
- candidate_dispositions.csv: all 48 starting records.
- decisions_spec.json, evidence.csv, human_review.csv: factual reasoning and open work.
- scope_word_review.csv: semantic interpretation, separate from count certification.
- identity_audit_after.csv and records_after.csv: source-level corrections.
- *_before.csv and protected_files.csv: preserved original inputs and hashes.
- cache_status.csv, sources*.json, manifest_after.json, web_observations.json: provenance.
- PDF PNGs and pdf_visual_review.md: visual checks.
- headline_publication_gate.txt: unfinished national headline gate.

Read-only build_validate.R --verify-only is valid only while this is the live
checkpoint; it writes checkpoint evidence, so never rerun after a successor freezes it.
No independent matching labels were created.
''',encoding='utf-8')
checkpoint=f'The [M2 leading-group checkpoint](data/validation/{p.name}.md) validates 52,387 counted / 52,255 eligible museum institutions, 440 identity rows in 185 cases and 174 complete factual reviews (including exclusions). All 340 assertions and {n} integrity checks pass; 1,887 prior evidence/label files remain unchanged. Four batch reviews are newly complete; 28 open actions remain, including three carried forward.'
f=Path('HANDOFF.md');t=f.read_text(encoding='utf-8');a=t.index('**Active continuation:**');b=t.index('\n\n',a)
t=t[:a]+'**Active continuation:** See [FLIGHT_LOG.md](FLIGHT_LOG.md). '+checkpoint+' Next: consolidate remaining factual blockers and refresh local artifacts. Old Jail has four pending reviews; no national winner is certified. Cloud spending USD 0.'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('README.md');t=f.read_text(encoding='utf-8');a=t.index('The [Telephone/Union/Washington checkpoint]');b=t.index('\n\n',a)
t=t[:a]+checkpoint+' Historical counts below describe earlier checkpoints. Local artifacts still need refresh. Both drafts remain unpublished; see [FLIGHT_LOG.md](FLIGHT_LOG.md).'+t[b:];f.write_text(t,encoding='utf-8')
f=Path('data/validation/README.md');t=f.read_text(encoding='utf-8');a=t.index('**Current checkpoint:');b=t.index('## Church work in progress',a)
t=t[:a]+f'''**Current checkpoint: 2026-09-26 [M2 leading groups]({p.name}.md).**
Reviewed outputs preserve 60,002 rows: 57,083 counted source rows, 52,387 institutions and 52,255 eligible for L2 analysis. There are 174 complete factual reviews including exclusions, 440 identity rows in 185 cases, and 35 isolated source conflicts. All 340 assertions and {n} integrity checks pass; 1,887 prior files are preserved. Counts remain provisional; unknown affiliation is not independence.

Four new complete reviews and 28 open actions, including three carried forward. See [ranking]({p.name}/ranking_after.csv), [actions]({p.name}/human_review.csv), [scope-word interpretation]({p.name}/scope_word_review.csv), [preceding checkpoint](museum_telephone_union_washington_2026-09-26.md) and [handoff](../../HANDOFF.md). Old Jail still has four pending reviews. Local artifacts require refresh.

'''+t[b:];t=t.replace('403 rows in 171 cases','440 rows in 185 cases');f.write_text(t,encoding='utf-8')
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape');a=t.index('Current next action:');b=t.index('\n\n',a)
t=t[:a]+f'Current next action: M2 checkpoint validated: 52,387 counted / 52,255 eligible, 440 identity rows / 185 cases, 174 complete reviews. All 340 assertions and {n} integrity checks pass; 1,887 prior files preserved. Never rerun prepare/apply. Consolidate remaining factual blockers and refresh local artifacts; earlier/M2 reviews, church labels and publication remain incomplete. USD 0 cloud spending.'+t[b:]
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+f''' - M2 leading-group checkpoint validated

- Selective exports rebuilt; 340 assertions and {n} integrity checks pass, zero failures/warnings/skips. All 1,887 prior protected files, source coordinates, baseline, labels and threshold preserved.
- Counts: 60,002 rows; 57,083 counted rows; 52,387 institutions; 52,255 eligible; 440 identity rows / 185 cases; 174 complete reviews; 25 not-museum exclusions; 105 names; 35 isolated conflicts.
- Four new complete reviews; 25 new pending reviews and three carried-forward actions. All 48 starting records have dispositions. Twelve semantic interpretations are separate from count certification. Two absorbed generic Smithsonian pending decisions explicitly retired; originals archived.
- Packet frozen after this finalization. Next consolidate unresolved work and refresh post/explorer. Old Jail still has four pending reviews; church independent labels and publication destination still missing. No national headline certified or draft published. Cloud spending USD 0.
''';f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Validated checkpoint, report and live pointers finalized.')
