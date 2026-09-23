# Duplicate Names — Development Plan

**Status:** Phase 2 tooling and focused source/identity passes complete; remaining headline checks pending
**Last updated:** 2026-09-18

The museum pipeline runs on Overture + IMLS. All 300 candidate pairs have human labels;
the [validation report](data/validation/resolution_validation_2026-09-15.md) records the
results and their limits. [HANDOFF.md](HANDOFF.md) holds the current work queue. Sections
below distinguish implemented behavior from remaining analysis and publication work.

---

## 1. The premise

Standing in Bangor, Maine, in front of the **International Cryptozoology Museum**, the
obvious question is not "is cryptozoology real" but "is this *the* one?" The name makes a
claim of singularity — *International*, definite article implied — and nobody adjudicates
that claim. There is no registrar of institutional names. Anyone can be The Museum of
anything.

That opens a general question: **when a place name asserts uniqueness, how often is it
actually unique?** And its inverse: **when a name is obviously generic, how does the
namespace get carved up geographically?**

Churches are the richer case, because they solved the collision problem explicitly and
centuries ago: they *numbered themselves*. First Presbyterian, Second Presbyterian, Third.
That is a namespace with a versioning convention baked in — and a territory rule implied by
it. Museums assert; churches enumerate.

### The core questions

**Museums**

- M1. What is the most duplicated museum name in the US?
- M2. Which *singular-claiming* names (The / International / National / World / American …)
  have collisions anyway? Rank by hubris-vs-reality.
- M3. How does the generic tail behave — Natural History, Children's, Fire, Railroad,
  County Historical? These collide by necessity, not accident. Different phenomenon,
  worth separating.
- M4. Which collisions have evidence of common ownership or branch affiliation, and which
  are independent institutions sharing a name? Repeated templates such as `Children's
  Museum of X` or `X County Historical Museum` form a separate explanatory category;
  the wording alone does not make them chains.

**Churches**

- C1. Which church names are duplicated most, nationally?
- C2. How far apart do two `First [Denomination] Church`es sit? What is the *territory* of
  a First — and is that territory a real spacing rule, or just a proxy for "one per
  municipality"?
- C3. How high does the ordinal ladder go? Highest observed Nth. Is the ladder complete —
  does a Fourth imply a First, Second, and Third nearby?
- C4. Which denominations count, and which invent? Ordinal vs. saint vs. virtue vs.
  toponym vs. modern-brand naming cultures.
- C5. *(deferred to post 3 — see §2)* Has the practice changed over time? Hypothesis:
  ordinals are a 19th-century urban mainline habit; the 20th century goes toponymic and
  virtue-based; the 21st goes single-word brand (Elevation, Life, Journey, Mosaic,
  The Rock).

---

## 2. Deliverables

| # | Deliverable | Notes |
|---|---|---|
| D1 | **Blog post 1 — Museums.** "Who checks?" Opens on Bangor. Lands M1–M4. | The lead-in. Shorter, funnier, self-contained. |
| D2 | **Blog post 2 — Churches.** The counted namespace. Lands **C1–C4**. | The heavier one. Maps carry it. Flags posts 3 and 4 forward. |
| D3 | **Blog post 3 — Naming over time.** C5 on its own, with its own data-gathering phase. | Deferred deliberately: needs founding dates that don't exist in the Phase 1 sources. |
| D4 | **Blog post 4 — The other First Baptist.** The post-Reconstruction split (§6.4). | Needs historical sourcing beyond the name data. Raised by post 2's municipal-exclusivity result. |
| D5 | **`LEADS.md`** — running register of analogous name-collision phenomena surfaced while working. | Seeded now, appended continuously. |
| D6 | **Map / dashboard** — generalizable "duplicate name explorer." | Phase 4. Explicitly *after* posts 1–2; those posts define what the dashboard needs to do. |
| D7 | **Reproducible pipeline + published derived dataset.** | Arguably the most durable artifact here. |

**Post ordering.** D3 and D4 both descend from post 2 and can be written in either order.
Recommendation is D4 first — it answers a question post 2's own data puts in front of the
reader, whereas D3 needs a fresh acquisition phase before a word can be written. Post 2
should point forward to both regardless of which lands first.

---

## 3. Data sources

Availability verified 2026-09-07.

**Implemented inputs:** Overture Places release `2026-08-19.0` and the IMLS 2018 CSV
archive, with provenance in `data/raw/MANIFEST.json`. GNIS, HIFLD, OSM, and Overture
religious categories remain queued for Phase 1b. Wikidata enrichment is not implemented
and is not a completed Phase 1a dependency.

Phase 2 also uses official institution pages and source address/website metadata for
explicit naming, affiliation and identity decisions. The 38-record Overture context
query uses the same pinned release; its SQL/checksum are in the manifest and a
[tracked copy](data/validation/museum_identity_review_2026-09-15/overture_context.csv)
is archived with the identity evidence. The later
[Old Jail context query](data/validation/museum_old_jail_review_2026-09-15/overture_context.csv)
adds 41 records from the same release, followed by the 21-row
[Union County query](data/validation/museum_union_county_review_2026-09-17/overture_context.csv).
The manifest also records the address pass's IRS extracts and operator-page caches,
19 pages from the Old Jail review, and 30 public documents from the Union County review.
These research acquisitions are outside `_targets.R`; their dated packets preserve
the context and extracted evidence needed to review the decisions.
Census 2023 places, counties and states supply the cached normalization gazetteer;
those downloads are not yet included in the manifest.

### Primary spine

