---
type: Evidence Packet
title: First identity reconciliation pass
description: Nine sourced corrections reconcile 25 source records from 24 baseline entities into nine institutions and introduce the reviewed identity layer; 52,621 counted and 52,489 eligible.
resource: ../../../data/validation/museum_identity_review_2026-09-15.md
tags: [museums, checkpoint, identity]
status: deprecated
superseded_by: museum_focused_review_2026-09-15.md
checkpoint: 2026-09-15
sequence: 5
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_identity_review_2026-09-15.md
    title: Museum identity reconciliation first-pass report
  - id: packet
    resource: ../../../data/validation/museum_identity_review_2026-09-15/
    title: Identity-review packet (decisions, audit, records, Overture context)
---

# Scope

Applied nine source-supported corrections: **25 source records, previously assigned to 24
entities, now represent nine institutions** in a new reviewed layer, while the automatic
baseline is retained. It is a factual correction pass, not a new evaluation of matching
accuracy or a completed top-20 publication review.[^report] Preceded by the
[first source pass](museum_source_review_2026-09-15.md). Superseded by the
[focused follow-up](museum_focused_review_2026-09-15.md); a later checkpoint replaced its
counts, but the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Counted entities in museum working data | 52,636 | 52,621 |
| Eligible for provisional name analysis | 52,501 | 52,489 |
| Washington County Historical Society | 19 | 16 |
| National Electronics Museum | 4 | 1 |
| National Vietnam War Museum | 5 | 2 |
| Martin Museum of Art | 2 | 1 |
| Brown House Museum | 3 | 2 |
| Old Jail Museum | 15 | 15 |

- Introduces the [identity-correction layer](../../methodology/identity-corrections.md): the
  new `museum_records` target applies the live
  [identity decisions](../../inputs/museum-identity-decisions.md) through
  `R/museum_identity.R`; `entities` stays the automatic baseline.[^report] See
  [decision 11](../../decisions/11-auditable-identity-corrections.md).
- Each correction lists every member of its affected baseline entities, an explicit canonical
  record, physical-site groups, evidence and reviewer/date. Name, entity and coordinate guards
  reject stale inputs; no name pattern, shared operator or proximity search expands a
  correction automatically.[^report]
- Corrections (baseline entities → reviewed institutions): National Electronics Museum 5 → 1,
  Texas Vietnam museum 3 → 1, Florida Smedley museum 2 → 1, Baylor galleries 3 → 1, Stony
  Brook gallery 2 → 1, UCSD gallery 2 → 1, Sandersville Old Jail 2 → 1, Sandersville Brown
  House 3 → 1, Fayetteville Headquarters House 2 → 1.[^report]
- The Brown House and Old Jail remain distinct museums; shared society ownership does not
  merge them.[^report]
- The 15-entity reduction changes eligibility by 12 because three former gallery names were
  already held out. Washington County Historical Society still leads at 16 provisional
  entities; neither that number nor the two remaining Vietnam museum candidates is
  certified.[^report]
- Validation: 139 assertions passed under R 4.4.2 with no failures, warnings or skips; the
  selective rebuild completed 15 targets. The baseline, normalized source fields, every
  unreviewed record and both label files are unchanged, and the 0.85 label result is
  unchanged.[^report]

# Open actions

The [focused follow-up list](../../../data/validation/museum_identity_review_2026-09-15/unresolved_cases.csv)
separates six remaining research tasks: the Texas Bankhead Drive record, the Pennsylvania
Barrow source conflict, Fayetteville's Lafayette Street record, Chipley's older
preservation-society record, and map verification for Smedley and Mandeville.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_identity_review_2026-09-15.md)
- [Packet directory](../../../data/validation/museum_identity_review_2026-09-15/):
  [identity decisions](../../../data/validation/museum_identity_review_2026-09-15/identity_decisions.csv),
  [identity audit](../../../data/validation/museum_identity_review_2026-09-15/identity_audit.csv),
  [count effects](../../../data/validation/museum_identity_review_2026-09-15/count_effects.csv),
  [records before](../../../data/validation/museum_identity_review_2026-09-15/records_before.csv),
  [ranking after](../../../data/validation/museum_identity_review_2026-09-15/ranking_after.csv)
- The [Overture context extract](../../../data/validation/museum_identity_review_2026-09-15/overture_context.csv)
  holds 38 records from the 2026-08-19.0 release; its query and checksum are in
  `data/raw/MANIFEST.json`.[^report]
- The packet holds no scripts.[^packet]

[^report]: Museum identity reconciliation first-pass report
[^packet]: Identity-review packet (decisions, audit, records, Overture context)
