---
type: Dataset
title: HIFLD All Places of Worship
description: "Independent third church source built from IRS 501(c)(3) master files, so it records legal names rather than signage names."
resource: https://services.arcgis.com/XG15cJAlne2vxtgt/arcgis/rest/services/All_Places_Of_Worship__HiFLD_Open_/FeatureServer/42
tags: [datasets, churches]
sequence: 5
license: Public domain
role: implemented
implemented_in: [../../R/src_churches.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md §3 data sources, as of commit 7416eef
  - id: manifest
    resource: ../../data/raw/MANIFEST.json
    title: Input provenance manifest (query hifld_fema_adapter)
---

# Role

254,740 US records in the July 2024 snapshot. Because it is IRS-derived, it captures legal
names rather than signage names, a useful contrast in its own right.[^design] The adapter
(`src_hifld()`) pages the FEMA-hosted feature service; the manifest records 254,740 rows,
retrieved 2026-09-25.[^manifest] See [known trap 1](../methodology/known-traps.md) on
signage versus legal names.

[^design]: DESIGN.md §3 data sources, as of commit 7416eef
[^manifest]: Input provenance manifest (query hifld_fema_adapter)
