---
type: Evidence Packet
title: Local artifact refresh to the M2 museum checkpoint
description: Museum draft and explorer rebuilt from the M2 leading-groups checkpoint, with 52,719 museum descriptions (52,255 eligible, 174 complete reviews) and passing payload checks; both remain unpublished.
resource: ../../../data/validation/artifact_refresh_2026-09-26/README.md
tags: [artifacts, checkpoint, explorer, post-1]
status: stable
checkpoint: 2026-09-26
sequence: 2
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/artifact_refresh_2026-09-26/README.md
    title: Artifact refresh README
  - id: packet
    resource: ../../../data/validation/artifact_refresh_2026-09-26/
    title: Artifact refresh packet (builds, checks, queues, input snapshots)
  - id: artifact-qa
    resource: ../../../data/validation/artifact_refresh_2026-09-26/artifact_QA.md
    title: Local artifact QA
  - id: data-build
    resource: ../../../data/validation/artifact_refresh_2026-09-26/data_build.json
    title: Explorer data build manifest after refresh
  - id: before-build
    resource: ../../../data/validation/dashboard_2026-09-26/data_build.json
    title: Explorer data build manifest from the initial build
  - id: blockers
    resource: ../../../data/validation/artifact_refresh_2026-09-26/publication_publication_blockers.csv
    title: Publication blockers at the artifact refresh
  - id: church-qa
    resource: ../../../data/validation/church_ordinal_review_2026-09-26/artifact_QA.md
    title: Church checkpoint artifact QA
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 19:00 and 19:09 UTC entries and the post 1 rescope entry
---

# Scope

Rebuilds the local museum post draft and the [explorer](../../publications/explorer.md) from
the [M2 leading-groups checkpoint](../museums/museum_m2_leaders_2026-09-26.md). This artifact
step makes no new factual decisions or labels.[^report][^flight-log] Preceded by
[the initial explorer build](dashboard_2026-09-26.md). It is the current artifact packet. The
church ordinal checkpoint later refreshed the church payload to 442,832 eligible; see
[that checkpoint](../churches/church_ordinal_review_2026-09-26.md).[^church-qa]

# Outcome

| Explorer measure | Before | After |
|---|---:|---:|
| Museum canonical descriptions, including holds | 52,847 | 52,719 |
| Museum eligible | 52,425 | 52,255 |
| Museum descriptions with aliases | 6,218 | 6,329 |
| Museum `verified` (complete factual reviews) | 40 | 174 |
| Church records | 540,778 | 540,778 |
| Church eligible | 442,834 | 442,834 |
| Church `verified` | 0 | 0 |

Before values are from the initial build;[^before-build] after values from this
packet.[^data-build]

- The museum standalone draft rendered in an isolated copy with no project profile, targets
  checkout or source downloads (Pandoc 3.11; 669,813 bytes). The browser preview shows 60,002
  source rows, 52,387 counted institutions, 52,255 eligible and 174 complete factual reviews,
  including exclusions.[^artifact-qa]
- The explorer's 52,719-description display inventory differs from the 52,387 counted
  institutions.[^report]
- Both categories pass serialized L2/L3 checks; 19 focused JS assertions pass; compressed
  payloads occupy 77.22544 MiB.[^report]
- In the browser, International Police Museum shows three eligible records (Oregon
  verified/independent; California and Pennsylvania pending/unknown). Old Jail remains eight
  with four pending reviews. The single-review grammar fix is browser-verified.[^artifact-qa]
- 1,990 prior files and four live decision inputs are unchanged.[^flight-log]
- Queues separate 233 reviewed-but-unresolved descriptions from 51,904 eligible descriptions
  without factual evidence.[^report]
- Automatic approval review rejected marking the unfinished draft tab as a deliverable; no
  bypass or completion marker was used. Cloud spending USD 0.[^artifact-qa]

# Open actions

- Actual filesystem CSV saving remains unverified: a 12-second download-event check timed
  out.[^artifact-qa]
- [`publication_publication_blockers.csv`](../../../data/validation/artifact_refresh_2026-09-26/publication_publication_blockers.csv)
  lists the remaining steps, among them M1 leaders, Old Jail evidence, the unset publication
  destination and the blank church version-2 labels.[^blockers] Decision 14 later changed how
  Old Jail is assessed; see [post 1](../../publications/post-1-museums.md).[^flight-log]
- The explorer is frozen until post 1 publishes
  ([decision 14](../../decisions/14-post-1-headline-sufficient-review.md)).[^flight-log]
- No national headline or project completion is certified.[^report]

# Files

- [Packet README (report)](../../../data/validation/artifact_refresh_2026-09-26/README.md)
- [Packet directory](../../../data/validation/artifact_refresh_2026-09-26/):
  [artifact QA](../../../data/validation/artifact_refresh_2026-09-26/artifact_QA.md),
  [data build](../../../data/validation/artifact_refresh_2026-09-26/data_build.json),
  [serialized payload checks](../../../data/validation/artifact_refresh_2026-09-26/serialized_payload_checks.json),
  [reviewed unresolved](../../../data/validation/artifact_refresh_2026-09-26/current_review_followup.csv),
  [unreviewed institutions](../../../data/validation/artifact_refresh_2026-09-26/unreviewed_institutions.csv),
  [preservation checks](../../../data/validation/artifact_refresh_2026-09-26/preservation_checks.json)
- `prepare.py` must not be rerun;[^report] treat the other packet scripts (`finalize.py`,
  `refresh_publication.R`, `render_standalone.R`) as frozen too and never rerun them.

[^report]: Artifact refresh README
[^artifact-qa]: Local artifact QA
[^data-build]: Explorer data build manifest after refresh
[^before-build]: Explorer data build manifest from the initial build
[^blockers]: Publication blockers at the artifact refresh
[^church-qa]: Church checkpoint artifact QA
[^flight-log]: Flight log, 2026-09-26 19:00 and 19:09 UTC entries and the post 1 rescope entry
