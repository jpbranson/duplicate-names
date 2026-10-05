---
type: Method
title: "Structured extraction"
description: "Fields parsed from normalized names: ordinal, denomination, scope claim, subject and naming style, with implementation status."
tags: [normalization, ordinals, museums, churches]
sequence: 2
implemented_in: [../../R/normalize.R, ../../R/church_normalize.R, ../../R/museums.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §4.2, as of commit 7416eef (moved here verbatim)"
---

Extract fields from the appropriate normalization level, preserving the full name for
ordinal and scope-claim parsing and using the geography-stripped name for subject work:

- `ordinal` — First … Twentieth and beyond, numeric and word forms. Watch the trap:
  `First Christian Church` is an ordinal; `First Church of Christ, Scientist` is a
  denominational proper name and not the first of anything.
- `denomination` — from the name, reconciled against OSM `denomination`/`religion` tags and
  HIFLD/IRS classification. Tag-derived is preferred; name-derived is the fallback.
- `scope_claim` — `International | National | World | Global | Universal | American |
  Only | Original`. Drives the museum hubris ranking.
- `subject` — for museums, the topic noun phrase (Cryptozoology, Natural History, Fire,
  Quilts, Barbed Wire).
- `name_style` — the C4 taxonomy: `ordinal | saint | virtue | toponym | modern_brand |
  ethnolinguistic | descriptive | other`. Lexicon-classified first; then hand-label a
  stratified sample of ~500 to measure the classifier's error rate, and publish that rate.

**Implementation status:** ordinal and scope-claim parsing exist. The church pipeline parses
ordinals through 999, including compounds, and assigns heuristic `denom_norm` and
`name_style` values pending independent labels. The shared museum parser still returns
`NA` for compound ordinals. Museum
subjects use a bounded regex vocabulary on L3, with unmatched names left unknown and
multiple topics retained. This is a heuristic topic taxonomy, not complete noun-phrase
parsing. IMLS discipline provides a coarse compatibility diagnostic; GMU is not agreement,
and this comparison does not measure classifier accuracy. Subjects inherit L3's limits.
