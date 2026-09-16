# duplicate-names

Analysis pipeline behind a series of blog posts on duplicated institutional
names in the United States: museums that claim to be *the* one, and churches
that solved the same problem by numbering themselves.

Start with **[DESIGN.md](DESIGN.md)** — questions, data sources, metric
definitions, decisions, and the phase plan. **[HANDOFF.md](HANDOFF.md)** is the
fastest way to resume work: current state, the next task, and the traps. Analogous
namespaces worth a future post are tracked in **[LEADS.md](LEADS.md)**.

## Setup

Use **R 4.4**, preferably the lockfile version **4.4.2**, with `renv`. From the
project root:

```r
renv::restore()      # restore the pinned dependencies
```

This is an R analysis project, not an R package. Keep `DESCRIPTION` as
`Type: Project` without a `Package:` field.

## Current status — 2026-09-15

**Phase 1a's museum acquisition and measured-validation milestone is complete;
Phase 2 museum analysis is next.** The pipeline uses Overture Places release
`2026-08-19.0` and the IMLS 2018 Museum Universe Data File. The saved September 7
run has **57,348 counted records representing 52,636 entities**. These counts
remain provisional pending the analysis and review below.

All **300 candidate pairs** have independent human labels. At the retained
**0.85** threshold, sample precision is **99.17%** and recall is **93.70%**
(119 true merges, 1 false merge, 8 missed merges, 172 true separations).
These are unweighted results from five equally sampled similarity bands within
150 m; they do not establish dataset-wide accuracy or validate final clusters.
See the [validation report](data/validation/resolution_validation_2026-09-15.md).

The next deliverable is a **cleaned museum collision ranking and a review sheet
identifying the institutions behind the top 20 names**:

1. Flag likely category-only placeholders with auditable review decisions.
2. Extend franchise detection while keeping repeated naming templates distinct
   from evidence of common ownership.
3. Implement museum subject extraction for M3.
4. Align M1/M2 with L2 (`name_expanded`); M2 still groups on L3 in the code.
5. Verify leading collisions and relevant multi-site cases before drafting headlines.

Church acquisition is queued for Phase 1b, after the museum post. The dashboard
comes after the first two posts. See [HANDOFF.md](HANDOFF.md) for the work queue.

## Running

```r
targets::tar_make()          # run the pipeline
targets::tar_visnetwork()    # see the DAG
source("tests/testthat.R")  # source project functions and run tests
```

The pipeline acquires museums, normalizes names with the gazetteer, resolves
entities, applies counting and franchise flags, and produces duplicate counts,
a multi-site review queue, and `data/processed/entities.parquet`. Stage outputs
are checked against `R/schema.R`. Cold runs download public datasets; cached
inputs and the targets store make subsequent runs faster.

**Preserve human labels before rebuilding `labelling_sheet`.** That target
rewrites `data/processed/resolution_labelling.csv`. The completed September 15
labels are archived in `data/validation/`, outside the generated directories.
Score that archive without rebuilding the pipeline:

```r
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
dn_score_labels("data/validation/resolution_labelling_2026-09-15.csv")
```

## Layout

| Path | What |
|---|---|
| `_targets.R` | Pipeline DAG |
| `R/schema.R` | The contract between stages. Start here. |
| `R/src_*.R` | Implemented Overture/IMLS adapters; queued source stubs in `src_others.R` |
| `R/normalize.R` | The name ladder — decides every headline number |
| `R/gazetteer.R` | Place names and exceptions for L3 geography stripping |
| `R/resolve.R` | Cross-source entity resolution |
| `R/validate_resolution.R` | Candidate-pair sampling and human-label scoring |
| `R/metrics.R` | Pre-registered metrics, one function each |
| `R/config_blog.R` | Every blog-dependent setting, in one place |
| `R/theme_dupnames.R` | ggplot2 theme, palette, scales |
| `R/embed.R` | Builds and deploys self-contained map embeds |
| `posts/` | Shared setup and a template for future Hugo page bundles |
| `data/raw/MANIFEST.json` | URL + SHA-256 + date for every download |
| `data/processed/` | Generated entities and labelling sheet; gitignored |
| `data/validation/` | Preserved human labels and their validation report; tracked |

## Two things worth knowing before changing anything

**The normalizer decides the findings.** Duplicate counts are an artifact of
how aggressively names are collapsed, so `R/normalize.R` is tested first and
`tests/testthat/test-normalize.R` is a gold set, not a smoke test. Never edit an
expectation to make a test pass.

**Museum name headlines use L2 (`name_expanded`).** The L3 gazetteer step is
implemented, but stripping geography often removes part of a museum's identity.
Use L3 (`name_core`) for geography-stripped comparisons and as input to the
planned subject analysis; churches will use L3 for their name counts. The
remaining M2 implementation mismatch is part of Phase 2, not a reason to change
the museum counting policy.

## Blog

Posts will be drafted here and handed to a separate R blogdown repo as a payload:
`index.Rmd` plus the small aggregated files it reads. The blog repo never needs
`duckdb`, `sf`, or `arrow` to build. Set `DUPNAMES_BLOG_DIR` to point at it; all
other blog settings live in `R/config_blog.R` (see DESIGN.md §7.3).
The current template still sources shared helpers from this analysis checkout;
packaging those helpers with the post and verifying an independent knit remain
part of Phase 2.

## Data licensing

The current museum pipeline uses Overture and IMLS. The planned church extension
adds GNIS and HIFLD, with OpenStreetMap reserved for internal enrichment and
validation under the project's licensing plan. Review licensing and attribution
before releasing tables or figures that depend on OSM contributions. See
DESIGN.md §7; the published dataset's destination is still undecided.
