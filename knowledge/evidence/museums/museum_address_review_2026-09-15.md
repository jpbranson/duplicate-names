---
type: Evidence Packet
title: Address and map follow-up — Chipley, Peters Creek and staged publication points
description: Expanded IMLS dossiers support Chipley and Peters Creek consolidations, and operator map points are staged for publication; 52,617 counted and 52,485 eligible.
resource: ../../../data/validation/museum_address_review_2026-09-15.md
tags: [museums, checkpoint, identity, publication]
status: deprecated
superseded_by: museum_old_jail_review_2026-09-15.md
checkpoint: 2026-09-15
sequence: 7
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_address_review_2026-09-15.md
    title: Museum address and map follow-up report
  - id: packet
    resource: ../../../data/validation/museum_address_review_2026-09-15/
    title: Address-review packet (decisions, audit, IRS rows, staged locations)
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation and review evidence index
---

# Scope

Expanded IMLS dossiers support two further consolidations, Chipley's museum/mailing records
and Peters Creek's house/society records, and precise operator map points are staged
separately for publication. It is a factual source review, not a completed headline review
or an independent matching evaluation.[^report] Preceded by the
[focused follow-up](museum_focused_review_2026-09-15.md). Superseded by the
[Old Jail review](museum_old_jail_review_2026-09-15.md); a later checkpoint replaced its
counts, but the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Source rows retained | 60,002 | 60,002 |
| Counted source rows | 57,329 | 57,327 |
| Counted institutions | 52,619 | 52,617 |
| Eligible for L2 name analysis | 52,487 | 52,485 |
| Washington County Historical Society | 14 | 13 |
| National Vietnam War Museum | 2 | 2 |

- **Chipley:** IMLS `8401200854` gives EIN `592788489`, a legal preservation-society name and a
  mailing address, with a blank physical address. The IRS Florida file identifies the same
  EIN and legal name at 685 7th Street, the museum site in the state grant record. The Overture
  museum stays canonical and the IMLS row is retained as `reviewed_mailing_address`.[^report]
- **Peters Creek / Enoch Wright House:** both Overture records fall within 12 m of the
  operator's published point and now count once under the house name. Contradictory IMLS
  `8404201308` stays isolated and uncounted; the Barrow conflict is unchanged.[^report]
- The live identity input now covers 33 source rows in 13 cases: 12 canonical institutions and
  two isolated conflicts. No institution has a completed overall `verified` review.[^report]
- **Staged publication points:** separate `publication_lon`/`publication_lat` fields for
  Smedley, Mandeville and Peters Creek, with dated access wording. They are operator-supplied
  locations, not surveyed entrances or independent geocoding, and the pipeline and Parquet
  exports do not apply them.[^report] The table is still a live staged input; see
  [publication locations](../../inputs/publication-locations.md).[^index]
- Validation: 192 passing assertions and 18 passing integration checks under R 4.4.2; the
  build completed 15 targets and skipped 13. All 63 protected files are unchanged, all ten
  new raw acquisition hashes match, and the original label scores at 0.85 are
  unchanged.[^report]

# Open actions

Bankhead and Lafayette Street remain unresolved and separate. Municipal residential evidence
cannot establish Bankhead's museum membership or closure; the IRS row confirms Lafayette
Street's legal organization and address, not current museum operation.[^report] The
[follow-up queue](../../../data/validation/museum_address_review_2026-09-15/follow_up.csv)
also leaves Chipley's and Peters Creek's overall reviews open, and asks for the Smedley and
Mandeville points to be applied in the publication export with refreshed access
wording.[^packet]

# Files

- [Checkpoint report](../../../data/validation/museum_address_review_2026-09-15.md)
- [Packet directory](../../../data/validation/museum_address_review_2026-09-15/):
  [staged publication locations](../../../data/validation/museum_address_review_2026-09-15/publication_locations.csv),
  [applied identity decisions](../../../data/validation/museum_address_review_2026-09-15/applied_identity_decisions.csv),
  [identity audit](../../../data/validation/museum_address_review_2026-09-15/identity_audit.csv),
  [map checks](../../../data/validation/museum_address_review_2026-09-15/map_checks.csv),
  [selected IRS rows](../../../data/validation/museum_address_review_2026-09-15/irs_selected_rows.csv),
  [evidence ledger](../../../data/validation/museum_address_review_2026-09-15/evidence.csv)
- The packet also preserves manifest snapshots and the public Smedley map marker.[^index]
- `reproduce.R` checks counts and preservation without rebuilding.[^report]

[^report]: Museum address and map follow-up report
[^packet]: Address-review packet (decisions, audit, IRS rows, staged locations)
[^index]: Validation and review evidence index
