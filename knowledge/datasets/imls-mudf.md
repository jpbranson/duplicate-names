---
type: Dataset
title: IMLS Museum Universe Data File (2018)
description: "Second museum source: the 2018 IMLS Museum Universe Data File CSV archive, a historical list that never updates."
resource: https://www.imls.gov/sites/default/files/2018_csv_museum_data_files.zip
tags: [datasets, museums]
sequence: 3
license: Public domain
role: implemented
implemented_in: [../../R/src_imls.R, ../../R/museum_review_context.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md §3 data sources, as of commit 7416eef
  - id: manifest
    resource: ../../data/raw/MANIFEST.json
    title: Input provenance manifest (download imls_mudf_2018, query imls_museums)
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: HANDOFF.md §5 things that will bite you, as of commit 7416eef
---

# Role

A historical museum list with discipline codes, used as the second museum source and as a
cross-check against Overture. The snapshot does not establish current operation or complete
present-day coverage.[^design] The manifest records the archive download (2026-09-07) and
30,109 rows in the cached adapter table.[^manifest]

Review dossiers keep the original EIN and separate physical/mailing address fields; see
[completing a museum review](../playbooks/complete-museum-review.md).

# Caveats

- The CSVs are Windows-1252; read as UTF-8 they corrupt 42 names, which then fail to match.
  `R/src_imls.R` handles this.[^handoff]
- IMLS is a 2018 snapshot that will never update: evidence a museum existed in 2018, never
  that one exists now.[^handoff]
- Some rows mix fields from different organizations (see the
  [mixed-records lead](../leads/mixed-source-records.md)).

[^design]: DESIGN.md §3 data sources, as of commit 7416eef
[^manifest]: Input provenance manifest (download imls_mudf_2018, query imls_museums)
[^handoff]: HANDOFF.md §5 things that will bite you, as of commit 7416eef
