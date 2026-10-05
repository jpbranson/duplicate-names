# Design Notes

* [Technical architecture overview](overview.md) - R end to end with targets, DuckDB, arrow and sf; repository layout; one-way flow to the blog repo; US-first scope.
* [Reproducibility and provenance](reproducibility.md) - MANIFEST.json, dated packets and checksums; what the manifest does and does not guarantee.
* [renv setup gotchas](renv.md) - Explicit snapshots driven by DESCRIPTION, which must stay Type: Project with no Package: field.
* [Distance correctness](distance-correctness.md) - Use sf on s2 geometry for great-circle distances; never project to a national CRS and measure Euclidean distance.
* [Data licensing](licensing.md) - Build the published dataset on permissive sources and keep OSM (ODbL) as an internal validation layer, or license the release ODbL.
* [Publishing into blogdown](blog-publishing.md) - ggplot2 charts knitted in the post, maps as self-contained iframed widget HTML, and posts as Hugo page bundles that never knit the pipeline.
* [Blog defaults (adjustable)](blog-defaults.md) - Chosen defaults for the blog integration (paths, format, widths, devices, slugs) and the load-bearing palette rules.
* [Dashboard design (Phase 4)](dashboard.md) - The explorer generalizes the post-2 embeds: static first, alt_names exposed on the map, plain GeoJSON at this scale.
