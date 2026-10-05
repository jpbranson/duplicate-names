---
type: Evidence Packet
title: Madison, Marion County and Milton source review
description: Twenty-four exact-name candidates reviewed; 52,437 counted and 52,305 eligible institutions, 146 complete factual reviews including exclusions and eight pending reviews.
resource: ../../../data/validation/museum_madison_marion_milton_2026-09-26.md
tags: [museums, leaders, identity, not-museum, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 24
superseded_by: museum_bedford_belmont_chatham_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_madison_marion_milton_2026-09-26.md
    title: Madison, Marion County and Milton museum review report
  - id: packet
    resource: ../../../data/validation/museum_madison_marion_milton_2026-09-26/
    title: Madison, Marion County and Milton packet (inputs, evidence, validation)
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 16:30–16:56 UTC entries
---

# Scope

Reviews the 24 starting exact-name candidates in Madison, Marion County and Milton
Historical Society. It does not certify a national winner, dataset-wide matching accuracy
or publication-ready map points.[^report] Preceded by
[Jefferson and Lincoln County](museum_jefferson_lincoln_2026-09-26.md); superseded by
[Bedford, Belmont and Chatham](museum_bedford_belmont_chatham_2026-09-26.md). A later
checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,156 | 57,136 |
| Counted institutions | 52,455 | 52,437 |
| Eligible for L2 analysis | 52,323 | 52,305 |
| Guarded identity rows / cases | 319 / 134 | 351 / 147 |
| Complete factual reviews, including exclusions | 132 | 146 |
| Sourced not-museum exclusions | 22 | 23 |
| Preferred-name overrides | 80 | 91 |
| Isolated source conflicts | 29 | 30 |

- Adds 32 identity rows in 13 cases, 22 factual decisions and 11 public names; fourteen
  reviews are complete and eight explicitly pending. Bare-name non-chain groups fall from
  eight each to Madison one, Marion County two and Milton zero; these are identity and name
  corrections, not claims that the places no longer exist.[^report]
- New Jersey's Madison research office is excluded using its current operator description
  and explicit future museum plans.[^report]
- Connecticut keeps two separate Madison museums under one society. In the Marion County
  group, Ohio's Popcorn Museum stays separate from the co-located Heritage Hall, and Oregon
  and Georgia records reconcile to Willamette Heritage Center and university-affiliated
  Pasaquan.[^report]
- Milton's Pennsylvania, Vermont, Wisconsin and Massachusetts records are reconciled. The
  mixed Massachusetts IMLS row stays separately uncounted and supplies no aliases.[^report]
- An Iowa 210 Union Street field is kept as a separate, unreviewed source-quality lead. The
  606 related baseline rows include Hamilton strings and were not all reviewed.[^report]
- Validation: all 340 assertions pass with zero failures, warnings or skips; all 27
  saved-output and integrity checks pass; the 1,351 protected earlier evidence files and
  human labels, the baseline, source coordinates and the 0.85 threshold are
  unchanged.[^report]
- Old Jail Museum remains the provisional non-chain leader at eight, with four reviews
  pending and a failing publication gate.[^report]

# Open actions

[`human_review.csv`](../../../data/validation/museum_madison_marion_milton_2026-09-26/human_review.csv)
holds the eight follow-ups, including New York, the older Ohio address cluster, and Alabama,
Missouri and current Mississippi operator scope. Publication still needs current access and
sourced visitor coordinates. The seven-count groups were next, beginning with Bedford,
Belmont and Chatham Historical Society.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_madison_marion_milton_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_madison_marion_milton_2026-09-26/):
  [evidence](../../../data/validation/museum_madison_marion_milton_2026-09-26/evidence.csv),
  [candidate dispositions](../../../data/validation/museum_madison_marion_milton_2026-09-26/candidate_dispositions.csv),
  [integrity checks](../../../data/validation/museum_madison_marion_milton_2026-09-26/integrity_checks.csv)
- One-time scripts (`prepare.R`, `apply.R`) are frozen; never rerun them.[^packet] The
  before snapshot is `data/processed/museum_madison_marion_milton_before.rds`.[^flight-log]

[^report]: Madison, Marion County and Milton museum review report
[^packet]: Madison, Marion County and Milton packet (inputs, evidence, validation)
[^flight-log]: Flight log, 2026-09-26 16:30–16:56 UTC entries
