---
type: Dataset
title: Overture Maps Places
description: "Primary spine for both pipelines: Overture Places release 2026-08-19.0, queried in place with DuckDB for museums and places of worship."
resource: s3://overturemaps-us-west-2/release/2026-08-19.0/theme=places/type=place/*
tags: [datasets, museums, churches]
sequence: 2
license: CDLA-Permissive-2.0 / Apache-2.0
role: implemented
implemented_in: [../../R/src_overture.R, ../../R/src_church_overture.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md §3 data sources, as of commit 7416eef
  - id: manifest
    resource: ../../data/raw/MANIFEST.json
    title: Input provenance manifest (queries overture_museum and overture_worship)
  - id: code
    resource: ../../R/src_overture.R
    title: Overture adapter
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: HANDOFF.md §5 things that will bite you, as of commit 7416eef
---

# Role

The best single spine: queryable in place via DuckDB `httpfs` without a full download,
permissively licensed, with a consistent schema, confidence scores and source
lineage.[^design] Both pipelines pin release `2026-08-19.0`.[^code]

| Query (manifest label) | Use | Rows | Retrieved |
|---|---|---:|---|
| `overture_museum` | Museum pipeline input (category like `%museum%`, US) | 29,894 | 2026-09-07 |
| `overture_worship` | Church pipeline input | 545,776 | 2026-09-25 |

Rows and dates are as recorded in the manifest.[^manifest] Separate dated context queries
for museum identity research use the same release; their packets preserve them and
`tar_make()` does not recreate them.

# Caveats

- Overture's own `sources[].update_time` entries carry the release date; exclude
  `provider = 'overture'` to keep the freshness signal.[^handoff]
- `operating_status` does not catch stale records; the Portland Cryptozoology Museum is the
  documented example.[^handoff] See [pitfalls](../project/pitfalls.md).
- Records can be stale and sources can share upstream providers, so cross-source agreement
  is a research signal, not proof (see [entity resolution](../methodology/entity-resolution.md)).

[^design]: DESIGN.md §3 data sources, as of commit 7416eef
[^manifest]: Input provenance manifest (queries overture_museum and overture_worship)
[^code]: Overture adapter
[^handoff]: HANDOFF.md §5 things that will bite you, as of commit 7416eef
