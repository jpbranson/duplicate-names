# Repository Guidelines

## Project Structure & Module Organization

This is an R analysis project, not an R package. Read `HANDOFF.md` for current work, `DESIGN.md` for methodology, and `README.md` for setup and the project overview. Phase 2 tooling and focused source/identity passes are complete; remaining headline checks precede the post.

- `_targets.R` defines the pipeline, currently focused on museums.
- `R/` contains source adapters (`src_*.R`), normalization, resolution, metrics, and publishing helpers. `R/schema.R` defines stage contracts.
- `tests/testthat/` holds normalization, schema, metric and museum-review/identity tests.
- `data/raw/` caches inputs; `data/processed/` holds derived outputs and the generated labelling sheet. Preserve completed human labels and reports in `data/validation/`; its [index](data/validation/README.md) distinguishes live inputs from dated evidence packets. Track input provenance in `data/raw/MANIFEST.json`.
- `posts/` holds Hugo page bundles and a template; `embeds/` holds generated maps. `dashboard/` is reserved for later work.

## Build, Test, and Development Commands

Use R 4.4, preferably lockfile version 4.4.2. Run from the repository root in R:

```r
renv::restore()                # Restore pinned dependencies
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file,
                            museum_records_file, dup_museums,
                            multisite_review, entities_file)) # Current review and exports
targets::tar_visnetwork()      # Inspect the dependency graph
source("tests/testthat.R")     # Source project functions and run tests
```

Cold pipeline runs download public datasets. A full `targets::tar_make()` builds all outdated targets. Before that or any rebuild of `labelling_sheet`, archive new completed labels outside `data/processed/`, because the target rewrites `data/processed/resolution_labelling.csv`. The authoritative completed sample is `data/validation/resolution_labelling_2026-09-15.csv`; score that archive with `dn_score_labels()` after sourcing `R/`. Building `museum_review_files` alone does not refresh the separate identity-audit or reviewed-Parquet export targets. See [README.md](README.md#running) for the archive helper's identity-artifact limitations.

## Coding Style & Naming Conventions

Follow existing R style: two-space indentation, `<-` assignment, native `|>` pipes, and snake_case names. Use `dn_*` for helpers, `src_*` for adapters, `metric_*` for metrics, and `DN_*` for constants. Validate stage outputs against `R/schema.R`. No repository formatter or linter configuration is present.

Keep `DESCRIPTION` as `Type: Project` without a `Package:` field. Centralize blog settings in `R/config_blog.R`; set the external blog path through `DUPNAMES_BLOG_DIR`.

## Testing & Analysis Integrity

Use testthat files named `test-<module>.R` with descriptive `test_that()` cases. Add regression cases for normalization, schema, or matching changes; avoid network downloads in unit tests. No numeric coverage threshold is configured.

Never change gold-set expectations merely to pass tests. Museum headline counts use L2 (`name_expanded`); L3 strips geography and answers a different question. Matching accuracy requires independent human labels; do not self-grade clustering decisions.

Retain the 0.85 matching threshold supported by the September 15 sample. Its unweighted pair-level precision and recall do not establish dataset-wide or final-cluster accuracy. Preserve the original labels and use fresh independent labels to evaluate changes suggested by the nine disagreements.

Phase 2 now has category-only holdouts, sourced affiliation rules, subject extraction, L2 M1/M2 metrics and review queues. Use `museum_analysis` for one canonical name per entity; `entities` retains multiple source records. Unknown affiliation is `NA`, not independence. Preserve completed review decisions in `data/validation/museum_decisions.csv`; generated review files are overwritten. Repeated naming templates alone do not establish common ownership. Keep uncertain and excluded records auditable, including `historical_name` holdouts. An assistant can verify official sources and apply supported factual decisions. Complete identity/count checks before publishing headlines; independent human labels are required for matching-accuracy evaluation, not as blanket approval for source research. `review_status = verified` means complete factual review. See the [first identity report](data/validation/museum_identity_review_2026-09-15.md) for the correction layer and the latest source review below for its current checkpoint.

`entities` is the unchanged automatic baseline. `museum_records` applies the explicit
membership in `data/validation/museum_identity_decisions.csv` before museum analysis.
Every affected baseline-cluster member must be listed; name, entity and coordinate
guards reject stale decisions. One canonical record counts per reviewed institution;
supporting rows remain with reviewed exclusion reasons. Keep `source_conflict`
holdouts auditable: contradictory rows have separate uncounted IDs
and must not contribute disputed aliases to accepted institutions. The
[provisional leaders review](data/validation/museum_leaders_review_2026-09-23.md) is the latest
count checkpoint: 90 identity rows in 36 cases, including five isolated source conflicts.
Sixteen institutions have complete factual reviews, including all 11 Museum of Illusions
network locations. Washington County Historical Society falls to seven and Museum of
Illusions to 12; Union County's seven and Old Jail's ten pending cases are unchanged.
Three of the four names tied at 12 are single-brand chains, and 14 more Museum of Illusions
locations carry city-suffixed names. Resolve that headline methodology question with the
user before more chain reviews; then continue Old Jail and the latest follow-up queue.
The schema cannot yet exclude sourced non-museum society records; do not drop them ad hoc. Preserve Oregon's
mixed source context and unresolved museum/address/name cases without unsupported merges.
The earlier
[address follow-up](data/validation/museum_address_review_2026-09-15.md) reconciles Chipley
and the accepted Peters Creek pair; its mixed IMLS row stays isolated. That packet's
`publication_locations.csv` stages
separate operator coordinates and dated access wording for Mandeville, Smedley and
Peters Creek. The pipeline does not yet consume these overrides; generated `lon`, `lat`
and `map_url` still use source coordinates. Apply the sourced points separately during
publication export and recheck access. Preserve the source-level
`data/processed/museum_review/identity_audit.csv` in a tracked dated packet. The
`multisite_review` target still describes the automatic baseline. Do not carry a historical-name hold onto a reconciled current
name; preserve its old decision in the dated packet and write a current-name decision.

Generated IMLS review context retains EIN and separate `imls_physical_*` and
`imls_mailing_*` fields, including ZIP codes as text. Use those for identity/address
conflicts; the older `imls_street/city/state` fields still coalesce address types.
Institution summaries attach IMLS source IDs to EIN/address values; repeated archive
values are alternatives to inspect, not additional confirmed sites. Before exporting selected headline names, call
`dn_assert_museum_publication_ready()` explicitly; the pipeline does not invoke it.
The helper checks recorded statuses, not the evidence, visitor access, map points or
M2 scope-word meaning. These still require factual review.

## Commit & Pull Request Guidelines

Use concise, descriptive commit subjects, optionally prefixed by phase, such as `Phase 1a: implement museum sources`. Keep changes focused.

PRs should explain the problem, resulting behavior, validation performed, and effects on counts or methodology. Link relevant issues or design decisions; include rendered previews for visual changes. Update `HANDOFF.md` when the next task or project state changes.
