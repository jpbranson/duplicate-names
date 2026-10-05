---
type: Metric
title: "Municipal multiplicity list (post 4)"
description: "Places holding two or more First churches of a denomination, emitted as a named artifact for post 4."
tags: [metrics, churches, post-4]
sequence: 11
questions: [C2]
implemented_in: [../../R/church_analysis.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

Post 2 will produce a list of places holding two or
more `First D Church`es. That list is the raw material for post 4 ([known trap 4](../methodology/known-traps.md)), so post 2's
pipeline should emit it as a named artifact rather than an incidental intermediate.

# Implementation

Written by `dn_export_church_outputs()` as `municipal_multiplicity`; it feeds post 4 per [decision 4](../decisions/04-first-baptist-split-own-post.md).
