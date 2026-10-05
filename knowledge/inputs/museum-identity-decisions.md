---
type: Decision Table
title: Museum identity decisions
description: Explicit, guarded source membership over the automatic entities baseline, applied in museum_records before museum analysis; 440 rows in 185 cases as of commit 7416eef.
resource: ../../data/validation/museum_identity_decisions.csv
tags: [museums, identity]
status: stable
implemented_in:
  - ../../_targets.R
  - ../../R/schema.R
  - ../../R/museums.R
  - ../../R/museum_identity.R
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: csv
    resource: ../../data/validation/museum_identity_decisions.csv
    title: Live museum identity decisions (museum_identity_decisions.csv)
  - id: code
    resource: ../../R/museum_identity.R
    title: Guarded identity corrections and audit (R/museum_identity.R)
  - id: identity-report
    resource: ../../data/validation/museum_identity_review_2026-09-15.md
    title: First museum identity reconciliation report
  - id: focused-report
    resource: ../../data/validation/museum_focused_review_2026-09-15.md
    title: Focused identity follow-up report
  - id: county-report
    resource: ../../data/validation/museum_county_leaders_2026-09-26.md
    title: County leaders checkpoint report
  - id: cass-report
    resource: ../../data/validation/museum_cass_chester_crawford_2026-09-26.md
    title: Cass, Chester and Crawford checkpoint report
  - id: m2-report
    resource: ../../data/validation/museum_m2_leaders_2026-09-26.md
    title: Leading M2 groups checkpoint report
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation evidence index at 7416eef, decision inputs and human labels
  - id: readme
    resource: 7416eef:README.md
    title: Project README at 7416eef, running and completing a museum review
  - id: agents
    resource: ../../AGENTS.md
    title: Repository guidelines for coding agents
---

# Purpose

This file lists explicit membership over the automatic `entities` baseline.[^index]
`museum_records` applies it before museum analysis; `entities` stays the unchanged automatic
baseline.[^agents] Each row records a sourced factual correction, not an independent
matching-validation label.[^code] The
[first identity pass](../evidence/museums/museum_identity_review_2026-09-15.md) introduced
it.[^identity-report] See [identity corrections](../methodology/identity-corrections.md) and
[decision 11](../decisions/11-auditable-identity-corrections.md).

# Schema

Read as text and checked against `dn_schema_museum_identity_decisions()`. Every column must be
non-blank.[^code]

| Column | Type | Description |
|---|---|---|
| `case_id` | text | Groups the rows of one correction |
| `source`, `source_id` | text | Source key of one baseline record; unique in the file |
| `expected_name` | text | Guard: must equal the record's `name_raw` |
| `expected_entity_id` | text | Guard: must equal the record's automatic baseline `entity_id` |
| `expected_coordinates` | text | Guard: `lon,lat` at seven decimals (`%.7f,%.7f`) |
| `role` | text | `canonical`, `reselected_canonical`, `split_canonical`, `same_site`, `former_site`, `mislocated`, `mailing_address` or `source_conflict` |
| `site_group` | text | Site label within the case; `unresolved_source` for conflicts |
| `evidence_url` | text | Source URL(s); must start with `https://` |
| `evidence_note` | text | What the evidence shows and its limits |
| `reviewed_by`, `reviewed_on` | text | Reviewer and `YYYY-MM-DD` date |

Role effects: `canonical` is the case's one counted record. `reselected_canonical` replaces the
automatic primary site and must be a `non_primary_site` record of a counted institution. Each
destination of a split has one `split_canonical` row. `same_site`, `former_site`,
`mailing_address` and `mislocated` rows stay uncounted with `reviewed_duplicate_record`,
`reviewed_former_site`, `reviewed_mailing_address` or `reviewed_mislocated_record`. A
`source_conflict` row gets its own holdout ID and `reviewed_source_conflict`.[^code]

# Rules

- A changed source name, entity or coordinate stops the build as a stale decision.[^code]
- Every member of each affected baseline cluster must be listed; a baseline entity can appear
  in only one case; names or proximity never expand a correction.[^code][^agents]
- Ordinary cases need exactly one counted canonical record. Former sites take their own site
  group; all other roles share the canonical's group.[^code]
- Splits need at least two site groups, each with exactly one counted `split_canonical`, and no
  former sites.[^code]
- Source conflicts stay auditable and uncounted, and contribute no disputed aliases to
  accepted institutions.[^agents]
- One canonical record counts per reviewed institution; supporting rows keep reviewed
  exclusion reasons. Repeated naming templates alone do not establish common ownership.[^agents]
- Apply identity membership before decisions in `museum_decisions.csv`.[^readme]

# Current contents

As of commit 7416eef: 440 rows (244 Overture, 196 IMLS) in 185 cases, covering 395 baseline
entity IDs. Roles: canonical 161, same_site 95, mailing_address 64, mislocated 53,
source_conflict 35 (in 33 cases), former_site 22, split_canonical 9 (in 4 cases),
reselected_canonical 1. Review dates: 2026-09-15 (56), 2026-09-17 (13), 2026-09-23 (21),
2026-09-26 (350).[^csv] This matches the
[M2 checkpoint](../evidence/museums/museum_m2_leaders_2026-09-26.md): 440 rows in 185 cases and
35 isolated source conflicts.[^m2-report]

The [focused follow-up](../evidence/museums/museum_focused_review_2026-09-15.md) isolated the
first source conflicts.[^focused-report]
[County leaders](../evidence/museums/museum_county_leaders_2026-09-26.md) added
`split_canonical` for Independence, Missouri.[^county-report]
[Cass, Chester and Crawford](../evidence/museums/museum_cass_chester_crawford_2026-09-26.md)
added `reselected_canonical`.[^cass-report]

# Consumers

- `_targets.R`: `museum_identity_decisions_file` → `museum_identity_decisions` →
  `museum_identity_review` (`dn_reconcile_museums()`) → `museum_records` →
  `museum_records_file` and `museum_analysis`.
- `museum_identity_audit_file` writes `data/processed/museum_review/identity_audit.csv`.
  Building `museum_review_files` alone refreshes neither the audit nor the reviewed
  Parquet. `multisite_review` still describes the automatic baseline.[^agents]

# Preservation

- Preserve the prior file in a new dated packet before applying further decisions.[^index]
  Recent packets keep `museum_identity_decisions_before.csv` and a before/after audit.
- The archive helper does not archive or checksum identity decisions or the audit. Preserve
  them, with before/after records and evidence, following the latest packets.[^readme]
- Never rerun a dated packet's `prepare`/`apply` scripts.[^agents] See
  [preserve evidence](../playbooks/preserve-evidence.md).

[^csv]: Live museum identity decisions (museum_identity_decisions.csv)
[^code]: Guarded identity corrections and audit (R/museum_identity.R)
[^identity-report]: First museum identity reconciliation report
[^focused-report]: Focused identity follow-up report
[^county-report]: County leaders checkpoint report
[^cass-report]: Cass, Chester and Crawford checkpoint report
[^m2-report]: Leading M2 groups checkpoint report
[^index]: Validation evidence index at 7416eef, decision inputs and human labels
[^readme]: Project README at 7416eef, running and completing a museum review
[^agents]: Repository guidelines for coding agents
