---
type: Decision Table
title: Museum decisions (naming, category, affiliation, review)
description: Per-institution naming and category (including sourced not_museum), affiliation and overall review decisions, keyed to a source record and its exact expected name after identity reconciliation.
resource: ../../data/validation/museum_decisions.csv
tags: [museums, affiliation, not-museum, category-names]
status: stable
implemented_in:
  - ../../_targets.R
  - ../../R/schema.R
  - ../../R/museums.R
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: csv
    resource: ../../data/validation/museum_decisions.csv
    title: Live museum decisions (museum_decisions.csv)
  - id: code
    resource: ../../R/museums.R
    title: Museum analysis, decisions and publication gate (R/museums.R)
  - id: analysis-report
    resource: ../../data/validation/museum_analysis_2026-09-15.md
    title: Initial Phase 2 museum analysis report
  - id: source-report
    resource: ../../data/validation/museum_source_review_2026-09-15.md
    title: First museum source pass report
  - id: methodology-report
    resource: ../../data/validation/museum_methodology_2026-09-23.md
    title: Chain separation and first not-a-museum decisions report
  - id: m2-report
    resource: ../../data/validation/museum_m2_leaders_2026-09-26.md
    title: Leading M2 groups checkpoint report
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation evidence index at 7416eef, decision inputs and human labels
  - id: readme
    resource: 7416eef:README.md
    title: Project README at 7416eef, completing a museum review
  - id: agents
    resource: ../../AGENTS.md
    title: Repository guidelines for coding agents
---

# Purpose

`museum_decisions.csv` records naming/category (including sourced `not_museum`), affiliation
and overall review decisions, keyed to source records and expected names after identity
reconciliation.[^index] For the entity a row addresses, it replaces the analysis defaults:
the category status, rule-derived or unknown affiliation, and pending review.[^code] The
[initial Phase 2 analysis](../evidence/museums/museum_analysis_2026-09-15.md) introduced the
file.[^analysis-report] The
[first source pass](../evidence/museums/museum_source_review_2026-09-15.md) applied 24
decisions, all still pending.[^source-report]

# Schema

Read as text and checked against `dn_schema_museum_decisions()`.[^code]

| Column | Type | Description |
|---|---|---|
| `source`, `source_id` | text | Source key of a record in `museum_records`; one decision per resulting entity |
| `expected_name` | text | Guard: must equal the record's `name_raw` |
| `category_decision` | text | `pending`, `confirmed_name`, `placeholder`, `historical_name`, `not_flagged` or `not_museum` |
| `affiliation_status` | text | `unknown`, `chain` or `independent` |
| `chain_id` | text | Required when `affiliation_status` is `chain`; otherwise ignored |
| `review_status` | text | `pending` or `verified` (complete factual review) |
| `evidence_url` | text | Required; must start with `https://`; becomes affiliation and review evidence |
| `note` | text | Becomes `review_note` |
| `reviewed_by`, `reviewed_on` | text | Reviewer and `YYYY-MM-DD` date; required |

Category effects in `museum_analysis`: a category-only name left `pending` or `not_flagged` is
excluded as `category_pending`; `confirmed_name` releases that hold. `placeholder` and
`historical_name` keep the institution counted but ineligible for L2 analysis. `not_museum`
sets `counted = FALSE` with `reviewed_not_museum`; its rows stay in
`museum_records`.[^code][^methodology-report]

# Rules

- A missing source key or changed `expected_name` stops the build as stale. Two decisions for
  one entity, invalid statuses, or missing evidence, reviewer or date also stop it.[^code]
- `verified` requires a resolved category and a known affiliation, except that `not_museum`
  may be verified with unknown affiliation.[^code][^methodology-report]
- `review_status = verified` means complete factual review. An assistant can verify official
  sources; this is not an independent human matching label.[^agents][^analysis-report]
- Unknown affiliation is `NA`, not independence. Repeated naming templates alone do not
  establish common ownership.[^agents]
- `not_museum` needs sourced evidence (society offices, archives or umbrella groups with no
  museum); never infer it from a failed search, a mailbox or an IRS revocation.[^agents]
- Use `placeholder` only with evidence.[^analysis-report] Keep `historical_name` holdouts and
  exclusions auditable.[^agents]
- Apply identity membership first. After a reconciliation, do not carry a historical-name hold
  onto the current name: archive the old decision and write a current-name
  decision.[^readme][^agents]

# Current contents

As of commit 7416eef: 407 rows (293 Overture, 114 IMLS).[^csv]

- Category: not_flagged 372, not_museum 25, confirmed_name 5, pending 4, historical_name 1.
- Affiliation: unknown 183, chain 117, independent 107.
- Review: verified 174, pending 233. All 25 `not_museum` rows are verified.
- The 117 chain rows use 49 `chain_id` values. The largest are `museum_of_illusions_global`
  (25), `commemorative_air_force` (10) and `smithsonian_institution` (5); `smithsonian` (3) is
  a separate ID, and the chain summary groups by exact `chain_id`.
- Review dates: 2026-09-15 (26), 2026-09-17 (4), 2026-09-23 (36), 2026-09-26 (341).

These match the [M2 checkpoint](../evidence/museums/museum_m2_leaders_2026-09-26.md): 174
complete factual reviews and 25 positive not-museum exclusions.[^m2-report] The
[methodology checkpoint](../evidence/museums/museum_methodology_2026-09-23.md) made the
first `not_museum` decisions.[^methodology-report]

# Consumers

- `_targets.R`: `museum_decisions_file` → `museum_decisions` → `museum_analysis`, then
  `dup_museums`, `museum_ranking`, `museum_singularity`, `museum_subjects`, `museum_chains`,
  `museum_chain_overlap` and `museum_review_files` (including `not_museum_review.csv`).
- `dn_assert_museum_publication_ready()` reads the resulting statuses from
  `museum_analysis`.[^code] See the [publication gate](../methodology/publication-gate.md) and
  [decision 13](../decisions/13-exclude-sourced-non-museums.md).
- `scripts/archive_museum_review.R` records its checksum.[^readme]

# Preservation

- Preserve the prior file in a new dated packet before applying further decisions.[^index]
  Recent packets keep `museum_decisions_before.csv`.
- Generated review files are overwritten; completed decisions belong in this file.[^agents]
  Follow [complete a museum review](../playbooks/complete-museum-review.md) and
  [preserve evidence](../playbooks/preserve-evidence.md).

[^csv]: Live museum decisions (museum_decisions.csv)
[^code]: Museum analysis, decisions and publication gate (R/museums.R)
[^analysis-report]: Initial Phase 2 museum analysis report
[^source-report]: First museum source pass report
[^methodology-report]: Chain separation and first not-a-museum decisions report
[^m2-report]: Leading M2 groups checkpoint report
[^index]: Validation evidence index at 7416eef, decision inputs and human labels
[^readme]: Project README at 7416eef, completing a museum review
[^agents]: Repository guidelines for coding agents
