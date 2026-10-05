---
type: Metric
title: "M3: genericity split"
description: "Partition museum names into asserted-unique and descriptive and report the two distributions separately."
tags: [metrics, museums, m3]
sequence: 3
questions: [M3]
implemented_in: [../../R/museums.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

**Genericity split** — partition names into *asserted-unique* vs *descriptive* and report
the two distributions separately. Conflating them is the obvious analytical mistake and
the thing most likely to make post 1 wrong.

# Implementation

Subject extraction for the generic tail is built by the `museum_subjects` target (`metric_museum_subjects(museum_analysis)`); it is a bounded heuristic vocabulary on L3 (see [structured extraction](../methodology/structured-extraction.md)).
