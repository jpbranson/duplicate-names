# duplicate-names

Analysis pipeline behind a series of blog posts on duplicated institutional
names in the United States: museums that claim to be *the* one, and churches
that solved the same problem by numbering themselves.

Everything the project knows lives in **[knowledge/](knowledge/index.md)**, an
[Open Knowledge Format](knowledge/conventions.md) v0.2 bundle: the
[current status](knowledge/project/status.md), questions, data sources, metric
definitions, [decisions](knowledge/decisions/index.md), the evidence index, the phase plan
and the [leads register](knowledge/leads/index.md). `DESIGN.md`, `HANDOFF.md`, `LEADS.md`
and `FLIGHT_LOG.md` are redirect stubs into it. This README covers setup, builds and layout.

## Setup

Use **R 4.4**, preferably the lockfile version **4.4.2**, with `renv`. From the
project root:

```r
renv::restore()      # restore the pinned dependencies
```

This is an R analysis project, not an R package. Keep `DESCRIPTION` as
`Type: Project` without a `Package:` field.

## Current status

The live status report is [knowledge/project/status.md](knowledge/project/status.md); the
[mission board](knowledge/project/mission.md) and [flight log](knowledge/project/flight-log.md)
record each checkpoint. The museum count history that used to live here is in
[count history](knowledge/project/count-history.md).

## Running

For the current museum review, build these targets without regenerating the human-label sheet:

```r
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
                            museum_records_file, dup_museums,
                            multisite_review, entities_file))
targets::tar_visnetwork()    # see the DAG
source("tests/testthat.R")  # source project functions and run tests
```

The pipeline acquires and normalizes museums, resolves the automatic baseline, applies
curated identity and naming/affiliation decisions, then computes metrics and review sheets.
`data/processed/entities.parquet` and `multisite_review` retain the automatic baseline;
`data/processed/museum_records.parquet` contains the reviewed source records.
`museum_identity_audit_file` writes `data/processed/museum_review/identity_audit.csv`.
The audit and reviewed Parquet are separate export targets, so building
`museum_review_files` alone does not refresh them. Stage outputs are checked against
`R/schema.R`. Cold runs download public datasets; cached inputs speed up later runs.

**Preserve human labels before a full `targets::tar_make()` or any rebuild of
`labelling_sheet`.** That target
rewrites `data/processed/resolution_labelling.csv`. The completed September 15
labels are archived in `data/validation/`, outside the generated directories.
Score that archive without rebuilding the pipeline:

```r
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
dn_score_labels("data/validation/resolution_labelling_2026-09-15.csv")
```

After the selective build above, run the archive helper from a terminal at the repository
root, supplying a new review date:

```sh
Rscript scripts/archive_museum_review.R YYYY-MM-DD
```

Use R 4.4.2's `Rscript`. On the current Windows machine the one on `PATH` is 4.3.2 and has
no renv library, so call `"C:\Program Files\R\R-4.4.2\bin\Rscript.exe"` explicitly.

It reads saved targets and archives the leading rankings (including cutoff ties),
review sheets and baseline multi-site queue into `data/validation/museum_review_YYYY-MM-DD/`.
It neither builds targets nor copies the entire generated export directory, and it refuses
an existing destination. Its checksums identify the manifest, chain rules, naming decisions
and archived labels; the helper does not copy those inputs. It does **not** archive
identity decisions or the identity audit, or include identity decisions in its checksums.
For an identity-correction checkpoint, also preserve those inputs, before/after records,
evidence and hashes, following the
[identity packet](data/validation/museum_identity_review_2026-09-15/) and
[focused packet](data/validation/museum_focused_review_2026-09-15/) or the latest
[M2 packet](data/validation/museum_m2_leaders_2026-09-26/). Existing dated
packets and completed human labels are historical evidence, not generated scratch files.

### Completing a museum review

The review guide (identity before naming decisions, IMLS review fields, the explicit
publication check and staged publication points) is in
[completing a museum review](knowledge/playbooks/complete-museum-review.md).

## Layout

