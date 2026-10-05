---
type: Metric
title: "C2: municipal exclusivity rate"
description: "Of Census places with at least one congregation of a denomination, the fraction holding exactly one First church of it."
tags: [metrics, churches, c2, post-2]
sequence: 6
questions: [C2]
implemented_in: [../../R/metrics.R, ../../R/church_analysis.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

**Municipal exclusivity rate** — the real C2 test. Of all Census places containing ≥1
congregation of denomination D, what fraction contain *exactly one* `First D Church`?
The hypothesis under test: "territory" is not a distance rule at all but a
*one-per-settlement* rule, and observed spacing is just settlement spacing wearing a
costume. This reframing is the most likely genuine finding in the churches post.

# Implementation

Census places supply the denominator (see [datasets](../datasets/census-tiger.md)).
