# Methods

* [Name normalization ladder (L0-L4)](normalization-ladder.md) - Every record keeps five name levels; museum headlines use L2 name_expanded and church counts use L3 name_core.
* [Structured extraction](structured-extraction.md) - Fields parsed from normalized names: ordinal, denomination, scope claim, subject and naming style, with implementation status.
* [Entity resolution](entity-resolution.md) - Deduplicating source records into institutions: 150 m candidate radius, 0.85 similarity threshold and the September 15 validation.
* [Curated identity corrections](identity-corrections.md) - The guarded, auditable correction layer that turns the automatic entities baseline into museum_records, including source-conflict holds.
* [Franchise and branch detection (M4)](chain-detection.md) - How sourced chain rules separate brand locations from independent collisions; unknown affiliation is NA, never independence.
* [Category-only names](category-only-names.md) - Names such as art gallery or planetarium are held for review; sourced decisions confirm, exclude, hold as historical or mark not_museum.
* [Museum publication gate](publication-gate.md) - What dn_assert_museum_publication_ready() checks before headline export, how decision 14's headline_review changes it, and what it cannot check.

# References

* [Known traps](known-traps.md) - Seven analytical traps: signage vs legal names, closed institutions, chains, the First Baptist split, messy denominations, Christian Science, ladder survivorship.
