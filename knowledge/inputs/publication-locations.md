---
type: Decision Table
title: Staged museum publication locations
description: Separate operator-sourced map points and dated access wording for Mandeville, Smedley and Peters Creek, applied only in the dated publication export; the pipeline and Parquet keep source coordinates.
resource: ../../data/validation/museum_address_review_2026-09-15/publication_locations.csv
tags: [museums, publication]
status: stable
stale_after: 2026-10-15T00:00:00Z
implemented_in:
  - ../../R/museum_publication.R
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: csv
    resource: ../../data/validation/museum_address_review_2026-09-15/publication_locations.csv
    title: Staged publication locations (publication_locations.csv)
  - id: code
    resource: ../../R/museum_publication.R
    title: Publication points and access checks (R/museum_publication.R)
  - id: address-report
    resource: ../../data/validation/museum_address_review_2026-09-15.md
    title: Museum address and map follow-up report
  - id: publication-report
    resource: ../../data/validation/museum_publication_2026-09-26.md
    title: Museum publication preparation report
  - id: export
    resource: ../../data/validation/museum_publication_2026-09-26/build_export.R
    title: Dated publication export script, 2026-09-26
  - id: access
    resource: ../../data/validation/museum_publication_2026-09-26/access_checks.csv
    title: Publication access checks, 2026-09-26
  - id: readme
    resource: 7416eef:README.md
    title: Project README at 7416eef, completing a museum review
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation evidence index at 7416eef, current outputs versus archives
  - id: agents
    resource: ../../AGENTS.md
    title: Repository guidelines for coding agents
---

# Purpose

This table stages separate operator coordinates and dated access wording for Mandeville,
Smedley and Peters Creek.[^agents] The
[address follow-up](../evidence/museums/museum_address_review_2026-09-15.md) created it; the
points are operator-supplied, not surveyed entrances or independent
geocoding.[^address-report] The pipeline and Parquet do not consume it, so generated `lon`,
`lat` and `map_url` still use source coordinates.[^readme] `dn_museum_publication_points()`
applies it, with 30-day access checks, only in the dated
[publication export](../evidence/museums/museum_publication_2026-09-26.md).[^readme]

# Schema

Columns marked "read" are required by `dn_museum_publication_points()`; the others are
context.[^code][^csv]

| Column | Type | Description |
|---|---|---|
| `case_id` | text | Case label, such as `Peters_Creek_Wright_House` |
| `source`, `source_id` | text | Read: source key in the analysis table; unique |
| `publication_lon`, `publication_lat` | number | Read: publication point; finite, within ±180 and ±90 |
| `evidence_url` | text | Read: point evidence; must start with `https://` |
| `point_basis` | text | Read: how the point was obtained; non-empty |
| `visitor_access_as_of_review` | text | Access wording as of `reviewed_on` |
| `reviewed_on` | text (date) | Read: point review date; not in the future, at most 30 days old by default |
| `status` | text | `staged_for_publication_export` in every row |
| `entity_id`, `name_raw` | text | Read: guards; must equal the analysis row's values |
| `lon`, `lat` | number | Read: source-point guard; must match within 1e-7 degrees |
| `source_offset_m` | number | Distance from the source point to the publication point, in metres |

# Rules

- The overlay never replaces source points, and no fallback to source coordinates is
  labelled as a checked visitor location.[^code]
- A changed entity, name or source point, a duplicate key, or a missing access check stops the
  export. So do invalid coordinates or evidence, or dates that are stale or in the
  future.[^code]
- Every point needs a row in a separate access table with `access_status` (`open`,
  `appointment_or_event`, `closed` or `unknown`), `access_text`, an `https://` evidence URL and
  `access_checked_on`, also at most 30 days old.[^code]
- `visitor_ready` requires a counted institution with `review_status = verified`, open or
  appointment/event access, and a publication point.[^code]
- Apply the sourced points separately during publication export and recheck access.[^agents]

# Current contents

As of commit 7416eef: 3 Overture rows, all `staged_for_publication_export`, all reviewed on
2026-09-15.[^csv]

| `case_id` | `name_raw` | `point_basis` |
|---|---|---|
| `Peters_Creek_Wright_House` | Enoch Wright House | operator-published GPS |
| `Smedley_Florida_alias` | Corporal Larry E Smedley National Vietnam War Museum | operator public map component address marker |
| `UCSD_gallery_rename` | Mandeville Art Gallery | official map link destination; carried from focused packet |

The Mandeville point comes from the
[focused follow-up](../evidence/museums/museum_focused_review_2026-09-15.md); its access
wording says the indoor gallery is listed closed from May 2 until further
notice.[^csv][^address-report]

**Freshness.** `stale_after` is 2026-10-15, the earliest `reviewed_on` (2026-09-15) plus 30
days. By default the function rejects points reviewed more than 30 days before its `as_of`
date, so an export after then needs a fresh point review.[^code] The 2026-09-26 export used
separate access checks dated 2026-09-26.[^access] Mandeville remained closed, Smedley listed
weekend access and Wright House listed events or arranged tours; pending identity reviews
still prevented visitor-ready status.[^publication-report]

# Consumers

- No target reads it. The dated
  [export script](../../data/validation/museum_publication_2026-09-26/build_export.R) read it
  with that packet's `access_checks.csv` and wrote `publication_points.csv`.[^export]
- See the [publication gate](../methodology/publication-gate.md) and
  [post 1](../publications/post-1-museums.md).

# Preservation

- The file sits inside a dated packet; keep dated packet CSVs unchanged.[^index] The
  2026-09-26 export recorded its new access checks in its own packet.[^export]
- Refresh access wording before publication, preserving source coordinates and
  evidence.[^readme] See [preserve evidence](../playbooks/preserve-evidence.md).

[^csv]: Staged publication locations (publication_locations.csv)
[^code]: Publication points and access checks (R/museum_publication.R)
[^address-report]: Museum address and map follow-up report
[^publication-report]: Museum publication preparation report
[^export]: Dated publication export script, 2026-09-26
[^access]: Publication access checks, 2026-09-26
[^readme]: Project README at 7416eef, completing a museum review
[^index]: Validation evidence index at 7416eef, current outputs versus archives
[^agents]: Repository guidelines for coding agents
