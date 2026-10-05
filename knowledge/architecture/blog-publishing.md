---
type: Design Note
title: "Publishing into blogdown"
description: "ggplot2 charts knitted in the post, maps as self-contained iframed widget HTML, and posts as Hugo page bundles that never knit the pipeline."
tags: [architecture, publication]
sequence: 6
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §7.1, as of commit 7416eef (moved here verbatim)"
---

**Charts: ggplot2 chunks, knitted in the post.** A shared `theme_dupnames()` keeps the two
posts visually consistent. The shared setup uses `dev = "svglite"` for SVG line/bar work;
switch to knitr's `dev = "ragg_png"` at `dpi = 192` for tens of thousands of overplotted points, where SVG file
size explodes.

**Maps: self-contained widget HTML, iframed — not inline widgets.** Build with
`htmlwidgets::saveWidget(map, "embeds/xxx.html", selfcontained = TRUE)`, ship to the blog's
`static/embeds/`, and reference as `<iframe src="/embeds/xxx.html">`.

This route is deliberate, because blogdown has a trap here. **`.Rmarkdown` files are
rendered to Markdown by Hugo and cannot carry HTML dependencies — htmlwidgets simply fail.**
Only `.Rmd` (Pandoc → HTML, `output: blogdown::html_page`) supports inline widgets. Rather
than forcing the file-format choice, the iframe route works with either, and buys three
other things: page weight stays down until the reader scrolls, the embed can't collide with
the Hugo theme's CSS, and **the same files become the Phase 4 dashboard** with no rework.

So the **territory maps live inside post 2**, which matters: the C2 result is a map result,
and sending a reader off to a separate dashboard to see the central finding would gut the
post.

Two constraints follow. Each embed must be genuinely standalone, since an iframe inherits
no CSS or JS from the host page. And each needs a deliberate static fallback for RSS
readers and iframe-blockers — build the still image as its own considered key view rather
than screenshotting at the end.

**Widget library: `mapgl`** (Kyle Walker; CRAN) for the point-density maps. It wraps
MapLibre GL JS, renders tens of thousands of points on WebGL where `leaflet` starts to
struggle, and supports PMTiles — which keeps the Phase 4 path open. `leaflet` is already
installed and fine for anything simple; `reactable` for the sortable duplicate-rank tables,
which is a better fit than a static table for "here are the top 200 collisions."

**Never knit the pipeline.** blogdown re-knits `.Rmd` on site rebuilds, so a post must never
trigger an Overture query. Post chunks read only small pre-aggregated files from
`payload/` and plot them. Ship each post as a **Hugo page bundle** —
`content/post/<slug>/index.Rmd` with its data files alongside — so knit-time paths resolve
relative to the post and the files publish as page resources, which conveniently also lets
readers download the data behind each chart.
