# Duplicate Names — Development Plan

**Status:** draft plan, awaiting review
**Last updated:** 2026-09-07

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
- M4. Which collisions are franchises/branches (Ripley's, Smithsonian units, Children's
  Museum of X) versus genuinely independent institutions that happen to share a name?
  Only the second kind is interesting.

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

### Primary spine

| Source | Covers | Why | License |
|---|---|---|---|
| **Overture Maps — Places theme** | Global POIs; categories `museum` (under `arts_and_entertainment`) and `religious_organization`; GeoParquet on S3/Azure | Best single spine: queryable in place via DuckDB `httpfs` without a full download; permissive license; consistent schema; carries confidence scores and source lineage | CDLA-Permissive-2.0 / Apache-2.0 |
| **OpenStreetMap** (Geofabrik NA extract or Overpass) | `tourism=museum`, `amenity=place_of_worship` | Richer tags Overture drops: `denomination`, `religion`, `start_date`, `wikidata`, `operator`, `museum=*` | **ODbL** — share-alike; see §7 |
| **GNIS 2021 archived snapshot** | ~230k US churches under the retired `Church` feature class | USGS *removed* Church/Cemetery/School classes in 2021 and archived the file unchanged since. A frozen, government-authored, name-rich snapshot — and its staleness is a feature: it predates the modern church-plant naming wave | Public domain |
| **IMLS Museum Universe Data File** | ~30k US museums; last updated FY2015Q3, no further updates planned | Authoritative museum list with discipline codes. Stale but complete; cross-check against Overture to catch what commercial POI feeds miss | Public domain |
| **HIFLD "All Places of Worship"** | 254,740 US records, July 2024 snapshot, built from IRS 501(c)(3) master files | Independent third source. IRS-derived, so it captures *legal* names rather than *signage* names — a useful contrast in its own right | Public domain |

### Supporting / temporal

**Scope note.** These are **post 3 (D3) sources**, not Phase 1 sources. Nothing in this
table is needed to ship posts 1 and 2, and treating it as optional is what makes the
deferral of C5 cheap rather than merely postponed.

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
- Anything scraped from Google Maps or Yelp. Terms of service, and no reproducibility.

---

## 4. The hard part: name normalization

This is where the project succeeds or fails. Every headline number is an artifact of the
normalizer. It gets its own module, its own test suite, and a paragraph in each post.

### 4.1 Normalization ladder

Each record keeps *all* levels, so sensitivity can be reported rather than hidden:

- **L0 `name_raw`** — as given.
- **L1 `name_clean`** — Unicode NFKC, case-fold, strip punctuation and diacritics, collapse
  whitespace, drop leading `The`.
- **L2 `name_expanded`** — abbreviation expansion: `St.`→`Saint`, `Ft.`→`Fort`,
  `Mt.`→`Mount`, `AME`→`African Methodist Episcopal`, `UMC`→`United Methodist Church`,
  `1st`→`First`, `Ch.`→`Church`, `Assy`→`Assembly`.
- **L3 `name_core`** — strip the locative tail. This is the key operation:
  `First Baptist Church of Springfield` → `First Baptist Church`;
  `Springfield First Baptist Church` → `First Baptist Church`.
  Implemented by matching against a gazetteer of place names (Census places, counties,
  states) at both head and tail positions — not by naive regex.
- **L4 `name_key`** — L3 plus token sort and stopword removal, for fuzzy grouping.

Duplicate counts are reported at **L3** by default, with L1 and L4 counts as a sensitivity
band. A headline that only survives at L4 is not a headline.

### 4.2 Structured extraction

From `name_core`, parse into fields:

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

### 4.3 Entity resolution (deduplicating the *data*, not the *names*)

A single institution appearing in Overture + OSM + GNIS + HIFLD must not count as four
duplicates. Resolution key: normalized name + distance threshold (start at 150 m, tune
against a hand-labelled sample) + address match where available. Cross-source agreement
doubles as the quality signal: a record present in three sources is real; one present only
in a low-confidence commercial POI feed may be a closed storefront.

**This is the single largest correctness risk in the project.** Budget real time for it.

### 4.4 Franchise / branch detection (M4)

Flag same-operator collisions so they can be held out of the "independent collision"
headline: shared `operator` tag, shared Wikidata parent, a known-chain lexicon (Ripley's,
Madame Tussauds, Smithsonian units, Titanic Museum Attraction), and productive-template
detection for `Children's Museum of X` / `X County Historical Museum`.

---

## 5. Metrics — defined before we look

Pre-registered so the analysis can't drift toward whatever looks good.

**Museums**

