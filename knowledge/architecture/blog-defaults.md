---
type: Design Note
title: "Blog defaults (adjustable)"
description: "Chosen defaults for the blog integration (paths, format, widths, devices, slugs) and the load-bearing palette rules."
tags: [architecture, publication]
sequence: 7
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §7.3, as of commit 7416eef (moved here verbatim)"
---

The blog repo is being reworked, so these are chosen defaults rather than measured facts.
Paths, widths, slugs and embed settings live in **`R/config_blog.R`**. Knitr's figure
device, aspect ratio and output-width defaults live in **`posts/_setup.R`**, which reads
that configuration. Adjust these shared settings when the blog repo settles.

| Knob | Default | Why, and what changes it |
|---|---|---|
| Blog repo path | `$DUPNAMES_BLOG_DIR`, else `../blog` | Set in `~/.Renviron` so it survives sessions |
| Post format | **`.Rmd`** | `.Rmarkdown` cannot carry HTML dependencies, so it forecloses inline widgets permanently. Maps are iframed either way, so `.Rmd` costs nothing today and keeps the option open — plus Pandoc footnotes and citations, which a source-heavy post wants. Switching later is a rename and a rebuild. |
| Post structure | Leaf page bundle: `content/post/<slug>/index.Rmd` | Data travels with the post and publishes as page resources, so readers can download the numbers behind a chart |
| Content width | **720 px → `fig.width = 7.5`** | Most Hugo themes land at 700–800; 720 divides cleanly by 96 dpi. Measure the real column once and change this one number. |
| Figure device | `svglite`, `fig.asp = 0.618`, `out.width = "100%"` | Shared knitr defaults in `posts/_setup.R`; override to `ragg_png` at `dpi = 192` for heavy point plots |
| Code visibility | `echo = FALSE` | General-audience blog; the code is public in this repo anyway |
| Embed location | `static/embeds/duplicate-names/` → `/embeds/duplicate-names/` | Namespaced so future projects can't collide |
| Embed height | 520 px, per-embed override | — |
| Slugs | `duplicate-museum-names`, `duplicate-church-names`, `church-naming-over-time`, `the-other-first-baptist` | Plain and searchable over clever. These become permanent URLs, so worth disliking now rather than after publication. |

**Palette and theme** are fixed in `R/theme_dupnames.R`, taken verbatim from a validated
reference palette rather than invented. Two things there are load-bearing and should not be
adjusted casually:

- **The slot order is the colourblind-safety mechanism**, not cosmetics. Reordering or
  inserting a ninth hue breaks the adjacent-pair guarantees.
- **Series caps differ by chart form.** Stacked/grouped bars and lines control which pairs
  touch, so all 8 slots are safe. Maps, scatter, and small multiples can put *any* pair side
  by side, and only the **first 3 slots** clear the floors. This bites post 2 directly: the
  denomination map cannot use one colour per denomination. Fold the tail into "Other" or
  facet. `dn_pal()` enforces the cap and errors rather than silently recycling.

The reference palette values remain unmodified. Swapping in different hues requires
running the palette validator in an environment with its dependencies; the original setup
did not have `node` available.

Supporting files now in place: `R/config_blog.R`, `R/theme_dupnames.R`, `R/embed.R`,
`posts/_setup.R` (shared knitr defaults), `posts/_template/index.Rmd` (post skeleton).
