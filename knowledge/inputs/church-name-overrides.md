---
type: Decision Table
title: Church preferred public names
description: Guarded church public-name corrections applied to church_named_analysis; two 38th Avenue records, with no identity or matching-accuracy certification.
resource: ../../data/validation/church_name_overrides.csv
tags: [churches, names]
status: stable
implemented_in:
  - ../../_targets_churches.R
  - ../../R/church_names.R
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: csv
    resource: ../../data/validation/church_name_overrides.csv
    title: Live church name overrides (church_name_overrides.csv)
  - id: code
    resource: ../../R/church_names.R
    title: Source-guarded church public names (R/church_names.R)
  - id: targets
    resource: ../../_targets_churches.R
    title: Church pipeline definition (_targets_churches.R)
  - id: ordinal-report
    resource: ../../data/validation/church_ordinal_review_2026-09-26.md
    title: Church ordinal and scope checkpoint report
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation evidence index at 7416eef, church work and decision inputs
  - id: agents
    resource: ../../AGENTS.md
    title: Repository guidelines for coding agents
---

# Purpose

`church_name_overrides.csv` records sourced public-name corrections for church records. It does
not certify institutional identity or matching accuracy.[^index] The code changes analysis
labels only, never identity or raw fields.[^code] It feeds the separate church pipeline. The
validation index describes it with the
[church Phase 1 packet](../evidence/churches/church_phase1_2026-09-26.md), which holds the
initial copy.[^index]

# Schema

`_targets_churches.R` reads every column as text.[^targets] `dn_apply_church_names()` requires
these columns; it does not reject extra ones.[^code]

| Column | Type | Description |
|---|---|---|
| `source`, `source_id` | text | Source key of a record in `church_records`; unique in the file |
| `expected_name` | text | Guard: must equal the record's `name_raw` |
| `expected_coordinates` | text | Guard: `lon,lat` at seven decimals (`%.7f,%.7f`) |
| `preferred_name` | text | Public name; must be non-blank |
| `evidence_url` | text | Must start with `http://` or `https://` |
| `evidence_note` | text | What the evidence shows; content not checked by the code |
| `reviewed_by`, `reviewed_on` | text | Reviewer and `YYYY-MM-DD` date; content not checked by the code |

# Rules

- Missing columns, a duplicate source key, a missing source record, or a changed name or
  coordinate stop the build.[^code]
- The entity comes from the source record and must have exactly one analysis row. All rows for
  one entity must agree on one preferred name.[^code]
- The analysis row is renormalized from the preferred name: the name ladder, ordinal, scope
  claim, subject, name style and denomination fields. A denomination conflict sets
  `denom_norm` to missing. `source_primary_name` keeps the source name.[^code]
- Unlike the [scope decisions](church-scope-decisions.md), there is no entity guard column and
  no requirement to list every cluster member.[^code]
- Church counts come from `church_named_analysis`. Independent church matching labels are
  still blank; source research does not grade them.[^agents]

# Current contents

As of commit 7416eef: 2 Overture rows. Both expect "Thirty Eighth Baptist Church" and prefer
"38th Avenue Baptist Church", with evidence `https://38thavenuebaptist.org/contact-us`. Both
were reviewed by `assistant_official_source_review` on 2026-09-26. Each note says identity and
point review remain pending.[^csv]

The live file matches the Phase 1 packet's `church_name_overrides_initial.csv`. The
[ordinal checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md) and the scope
follow-up kept `church_name_overrides.csv.before` copies. The ordinal checkpoint reports zero
complete church factual reviews.[^ordinal-report]

# Consumers

- `_targets_churches.R`: `church_name_overrides_file` → `church_name_overrides` →
  `church_named_analysis`, built as `dn_apply_church_scope(dn_apply_church_names(...))`, then
  `church_output_files`.[^targets]
- `dashboard/build_data.R` reads `church_named_analysis` for the local explorer.
- Church work and the explorer are frozen until post 1 publishes.[^agents] See
  [post 2](../publications/post-2-churches.md) and the
  [independent church labels](church-independent-labels-v2.md).

# Preservation

- Preserve the prior file in a new dated packet before applying further decisions; dated
  copies describe their own checkpoint.[^index]
- Never rerun a dated packet's `prepare`/`apply` scripts after its checkpoint.[^agents] See
  [preserve evidence](../playbooks/preserve-evidence.md).

[^csv]: Live church name overrides (church_name_overrides.csv)
[^code]: Source-guarded church public names (R/church_names.R)
[^targets]: Church pipeline definition (_targets_churches.R)
[^ordinal-report]: Church ordinal and scope checkpoint report
[^index]: Validation evidence index at 7416eef, church work and decision inputs
[^agents]: Repository guidelines for coding agents
