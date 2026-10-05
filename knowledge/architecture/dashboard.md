---
type: Design Note
title: "Dashboard design (Phase 4)"
description: "The explorer generalizes the post-2 embeds: static first, alt_names exposed on the map, plain GeoJSON at this scale."
tags: [architecture, explorer]
sequence: 8
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §7.2, as of commit 7416eef (moved here verbatim)"
---

The dashboard is the *generalized* version of the post-2 embeds — same `mapgl` rendering
stack, arbitrary category instead of churches — which is the argument for building those
embeds with its eventual shape in mind from the start.

**Static vs. Shiny is a real decision, deferred to Phase 4.** A static `mapgl` page drops
into the blog's `static/` and needs no server, no cost, and no maintenance; filtering is
limited to what can be pushed into the client. Shiny (which `mapgl` supports directly) gives
real querying but needs hosting — shinyapps.io or Posit Connect — which is a different
operational commitment than a blogdown site. Static first is the recommendation; revisit
only if the interactions the posts suggest genuinely can't be done client-side.
**Update 2026-09-26:** a static, local-first explorer is built in `dashboard/`; it is
not deployed.

**Required of the map, not optional:** every entity that carries `alt_names` must expose
them — a footnote, a popup line, whatever fits — because the map is where the merge
decisions become visible. A reader looking at one pin labelled "Washington County
Historical Museum" is entitled to know that the historical society at the same address was
folded into it ([decision 7](../decisions/07-physical-institution-unit.md)).

At our scale — tens of thousands of points, not millions — plain GeoJSON is sufficient and
no tiling is required. Should PMTiles become necessary later, note that `tippecanoe` does
not build natively on Windows: that would mean WSL, and it is a reason to avoid needing
tiles at all.

**Pandoc** is not on `PATH` but ships with RStudio; if the pipeline ever renders outside
RStudio, check `rmarkdown::pandoc_available()` and set `RSTUDIO_PANDOC`.
