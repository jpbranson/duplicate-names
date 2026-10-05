---
type: Dataset
title: Census 2023 TIGER/Line places, counties and states
description: "Census 2023 geography: the L3 place-name gazetteer for both pipelines and the C2 municipal denominator for churches."
resource: https://www2.census.gov/geo/tiger/TIGER2023/
tags: [datasets, churches, museums, normalization]
sequence: 6
license: Public domain
role: implemented
implemented_in: [../../R/gazetteer.R, ../../R/src_church_overture.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md §3 and §7 reproducibility, as of commit 7416eef
  - id: manifest
    resource: ../../data/raw/MANIFEST.json
    title: Input provenance manifest (queries census_places_2023 and census_states_2023)
---

# Role

- **Gazetteer.** Census 2023 places, counties and states supply the cached place-name
  gazetteer for L3 normalization (`dn_gazetteer()`). Those downloads are not yet in the
  manifest.[^design]
- **Church denominator.** The church pipeline adds full TIGER/Line 2023 places (incorporated
  places and census-designated places, 50 states and DC) and states; the manifest records
  32,037 places, retrieved 2026-09-25.[^manifest] They are the non-optional denominator for
  [municipal exclusivity](../metrics/c2-municipal-exclusivity.md).[^design]

[^design]: DESIGN.md §3 and §7 reproducibility, as of commit 7416eef
[^manifest]: Input provenance manifest (queries census_places_2023 and census_states_2023)
