---
type: Metric
title: "C3: maximum ordinal"
description: "Highest ordinal observed, by denomination and by city, with the top handful verified by hand."
tags: [metrics, churches, c3, ordinals, post-2]
sequence: 8
questions: [C3]
implemented_in: [../../R/church_normalize.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5, as of commit 7416eef (definition moved here verbatim)"
---

# Definition

**Max ordinal** — highest N observed, by denomination and by city. Verify the top handful
by hand; the largest number in any dataset is usually a data error.

# Implementation

The [church checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md) documents the ten highest ordinals; no national maximum is certified. See also the [numbered-geography lead](../leads/numbered-geography-not-congregations.md).
