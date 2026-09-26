"""Close this bounded checkpoint only after validation and browser QA are recorded."""
from pathlib import Path
import json,csv,hashlib
from datetime import datetime,timezone
p=Path(__file__).parent
read=lambda n:json.loads((p/n).read_text(encoding='utf-8'))
c=read('checkpoint.json');b=read('data_build.json');r=read('standalone_build.json')
v=read('serialized_payload_checks.json');t=read('test_summary.json')
assert c['status']=='validated_provisional' and c['eligible']==442832 and c['checks']>=20
assert t['passed']==352 and not any(t[x] for x in ['failed','errors','warnings','skips'])
assert r['status']=='passed' and v['status']=='passed' and len(v['checks'])==4
assert b['collections']['churches']['eligible']==442832 and b['collections']['churches']['verified']==0
assert 'browser_verified: yes' in (p/'artifact_QA.md').read_text(encoding='utf-8')
protected=list(csv.DictReader((p/'protected_files.csv').open(encoding='utf-8-sig')))
assert all(hashlib.sha256(Path(x['path']).read_bytes()).hexdigest()==x['sha256'] for x in protected)
assert len(protected)==2020
assert '7 asynchronous' in (p/'js_loading_final.log').read_text(encoding='utf-8')
assert '19 focused' in (p/'js_data_final.log').read_text(encoding='utf-8')
f=p/'README.md';s=f.read_text(encoding='utf-8');start=s.index('Work is in progress.');end=s.index('\n\nThe source snapshot',start)
s=s[:start]+f'''This bounded implementation and evidence checkpoint is validated. The whole project
and church headline review remain incomplete. Do not rerun snapshot/apply/finalize
scripts or overwrite this packet after subsequent work begins.

All 352 assertions across 73 tests and {c['checks']} integrity checks pass. The pipeline
retains 1,032,223 original rows and 540,778 canonical Overture descriptions. Two sourced
scope holds reduce eligibility to 442,832. There are {c['analysis_ordinal_changes']}
changed canonical ordinal values and zero complete factual reviews. All 2,020 prior
files are byte-preserved. A rapid collection/scope-change loading race and stale empty-table caption were
fixed, with 7 asynchronous and 19 data/import/export JS assertions passing.
The church draft rendered independently ({r['build']['bytes']:,}
bytes), and both dashboard datasets pass serialized L2/L3 verification. Browser QA
is recorded in artifact_QA.md; publication and independent evaluation remain blocked.'''+s[end:]
f.write_text(s,encoding='utf-8')
report=Path('data/validation/church_ordinal_review_2026-09-26.md')
report.write_text('''# Church ordinal and scope checkpoint — September 26, 2026

The day-modifier parser correction and two sourced scope exclusions are implemented
and validated. National headline and accuracy claims remain incomplete.

- 1,032,223 original source rows retained; automatic membership unchanged.
- 540,778 canonical descriptions; 442,832 eligible after two scope holds.
- 352 assertions, full output integrity and serialized dashboard checks pass.
- 2,020 earlier files preserved, including independent version-2 labels.
- Zero complete church factual reviews; no independent labels supplied.
- Ten high-number candidates documented: five unresolved, three partial and two
  with supported scope exclusions. Number semantics and identity remain distinct.
- The local church draft and explorer are refreshed; publication is incomplete.
- Cloud resource spending USD 0.

See the [packet](church_ordinal_review_2026-09-26/README.md),
[leader evidence](church_ordinal_review_2026-09-26/leader_review.csv),
[human follow-ups](church_ordinal_review_2026-09-26/human_review.csv),
[integrity checks](church_ordinal_review_2026-09-26/integrity_checks.csv), and
[artifact QA](church_ordinal_review_2026-09-26/artifact_QA.md).

The parser excludes day modifiers from congregation numbering but retains outer
ordinals such as First Seventh Day Baptist. Its full dry run changed 225 source rows
and two cross-source comparison predictions, with no cluster membership changes.
This is a deterministic integrity result, not a measurement of matching accuracy.

Alexandria and Miami COGASOC records have explicit name/entity/point/member guards.
Their operator pages match the source addresses and phones; the parent describes
its faith as Judaism. The analysis holds these outside Christian-only statistics,
preserving source religion, original identity and pending overall review status.
The cached parent directory supports a later review of additional linked records;
they have not been broadly reclassified by name alone.
''',encoding='utf-8')
f=Path('HANDOFF.md');s=f.read_text(encoding='utf-8');a=s.index('**Church continuation:**');z=s.index('\n\n',a)
s=s[:a]+f'''**Church continuation:** The [ordinal/scope checkpoint](data/validation/church_ordinal_review_2026-09-26.md) retains 1,032,223 raw rows and 540,778 canonical descriptions, with 442,832 eligible after two sourced COGASOC scope holds. Day-modifier parsing is corrected; automatic memberships are unchanged. All 352 assertions and {c['checks']} integrity checks pass; 2,020 prior files preserved. Draft/explorer refreshed and browser-checked. Ten high ordinals have documented findings; five unresolved cases need human review, three remain partial, and two have scope-only corrections. Zero complete factual reviews. Independent version-2 labels remain blank; source research does not grade them. No national maximum or project completion is certified.'''+s[z:]
s=s.replace('540,778 church records (442,834 eligible; zero complete factual reviews)','540,778 church records (442,832 eligible after the church scope checkpoint; zero complete factual reviews)')
f.write_text(s,encoding='utf-8')
f=Path('README.md');s=f.read_text(encoding='utf-8');needle='The national church build is complete in a separate target store:'
s=s.replace(needle,'''The [church ordinal/scope checkpoint](data/validation/church_ordinal_review_2026-09-26.md)
corrects day-name parsing and holds two operator-confirmed Jewish tabernacles outside
Christian-only analysis. It preserves the automatic identities: 540,778 canonical
descriptions, 442,832 eligible. Tests and local artifacts pass; independent labels,
remaining factual checks and publication are still incomplete.

The initial national church build is complete in a separate target store:''')
f.write_text(s,encoding='utf-8')
f=Path('data/validation/README.md');s=f.read_text(encoding='utf-8');needle='## Church work in progress\n'
s=s.replace(needle,needle+'''
Latest: [ordinal/scope checkpoint](church_ordinal_review_2026-09-26.md), with 442,832
eligible descriptions, 352 passing assertions and preserved original identities.
Live `church_scope_decisions.csv` adds two guarded analytical exclusions; it does
not change source religion or certify full factual review. Preserve it with the
other live decision inputs before future changes. The ten-leader evidence and
remaining actions are in the dated packet.\n''')
f.write_text(s,encoding='utf-8')
f=Path('DESIGN.md');s=f.read_text(encoding='utf-8');needle='> distance summaries restrict both endpoints to the selected First cohort.'
s=s.replace(needle,needle+'''
> Day modifiers (Seventh Day, Eighth Day, Third Day) are also held out of congregation
> numbering, while outer ordinals remain. Two exact operator-linked COGASOC records
> are held outside Christian-only scope; source religion and identity are preserved.''')
f.write_text(s,encoding='utf-8')
f=Path('dashboard/README.md');s=f.read_text(encoding='utf-8').replace('data/validation/artifact_refresh_2026-09-26','data/validation/church_ordinal_review_2026-09-26');f.write_text(s,encoding='utf-8')
f=Path('FLIGHT_LOG.md');s=f.read_text(encoding='utf-8',errors='surrogateescape');a=s.index('Current next action:');z=s.index('\n\n',a)
s=s[:a]+'''Current next action: church ordinal/scope checkpoint validated; local draft and explorer refreshed. Continue remaining museum headline and church factual source checks; investigate additional operator-linked COGASOC candidates against the cached directory. Five highest-ordinal cases are flagged for human review. Independent church labels and publication destination remain missing. Counts: museums 52,387 counted / 52,255 eligible / 174 complete reviews; churches 540,778 canonical / 442,832 eligible / zero complete reviews. Do not rerun frozen packet scripts. Cloud spending USD 0.'''+s[z:]
s+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+f''' - Church ordinal/scope checkpoint validated

- Day-modifier guard and two sourced Christian-scope exclusions are implemented. Full dry run changed 225 source rows, 19 conflict flags and two cross-source predictions, with zero automatic membership changes. 0.85 unchanged; original source fields preserved.
- All 352 assertions across 73 tests and {c['checks']} output integrity checks pass. Original 1,032,223 rows and 540,778 canonical descriptions remain; eligibility is 442,832. Canonical ordinal changes: {c['analysis_ordinal_changes']}. Zero complete factual reviews or independent accuracy labels.
- Preserved 2,020 prior files and working-label snapshots. Ten high ordinals documented; five unresolved, three partial, two scope-only corrections. Twenty-one public URL attempts, eighteen cached; access failures retained. Three evidentiary PDF pages visually checked.
- Browser QA found and fixed a collection/scope loading race and stale empty-table caption. Seven async and 19 existing JS assertions pass.
- Church standalone draft rendered ({r['build']['bytes']:,} bytes), current payloads and both dashboard datasets validated. Browser QA recorded separately. Existing map points were verified unchanged and reused. Publication remains incomplete.
- Resume from the dated packet and explicit action queues. Broader museum headline checks and church factual reviews remain unfinished; independent labels and destination require human input. No outreach/deployment. Cloud spending USD 0.
'''
f.write_bytes(s.encode('utf-8',errors='surrogateescape'))
print('Church checkpoint finalized; project remains incomplete.')
