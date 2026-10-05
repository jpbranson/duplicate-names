---
type: Evidence Packet
title: Clinton, Madison and Monroe County source review
description: Twenty-seven candidates in the three remaining nine-member county-society groups reviewed; 52,493 counted and 52,361 eligible institutions, 101 complete factual reviews and 15 pending items.
resource: ../../../data/validation/museum_clinton_madison_monroe_2026-09-26.md
tags: [museums, leaders, identity, not-museum, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 20
superseded_by: museum_african_imagination_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_clinton_madison_monroe_2026-09-26.md
    title: Clinton, Madison and Monroe County source review report
  - id: packet
    resource: ../../../data/validation/museum_clinton_madison_monroe_2026-09-26/
    title: Clinton, Madison and Monroe packet (inputs, evidence, validation)
---

# Scope

Reviews the 27 candidates in the three remaining nine-member L2 groups, Clinton, Madison
and Monroe County Historical Society. It does not certify a national M1 or M2
winner.[^report] Preceded by
[Veterans Memorial Museum and Carroll County](museum_veterans_carroll_2026-09-26.md);
superseded by
[African American Museum and Imagination Station](museum_african_imagination_2026-09-26.md).
A later checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Original source rows | 60,002 | 60,002 |
| Counted source rows | 57,216 | 57,202 |
| Counted institutions | 52,506 | 52,493 |
| Eligible institutions | 52,374 | 52,361 |
| Guarded identity rows / cases | 220 / 86 | 243 / 98 |
| Complete factual reviews | 85 | 101 |
| `not_museum` decisions | 16 | 18 |
| Preferred public names | 41 | 55 |
| Isolated source conflicts | 11 | 19 |

- Adds 23 explicit identity rows in 12 cases, 31 factual decisions and 14 public-name
  overrides; sixteen additional factual reviews are complete.[^report]
- Bare-name non-chain groups: Clinton 9 to 0, Madison 9 to 0, Monroe 9 to 3. A zero means
  no eligible non-chain institution keeps that exact L2 name, not that the museums do not
  exist.[^report]
- Mailing records consolidate with their current museums and public names are applied,
  such as Heisey House Museum and Bellefontaine House. Pennsylvania's Heisey and Barton
  Street School museums, and Virginia's Madison and Mountain museums, record a documented
  common operator.[^report]
- Source conflicts (four Clinton rows, Madison's Iowa and New York rows, Monroe's Albia and
  Forsyth rows) get separate uncounted IDs and supply no aliases to accepted
  institutions.[^report]
- Kentucky's Madison society record is excluded as `not_museum` on its own account of its
  activities and battlefield-property transfer, not on a failed search or mailbox. Ohio's
  Monroe society office/records room is excluded as an additional museum (`not_museum` in
  the dispositions); the separate Parry museum stays counted.[^report][^packet]
- Validation: all 322 test assertions and 20 integrity checks passed; the 861 protected
  earlier evidence and human-label files, the baseline, source coordinates and the 0.85
  threshold are unchanged. These are factual source reviews, not independent
  matching-accuracy labels. The publication gate rejects the next leader.[^report]

# Open actions

[`human_review.csv`](../../../data/validation/museum_clinton_madison_monroe_2026-09-26/human_review.csv)
records all 15 pending items, including eight source-conflict holds, parent roles in
Wisconsin, Missouri and Tennessee, and West Virginia's governance and access.[^report] The
refreshed local post and explorer passed the documented artifact checks; the CSV
filesystem-save check is unverified and publication remains incomplete.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_clinton_madison_monroe_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_clinton_madison_monroe_2026-09-26/):
  [decisions spec](../../../data/validation/museum_clinton_madison_monroe_2026-09-26/decisions_spec.json),
  [candidate dispositions](../../../data/validation/museum_clinton_madison_monroe_2026-09-26/candidate_dispositions.csv),
  [integrity checks](../../../data/validation/museum_clinton_madison_monroe_2026-09-26/integrity_checks.csv),
  [artifact QA](../../../data/validation/museum_clinton_madison_monroe_2026-09-26/artifact_QA.md)
- One-time scripts (`prepare.R`, `apply.R`) are frozen (`applied.json`); never rerun them.

[^report]: Clinton, Madison and Monroe County source review report
[^packet]: Clinton, Madison and Monroe packet (inputs, evidence, validation)
