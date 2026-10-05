---
type: Evidence Packet
title: Old Jail follow-up — validated corrections, incomplete headline review
description: The Old Jail Museum non-chain group falls from eleven to eight institutions with four pending cases; 52,560 counted and 52,428 eligible institutions, 36 complete factual reviews.
resource: ../../../data/validation/museum_jail_followup_2026-09-26.md
tags: [museums, leaders, affiliation, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 13
superseded_by: museum_affiliation_followup_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_jail_followup_2026-09-26.md
    title: Old Jail follow-up checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_jail_followup_2026-09-26/
    title: Old Jail follow-up packet (decisions, evidence notes, audits, ranks, validation)
  - id: human-review
    resource: ../../../data/validation/museum_jail_followup_2026-09-26/human_review.csv
    title: Old Jail remaining cases
---

# Scope

A supported correction batch for the Old Jail Museum group. The batch is complete; the Old
Jail headline review is not.[^report] Preceded by
[the county society leaders checkpoint](museum_county_leaders_2026-09-26.md); superseded by
[the affiliation follow-up](museum_affiliation_followup_2026-09-26.md). Deprecated: a later
checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before (county checkpoint) | After |
|---|---:|---:|
| Original source rows retained | 60,002 | 60,002 |
| Counted source records | 57,274 | 57,273 |
| Counted museum institutions | 52,563 | 52,560 |
| Eligible for L2 analysis | 52,431 | 52,428 |
| Explicit identity rows / cases | 121 / 49 | 123 / 50 |
| Complete factual reviews | 28 | 36 |
| Sourced not-museum decisions | 7 | 9 |
| Isolated source conflicts | 7 | 7 |

- The non-chain Old Jail L2 group falls from eleven to eight institutions, with four
  complete factual reviews and four pending cases.[^report]
- Shared operators link Allegan jail/village, Sandersville jail/Brown House and
  Chambersburg jail/John Brown House without merging the separate visitor institutions.
  Chambersburg's earlier independent flag was corrected; companion institutions remain
  pending where their full review is unfinished.[^report]
- Barnesville's archives and former corporate office are reconciled as one excluded
  non-museum institution; its jail museum remains separate. Historic Tours of America's
  generic St Augustine operator/campus record is not a fourth museum beside its named
  attractions.[^report]
- Lawrenceburg, Barnesville, Smethport and St Augustine have sourced factual reviews.
  Smethport now uses the operator's public name, The County Museum in The Old Jail, through
  a guarded preferred-name input; its source name and coordinates are unchanged.[^report]
- Validation: 253 assertions and 17 integrity checks pass, including all 325 protected prior
  evidence/label files, original source fields, automatic baseline, threshold 0.85, guarded
  replay and refreshed Parquet. The explicit publication gate correctly rejects the
  unfinished Old Jail group. These source decisions are not independent matching-accuracy
  labels.[^report]

# Open actions

Four cases remain in
[`human_review.csv`](../../../data/validation/museum_jail_followup_2026-09-26/human_review.csv):
Hayesville needs current public-name/operator/campus confirmation; Winchester needs current
governance and the relationship between two distinct legal organizations; Thompson Falls
needs current governance and precise visitor-address wording; Greenwood needs museum-campus
scope confirmation.[^human-review] Failed access, historical leases and public repair
funding do not settle these questions, and no outreach message has been sent.[^report]

Visitor access and publication map points need a dated check even for institutions with
complete factual review. The lower corrected groups expose other unreviewed leaders,
including Depot Museum and Wayne County Historical Society at ten; no national winner is
established, and county and earlier queues remain open.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_jail_followup_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_jail_followup_2026-09-26/):
  [applied name decisions](../../../data/validation/museum_jail_followup_2026-09-26/applied_name_decisions.csv),
  [Old Jail institutions after](../../../data/validation/museum_jail_followup_2026-09-26/old_jail_institutions_after.csv),
  [ranking after](../../../data/validation/museum_jail_followup_2026-09-26/ranking_after.csv),
  [research notes](../../../data/validation/museum_jail_followup_2026-09-26/research_notes.md),
  [integrity checks](../../../data/validation/museum_jail_followup_2026-09-26/integrity_checks.csv),
  [validation log](../../../data/validation/museum_jail_followup_2026-09-26/validation.log)
- `build_check.R` validates this live checkpoint; do not overwrite it after a successor
  changes the live inputs.[^report]
- One-time scripts (`prepare.R`, `apply.R`) are frozen; never rerun them.

[^report]: Old Jail follow-up checkpoint report
[^human-review]: Old Jail remaining cases
