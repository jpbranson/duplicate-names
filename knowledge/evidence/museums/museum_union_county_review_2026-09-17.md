---
type: Evidence Packet
title: Union County Historical Society — candidate review
description: All 14 Union County Historical Society starting candidates reviewed; six corrections over 15 source rows cut the exact-name group to seven, giving 52,597 counted and 52,465 eligible.
resource: ../../../data/validation/museum_union_county_review_2026-09-17.md
tags: [museums, checkpoint, leaders, identity]
status: deprecated
superseded_by: museum_leaders_review_2026-09-23.md
checkpoint: 2026-09-17
sequence: 9
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_union_county_review_2026-09-17.md
    title: Union County Historical Society candidate review report
  - id: packet
    resource: ../../../data/validation/museum_union_county_review_2026-09-17/
    title: Union County packet (dispositions, decisions, audit, scripts, follow-up)
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation and review evidence index
---

# Scope

Reviewed all **14 starting candidates** for Union County Historical Society, with their
source dossiers and related museum records. It is a completed research batch, not headline
certification: every remaining institution in the name group is still pending.[^report]
Preceded by the [Old Jail review](museum_old_jail_review_2026-09-15.md). Superseded by the
[provisional leaders review](museum_leaders_review_2026-09-23.md); a later checkpoint replaced
its counts, but the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Source rows retained | 60,002 | 60,002 |
| Counted source rows | 57,313 | 57,305 |
| Counted institutions | 52,605 | 52,597 |
| Eligible for L2 name analysis | 52,473 | 52,465 |
| Union County Historical Society | 14 | 7 |
| Washington County Historical Society | 13 | 13 |
| Old Jail Museum | 12 | 12 |
| Institutions with complete factual review | 2 | 3 |

- The corrections list **15 source rows in six cases**, representing 14 baseline entities and
  six resulting institutions: Blairsville GA, Maynardville TN, Cobden IL, Lake Butler FL,
  Creston IA and Clayton NM. The live input now holds 71 rows in 28 cases: 26 canonical
  institutions and four existing isolated source conflicts.[^report]
- Selecting named museum representatives removes five society-name candidates and the Georgia
  consolidation removes two duplicates: seven fewer exact-name institutions and eight fewer
  across all names.[^report]
- Creston's Historical Village has a complete factual review; its independent local
  operation is supported by the operator's own governance description. This is not an
  independent human matching label or a field survey of the map point.[^report]
- Marysville OH, Lewisburg PA, Liberty IN, Union/La Grande OR and Monroe NC are retained with
  unresolved questions; neither a mailbox nor an unsuccessful search proves a museum or a
  closure.[^report]
- Museum of Illusions and Washington County Historical Society now share the highest
  provisional eligible count, 13; these are not certified counts of independent
  museums.[^report]
- Validation: 195 assertions and 23 integrity checks passed under R 4.4.2, including 125
  protected files; all 32 acquisition hashes match. Review sheets hold 435 institutions, 535
  source rows and 143 nearby pairs.[^report]
- The explicit publication gate rejects `union county historical society`: all seven remaining
  institutions have pending factual reviews and unknown affiliation. No headline was
  published.[^report]

# Open actions

The [follow-up queue](../../../data/validation/museum_union_county_review_2026-09-17/follow_up.csv)
puts the remaining top-20 groups, the Oregon identity conflict and Monroe NC's museum status
first, then name, governance and address work for the other Union County institutions,
Old Jail's ten pending reviews and the publication maps.[^packet] Count distinct resulting IDs
in the candidate ledger, not its rows.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_union_county_review_2026-09-17.md)
- [Packet directory](../../../data/validation/museum_union_county_review_2026-09-17/):
  [candidate dispositions](../../../data/validation/museum_union_county_review_2026-09-17/candidate_review.csv),
  [applied identity decisions](../../../data/validation/museum_union_county_review_2026-09-17/applied_identity_decisions.csv),
  [identity audit](../../../data/validation/museum_union_county_review_2026-09-17/identity_audit.csv),
  [IMLS dossier](../../../data/validation/museum_union_county_review_2026-09-17/imls_context.csv),
  [integrity checks](../../../data/validation/museum_union_county_review_2026-09-17/integrity_checks.csv),
  [validation log](../../../data/validation/museum_union_county_review_2026-09-17/validation.log)
- `prepare.R` and `apply_review.R` are one-time scripts; never rerun them. The acquisition,
  cache, build and finalize scripts also write into the packet; do not rerun them.[^packet]
- `validate.R` is the read-only replay. Its live comparisons now fail by design because later
  decisions and headline code changed the saved state; its archived replay remains
  valid.[^index]

[^report]: Union County Historical Society candidate review report
[^packet]: Union County packet (dispositions, decisions, audit, scripts, follow-up)
[^index]: Validation and review evidence index
