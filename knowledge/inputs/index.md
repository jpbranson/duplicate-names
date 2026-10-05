# Label Sets

* [Church independent labels, version 2 (blank)](church-independent-labels-v2.md) - Draft. Blank version-2 church sample awaiting independent human labels, with 300 matching pairs, 500 naming-style and denomination items and a final-cluster review queue.
* [Resolution labels, September 15 sample](resolution-labels-2026-09-15.md) - Authoritative archive of 300 independent human pair labels used to score the museum matching rule; preserve it unchanged and score it with dn_score_labels().

# Decision Tables

* [Church preferred public names](church-name-overrides.md) - Guarded church public-name corrections applied to church_named_analysis; two 38th Avenue records, with no identity or matching-accuracy certification.
* [Church scope decisions](church-scope-decisions.md) - Guarded, sourced outside_christian_scope holds that remove listed church entities from Christian-only analysis without changing source religion, identity or review status.
* [Museum chain rules](museum-chain-rules.md) - Sourced brand-affiliation rules and ambiguous-name review hints that the museum pipeline matches against every source record; no match means unknown affiliation, not independence.
* [Museum decisions (naming, category, affiliation, review)](museum-decisions.md) - Per-institution naming and category (including sourced not_museum), affiliation and overall review decisions, keyed to a source record and its exact expected name after identity reconciliation.
* [Museum identity decisions](museum-identity-decisions.md) - Explicit, guarded source membership over the automatic entities baseline, applied in museum_records before museum analysis; 440 rows in 185 cases as of commit 7416eef.
* [Museum preferred public names](museum-name-overrides.md) - Guarded preferred public names for counted museum institutions, applied in museum_analysis only; original source names and the automatic baseline stay unchanged.
* [Post 1 headline review (decision 14)](post1-headline-review.md) - Per-member evidence that a museum meets DESIGN decision 14's headline-sufficient standard, passed as headline_review to dn_assert_museum_publication_ready(); never changes review_status.
* [Staged museum publication locations](publication-locations.md) - Separate operator-sourced map points and dated access wording for Mandeville, Smedley and Peters Creek, applied only in the dated publication export; the pipeline and Parquet keep source coordinates.
