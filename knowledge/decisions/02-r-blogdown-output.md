---
type: Decision
title: "Output format: R blogdown"
description: "The project is R end to end; ggplot2 figures knit inline, mapgl maps are iframed and posts ship as Hugo page bundles."
tags: [decisions, publication, architecture]
decision: 2
decided: 2026-09-07
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 2, as of commit 7416eef (moved here verbatim)"
---

**Output format — R blogdown.** Project is R end to end, pinned to R 4.4. ggplot2
figures knit inline; `mapgl` maps built as self-contained HTML and iframed from
`static/embeds/`; posts shipped as Hugo page bundles. See [blog publishing](../architecture/blog-publishing.md).
