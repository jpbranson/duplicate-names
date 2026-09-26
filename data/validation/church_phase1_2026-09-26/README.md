# Church acquisition and methodology checkpoint — September 26, 2026

Work is ongoing; this is not a completed church analysis or published result.
The museum packets and decision inputs are protected by `protected_files.csv`.
The separate `_targets_churches.R` / `_targets_churches` DAG leaves the museum
store and its completed label sheet untouched.

## Source selection

- Overture release **2026-08-19.0**: 545,776 US-address records in the full
  `place_of_worship` taxonomy hierarchy plus `religious_organization` holdouts.
  Its 1,943-row category inventory and exact SQL are retained here/in the manifest.
  A `%religious%` primary-category query would miss the principal church classes.
  The September schema removed the older categories field, so this acquisition
  intentionally retains the existing August pin. Original and new category fields
  are both cached. [Schema notes](https://docs.overturemaps.org/guides/places/).
- GNIS: 231,707 Church features in 50 states/DC from the **2021-08-25** official
  national archive. 8,930 names explicitly say historical. A feature can be a
  building or historical congregation; none is evidence of current operation.
  The source edit date uses `DATE_EDITED`; the first cache version's missing date
  mapping is preserved and superseded by `gnis_church_20210825_v2.parquet`.
  [Official archive description](https://www.usgs.gov/us-board-on-geographic-names/download-gnis-data).
- HIFLD: **254,740** unique legal-name/address records from the public FEMA service
  `495cc33ef490462ab2d8933247a66a87`, referenced by EPA's IRS 2024 catalog item.
  The original HIFLD endpoint returned unavailable; no private service was accessed.
  The adapter verified all 128 page sizes, unique FIDs and unchanged data modification
  time. Service timestamps are not congregation update dates. EIN and address/geocode
  metadata are retained separately. Its latitude extent omits Hawaii; absence from
  this source is not absence of a congregation. [EPA source description](https://www.arcgis.com/sharing/rest/content/items/02934d1d566c4ce6b48887f767e3cfab/info/metadata/metadata.xml?format=default&output=html).
- Census **2023 full TIGER/Line**: 32,037 incorporated places/CDPs and 51 state/DC
  polygons. Full boundaries support the spatial denominator; CDPs are distinguished
  from municipalities. Outside-place points and ambiguous boundary matches are
  retained, not assigned to the nearest town. Every archive has a manifest checksum.
- OSM: eight predetermined metro bounding boxes for internal validation. All eight
  are cached after paced retries, with 5,234 elements before duplicate-ID handling. These are bounded
  regional samples, not national coverage. ODbL input stays out of the permissive
  derived tables and is not a substitute for independent human labels.
  [Overpass usage guidance](https://dev.overpass-api.de/overpass-doc/en/preface/commons.html).

No paid account, cloud compute resource, paid geocoder or external correspondence
was used. Cloud resources USD 0. All calculations run locally in pinned R 4.4.2.

## Provisional analysis scope and changes

The raw union retains 1,032,223 records. Current provisional name analysis uses
Overture's Christian worship categories within 50 states/DC, one chosen row per
local automatic cluster. Other religions, broad organizations, missing names,
source closures and out-of-scope points remain auditable holds. This scope reflects
source classification and does not establish anyone's religious identity.

GNIS and HIFLD remain historical/legal comparison records. Their candidate matches
are exported for fresh independent review; imprecise tax addresses cannot bridge
current Overture churches. Repeated distant names are never merged by the museum
multi-site heuristic. The retained 0.85 similarity score gets church-specific guards
against conflicting ordinals, denomination families and transitive contradictions.
These rules need independent evaluation; museum pair-level accuracy does not transfer.
Multi-campus congregations still require institutional review. Provisional counts
are worship-site candidates, not certified independent congregations.

Church-only extraction handles spelled and numeric ordinals through 999, protects
numbered streets and doctrinal proper names, and preserves all name levels. Larger
or novel forms remain unparsed and reviewable. Broad denomination families use source
categories where available and name heuristics otherwise; conflicts are preserved
and withheld from family metrics. Baptist labels do not establish a convention.
Naming-style lexicons remain unvalidated until independent human labels are supplied.
No museum normalization rule or original gold expectation was changed.

C1 uses L3 and reports L2/L4 sensitivity. C2 uses great-circle nearest OTHER sites,
including zero-distance other institutions and leaving singleton classes undefined.
Its occupied-place denominator includes places with zero Firsts. An incorporated-only
cut is separate from the all-Census-place cut. C3 counts distinct observed rungs;
missing rungs do not establish historical closures or splits. C4 proportions describe
automatic labels pending validation. Municipal multiplicity is a named future-research
artifact; names alone do not establish racial or historical causes.

## Validation and remaining work

**322 unit assertions, 18 national-output checks and six museum preservation checks
pass.** All 453 protected evidence/label files are unchanged. The national build
retains 1,032,223 source rows, 540,778 canonical Overture entities and 442,834 eligible
provisional Christian worship sites. Four otherwise-counted source points are outside
the 50-state/DC geography. Review exclusions remain in the analysis export.

A substantive C2 correction followed initial draft inspection: First Mesa Baptist
Church is a place-qualified name, not ordinal one. Parsing the L3 core removes that
false ordinal. The distance exporter also now limits both endpoints to the First
cohort, so a stripped Baptist Church key cannot pull all Baptist Church rows into
C2. The superseded territory summary and first blank-label packet are preserved.
Use **independent_review_v2/**: 300 blank matching pairs, 500 blank classifier labels,
separate predictions/strata and the final-cluster queue. No truth labels are filled.
The museum sample's measured precision/recall does not transfer to churches.

The church post builds in an isolated copy without the analysis checkout/profile.
Its self-contained map uses pinned mapgl/MapLibre, 7,010 provisional First Baptist
points, display aliases, region controls and a static PNG fallback. No remote tiles
or map charges. Windows Unicode and empty-style-object rendering problems were
found in browser QA and fixed; failed build/diagnostic logs remain here. HTML entity
encoding preserves the visible Unicode alias while keeping the display GeoJSON ASCII;
raw source fields and the CSV remain unchanged.

The static explorer source and data are built separately under dashboard/. Its
serialized payload checks and UI observations are in the dashboard evidence packet.
Independent labels, church leading-name/high-ordinal factual reviews, final identity
validation and museum headline checks remain incomplete. Both posts remain drafts,
and deployment needs the missing blog destination. No national church record or
museum winner is certified. Cloud resource spending remains USD 0.
