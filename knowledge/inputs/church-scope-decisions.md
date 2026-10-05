---
type: Decision Table
title: Church scope decisions
description: Guarded, sourced outside_christian_scope holds that remove listed church entities from Christian-only analysis without changing source religion, identity or review status.
resource: ../../data/validation/church_scope_decisions.csv
tags: [churches, scope]
status: stable
implemented_in:
  - ../../_targets_churches.R
  - ../../R/church_scope.R
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: csv
    resource: ../../data/validation/church_scope_decisions.csv
    title: Live church scope decisions (church_scope_decisions.csv)
  - id: code
    resource: ../../R/church_scope.R
    title: Narrow church scope corrections (R/church_scope.R)
  - id: targets
    resource: ../../_targets_churches.R
    title: Church pipeline definition (_targets_churches.R)
  - id: ordinal-report
    resource: ../../data/validation/church_ordinal_review_2026-09-26.md
    title: Church ordinal and scope checkpoint report
  - id: followup
    resource: ../../data/validation/church_scope_followup_2026-09-26/
    title: Church scope follow-up packet (proposal, not applied)
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation evidence index at 7416eef, church work and decision inputs
  - id: agents
    resource: ../../AGENTS.md
    title: Repository guidelines for coding agents
---

# Purpose

`church_scope_decisions.csv` holds guarded, sourced `outside_christian_scope` holds, with every
cluster member listed.[^index] A held entity leaves the eligible church analysis. Scope holds
do not change source religion, identity or review status.[^agents] A supported exclusion is
neither a complete identity review nor an accuracy label.[^code] The
[ordinal checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md) introduced the
two current holds.[^ordinal-report]

# Schema

`_targets_churches.R` reads every column as text.[^targets] Every column below is required and
must be non-blank.[^code]

| Column | Type | Description |
|---|---|---|
| `source`, `source_id` | text | Source key of a record in `church_records`; unique in the file |
| `expected_name` | text | Guard: must equal the record's `name_raw` |
| `expected_entity_id` | text | Guard: must equal the record's automatic `entity_id` |
| `expected_coordinates` | text | Guard: `lon,lat` at seven decimals (`%.7f,%.7f`) |
| `decision` | text | Only `outside_christian_scope` is accepted |
| `evidence_url` | text | Source URL(s); must start with `http://` or `https://` |
| `evidence_note` | text | What the evidence shows and what it does not change |
| `reviewed_by`, `reviewed_on` | text | Reviewer and `YYYY-MM-DD` date |

# Rules

- Missing columns or values, another decision value, non-URL evidence, a duplicate key, a
  missing source record, or a changed name, entity or coordinate stop the build.[^code]
- Every member of each listed entity must be in the file, and the entity must have exactly
  one analysis row.[^code]
- Effect: `analysis_eligible` becomes `FALSE`. A previously eligible row gets
  `analysis_exclusion = outside_christian_scope_source_review`; an earlier exclusion reason is
  kept. The evidence URLs go to `scope_review_evidence`.[^code]
- A similar name alone never justifies exclusion.[^agents] Additional records linked through
  the cached parent directory have not been broadly reclassified by name alone.[^ordinal-report]

# Current contents

As of commit 7416eef: 2 Overture rows for 2 entities, "Tenth Tabernacle Beth El" and
"Sixteenth Tabernacle Beth El - Alexandria, Va". Both were reviewed by
`assistant_official_source_review` on 2026-09-26.[^csv] The live file matches the ordinal
packet's `church_scope_decisions_applied.csv`.

The checkpoint describes Alexandria and Miami Church of God and Saints of Christ records whose
operator pages match the source addresses and phones; the parent describes its faith as
Judaism. It reports 540,778 canonical descriptions and 442,832 eligible after the two scope
holds.[^ordinal-report]

**Not applied:** the
[scope follow-up packet](../evidence/churches/church_scope_followup_2026-09-26.md) proposes
23 guarded scope decisions for linked records. Its read-only dry run passed, and eligible
would become 442,818. They await user approval; the live file still has two
rows.[^index][^followup] Church work is frozen until post 1 publishes.[^agents]

# Consumers

- `_targets_churches.R`: `church_scope_decisions_file` → `church_scope_decisions` →
  `church_named_analysis` (via `dn_apply_church_scope()`, after the
  [church name overrides](church-name-overrides.md)) → `church_output_files`.[^targets]
- Church counts come from `church_named_analysis`.[^agents] `dashboard/build_data.R` reads it
  for the local explorer. See [post 2](../publications/post-2-churches.md).

# Preservation

- Preserve the file with the other live decision inputs before future changes, in a new
  dated packet.[^index] The scope follow-up saved
  `church_scope_decisions.csv.before`.[^followup]
- Dated packet `prepare`/`apply` scripts are one-time; never rerun them after their
  checkpoint.[^agents] See [preserve evidence](../playbooks/preserve-evidence.md).

[^csv]: Live church scope decisions (church_scope_decisions.csv)
[^code]: Narrow church scope corrections (R/church_scope.R)
[^targets]: Church pipeline definition (_targets_churches.R)
[^ordinal-report]: Church ordinal and scope checkpoint report
[^followup]: Church scope follow-up packet (proposal, not applied)
[^index]: Validation evidence index at 7416eef, church work and decision inputs
[^agents]: Repository guidelines for coding agents
