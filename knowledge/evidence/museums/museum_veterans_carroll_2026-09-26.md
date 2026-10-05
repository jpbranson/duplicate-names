---
type: Evidence Packet
title: Veterans Memorial Museum and Carroll County review
description: Eighteen Veterans Memorial Museum and Carroll County Historical Society candidates reviewed; 52,506 counted and 52,374 eligible institutions, 85 complete factual reviews and ten pending reviews.
resource: ../../../data/validation/museum_veterans_carroll_2026-09-26.md
tags: [museums, leaders, identity, explorer, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 19
superseded_by: museum_clinton_madison_monroe_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_veterans_carroll_2026-09-26.md
    title: Veterans Memorial Museum and Carroll County review checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_veterans_carroll_2026-09-26/
    title: Veterans and Carroll County packet (candidates, context, decisions, audit, validation)
  - id: follow-up
    resource: ../../../data/validation/museum_veterans_carroll_2026-09-26/follow_up.csv
    title: Veterans and Carroll County pending reviews
---

# Scope

Reviews the bare Veterans Memorial Museum and Carroll County Historical Society groups:
eighteen starting candidates, 261 related baseline rows, 115 pinned Overture context rows
and selected IRS rows. It also refreshes the local museum draft and explorer.[^report]
Preceded by [the Children's Discovery Museum and Pioneer Village review](museum_discovery_pioneer_2026-09-26.md);
superseded by [Clinton, Madison and Monroe](museum_clinton_madison_monroe_2026-09-26.md).
Deprecated: a later checkpoint superseded its counts; the packet remains valid historical
evidence.

# Outcome

The report gives no before/after count table; its counts and group changes:[^report]

| Measure | At this checkpoint |
|---|---:|
| Original source rows retained | 60,002 |
| Counted source rows | 57,216 |
| Counted institutions | 52,506 |
| Eligible institutions | 52,374 |
| Identity members / cases | 220 / 86 |
| Complete factual reviews | 85 |
| not_museum decisions | 16 |
| Preferred names | 41 |
| Isolated source conflicts | 11 |

| Bare L2 group | Before | After (non-chain candidates) |
|---|---:|---:|
| Veterans Memorial Museum | 9 | 3 |
| Carroll County Historical Society | 9 | 1 |

- The batch adds 22 identity members in nine cases, nineteen factual decisions, eight names
  and nine complete reviews. Clinton, Madison and Monroe County Historical Society remain
  tied at nine; no national M1/M2 winner is certified.[^report]
- Veterans: Chehalis/Centralia WA rows become one museum with Centralia as a former site;
  Laurel MS's two Overture points and one IMLS row describe one museum; Branson MO's current
  public name is Branson Veterans Memorial Museum.[^report]
- Carroll: Berryville AR (Carroll County Heritage Museum), Carrollton MO (exact EIN resolves
  an IMLS street-number transposition), Mount Carroll IL (Miles Museum) and Delphi IN each
  count once; Carrollton OH reconciles two McCook House rows and keeps Algonquin Mill as a
  separate affiliated campus. Carrollton GA splits historical and genealogical societies
  with different EINs and excludes only the genealogy organization.[^report]
- Source conflicts: the Illinois row with the Ohio society domain and the Tennessee row with
  a humane-society domain each get a separate uncounted ID and contribute no aliases to an
  accepted museum.[^report]
- Validation: selective exports, 322 test assertions and 20 integrity checks pass; all 754
  protected earlier evidence and label files are unchanged; the automatic baseline, source
  coordinates, prior factual decisions and 0.85 threshold are preserved. Of 49 cache attempts,
  45 succeeded; certificate checks were not disabled.[^report]
- The local museum draft and explorer were refreshed: the isolated render, serialized L2/L3
  payload checks and nineteen JavaScript assertions pass; actual CSV filesystem saving
  remains unverified.[^report]

# Open actions

Ten new reviews remain pending in
[`follow_up.csv`](../../../data/validation/museum_veterans_carroll_2026-09-26/follow_up.csv):
Shenandoah, Hinton, Johnstown, Berryville, the Illinois mixed source row, the Ohio generic
society, the Tennessee generic society and Gordon Browning museum, the Tennessee mixed
source row and the Georgia historical society. Source-access failures have not been treated
as evidence of closure, independence or absence of a museum.[^report][^follow-up] Visitor
map points and current access still need separate publication checks.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_veterans_carroll_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_veterans_carroll_2026-09-26/):
  [counts](../../../data/validation/museum_veterans_carroll_2026-09-26/counts.csv),
  [candidate dispositions](../../../data/validation/museum_veterans_carroll_2026-09-26/candidate_dispositions.csv),
  [identity audit](../../../data/validation/museum_veterans_carroll_2026-09-26/identity_audit_after.csv),
  [specification](../../../data/validation/museum_veterans_carroll_2026-09-26/decisions_spec.json),
  [integrity checks](../../../data/validation/museum_veterans_carroll_2026-09-26/integrity_checks.csv),
  [artifact QA](../../../data/validation/museum_veterans_carroll_2026-09-26/artifact_QA.md)
- The one-time `prepare.R` and live `apply.R` scripts have already run; never rerun
  them.[^report]

[^report]: Veterans Memorial Museum and Carroll County review checkpoint report
[^follow-up]: Veterans and Carroll County pending reviews
