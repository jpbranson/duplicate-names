---
type: Evidence Packet
title: Provisional leaders — Museum of Illusions and Washington County Historical Society
description: All 26 candidates of the two co-leading names reviewed; Washington County Historical Society falls from 13 to 7, Museum of Illusions from 13 to 12, and 13 institutions gain complete factual reviews.
resource: ../../../data/validation/museum_leaders_review_2026-09-23.md
tags: [museums, checkpoint, leaders, chains, not-museum]
status: deprecated
superseded_by: museum_methodology_2026-09-23.md
checkpoint: 2026-09-23
sequence: 10
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_leaders_review_2026-09-23.md
    title: Provisional leaders review report (Museum of Illusions, Washington County)
  - id: packet
    resource: ../../../data/validation/museum_leaders_review_2026-09-23/
    title: Leaders packet (dispositions, decisions, audit, IRS rows, scripts, follow-up)
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation and review evidence index
---

# Scope

Reviewed all **26 starting candidates** of the two co-leading L2 names (13 each). Both names
still fail the publication gate, and neither is a certified headline.[^report] Preceded by the
[Union County review](museum_union_county_review_2026-09-17.md). Superseded by the
[chain-separation and not-a-museum checkpoint](museum_methodology_2026-09-23.md); a later
checkpoint replaced its counts, but the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Source rows retained | 60,002 | 60,002 |
| Counted source rows | 57,305 | 57,293 |
| Counted institutions | 52,597 | 52,588 |
| Eligible for L2 name analysis | 52,465 | 52,456 |
| Museum of Illusions | 13 | 12 |
| Washington County Historical Society | 13 | 7 |
| Old Jail Museum | 12 | 12 |
| Institutions with complete factual review | 3 | 16 |

- Eight identity cases cover 19 source rows; the live input now holds 90 rows in 36 cases,
  including five isolated source conflicts. Four names tie at 12: Museum of Illusions, Old
  Jail Museum, Play Street Museum and Ripley's Believe It or Not; three are single-brand
  chains.[^report]
- **Methodology question.** The official Museum of Illusions directory lists 25 open US
  locations: eleven appear under the bare name in Overture and fourteen carry city suffixes,
  so L2 splits them into fourteen separate name groups. The exact-name count of 12
  undercounts the brand and measures how one chain labels its listings. This batch left the
  normalizer and ranking rules unchanged.[^report]
- Washington County corrections count Stevens Memorial Museum (Salem IN), Miller House Museum
  (Hagerstown MD), Port o' Plymouth Museum (Plymouth NC), Dewey Hotel Museum (Dewey OK) and
  Washington County Heritage Center (Stillwater MN) once each, and combine two Marietta OH
  records. Salem and Stillwater are verified independent. IMLS `8400500101` (Fayetteville AR)
  is isolated as a source conflict.[^report]
- All 11 affiliated Museum of Illusions locations are verified chain members: brand
  affiliation, not common ownership. Charlotte and Denver were temporarily closed, with
  reopening announced for late October and November 2026. Miami Beach remains pending.
  Hollywood counts once as World of Illusions Los Angeles, with Museum of Illusions as a
  same-site alias; venue affiliation is pending.[^report]
- Four Washington County records (New York, Utah, Ohio, Mississippi) appear not to describe a
  museum visitor site, but the decision schema had no sourced non-museum exclusion, so they
  remained counted and pending.[^report]
- Validation: 195 assertions and 25 integrity checks passed under R 4.4.2, including 168
  protected files; all 48 acquisition hashes match. Review sheets hold 493 institutions, 598
  source rows and 154 nearby pairs because the lower top-20 cutoff (8) admits more
  names.[^report]
- The publication gate rejects Museum of Illusions because Miami is pending, and Washington
  County Historical Society because all seven remaining institutions are pending. No headline
  was published.[^report]

# Open actions

The [follow-up queue](../../../data/validation/museum_leaders_review_2026-09-23/follow_up.csv)
puts four items first: the chain/city-suffix headline decision, Old Jail Museum's ten pending
reviews, Miami Beach's closure question and the non-museum schema gap. Later items cover
governance, name and access checks for Washington County museums and WonderWalk's
affiliation.[^packet] The next checkpoint took up the chain and not-a-museum
questions;[^index] see [decision 12](../../decisions/12-separate-chains-from-headline.md) and
[decision 13](../../decisions/13-exclude-sourced-non-museums.md).

# Files

- [Checkpoint report](../../../data/validation/museum_leaders_review_2026-09-23.md)
- [Packet directory](../../../data/validation/museum_leaders_review_2026-09-23/):
  [candidate dispositions](../../../data/validation/museum_leaders_review_2026-09-23/candidate_review.csv),
  [applied identity decisions](../../../data/validation/museum_leaders_review_2026-09-23/applied_identity_decisions.csv),
  [identity audit](../../../data/validation/museum_leaders_review_2026-09-23/identity_audit.csv),
  [reviewed institutions](../../../data/validation/museum_leaders_review_2026-09-23/reviewed_institutions_after.csv),
  [selected IRS rows](../../../data/validation/museum_leaders_review_2026-09-23/irs_selected.csv),
  [integrity checks](../../../data/validation/museum_leaders_review_2026-09-23/integrity_checks.csv)
- `prepare.R` and `apply_review.R` are one-time scripts; never rerun them. The acquisition,
  cache, build and finalize scripts also write into the packet; do not rerun them.[^packet]
- `validate.R` is the read-only replay. Its live comparisons now fail by design because later
  decisions and headline code changed the saved state; its archived replay remains
  valid.[^index]

[^report]: Provisional leaders review report (Museum of Illusions, Washington County)
[^packet]: Leaders packet (dispositions, decisions, audit, IRS rows, scripts, follow-up)
[^index]: Validation and review evidence index