- `dup_count(name_core)` — headline for M1.
- **Singularity Collision Index** — for names carrying a `scope_claim`, the count of
  independent (non-franchise) institutions sharing `name_core`. The Cryptozoology seed case
  scores whatever it scores; the *ranking* is the story.
- **Genericity split** — partition names into *asserted-unique* vs *descriptive* and report
  the two distributions separately. Conflating them is the obvious analytical mistake and
  the thing most likely to make post 1 wrong.

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
   Duplicate counts inflate if we count the dead. Use Overture confidence plus cross-source
   presence.
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

Environment on this machine: R 4.6.1 plus 4.2–4.5 under `C:\Program Files\R`; RStudio;
`git`; `curl`. **Note:** R 4.6.1's library is empty — the populated user library is
**4.4** (230 packages), which already has `tidyverse`, `sf`, `arrow`, `leaflet`, `tigris`,
`tidycensus`, `reactable`, `renv`, `knitr`, `rmarkdown`. **Pin the project to R 4.4.** Still
to install: `duckdb`, `targets`, `stringdist`, `mapgl`, and `blogdown` (absent from every
user library, so it presumably lives in the blog repo's own `renv` library).

`tigris` and `tidycensus` already being present matters more than it looks: the Census
places denominator for the C2 municipal-exclusivity test — the most likely real finding in
post 2 — is a `tigris::places()` call away.

```
duplicate-names/                # analysis repo; source of truth
  DESIGN.md
  LEADS.md
  duplicate-names.Rproj
  renv.lock                     # pinned to R 4.4
  _targets.R                    # pipeline DAG
  R/
    src_*.R                     # one file per source: overture, osm, gnis, imls, hifld
    normalize_*.R               # §4 — the ladder, extraction, exceptions
    resolve_*.R                 # §4.3 entity resolution
    metrics_*.R                 # §5, one function per named metric
    theme_dupnames.R            # shared ggplot2 theme + palette
    embed_*.R                   # builds self-contained widget HTML
  data/
    raw/                        # immutable downloads, gitignored, manifest-tracked
    processed/                  # parquet artifacts; the publishable dataset
  tests/testthat/               # gold-set tests for the normalizer
  posts/
    01-museums/
      index.Rmd                 # drafted here, copied to the blog as a page bundle
      payload/                  # the small aggregated files the .Rmd reads
    02-churches/
    03-over-time/               # D3, later
    04-first-baptist/           # D4, later
  embeds/                       # self-contained widget HTML → blog's static/embeds/
  dashboard/                    # Phase 4
```

**Two repos, one direction of flow.** This repo owns the pipeline and drafts the posts; the
blog repo receives a *payload* — `index.Rmd`, the small data files it reads, and prebuilt
embed HTML. The blog repo never needs `duckdb`, `sf`, or `arrow` to build the site, and its
`renv` library stays untouched.

**Scope: US-first, global follow-up.** Analysis and both near-term posts are US-only, but
Phase 1 pays a small generality tax so a global pass is cheap later: no US-specific columns
in the core schema, country code on every entity, and the place-name gazetteer treated as a
pluggable source rather than "Census places" hardcoded. The two things that genuinely do
not generalize — the municipal-exclusivity denominator and denomination tagging density —
get isolated behind country-scoped modules so their absence degrades gracefully rather than
breaking the pipeline.

**Stack.** DuckDB (spatial + httpfs extensions) via the `duckdb` R package as the engine —
it queries Overture's remote GeoParquet directly with predicate pushdown, so we never
download the planet, and the heavy work stays in SQL rather than in R memory. `arrow` +
Parquet for every intermediate. `sf` for spatial operations and Voronoi territory polygons
(`st_voronoi`). `tigris` for Census places, `stringdist` for fuzzy name matching,
`stringi` for the Unicode normalization in §4.1.

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

**Reproducibility.** Every download recorded in `data/raw/MANIFEST.json` with URL, fetch
date, and SHA-256. Sources shift under you; the manifest is what makes a published number
defensible a year later. `dn_fetch()` treats a checksum change as an *error*, not a cue to
re-download — a source changing underneath a published figure is the event the machinery
exists to catch.

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
posts visually consistent. Set `dev = "svg"` for line/bar work; switch to `ragg::agg_png`
at `dpi = 192` for anything with tens of thousands of overplotted points, where SVG file
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

At our scale — tens of thousands of points, not millions — plain GeoJSON is sufficient and
no tiling is required. Should PMTiles become necessary later, note that `tippecanoe` does
not build natively on Windows: that would mean WSL, and it is a reason to avoid needing
tiles at all.

**Pandoc** is not on `PATH` but ships with RStudio; if the pipeline ever renders outside
RStudio, check `rmarkdown::pandoc_available()` and set `RSTUDIO_PANDOC`.

### 7.3 Blog defaults (adjustable)

The blog repo is being reworked, so these are chosen defaults rather than measured facts.
**Every one of them lives in `R/config_blog.R`** — one file to edit when the repo settles,
and nothing downstream hardcodes a path, a width, or a URL.

| Knob | Default | Why, and what changes it |
|---|---|---|
| Blog repo path | `$DUPNAMES_BLOG_DIR`, else `../blog` | Set in `~/.Renviron` so it survives sessions |
| Post format | **`.Rmd`** | `.Rmarkdown` cannot carry HTML dependencies, so it forecloses inline widgets permanently. Maps are iframed either way, so `.Rmd` costs nothing today and keeps the option open — plus Pandoc footnotes and citations, which a source-heavy post wants. Switching later is a rename and a rebuild. |
| Post structure | Leaf page bundle: `content/post/<slug>/index.Rmd` | Data travels with the post and publishes as page resources, so readers can download the numbers behind a chart |
| Content width | **720 px → `fig.width = 7.5`** | Most Hugo themes land at 700–800; 720 divides cleanly by 96 dpi. Measure the real column once and change this one number. |
| Figure device | `svg`, `fig.asp = 0.618`, `out.width = "100%"` | Per-chunk override to `ragg_png` at `dpi = 192` for heavy point plots, where SVG size explodes |
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

`node` is not installed on this machine, so the palette validator cannot be run here — which
is precisely why the reference values are used unmodified. Swapping in different hues later
means running the validator, not eyeballing the result.

Supporting files now in place: `R/config_blog.R`, `R/theme_dupnames.R`, `R/embed.R`,
`posts/_setup.R` (shared knitr defaults), `posts/_template/index.Rmd` (post skeleton).

---

## 8. Phases

| Phase | Work | Exit criterion |
|---|---|---|
| **0. Scaffold** ✅ **done 2026-09-07** | `git init`, RStudio project, renv pinned to R 4.4 (138 packages), schema contract, manifest machinery, source stubs, gold-set tests | ✅ `targets::tar_make()` runs end to end; 42 tests pass; `entities.parquet` written with 0 rows / 31 cols matching the contract |
| **1a. Acquire + resolve — MUSEUMS** ◀ *current* | Overture (museum categories) + IMLS + Wikidata; the L3 gazetteer; entity resolution | `entities.parquet` covering museums, plus a measured resolution error rate on a hand-labelled sample |
| **2. Museums analysis → D1** | M1–M4; verify top-20 collisions by hand; ggplot2 figures + `reactable` rank table; draft `index.Rmd` | Post 1 knits from `payload/` alone with no pipeline dependency; every headline number hand-verified |
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

---

## 9. Decisions

Settled 2026-09-07:

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
5. **Phase 1 runs museums-first, in two halves (1a then 1b).** Post 1 needs only Overture +
   IMLS + Wikidata over ~30k museums, which reaches a publishable post sooner and proves the
   normalizer and entity resolution on a tractable population before facing ~250k
   congregations, where the same bugs would be slower to find and costlier to fix.

   **Churches are deferred, not dropped.** Phase 1b still owes: GNIS (the 2021 Church
   archive), HIFLD, OSM (for the `denomination` tag C4 depends on), Overture's religious
   categories, and the `tigris` Census-places denominator for C2. The source stubs for all
   of these stay in `R/src_others.R` with their Phase 1 notes intact — nothing about the
   churches work is being unwound, it is queued. The schema in `R/schema.R` is already
   church-shaped (`denomination`, `religion`, `ordinal`, `place_geoid`), so 1b extends the
   pipeline rather than reopening it.

   The one thing to watch: a normalizer tuned only against museum names will have
   museum-shaped blind spots. Phase 1b must re-run the gold set with church cases added
   rather than assuming L3 generalizes.
6. **Blog integration — defaulted, not blocked.** The blog repo is mid-rework, so §7.3
   fixes sensible defaults in `R/config_blog.R` and the project proceeds. The iframe
   approach in §7.1 was chosen specifically to be robust to most of the unknowns.

### Still open

- **Confirm against the reworked blog repo when it settles:** the real content column width
  (the only default likely to be visibly wrong), whether `static/` is served at root as
  usual, and the R version its `renv` library pins. All are one-line changes in
  `R/config_blog.R`.
- **Where the published dataset (D7) lives** — GitHub release, Zenodo DOI, or alongside the
  blog. Affects nothing technically, but decide it together with the §7 licensing question.

---

## 10. Cross-references

- Analogous name-collision phenomena → [`LEADS.md`](LEADS.md)
