# Phase 2 museum analysis — review checkpoint

**Later same-day update:** the [source-verification pass](museum_source_review_2026-09-15.md)
applies additional naming and affiliation decisions, followed by nine
[identity corrections](museum_identity_review_2026-09-15.md) and the
[focused follow-up](museum_focused_review_2026-09-15.md). The focused report has the latest
counts and remaining cases. This report and its original packet retain the earlier
checkpoint results. Official-source checking is assistant work; it is separate from
independent human matching labels.

**Date:** 2026-09-15. **Status:** analysis and review tooling implemented; institution
verification and the standalone museum post are still pending. These are candidate
counts from two snapshots, not a current national census or verified independent totals.

## What changed

M1/M2 now count **one canonical L2 name per entity**. The `entities` target retains source
records, so the old duplicate helper counted multiple records and aliases as institutions.
For example, Washington County Historical Society had 27 source rows under that label;
the canonical-entity calculation has 19. This corrects the metric without changing any
matching threshold, entity/site assignment, or baseline counting flag.

Category-only names use an explicit exact-name vocabulary. Their records remain in the
data and unfiltered ranking; pending names are held out of the provisional cleaned ranking.
There are **140 flagged counted entities**, of which **139 remain pending**. Cal Poly's
[University Art Gallery](https://cla.calpoly.edu/university-art-gallery) confirms that a
category-like name can be an actual name, so that one category hold was released.
Its overall identity review remains pending. UC San Diego documents University Art Gallery
as the former name of [Mandeville Art Gallery](https://mandevilleartgallery.ucsd.edu/about/history.html);
that record stays on hold. No category record was automatically declared a placeholder.

Affiliation now requires a sourced rule or explicit decision. The initial lexicon covers
Play Street Museum, Ripley's, Madame Tussauds, and Museum of Ice Cream. Brand affiliation
does not establish that each POI is a distinct, currently operating museum. Missing
evidence is **unknown**, not independent. County-name templates remain separate from
chains. The rule file carries the source URLs, scope and review date.

M3 now extracts a bounded set of topics, retaining multiple topics and leaving unknown
ones unclassified. It is a heuristic vocabulary, not complete noun-phrase extraction.
The IMLS comparison checks broad compatibility only: GMU (general/uncategorized) is not
agreement. Subjects inherit L3's limitations, and subject totals overlap for multi-topic
names. Neither this comparison nor the assistant's research measures classification accuracy.

## Provisional L2 ranking

The first 20 positions include a tie at nine entities, so the review retains **21 names**.
Known affiliated branches remain in M1 and are separated in M4; none count as independently
verified collisions. All entries below require identity/count review.

| Name | Candidate entities | Initial review focus |
|---|---:|---|
| Washington County Historical Society | 19 | Inherited county name; nearby records and society/museum identities |
| Old Jail Museum | 15 | Building-name template; distinct locations and current operation |
| Union County Historical Society | 14 | Inherited county name; nearby records |
| Museum of Illusions | 13 | Location-specific operator networks |
| Play Street Museum | 12 | Sourced franchise affiliation; branch identity |
| Ripley's Believe It or Not | 12 | Sourced brand affiliation; branch identity |
| Franklin County Historical Society | 11 | County template; identity and liveness |
| Greene County Historical Society | 11 | County template; identity and liveness |
| Jackson County Historical Society | 11 | County template; identity and liveness |
| Depot Museum | 10 | Building-name template; identity and liveness |
| Smithsonian Institution | 10 | Parent-label POIs versus actual museum facilities |
| Wayne County Historical Society | 10 | County template; identity and liveness |
| Adams County Historical Society | 9 | County template; identity and liveness |
| Brown County Historical Society | 9 | County template; identity and liveness |
| Carroll County Historical Society | 9 | County template; identity and liveness |
| Children's Discovery Museum | 9 | Shared topic versus affiliation |
| Clinton County Historical Society | 9 | County template; identity and liveness |
| Madison County Historical Society | 9 | County template; identity and liveness |
| Monroe County Historical Society | 9 | County template; identity and liveness |
| Pioneer Village | 9 | Broad attraction label; distinct institutions |
| Veterans Memorial Museum | 9 | Shared topic; nearby records |

The analysis retains **52,636 baseline counted entities** from **57,348 counted source
records**. Category holds leave **52,497 provisionally eligible entities**. This is a
review policy, not evidence that exactly 139 source names are erroneous. The separate
unfiltered ranking retains Art Gallery (37), Planetarium (14), Children's Museum (13),
University Art Gallery (13), and the other held categories.

## Review packet

The [dated packet](museum_review_2026-09-15/) is tracked independently of generated outputs:

- [Cleaned leading ranking](museum_review_2026-09-15/ranking.csv) and
  [unfiltered comparison](museum_review_2026-09-15/ranking_before_category_review.csv).
- [470 candidate institutions](museum_review_2026-09-15/institutions.csv): top M1 names
  before/after category holds, leading M2 candidates including cutoff ties, and the seed.
  Includes source keys, canonical/alternate names, coordinates, map links, 2018 IMLS
  city/parent context, affiliations and review status. Every overall review remains pending.
- [551 underlying source records](museum_review_2026-09-15/source_records.csv), including
  excluded records and original IMLS legal names, addresses, parent institutions and URLs.
  IMLS context is historical, and its old URLs have not all been checked.
- [159 nearby entity pairs](museum_review_2026-09-15/nearby_pairs.csv), within 25 km,
  with **blank** independent labels. Join `entity_a`/`entity_b` to the institution sheet.
  These diagnostic cases are intentionally selected, not a representative accuracy sample.
- [Relevant multi-site source records](museum_review_2026-09-15/multisite_records.csv)
  and the [full saved multi-site queue](museum_review_2026-09-15/multisite_queue.csv).
  None of the leading M1 entities already spans multiple resolved sites; the relevant
  multi-site rows in this packet belong to the Cryptozoology seed. Nearby unmerged entities
  are a separate review problem and are explicitly included above.
- [Category review](museum_review_2026-09-15/category_review.csv),
  [M2 candidates](museum_review_2026-09-15/singularity_candidates.csv), and
  [subject summary](museum_review_2026-09-15/subjects.csv).
- [Source research notes](museum_research_2026-09-15.csv),
  [affiliation rules](museum_chain_rules.csv), and
  [category decisions at this checkpoint](museum_source_review_2026-09-15/decisions_before.csv).
  The live decision input is [museum_decisions.csv](museum_decisions.csv).

Generated files live in `data/processed/museum_review/` and are overwritten by targets.
Save completed review outside that directory. Apply one decision per entity using a stable
`source`/`source_id` and the exact `expected_name` in `museum_decisions.csv`; the code fails
on missing/stale source keys, conflicting entity decisions, or absent review evidence.
Use `confirmed_name` to release a category hold and `placeholder` only with evidence.
Keep `review_status = pending` until the institution, name, current counting decision and
affiliation have been checked against source evidence. An assistant can complete this
factual review; `verified` does not mean an independent human matching label. For M2,
also inspect the meaning of the scope word. A verified row must have resolved category
and affiliation statuses.

Fresh pair labels should stay in the dated packet or another tracked archive. **Do not
alter the September 15 resolution gold labels** or use the assistant's research as
independent validation. No new matching decisions were applied at this initial checkpoint.

## Priority findings from source research

1. **Museum of Illusions needs location-level ownership review.** Its
   [global network directory](https://www.museumofillusions.com/our-locations/) provides
   addresses, while a [2021 court order](https://business.cch.com/ipld/MetamorfozaBigFunny20210727.pdf)
   describes separate operators using the wording in Los Angeles and Miami. The legal
   document is historical evidence of ambiguity, not a current ownership determination.
   The [San Diego site's affiliation statement](https://moisandiego.com/) illustrates the
   location-specific evidence needed. A name/operator label alone cannot select a network.
2. **National Electronics Museum is a relocation warning.** Four candidate entities share
   the L2 name. Its [official history](https://www.nationalelectronicsmuseum.org/about-us/history-mission/)
   documents a Linthicum-to-Hunt Valley move and November 2024 reopening. The four points
   cannot support a four-independent-museum headline without reconciliation.
3. **National Vietnam War Museum needs geographic reconciliation.** Five L2 candidates
   include several Texas points and a Florida record. The Texas museum gives one
   [physical address near Mineral Wells](https://www.nationalvnwarmuseum.org/contact-map-1).
   Investigate those points and the separately named Florida institution; no merge was inferred.
4. **The scope parser is lexical.** African American Museum and Museum of American Art
   can describe a subject rather than assert uniqueness. M2 outputs are candidates with
   separate unknown-affiliation counts, not ready-made hubris findings.
5. **Correct the seed chronology.** The Cryptozoology Museum's
   [official home page](https://cryptozoologymuseum.com/) dates its new Bangor home to
   June 1, 2026; 2016 was a move within Portland. Its
   [visit page](https://cryptozoologymuseum.com/plan-your-visit/) names 490 Broadway as current
   and lists both Thompson's Point and 585 Hammond Street as closed. The saved selected
   point is -68.77496444, 44.81822101. Retain all old sites and verify the map location;
   the assistant has not supplied an independent clustering label.

## Validation and reproducibility

- R **4.4.2**; all **97 test assertions pass**, including canonical counting, L2 separation,
  unknown affiliation, category decisions, stale/conflicting review inputs, subjects,
  cutoff ties, empty-stage contracts, nearby-pair diagnostics and publication readiness.
- The targets build completed using cached Overture `2026-08-19.0`, IMLS 2018, and
  gazetteer inputs. The original IMLS archive supplies review context; it required no
  new download. No dependency or lockfile change.
- Compared all 60,002 source records before and after: entity IDs, site IDs, baseline
  counted flags and exclusion reasons are identical. Raw provenance is unchanged.
- Both the completed working label sheet and tracked label archive are byte-identical
  to their pre-build versions. The destructive `labelling_sheet` target was not selected.
- Archived label scoring is unchanged: **119 true merges, 1 false merge, 8 missed merges,
  172 true separations; precision 99.17%, recall 93.70%, sample error 3.00% at 0.85**.
  These are the original unweighted sampled-pair results, not dataset/cluster accuracy.
- [Input SHA-256 hashes](museum_review_2026-09-15/input_checksums.csv) identify the manifest,
  rules, decisions and gold labels used for this review packet.

Commands used at this checkpoint (see [README.md](../../README.md#running) for the
current build, including identity exports):

```r
targets::tar_make(names = c(museum_review_files, dup_museums,
                            multisite_review, entities_file))
source("tests/testthat.R")
```

`scripts/archive_museum_review.R YYYY-MM-DD` creates a new tracked review packet after
the build and refuses to overwrite an existing one. It does not archive the later identity
decision/audit artifacts; preserve those separately as described in README. The template still needs
its helpers bundled and an independent knit. **Do not export post payloads or publish
headlines yet:** complete the factual institution review, adjudicate necessary source corrections
without retuning against the old labels, then prepare the figures and standalone post.
