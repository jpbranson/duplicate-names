# Museum post bundle — local, unpublished draft

Status: substantive M1/M2 factual review remains incomplete. `draft: true` is intentional.
Do not publish national winners or treat this bundle as a final museum census.
`payload/publication_blockers.csv` records the remaining work.

The source reads only `payload/`, `_setup.R`, and the bundled `R/` helpers. It does not
load targets, Arrow data, DuckDB, or the analysis checkout. The helper copies originate
in the central project settings/theme; regenerate them when those settings change.
R dependencies: knitr, rmarkdown, blogdown, ggplot2, dplyr, readr, svglite.
Use a local Pandoc installation, or the checksum-verified portable runtime recorded
in the publication packet. No paid cloud service is needed.

From this directory in R: `rmarkdown::render("index.Rmd")` for the Hugo fragment.
The validation script additionally builds a standalone HTML preview in an isolated
copy with no project profile or analysis-root environment variable.

This is a research draft and build artifact, not publication authorization evidence.
The blog destination is not configured. Final factual checks and explicit selected-name
publication gates must pass before changing draft status or exporting final headlines.
