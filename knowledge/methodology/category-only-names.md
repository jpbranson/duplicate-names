---
type: Method
title: "Category-only names"
description: "Names such as art gallery or planetarium are held for review; sourced decisions confirm, exclude, hold as historical or mark not_museum."
tags: [category-names, not-museum, museums]
sequence: 6
implemented_in: [../../R/museums.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §4.5, as of commit 7416eef (moved here verbatim)"
---

The saved rankings include `art gallery`, `planetarium`, and `fine arts gallery`. These
may be POI category placeholders or actual institution names; names alone cannot settle
that distinction. An exact L2 vocabulary now flags category-only names. Pending cases
are held out of the provisional cleaned ranking, remain counted under the baseline
policy, and appear in the unfiltered ranking and review queue. A sourced `confirmed_name`
decision releases the hold; `placeholder` excludes only the name analysis. A sourced
`historical_name` decision preserves a documented former name while holding it out of
the current-name ranking. A sourced `not_museum` decision records that an entity is not
a museum (for example a society office, archive or umbrella group): `museum_analysis`
sets `counted = FALSE` with `reviewed_not_museum`, while `museum_records` keeps its rows.
Absence of evidence, a mailbox or an IRS revocation does not support it. These decisions
are keyed by source record with a stale-name guard. This is not blanket deletion or a
claim that every flagged name is wrong. Review ambiguous cases before any headline.
