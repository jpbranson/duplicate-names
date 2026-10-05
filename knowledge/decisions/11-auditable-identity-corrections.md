---
type: Decision
title: "Apply sourced identity corrections in a separate, auditable layer"
description: "entities stays the automatic baseline; explicit membership in museum_identity_decisions.csv produces museum_records."
tags: [decisions, identity, museums]
decision: 11
decided: 2026-09-15
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 11, as of commit 7416eef (moved here verbatim)"
---

**Apply sourced identity corrections in a separate, auditable layer (2026-09-15).**
Preserve `entities` as the automatic baseline and apply explicit membership through
`museum_identity_decisions.csv` to produce `museum_records`. Museum analysis uses
this corrected layer. Keep every source row, original name/coordinate and before/after
audit. Factual source review can be completed by an assistant; independent human
labels remain necessary to evaluate matching accuracy ([identity corrections](../methodology/identity-corrections.md)). Contradictory source
rows may be isolated as `source_conflict` holdouts, with stable separate IDs and
`reviewed_source_conflict` exclusions. They do not establish identity for either
institution suggested by their fields, and their disputed aliases must not propagate.
