---
type: Playbook
title: "Publishing a post"
description: "Export a post's payload, knit it in isolation, stage it in the blog repository, and publish only after the user's explicit go-ahead."
tags: [publication, post-1]
sequence: 5
generated: { by: claude-code/claude-fable-5-1, at: 2026-10-06T03:45:00Z }
sources:
  - id: flight-log
    resource: ../project/flight-log.md
    title: Flight log, 2026-10-06 post 1 entry
  - id: export
    resource: ../../scripts/export_post1_payload.R
    title: Post 1 payload export script
  - id: stage
    resource: ../../scripts/stage_post.R
    title: Post staging script
  - id: blog-readme
    resource: https://github.com/jpbranson/goodsite/blob/master/README.md
    title: Blog repository README (build and publishing workflow)
---

Run everything from the repository root with R 4.4.2
(`"C:\Program Files\R\R-4.4.2\bin\Rscript.exe"`). Pandoc is not on `PATH`; point
`RSTUDIO_PANDOC` at `data/processed/tools/pandoc/pandoc-3.11`.[^flight-log]

# 1. Record the evidence

For post 1, add one row per checked record to
[`post1_headline_review.csv`](../inputs/post1-headline-review.md). Record failures as well
as passes. Do not change `review_status`, decisions or counts for the post.

# 2. Export the payload

```sh
Rscript scripts/export_post1_payload.R
```

The script reads saved targets, calls `dn_assert_museum_publication_ready()` for the
headline and stops if it fails, then writes `posts/duplicate-museum-names/payload/`.[^export]
It builds no target.

# 3. Knit in isolation

Copy `index.Rmd`, `_setup.R`, `R/` and `payload/` to an empty directory and render there
with no project profile. The post must knit without the analysis checkout or a pipeline
run. Look at the rendered page and figure before going on.

# 4. Stage in the blog repository

```sh
DUPNAMES_BLOG_DIR=../goodsite RSTUDIO_PANDOC=<pandoc dir> Rscript scripts/stage_post.R museums
```

This copies the bundle to `content/post/<slug>/` in the blog repository and knits
`index.html` beside it with blogdown. It does not run Hugo, change `draft`, commit or
push.[^stage] To preview in the theme, build the blog into a scratch directory with the
Hugo version the live site uses (0.164.0 on 2026-10-05) and `--buildDrafts`. A build
without that flag must not contain a draft post.[^flight-log]

# 5. Publish, only with the user's go-ahead

Publishing puts the post on the public site under the user's name. An assistant does not
do it without an explicit instruction for that post.

1. Set `draft: false` and the intended date in `posts/<slug>/index.Rmd`, then stage again.
2. In the blog repository, commit the post folder (source, `index.html`, `figures/`,
   `payload/`) and push `master`. The blog README says to commit both source and rendered
   HTML; the live site rebuilds from the repository.[^blog-readme]
3. Open the live URL (`/<year>/<slug>/`) and check the page, the figure and one payload
   link.
4. Record the publication in the [publication concept](../publications/post-1-museums.md),
   the [status report](../project/status.md), the [mission board](../project/mission.md)
   and the [flight log](../project/flight-log.md).

[^flight-log]: Flight log, 2026-10-06 post 1 entry
[^export]: Post 1 payload export script
[^stage]: Post staging script
[^blog-readme]: Blog repository README (build and publishing workflow)
