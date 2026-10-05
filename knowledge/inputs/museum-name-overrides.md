---
type: Decision Table
title: Museum preferred public names
description: Guarded preferred public names for counted museum institutions, applied in museum_analysis only; original source names and the automatic baseline stay unchanged.
resource: ../../data/validation/museum_name_overrides.csv
tags: [museums, names, identity]
status: stable
implemented_in:
  - ../../_targets.R
  - ../../R/schema.R
  - ../../R/museums.R
  - ../../R/museum_names.R
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: csv
    resource: ../../data/validation/museum_name_overrides.csv
    title: Live museum preferred public names (museum_name_overrides.csv)
  - id: code
    resource: ../../R/museum_names.R
    title: Guarded preferred museum names (R/museum_names.R)
  - id: analysis
    resource: ../../R/museums.R
    title: Museum analysis and canonical-row selection (R/museums.R)
  - id: schema
    resource: ../../R/schema.R
    title: Stage contracts (R/schema.R)
  - id: jail-report
    resource: ../../data/validation/museum_jail_followup_2026-09-26.md
    title: Old Jail follow-up checkpoint report
  - id: m2-report
    resource: ../../data/validation/museum_m2_leaders_2026-09-26.md
    title: Leading M2 groups checkpoint report
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation evidence index at 7416eef, decision inputs and human labels
  - id: readme
    resource: 7416eef:README.md
    title: Project README at 7416eef, running and archive helper
---

# Purpose

`museum_name_overrides.csv` holds guarded preferred public names; original source names remain
unchanged.[^index] A preferred name is separate from immutable source names and
identity.[^schema] It changes analysis only, never source records or the automatic baseline,
and does not certify the rest of a review.[^code] The
[Old Jail follow-up](../evidence/museums/museum_jail_followup_2026-09-26.md) introduced it to
give Smethport its operator's public name, The County Museum in The Old Jail.[^jail-report]

# Schema

Read as text and checked against `dn_schema_museum_name_overrides()`. Every column must be
non-blank.[^code]

| Column | Type | Description |
|---|---|---|
| `source`, `source_id` | text | Source key of the institution's representative row in `museum_analysis` |
| `expected_name` | text | Guard: must equal that row's `name_raw` |
| `expected_entity_id` | text | Guard: must equal the reviewed institution's `entity_id` |
| `preferred_name` | text | Public name to use; trimmed; must yield a non-empty L2 name |
| `evidence_url` | text | Source URL(s); must start with `https://`; stored as `name_override_evidence` |
| `evidence_note` | text | What the evidence shows and what stays unchanged |
| `reviewed_by`, `reviewed_on` | text | Reviewer and `YYYY-MM-DD` date |

# Rules

- The source key must be the row `dn_canonical_entities()` chose for the institution, with
  matching name and entity, and it must be counted. Otherwise the build stops as a stale
  preferred-name decision.[^code][^analysis]
- At most one override per institution. A gazetteer is required for consistent L3
  normalization.[^code]
- The preferred name replaces `primary_name`. `name_clean`, `name_expanded`, `name_core`,
  `name_key`, `scope_claim` and `ordinal` are recomputed; the subject is then extracted from the
  new L3 core.[^code][^analysis]
- The previous primary name joins `alt_names`, and `source_primary_name` keeps the source
  name.[^code] Because `name_expanded` (L2) changes, an override can move an institution
  between headline name groups.
- The source name and coordinates stay unchanged.[^jail-report]

# Current contents

As of commit 7416eef: 105 rows for 105 distinct institutions (95 Overture, 10 IMLS). Every row
was reviewed by "Codex source review" on 2026-09-26.[^csv] This matches the
[M2 checkpoint's](../evidence/museums/museum_m2_leaders_2026-09-26.md) 105 preferred public
names, up from 103 before it.[^m2-report]

# Consumers

- `_targets.R`: `museum_name_overrides_file` → `museum_name_overrides` →
  `museum_analysis` (`dn_museum_analysis(..., museum_name_overrides, gazetteer)`, which calls
  `dn_apply_museum_name_overrides()`), then every museum metric and review export.
- `scripts/archive_museum_review.R` neither copies nor checksums this file.[^readme]
- Related: [museum decisions](museum-decisions.md) for naming holds,
  [normalization ladder](../methodology/normalization-ladder.md) and
  [decision 9](../decisions/09-museum-headlines-use-l2.md).

# Preservation

- Preserve the prior file in a new dated packet before applying further decisions.[^index]
  Recent packets keep `museum_name_overrides_before.csv`, for example the
  [M2 packet](../../data/validation/museum_m2_leaders_2026-09-26/museum_name_overrides_before.csv).
- Never edit archived copies. See [preserve evidence](../playbooks/preserve-evidence.md).

[^csv]: Live museum preferred public names (museum_name_overrides.csv)
[^code]: Guarded preferred museum names (R/museum_names.R)
[^analysis]: Museum analysis and canonical-row selection (R/museums.R)
[^schema]: Stage contracts (R/schema.R)
[^jail-report]: Old Jail follow-up checkpoint report
[^m2-report]: Leading M2 groups checkpoint report
[^index]: Validation evidence index at 7416eef, decision inputs and human labels
[^readme]: Project README at 7416eef, running and archive helper
