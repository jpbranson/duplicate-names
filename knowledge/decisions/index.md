# Decisions

* [Geographic scope: US-first, with a global follow-up](01-us-first-scope.md) - Both near-term posts are US-only; the schema stays country-general so a global pass is cheap.
* [Output format: R blogdown](02-r-blogdown-output.md) - The project is R end to end; ggplot2 figures knit inline, mapgl maps are iframed and posts ship as Hugo page bundles.
* [Temporal question C5 deferred to post 3](03-temporal-c5-deferred.md) - Founding-date analysis gets its own post and acquisition phase, outside post 2's critical path.
* [First Baptist racial split gets its own post](04-first-baptist-split-own-post.md) - Post 2 surfaces and names the pattern and emits the multiplicity list; post 4 tells the history with real sourcing.
* [Phase 1 runs museums first, in two halves](05-museums-first-phasing.md) - Museums (1a) before churches (1b) to reach a publishable post sooner; churches deferred, not dropped, and implemented on 2026-09-26.
* [Closed museums are excluded from counts but kept in the data](06-closed-museums-flagged-not-counted.md) - Exclusions are flags with a reason (counted / exclusion_reason), never deletions.
* [The physical institution is the unit of analysis](07-physical-institution-unit.md) - Count one entity per physical museum; society names go to alt_names, which the map must expose.
* [Blog integration: defaulted, not blocked](08-blog-integration-defaults.md) - Sensible defaults in R/config_blog.R let work proceed while the blog repo is reworked.
* [Museum name headlines use L2](09-museum-headlines-use-l2.md) - M1/M2 use name_expanded; L3 is kept for geography-stripped comparisons and subject analysis.
* [Retain the 0.85 matching threshold](10-retain-085-threshold.md) - The 300-pair human-labelled sample supports 0.85; lowering to 0.80 adds false merges for little recall.
* [Apply sourced identity corrections in a separate, auditable layer](11-auditable-identity-corrections.md) - entities stays the automatic baseline; explicit membership in museum_identity_decisions.csv produces museum_records.
* [Separate chains from the headline](12-separate-chains-from-headline.md) - M1 and M2 count only non-chain institutions; chains are reported beside the headline.
* [Exclude sourced non-museums from the count](13-exclude-sourced-non-museums.md) - A not_museum decision needs positive operator evidence of what the record is; absence of evidence does not qualify.
* [Headline-sufficient review and stopping rules for post 1](14-post-1-headline-sufficient-review.md) - Post 1's per-member evidence standard, the M1 stopping rule, at most five surprising collisions, and the church/explorer freeze.
