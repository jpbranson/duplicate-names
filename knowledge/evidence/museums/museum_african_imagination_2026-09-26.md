---
type: Evidence Packet
title: African American Museum and Imagination Station source review
description: Sixteen candidates in two eight-member groups reviewed; 52,480 counted and 52,348 eligible institutions, 110 complete factual reviews including exclusions and eight incomplete reviews.
resource: ../../../data/validation/museum_african_imagination_2026-09-26.md
tags: [museums, leaders, identity, not-museum, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 21
superseded_by: museum_cass_chester_crawford_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_african_imagination_2026-09-26.md
    title: African American Museum and Imagination Station source review report
  - id: packet
    resource: ../../../data/validation/museum_african_imagination_2026-09-26/
    title: African American Museum and Imagination Station packet
---

# Scope

Reviews the 16 starting candidates in two eight-member L2 groups, African American Museum
and Imagination Station, and applies the supported corrections. No national M1 or M2
winner is certified.[^report] Preceded by
[Clinton, Madison and Monroe County](museum_clinton_madison_monroe_2026-09-26.md);
superseded by [Cass, Chester and Crawford](museum_cass_chester_crawford_2026-09-26.md).
A later checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Original source rows | 60,002 | 60,002 |
| Counted source rows | 57,202 | 57,191 |
| Counted institutions | 52,493 | 52,480 |
| Eligible institutions | 52,361 | 52,348 |
| Guarded identity rows / cases | 243 / 98 | 258 / 106 |
| Complete factual reviews, including exclusions | 101 | 110 |
| `not_museum` decisions | 18 | 21 |
| Preferred public names | 55 | 57 |
| Isolated source conflicts | 19 | 23 |

- Adds 15 explicit identity rows in eight cases, 17 factual decisions and two public-name
  overrides. Six museum reviews and three affirmative non-museum exclusions are
  complete.[^report]
- Non-chain bare-name groups: African American Museum 8 to 3 (Tacoma and Galveston still
  pending) and Imagination Station 8 to 2.[^report]
- Monroe, Louisiana's three clean records become one Northeast Louisiana Delta African
  American Heritage Museum. Bowling Green keeps the operator's bare public name; no locality
  suffix was invented to reduce a duplicate-name count.[^report]
- COSI Toledo is a former name of Toledo's Imagination Station. Similar names, grants and
  board members' university employment do not establish a chain.[^report]
- Marshfield and Zeeland are excluded as `not_museum` because their operators describe
  childcare facilities. Pensacola's stale stadium-space record is excluded on affirmative
  repurposing evidence, not a blanket rule about closed museums.[^report]
- A Monroe row with the Dallas museum domain and the Missoula, Stratford and Woodstock rows
  receive separate uncounted source-conflict IDs, with no aliases transferred.[^report]
- Validation: all 322 test assertions and 21 integrity checks passed; all 977 protected
  earlier evidence and human-label files, the baseline, source coordinates and the 0.85
  threshold are unchanged.[^report]
- The recorded-status gate passes for the two remaining Imagination Stations without
  certifying visitor access, M2 meaning or a national maximum; the next national leader
  still fails it. These reviews are not independent matching-accuracy labels.[^report]

# Open actions

The eight-item
[`human_review.csv`](../../../data/validation/museum_african_imagination_2026-09-26/human_review.csv)
covers Tacoma's address and status, Galveston's operator succession and access, a
St. Martinville campus-counting overlap and four source conflicts.[^report] No outreach was
sent. Cass, Chester and Crawford County Historical Society were next; the museum draft and
explorer still reflected the Clinton/Madison/Monroe checkpoint.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_african_imagination_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_african_imagination_2026-09-26/):
  [candidate dispositions](../../../data/validation/museum_african_imagination_2026-09-26/candidate_dispositions.csv),
  [identity audit](../../../data/validation/museum_african_imagination_2026-09-26/identity_audit_after.csv),
  [integrity checks](../../../data/validation/museum_african_imagination_2026-09-26/integrity_checks.csv)
- One-time scripts (`prepare.R`, `apply.R`) are frozen (`applied.json`); never rerun them.

[^report]: African American Museum and Imagination Station source review report
