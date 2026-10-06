# Museum post bundle

Post 1, "Who checks the museum names?", written to DESIGN decision 14
(`knowledge/decisions/14-post-1-headline-sufficient-review.md`). `draft: true` stays until
the author approves publication.

The source reads only `payload/`, `_setup.R` and the bundled `R/` helpers. It does not load
targets, Arrow data, DuckDB or the analysis checkout. The helper copies originate in the
central project settings and theme; regenerate them when those settings change.
R dependencies: knitr, rmarkdown, blogdown, ggplot2, dplyr, readr, svglite. Knitting needs
Pandoc; the project keeps a portable copy under `data/processed/tools/pandoc/`.

- `payload/` is written by `scripts/export_post1_payload.R` from saved targets and
  `data/validation/post1_headline_review.csv`. Do not edit it by hand.
- The setup chunk stops the knit if a re-export changes a result the prose names. Change
  the prose and that check together.
- `scripts/stage_post.R museums` copies the bundle into the blog repository and knits it
  there. It never publishes. See `knowledge/playbooks/publish-post.md`.

Every museum the post names was checked against a public source; the links are in the
payload. Numbers outside the named groups are provisional.
