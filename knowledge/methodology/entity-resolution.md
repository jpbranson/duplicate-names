---
type: Method
title: "Entity resolution"
description: "Deduplicating source records into institutions: 150 m candidate radius, 0.85 similarity threshold and the September 15 validation."
tags: [matching, museums]
sequence: 3
implemented_in: [../../R/resolve.R, ../../R/validate_resolution.R, ../../R/church_resolve.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §4.3, as of commit 7416eef (moved here verbatim)"
---

A single institution appearing in several sources must not count as several duplicates.
The current Overture/IMLS automatic matcher uses normalized names and a 150 m site
candidate radius, followed by a separate name-based multi-site heuristic. Address and
website evidence supports curated corrections; automatic address matching is not
implemented. Cross-source agreement is a research signal, not proof of identity or
current operation: records can be stale and sources can share upstream providers.

**This is the single largest correctness risk in the project.** Budget real time for it.

**September 15 validation:** all 300 sampled pairs were independently human-labelled.
At the retained similarity threshold of **0.85**, there are 119 true merges, 1 false merge,
8 missed merges, and 172 true separations: precision **99.17%**, recall **93.70%**, and
sample error **3.00%**. The sample F1 sweep also selects 0.85.

These are unweighted results from 60 pairs per similarity band, all within 150 m. They
do not estimate dataset-wide error or validate final transitive clusters, multi-site
merging, or matches outside that radius. Threshold selection used the same sample rather
than a held-out set. Preserve the original labels in `data/validation/`; use the nine
disagreements diagnostically and fresh independent labels to evaluate matching changes.
The generated `labelling_sheet` target can overwrite the working sheet in `data/processed/`.
