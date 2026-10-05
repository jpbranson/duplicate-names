---
type: Decision
title: "Exclude sourced non-museums from the count"
description: "A not_museum decision needs positive operator evidence of what the record is; absence of evidence does not qualify."
tags: [decisions, not-museum, museums]
decision: 13
decided: 2026-09-23
approved_by: human:jpbranson
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 13, as of commit 7416eef (moved here verbatim)"
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: "HANDOFF.md §7 session log, 2026-09-23 entry (user decisions)"
---

**Exclude sourced non-museums from the count (2026-09-23).** A `not_museum` category
decision removes a record whose operator evidence shows no museum function, while
keeping its source rows auditable. It requires positive evidence of what the record
is; absence of evidence does not qualify.
