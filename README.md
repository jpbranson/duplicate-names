# duplicate-names

Analysis pipeline behind a series of blog posts on duplicated institutional
names in the United States: museums that claim to be *the* one, and churches
that solved the same problem by numbering themselves.

Start with **[DESIGN.md](DESIGN.md)** — questions, data sources, metric
definitions, decisions, and the phase plan. **[HANDOFF.md](HANDOFF.md)** is the
fastest way to resume work: current state, the next task, and the traps. Analogous
namespaces worth a future post are tracked in **[LEADS.md](LEADS.md)**.

## Setup

R 4.4 with `renv`. From the project root:

```r
renv::restore()      # existing checkout
# or, first time on a new machine:
# Rscript setup-renv.R
```

Note the project pins **R 4.4**, not the newest R on the machine.

## Running

```r
targets::tar_make()          # run the pipeline
targets::tar_visnetwork()    # see the DAG
testthat::test_dir("tests/testthat")
```

The pipeline currently runs end to end on **empty** source stubs — Phase 0's
exit criterion. Every stage is shape-checked against `R/schema.R`, so the run
proves the wiring, not the findings.

## Layout

| Path | What |
|---|---|
| `_targets.R` | Pipeline DAG |
| `R/schema.R` | The contract between stages. Start here. |
| `R/src_*.R` | One module per data source (Phase 1 stubs) |
| `R/normalize.R` | The name ladder — decides every headline number |
| `R/resolve.R` | Cross-source entity resolution |
| `R/metrics.R` | Pre-registered metrics, one function each |
| `R/config_blog.R` | Every blog-dependent setting, in one place |
| `R/theme_dupnames.R` | ggplot2 theme, palette, scales |
| `R/embed.R` | Builds and deploys self-contained map embeds |
| `posts/` | Post drafts as Hugo page bundles |
| `data/raw/MANIFEST.json` | URL + SHA-256 + date for every download |

## Two things worth knowing before changing anything

**The normalizer decides the findings.** Duplicate counts are an artifact of
how aggressively names are collapsed, so `R/normalize.R` is tested first and
`tests/testthat/test-normalize.R` is a gold set, not a smoke test. Never edit an
expectation to make a test pass.

**`name_core` is currently a pass-through.** The L3 gazetteer step is Phase 1.
Until it lands, `First Baptist Church of Springfield` and `Springfield First
Baptist Church` are different keys, and any duplicate count is wrong.
`dn_normalize()` warns about this rather than letting it slip by quietly.

## Blog

Posts are drafted here and handed to a separate R blogdown repo as a payload:
`index.Rmd` plus the small aggregated files it reads. The blog repo never needs
`duckdb`, `sf`, or `arrow` to build. Set `DUPNAMES_BLOG_DIR` to point at it; all
other blog settings live in `R/config_blog.R` (see DESIGN.md §7.3).

## Data licensing

The publishable dataset is built from permissive and public-domain sources
(Overture, GNIS, IMLS, HIFLD). OpenStreetMap is ODbL and is used as an internal
enrichment and validation layer only — if OSM tags become load-bearing in a
published figure, the release has to be relicensed and attributed. See
DESIGN.md §7.
