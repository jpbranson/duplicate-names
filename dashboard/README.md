# Duplicate-name research explorer

Static, local-first implementation for the museum and church snapshots. It shows
L2/L3 comparisons, names, source aliases, factual-review status, affiliation and
holds. Museum defaults exclude known chains without calling unknowns independent.
Church counts remain provisional worship sites. No headline or accuracy gate is
cleared by this interface. Arbitrary categories can be explored through a local
canonical-record CSV; the included parks example is explicitly fictional.

Build from the repository root with R 4.4.2 after both target stores are current:

```r
Sys.setenv(DUPNAMES_DASHBOARD_EVIDENCE='data/processed/dashboard_validation')
source('dashboard/build_data.R')
```

Set the same `DUPNAMES_DASHBOARD_EVIDENCE` path for `node dashboard/validate-data.cjs`.
Use a fresh dated evidence directory for each new review checkpoint. The default
is a disposable processed-output folder, so rebuilding never overwrites archived
validation evidence. The September 26 initial packet is retained unchanged.

Serve `dashboard/` with a static HTTP server bound to localhost. Open `index.html`.
The browser decompresses small, name-indexed JSON buckets as needed. It never
loads all 540,000 church entities into the map. Search and filtering happen locally.
No analytics, external queries, tiles, geocoding, credentials or paid services.
The supplied CSV stays in the browser and does not modify canonical project data.

The MapLibre GL JS 5.24.0 assets were copied from pinned mapgl 0.5.0 and retain
their license. Census 2023 boundary display copies are simplified; analysis uses
the original full boundaries. All positions are source coordinates. Museum
publication-point overrides are not silently applied to research records.

Generated `data/` is reproducible and ignored by Git; its checksums and build
metadata for the latest refresh are retained in
`data/validation/church_ordinal_review_2026-09-26/`; the initial
`data/validation/dashboard_2026-09-26/` packet remains unchanged. Deploy the entire
dashboard folder, including generated data and vendor assets, to static hosting
only after choosing the destination and an appropriate publication state.
Deployment is currently blocked by the missing blog destination; the local build
is a draft research tool. Rebuild after any analysis decision changes.

Validation: `node dashboard/test-data.cjs` covers CSV quoting, invalid identities,
coordinates, boolean inputs, affiliation/scope counts and spreadsheet-safe CSV
exports; `node dashboard/test-loading.cjs` covers scope changes during pending fetches.
Browser checks cover search, level/scope changes, aliases, map selection,
CSV import/export, mobile layout and console errors. Check the dated QA report
for which checks have actually passed; saving the exported CSV to disk from the
browser remains unverified.
