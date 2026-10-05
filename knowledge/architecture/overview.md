---
type: Design Note
title: "Technical architecture overview"
description: "R end to end with targets, DuckDB, arrow and sf; repository layout; one-way flow to the blog repo; US-first scope."
tags: [architecture]
sequence: 1
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §7, as of commit 7416eef (moved here verbatim)"
---

**The blog is R blogdown (Hugo + R Markdown), so the project is R end to end.** This is the
right call regardless of convenience: analysis and publication share one language, ggplot2
figures knit directly into posts, and the existing R library already carries most of what's
needed. Python is not used.

**Use R 4.4, preferably the lockfile version 4.4.2.** Restore dependencies with
`renv::restore()` rather than relying on a machine's user library or newest R installation.
Use the selective museum build in [README.md](../../README.md#running) while reviewing.
A full `targets::tar_make()` can overwrite the working label sheet; archive new labels
first. Run `source("tests/testthat.R")` for tests; it sources this non-package project's
functions first.

The current layout is below (updated for the knowledge bundle on 2026-10-05). The standalone drafts are `posts/duplicate-museum-names/` and
`posts/duplicate-church-names/`, with earlier bundles in `posts/01-museums/` and
`posts/02-churches/`. All are unpublished.

```
duplicate-names/                # analysis repo; source of truth
  README.md                     # setup, builds, tests, layout
  AGENTS.md                     # rules for coding agents
  DESIGN.md, HANDOFF.md, LEADS.md, FLIGHT_LOG.md  # redirect stubs into knowledge/
  knowledge/                    # OKF knowledge bundle: status, decisions, methods, evidence index
  duplicate-names.Rproj
  renv.lock                     # pinned to R 4.4
  _targets.R                    # museum pipeline DAG
  _targets_churches.R           # church pipeline DAG (store: _targets_churches)
  R/
    src_*.R                     # adapters: overture, imls, churches (GNIS+HIFLD), church_overture, osm
    church_*.R                  # church normalization, resolution, names, scope, analysis, metrics
    museum_names.R              # preferred public names
    museum_publication.R        # publication gates and sourced publication points
    manifest.R                  # input provenance
    normalize.R                 # the name ladder, extraction, exceptions
    gazetteer.R                 # L3 place-name stripping and exceptions
    resolve.R                   # entity resolution and counting policy
    validate_resolution.R       # sample generation and human-label scoring
    metrics.R                   # one function per named metric
    museums.R                   # category/affiliation/subject analysis and review exports
    museum_identity.R           # explicit corrections over the automatic baseline
    museum_review_context.R     # IMLS names, EIN and separate physical/mailing addresses
    config_blog.R               # blog paths and presentation settings
    theme_dupnames.R            # shared ggplot2 theme + palette
    embed.R                     # builds self-contained widget HTML
  data/
    raw/                        # cached inputs; tracked museum-input manifest
    processed/                  # baseline/reviewed parquet, review exports and labelling sheet
    validation/                 # tracked labels, sourced decisions, evidence and reports
  scripts/archive_museum_review.R # review-sheet archive helper; see README limitations
  tests/testthat/               # normalization, schema, metrics and curated-review tests
  posts/
    _setup.R                    # shared plotting and payload helpers
    _template/index.Rmd         # skeleton for future post bundles
  embeds/                       # self-contained widget HTML → blog's static/embeds/
  dashboard/                    # Phase 4: local static duplicate-name explorer
```

**Two repos, one direction of flow.** This repo owns the pipeline and drafts the posts; the
blog repo receives a *payload* — `index.Rmd`, the small data files it reads, and prebuilt
embed HTML. The blog repo never needs `duckdb`, `sf`, or `arrow` to build the site, and its
`renv` library stays untouched. This is a publication requirement, not yet a verified
export path: the current template sources helpers through `DUPNAMES_ROOT`, and those
helpers must be packaged with the bundle. Use CSV payloads for a blog build without
`arrow`; the shared reader also supports Parquet, which would require it.

**Scope: US-first, global follow-up.** Analysis and both near-term posts are US-only, but
Phase 1 pays a small generality tax so a global pass is cheap later: no US-specific columns
in the core schema, country code on every entity, and the place-name gazetteer treated as a
pluggable source rather than "Census places" hardcoded. The two things that genuinely do
not generalize — the municipal-exclusivity denominator and denomination tagging density —
get isolated behind country-scoped modules so their absence degrades gracefully rather than
breaking the pipeline.

**Stack.** DuckDB (spatial + httpfs extensions) queries Overture's remote GeoParquet
with predicate pushdown. R handles normalization, resolution and metrics; `targets`
stores intermediate objects as RDS. `arrow` supplies source caches and the baseline/
reviewed Parquet exports. `sf` handles spatial operations; Voronoi territory polygons
(`st_voronoi`) remain planned church-analysis work. `tigris` supplies Census places,
`stringdist` fuzzy name matching, and `stringi` Unicode normalization ([normalization ladder](../methodology/normalization-ladder.md)).

**Pipeline orchestration.** `targets` for the DAG. The pipeline has a handful of expensive,
cacheable stages (Overture pull, normalization, entity resolution) and a long tail of cheap
downstream metrics, which is precisely the shape `targets` handles well — change a metric,
re-run seconds instead of an hour. If `targets` is unfamiliar territory, numbered scripts in
`R/` writing to `data/processed/` is an acceptable substitute; the cost is manual cache
discipline. `testthat` for the normalization gold-set tests.
