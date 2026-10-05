---
type: Dataset
title: OpenStreetMap (internal validation only)
description: "OSM place-of-worship tags for eight metro areas, cached as an internal validation sample and kept out of released tables because of ODbL."
resource: https://overpass-api.de/api/interpreter
tags: [datasets, churches, licensing]
sequence: 7
license: ODbL (share-alike)
role: internal validation only
implemented_in: [../../R/src_osm.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md §3 and §7 licensing, as of commit 7416eef
  - id: manifest
    resource: ../../data/raw/MANIFEST.json
    title: Input provenance manifest (query osm_bounded_validation_regions)
---

# Role

OSM carries richer tags than Overture (`denomination`, `religion`, `start_date`,
`wikidata`, `operator`), but it is ODbL.[^design] It is cached for eight metro areas as an
internal validation sample only; the manifest records 5,234 rows, labelled internal only
and excluded from permissive outputs.[^manifest] Under [licensing](../architecture/licensing.md),
if OSM tags become load-bearing in released data, the release must be ODbL and attributed.

[^design]: DESIGN.md §3 and §7 licensing, as of commit 7416eef
[^manifest]: Input provenance manifest (query osm_bounded_validation_regions)
