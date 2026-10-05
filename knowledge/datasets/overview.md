---
type: Reference
title: "Data sources overview"
description: "Implemented inputs, research acquisitions, the primary spine, supporting temporal sources and sources deliberately not used."
tags: [datasets, provenance]
sequence: 1
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §3, as of commit 7416eef (moved here verbatim)"
---

Availability verified 2026-09-07.

**Implemented inputs:** Overture Places release `2026-08-19.0` and the IMLS 2018 CSV
archive, with provenance in `data/raw/MANIFEST.json`. The church pipeline
(`_targets_churches.R`, 2026-09-26) adds Overture worship categories, the GNIS 2021 archive,
HIFLD and Census 2023 TIGER places/states. OSM is cached for eight metro areas as an
internal validation sample only. Wikidata enrichment is not implemented
and is not a completed Phase 1a dependency.

Phase 2 also uses official institution pages and source address/website metadata for
explicit naming, affiliation and identity decisions. The 38-record Overture context
query uses the same pinned release; its SQL/checksum are in the manifest and a
[tracked copy](../../data/validation/museum_identity_review_2026-09-15/overture_context.csv)
is archived with the identity evidence. The later
[Old Jail context query](../../data/validation/museum_old_jail_review_2026-09-15/overture_context.csv)
adds 41 records from the same release, followed by the 21-row
[Union County query](../../data/validation/museum_union_county_review_2026-09-17/overture_context.csv)
and the 22- and 18-row [leaders queries](../../data/validation/museum_leaders_review_2026-09-23/overture_context.csv).
The manifest also records the address pass's IRS extracts and operator-page caches,
19 pages from the Old Jail review, 30 public documents from the Union County review and
46 from the leaders review, including IRS Kansas/Mississippi extracts and revocations.
These research acquisitions are outside `_targets.R`; their dated packets preserve
the context and extracted evidence needed to review the decisions.
Census 2023 places, counties and states supply the cached normalization gazetteer;
those downloads are not yet included in the manifest.

# Primary spine

| Source | Covers | Why | License |
|---|---|---|---|
| **Overture Maps — Places theme** | Global POIs; categories `museum` (under `arts_and_entertainment`) and `religious_organization`; GeoParquet on S3/Azure | Best single spine: queryable in place via DuckDB `httpfs` without a full download; permissive license; consistent schema; carries confidence scores and source lineage | CDLA-Permissive-2.0 / Apache-2.0 |
| **OpenStreetMap** (Geofabrik NA extract or Overpass) | `tourism=museum`, `amenity=place_of_worship` | Richer tags Overture drops: `denomination`, `religion`, `start_date`, `wikidata`, `operator`, `museum=*` | **ODbL** — share-alike; see [licensing](../architecture/licensing.md) |
| **GNIS 2021 archived snapshot** | ~230k US churches under the retired `Church` feature class | USGS *removed* Church/Cemetery/School classes in 2021 and archived the file unchanged since. A frozen, government-authored, name-rich snapshot — and its staleness is a feature: it predates the modern church-plant naming wave | Public domain |
| **IMLS Museum Universe Data File** | ~30k records from the 2018 CSV archive used by `src_imls()` | Historical museum list with discipline codes; cross-check against Overture. The snapshot does not establish current operation or complete present-day coverage | Public domain |
| **HIFLD "All Places of Worship"** | 254,740 US records, July 2024 snapshot, built from IRS 501(c)(3) master files | Independent third source. IRS-derived, so it captures *legal* names rather than *signage* names — a useful contrast in its own right | Public domain |

# Supporting / temporal

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

# Explicitly not used

- **ARDA / US Religion Census (RCMS)** — county-level counts only, no congregation names.
  Fine for context sentences, useless for name analysis.
- Google Maps or Yelp POI harvesting. Source reviews may compare saved coordinates
  with an institution's own outbound map destination; those checks are documented as
  operator-supplied locations, not independent geocoding validation.
