---
type: Decision
title: "Museum name headlines use L2"
description: "M1/M2 use name_expanded; L3 is kept for geography-stripped comparisons and subject analysis."
tags: [decisions, museums, normalization, metrics]
decision: 9
decided: 2026-09-15
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 9, as of commit 7416eef (moved here verbatim)"
---

**Museum name headlines use L2.** Place names are usually part of museum identity.
Use `name_expanded` for M1/M2 and retain L3 for geography-stripped comparisons and
subject analysis. This corrects the original plan's blanket L3 default. M1 follows
this policy; Phase 2 corrected M2 and the source-row versus entity counting mismatch.
