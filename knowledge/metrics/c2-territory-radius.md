---
type: Metric
title: "C2: territory radius"
description: "Distribution of nearest-neighbour great-circle distances between same-name congregations, per name_core class and denomination."
tags: [metrics, churches, c2, post-2]
sequence: 5
questions: [C2]
implemented_in: [../../R/metrics.R, ../../R/church_metrics.R, ../../R/church_analysis.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

**Territory radius** — for each `name_core` class, the distribution of nearest-neighbor
great-circle distances between same-name congregations. Median and p10/p90 per
denomination. `sf::st_nearest_feature()` + `st_distance()` on s2 geometry; do not project
and measure Euclidean distance at national scale (see [distance correctness](../architecture/distance-correctness.md)).

# Implementation

Distances follow [distance correctness](../architecture/distance-correctness.md). At the [church checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md), distance summaries restrict both endpoints to the selected First cohort.
