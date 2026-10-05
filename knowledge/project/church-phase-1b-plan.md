---
type: Plan
title: "Phase 1b church plan (original, 2026-09-23)"
description: "The original queued plan for church acquisition and resolution; implemented on 2026-09-26 in the separate church pipeline."
tags: [churches, planning, history]
sequence: 12
status: deprecated
checkpoint: 2026-09-23
superseded_by: ../evidence/churches/church_phase1_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: "HANDOFF.md §6, as of commit 7416eef (moved here verbatim)"
---

**Update 2026-09-26:** implemented. Church acquisition (Overture worship, GNIS 2021, HIFLD,
Census places/states) and resolution run in `_targets_churches.R`; `R/src_others.R` is now
only a pointer comment. OSM is an internal regional validation sample only. Church ordinals
parse through 999, including compounds (`R/church_normalize.R`); the shared museum parser
keeps the compound gap described below. The rest of this section is the original plan.

Queued, not cancelled ([decision 5](../decisions/05-museums-first-phasing.md)). The stubs are in `R/src_others.R` with
their notes intact, and `_targets.R` carries the wiring in a comment block at the bottom.
The schema is already church-shaped (`denomination`, `religion`, `ordinal`, `place_geoid`),
so 1b extends the pipeline rather than reopening it.

Still owed: GNIS 2021 Church archive, HIFLD, OSM (for the `denomination` tag C4 needs),
Overture religious categories, and the `tigris` Census-places denominator for C2.

**Do not assume the normalizer generalizes.** Matching validation covers museum source
data; church-specific blind spots remain possible. Re-run and extend the existing gold
set with church cases *added*.
Two known gaps that only matter for churches:

- Compound ordinals (`Twenty Third`) return `NA`. C3's headline is the *highest* observed
  ordinal and the highest ones are compound, so this biases that number downward. There is
  a test documenting the gap.
- L3 stripping is *right* for churches and wrong for museums — the opposite of the museum
  default above.
