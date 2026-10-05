---
type: Evidence Packet
title: Cass, Chester and Crawford source review
description: Twenty-four candidates in three eight-member groups reviewed and a guarded reselected_canonical identity role added; 52,466 counted and 52,334 eligible institutions, 123 complete factual reviews and twelve incomplete.
resource: ../../../data/validation/museum_cass_chester_crawford_2026-09-26.md
tags: [museums, leaders, identity, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 22
superseded_by: museum_jefferson_lincoln_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_cass_chester_crawford_2026-09-26.md
    title: Cass, Chester and Crawford source review report
  - id: packet
    resource: ../../../data/validation/museum_cass_chester_crawford_2026-09-26/
    title: Cass, Chester and Crawford packet (inputs, evidence, validation)
---

# Scope

Gives sourced dispositions to the 24 starting candidates in three eight-member L2 groups:
Cass County Historical Society, Chester Historical Society and Crawford County Historical
Society. No national M1 or M2 winner is certified.[^report] Preceded by
[African American Museum and Imagination Station](museum_african_imagination_2026-09-26.md);
superseded by [Jefferson and Lincoln County](museum_jefferson_lincoln_2026-09-26.md).
A later checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Original source rows | 60,002 | 60,002 |
| Counted source rows | 57,191 | 57,171 |
| Counted institutions | 52,480 | 52,466 |
| Eligible institutions | 52,348 | 52,334 |
| Identity rows / cases | 258 / 106 | 292 / 121 |
| Complete factual reviews, including exclusions | 110 | 123 |
| `not_museum` decisions | 21 | 22 |
| Preferred names | 57 | 69 |
| Isolated source conflicts | 23 | 28 |

- Adds 34 identity memberships in 15 cases, 25 factual decisions and 12 preferred names.
  Twelve museum reviews and one affirmative archive exclusion are complete.[^report]
- Non-chain bare-name groups: Cass 8 to 0, Chester 8 to 3, Crawford 8 to 3. Zero for Cass
  does not mean no Cass museums exist.[^report]
- New identity role `reselected_canonical` (see
  [identity corrections](../../methodology/identity-corrections.md)): it accepts only a
  source excluded as `non_primary_site` that has an accepted counted member of the same
  baseline institution. It was added after the first dry run rejected Baldwin-Reynolds'
  documented Terrace visitor-site row; it selects an existing source point and neither
  certifies an entrance nor alters coordinates. Eighteen new regression assertions cover it;
  all 85 identity assertions pass.[^report]
- Crawford, Pennsylvania's generic administrative/archive record is excluded on affirmative
  operator role evidence; its two museums stay separate with a common operator.[^report]
- Five new source conflicts are isolated (Cass Michigan, Chester New York, Crawford
  Arkansas, Illinois and Pennsylvania). These are source-field contradictions, not
  exclusions inferred from failed searches or mailboxes.[^report]
- Validation: all 340 test assertions and 25 integrity checks pass; all 1,097 earlier
  protected evidence and human-label files, the baseline, source coordinates and the 0.85
  threshold are unchanged. A second failed dry run (draft status `affiliated`, corrected to
  `chain`) left live inputs unchanged. These reviews are not independent
  matching-accuracy labels.[^report]

# Open actions

The twelve-item
[`human_review.csv`](../../../data/validation/museum_cass_chester_crawford_2026-09-26/human_review.csv)
lists five source conflicts, Vermont and New Jersey museum scope, Iowa address history,
Wisconsin/Hauge Center scope, Georgia's site/move dates, Cuba governance and the
Robinson/Palestine relationship.[^report] The national leader still failed the
recorded-status gate; Jefferson and Lincoln County Historical Society were next.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_cass_chester_crawford_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_cass_chester_crawford_2026-09-26/):
  [candidate dispositions](../../../data/validation/museum_cass_chester_crawford_2026-09-26/candidate_dispositions.csv),
  [identity audit](../../../data/validation/museum_cass_chester_crawford_2026-09-26/identity_audit_after.csv),
  [identity regression log](../../../data/validation/museum_cass_chester_crawford_2026-09-26/identity_regression.log),
  [integrity checks](../../../data/validation/museum_cass_chester_crawford_2026-09-26/integrity_checks.csv)
- One-time scripts (`prepare.R`, `correct_context.R`, `apply.R`) are frozen
  (`applied.json`); never rerun them.

[^report]: Cass, Chester and Crawford source review report
