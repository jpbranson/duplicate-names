---
type: Evidence Packet
title: Bedford, Belmont and Chatham source review
description: Twenty-one exact-name candidates in three seven-count groups reviewed; 52,429 counted and 52,297 eligible institutions, 154 complete factual reviews including exclusions and eight pending reviews.
resource: ../../../data/validation/museum_bedford_belmont_chatham_2026-09-26.md
tags: [museums, leaders, identity, not-museum, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 25
superseded_by: museum_commemorative_air_force_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_bedford_belmont_chatham_2026-09-26.md
    title: Bedford, Belmont and Chatham museum review report
  - id: packet
    resource: ../../../data/validation/museum_bedford_belmont_chatham_2026-09-26/
    title: Bedford, Belmont and Chatham packet (inputs, evidence, validation)
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 16:57–17:21 UTC entries
---

# Scope

Reviews the 21 starting exact-name candidates in Bedford, Belmont and Chatham Historical
Society. It does not certify a national winner, dataset-wide matching accuracy or
visitor-ready map coordinates.[^report] Preceded by
[Madison, Marion County and Milton](museum_madison_marion_milton_2026-09-26.md); superseded
by [Commemorative Air Force](museum_commemorative_air_force_2026-09-26.md). A later
checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Preserved source rows | 60,002 | 60,002 |
| Counted source rows | 57,136 | 57,129 |
| Counted institutions | 52,437 | 52,429 |
| Eligible for L2 analysis | 52,305 | 52,297 |
| Guarded identity rows / cases | 351 / 147 | 364 / 154 |
| Complete factual reviews, including exclusions | 146 | 154 |
| Sourced not-museum exclusions | 23 | 24 |
| Preferred-name overrides | 91 | 95 |
| Isolated source conflicts | 30 | 31 |

- Adds 13 identity rows in seven cases, 16 factual decisions and four public names; eight
  reviews are complete and eight explicitly pending. Bare-name non-chain groups change from
  seven each to Bedford three, Belmont two and Chatham four.[^report]
- New York's Bedford office/store at 612 Old Post Road is excluded on the operator's
  positive description; no office-to-branch merger is invented.[^report]
- Massachusetts Bedford's documented move reconciles old and current addresses; Job Lane
  Farm Museum's separately elected Friends board is kept as a different operator. Chatham's
  Massachusetts records reconcile to Atwood Museum.[^report]
- New Hampshire Belmont's IMLS row mixes local legal/mail identity with North Carolina's
  physical address and website. It is separately uncounted, supplies no aliases and is not
  a not-museum decision.[^report]
- Possible unrelated quality leads are preserved, not adjudicated: New Bedford Whaling
  Museum and Fishing Heritage Center share a baseline entity, and Chatham Railroad Museum
  appears at two Massachusetts addresses.[^report]
- Validation: all 340 assertions pass with zero failures, warnings or skips; all 27
  saved-output and integrity checks pass; the 1,467 protected earlier evidence files and
  human labels, the baseline, source coordinates and the 0.85 threshold are unchanged.
  Old Jail Museum remains the provisional non-chain leader at eight, with four reviews
  pending and a failed publication gate.[^report]

# Open actions

The eight actions in
[`human_review.csv`](../../../data/validation/museum_bedford_belmont_chatham_2026-09-26/human_review.csv)
state the missing evidence and are not completion claims. They cover Virginia's Wharton
House scope, California Belmont's governance, the New Hampshire Belmont conflict, Dayton
Belmont's scope, the two New Hampshire Chatham addresses, and New Jersey and Ohio Chatham
questions.[^report][^packet] The 886-row related context includes unrelated institutions
and was not all factually reviewed.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_bedford_belmont_chatham_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_bedford_belmont_chatham_2026-09-26/):
  [evidence](../../../data/validation/museum_bedford_belmont_chatham_2026-09-26/evidence.csv),
  [candidate dispositions](../../../data/validation/museum_bedford_belmont_chatham_2026-09-26/candidate_dispositions.csv),
  [integrity checks](../../../data/validation/museum_bedford_belmont_chatham_2026-09-26/integrity_checks.csv)
- One-time scripts (`prepare.R`, `apply.R`) are frozen; never rerun them. The before
  snapshot is `data/processed/museum_bedford_belmont_chatham_before.rds`.[^flight-log]

[^report]: Bedford, Belmont and Chatham museum review report
[^packet]: Bedford, Belmont and Chatham packet (inputs, evidence, validation)
[^flight-log]: Flight log, 2026-09-26 16:57–17:21 UTC entries