| Source | Covers | Why | License |
|---|---|---|---|
| **Overture Maps — Places theme** | Global POIs; categories `museum` (under `arts_and_entertainment`) and `religious_organization`; GeoParquet on S3/Azure | Best single spine: queryable in place via DuckDB `httpfs` without a full download; permissive license; consistent schema; carries confidence scores and source lineage | CDLA-Permissive-2.0 / Apache-2.0 |
| **OpenStreetMap** (Geofabrik NA extract or Overpass) | `tourism=museum`, `amenity=place_of_worship` | Richer tags Overture drops: `denomination`, `religion`, `start_date`, `wikidata`, `operator`, `museum=*` | **ODbL** — share-alike; see §7 |
| **GNIS 2021 archived snapshot** | ~230k US churches under the retired `Church` feature class | USGS *removed* Church/Cemetery/School classes in 2021 and archived the file unchanged since. A frozen, government-authored, name-rich snapshot — and its staleness is a feature: it predates the modern church-plant naming wave | Public domain |
| **IMLS Museum Universe Data File** | ~30k records from the 2018 CSV archive used by `src_imls()` | Historical museum list with discipline codes; cross-check against Overture. The snapshot does not establish current operation or complete present-day coverage | Public domain |
| **HIFLD "All Places of Worship"** | 254,740 US records, July 2024 snapshot, built from IRS 501(c)(3) master files | Independent third source. IRS-derived, so it captures *legal* names rather than *signage* names — a useful contrast in its own right | Public domain |

### Supporting / temporal

**Scope note.** Founding-date acquisition is deferred to **post 3 (D3)**. Wikidata may
also support affiliation checks for M4, but is not currently wired into the pipeline.
Census places serve a separate purpose and are required for the church C2 denominator;
the museum pipeline already uses a place-name gazetteer for L3 normalization.

| Source | Use |
|---|---|
| **Wikidata** | `inception` dates, `instance of` museum/church building, operator chains, disambiguation pages. The only clean structured source for founding years. |
| **National Register of Historic Places** (NPGallery bulk spreadsheet, 90k+ properties) | Construction and listing dates for historic churches. Skews old and architecturally notable — a biased but datable sample. |
| **IRS Business Master File (Pub 78 / BMF)** | `RULING` date as a weak proxy for congregation founding. Churches are exempt from filing, so coverage is partial and biased toward larger, incorporated bodies. Use with loud caveats, or not at all. |
| **Denominational directories** (SBC, PCUSA, ELCA, UMC, Episcopal) | Several publish congregation lists with organization years. The best temporal data available if scrapeable — highest effort, highest payoff for C5. |
| **Census places / TIGER; GNIS populated places** | Denominator for the "one First per municipality" test (C2). Non-optional. |

### Explicitly not used

- **ARDA / US Religion Census (RCMS)** — county-level counts only, no congregation names.
  Fine for context sentences, useless for name analysis.
- Google Maps or Yelp POI harvesting. Source reviews may compare saved coordinates
  with an institution's own outbound map destination; those checks are documented as
  operator-supplied locations, not independent geocoding validation.

---

## 4. The hard part: name normalization

This is where the project succeeds or fails. Every headline number is an artifact of the
normalizer. It gets its own module, its own test suite, and a paragraph in each post.

### 4.1 Normalization ladder

Each record keeps *all* levels, so sensitivity can be reported rather than hidden:

- **L0 `name_raw`** — as given.
- **L1 `name_clean`** — Unicode NFKC, case-fold, remove diacritics, expand `&` to `and`,
  replace punctuation except apostrophes with spaces, collapse whitespace, drop leading `The`.
- **L2 `name_expanded`** — abbreviation expansion: `St.`→`Saint`, `Ft.`→`Fort`,
  `Mt.`→`Mount`, `AME`→`African Methodist Episcopal`, `UMC`→`United Methodist Church`,
  `1st`→`First`, `Assy`→`Assembly`. These examples show expansions; stored strings are lowercase.
- **L3 `name_core`** — strip the locative tail. This is the key operation:
  `First Baptist Church of Peoria` → `First Baptist Church`;
  `Peoria First Baptist Church` → `First Baptist Church`.
  Implemented by matching against a gazetteer of place names (Census places, counties,
  states) at both head and tail positions, with a blocklist protecting ambiguous names
  such as Springfield and Union.
- **L4 `name_key`** — L3 plus token sort and stopword removal, for fuzzy grouping.

**Museum name headlines (M1/M2) use L2 `name_expanded`.** Geography is often part of a
museum's identity; stripping it answers a different question. L3 `name_core` supports
geography-stripped comparisons and the implemented bounded M3 subject analysis. Church name counts
will use L3. Report the comparison levels explicitly rather than presenting L3/L4 museum
counts as interchangeable estimates of the L2 result. A headline that only survives at L4
is not a headline.

The current duplicate-count helper defaults to L2/L3/L4. L1 can be requested explicitly.
M1/M2 now count a single canonical L2 name per entity. The resolved-record table retains
all source rows; counting those rows or each alias separately inflated the old metrics.

### 4.2 Structured extraction

Extract fields from the appropriate normalization level, preserving the full name for
ordinal and scope-claim parsing and using the geography-stripped name for subject work:

- `ordinal` — First … Twentieth and beyond, numeric and word forms. Watch the trap:
  `First Christian Church` is an ordinal; `First Church of Christ, Scientist` is a
  denominational proper name and not the first of anything.
- `denomination` — from the name, reconciled against OSM `denomination`/`religion` tags and
  HIFLD/IRS classification. Tag-derived is preferred; name-derived is the fallback.
- `scope_claim` — `International | National | World | Global | Universal | American |
  Only | Original`. Drives the museum hubris ranking.
- `subject` — for museums, the topic noun phrase (Cryptozoology, Natural History, Fire,
  Quilts, Barbed Wire).
- `name_style` — the C4 taxonomy: `ordinal | saint | virtue | toponym | modern_brand |
  ethnolinguistic | descriptive | other`. Lexicon-classified first; then hand-label a
  stratified sample of ~500 to measure the classifier's error rate, and publish that rate.

