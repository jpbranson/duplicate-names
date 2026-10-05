---
type: Evidence Packet
title: Old Jail Museum — first leading-name review
description: All 15 Old Jail Museum starting candidates reviewed; the group falls to 12, two institutions gain complete factual reviews, and Union County Historical Society becomes the provisional leader at 14.
resource: ../../../data/validation/museum_old_jail_review_2026-09-15.md
tags: [museums, checkpoint, leaders, identity, affiliation]
status: deprecated
superseded_by: museum_union_county_review_2026-09-17.md
checkpoint: 2026-09-15
sequence: 8
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_old_jail_review_2026-09-15.md
    title: Old Jail Museum leading-name factual review report
  - id: packet
    resource: ../../../data/validation/museum_old_jail_review_2026-09-15/
    title: Old Jail review packet (dispositions, decisions, audit, evidence, follow-up)
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation and review evidence index
---

# Scope

Reviewed all **15 starting candidates** for the provisional leading L2 name, with their
source-cluster members and nearby museum/society records. It completes a review batch, not
the broader top-20 review or headline certification.[^report] Preceded by the
[address follow-up](museum_address_review_2026-09-15.md). Superseded by the
[Union County review](museum_union_county_review_2026-09-17.md); a later checkpoint replaced
its counts, but the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Source rows retained | 60,002 | 60,002 |
| Counted source rows | 57,327 | 57,313 |
| Counted institutions | 52,617 | 52,605 |
| Eligible for L2 name analysis | 52,485 | 52,473 |
| Old Jail Museum | 15 | 12 |
| Washington County Historical Society | 13 | 13 |
| Institutions with complete factual review | 0 | 2 |

- Twenty-three explicitly listed source records from 20 baseline entities are handled in nine
  new cases: eight canonical institutions and two isolated holdouts. The live input now holds
  56 rows in 22 cases, with 20 canonical institutions and four isolated source
  conflicts.[^report]
- The Old Jail decrease comes from one Winchester consolidation and two Dubuque holds. Other
  consolidations remove society names and mailing records from separate institution counts.
  Identity cases cover Winchester, Hayesville, Albion, Allegan, Smethport, Greenwood and
  Thompson Falls; Jim Thorpe keeps one entity with one counted representative.[^report]
- **Dubuque** receives two `reviewed_source_conflict` exclusions rather than an inferred
  merge; this does not assert a resolved closure date.[^report]
- Albion and Jim Thorpe have `review_status = verified` and reviewed independent affiliation.
  These are factual source decisions, not independent human matching labels.[^report]
- St. Augustine receives the sourced `historic_tours_of_america` affiliation and remains
  overall pending.[^report]
- The twelve remaining candidates: two verified independent, one affiliated and nine
  affiliation-unknown; ten overall reviews remain pending.[^report]
- Validation: 192 assertions and 23 integrity checks passed under R 4.4.2. All 92 protected
  files and 20 new acquisition/query hashes match; the 0.85 label scores are unchanged.
  Review sheets hold 449 institutions, 553 source rows and 147 nearby pairs.[^report]
- `dn_assert_museum_publication_ready()` was run explicitly for `old jail museum` and correctly
  rejected the pending reviews and unknown affiliations. No headline was published.[^report]
  See the [publication gate](../../methodology/publication-gate.md).

# Open actions

The [follow-up queue](../../../data/validation/museum_old_jail_review_2026-09-15/follow_up.csv)
puts the Union County Historical Society review first, then Old Jail's shared-operator
affiliation scope, Smethport's preferred name, Winchester, Barnesville, St. Augustine, the
Dubuque holds, remaining factual and visitor-point checks, the unchanged Bankhead and
Lafayette Street cases, and the publication export of staged points.[^packet] Old Jail work
continues in the later [Old Jail follow-up](museum_jail_followup_2026-09-26.md).[^index]

# Files

- [Checkpoint report](../../../data/validation/museum_old_jail_review_2026-09-15.md)
- [Packet directory](../../../data/validation/museum_old_jail_review_2026-09-15/):
  [candidate dispositions](../../../data/validation/museum_old_jail_review_2026-09-15/candidate_review.csv),
  [applied identity decisions](../../../data/validation/museum_old_jail_review_2026-09-15/applied_identity_decisions.csv),
  [identity audit](../../../data/validation/museum_old_jail_review_2026-09-15/identity_audit.csv),
  [evidence ledger](../../../data/validation/museum_old_jail_review_2026-09-15/evidence.csv),
  [cache status](../../../data/validation/museum_old_jail_review_2026-09-15/cache_status.csv),
  [Overture context](../../../data/validation/museum_old_jail_review_2026-09-15/overture_context.csv)
  (41 records)
- `reproduce.R` replays archived counts and preservation checks without rebuilding; it needs
  the saved automatic entities target and the original working label copy.[^index]

[^report]: Old Jail Museum leading-name factual review report
[^packet]: Old Jail review packet (dispositions, decisions, audit, evidence, follow-up)
[^index]: Validation and review evidence index
