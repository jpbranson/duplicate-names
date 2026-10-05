---
type: Decision
title: "Blog integration: defaulted, not blocked"
description: "Sensible defaults in R/config_blog.R let work proceed while the blog repo is reworked."
tags: [decisions, publication]
decision: 8
decided: 2026-09-07
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 8, as of commit 7416eef (moved here verbatim)"
---

**Blog integration — defaulted, not blocked.** The blog repo is mid-rework, so the [blog defaults](../architecture/blog-defaults.md)
fixes sensible defaults in `R/config_blog.R` and the project proceeds. The iframe
approach in [blog publishing](../architecture/blog-publishing.md) was chosen specifically to be robust to most of the unknowns.
