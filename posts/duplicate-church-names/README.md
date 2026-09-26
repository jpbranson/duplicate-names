# Church post bundle — unpublished research draft

The bundle builds from its own CSV payloads, local helpers and prebuilt map without
the analysis checkout or profile. `preview.html` is the verified standalone preview;
`index.Rmd` remains `draft: true`. The map is self-contained, uses no remote tiles,
and exposes source aliases. `first-baptist-fallback.png` is its static key view.
The leading-name CSV contains the first 200 rows at each normalization level; full
rankings and reviewable source rows remain in the project exports.

Open the post over a local HTTP server so relative page resources work. To knit:
`rmarkdown::render('index.Rmd')` with the pinned R libraries and Pandoc available.
The recorded isolated build uses html_document for preview; final blogdown/theme
integration is unverified because the actual blog destination is still missing.

Required unfinished gates: fresh independent matching/classifier labels, final
cluster identities, leading-name and high-ordinal factual checks, and actual blog
integration/deployment. Do not turn this provisional draft into a certified claim.
See the church evidence packet and the project FLIGHT_LOG.md for current status.
