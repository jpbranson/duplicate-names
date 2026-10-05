---
type: Evidence Packet
title: Church ordinal and scope checkpoint (current church checkpoint)
description: Day-modifier ordinal parser correction and two sourced Christian-scope holds, leaving 540,778 canonical descriptions, 442,832 eligible and zero complete church factual reviews.
resource: ../../../data/validation/church_ordinal_review_2026-09-26.md
tags: [churches, checkpoint, ordinals, scope]
status: stable
checkpoint: 2026-09-26
sequence: 2
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/church_ordinal_review_2026-09-26.md
    title: Church ordinal and scope checkpoint report
  - id: packet
    resource: ../../../data/validation/church_ordinal_review_2026-09-26/
    title: Church ordinal and scope packet (inputs, evidence, validation)
  - id: readme
    resource: ../../../data/validation/church_ordinal_review_2026-09-26/README.md
    title: Church ordinal and scope packet README
  - id: artifact-qa
    resource: ../../../data/validation/church_ordinal_review_2026-09-26/artifact_QA.md
    title: Church checkpoint artifact QA
  - id: metric-impact
    resource: ../../../data/validation/church_ordinal_review_2026-09-26/metric_impact.json
    title: Church ordinal metric impact
  - id: phase1
    resource: ../../../data/validation/church_phase1_2026-09-26/README.md
    title: Church acquisition and methodology checkpoint README
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 19:17–20:00 UTC entries and the post 1 rescope entry
---

# Scope

A bounded implementation and evidence checkpoint. It researches the ten highest-ordinal
candidates and Seventh/Eighth Day names, adds a day-modifier parser guard, applies two sourced
scope holds and refreshes the local church draft and explorer.[^readme] Preceded by
[the acquisition checkpoint](church_phase1_2026-09-26.md). It is the current church checkpoint;
the later [scope follow-up](church_scope_followup_2026-09-26.md) is an unapplied proposal.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Original source rows | 1,032,223 | 1,032,223 |
| Canonical Overture descriptions | 540,778 | 540,778 |
| Eligible | 442,834 | 442,832 |
| Baptist First candidates | 9,619 | 9,618 |

Before counts come from the acquisition checkpoint;[^phase1] after counts from this
report.[^report] The Baptist First cohort comes from the packet's metric impact
file.[^metric-impact]

- Day modifiers no longer number congregations; outer ordinals such as First Seventh Day
  Baptist are kept. The full dry run changed 225 source rows (108 Overture, 56 GNIS, 61 HIFLD),
  19 ordinal-conflict flags and two cross-source comparison predictions, with no automatic
  cluster membership or counted-flag changes. The 0.85 threshold and raw fields are preserved.
  This is not an independent accuracy evaluation.[^readme]
- 107 canonical ordinal values changed (87 eligible); 8,554 neighbor-bearing Baptist Firsts and
  the 12.788455840965005 km median are unchanged.[^metric-impact]
- Alexandria and Miami Church of God and Saints of Christ (COGASOC) tabernacles are held outside
  Christian-only statistics. Their operator pages match the source addresses and phones, and
  the parent describes its faith as Judaism. Source religion, automatic identity and pending
  review status are preserved.[^report] The live holds are the
  [church scope decisions](../../inputs/church-scope-decisions.md).
- `leader_review.csv` documents the ten highest prior candidates: five unresolved, three
  partial, two with applied scope holds. No row is a complete factual review or a certified
  national maximum.[^readme]
- Validation: 352 assertions across 73 tests and 20 integrity checks pass; all 2,020 prior files
  are byte-preserved, including the still-blank independent version-2 labels.[^readme] A first
  map-CSV check failed on a one-ULP round trip; the repaired check uses a 1e-12-degree bound,
  and source-coordinate checks stay exact.[^artifact-qa]
- The church draft rendered independently (678,361 bytes) and both dashboard datasets pass
  serialized L2/L3 checks. A collection/scope-change loading race and a stale empty-table
  caption were fixed; 7 asynchronous and 19 data/import/export JS assertions pass.[^readme]
- Twenty-one public URLs were attempted: eighteen cached, two returned HTTP 403 and one looped
  redirects; no bypass was used.[^readme]
- No version-2 sampled record is touched by the parser or the two scope holds. Directory
  discovery saved 36 candidate descriptions (25 still eligible) as follow-up candidates, not
  blanket affiliation decisions.[^readme]

# Open actions

- Five unresolved high-number cases with their exact missing evidence are in
  [`human_review.csv`](../../../data/validation/church_ordinal_review_2026-09-26/human_review.csv);
  the three partial reviews keep next actions. Albany's current source linkage is
  unresolved.[^readme]
- Zero complete church factual reviews; no independent labels supplied (see the
  [version-2 label set](../../inputs/church-independent-labels-v2.md)).[^report]
- Actual browser CSV saving remains unverified.[^artifact-qa]
- The [scope follow-up](church_scope_followup_2026-09-26.md) proposal awaits user approval.
  Church work is frozen until post 1 publishes
  ([decision 14](../../decisions/14-post-1-headline-sufficient-review.md)).[^flight-log]

# Files

- [Checkpoint report](../../../data/validation/church_ordinal_review_2026-09-26.md)
- [Packet directory](../../../data/validation/church_ordinal_review_2026-09-26/):
  [README](../../../data/validation/church_ordinal_review_2026-09-26/README.md),
  [leader evidence](../../../data/validation/church_ordinal_review_2026-09-26/leader_review.csv),
  [integrity checks](../../../data/validation/church_ordinal_review_2026-09-26/integrity_checks.csv),
  [parser impact](../../../data/validation/church_ordinal_review_2026-09-26/parser_impact.json),
  [artifact QA](../../../data/validation/church_ordinal_review_2026-09-26/artifact_QA.md),
  [COGASOC follow-up](../../../data/validation/church_ordinal_review_2026-09-26/cogasoc_followup.csv)
- `*.before` files keep the original parser and name inputs (see
  [church name overrides](../../inputs/church-name-overrides.md));[^flight-log]
  `working_labels_before/` archives the working label exports.[^readme]
- Snapshot, apply and finalize scripts (`prepare.R`, `finalize.py` and the others) are one-time;
  never rerun them or overwrite this packet.[^readme]

[^report]: Church ordinal and scope checkpoint report
[^readme]: Church ordinal and scope packet README
[^artifact-qa]: Church checkpoint artifact QA
[^metric-impact]: Church ordinal metric impact
[^phase1]: Church acquisition and methodology checkpoint README
[^flight-log]: Flight log, 2026-09-26 19:17–20:00 UTC entries and the post 1 rescope entry
