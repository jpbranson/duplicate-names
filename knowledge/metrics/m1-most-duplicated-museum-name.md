---
type: Metric
title: "M1: most duplicated museum name"
description: "Headline count of counted, non-chain museum institutions sharing one canonical L2 name."
tags: [metrics, museums, m1, post-1]
sequence: 1
questions: [M1]
implemented_in: [../../R/metrics.R, ../../R/museums.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

`dup_count(name_expanded)` — headline for M1, using counted non-chain museum entities
and the implemented category-only review policy. Chains are reported separately.

# Implementation

Built by the `dup_museums` target (`metric_duplicate_counts(museum_analysis, category = "museum", exclude_chains = TRUE)`) and ranked by `dn_museum_ranking()`.

Level: L2 per [decision 9](../decisions/09-museum-headlines-use-l2.md); chains excluded per [decision 12](../decisions/12-separate-chains-from-headline.md); review standard and stopping rule for post 1 per [decision 14](../decisions/14-post-1-headline-sufficient-review.md). Certification limits are in the [publication gate](../methodology/publication-gate.md); the current result is in [post 1](../publications/post-1-museums.md).
