---
type: Reference
title: "Things that will bite you"
description: "Operational traps: Overture update times, stale operating status, IMLS encoding and age, the L2/L3 default, DESCRIPTION, s2 distances, tippecanoe."
tags: [pitfalls, museums]
sequence: 8
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: "HANDOFF.md §5, as of commit 7416eef (moved here verbatim)"
---

- **Overture's `sources[].update_time` must exclude `provider = 'overture'`.** Overture's
  own entries are stamped with the release date, which pins every row to the same day and
  destroys the freshness signal. This is already handled in `R/src_overture.R` — do not
  "simplify" it.
- **`operating_status` does not catch stale records.** Overture still marks old Portland
  Cryptozoology Museum records "open". The official site dates the new Bangor home to
  June 1, 2026; 2016 was the move to Thompson's Point within Portland, not to Bangor.
  The official visit page also lists 585 Hammond Street, Bangor as closed. The
  selected Bangor coordinate was checked against the official 490 Broadway map link:
  it is 5.9 m from the linked destination. This is a source check, not a field survey.
- **IMLS CSVs are Windows-1252.** Handled in `R/src_imls.R`. Read as UTF-8 they corrupt 42
  names and those museums silently fail to match.
- **IMLS is a 2018 snapshot** and will never update. It is evidence a museum existed in
  2018, never that one exists now. Its `source_update_time` says so honestly.
- **L3 (`name_core`) is the wrong default for museums.** Stripping place names suits
  churches; for museums the place is usually the identity. Museum headlines use **L2
  (`name_expanded`)**. L3 supports geography-stripped comparisons and the bounded M3
  subject analysis; it is not a substitute for subject extraction. Do not "fix" the
  museum headline metric to use L3.
- **`DESCRIPTION` must keep `Type: Project` and no `Package:` field**, or renv reclassifies
  the project as an R package and relocates the library out of `renv/library`, orphaning
  every installed package.
- **Distances use `sf` on s2 geometry.** Never project to a national CRS and measure
  Euclidean distance.
- Windows has no `tippecanoe`. Not needed at this scale — plain GeoJSON is fine.
