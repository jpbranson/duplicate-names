---
type: Playbook
title: "Completing a museum review"
description: "Order of identity and naming decisions, the IMLS review fields, the publication check and the staged publication points."
tags: [museums, review, identity]
sequence: 2
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: readme
    resource: 7416eef:README.md
    title: "README.md Completing a museum review, as of commit 7416eef (moved here verbatim)"
---

Apply identity membership in `museum_identity_decisions.csv` before assigning naming,
category and affiliation decisions in `museum_decisions.csv`. The identity file must list
every member of each affected baseline cluster. Naming decisions address one resulting
entity through a source key and exact expected name; after a reconciliation, replace any
former-name hold with a decision appropriate to the current name and archive the old input.
The generated dossiers now retain IMLS EIN and separate physical/mailing addresses.
The old coalesced fields remain for compatibility; use the separate fields for identity
research. All identifiers and ZIP codes are read as text to preserve leading zeros.

| Review fields | Source and meaning |
|---|---|
| `imls_ein` | Original IMLS `EIN`; a research clue, not an automatic identity rule |
| `imls_physical_street/city/state/zip/zip5` | Original `PHSTREET`, `PHCITY`, `PHSTATE`, `PHZIP`, `PHZIP5`; missing fields stay missing |
| `imls_mailing_street/city/state/zip/zip5` | Original `ADSTREET`, `ADCITY`, `ADSTATE`, `ADZIP`, `ADZIP5` |
| `imls_physical_address`, `imls_mailing_address` | Readable addresses formatted per original row before repeated MIDs are combined |
| `imls_street`, `imls_city`, `imls_state` | Legacy per-field physical-to-mailing fallback; these can mix address types |

`source_records.csv` and `multisite_records.csv` include all these fields. The institution
sheet adds `imls_ein_2018`, `imls_physical_address_2018` and `imls_mailing_address_2018`,
with each value tied to its IMLS source ID. Repeated archive values are separated by ` | `;
they are alternatives for review, not evidence of multiple physical sites. Future archives
retain the expanded fields. Earlier dated packets remain unchanged.
This is 2018 source context, not verification of current identity or visitor access.

Before exporting chosen headlines, call
`dn_assert_museum_publication_ready(analysis, name_values)` with the current
`museum_analysis` table and the selected L2 names. This helper is **not called by the
pipeline automatically**. It checks recorded eligibility, review and affiliation statuses;
it cannot verify source evidence, the meaning of an M2 scope claim, visitor access or
map accuracy. Complete those checks as relevant to the post.

The generated `lon`, `lat` and `map_url` still describe selected source points.
The [staged location table](../../data/validation/museum_address_review_2026-09-15/publication_locations.csv)
has separate `publication_lon`/`publication_lat` and dated access wording for Mandeville,
Smedley and Peters Creek. The pipeline and Parquet exports still do not consume it; `dn_museum_publication_points()`
applies it, with 30-day access checks, only in the dated
[publication export](../evidence/museums/museum_publication_2026-09-26.md). Refresh access wording
before publication, preserving source coordinates and evidence. See the
[current queue](../../data/validation/museum_m2_leaders_2026-09-26/human_review.csv)
for the remaining source checks and the
[address queue](../../data/validation/museum_address_review_2026-09-15/follow_up.csv) for location details.
