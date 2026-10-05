---
type: Evidence Packet
title: Museum Depot and Wayne County checkpoint
description: Twenty provisional Depot Museum and Wayne County Historical Society candidates reviewed; 52,539 counted and 52,407 eligible institutions, 53 complete factual reviews and eleven pending entries.
resource: ../../../data/validation/museum_next_leaders_2026-09-26.md
tags: [museums, leaders, identity, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 16
superseded_by: museum_adams_brown_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_next_leaders_2026-09-26.md
    title: Museum Depot and Wayne County checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_next_leaders_2026-09-26/
    title: Depot and Wayne County packet (inputs, context, decisions, audits, validation)
  - id: artifact-qa
    resource: ../../../data/validation/museum_next_leaders_2026-09-26/artifact_QA.md
    title: Artifact refresh QA, 2026-09-26 (Depot/Wayne)
---

# Scope

Examined the 20 provisional Depot Museum and Wayne County Historical Society candidates,
their related source records, public names and operators, and applied supported corrections
without changing the automatic baseline or independent human labels. The headline review
remains incomplete.[^report] Preceded by
[publication preparation](museum_publication_2026-09-26.md); superseded by
[the Adams and Brown County review](museum_adams_brown_2026-09-26.md). Deprecated: a later
checkpoint superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Original source rows retained | 60,002 | 60,002 |
| Counted source rows in museum_records | 57,272 | 57,250 |
| Counted institutions | 52,557 | 52,539 |
| Eligible for name analysis | 52,425 | 52,407 |
| Explicit identity rows / cases | 125 / 51 | 160 / 63 |
| Complete factual reviews | 40 | 53 |
| Isolated source conflicts | 7 | 8 |
| Sourced not_museum decisions | 11 | 12 |
| Preferred public-name overrides | 2 | 18 |

- The ten bare Wayne County Historical Society candidates reduce to one unresolved Tennessee
  record; the ten bare Depot Museum candidates now have more specific operator or
  public-authority names. These are exact L2 group changes, not museum closures and not proof
  that other similarly named museums are absent. Franklin, Greene and Jackson stay at six
  and Old Jail at eight.[^report]
- Four Corydon records now count once as Prairie Trails Museum; five Ironwood
  depot/society/building rows count once. The Kentucky IMLS row with a Monticello address
  but the Michael J Quill legal name and EIN is isolated, and the accepted Kentucky
  institution does not inherit its aliases.[^report]
- Stratford's museum and uncertain historical-society record are explicitly split; different
  legal identities are not merged merely because a geocoder placed them together.[^report]
- Enterprise's research library/shop is excluded as `not_museum` on affirmative operator
  evidence that distinguishes it from Pea River Museum. Sourced common operators are recorded
  for Fairfield, Honesdale, Wakefield, Lake County Minnesota and Arkansas State Parks;
  separate museums remain separate.[^report]
- Validation: all 322 unit assertions and 19 integrity checks pass; the 60,002-row automatic
  baseline, baseline multisite queue and 0.85 threshold are unchanged; all 553 protected
  earlier evidence and label files are byte-identical. The leading-name publication gate
  fails as expected; the reviewed Pea River name passes the recorded-status gate.[^report]
- The local museum draft and explorer were refreshed to this checkpoint: the isolated render,
  serialized payload checks and nineteen JS assertions pass. No actual CSV filesystem save
  or public deployment is claimed.[^artifact-qa]

# Open actions

Eleven entries remain pending in
[`follow_up.csv`](../../../data/validation/museum_next_leaders_2026-09-26/follow_up.csv):
affiliation or current governance in Piedmont, Corydon, Ironwood, Oroville and Stratford;
Kentucky visitor address/point reconciliation; two generic Wakefield records; the uncertain
Stratford society role; Arcadia governance/access; and Tennessee society identity. Four
cache failures remain explicit; operator/site failures are evidence-access blockers, not
evidence of closure. The new leading groups have nine provisional candidates and remain
unreviewed.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_next_leaders_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_next_leaders_2026-09-26/):
  [candidate dispositions](../../../data/validation/museum_next_leaders_2026-09-26/candidate_dispositions.csv),
  [ranking after](../../../data/validation/museum_next_leaders_2026-09-26/ranking_after.csv),
  [Enterprise browser evidence](../../../data/validation/museum_next_leaders_2026-09-26/enterprise_browser_evidence.md),
  [research notes](../../../data/validation/museum_next_leaders_2026-09-26/research_notes.md),
  [integrity checks](../../../data/validation/museum_next_leaders_2026-09-26/integrity_checks.csv),
  [artifact QA](../../../data/validation/museum_next_leaders_2026-09-26/artifact_QA.md)
- `build_validate.R` holds the selective rebuild and checks.[^report]
- One-time scripts (`prepare.R`, `apply_wayne.R`, `apply_depot.R`) are frozen; never rerun
  them.

[^report]: Museum Depot and Wayne County checkpoint report
[^artifact-qa]: Artifact refresh QA, 2026-09-26 (Depot/Wayne)
