---
type: Method
title: "Name normalization ladder (L0-L4)"
description: "Every record keeps five name levels; museum headlines use L2 name_expanded and church counts use L3 name_core."
tags: [normalization, museums, churches]
sequence: 1
implemented_in: [../../R/normalize.R, ../../R/gazetteer.R, ../../R/church_normalize.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §4 and §4.1, as of commit 7416eef (moved here verbatim)"
---

This is where the project succeeds or fails. Every headline number is an artifact of the
normalizer. It gets its own module, its own test suite, and a paragraph in each post.

Each record keeps *all* levels, so sensitivity can be reported rather than hidden:

- **L0 `name_raw`** — as given.
- **L1 `name_clean`** — Unicode NFKC, case-fold, remove diacritics, expand `&` to `and`,
  replace punctuation except apostrophes with spaces, collapse whitespace, drop leading `The`.
- **L2 `name_expanded`** — abbreviation expansion: `St.`→`Saint`, `Ft.`→`Fort`,
  `Mt.`→`Mount`, `AME`→`African Methodist Episcopal`, `UMC`→`United Methodist Church`,
  `1st`→`First`, `Assy`→`Assembly`. These examples show expansions; stored strings are lowercase.
- **L3 `name_core`** — strip the locative tail. This is the key operation:
  `First Baptist Church of Peoria` → `First Baptist Church`;
  `Peoria First Baptist Church` → `First Baptist Church`.
  Implemented by matching against a gazetteer of place names (Census places, counties,
  states) at both head and tail positions, with a blocklist protecting ambiguous names
  such as Springfield and Union.
- **L4 `name_key`** — L3 plus token sort and stopword removal, for fuzzy grouping.

**Museum name headlines (M1/M2) use L2 `name_expanded`.** Geography is often part of a
museum's identity; stripping it answers a different question. L3 `name_core` supports
geography-stripped comparisons and the implemented bounded M3 subject analysis. Church name counts
will use L3. Report the comparison levels explicitly rather than presenting L3/L4 museum
counts as interchangeable estimates of the L2 result. A headline that only survives at L4
is not a headline.

The current duplicate-count helper defaults to L2/L3/L4. L1 can be requested explicitly.
M1/M2 now count a single canonical L2 name per entity. The resolved-record table retains
all source rows; counting those rows or each alias separately inflated the old metrics.
