---
type: Evidence Packet
title: Static explorer initial build QA
description: First local build of the duplicate-name explorer, with 52,847 museum and 540,778 church canonical rows passing serialized L2/L3 payload checks; not deployed, and browser CSV saving unverified.
resource: ../../../data/validation/dashboard_2026-09-26/QA.md
tags: [artifacts, checkpoint, explorer]
status: deprecated
superseded_by: artifact_refresh_2026-09-26.md
checkpoint: 2026-09-26
sequence: 1
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/dashboard_2026-09-26/QA.md
    title: Static explorer QA
  - id: packet
    resource: ../../../data/validation/dashboard_2026-09-26/
    title: Explorer build packet (QA, logs, payload checks and checksums)
  - id: data-build
    resource: ../../../data/validation/dashboard_2026-09-26/data_build.json
    title: Explorer data build manifest
  - id: payload-checks
    resource: ../../../data/validation/dashboard_2026-09-26/serialized_payload_checks.json
    title: Explorer serialized payload checks
---

# Scope

QA of the first local build of the static [duplicate-name explorer](../../publications/explorer.md)
in `dashboard/`: payload serialization, browser search and selection, layout, CSV import and
export.[^report] The data build is stamped 2026-09-26 04:25:32 UTC.[^data-build] It is the
first artifact packet; nothing precedes it. Superseded by
[the artifact refresh](artifact_refresh_2026-09-26.md): a later checkpoint superseded its
counts, but the packet remains valid historical evidence.

# Outcome

| Collection | Records | Eligible | Aliases | `verified` | L2 groups | L3 groups |
|---|---:|---:|---:|---:|---:|---:|
| Museums | 52,847 | 52,425 | 6,218 | 40 | 48,146 | 37,209 |
| Churches | 540,778 | 442,834 | 4,463 | 0 | 325,861 | 232,530 |

Copied from the serialized payload checks, all four with status `passed`.[^payload-checks]
`verified` counts records with `review_status = verified` (complete factual review), not
independent matching labels.

- Nineteen focused JS import/count/export assertions pass. Every payload bucket passes an
  independent JSON/gzip check at L2 and L3; unique IDs, numeric coordinates, boolean scope,
  aliases, index/group totals and 51 Census outlines agree with the manifest. No OSM
  rows.[^report]
- Browser checks: Depot Museum 10; Old Jail Museum L2 8 with four `verified` and four pending;
  First Baptist Church L3 7,010. The Old Jail L3/all-record view shows 16 rows including two
  holds. Defaults keep known chains separate and unknown affiliation explicit.[^report]
- A local fictional-parks CSV import shows three rows, all marked unverified; no network
  upload.[^report]
- Desktop and 390x844 phone layouts have no document horizontal overflow and no explorer
  console errors.[^report]
- No remote tiles or OSM data; MapLibre 5.24.0 from mapgl 0.5.0; cloud cost USD 0.[^data-build]

# Open actions

- Browser automation timed out twice waiting for a saved blob CSV download, so no filesystem
  download is confirmed; a normal browser/manual save check stays on the human review
  list.[^report]
- Public hosting and blog integration: destination missing, no deployment.[^report]
- Museum and church factual and independent-label gates remain incomplete; UI tests do not
  satisfy them.[^report]
- These carried into [the artifact refresh](artifact_refresh_2026-09-26.md).

# Files

- [QA report](../../../data/validation/dashboard_2026-09-26/QA.md)
- [Packet directory](../../../data/validation/dashboard_2026-09-26/):
  [data build](../../../data/validation/dashboard_2026-09-26/data_build.json),
  [serialized payload checks](../../../data/validation/dashboard_2026-09-26/serialized_payload_checks.json),
  [payload checksums](../../../data/validation/dashboard_2026-09-26/payload_checksums.csv),
  [JS test log](../../../data/validation/dashboard_2026-09-26/tests.log),
  [build log](../../../data/validation/dashboard_2026-09-26/build.log)
- The packet holds QA, logs and checks only, no scripts.

[^report]: Static explorer QA
[^data-build]: Explorer data build manifest
[^payload-checks]: Explorer serialized payload checks
