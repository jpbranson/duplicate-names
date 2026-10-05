---
type: Metric
title: "C3: ladder completeness"
description: "For each place with a maximum ordinal N, the fraction of ordinals 1..N present."
tags: [metrics, churches, c3, ordinals, post-2]
sequence: 7
questions: [C3]
implemented_in: [../../R/metrics.R, ../../R/church_analysis.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

**Ladder completeness** — for each place with a max ordinal N, what fraction of 1..N are
present? Missing rungs are stories: mergers, closures, renames, splits.

# Implementation

Ordinals are parsed from the L3 core (see [structured extraction](../methodology/structured-extraction.md)); survivorship is [known trap 7](../methodology/known-traps.md).
