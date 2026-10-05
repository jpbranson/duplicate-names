---
type: Decision Table
title: Post 1 headline review (decision 14)
description: Per-member evidence that a museum meets DESIGN decision 14's headline-sufficient standard, passed as headline_review to dn_assert_museum_publication_ready(); never changes review_status.
resource: ../../data/validation/post1_headline_review.csv
tags: [museums, post-1, publication]
status: stable
implemented_in:
  - ../../R/museums.R
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: csv
    resource: ../../data/validation/post1_headline_review.csv
    title: Post 1 headline review (post1_headline_review.csv)
  - id: code
    resource: ../../R/museums.R
    title: Publication gate and headline-sufficient check (R/museums.R)
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md at 7416eef, decision 14 and publication gate
  - id: flight-log
    resource: ../project/flight-log.md
    title: Flight log, 2026-09-26 rescope and gate-change entries
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation evidence index at 7416eef, decision inputs and human labels
  - id: agents
    resource: ../../AGENTS.md
    title: Repository guidelines for coding agents
---

# Purpose

This file holds post 1 evidence under
[decision 14](../decisions/14-post-1-headline-sufficient-review.md) for each named group's
members. `_targets.R` does not read it, and it does not change
`review_status`.[^index] For post 1, pass it as `headline_review` to
`dn_assert_museum_publication_ready()`.[^agents] Decision 14 puts the post's per-member evidence
in one flat CSV, not a new packet.[^design]

The standard: an institution counts toward a named headline group when source evidence shows
that it is (a) a distinct public museum, not a duplicate record, office, mailing address,
former site or support facility; (b) plausibly operating; and (c) not sharing a brand or
operator with another member of the group. Governance, campus scope, visitor access and exact
map points are outside it unless they change (a)–(c).[^design]

# Schema

The gate reads only the columns marked "gate"; the rest are context for reviewers.[^code]

| Column | Type | Description |
|---|---|---|
| `group` | text | Gate: the L2 name (`name_expanded`); must equal the member's current L2 name |
| `source`, `source_id` | text | Gate: source key of the member's row in `museum_analysis`; unique |
| `place`, `state` | text | Location of the member |
| `prior_review_status` | text | The member's recorded `review_status` (`verified` or `pending`) |
| `a_distinct_public_museum` | text | Gate: criterion (a); only `yes` passes |
| `b_plausibly_operating` | text | Gate: criterion (b); only `yes` passes |
| `c_no_shared_operator_in_group` | text | Gate: criterion (c); only `yes` passes |
| `operator` | text | Operator named by the evidence |
| `evidence_url` | text | Gate: must start with `https://` |
| `checked_on` | text (date) | Gate: `YYYY-MM-DD`; must parse and not be after `as_of` |
| `note` | text | Evidence summary and questions left outside decision 14 |

# Rules

- The gate checks the counted non-chain members of the named groups. A member passes with
  `review_status = verified` and known affiliation, or with a passing row here. Every member
  must also be analysis-eligible.[^code]
- Missing gate columns or a duplicate source key stop the check. `checked_on` must not be
  after `as_of`, but has no maximum age.[^code]
- The file never changes `review_status` or `affiliation_status`; `verified` still means a
  complete factual review.[^code][^design]
- The helper checks recorded statuses, not the evidence, visitor access, map points or M2
  scope-word meaning.[^agents] Map and access checks apply only to institutions the post
  maps.[^design]
- M1 stopping rule: resolve Old Jail Museum's pending members to this standard to get V. If
  V is 7 or more, Old Jail is the headline, after checking that no six-member group can reach
  V through pending renames or near-variant names. Select at most five surprising-collision
  groups and verify only those to this standard.[^design]

# Current contents

As of commit 7416eef: 8 rows, all group `old jail museum`, all Overture, all `yes` on (a), (b)
and (c).[^csv] Four were `verified` (Albion IN, Jim Thorpe PA, Lawrenceburg TN, Barnesville GA)
and four `pending` (Winchester TN, Hayesville NC, Greenwood AR, Thompson Falls MT). Checked on
2026-09-15 (2) and 2026-09-26 (6).[^csv]

The flight log records V = 8, above every other group (none at 7, 38 at 6). Old Jail passes
the gate with this file (4 verified plus 4 decision-14 members).[^flight-log] Re-running the
gate read-only against the saved `museum_analysis` target during this migration gave the same
result: pass with the file, fail without it. The five shortlisted surprising collisions are
not yet verified to decision 14 and have no rows.[^flight-log]

# Consumers

No target reads it. Pass it explicitly before exporting selected headline names:

```r
review <- readr::read_csv("data/validation/post1_headline_review.csv",
                          col_types = readr::cols(.default = "c"))
dn_assert_museum_publication_ready(targets::tar_read(museum_analysis),
                                   "old jail museum", headline_review = review)
```

`dn_headline_sufficient()` evaluates the rows. See the
[publication gate](../methodology/publication-gate.md) and
[post 1](../publications/post-1-museums.md).

# Preservation

Decision 14 keeps this evidence in one flat CSV rather than a new dated packet.[^design] Git
keeps files under `data/validation/` byte for byte, so earlier versions stay in history; the
file was first committed with the gate change (5b50ab3).[^flight-log] The general archive
helper neither copies nor checksums it. See
[preserve evidence](../playbooks/preserve-evidence.md).

[^csv]: Post 1 headline review (post1_headline_review.csv)
[^code]: Publication gate and headline-sufficient check (R/museums.R)
[^design]: DESIGN.md at 7416eef, decision 14 and publication gate
[^flight-log]: Flight log, 2026-09-26 rescope and gate-change entries
[^index]: Validation evidence index at 7416eef, decision inputs and human labels
[^agents]: Repository guidelines for coding agents
