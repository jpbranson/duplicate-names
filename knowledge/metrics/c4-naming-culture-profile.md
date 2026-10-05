---
type: Metric
title: "C4: naming-culture profile"
description: "Distribution of name_style per denomination: ordinal, saint, virtue, toponym, modern brand and others."
tags: [metrics, churches, c4, post-2]
sequence: 9
questions: [C4]
implemented_in: [../../R/metrics.R, ../../R/church_normalize.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

**Naming-culture profile** — `name_style` distribution per denomination (C4). The
per-founding-decade cut is post 3's job.

# Implementation

`name_style` and `denom_norm` are heuristic pending independent labels (see [church independent labels](../inputs/church-independent-labels-v2.md)).
