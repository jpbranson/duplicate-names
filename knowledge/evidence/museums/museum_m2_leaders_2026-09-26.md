---
type: Evidence Packet
title: M2 leading groups — identity and meaning (current museum checkpoint)
description: Twelve leading scope-word groups (48 starting records) reviewed; 52,387 counted and 52,255 eligible institutions, 174 complete factual reviews and 28 open actions.
resource: ../../../data/validation/museum_m2_leaders_2026-09-26.md
tags: [museums, m2, identity, checkpoint]
status: stable
checkpoint: 2026-09-26
sequence: 29
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_m2_leaders_2026-09-26.md
    title: Leading M2 groups checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_m2_leaders_2026-09-26/
    title: M2 leading-groups packet (inputs, evidence, validation)
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 18:31–18:57 UTC entries
---

# Scope

A bounded pass over 48 starting records in the twelve leading M2 scope-word name groups. It
checks source identity and, separately, whether each scope word actually asserts
singularity.[^report] Preceded by
[Telephone, Union and Washington](museum_telephone_union_washington_2026-09-26.md). It is the
latest museum count checkpoint.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,107 | 57,083 |
| Counted institutions | 52,409 | 52,387 |
| Eligible for L2 analysis | 52,277 | 52,255 |
| Guarded identity rows / cases | 403 / 171 | 440 / 185 |
| Complete factual reviews, including exclusions | 170 | 174 |
| Positive not-museum exclusions | 24 | 25 |
| Preferred public names | 103 | 105 |
| Isolated source conflicts | 33 | 35 |

- Applies 37 identity rows in fourteen new cases, 29 factual decisions and two current
  public names.[^report]
- Validation: 340 assertions and 27 integrity checks pass; 1,887 earlier evidence/label files
  are unchanged; baseline, source names/coordinates, multisite queue and the 0.85 threshold
  are intact.[^report]
- Two pending generic Smithsonian decisions are deliberately retired because their rows are
  absorbed into the named New York museum; the originals are archived.[^report]
- Notable reconciliations: Oregon International Police Museum (former and current sites),
  Old World Wisconsin campus, NMAAHC with its conservation lab, NMAI's two campuses kept
  separate, and Chattanooga's descriptions under the current Coolidge National Medal of Honor
  Heritage Center name.[^report]
- The [scope-word review](../../../data/validation/museum_m2_leaders_2026-09-26/scope_word_review.csv)
  records that American Art, American Armor and international collections describe subjects,
  National can reflect tribal governance or reach, and Old World is an idiom. These readings
  do not certify counts.[^report]
- Old Jail Museum remains the provisional non-chain leader at eight, with four pending reviews
  and a failing publication gate at this checkpoint. No national headline is
  certified.[^report] Decision 14 later changed how Old Jail is assessed; see
  [post 1](../../publications/post-1-museums.md).

# Open actions

28 open actions: 25 newly reviewed institutions pending plus three carried-forward African
American Museum questions, in
[`human_review.csv`](../../../data/validation/museum_m2_leaders_2026-09-26/human_review.csv).[^report]
Remaining M2 groups and prior identity actions are unfinished.

# Files

- [Checkpoint report](../../../data/validation/museum_m2_leaders_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_m2_leaders_2026-09-26/):
  [ranking after](../../../data/validation/museum_m2_leaders_2026-09-26/ranking_after.csv),
  [candidate dispositions](../../../data/validation/museum_m2_leaders_2026-09-26/candidate_dispositions.csv),
  [evidence](../../../data/validation/museum_m2_leaders_2026-09-26/evidence.csv),
  [identity audit](../../../data/validation/museum_m2_leaders_2026-09-26/identity_audit_after.csv),
  [integrity checks](../../../data/validation/museum_m2_leaders_2026-09-26/integrity_checks.csv)
- One-time scripts (`prepare.R`, `apply.R`) are frozen; never rerun them.

[^report]: Leading M2 groups checkpoint report
