"""Record artifact verification without certifying research or publication."""
from pathlib import Path
import json,csv,hashlib
from datetime import datetime,timezone
p=Path(__file__).parent
read=lambda f:json.loads((p/f).read_text(encoding='utf-8'))
build=read('data_build.json');verified=read('serialized_payload_checks.json');render=read('standalone_build.json')
assert verified['status']=='passed' and len(verified['checks'])==4 and verified['states']==51
assert render['status']=='passed' and render['build']['bytes']==669813
assert build['collections']['museums']=={'records':52719,'eligible':52255,'unmapped':0,'aliases':6329,'verified':174}
assert build['collections']['churches']['eligible']==442834 and build['collections']['churches']['verified']==0
assert '19 focused' in (p/'js_assertions.log').read_text(encoding='utf-8')
protected=list(csv.DictReader((p/'protected_files.csv').open(encoding='utf-8-sig')))
assert len(protected)==1990
assert all(hashlib.sha256(Path(r['path']).read_bytes()).hexdigest()==r['sha256'] for r in protected)
for n in ['museum_identity_decisions','museum_decisions','museum_name_overrides','museum_chain_rules']:
 assert (p/(n+'_before.csv')).read_bytes()==Path('data/validation/'+n+'.csv').read_bytes()
q=p/'artifact_QA.md';t=q.read_text(encoding='utf-8');t+='\nThe single-review grammar fix is browser-verified. A versioned local app script\nreference was needed to refresh the cached JavaScript. All 19 focused assertions\npass. A read-only process-inspection command returned Access denied; no permission\nchange or escalation was attempted. Current artifact files were inspected after\na patch/retry reported an already-changed line.\n';q.write_text(t,encoding='utf-8')
(p/'README.md').write_text('''# Artifact refresh — September 26, 2026

Local artifacts rebuilt and checked; publication remains incomplete. Do not rerun
prepare.py. This packet records 1,990 preserved prior files and unchanged factual
decision inputs. The source checkpoint is museum_m2_leaders_2026-09-26.

- standalone_build.json: isolated museum render; 669,813 bytes, Pandoc 3.11.
- data_build.json, serialized_payload_checks.json: both categories and L2/L3.
- js_assertions.log: 19 passing focused assertions.
- artifact_QA.md: browser findings, download limitation and approval rejection.
- current_review_followup.csv: 233 reviewed but unresolved descriptions.
- unreviewed_institutions.csv: 51,904 eligible descriptions without factual evidence.
- current_ranking.csv, m2_candidates.csv: unfinished candidate queues.
- publication_*: current gates, provisional counts and blockers used by draft.

The explorer contains 52,719 museum canonical descriptions including holds, with
52,255 eligible, 6,329 with aliases and 174 complete reviews including exclusions.
That display inventory differs from 52,387 counted institutions. Church inventory
remains 540,778 canonical / 442,834 eligible / zero complete factual reviews.
Compressed payloads occupy 77.22544 MiB. No remote tiles or paid services.

Unresolved factual cases and unreviewed groups are distinct. Independent church
labels and publication destination are still missing. Actual browser CSV saving
is unverified. No national headline or project completion is certified.
''',encoding='utf-8')
f=Path('HANDOFF.md');t=f.read_text(encoding='utf-8');a=t.index('**Explorer and drafts:**');b=t.index('\n\n',a)
t=t[:a]+'''**Explorer and drafts:** Refreshed to the M2 checkpoint: 52,719 museum descriptions including holds (52,255 eligible; 174 complete factual reviews) and 540,778 church records (442,834 eligible; zero complete factual reviews). All L2/L3 serialized checks and 19 JS assertions pass. Museum draft rendered independently with current counts and twelve-group examples, and browser QA confirms the corrected police museum group. [Artifact QA](data/validation/artifact_refresh_2026-09-26/artifact_QA.md) retains the unverified browser CSV save. Both drafts remain unpublished; destination and research gates remain missing. Current queues distinguish 233 reviewed unresolved descriptions from 51,904 unreviewed eligible descriptions.'''+t[b:]
t=t.replace('Next: consolidate remaining factual blockers and refresh local artifacts.','Local artifacts refreshed; next continue remaining source reviews and church factual leader/ordinal checks while independent labels and publication are blocked.')
f.write_text(t,encoding='utf-8')
f=Path('README.md');t=f.read_text(encoding='utf-8').replace('Local artifacts still need refresh.','Local post/explorer were refreshed and validated in [artifact QA](data/validation/artifact_refresh_2026-09-26/artifact_QA.md).');f.write_text(t,encoding='utf-8')
f=Path('data/validation/README.md');t=f.read_text(encoding='utf-8').replace('Local artifacts require refresh.','Local artifacts were refreshed; see [artifact QA](artifact_refresh_2026-09-26/artifact_QA.md).');f.write_text(t,encoding='utf-8')
f=Path('FLIGHT_LOG.md');t=f.read_text(encoding='utf-8',errors='surrogateescape');a=t.index('Current next action:');b=t.index('\n\n',a)
t=t[:a]+'''Current next action: M2 checkpoint and artifact refresh validated. Museum totals 52,387 counted / 52,255 eligible; 174 complete reviews. Post and explorer now current. Remaining source reviews and church factual leader/ordinal checks are unfinished; human church labels and publication destination remain missing. Current source-review queue: data/validation/artifact_refresh_2026-09-26/current_review_followup.csv. Do not rerun frozen packet scripts. Cloud spending USD 0.'''+t[b:]
t+='\n\n### '+datetime.now(timezone.utc).strftime('%Y-%m-%d %H:%M UTC')+''' - Local artifact refresh validated

- Museum standalone draft rendered in isolation, 669,813 bytes with Pandoc 3.11. Current count paragraph and M2 examples verified in browser; draft remains unpublished.
- Explorer rebuilt: 52,719 museum descriptions incl holds, 52,255 eligible, 6,329 aliases, 174 complete reviews. Church inventory unchanged: 540,778 / 442,834 eligible / zero verified. All four serialized L2/L3 checks, 51-state payload and 19 JS assertions pass; 77.22544 MiB compressed.
- Browser police group has three records, one verified and two pending; singular review wording fixed and verified after versioning the cached script. CSV link prepares correctly, but download event timed out after 12 seconds: filesystem save remains unverified.
- Preserved all 1,990 prior files and four live decision inputs. Consolidated 233 reviewed unresolved descriptions separately from 51,904 unreviewed eligible descriptions. Unreviewed work is not marked human-blocked or complete.
- Automatic approval review rejected marking the unfinished draft browser tab as a deliverable; no bypass or completion marker used. Only read-only QA continued. No deployment or outreach; cloud spending USD 0.
- Continue source/factual review work. Independent church labels and publication destination still require human input; do not self-grade or declare final headlines.
''';f.write_bytes(t.encode('utf-8',errors='surrogateescape'))
print('Artifact checkpoint recorded; research and publication remain incomplete.')
