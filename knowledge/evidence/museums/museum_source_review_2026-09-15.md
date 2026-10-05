---
type: Evidence Packet
title: First source-verification pass
description: Fifty-one source records across 46 entity IDs checked against official sources; 24 naming and affiliation decisions raise provisional eligibility from 52,497 to 52,501 without changing baseline identity.
resource: ../../../data/validation/museum_source_review_2026-09-15.md
tags: [museums, checkpoint, category-names, chains, identity]
status: deprecated
superseded_by: museum_identity_review_2026-09-15.md
checkpoint: 2026-09-15
sequence: 4
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_source_review_2026-09-15.md
    title: Museum source verification first-pass report
  - id: packet
    resource: ../../../data/validation/museum_source_review_2026-09-15/
    title: Source-review packet (decisions, evidence ledger, case index)
---

# Scope

Checked **51 source records across 46 existing entity IDs** against official sources and
applied 24 explicit naming/affiliation decisions. It completes the first source-verification
pass, not the full top-20 publication review. These are assistant source checks, not
independent human matching labels.[^report] Preceded by the
[initial research notes](museum_research_2026-09-15.md). Superseded by the
[first identity pass](museum_identity_review_2026-09-15.md); a later checkpoint replaced its
counts, but the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Baseline counted entities | 52,636 | 52,636 |
| Eligible for provisional name analysis | 52,497 | 52,501 |
| Category-only names confirmed as current names | 1 | 5 |
| Explicit historical-name holdouts | 0 | 4 |
| Category decisions still pending | 139 | 131 |
| MOI global-network affiliations in the 13-name group | 0 | 11 |

- University Art Gallery: all 13 records checked. Five universities explicitly use the name
  (Cal Poly was already released; four are new releases). Baylor, New Mexico State, Stony
  Brook and UC San Diego receive `historical_name` holdouts. Eastern Michigan, Elizabeth City
  State, Oklahoma Christian and UMass Dartmouth remain pending.[^report]
- Museum of Illusions: the official directory supports affiliation for 11 locations, each
  within 26 m of the coordinate in its outbound map link. This is brand affiliation, not
  common legal ownership. Hollywood and Miami remain open.[^report]
- No entity IDs, site IDs, baseline exclusions, source names or matching thresholds changed.
  All 24 decisions remain `review_status = pending`.[^report]
- Washington County Historical Society still leads with 19 provisional entities; this is not
  a verified count of distinct current museums.[^report]
- The Cryptozoology seed location check is complete: the selected Bangor point is 5.9 m from
  the operator's 490 Broadway map destination.[^report]
- Validation: under R 4.4.2, 108 assertions passed with zero failures, warnings or skips. The
  selective rebuild completed nine targets; both label copies are byte-identical, and the 0.85
  score remains 119 true merges, one false merge, eight missed merges and 172 true
  separations.[^report]

# Open actions

Three identity cases were prepared for the next pass: the National Electronics Museum (four
entities), the National Vietnam War Museum (five exact-name entities plus one Smedley alias)
and Washington County societies in Arkansas, Florida, Georgia and Pennsylvania.[^report] The
[case index](../../../data/validation/museum_source_review_2026-09-15/case_index.csv) groups
the researched records into nine cases;[^report] the packet has no separate follow-up
queue.[^packet]

# Files

- [Checkpoint report](../../../data/validation/museum_source_review_2026-09-15.md)
- [Packet directory](../../../data/validation/museum_source_review_2026-09-15/):
  [evidence ledger](../../../data/validation/museum_source_review_2026-09-15/evidence.csv),
  [applied decisions](../../../data/validation/museum_source_review_2026-09-15/applied_decisions.csv),
  [decisions before](../../../data/validation/museum_source_review_2026-09-15/decisions_before.csv),
  [analysis after](../../../data/validation/museum_source_review_2026-09-15/analysis_after.csv),
  [ranking after](../../../data/validation/museum_source_review_2026-09-15/ranking_after.csv),
  [input checksums](../../../data/validation/museum_source_review_2026-09-15/input_checksums.csv)
- The decisions were applied to the live
  [museum decisions input](../../inputs/museum-decisions.md).[^report]
- The packet holds no scripts.

[^report]: Museum source verification first-pass report
[^packet]: Source-review packet (decisions, evidence ledger, case index)
