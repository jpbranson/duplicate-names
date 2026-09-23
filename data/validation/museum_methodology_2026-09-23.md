# Chains leave the headline; first not-a-museum decisions

**2026-09-23.** Two methodology decisions, made by the project owner after the
[provisional leaders review](museum_leaders_review_2026-09-23.md), and the first
decisions applying them:

1. **Chain locations are separated from the headline.** M1 and M2 now count only
   institutions without established chain affiliation. Chains are reported beside the
   headline, with the L2 names where a brand collides with independently chosen names.
2. **A sourced `not_museum` category decision** removes a record that describes no
   museum (for example a society office, archive or umbrella group) from the museum
   count, while keeping its source rows auditable.

## Code changes

| Change | Effect |
|---|---|
| `dn_museum_ranking()` | `n_entities` counts non-chain institutions; `n_chain` reports same-name chain locations; names used only by chains drop out. `publication_ready` considers only the non-chain institutions. |
| `dn_assert_museum_publication_ready()` | Checks only non-chain institutions; a chain-only name cannot pass. |
| `metric_singularity_collisions()` (M2) | `n_candidates` excludes chain locations; `n_affiliated` still reports them. |
| `metric_duplicate_counts(exclude_chains = TRUE)` | Used by `dup_museums`, the M1 sensitivity band. |
| `dn_museum_chain_summary()` → `museum_chains` | One row per chain: locations, verified locations and the L2 names used. |
| `dn_museum_chain_overlap()` → `museum_chain_overlap` | L2 names shared by chain locations and non-chain institutions. |
| `category_decision = "not_museum"` | In `museum_analysis`, sets `counted = FALSE` and `exclusion_reason = "reviewed_not_museum"`. `museum_records` and its Parquet keep the identity-level rows unchanged. It may be `verified` with unknown affiliation, which is moot for a non-museum. |

`museum_review_files` also writes `chain_summary.csv`, `chain_overlap.csv` and
`not_museum_review.csv`. Two new tests cover the chain separation and the exclusion.
The resolver, 0.85 threshold, identity rules and human labels are unchanged. Earlier
packets' rankings used the old headline definition and remain valid for their checkpoints.

## Count effects

| Measure | Before | After |
|---|---:|---:|
| Counted source rows | 57,293 | 57,292 |
| Counted institutions | 52,588 | 52,584 |
| Eligible for L2 name analysis | 52,456 | 52,452 |
| Headline leader (non-chain institutions) | 11 | 11 |
| Washington County Historical Society (headline) | 7 | 4 |
| Museum of Illusions (headline, non-chain) | 1 | 1 |
| Museum of Illusions network locations | 11 | 25 |
| Chain locations reported beside the headline | 79 | 93 |
| Reviewed not-a-museum records | 0 | 3 |
| Institutions with complete factual review | 16 | 19 |

"Before" applies the new headline rules to the leaders checkpoint's decisions, so the
columns differ only by this checkpoint's decisions. Under the new rules, Franklin, Greene
and Jackson County Historical Society and Old Jail Museum tie at **11**. Old Jail's
Historic Tours of America site now sits beside its headline rather than in it.
[Count effects](museum_methodology_2026-09-23/count_effects.csv),
[ranking before](museum_methodology_2026-09-23/ranking_before.csv) and
[after](museum_methodology_2026-09-23/ranking_after.csv).

## Chains beside the headline

| Chain | Locations | L2 names used |
|---|---:|---:|
| Play Street Museum | 37 | 25 |
| Museum of Illusions (global network) | 25 | 15 |
| Ripley's | 19 | 8 |
| Museum of Ice Cream | 6 | 1 |
| Madame Tussauds | 5 | 5 |
| Historic Tours of America | 1 | 1 |

Three names are shared by a chain and non-chain institutions
([overlap](museum_methodology_2026-09-23/chain_overlap.csv)):
**Old Jail Museum** (one HTA site, 11 others, two verified independent),
**Madame Tussaud's Wax Museum** (one chain location, two unaffiliated records) and
**Museum of Illusions** (11 network locations; Miami Beach unaffiliated and pending;
Hollywood's sub-attraction already counts with its WonderWalk venue). These are candidate
material for the post; the Madame Tussaud's pair is not yet researched.

## Museum of Illusions city-suffixed locations

The official directory's US map links were parsed and matched to the 15 city-suffixed
records ([match table](museum_methodology_2026-09-23/moi_directory_match.csv)).
Thirteen are within 53 m of a directory point. New Orleans is 414 m away, but its Overture
address, 600 Decatur St, is the directory address. Atlanta has two Overture records with the
same street and website: one is 27 m from the directory point and the other, 458 m away,
is reconciled as a displaced duplicate (identity case `Methodology_MOI_Atlanta`). The
14 resulting locations receive `chain` affiliation with review still pending, because
their individual location sites were not opened. The network therefore reports 25 US
locations under 15 L2 names, matching the directory's 25 open US museums.

## Not-a-museum decisions

| Record | Evidence | Result |
|---|---|---|
| Fort Edward, NY — Washington County Historical Society | The Wing-Northup House is "the home of the Washington County Historical Society"; its "research facilities are open on Tuesdays and Wednesdays". The operator describes headquarters, library and bookshop, with no exhibits or museum visits. [Operator](https://wchs-ny.org/the-wing-northup-house/) | Not a museum; Old Fort House Museum (separate association) stays counted |
| St. George, UT — Washington County Historical Society | "WCHS exists to encourage and assist all interested Washington County communities with the organization of their city historical societies"; PO Box 404. The Pioneer Courthouse it co-manages with the city and three groups is not this record. [Operator](https://wchsutah.org/wchs/about-wchs.php) | Not a museum |
| Marietta, OH — Washington County Historical Society | 346 Muskingum Drive is "The Archives of the Washington County Historical Society of Ohio". The society's museums, The Henry Fearing House Museum and The Anchorage, are already separate counted records. [Archives](https://www.wchshistory.org/visit-the-archives) | Not an additional museum |

Greenville, MS stays counted and pending: an IRS revocation and an unsuccessful search
do not show that a record is not a museum.

## Evidence and reproducibility

One pinned-release Overture query recovered context for the 15 city-suffixed records;
its SQL and checksum are in `data/raw/MANIFEST.json`, with a
[tracked copy](museum_methodology_2026-09-23/overture_context.csv). The directory and
operator pages were cached for the leaders review; their hashes are in that packet and
the directory hash is re-verified here.

R 4.4.2: **217 assertions passed**, with no failures, warnings or skips. **23 integrity
checks passed**, including 212 protected files, the saved chain targets, both Parquet
exports and the unchanged automatic baseline and multisite queue. The generated review
now holds 457 institutions, 560 source rows and 149 nearby pairs.
[Log](museum_methodology_2026-09-23/validation.log),
[checks](museum_methodology_2026-09-23/integrity_checks.csv),
[follow-up queue](museum_methodology_2026-09-23/follow_up.csv).

```r
source("data/validation/museum_methodology_2026-09-23/validate.R")
```

The leaders validator's live comparisons now fail by design, because this checkpoint
changes the saved state and the headline code; its archived decisions and counts remain
the record of that checkpoint. No headline is publication ready.
