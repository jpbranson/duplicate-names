---
type: Evidence Packet
title: Chains leave the headline; first not-a-museum decisions
description: Chain locations leave the M1/M2 headline and the first sourced not_museum decisions apply; 52,584 counted and 52,452 eligible institutions with 19 complete factual reviews.
resource: ../../../data/validation/museum_methodology_2026-09-23.md
tags: [museums, chains, not-museum, checkpoint]
status: deprecated
checkpoint: 2026-09-23
sequence: 11
superseded_by: museum_county_leaders_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_methodology_2026-09-23.md
    title: Chains leave the headline; first not-a-museum decisions (checkpoint report)
  - id: packet
    resource: ../../../data/validation/museum_methodology_2026-09-23/
    title: Methodology checkpoint packet (rankings, chain summaries, decisions, validation)
  - id: follow-up
    resource: ../../../data/validation/museum_methodology_2026-09-23/follow_up.csv
    title: Methodology checkpoint follow-up queue
---

# Scope

Two methodology decisions made by the project owner after the provisional leaders review,
and the first decisions applying them: chain locations leave the M1/M2 headline and are
reported beside it, and a sourced `not_museum` category decision removes a record that
describes no museum from the museum count while keeping its source rows auditable.[^report]
They are recorded as [decision 12](../../decisions/12-separate-chains-from-headline.md) and
[decision 13](../../decisions/13-exclude-sourced-non-museums.md). Preceded by
[the provisional leaders review](museum_leaders_review_2026-09-23.md); superseded by
[the county society leaders checkpoint](museum_county_leaders_2026-09-26.md). Deprecated: a
later checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Counted source rows | 57,293 | 57,292 |
| Counted institutions | 52,588 | 52,584 |
| Eligible for L2 name analysis | 52,456 | 52,452 |
| Headline leader (non-chain institutions) | 11 | 11 |
| Washington County Historical Society (headline) | 7 | 4 |
| Museum of Illusions (headline, non-chain) | 1 | 1 |
| Museum of Illusions network locations | 11 | 25 |
| Chain locations reported beside the headline | 79 | 93 |
| Reviewed not-a-museum records | 0 | 3 |
| Institutions with complete factual review | 16 | 19 |

"Before" applies the new headline rules to the leaders checkpoint's decisions, so the
columns differ only by this checkpoint's decisions.[^report]

- Code: ranking, the publication gate and M2 candidates now use non-chain institutions;
  new `museum_chains` and `museum_chain_overlap` targets report chains. `category_decision =
  "not_museum"` sets `counted = FALSE` and `exclusion_reason = "reviewed_not_museum"` in
  `museum_analysis`, leaving `museum_records` rows unchanged. The resolver, 0.85 threshold,
  identity rules and human labels are unchanged.[^report]
- Franklin, Greene and Jackson County Historical Society and Old Jail Museum tie at 11 under
  the new rules; Old Jail's Historic Tours of America site now sits beside its
  headline.[^report]
- Chains beside the headline: Play Street Museum (37 locations), Museum of Illusions (25),
  Ripley's (19), Museum of Ice Cream (6), Madame Tussauds (5) and Historic Tours of America
  (1). Old Jail Museum, Madame Tussaud's Wax Museum and Museum of Illusions are names shared
  by a chain and non-chain institutions.[^report]
- Museum of Illusions: the official directory's US map links were matched to the 15
  city-suffixed records; a displaced Atlanta duplicate is reconciled (identity case
  `Methodology_MOI_Atlanta`). The 14 resulting locations receive `chain` affiliation with
  review still pending, because their individual location sites were not opened.[^report]
- Not a museum: the Washington County Historical Society records at Fort Edward NY (society
  home and research facilities, with no exhibits or museum visits), St. George UT (a society
  that assists local historical societies, at a PO box) and Marietta OH (the society's
  archives; its museums are already separate counted records). Greenville MS stays counted
  and pending: an IRS revocation and an unsuccessful search do not show that a record is not
  a museum.[^report]
- Validation: 217 assertions passed with no failures, warnings or skips; 23 integrity checks
  passed, including 212 protected files, the saved chain targets, both Parquet exports and
  the unchanged automatic baseline and multisite queue. No headline is publication
  ready.[^report]

# Open actions

The [follow-up queue](../../../data/validation/museum_methodology_2026-09-23/follow_up.csv)
lists the new leaders tied at 11, Smithsonian Institution affiliation, the Madame Tussaud's
overlap, Museum of Illusions city-suffixed access and Miami Beach, optional chain
inventories, a Union County Lewisburg PA `not_museum` candidate, the remaining Washington
County records and the earlier queues.[^follow-up]

# Files

- [Checkpoint report](../../../data/validation/museum_methodology_2026-09-23.md)
- [Packet directory](../../../data/validation/museum_methodology_2026-09-23/):
  [count effects](../../../data/validation/museum_methodology_2026-09-23/count_effects.csv),
  [ranking after](../../../data/validation/museum_methodology_2026-09-23/ranking_after.csv),
  [chain summary after](../../../data/validation/museum_methodology_2026-09-23/chain_summary_after.csv),
  [chain overlap](../../../data/validation/museum_methodology_2026-09-23/chain_overlap.csv),
  [Museum of Illusions directory match](../../../data/validation/museum_methodology_2026-09-23/moi_directory_match.csv),
  [integrity checks](../../../data/validation/museum_methodology_2026-09-23/integrity_checks.csv)
- `validate.R` holds read-only replay and preservation checks. The report notes that the
  leaders validator's live comparisons fail by design after this checkpoint.[^report]
- One-time scripts (`prepare.R`, `apply_review.R`) are frozen; never rerun them.

[^report]: Chains leave the headline; first not-a-museum decisions (checkpoint report)
[^follow-up]: Methodology checkpoint follow-up queue
