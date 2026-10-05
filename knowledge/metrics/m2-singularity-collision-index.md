---
type: Metric
title: "M2: Singularity Collision Index"
description: "For names carrying a scope claim (International, National, World …), the count of independent institutions sharing the L2 name."
tags: [metrics, museums, m2, post-1]
sequence: 2
questions: [M2]
implemented_in: [../../R/metrics.R, ../../R/normalize.R, ../../R/museums.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

**Singularity Collision Index** — for names carrying a `scope_claim`, the count of
independent (non-franchise) institutions sharing `name_expanded`. The Cryptozoology seed case
scores whatever it scores; the *ranking* is the story.

# Implementation

Built by the `museum_singularity` target (`metric_singularity_collisions(museum_analysis)`); scope claims come from `dn_parse_scope_claim()` (see [structured extraction](../methodology/structured-extraction.md)). Unknown affiliation is reported separately from reviewed independence, and lexical scope words still need semantic review: see the [M2 checkpoint](../evidence/museums/museum_m2_leaders_2026-09-26.md) and [open questions](../project/open-questions.md).
