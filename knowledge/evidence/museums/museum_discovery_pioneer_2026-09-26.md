---
type: Evidence Packet
title: Children's Discovery Museum and Pioneer Village review
description: Eighteen Children's Discovery Museum and Pioneer Village candidates reviewed; 52,516 counted and 52,384 eligible institutions, 76 complete factual reviews and eight pending reviews.
resource: ../../../data/validation/museum_discovery_pioneer_2026-09-26.md
tags: [museums, leaders, identity, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 18
superseded_by: museum_veterans_carroll_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_discovery_pioneer_2026-09-26.md
    title: Children's Discovery Museum and Pioneer Village review checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_discovery_pioneer_2026-09-26/
    title: Discovery and Pioneer Village packet (candidates, context, decisions, audit, validation)
  - id: follow-up
    resource: ../../../data/validation/museum_discovery_pioneer_2026-09-26/follow_up.csv
    title: Discovery and Pioneer Village pending reviews
---

# Scope

Reviews the bare Children's Discovery Museum and Pioneer Village groups: eighteen starting
candidates, 583 related baseline rows and 323 pinned Overture context rows.[^report]
Preceded by [the Adams and Brown County review](museum_adams_brown_2026-09-26.md);
superseded by [the Veterans Memorial Museum and Carroll County review](museum_veterans_carroll_2026-09-26.md).
Deprecated: a later checkpoint superseded its counts; the packet remains valid historical
evidence.

# Outcome

The report gives no before/after count table; its counts and group changes:[^report]

| Measure | At this checkpoint |
|---|---:|
| Original source rows retained | 60,002 |
| Counted source rows | 57,228 |
| Counted institutions | 52,516 |
| Eligible institutions | 52,384 |
| Identity rows / cases | 198 / 77 |
| Complete factual reviews | 76 |
| Sourced not_museum decisions | 15 |
| Public-name overrides | 33 |
| Isolated source conflicts | 9 |

| Bare L2 group | Before | After (non-chain candidates) |
|---|---:|---:|
| Children's Discovery Museum | 9 | 4 |
| Pioneer Village | 9 | 4 |

- The batch adds nineteen identity members in eight cases, nineteen factual decisions, six
  preferred names and eleven complete factual reviews. Five remaining leaders count nine
  each: Carroll, Clinton, Madison and Monroe County Historical Society, and Veterans Memorial
  Museum. No M1/M2 winner is certified.[^report]
- Victoria TX and Augusta/Waterville ME each become one museum with former-address records
  preserved; Normal IL's museum and foundation records become one physical museum. Salem MA,
  Corsicana TX and Searcy AR village records each count once, with Searcy's overall review
  still pending; Minden NE uses Harold Warp Pioneer Village, its historic buildings forming
  one museum.[^report]
- Shared operators without merging: Grand Rapids MN's Children's Discovery Museum and Judy
  Garland Museum share a nonprofit; Worthington MN's Nobles County Heritage Center and
  Pioneer Village keep separate identities with sourced society affiliation.[^report]
- Indianapolis IN keeps the fair-address record pending complete review and isolates a row
  with an Indianapolis point but Spring Mill website as an uncounted source conflict with no
  alias contribution.[^report]
- Validation: 322 test assertions pass; the final verification passes 19 integrity checks,
  including byte preservation of 693 earlier evidence/label files. An audit-script assertion
  (empty alias strings, not NA) and an exporter omission were corrected in the scripts; no
  factual inputs, expected counts or gold labels were changed. `verify_final.log` confirms
  all nineteen checks and all eight follow-ups.[^report]
- Forty cache attempts yielded 39 caches and one recorded HTTP 403.[^report]

# Open actions

Eight reviews remain pending in
[`follow_up.csv`](../../../data/validation/museum_discovery_pioneer_2026-09-26/follow_up.csv):
California (two), Grand Rapids (two), Searcy, Rison and Indianapolis (two). No closure,
independence or exclusion is inferred from missing evidence.[^report][^follow-up] Before
visitor-facing publication, check Salem's conflicting season closing date, Worthington's
apparent opening-hour typo and Kelso's stale source point. The local museum post and
explorer still describe the Depot/Wayne snapshot.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_discovery_pioneer_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_discovery_pioneer_2026-09-26/):
  [counts](../../../data/validation/museum_discovery_pioneer_2026-09-26/counts.csv),
  [ranking after](../../../data/validation/museum_discovery_pioneer_2026-09-26/ranking_after.csv),
  [candidate dispositions](../../../data/validation/museum_discovery_pioneer_2026-09-26/candidate_dispositions.csv),
  [identity audit](../../../data/validation/museum_discovery_pioneer_2026-09-26/identity_audit_after.csv),
  [integrity checks](../../../data/validation/museum_discovery_pioneer_2026-09-26/integrity_checks.csv),
  [source status](../../../data/validation/museum_discovery_pioneer_2026-09-26/cache_status.csv)
- `decisions_spec.json` and `apply.R` describe the already-applied batch; never rerun the
  one-time live apply or `prepare.R` scripts.[^report]

[^report]: Children's Discovery Museum and Pioneer Village review checkpoint report
[^follow-up]: Discovery and Pioneer Village pending reviews
