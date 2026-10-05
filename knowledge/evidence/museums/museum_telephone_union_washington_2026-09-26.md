---
type: Evidence Packet
title: Telephone, Union and Washington factual review
description: Twenty-one candidates mapped to eighteen reviewed institution descriptions; 52,409 counted and 52,277 eligible institutions, 170 complete factual reviews and fourteen pending.
resource: ../../../data/validation/museum_telephone_union_washington_2026-09-26.md
tags: [museums, leaders, identity, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 28
superseded_by: museum_m2_leaders_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_telephone_union_washington_2026-09-26.md
    title: Telephone, Union and Washington factual review report
  - id: packet
    resource: ../../../data/validation/museum_telephone_union_washington_2026-09-26/
    title: Telephone, Union and Washington packet (inputs, evidence, validation)
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 18:08–18:30 UTC entries
---

# Scope

Reviews the 21 starting candidates in the Telephone, Union and Washington name groups,
which map to eighteen reviewed institution descriptions. It does not certify a national
winner or a complete museum census.[^report] Preceded by
[Franklin, Heritage and Newton](museum_franklin_heritage_newton_2026-09-26.md); superseded
by [M2 leading groups](museum_m2_leaders_2026-09-26.md). A later checkpoint superseded its
counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,111 | 57,107 |
| Counted institutions | 52,413 | 52,409 |
| Eligible for L2 analysis | 52,281 | 52,277 |
| Guarded identity rows / cases | 396 / 168 | 403 / 171 |
| Complete factual reviews, including exclusions | 166 | 170 |
| Sourced not-museum exclusions | 24 | 24 |
| Preferred names | 100 | 103 |
| Isolated source conflicts | 33 | 33 |

- Nine identity rows cover three new cases and an explicit extension of the earlier two-row
  Union County, Illinois case, whose identifier and canonical site group are preserved.
  Seven earlier pending factual decisions are deliberately updated, with originals kept in
  the dated snapshots. Four factual reviews are complete; fourteen remain pending.[^report]
- Maine's Telephone Museum reconciles to one locally governed museum. A 2022 Lexington
  tenancy proposal is not treated as an accepted move; conflicting Massachusetts legal
  identifiers remain separate and visible.[^report]
- Washington: Missouri's physical/mail descriptions reconcile; Illinois's former
  Dement-Zinser site reconciles with the current society; New York receives its current
  name, Millbrook Historical Society, with museum versus archives scope pending.[^report]
- Union: Ohio's Morey house/annex museum has a complete factual review; Georgia receives
  its current Old Courthouse Museum name; the Cobden collection's documented 2006 transfer
  supports the Illinois extension and the current Union County Museum name. Pennsylvania's
  planned Packwood reopening is not reported as completed.[^report]
- Validation: all 340 assertions and 26 integrity checks pass with no failures, warnings or
  skips; all 1,781 protected prior evidence/label files, source coordinates, baseline and
  the 0.85 threshold are preserved. The first dry run correctly rejected former sites
  sharing a canonical site group; the drafts were corrected and no guard was weakened. Old
  Jail Museum remains the provisional non-chain leader at eight with four pending reviews;
  its publication gate still fails.[^report]

# Open actions

Fourteen actions in
[`human_review.csv`](../../../data/validation/museum_telephone_union_washington_2026-09-26/human_review.csv)
cover Telephone records in Atlanta, Houston, Massachusetts and Fairmont; Washington in
Illinois, Maine and New York; and Union in Georgia, Indiana, Illinois, Pennsylvania, Oregon
and North Carolina.[^packet] No record is excluded merely for a mailbox or failed
search.[^report] Remaining M2 and earlier identity work was to precede the artifact
refresh.[^flight-log]

# Files

- [Checkpoint report](../../../data/validation/museum_telephone_union_washington_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_telephone_union_washington_2026-09-26/):
  [evidence](../../../data/validation/museum_telephone_union_washington_2026-09-26/evidence.csv),
  [candidate dispositions](../../../data/validation/museum_telephone_union_washington_2026-09-26/candidate_dispositions.csv),
  [PDF visual review](../../../data/validation/museum_telephone_union_washington_2026-09-26/pdf_visual_review.md),
  [integrity checks](../../../data/validation/museum_telephone_union_washington_2026-09-26/integrity_checks.csv)
- One-time scripts (`prepare.R`, `apply.R`, `prepare_validation.py`, `finalize_packet.py`)
  are frozen; never rerun them.[^packet]

[^report]: Telephone, Union and Washington factual review report
[^packet]: Telephone, Union and Washington packet (inputs, evidence, validation)
[^flight-log]: Flight log, 2026-09-26 18:08–18:30 UTC entries
