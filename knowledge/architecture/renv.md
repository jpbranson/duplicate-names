---
type: Design Note
title: "renv setup gotchas"
description: "Explicit snapshots driven by DESCRIPTION, which must stay Type: Project with no Package: field."
tags: [architecture, setup]
sequence: 3
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §7 renv gotchas, as of commit 7416eef (moved here verbatim)"
---

**Two renv gotchas, both hit during Phase 0 and both now handled in `setup-renv.R`:**

- renv's default *implicit* snapshot records only packages referenced in code *today*, which
  silently dropped `sf`, `mapgl`, `stringdist` and `svglite` — every package a Phase 1 stub
  has committed to but not yet called. The project uses **explicit** snapshots driven by
  `DESCRIPTION` instead.
- That `DESCRIPTION` must declare **`Type: Project`** and must **not** carry a `Package:`
  field. With one, renv classifies the project as an R package and relocates the library
  from `renv/library` into the cache, orphaning everything already installed. Also note the
  default dependency fields are Imports/Depends/LinkingTo — `Suggests` is not scanned, so
  everything the project needs goes in `Imports`.
