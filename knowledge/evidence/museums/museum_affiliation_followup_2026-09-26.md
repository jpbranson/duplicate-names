---
type: Evidence Packet
title: Affiliation follow-up — Madame Tussauds, Smithsonian and shared local operators
description: Supported affiliation corrections for Madame Tussauds Las Vegas, Smithsonian parent labels and two shared local operators; 52,557 counted and 52,425 eligible institutions, 39 complete factual reviews.
resource: ../../../data/validation/museum_affiliation_followup_2026-09-26.md
tags: [museums, affiliation, m2, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 14
superseded_by: museum_publication_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_affiliation_followup_2026-09-26.md
    title: Affiliation follow-up checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_affiliation_followup_2026-09-26/
    title: Affiliation follow-up packet (inputs, context, decisions, audit, validation)
  - id: notes
    resource: ../../../data/validation/museum_affiliation_followup_2026-09-26/research_notes.md
    title: Affiliation follow-up evidence and open questions
---

# Scope

Affiliation work on chain overlaps, Smithsonian parent-label records and local operators
that run more than one museum. Supported corrections are validated; the overall affiliation
and headline review remains incomplete.[^report] Preceded by
[the Old Jail follow-up](museum_jail_followup_2026-09-26.md); superseded by
[publication preparation](museum_publication_2026-09-26.md). Deprecated: a later checkpoint
superseded its counts; the packet remains valid historical evidence.

# Outcome

The report gives no before/after table. Its provisional counts:[^report]

| Measure | At this checkpoint |
|---|---:|
| Original source rows retained | 60,002 |
| Counted source records | 57,272 |
| Counted museum institutions | 52,557 |
| Eligible for L2 | 52,425 |
| Identity rows / cases | 125 / 51 |
| Complete factual reviews | 39 |
| Sourced non-museum decisions | 11 |

- Two Las Vegas wax-museum records now represent one affiliated Madame Tussauds attraction
  with its current public name. This resolves the earlier wax-museum chain overlap; it does
  not certify a nationwide chain inventory.[^report][^notes]
- Two Archives of American Art office/research sites are excluded as additional museums.
  Five Smithsonian parent-label records receive supported affiliation while their
  institution membership/names remain pending; three generic parent rows remain
  unknown.[^report]
- A consistency check corrected two older independent flags: Washington County Heritage
  Center shares its local operator with Warden's House and Hay Lake School, and Stevens
  Memorial Museum shares the John Hay Center operator with The Depot Railroad Museum. Four
  companion records gain affiliation but keep full reviews pending; the museums remain
  separate. An independent nonprofit board does not make multiple museums operated by that
  board independent of one another.[^report]
- The [M2 semantic review](../../../data/validation/museum_affiliation_followup_2026-09-26/m2_semantic_review.csv)
  records why a scope token alone does not establish a singularity claim. No M2 collision
  group is certified.[^report]
- Validation: 253 test assertions and 17 integrity checks pass, including all 366 protected
  prior evidence/label files, the unchanged automatic baseline and multisite queue, threshold
  0.85, original source fields, guarded replay and both exports. No new independent accuracy
  estimate is made.[^report]

# Open actions

Old Jail, the county groups, newly exposed top-name groups, Smithsonian identity cases,
Museum of Illusions Miami Beach and the earlier queues remain incomplete, and the explicit
Old Jail gate still fails. The post may proceed only as a visibly provisional local draft;
no external blog directory is configured.[^report] The packet has no follow-up CSV; the
remaining Smithsonian parent-label cases are described in the
[research notes](../../../data/validation/museum_affiliation_followup_2026-09-26/research_notes.md).[^notes]

# Files

- [Checkpoint report](../../../data/validation/museum_affiliation_followup_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_affiliation_followup_2026-09-26/):
  [final museum decisions](../../../data/validation/museum_affiliation_followup_2026-09-26/museum_decisions_final.csv),
  [local-operator decisions](../../../data/validation/museum_affiliation_followup_2026-09-26/local_operator_decisions.csv),
  [ranking final](../../../data/validation/museum_affiliation_followup_2026-09-26/ranking_final.csv),
  [integrity checks](../../../data/validation/museum_affiliation_followup_2026-09-26/integrity_checks.csv),
  [validation log](../../../data/validation/museum_affiliation_followup_2026-09-26/validation.log)
- The initial sub-checkpoint is preserved in `initial_*` files. Use
  `museum_decisions_final.csv` for the final decisions and the archived identity/name inputs
  for reproduction.[^report]
- One-time scripts (`prepare.R`, `resume_prepare.R`, `apply.R`, `local_operator_apply.R`)
  are frozen; never rerun them.

[^report]: Affiliation follow-up checkpoint report
[^notes]: Affiliation follow-up evidence and open questions
