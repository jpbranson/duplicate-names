# Museum address and map follow-up

**2026-09-15.** Expanded IMLS dossiers support two further consolidations: Chipley's
museum/mailing records and Peters Creek's house/society records. Precise operator map
points are staged separately for publication. Bankhead and Lafayette Street remain
unresolved. This is a factual source review, not a completed headline review or an
independent matching evaluation.

## Count effects

| Measure | Before | After |
|---|---:|---:|
| Source rows retained | 60,002 | 60,002 |
| Counted source rows | 57,329 | 57,327 |
| Counted institutions | 52,619 | 52,617 |
| Eligible for L2 name analysis | 52,487 | 52,485 |
| Washington County Historical Society | 14 | 13 |
| National Vietnam War Museum | 2 | 2 |

Old Jail Museum remains the provisional leader at 15. The live identity input now
covers 33 source rows in 13 cases: 12 canonical institutions and two isolated conflicts.
No institution has a completed overall `verified` review.
[Count comparison](museum_address_review_2026-09-15/count_effects.csv),
[ranking](museum_address_review_2026-09-15/ranking_after.csv).

## Supported corrections

**Chipley.** IMLS `8401200854` supplies EIN `592788489`, a legal preservation-society
name and a mailing address at 206 South 6th Street; its physical address is blank.
The IRS Florida file identifies the same EIN/legal name at **685 7th Street**, the
museum site in the state grant record. County tourism identifies the museum by the
common Washington County Historical Society name, although it calls the road 7th
Avenue. Together these sources link the old mailing record to the current museum;
the IRS filing address alone would not establish a visitor venue. The Overture
museum remains canonical; IMLS is retained with `reviewed_mailing_address`, without
inventing a former physical site.
[IRS Florida extract](https://www.irs.gov/pub/irs-soi/eo_fl.csv),
[county tourism](https://visitwcfla.com/businesses/details/washington-county-historical-society/),
[state grant review](https://files.floridados.gov/media/705801/fy24-small-matching-staff-review-forms.pdf).

**Peters Creek / Enoch Wright House.** The operator identifies its house museum at
815 Venetia Road and publishes coordinates **40.247871, -80.028924**. Both the Enoch
Wright House and Peters Creek Historical Society Overture records fall within 12 m.
Its museum page establishes the house/museum relationship. These two accepted records
now count once under the house name; the society name remains an alias.
[Operator location](https://peterscreekhistoricalsociety.org/location/),
[museum page](https://peterscreekhistoricalsociety.org/enoch-wright-house-and-museum-of-westward-expansion/).

The IRS Pennsylvania row also confirms EIN `251778027` and PO Box 208 in Venetia.
That corroborates the earlier identity lead, but does not repair contradictory IMLS
`8404201308`. Its Washington County name/website and Washington physical-city field
remain mixed. It stays isolated and uncounted, with no disputed aliases transferred
to Peters Creek or LeMoyne. The separate Barrow conflict also stays unchanged.
[IRS Pennsylvania extract](https://www.irs.gov/pub/irs-soi/eo_pa.csv).

The [applied decisions](museum_address_review_2026-09-15/applied_identity_decisions.csv)
list every member of the four affected baseline entities. The
[source-level audit](museum_address_review_2026-09-15/identity_audit.csv) retains all
33 current identity decisions. Original names and coordinates are unchanged.

## Map and access evidence

The [staged publication locations](museum_address_review_2026-09-15/publication_locations.csv)
use separate `publication_lon`/`publication_lat` fields; they are **not yet applied
by the pipeline or Parquet exports**. These are operator-supplied locations, not
surveyed entrances or independent geocoding.

- **Smedley:** the older operator page's public Wix map configuration gives
  **28.5907117, -81.1718752**, about 42 m from Overture and 7.2 km from IMLS. The
  address is 3400 North Tanner Road. The current museum site corroborates the identity
  and lists weekend visits. The public JSON marker was extracted without executing
  page scripts; no connected browser was available. Raw page/data hashes are in the
  manifest and the minimal marker is archived in this packet.
  [Operator contact/map](https://theoriginalbunker.wixsite.com/orlando/contact),
  [current museum](https://www.smedleymuseum.com/).
- **Mandeville:** carry forward the earlier official destination
  **32.8777592, -117.2408635**. Dated visitor wording: *Indoor gallery listed closed
  from May 2 until further notice; exterior Media Mesh programming does not establish
  indoor reopening.* Recheck access before publication; retain the institution count.
  [Official visitor page](https://mandevilleartgallery.ucsd.edu/visit/index.html).
- **Peters Creek:** stage the operator's GPS point with its special-event/by-arrangement
  tour wording. The accepted source points already agree within 12 m.

Distances for each supporting source row are saved in
[map checks](museum_address_review_2026-09-15/map_checks.csv), using `sf` with s2.

## Remaining questions

**Bankhead:** no dated institution source establishes the role of 1713 East Bankhead
Drive. Municipal residential evidence is insufficient to infer museum closure or
membership. Keep the candidate unchanged and separate from the accepted Texas museum.

**Lafayette Street:** the current IRS Arkansas row still lists preservation association
EIN `300212518` at 617 West Lafayette Street. IMLS supplied a mailing address, with no
physical address. This confirms the legal organization/address, not current museum
operation or the IMLS common name. Keep it separate from Headquarters House pending
dated museum evidence. [IRS Arkansas extract](https://www.irs.gov/pub/irs-soi/eo_ar.csv).

Florida's registry still required a JavaScript challenge; the IRS file supplied the
Chipley identity bridge instead. The IRS index reports a September 8, 2026 posting;
its addresses are filing/headquarters data. Selected rows, source URLs and raw-file
hashes are preserved. [IRS dataset description](https://www.irs.gov/charities-non-profits/exempt-organizations-business-master-file-extract-eo-bmf).

## Validation and next step

R 4.4.2: **192 passing assertions**, zero test failures/warnings/skips, and **18 passing
integration checks**. Existing Windows locale warnings occurred at startup. The
selective build completed 15 targets and skipped 13. Current review sheets contain
452 institutions, 542 source rows and 149 nearby pairs.

All 63 protected files, including earlier packets and both label copies, are unchanged.
The automatic baseline, baseline multi-site queue, normalized source fields and every
record outside the four accepted members are unchanged. Reviewed and baseline Parquet
exports match their targets. The threshold remains **0.85** and the original label
scores remain 119 true merges, one false merge, eight missed merges and 172 true
separations. Only `labelling_sheet` remains outdated and was not rebuilt.
All ten new raw acquisition hashes match, and earlier manifest entries are unchanged.
The cached Smedley component reproduces its marker. All 102 local links in the updated
project/report documents resolve, and `git diff --check` passes.

Reproduce counts and preservation checks without rebuilding:
`source("data/validation/museum_address_review_2026-09-15/reproduce.R")`.

Next: finish the broader top-20 identity/name/category/affiliation checks, seek dated
museum evidence for Bankhead and Lafayette Street, then wire the staged points into
the publication export with a fresh access check. Headlines and the standalone post
remain later steps. See the [evidence ledger](museum_address_review_2026-09-15/evidence.csv)
and [follow-up queue](museum_address_review_2026-09-15/follow_up.csv).
