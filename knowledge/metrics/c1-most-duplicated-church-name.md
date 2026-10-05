---
type: Metric
title: "C1: most duplicated church name"
description: "Headline count of church records sharing one L3 name_core."
tags: [metrics, churches, c1, post-2]
sequence: 4
questions: [C1]
implemented_in: [../../R/metrics.R, ../../R/church_analysis.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

`dup_count(name_core)` — headline for C1.

# Implementation

Church counts come from `church_named_analysis` in `_targets_churches.R`; see the [church checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md).
