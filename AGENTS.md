# Repository Guidelines

## Project Structure & Module Organization

This is an R analysis project, not an R package. Read `HANDOFF.md` for current work, `DESIGN.md` for methodology, and `README.md` for setup and the project overview. Phase 1a's measured-validation milestone is complete; Phase 2 museum analysis is next.

- `_targets.R` defines the pipeline, currently focused on museums.
- `R/` contains source adapters (`src_*.R`), normalization, resolution, metrics, and publishing helpers. `R/schema.R` defines stage contracts.
- `tests/testthat/` holds normalization and schema tests.
- `data/raw/` caches inputs; `data/processed/` holds derived outputs and the generated labelling sheet. Preserve completed human labels and reports in tracked `data/validation/`. Track input provenance in `data/raw/MANIFEST.json`.
- `posts/` holds Hugo page bundles and a template; `embeds/` holds generated maps. `dashboard/` is reserved for later work.

## Build, Test, and Development Commands

Use R 4.4, preferably lockfile version 4.4.2. Run from the repository root in R:

```r
renv::restore()                # Restore pinned dependencies
targets::tar_make()            # Build outdated pipeline targets
targets::tar_visnetwork()      # Inspect the dependency graph
source("tests/testthat.R")     # Source project functions and run tests
```

Cold pipeline runs download public datasets. Before rebuilding `labelling_sheet`, archive any new completed labels outside `data/processed/`, because the target rewrites `data/processed/resolution_labelling.csv`. The authoritative completed sample is `data/validation/resolution_labelling_2026-09-15.csv`; score that archive with `dn_score_labels()` after sourcing `R/`.

## Coding Style & Naming Conventions

Follow existing R style: two-space indentation, `<-` assignment, native `|>` pipes, and snake_case names. Use `dn_*` for helpers, `src_*` for adapters, `metric_*` for metrics, and `DN_*` for constants. Validate stage outputs against `R/schema.R`. No repository formatter or linter configuration is present.

Keep `DESCRIPTION` as `Type: Project` without a `Package:` field. Centralize blog settings in `R/config_blog.R`; set the external blog path through `DUPNAMES_BLOG_DIR`.

## Testing & Analysis Integrity

Use testthat files named `test-<module>.R` with descriptive `test_that()` cases. Add regression cases for normalization, schema, or matching changes; avoid network downloads in unit tests. No numeric coverage threshold is configured.

Never change gold-set expectations merely to pass tests. Museum headline counts use L2 (`name_expanded`); L3 strips geography and answers a different question. Matching accuracy requires independent human labels; do not self-grade clustering decisions.

Retain the 0.85 matching threshold supported by the September 15 sample. Its unweighted pair-level precision and recall do not establish dataset-wide or final-cluster accuracy. Preserve the original labels and use fresh independent labels to evaluate changes suggested by the nine disagreements.

Phase 2 starts with category-only name handling, then franchise detection, subject extraction, L2 alignment for M1/M2, and top-20 collision review including relevant multi-site cases. `metric_singularity_collisions()` still groups on L3 and needs correction. Repeated naming templates alone do not establish common ownership. Keep uncertain and excluded records auditable.

## Commit & Pull Request Guidelines

Use concise, descriptive commit subjects, optionally prefixed by phase, such as `Phase 1a: implement museum sources`. Keep changes focused.

PRs should explain the problem, resulting behavior, validation performed, and effects on counts or methodology. Link relevant issues or design decisions; include rendered previews for visual changes. Update `HANDOFF.md` when the next task or project state changes.
