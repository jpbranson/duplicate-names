---
type: Evidence Packet
title: Franklin, Heritage and Newton factual review
description: Twenty-one candidates in three seven-count name groups reviewed; 52,413 counted and 52,281 eligible institutions, 166 complete factual reviews and fifteen pending cases.
resource: ../../../data/validation/museum_franklin_heritage_newton_2026-09-26.md
tags: [museums, leaders, identity, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 27
superseded_by: museum_telephone_union_washington_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_franklin_heritage_newton_2026-09-26.md
    title: Franklin, Heritage and Newton factual review report
  - id: packet
    resource: ../../../data/validation/museum_franklin_heritage_newton_2026-09-26/
    title: Franklin, Heritage and Newton packet (inputs, evidence, validation)
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 17:41–18:07 UTC entries
---

# Scope

Reviews the 21 candidates in three seven-count name groups (Franklin Historical Society,
Heritage Museum and Newton County Historical Society) and related source identities. It
does not certify a national museum headline.[^report][^flight-log] Preceded by
[Commemorative Air Force](museum_commemorative_air_force_2026-09-26.md); superseded by
[Telephone, Union and Washington](museum_telephone_union_washington_2026-09-26.md).
A later checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,126 | 57,111 |
| Counted institutions | 52,426 | 52,413 |
| Eligible for L2 analysis | 52,294 | 52,281 |
| Guarded identity rows / cases | 370 / 157 | 396 / 168 |
| Complete factual reviews, including exclusions | 158 | 166 |
| Sourced not-museum exclusions | 24 | 24 |
| Preferred names | 97 | 100 |
| Isolated source conflicts | 31 | 33 |

- Adds 26 identity rows in eleven cases, 23 factual decisions and three names; eight
  factual reviews are complete.[^report]
- Two cross-state IMLS rows are isolated uncounted. One mixes a New Jersey Franklin museum
  and address with Indiana legal identity and coordinates; the clean Indiana members stay
  under Franklin Heritage without the disputed alias. The other, an Iowa Heritage Museum
  row, carries New Jersey legal identity; only the clean Freehold pair reconciles as Jewish
  Heritage Museum of Monmouth County.[^report]
- Heritage reconciliations include Heritage Museum at Falfurrias, Virginia's Rocktown
  History campus (the nearby Virginia Quilt Museum is not merged) and Austin's
  school-operated Heritage Center Museum, with no multi-museum chain inferred.[^report]
- Newton County Historical Society Museum and Resource Center (Indiana) reconciles its
  physical and mail descriptions; common control with the separate Scott-Lucas House is
  supported, and neither that house nor Hazelden is merged into Kentland.[^report]
- Arkansas's older 601 W Clark row stays separate from Bradley House's documented 403 W
  Clark campus; identical coordinates alone do not resolve it.[^report]
- Validation: all 340 assertions pass with zero failures, warnings or skips; all 28
  integrity checks pass; the 1,667 protected prior files, baseline, source coordinates,
  human labels and the 0.85 threshold are preserved. First dry runs caught an HTTP evidence
  URL and incomplete Indiana cluster membership; both were corrected without weakening any
  validation rule. Old Jail Museum still leads provisionally at eight with four pending
  reviews; its publication gate fails.[^report]

# Open actions

Fifteen open actions in
[`human_review.csv`](../../../data/validation/museum_franklin_heritage_newton_2026-09-26/human_review.csv),
including the two cross-state conflicts, Maine and New Hampshire governance, New Jersey's
current museum operation, Indiana museum scope, Astoria's IMLS parent mailing row, and
Neosho, Georgia, Mississippi and Baltimore scope or governance.[^report][^packet] The
Georgia and Mississippi sources are not excluded from search absence. Telephone Museum,
Union County Historical Society and Washington Historical Society were next.[^report] The
2,881 broad related rows are context, not completed factual review.[^flight-log]

# Files

- [Checkpoint report](../../../data/validation/museum_franklin_heritage_newton_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_franklin_heritage_newton_2026-09-26/):
  [evidence](../../../data/validation/museum_franklin_heritage_newton_2026-09-26/evidence.csv),
  [candidate dispositions](../../../data/validation/museum_franklin_heritage_newton_2026-09-26/candidate_dispositions.csv),
  [PDF inspection log](../../../data/validation/museum_franklin_heritage_newton_2026-09-26/pdf_visual_review.md),
  [integrity checks](../../../data/validation/museum_franklin_heritage_newton_2026-09-26/integrity_checks.csv)
- One-time scripts (`prepare.R`, `apply.R`) are frozen; never rerun them.[^packet]

[^report]: Franklin, Heritage and Newton factual review report
[^packet]: Franklin, Heritage and Newton packet (inputs, evidence, validation)
[^flight-log]: Flight log, 2026-09-26 17:41–18:07 UTC entries
