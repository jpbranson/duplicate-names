---
type: Evidence Packet
title: Commemorative Air Force factual review
description: Parent affiliation resolved for seven generic CAF candidates and three related records; 52,426 counted and 52,294 eligible institutions, 158 complete factual reviews and six pending actions.
resource: ../../../data/validation/museum_commemorative_air_force_2026-09-26.md
tags: [museums, chains, affiliation, identity, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 26
superseded_by: museum_franklin_heritage_newton_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_commemorative_air_force_2026-09-26.md
    title: Commemorative Air Force factual review report
  - id: packet
    resource: ../../../data/validation/museum_commemorative_air_force_2026-09-26/
    title: Commemorative Air Force packet (inputs, evidence, validation)
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 17:22–17:39 UTC entries
---

# Scope

Resolves the parent-affiliation question for the seven generic Commemorative Air Force
(CAF) candidates and three related records. It does not certify the total CAF museum count
or a national non-chain winner.[^report] Preceded by
[Bedford, Belmont and Chatham](museum_bedford_belmont_chatham_2026-09-26.md); superseded by
[Franklin, Heritage and Newton](museum_franklin_heritage_newton_2026-09-26.md). A later
checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,129 | 57,126 |
| Counted institutions | 52,429 | 52,426 |
| Eligible for L2 analysis | 52,297 | 52,294 |
| Guarded identity rows / cases | 364 / 154 | 370 / 157 |
| Complete factual reviews, including exclusions | 154 | 158 |
| Sourced not-museum exclusions | 24 | 24 |
| Preferred names | 95 | 97 |
| Isolated source conflicts | 31 | 31 |

- CAF's unit policy and NAEC disclosure establish common control across the parent, units
  and supporting museum corporations. The ten reviewed institutions receive the affiliation
  `commemorative_air_force`; three supported duplicate pairs count once each. No blanket
  identity rule is applied to the broader CAF directory or the 222-row research
  context.[^report]
- The generic exact-name CAF group falls from seven to zero in the non-chain ranking because
  affiliation is known (see [chain detection](../../methodology/chain-detection.md)). This
  does not mean all CAF identities are resolved.[^report]
- Florida (DeLand), Minnesota (Fleming Field) and Georgia (Echo Street and Echo Court)
  descriptions reconcile. Kansas receives the public name CAF Heart of America Wing and
  Midland's High Sky row the name Midland Army Air Field Museum.[^report]
- Midland's three source roles at 9600 Wright Drive, Dallas's NAEC and adjacent
  headquarters, and New Mexico's old Albuquerque contact remain separately pending. A shared
  address or organizational ancestry alone does not merge records. The flying-museum
  corporation's EIN 742554138 is kept distinct from static-museum EIN 742553763.[^report]
- Adds six identity rows in three cases, ten decisions and two names; four reviews are
  complete. No new exclusions or source-conflict holds.[^report][^flight-log]
- Validation: all 340 assertions pass with zero failures, warnings or skips; all 26
  integrity checks pass; the 1,578 protected prior evidence/label files, the baseline,
  source coordinates and the 0.85 threshold are preserved. Old Jail Museum remains the
  provisional non-chain leader at eight with four pending reviews; its publication gate
  still fails.[^report]

# Open actions

Six pending actions in
[`human_review.csv`](../../../data/validation/museum_commemorative_air_force_2026-09-26/human_review.csv)
cover New Mexico, three Midland source roles and Dallas's headquarters and NAEC.[^packet]
Georgia's access needs a recheck before publication.[^report] Franklin Historical Society,
Heritage Museum and Newton County Historical Society were next.[^flight-log]

# Files

- [Checkpoint report](../../../data/validation/museum_commemorative_air_force_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_commemorative_air_force_2026-09-26/):
  [evidence](../../../data/validation/museum_commemorative_air_force_2026-09-26/evidence.csv),
  [candidate dispositions](../../../data/validation/museum_commemorative_air_force_2026-09-26/candidate_dispositions.csv),
  [PDF visual review](../../../data/validation/museum_commemorative_air_force_2026-09-26/pdf_visual_review.md),
  [integrity checks](../../../data/validation/museum_commemorative_air_force_2026-09-26/integrity_checks.csv)
- One-time scripts (`prepare.R`, `apply.R`) are frozen; never rerun them.[^packet]

[^report]: Commemorative Air Force factual review report
[^packet]: Commemorative Air Force packet (inputs, evidence, validation)
[^flight-log]: Flight log, 2026-09-26 17:22–17:39 UTC entries
