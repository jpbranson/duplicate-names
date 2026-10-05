---
type: Decision
title: "Closed museums are excluded from counts but kept in the data"
description: "Exclusions are flags with a reason (counted / exclusion_reason), never deletions."
tags: [decisions, museums, counting]
decision: 6
decided: 2026-09-07
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 6, as of commit 7416eef (moved here verbatim)"
---

**Counting policy — closed museums are excluded from counts but kept in the data.**
Exclusions are flags with a reason (`counted` / `exclusion_reason`), never deletions, so
any of them can be audited or reversed by a reader of the published dataset.
