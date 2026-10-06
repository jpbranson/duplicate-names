---
type: Open Questions
title: "Open analysis, resolution and publication questions"
description: "Unresolved methodological questions (matching, multi-site, categories, M2 semantics) and undecided publication details."
tags: [museums, matching, publication, questions]
sequence: 7
generated: { by: claude-code/claude-fable-5-1, at: 2026-10-06T03:45:00Z }
sources:
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: "HANDOFF.md §4, as of commit 7416eef (moved here verbatim)"
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 Still open, as of commit 7416eef (moved here verbatim)"
---

# Analysis and resolution

Numbered as in the original handoff; `tests/testthat/test-schema.R` cites "open question 1".[^handoff]

**1. Jaro-Winkler over-scores shared place prefixes.** `springfield museum` vs
`springfield society` scores ~0.90 on the shared prefix alone, above the merge threshold.
The realistic failure is `Springfield Art Museum` vs `Springfield Science Museum` at the
same address — genuinely different museums that the current measure may merge. This is
the most likely over-merge in the pipeline.

The labelled sample contains one false merge: `Trinidad History Museum` versus
`TRINIDAD HISTORICAL SOCIETY` (P0181, similarity 0.945). The sample supports keeping
0.85 overall; it does not establish that shared prefixes or museum/society substitutions
are always safe. The existing test documents the prefix risk.

**2. Cross-source merging may still be too weak.** The automatic baseline has 52,636 entities from
57,348 counted records, but no independently verified national total. The sample has eight
missed matches, but lowering the threshold to 0.80 produces 31 false merges for only two
additional true merges. Investigate aliases and abbreviations before lowering it.

**3. Category-only names remain reviewable holdouts.** `art gallery` (37) and
`planetarium` (14) are preserved in the unfiltered ranking. Cal Poly confirms that
University Art Gallery can be an actual name; UC San Diego documents it as a former name.
Neither fact supports blanket exclusion or blanket inclusion of all such records.

**4. 249 entities in the baseline multi-site review queue** (`targets::tar_read(multisite_review)`),
top spread 598 km. Each is either a relocation, a genuine multi-site institution, or two
unrelated museums wrongly merged. Names and coordinates alone cannot separate them.

**5. Incomplete for post 1:** subject extraction is deliberately partial, with unknowns
retained; discipline compatibility is not an accuracy score. Sourced brand rules replace
the operator shortcut, but most individual locations remain unverified. Museum of Illusions
now has 11 verified global-network locations; Hollywood counts with its WonderWalk venue,
and Miami Beach's affiliation and status remain unresolved. Brand affiliation does not establish common legal ownership.

**6. M2 is now L2, with unknowns reported separately.** Its candidates expose unresolved
duplicates and relocations beyond 150 m (for example the Texas Bankhead Drive record).
Lexical words such as American can also describe a subject rather than a singular claim.

The National Electronics case is now reconciled, including its Historical Electronics
alias. The museum's home page announces relocation to Middle River and dates Hunt Valley
tour closure to January 30, 2026; the older hours page still lists Hunt Valley. Retain
the institution, but do not describe it as open for visits during this transition.

# Publication details still open

- **Confirmed against the blog repository on 2026-10-05:** the content column is 700 px (the
  720 px default is kept), `static/` is served at root as usual, and the blog has no `renv`
  library. See [blog defaults](../architecture/blog-defaults.md).
- **Where the published dataset (D7) lives** — GitHub release, Zenodo DOI, or alongside the
  blog. Affects nothing technically, but decide it together with the [licensing](../architecture/licensing.md) question.

[^handoff]: HANDOFF.md §4, as of commit 7416eef