**Implementation status:** ordinal and scope-claim parsing exist. Compound ordinals remain
a known church-analysis gap. `name_style` and `denom_norm` remain placeholders. Museum
subjects use a bounded regex vocabulary on L3, with unmatched names left unknown and
multiple topics retained. This is a heuristic topic taxonomy, not complete noun-phrase
parsing. IMLS discipline provides a coarse compatibility diagnostic; GMU is not agreement,
and this comparison does not measure classifier accuracy. Subjects inherit L3's limits.

### 4.3 Entity resolution (deduplicating the *data*, not the *names*)

A single institution appearing in several sources must not count as several duplicates.
The current Overture/IMLS automatic matcher uses normalized names and a 150 m site
candidate radius, followed by a separate name-based multi-site heuristic. Address and
website evidence supports curated corrections; automatic address matching is not
implemented. Cross-source agreement is a research signal, not proof of identity or
current operation: records can be stale and sources can share upstream providers.

**This is the single largest correctness risk in the project.** Budget real time for it.

**September 15 validation:** all 300 sampled pairs were independently human-labelled.
At the retained similarity threshold of **0.85**, there are 119 true merges, 1 false merge,
8 missed merges, and 172 true separations: precision **99.17%**, recall **93.70%**, and
sample error **3.00%**. The sample F1 sweep also selects 0.85.

These are unweighted results from 60 pairs per similarity band, all within 150 m. They
do not estimate dataset-wide error or validate final transitive clusters, multi-site
merging, or matches outside that radius. Threshold selection used the same sample rather
than a held-out set. Preserve the original labels in `data/validation/`; use the nine
disagreements diagnostically and fresh independent labels to evaluate matching changes.
The generated `labelling_sheet` target can overwrite the working sheet in `data/processed/`.

### 4.3.1 Curated identity corrections

**Curated identity layer, September 15:** the automatic `entities` target remains an
auditable baseline. `museum_records` applies only explicit source memberships from
`museum_identity_decisions.csv`; it does not widen any matching rule. Each case names
one existing canonical record, all affected baseline-cluster members, physical site
groups, and source evidence. Guards check original names, entity IDs and coordinates.
Current-name and former-name aliases are retained; physical museums under the same
operator remain separate unless the evidence identifies the same museum.

Within a reviewed case, only the canonical source record counts. Other rows remain
with `reviewed_duplicate_record`, `reviewed_former_site`, `reviewed_mailing_address`
or `reviewed_mislocated_record`. Source names and coordinates are not overwritten;
misplaced/mail coordinates are not treated as additional physical sites. A source-level
audit carries the original and corrected entity/site IDs, names and counting flags.
Unreviewed rows keep the baseline policy. The first nine cases reconcile 24 baseline
entities into nine institutions. Tests validate this mechanism, not the correctness of
the assistant's factual judgments or overall matching accuracy. See the
[identity report](data/validation/museum_identity_review_2026-09-15.md).

The [focused follow-up](data/validation/museum_focused_review_2026-09-15.md) adds a
LeMoyne consolidation and two `source_conflict` holdouts. The later
[address follow-up](data/validation/museum_address_review_2026-09-15.md) adds the Chipley
mailing consolidation and Peters Creek house/society pair. The
[Old Jail pass](data/validation/museum_old_jail_review_2026-09-15.md) adds eight accepted
identity cases and two more source-conflict holds. The
[Union County pass](data/validation/museum_union_county_review_2026-09-17.md) adds six
identity cases covering 15 source rows. The current input has 71 source rows across
28 cases, with 26 canonical institutions and four isolated conflicting rows.
A conflict row receives its own stable entity/site ID, `counted = FALSE` and
`reviewed_source_conflict`; its disputed aliases cannot propagate to accepted members.
Cases containing only conflicts need no canonical institution. Cases with accepted
members still require exactly one counted canonical record.

