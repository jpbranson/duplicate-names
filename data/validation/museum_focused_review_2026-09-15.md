# Museum source review — six focused follow-ups

**2026-09-15.** Reviewed the six cases left by the
[first identity pass](museum_identity_review_2026-09-15.md). Consolidated the clean
LeMoyne House records and isolated two contradictory IMLS rows. Confirmed an
operator-supplied Mandeville map destination. Other identity and visitor-location
questions remain open; this is not a completed top-20 review or matching evaluation.

## Count effects

| Measure | Before | After |
|---|---:|---:|
| Source rows retained | 60,002 | 60,002 |
| Counted source rows | 57,332 | 57,329 |
| Counted entities | 52,621 | 52,619 |
| Eligible for L2 name analysis | 52,489 | 52,487 |
| Washington County Historical Society | 16 | 14 |
| National Vietnam War Museum | 2 | 2 |

The [count comparison](museum_focused_review_2026-09-15/count_effects.csv) and
[updated ranking](museum_focused_review_2026-09-15/ranking_after.csv) preserve this
checkpoint. These remain provisional counts. Washington County Historical Society
now falls below Old Jail Museum (15) in the provisional ranking; neither group is certified.

## Pennsylvania: two source conflicts, one supported consolidation

The [original IMLS rows](museum_focused_review_2026-09-15/imls_original_rows.csv)
reveal information lost by the earlier coalesced address context:

- `8404200022` combines the Pennsylvania society's common name and street address
  with Barrow Gallery's legal name, website and EIN `222260222`. A separate New York
  IMLS record, `8403601781`, already carries that same EIN and legal name at a
  Skaneateles address. Barrow's own site identifies its New York location.
  [Gallery](https://www.barrowgallery.org/).
- `8404201308` gives **Venetia** as its mailing city, despite a Washington physical-city
  field. Its EIN `251778027` and PO Box 208 match Peters Creek Historical Society in
  the community foundation's participating-charity profile. It is not supported as
  a Washington County Historical Society mailbox.
  [Submitted charity profile](https://www.wccf.net/charities/peters-creek-historical-society).
- The clean IMLS record `8404201136` and the Overture LeMoyne House record share the
  museum address. The operator identifies this house as its public museum. Those
  two rows now count as one institution, led by the museum name.
  [Operator evidence](https://wchspa.org/lemoyne-houses/).

The contradictory rows receive `source_conflict` decisions and
`reviewed_source_conflict` exclusions. Each has its own stable holdout ID; neither
is assigned to Barrow, Peters Creek or LeMoyne, and its disputed aliases do not enter
the accepted institution. The New York record is unchanged. A future Peters Creek
review must establish the correct physical museum membership before reassigning
the Venetia row. All original fields remain available in the source and audit.

The correction layer still requires every affected baseline member and checks names,
coordinates and entity IDs. A wholly contradictory case may contain only holdouts;
every case with accepted members still requires one counted canonical record.
[Applied decisions](museum_focused_review_2026-09-15/applied_identity_decisions.csv),
[before/after audit](museum_focused_review_2026-09-15/identity_audit.csv).

## Other five cases

| Case | Result and remaining work |
|---|---|
| Texas Bankhead | No dated museum evidence links 1713 East Bankhead Drive to the accepted institution. A 2020 city residential-plat record raises a location question but cannot establish museum identity or closure. Leave unmerged. |
| Fayetteville Lafayette | Original legal/DBA fields and a state historical bibliography distinguish the preservation association from the society. Current museum operation and the common name at Lafayette Street remain unproved. Leave separate from Headquarters House. |
| Chipley | County tourism confirms the museum at 685 7th Avenue; the link to the older preservation-society address remains unproved. Registry retrieval encountered a JavaScript challenge and the newer operator domain did not resolve. Leave unmerged. |
| Mandeville | Both official visitor-page map links resolve to **32.8777592, -117.2408635**. The saved Overture point is **866 m** away and IMLS **527 m** away. The operator still reports an open-ended closure; its dated Media Mesh program does not establish indoor reopening. |
| Smedley | Operator identity, address and weekend hours are supported. The older page's embedded map did not expose a destination in static retrieval, and no connected browser was available. Precise visitor coordinates remain unverified. |

Per-case sources, retrieval limits and next actions are in the
[evidence ledger](museum_focused_review_2026-09-15/evidence.csv) and
[follow-up queue](museum_focused_review_2026-09-15/follow_up.csv).

Mandeville's [map checks](museum_focused_review_2026-09-15/map_checks.csv) use the
destination's `!3d`/`!4d` coordinates, not the map camera center, and `sf` with s2 for
distances. This is an operator-location check, not independent geocoding.
**The corrected point is saved for publication export; current Parquet/analysis
coordinates are unchanged.** A future visitor map must apply the sourced point
separately and resolve access wording.
[Visitor page](https://mandevilleartgallery.ucsd.edu/visit/index.html),
[dated Media Mesh program](https://mandevilleartgallery.ucsd.edu/exhibitions/data-tales.html).

## Validation and next step

R 4.4.2: **161 passing assertions**, no test failures, warnings or skips. Regression
cases cover partial-cluster rejection, isolated conflicts, alias separation,
unchanged source fields and deterministic IDs. R startup emitted the existing Windows
locale warnings separately from tests.

The selective rebuild completed **15 targets**, refreshing review CSVs, the identity
audit and reviewed Parquet. All **15 integration checks passed**. The automatic
baseline, unreviewed records, all normalized source fields, earlier dated packets and
both human-label files are unchanged. Only `labelling_sheet` remains outdated and
was deliberately skipped. Protected-file hashes and check results are in the packet.
The archived labels still yield 119 true merges, one false merge, eight missed merges
and 172 true separations at **0.85**;
these assistant factual decisions are not new independent matching labels.

Reproduce the before/after counts from the unchanged baseline and archived inputs:
`source("data/validation/museum_focused_review_2026-09-15/reproduce.R")`.

Next: continue the unresolved address/location cases and broader top-20 institution,
category and affiliation checks. Add original IMLS EIN and separate mailing/physical
address fields to future dossiers: coalescing those fields hid the Venetia conflict.
Publication and the standalone post remain later steps.
