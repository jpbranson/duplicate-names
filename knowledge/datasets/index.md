# References

* [Data sources overview](overview.md) - Implemented inputs, research acquisitions, the primary spine, supporting temporal sources and sources deliberately not used.

# Datasets

* [Overture Maps Places](overture-places.md) - Primary spine for both pipelines: Overture Places release 2026-08-19.0, queried in place with DuckDB for museums and places of worship.
* [IMLS Museum Universe Data File (2018)](imls-mudf.md) - Second museum source: the 2018 IMLS Museum Universe Data File CSV archive, a historical list that never updates.
* [GNIS 2021 archived snapshot (Church class)](gnis-2021.md) - Frozen, public-domain USGS snapshot of about 230k US churches from the retired Church feature class, used by the church pipeline.
* [HIFLD All Places of Worship](hifld-places-of-worship.md) - Independent third church source built from IRS 501(c)(3) master files, so it records legal names rather than signage names.
* [Census 2023 TIGER/Line places, counties and states](census-tiger.md) - Census 2023 geography: the L3 place-name gazetteer for both pipelines and the C2 municipal denominator for churches.
* [OpenStreetMap (internal validation only)](openstreetmap.md) - OSM place-of-worship tags for eight metro areas, cached as an internal validation sample and kept out of released tables because of ODbL.
* [IRS exempt-organization files](irs-exempt-organizations.md) - IRS Business Master File state extracts and the revocation list: evidence for museum identity research, and a weak planned founding-date proxy for C5.
* [Wikidata](wikidata.md) - Inception dates, instance-of museum/church building, operator chains and disambiguation pages.
* [National Register of Historic Places](nrhp.md) - Construction and listing dates for historic churches from the NPGallery bulk spreadsheet (90k+ properties).
* [Denominational directories](denominational-directories.md) - Several denominations publish congregation lists with organization years.