Identity reconciliation does not certify a visitor location. Source coordinates remain
intact, including Mandeville's displaced points; the operator-supplied destination is
archived in the focused packet's `map_checks.csv`. The address packet's
`publication_locations.csv` stages separate publication coordinates, evidence and dated
access wording for Mandeville, Smedley and Peters Creek. Publication export must consume
these fields and refresh access checks. Generated review map links still use source
coordinates. The expanded IMLS review context now retains EIN and separate physical/mailing
street, city, state and ZIP fields as text. Readable addresses are assembled per original
row before combining repeated MIDs; institution summaries retain the source ID beside
each value. The legacy coalesced fields remain for compatibility, but are insufficient
for identity research: the earlier dossiers hid the Pennsylvania contradictions.
These fields enrich review sheets and future archives without changing analysis records
or applying new identity decisions. See the [field guide](README.md#completing-a-museum-review).

### 4.4 Franchise / branch detection (M4)

Flag collisions with evidence of common ownership or branch affiliation so they can be
held out of the "independent collision" headline. Evidence can include a shared operator,
a verified Wikidata parent, or a sourced chain lexicon. A nonempty operator field alone
does not establish a chain. Sourced rules in `data/validation/museum_chain_rules.csv`
replace that shortcut. Specific brand names can establish network affiliation; location
identity and liveness remain separate review questions. Name-only rules for ambiguous
labels such as Museum of Illusions and Smithsonian Institution are review hints. Sourced
location-specific decisions now establish 11 Museum of Illusions network affiliations;
the Hollywood and Miami candidates remain unknown. `is_franchise = NA` means unknown;
only an explicit reviewed decision can establish independence.

Classify productive templates such as `Children's Museum of X` / `X County Historical
Museum` separately. Shared wording or inherited place names are not evidence of shared
ownership. Keep institution identity, affiliation, and name-pattern explanations distinct.

### 4.5 Category-only names

The saved rankings include `art gallery`, `planetarium`, and `fine arts gallery`. These
may be POI category placeholders or actual institution names; names alone cannot settle
that distinction. An exact L2 vocabulary now flags category-only names. Pending cases
are held out of the provisional cleaned ranking, remain counted under the baseline
policy, and appear in the unfiltered ranking and review queue. A sourced `confirmed_name`
decision releases the hold; `placeholder` excludes only the name analysis. A sourced
`historical_name` decision preserves a documented former name while holding it out of
the current-name ranking. These decisions are keyed by source record with a stale-name
guard. This is not blanket deletion or a
claim that every flagged name is wrong. Review ambiguous cases before any headline.

---

## 5. Metrics — defined before we look

The original questions were defined before analysis. Subsequent methodological decisions
are recorded in §9 so changes such as the museum L2 choice remain visible.

**Museums**

- `dup_count(name_expanded)` — headline for M1, using counted museum entities and the
  implemented category-only review policy.
- **Singularity Collision Index** — for names carrying a `scope_claim`, the count of
  independent (non-franchise) institutions sharing `name_expanded`. The Cryptozoology seed case
  scores whatever it scores; the *ranking* is the story.
- **Genericity split** — partition names into *asserted-unique* vs *descriptive* and report
  the two distributions separately. Conflating them is the obvious analytical mistake and
  the thing most likely to make post 1 wrong.

**Implementation status:** `_targets.R` emits canonical L2 duplicate and singularity
candidate counts, subject summaries, affiliation splits, and review sheets. M2 reports
unknown affiliation separately from reviewed independence; its lexical scope claims
still require semantic review (American can describe a subject rather than assert
singularity). No candidate count is a verified count of independent institutions.

`dn_assert_museum_publication_ready()` checks selected L2 names for counted, eligible,
verified rows with resolved affiliation. It is an explicit pre-export check, not a target
automatically invoked by `_targets.R`. The ranking's `publication_ready` column summarizes
recorded review statuses; neither mechanism verifies evidence, semantic scope claims or
map/access details. Albion, Jim Thorpe and Creston's Historical Village have verified
overall reviews. Ten Old Jail reviews and all seven remaining Union County Historical
Society exact-name candidates remain pending, so both groups fail the explicit publication
check. The [September 17 batch](data/validation/museum_union_county_review_2026-09-17.md)
reduces Union County's provisional count from 14 to seven through six identity cases.
A supported identity or naming decision alone does not complete a review.

**Churches**

- `dup_count(name_core)` — headline for C1.
- **Territory radius** — for each `name_core` class, the distribution of nearest-neighbor
  great-circle distances between same-name congregations. Median and p10/p90 per
  denomination. `sf::st_nearest_feature()` + `st_distance()` on s2 geometry; do not project
  and measure Euclidean distance at national scale (see §7).
- **Municipal exclusivity rate** — the real C2 test. Of all Census places containing ≥1
  congregation of denomination D, what fraction contain *exactly one* `First D Church`?
  The hypothesis under test: "territory" is not a distance rule at all but a
  *one-per-settlement* rule, and observed spacing is just settlement spacing wearing a
  costume. This reframing is the most likely genuine finding in the churches post.
- **Ladder completeness** — for each place with a max ordinal N, what fraction of 1..N are
  present? Missing rungs are stories: mergers, closures, renames, splits.
- **Max ordinal** — highest N observed, by denomination and by city. Verify the top handful
  by hand; the largest number in any dataset is usually a data error.
- **Naming-culture profile** — `name_style` distribution per denomination (C4). The
  per-founding-decade cut is post 3's job.

**Temporal (C5) — post 3.** Cohort analysis of `name_style` by founding decade, on the
subset with reliable dates. The reason this is its own post rather than a section of post 2:
the sample bias is severe and needs room to be handled honestly. Dated congregations skew
old, architecturally notable, and mainline, so a "modern brand names are rising" finding
has to be defended against the objection that recently founded churches are simply
underrepresented in every dated source we have. That defense requires either real
denominational-directory coverage or an explicit correction model — either way, more space
than a sub-section allows.

**Municipal multiplicity (post 4).** Post 2 will produce a list of places holding two or
more `First D Church`es. That list is the raw material for post 4 (§6.4), so post 2's
pipeline should emit it as a named artifact rather than an incidental intermediate.

---

## 6. Known traps

1. **Signage name ≠ legal name ≠ OSM name.** The IRS says `FIRST BAPTIST CHURCH OF
   SPRINGFIELD INC`; the sign says `Springfield First Baptist`; OSM says `First Baptist
   Church`. Pick one authority per question and say which one.
2. **Closed institutions.** POI data is full of ghosts, and museums close constantly.
   Duplicate counts inflate if we count the dead. Overture confidence and cross-source
   presence help prioritize research; current operation needs source checks. Keep
   excluded records and evidence rather than deleting them.
3. **Chains masquerading as collisions** — see §4.4.
4. **The First Baptist duplication has a history.** Many Southern towns hold two
   congregations with near-identical names because of post-Reconstruction racial splits,
   commonly `First Baptist Church` alongside `First African Baptist Church` (or, in the
   historical record, `First Baptist Church (Colored)`). Any honest analysis of "why do
   some towns have two Firsts" runs straight into this. It is real, well documented, and
   probably one of the most substantive findings available.
   **Decided: its own post (D4).** Post 2 surfaces the pattern in the exclusivity data,
   names it plainly, and points forward; it does not try to tell the history in a
   sub-section. Post 4 does that with proper historical sourcing — denominational
   histories, NRHP nominations (which frequently narrate exactly this split in their
   significance statements), and secondary literature — rather than inferring history from
   POI names, which the name data alone cannot support.
5. **Denomination is not clean.** "Baptist" spans SBC, ABC-USA, NBC, CBF, and thousands of
   independents. Report at the granularity the data supports, not the granularity that
   makes a better sentence.
6. **`First Church of Christ, Scientist`** and its kin — the ordinal-parser trap. Maintain
   an explicit exception list, under test.
7. **Survivorship in the ladder.** A missing Third may never have existed, or may have
   burned down in 1911.

---

## 7. Technical architecture

**The blog is R blogdown (Hugo + R Markdown), so the project is R end to end.** This is the
right call regardless of convenience: analysis and publication share one language, ggplot2
figures knit directly into posts, and the existing R library already carries most of what's
needed. Python is not used.

**Use R 4.4, preferably the lockfile version 4.4.2.** Restore dependencies with
`renv::restore()` rather than relying on a machine's user library or newest R installation.
Use the selective museum build in [README.md](README.md#running) while reviewing.
A full `targets::tar_make()` can overwrite the working label sheet; archive new labels
first. Run `source("tests/testthat.R")` for tests; it sources this non-package project's
functions first.

The current layout is below. Named post bundles will be created during their analysis
phases; only the shared setup and template exist today.

```
duplicate-names/                # analysis repo; source of truth
  DESIGN.md
  HANDOFF.md
  README.md
  AGENTS.md
  LEADS.md
  duplicate-names.Rproj
  renv.lock                     # pinned to R 4.4
  _targets.R                    # pipeline DAG
  R/
    src_*.R                     # one file per source: overture, osm, gnis, imls, hifld
    normalize.R                 # §4 — the ladder, extraction, exceptions
    gazetteer.R                 # L3 place-name stripping and exceptions
    resolve.R                   # §4.3 entity resolution and counting policy
    validate_resolution.R       # sample generation and human-label scoring
    metrics.R                   # §5, one function per named metric
    museums.R                   # category/affiliation/subject analysis and review exports
    museum_identity.R           # explicit corrections over the automatic baseline
    museum_review_context.R     # IMLS names, EIN and separate physical/mailing addresses
    config_blog.R               # blog paths and presentation settings
    theme_dupnames.R            # shared ggplot2 theme + palette
    embed.R                     # builds self-contained widget HTML
  data/
    raw/                        # cached inputs; tracked museum-input manifest
    processed/                  # baseline/reviewed parquet, review exports and labelling sheet
    validation/                 # tracked labels, sourced decisions, evidence and reports
  scripts/archive_museum_review.R # review-sheet archive helper; see README limitations
  tests/testthat/               # normalization, schema, metrics and curated-review tests
  posts/
    _setup.R                    # shared plotting and payload helpers
    _template/index.Rmd         # skeleton for future post bundles
  embeds/                       # self-contained widget HTML → blog's static/embeds/
  dashboard/                    # Phase 4
```

**Two repos, one direction of flow.** This repo owns the pipeline and drafts the posts; the
blog repo receives a *payload* — `index.Rmd`, the small data files it reads, and prebuilt
embed HTML. The blog repo never needs `duckdb`, `sf`, or `arrow` to build the site, and its
`renv` library stays untouched. This is a publication requirement, not yet a verified
export path: the current template sources helpers through `DUPNAMES_ROOT`, and those
helpers must be packaged with the bundle. Use CSV payloads for a blog build without
`arrow`; the shared reader also supports Parquet, which would require it.

**Scope: US-first, global follow-up.** Analysis and both near-term posts are US-only, but
Phase 1 pays a small generality tax so a global pass is cheap later: no US-specific columns
in the core schema, country code on every entity, and the place-name gazetteer treated as a
pluggable source rather than "Census places" hardcoded. The two things that genuinely do
not generalize — the municipal-exclusivity denominator and denomination tagging density —
get isolated behind country-scoped modules so their absence degrades gracefully rather than
breaking the pipeline.

**Stack.** DuckDB (spatial + httpfs extensions) queries Overture's remote GeoParquet
with predicate pushdown. R handles normalization, resolution and metrics; `targets`
stores intermediate objects as RDS. `arrow` supplies source caches and the baseline/
reviewed Parquet exports. `sf` handles spatial operations; Voronoi territory polygons
(`st_voronoi`) remain planned church-analysis work. `tigris` supplies Census places,
`stringdist` fuzzy name matching, and `stringi` Unicode normalization (§4.1).

**Distance correctness.** `sf` uses s2 geometry for geographic coordinates by default, so
`st_distance()` on lon/lat returns true great-circle distances — use `st_nearest_feature()`
plus `st_distance()` for the territory-radius metric. Do **not** project to a national CRS
(Albers, Web Mercator) and measure Euclidean distance; at the national scale that distorts
the exact quantity §5 reports. If s2 proves too slow across ~250k points, the fallback is
`nngeo::st_nn` or a k-d tree on ECEF coordinates, not a projection shortcut.

**Pipeline orchestration.** `targets` for the DAG. The pipeline has a handful of expensive,
cacheable stages (Overture pull, normalization, entity resolution) and a long tail of cheap
downstream metrics, which is precisely the shape `targets` handles well — change a metric,
re-run seconds instead of an hour. If `targets` is unfamiliar territory, numbered scripts in
`R/` writing to `data/processed/` is an acceptable substitute; the cost is manual cache
discipline. `testthat` for the §4 gold-set tests.

**Reproducibility.** `data/raw/MANIFEST.json` records the museum inputs and research
acquisitions with provenance, retrieval time and SHA-256. Dated review packets preserve
decision inputs, evidence and checksums. The Census gazetteer is pinned to 2023 in code
but still lacks manifest coverage. `dn_fetch()` checks cached downloads against their
recorded hash; a supplied `expect_sha256` also guards new downloads. Source adapters
can read existing Parquet caches directly, so manifest hashes should not be described
as an automatic check on every pipeline run. The [validation index](data/validation/README.md)
maps current decision inputs to the dated checkpoints. Archive manifests record file
contents at a checkpoint; later documentation and live decision edits do not justify
rewriting historical hashes. The general archive helper reads saved targets and omits
identity artifacts; see [README.md](README.md#running) before preserving a new review.

**Two renv gotchas, both hit during Phase 0 and both now handled in `setup-renv.R`:**

- renv's default *implicit* snapshot records only packages referenced in code *today*, which
  silently dropped `sf`, `mapgl`, `stringdist` and `svglite` — every package a Phase 1 stub
  has committed to but not yet called. The project uses **explicit** snapshots driven by
  `DESCRIPTION` instead.
- That `DESCRIPTION` must declare **`Type: Project`** and must **not** carry a `Package:`
  field. With one, renv classifies the project as an R package and relocates the library
  from `renv/library` into the cache, orphaning everything already installed. Also note the
  default dependency fields are Imports/Depends/LinkingTo — `Suggests` is not scanned, so
  everything the project needs goes in `Imports`.

**Licensing — matters, because this gets published.** OSM is ODbL: a derived database
distributed publicly carries share-alike and attribution obligations. Overture Places is
CDLA-Permissive/Apache, much friendlier. *Recommendation:* build the publishable derived
dataset on the permissive sources (Overture + GNIS + IMLS + HIFLD, all permissive or public
domain) and use OSM as an internal enrichment and validation layer whose contribution stays
out of the released tables. If OSM tags end up load-bearing in the released data, license
the release ODbL and attribute properly. Decide before publishing, not after.

### 7.1 Publishing into blogdown

**Charts: ggplot2 chunks, knitted in the post.** A shared `theme_dupnames()` keeps the two
posts visually consistent. The shared setup uses `dev = "svglite"` for SVG line/bar work;
switch to knitr's `dev = "ragg_png"` at `dpi = 192` for tens of thousands of overplotted points, where SVG file
size explodes.

**Maps: self-contained widget HTML, iframed — not inline widgets.** Build with
`htmlwidgets::saveWidget(map, "embeds/xxx.html", selfcontained = TRUE)`, ship to the blog's
`static/embeds/`, and reference as `<iframe src="/embeds/xxx.html">`.

This route is deliberate, because blogdown has a trap here. **`.Rmarkdown` files are
rendered to Markdown by Hugo and cannot carry HTML dependencies — htmlwidgets simply fail.**
Only `.Rmd` (Pandoc → HTML, `output: blogdown::html_page`) supports inline widgets. Rather
than forcing the file-format choice, the iframe route works with either, and buys three
other things: page weight stays down until the reader scrolls, the embed can't collide with
the Hugo theme's CSS, and **the same files become the Phase 4 dashboard** with no rework.

So the **territory maps live inside post 2**, which matters: the C2 result is a map result,
and sending a reader off to a separate dashboard to see the central finding would gut the
post.

Two constraints follow. Each embed must be genuinely standalone, since an iframe inherits
no CSS or JS from the host page. And each needs a deliberate static fallback for RSS
readers and iframe-blockers — build the still image as its own considered key view rather
than screenshotting at the end.

**Widget library: `mapgl`** (Kyle Walker; CRAN) for the point-density maps. It wraps
MapLibre GL JS, renders tens of thousands of points on WebGL where `leaflet` starts to
struggle, and supports PMTiles — which keeps the Phase 4 path open. `leaflet` is already
installed and fine for anything simple; `reactable` for the sortable duplicate-rank tables,
which is a better fit than a static table for "here are the top 200 collisions."

**Never knit the pipeline.** blogdown re-knits `.Rmd` on site rebuilds, so a post must never
trigger an Overture query. Post chunks read only small pre-aggregated files from
`payload/` and plot them. Ship each post as a **Hugo page bundle** —
`content/post/<slug>/index.Rmd` with its data files alongside — so knit-time paths resolve
relative to the post and the files publish as page resources, which conveniently also lets
readers download the data behind each chart.

### 7.2 Dashboard (Phase 4)

The dashboard is the *generalized* version of the post-2 embeds — same `mapgl` rendering
stack, arbitrary category instead of churches — which is the argument for building those
embeds with its eventual shape in mind from the start.

**Static vs. Shiny is a real decision, deferred to Phase 4.** A static `mapgl` page drops
into the blog's `static/` and needs no server, no cost, and no maintenance; filtering is
limited to what can be pushed into the client. Shiny (which `mapgl` supports directly) gives
real querying but needs hosting — shinyapps.io or Posit Connect — which is a different
operational commitment than a blogdown site. Static first is the recommendation; revisit
only if the interactions the posts suggest genuinely can't be done client-side.

**Required of the map, not optional:** every entity that carries `alt_names` must expose
them — a footnote, a popup line, whatever fits — because the map is where the merge
decisions become visible. A reader looking at one pin labelled "Washington County
Historical Museum" is entitled to know that the historical society at the same address was
folded into it (§9 decision 7).

At our scale — tens of thousands of points, not millions — plain GeoJSON is sufficient and
no tiling is required. Should PMTiles become necessary later, note that `tippecanoe` does
not build natively on Windows: that would mean WSL, and it is a reason to avoid needing
tiles at all.

**Pandoc** is not on `PATH` but ships with RStudio; if the pipeline ever renders outside
RStudio, check `rmarkdown::pandoc_available()` and set `RSTUDIO_PANDOC`.

### 7.3 Blog defaults (adjustable)

The blog repo is being reworked, so these are chosen defaults rather than measured facts.
Paths, widths, slugs and embed settings live in **`R/config_blog.R`**. Knitr's figure
device, aspect ratio and output-width defaults live in **`posts/_setup.R`**, which reads
that configuration. Adjust these shared settings when the blog repo settles.

| Knob | Default | Why, and what changes it |
|---|---|---|
| Blog repo path | `$DUPNAMES_BLOG_DIR`, else `../blog` | Set in `~/.Renviron` so it survives sessions |
| Post format | **`.Rmd`** | `.Rmarkdown` cannot carry HTML dependencies, so it forecloses inline widgets permanently. Maps are iframed either way, so `.Rmd` costs nothing today and keeps the option open — plus Pandoc footnotes and citations, which a source-heavy post wants. Switching later is a rename and a rebuild. |
| Post structure | Leaf page bundle: `content/post/<slug>/index.Rmd` | Data travels with the post and publishes as page resources, so readers can download the numbers behind a chart |
| Content width | **720 px → `fig.width = 7.5`** | Most Hugo themes land at 700–800; 720 divides cleanly by 96 dpi. Measure the real column once and change this one number. |
| Figure device | `svglite`, `fig.asp = 0.618`, `out.width = "100%"` | Shared knitr defaults in `posts/_setup.R`; override to `ragg_png` at `dpi = 192` for heavy point plots |
| Code visibility | `echo = FALSE` | General-audience blog; the code is public in this repo anyway |
| Embed location | `static/embeds/duplicate-names/` → `/embeds/duplicate-names/` | Namespaced so future projects can't collide |
| Embed height | 520 px, per-embed override | — |
| Slugs | `duplicate-museum-names`, `duplicate-church-names`, `church-naming-over-time`, `the-other-first-baptist` | Plain and searchable over clever. These become permanent URLs, so worth disliking now rather than after publication. |

**Palette and theme** are fixed in `R/theme_dupnames.R`, taken verbatim from a validated
reference palette rather than invented. Two things there are load-bearing and should not be
adjusted casually:

- **The slot order is the colourblind-safety mechanism**, not cosmetics. Reordering or
  inserting a ninth hue breaks the adjacent-pair guarantees.
- **Series caps differ by chart form.** Stacked/grouped bars and lines control which pairs
  touch, so all 8 slots are safe. Maps, scatter, and small multiples can put *any* pair side
  by side, and only the **first 3 slots** clear the floors. This bites post 2 directly: the
  denomination map cannot use one colour per denomination. Fold the tail into "Other" or
  facet. `dn_pal()` enforces the cap and errors rather than silently recycling.

The reference palette values remain unmodified. Swapping in different hues requires
running the palette validator in an environment with its dependencies; the original setup
did not have `node` available.

Supporting files now in place: `R/config_blog.R`, `R/theme_dupnames.R`, `R/embed.R`,
`posts/_setup.R` (shared knitr defaults), `posts/_template/index.Rmd` (post skeleton).

---

## 8. Phases

| Phase | Work | Exit criterion |
|---|---|---|
| **0. Scaffold** ✅ **done 2026-09-07** | `git init`, RStudio project, renv pinned to R 4.4 (138 packages), schema contract, manifest machinery, source stubs, gold-set tests | ✅ `targets::tar_make()` runs end to end; 42 tests pass; `entities.parquet` written with 0 rows / 31 cols matching the contract |
| **1a. Acquire + resolve — MUSEUMS** ✅ **milestone met 2026-09-15** | Overture + IMLS; the L3 gazetteer; entity resolution; 300 human-labelled pairs scored | Museum entities generated and pair-level validation measured; final clusters and multi-site cases remain subject to review (§4.3) |
| **2. Museums analysis → D1** ◀ **in progress** | Analysis tooling and focused source/identity passes complete; remaining top-20 checks, then figures and draft | Post 1 knits from its bundle and small payloads without the analysis checkout or pipeline; every headline number checked against evidence |
| **1b. Acquire + resolve — CHURCHES** | GNIS, HIFLD, OSM, Overture religious categories; Census places denominator | Same, extended to ~250k congregations |
| **3. Churches analysis → D2** | C1–C4; territory maps as `mapgl` embeds; ladder; naming cultures; emit the multiplicity list for post 4 | Post 2 drafted; embeds load standalone in a bare browser tab and have static fallbacks |
| **4. Dashboard → D6** | Generalize the post-2 embeds into an arbitrary-category explorer | Deployed and queryable beyond churches and museums |
| **5. Post 4 → D4** *(later)* | Historical sourcing on the multiplicity list from Phase 3 | — |
| **6. Post 3 → D3** *(later)* | Founding-date acquisition; cohort analysis | — |

Phases 2 and 3 feed `LEADS.md` continuously. Phase 1 is the long pole — probably 60% of
total effort to ship posts 1 and 2 — and the temptation to shortcut it should be resisted,
because everything downstream inherits its errors.

Phases 5 and 6 are sequenced after the dashboard on the reasoning that D3 and D4 both need
new data acquisition, while the dashboard needs nothing that Phase 1 hasn't already built.
Reorder freely if the writing momentum runs the other way.

### Immediate Phase 2 deliverable

The cleaned provisional L2 ranking and institution/source review sheets are available;
the [Union County report](data/validation/museum_union_county_review_2026-09-17.md) is the
latest checkpoint: 52,597 counted entities and 52,465 eligible for name analysis.
Six identity corrections reduce Union County Historical Society's exact-name count
from 14 to seven. All four source-conflict rows remain isolated. Albion, Jim Thorpe
and Creston's Historical Village have complete factual reviews; ten Old Jail reviews
and all seven remaining Union County exact-name institutions stay pending. Both groups
still fail the publication gate. Unresolved address/location cases and remaining
top-20 source checks precede publication; the latest packet's
[follow-up queue](data/validation/museum_union_county_review_2026-09-17/follow_up.csv)
also retains cases outside the regenerated top-20 queue.
The [initial Phase 2 report](data/validation/museum_analysis_2026-09-15.md)
preserves the earlier implementation checkpoint.
Category handling, affiliation rules, subject extraction, canonical entity counting and
M2's L2 correction are implemented and tested. Check identities, relevant multi-site
cases, category decisions and affiliations before certifying counts. An assistant can
research official sources and apply supported factual decisions; see the
[first source-verification pass](data/validation/museum_source_review_2026-09-15.md).
The `verified` institution status means the factual review is complete, not that a
human supplied an independent matching label. Record evidence for factual corrections
and use fresh independent human labels to evaluate matching changes. Then export the
post payloads and write the headlines.
This work does not require reopening the matching threshold.

---

## 9. Decisions

Decisions 1–8 were settled 2026-09-07, with implementation clarifications below.
Decisions 9–11 record the museum analysis policy, September 15 validation outcome and
curated correction layer.

1. **Geographic scope — US-first, with a global follow-up.** Both near-term posts are
   US-only; Phase 1 keeps the schema country-general so a global pass is cheap. See §7.
2. **Output format — R blogdown.** Project is R end to end, pinned to R 4.4. ggplot2
   figures knit inline; `mapgl` maps built as self-contained HTML and iframed from
   `static/embeds/`; posts shipped as Hugo page bundles. See §7.1.
3. **Temporal (C5) — deferred to post 3 (D3)**, with its own acquisition phase. Keeps the
   expensive, badly-biased founding-date problem out of post 2's critical path.
4. **First Baptist racial split — its own post (D4).** Post 2 surfaces and names the
   pattern, and emits the municipal multiplicity list; post 4 tells the history with real
   historical sourcing. See §6.4.
5. **Phase 1 runs museums-first, in two halves (1a then 1b).** Post 1 uses Overture +
   IMLS, with Wikidata enrichment still optional and unimplemented. Working on museums
   reaches a publishable post sooner and exercises the normalizer and entity resolution
   on a tractable population before facing ~250k congregations, where the same bugs would
   be slower to find and costlier to fix.

   **Churches are deferred, not dropped.** Phase 1b still owes: GNIS (the 2021 Church
   archive), HIFLD, OSM (for the `denomination` tag C4 depends on), Overture's religious
   categories, and the `tigris` Census-places denominator for C2. The source stubs for all
   of these stay in `R/src_others.R` with their Phase 1 notes intact — nothing about the
   churches work is being unwound, it is queued. The schema in `R/schema.R` is already
   church-shaped (`denomination`, `religion`, `ordinal`, `place_geoid`), so 1b extends the
   pipeline rather than reopening it.

   The one thing to watch: matching validation covers museum source data, leaving
   possible church-specific blind spots. Phase 1b must re-run the gold set with church cases added
   rather than assuming L3 generalizes.
6. **Counting policy — closed museums are excluded from counts but kept in the data.**
   Exclusions are flags with a reason (`counted` / `exclusion_reason`), never deletions, so
   any of them can be audited or reversed by a reader of the published dataset.
7. **The physical institution is the unit of analysis.** Where source evidence establishes
   that museum and society records identify the same museum, count one entity: the museum
   name leads and the society name is preserved in `alt_names`. Co-location or shared
   ownership alone is insufficient; an operator's distinct museums remain separate.
   Same for a documented relocation — the
   International Cryptozoology Museum is one entity, at Bangor, with the Portland records
   retained and flagged rather than dropped.

   **`alt_names` carries a publication obligation, not just bookkeeping.** The eventual map
   must footnote the alternate names, so a reader can see that "Washington County
   Historical Museum" and "Washington County Historical Society" were treated as one place
   and judge that call themselves. The automatic baseline contains 6,181 counted entities
   with an alternate name.

   The old source-row/alias metric gave `washington county historical society` 27;
   canonical-entity counting gives 19 on the baseline. Nine explicit identity cases
   subsequently reduce this name to 16 provisional entities, then the focused LeMoyne
   correction and Venetia source-conflict hold reduce it to 14. The address pass's
   Chipley mailing consolidation reduces it to 13. These are separate changes and
   must be distinguished in the post.
8. **Blog integration — defaulted, not blocked.** The blog repo is mid-rework, so §7.3
   fixes sensible defaults in `R/config_blog.R` and the project proceeds. The iframe
   approach in §7.1 was chosen specifically to be robust to most of the unknowns.
9. **Museum name headlines use L2.** Place names are usually part of museum identity.
   Use `name_expanded` for M1/M2 and retain L3 for geography-stripped comparisons and
   subject analysis. This corrects the original plan's blanket L3 default. M1 follows
   this policy; Phase 2 corrected M2 and the source-row versus entity counting mismatch.
10. **Retain the 0.85 matching threshold after measured validation (2026-09-15).** The
    300-pair sample supports this threshold; lowering it to 0.80 adds 30 false merges
    while recovering only two true matches. Archive the human labels unchanged. The
    result completes the Phase 1a validation milestone without asserting dataset-wide
    accuracy or validating final clusters.
11. **Apply sourced identity corrections in a separate, auditable layer (2026-09-15).**
    Preserve `entities` as the automatic baseline and apply explicit membership through
    `museum_identity_decisions.csv` to produce `museum_records`. Museum analysis uses
    this corrected layer. Keep every source row, original name/coordinate and before/after
    audit. Factual source review can be completed by an assistant; independent human
    labels remain necessary to evaluate matching accuracy (§4.3.1). Contradictory source
    rows may be isolated as `source_conflict` holdouts, with stable separate IDs and
    `reviewed_source_conflict` exclusions. They do not establish identity for either
    institution suggested by their fields, and their disputed aliases must not propagate.

### Still open

- **Confirm against the reworked blog repo when it settles:** the real content column width
  (the only default likely to be visibly wrong), whether `static/` is served at root as
  usual, and the R version its `renv` library pins. All are one-line changes in
  `R/config_blog.R`.
- **Where the published dataset (D7) lives** — GitHub release, Zenodo DOI, or alongside the
  blog. Affects nothing technically, but decide it together with the §7 licensing question.

---

## 10. Cross-references

- Setup and project overview → [`README.md`](README.md)
- Current work and saved counts → [`HANDOFF.md`](HANDOFF.md)
- Validation evidence and limitations → [September 15 report](data/validation/resolution_validation_2026-09-15.md)
- Latest museum counts and remaining review cases → [Union County report](data/validation/museum_union_county_review_2026-09-17.md)
- Live decisions and archived evidence → [validation index](data/validation/README.md)
- Analogous name-collision phenomena → [`LEADS.md`](LEADS.md)
