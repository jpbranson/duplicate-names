---
type: Evidence Packet
title: Jefferson and Lincoln County source review
description: Sixteen candidates reviewed as seventeen outcomes; 52,455 counted and 52,323 eligible institutions, 132 complete factual reviews including exclusions and eight pending outcomes.
resource: ../../../data/validation/museum_jefferson_lincoln_2026-09-26.md
tags: [museums, leaders, identity, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 23
superseded_by: museum_madison_marion_milton_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_jefferson_lincoln_2026-09-26.md
    title: Jefferson and Lincoln County review report
  - id: packet
    resource: ../../../data/validation/museum_jefferson_lincoln_2026-09-26/
    title: Jefferson and Lincoln packet (inputs, evidence, validation)
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 16:04–16:28 UTC entries
---

# Scope

A factual source/identity checkpoint for the 16 starting candidates in Jefferson and
Lincoln County Historical Society, not an independent matching evaluation or a certified
national headline. Seventeen outcomes are reviewed because Newport has two distinct
museums.[^report] Preceded by
[Cass, Chester and Crawford](museum_cass_chester_crawford_2026-09-26.md); superseded by
[Madison, Marion County and Milton](museum_madison_marion_milton_2026-09-26.md). A later
checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

The report gives after-counts only; it started from the Cass/Chester/Crawford
checkpoint.[^flight-log]

| Measure | Count |
|---|---:|
| Original source rows retained | 60,002 |
| Counted source rows | 57,156 |
| Counted museum institutions | 52,455 |
| Eligible for L2 analysis | 52,323 |
| Explicit identity rows / cases | 319 / 134 |
| Complete factual reviews, including exclusions | 132 |
| Sourced not-museum decisions | 22 |
| Preferred public names | 80 |
| Isolated source-conflict rows | 29 |

- Adds 27 identity rows in 13 cases, 17 factual decisions and 11 preferred names, and no
  not-museum exclusion. Jefferson County Historical Society's bare-name non-chain group
  falls from eight to two; Lincoln County Historical Society's from eight to three. Counts
  remain provisional.[^report]
- Nine institutions gain complete factual reviews: Jefferson in Nebraska, Indiana, New York
  and Illinois; Lincoln in Colorado (Hedlund House Museum), Nebraska and Georgia; and
  Newport's Burrows House Museum and Pacific Maritime Heritage Center, kept as separate
  museums with a shared society affiliation.[^report]
- The Iowa Jefferson row combines an Iowa EIN and address with the Illinois society's
  website field. It is isolated as `source_conflict` with no aliases and no merger; this is
  not a `not_museum` finding.[^report]
- Validation: the selective build and 340 test assertions pass; all 25 integrity checks
  pass, including hashes for 1,235 prior evidence/label files, unchanged baseline, source
  coordinates, full guarded replay and the 0.85 threshold. No algorithm or schema
  changed.[^report] The first dry run rejected a New Mexico former site that reused its
  canonical site group; the draft was corrected and no identity guard changed.[^flight-log]
- The publication gate still rejects the leading group.[^report]

# Open actions

Eight pending actions in
[`human_review.csv`](../../../data/validation/museum_jefferson_lincoln_2026-09-26/human_review.csv):
Jefferson in Colorado (Hiwan Museum scope), Kansas, Iowa and Georgia; Lincoln in Kentucky,
Washington, Tennessee and New Mexico. No outreach was sent. Madison, Marion County and
Milton Historical Society were next, with the four Old Jail blockers kept visible.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_jefferson_lincoln_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_jefferson_lincoln_2026-09-26/):
  [evidence register](../../../data/validation/museum_jefferson_lincoln_2026-09-26/evidence_register.csv),
  [candidate dispositions](../../../data/validation/museum_jefferson_lincoln_2026-09-26/candidate_dispositions.csv),
  [integrity checks](../../../data/validation/museum_jefferson_lincoln_2026-09-26/integrity_checks.csv)
- One-time scripts (`prepare.R`, `acquire_hedlund.R`, `apply.R`) are frozen
  (`applied.json`); never rerun them.

[^report]: Jefferson and Lincoln County review report
[^flight-log]: Flight log, 2026-09-26 16:04–16:28 UTC entries