| Path | What |
|---|---|
| `_targets.R` | Museum pipeline DAG |
| `_targets_churches.R` | Church pipeline DAG (store `_targets_churches`) |
| [`knowledge/`](knowledge/index.md) | OKF knowledge bundle: status, mission and flight log, decisions, methods, metrics, datasets, inputs, evidence index, leads |
| `R/knowledge.R` | OKF bundle checker and index generator (`dn_okf_check()`, `dn_okf_write_indexes()`) |
| `R/schema.R` | Stage contracts, validation and source binding. Start here. |
| `R/src_*.R` | Overture/IMLS museum adapters; church adapters in `src_churches.R` (GNIS, HIFLD) and `src_church_overture.R` (Overture worship, Census places/states); `src_osm.R` for internal validation only |
| `R/church_*.R` | Church normalization, resolution, names, scope holds, analysis and metrics |
| `R/normalize.R` | The name ladder — decides every headline number |
| `R/gazetteer.R` | Place names and exceptions for L3 geography stripping |
| `R/resolve.R` | Cross-source entity resolution |
| `R/validate_resolution.R` | Candidate-pair sampling and human-label scoring |
| `R/metrics.R` | Pre-registered metrics; M1/M2 use canonical entity names and L2 |
| `R/museums.R` | Category handling, affiliations, subjects, review queues and publication gate |
| `R/museum_review_context.R` | IMLS EIN, separate physical/mailing addresses and legacy context for review |
| `R/museum_identity.R` | Guarded source-specific corrections and before/after identity audit |
| `R/museum_names.R` | Guarded preferred public names |
| `R/museum_publication.R` | Publication gates and sourced publication points |
| `R/config_blog.R` | Every blog-dependent setting, in one place |
| `R/theme_dupnames.R` | ggplot2 theme, palette, scales |
| `R/embed.R` | Builds and deploys self-contained map embeds |
| `posts/` | Shared setup, template, unpublished drafts `duplicate-museum-names/` and `duplicate-church-names/`, and earlier bundles `01-museums/` and `02-churches/` |
| `dashboard/` | Local static duplicate-name explorer (unpublished) |
| `data/raw/MANIFEST.json` | Museum and church input/query provenance; the L3 Census gazetteer downloads are not yet manifest-tracked |
| `data/processed/` | Baseline/reviewed Parquet, review sheets, identity audit and labelling sheet; gitignored |
| [`data/validation/`](data/validation/README.md) | Human labels, sourced decisions, evidence packets and dated reports; described by [inputs](knowledge/inputs/index.md) and [evidence](knowledge/evidence/index.md) |
| `scripts/archive_museum_review.R` | General review-packet archive helper; identity artifacts need separate preservation |
| `scripts/export_post1_payload.R` | Post 1 payload export from saved targets; stops unless the headline passes the publication gate |
| `scripts/stage_post.R` | Copies a post bundle into the blog repository and knits it there; never publishes |
| `tests/testthat/data/raw/` | Immutable IMLS ZIP fixture and provenance; adapter caches are ignored |

## Two things worth knowing before changing anything

**The normalizer decides the findings.** Duplicate counts are an artifact of
how aggressively names are collapsed, so `R/normalize.R` is tested first and
`tests/testthat/test-normalize.R` is a gold set, not a smoke test. Never edit an
expectation to make a test pass.

**Museum name headlines use L2 (`name_expanded`).** The L3 gazetteer step is
implemented, but stripping geography often removes part of a museum's identity.
Use L3 (`name_core`) for geography-stripped comparisons and as input to the
subject analysis; churches use L3 for their name counts. M2's former L3
implementation mismatch has been corrected. The resolved-record table retains all
source rows; `museum_analysis` is the one-row-per-entity analysis table.

## Blog

Posts are drafted here and handed to a separate R blogdown repository as a page bundle:
`index.Rmd`, its bundled helpers and the small aggregated files it reads. The blog never
needs `duckdb`, `sf`, or `arrow` to build. Set `DUPNAMES_BLOG_DIR` to point at it; all
other blog settings live in `R/config_blog.R` (see [blog defaults](knowledge/architecture/blog-defaults.md)).
`scripts/export_post1_payload.R` writes post 1's payload from saved targets, and
`scripts/stage_post.R` copies a bundle into the blog and knits it there. Publishing is a
separate, deliberate step: see [publishing a post](knowledge/playbooks/publish-post.md).

## Data licensing

The museum pipeline uses Overture and IMLS. The separate church pipeline uses Overture
places of worship, the GNIS 2021 snapshot, HIFLD and Census TIGER places, with
OpenStreetMap reserved for internal validation under the project's licensing plan. Review licensing and attribution
before releasing tables or figures that depend on OSM contributions. See
[licensing](knowledge/architecture/licensing.md); the published dataset's destination is still undecided.




