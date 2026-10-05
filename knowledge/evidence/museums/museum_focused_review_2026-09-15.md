---
type: Evidence Packet
title: Focused follow-up — LeMoyne consolidation and Pennsylvania conflicts
description: Six cases left by the first identity pass reviewed; LeMoyne House consolidated, two contradictory IMLS rows isolated and a Mandeville operator map point saved; 52,619 counted and 52,487 eligible.
resource: ../../../data/validation/museum_focused_review_2026-09-15.md
tags: [museums, checkpoint, identity, publication]
status: deprecated
superseded_by: museum_address_review_2026-09-15.md
checkpoint: 2026-09-15
sequence: 6
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_focused_review_2026-09-15.md
    title: Museum source review, six focused follow-ups
  - id: packet
    resource: ../../../data/validation/museum_focused_review_2026-09-15/
    title: Focused-review packet (decisions, IMLS rows, audit, map checks, follow-up)
---

# Scope

Reviewed the six cases left by the first identity pass. It is not a completed top-20 review
or a matching evaluation.[^report] Preceded by the
[first identity pass](museum_identity_review_2026-09-15.md). Superseded by the
[address follow-up](museum_address_review_2026-09-15.md); a later checkpoint replaced its
counts, but the packet remains valid historical evidence.

# Outcome

| Measure | Before | After |
|---|---:|---:|
| Source rows retained | 60,002 | 60,002 |
| Counted source rows | 57,332 | 57,329 |
| Counted entities | 52,621 | 52,619 |
| Eligible for L2 name analysis | 52,489 | 52,487 |
| Washington County Historical Society | 16 | 14 |
| National Vietnam War Museum | 2 | 2 |

- Pennsylvania: IMLS `8404200022` combines the society's common name and street with Barrow
  Gallery's legal name, website and EIN; IMLS `8404201308` has a Venetia mailing city and an
  EIN and PO box matching Peters Creek Historical Society. Both receive `source_conflict`
  decisions and `reviewed_source_conflict` exclusions with their own stable holdout IDs; their
  disputed aliases do not enter any accepted institution.[^report]
- The clean IMLS record `8404201136` and the Overture LeMoyne House record now count as one
  institution, led by the museum name.[^report]
- Texas Bankhead, Fayetteville Lafayette and Chipley are left unmerged. Smedley's operator
  identity, address and weekend hours are supported, but its precise visitor coordinates remain
  unverified.[^report]
- Mandeville: both official map links resolve to **32.8777592, -117.2408635**; the saved
  Overture point is 866 m away and IMLS 527 m. The corrected point is saved for publication
  export; Parquet and analysis coordinates are unchanged, and the operator still reports
  an open-ended closure.[^report]
- Washington County Historical Society now falls below Old Jail Museum (15); neither group is
  certified.[^report]
- The [original IMLS rows](../../../data/validation/museum_focused_review_2026-09-15/imls_original_rows.csv)
  showed that coalesced address fields hid the Venetia conflict, so the report recommends
  carrying EIN and separate mailing/physical fields in future dossiers.[^report]
- Validation: 161 passing assertions under R 4.4.2; the selective rebuild completed 15 targets
  and all 15 integration checks passed. The archived labels still score 119 true merges, one
  false merge, eight missed merges and 172 true separations at 0.85; these assistant factual
  decisions are not new independent matching labels.[^report]

# Open actions

The [follow-up queue](../../../data/validation/museum_focused_review_2026-09-15/follow_up.csv)
carries Texas Bankhead, the Pennsylvania cases (Peters Creek physical membership still to
reconcile), Fayetteville Lafayette, Chipley's address history, Mandeville map/access and the
Smedley map destination.[^packet]

# Files

- [Checkpoint report](../../../data/validation/museum_focused_review_2026-09-15.md)
- [Packet directory](../../../data/validation/museum_focused_review_2026-09-15/):
  [applied identity decisions](../../../data/validation/museum_focused_review_2026-09-15/applied_identity_decisions.csv),
  [identity audit](../../../data/validation/museum_focused_review_2026-09-15/identity_audit.csv),
  [evidence ledger](../../../data/validation/museum_focused_review_2026-09-15/evidence.csv),
  [map checks](../../../data/validation/museum_focused_review_2026-09-15/map_checks.csv),
  [integration checks](../../../data/validation/museum_focused_review_2026-09-15/integration_checks.csv),
  [validation summary](../../../data/validation/museum_focused_review_2026-09-15/validation.txt)
- `reproduce.R` replays the before/after counts from the unchanged baseline and archived
  inputs;[^report] it does not write pipeline outputs.[^packet]

[^report]: Museum source review, six focused follow-ups
[^packet]: Focused-review packet (decisions, IMLS rows, audit, map checks, follow-up)
