---
type: Design Note
title: "Distance correctness"
description: "Use sf on s2 geometry for great-circle distances; never project to a national CRS and measure Euclidean distance."
tags: [architecture, churches, metrics]
sequence: 4
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §7 Distance correctness, as of commit 7416eef (moved here verbatim)"
---

**Distance correctness.** `sf` uses s2 geometry for geographic coordinates by default, so
`st_distance()` on lon/lat returns true great-circle distances — use `st_nearest_feature()`
plus `st_distance()` for the territory-radius metric. Do **not** project to a national CRS
(Albers, Web Mercator) and measure Euclidean distance; at the national scale that distorts
the exact quantity the [territory-radius metric](../metrics/c2-territory-radius.md) reports. If s2 proves too slow across ~250k points, the fallback is
`nngeo::st_nn` or a k-d tree on ECEF coordinates, not a projection shortcut.
