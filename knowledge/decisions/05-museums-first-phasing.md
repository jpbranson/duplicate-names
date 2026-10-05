---
type: Decision
title: "Phase 1 runs museums first, in two halves"
description: "Museums (1a) before churches (1b) to reach a publishable post sooner; churches deferred, not dropped, and implemented on 2026-09-26."
tags: [decisions, museums, churches, planning]
decision: 5
decided: 2026-09-07
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 5, as of commit 7416eef (moved here verbatim)"
---

**Phase 1 runs museums-first, in two halves (1a then 1b).** Post 1 uses Overture +
IMLS, with Wikidata enrichment still optional and unimplemented. Working on museums
reaches a publishable post sooner and exercises the normalizer and entity resolution
on a tractable population before facing ~250k congregations, where the same bugs would
be slower to find and costlier to fix.

**Churches are deferred, not dropped.** Phase 1b still owes: GNIS (the 2021 Church
archive), HIFLD, OSM (for the `denomination` tag C4 depends on), Overture's religious
categories, and the `tigris` Census-places denominator for C2. The source stubs for all
of these stay in `R/src_others.R` with their Phase 1 notes intact — nothing about the
churches work is being unwound, it is queued. The schema in `R/schema.R` is already
church-shaped (`denomination`, `religion`, `ordinal`, `place_geoid`), so 1b extends the
pipeline rather than reopening it.

**Update 2026-09-26:** Phase 1b is implemented in `_targets_churches.R`; see the
[church checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md).

The one thing to watch: matching validation covers museum source data, leaving
possible church-specific blind spots. Phase 1b must re-run the gold set with church cases added
rather than assuming L3 generalizes.
