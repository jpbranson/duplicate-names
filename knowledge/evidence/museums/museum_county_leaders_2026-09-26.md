---
type: Evidence Packet
title: County society leaders — supported corrections and remaining questions
description: Franklin, Greene and Jackson County Historical Society each fall from eleven to six provisional non-chain institutions; 52,563 counted and 52,431 eligible, 28 complete factual reviews.
resource: ../../../data/validation/museum_county_leaders_2026-09-26.md
tags: [museums, leaders, identity, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 12
superseded_by: museum_jail_followup_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_county_leaders_2026-09-26.md
    title: County society leaders checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_county_leaders_2026-09-26/
    title: County leaders packet (sub-batch decisions, audits, rankings, validation)
---

# Scope

Investigated all 33 starting Franklin, Greene and Jackson County Historical Society
candidates and related source records, in Franklin, Greene and Jackson sub-batches. It is a
validated correction batch, not completion of the headline review.[^report] Preceded by
[the methodology checkpoint](museum_methodology_2026-09-23.md); superseded by
[the Old Jail follow-up](museum_jail_followup_2026-09-26.md). Deprecated: a later checkpoint
superseded its counts; the packet remains valid historical evidence.

# Outcome

| Measure | Before (September 23) | After |
|---|---:|---:|
| Original source rows retained | 60,002 | 60,002 |
| Counted source records | 57,292 | 57,274 |
| Counted museum institutions | 52,584 | 52,563 |
| Eligible for L2 analysis | 52,452 | 52,431 |
| Explicit identity rows / cases | 92 / 37 | 121 / 49 |
| Complete factual reviews | 19 | 28 |
| Sourced not-museum decisions | 3 | 7 |
| Isolated source conflicts | 5 | 7 |

- Each bare-name group falls from eleven to six provisional non-chain institutions. None is
  certified.[^report]
- Franklin: consolidates Chambersburg's Old Jail/society, Rocky Mount's current
  museum/mailing record, Columbus COSI records and its exhibit, and Ottawa's society/archive
  records. Ottawa's research/administrative institution is not a separate museum; Old Depot
  Museum remains separate.[^report]
- Greene: consolidates Waynesburg, Stanardsville's current/former site, Bronck Museum and
  Jefferson's museum, and isolates a museum-labelled bank-address row. Springfield's
  preservation society is excluded separately from History Museum on the Square.[^report]
- Jackson: consolidates Lakefield's museum, separates Independence's History Center from
  the 1859 Jail Museum and isolates a Baldwin/Maquoketa mixed source record. The Newport
  museum-support society and Maquoketa genealogy library are not additional museums.
  Murphysboro remains counted: library research at a museum does not itself put that museum
  out of scope. Distinct Iowa subordinate EINs must not be merged on a shared IRS legal
  name.[^report]
- The Missouri split required an explicit `split_canonical` role in the
  [identity corrections](../../methodology/identity-corrections.md): one representative per
  destination site group, all affected baseline-cluster members in one guarded case, stable
  new IDs and aliases drawn only from assigned source rows. Former-site assignments are
  rejected in split cases. Ordinary merge behavior and the automatic matching baseline are
  unchanged.[^report]
- Validation: 231 test assertions and 23 integrity checks pass, including guarded replay,
  refreshed reviewed Parquet, unchanged automatic baseline/multisite queue, 60,002 original
  source rows/fields, threshold 0.85 and all 247 protected prior evidence/label files. The
  explicit publication gate still rejects the unfinished Jackson group; the Franklin and
  Greene sub-batches likewise recorded rejected gates.[^report]
- The old human-label sample was not regraded, and these factual decisions are not
  independent accuracy labels.[^report]

# Open actions

Preferred public names, uncertain museum roles and several older addresses remain pending,
in the [remaining queue](../../../data/validation/museum_county_leaders_2026-09-26/follow_up.csv).
Local operators with multiple distinct museums need consistent common-operator affiliation
treatment in the next Old Jail pass, and Chambersburg's independent flag must be revisited
under that rule. No national winner or complete present-day museum census is
established.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_county_leaders_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_county_leaders_2026-09-26/):
  research notes for [Franklin](../../../data/validation/museum_county_leaders_2026-09-26/research_notes.md),
  [Greene](../../../data/validation/museum_county_leaders_2026-09-26/greene_notes.md) and
  [Jackson](../../../data/validation/museum_county_leaders_2026-09-26/jackson_notes.md);
  [candidate dispositions](../../../data/validation/museum_county_leaders_2026-09-26/candidate_dispositions.csv),
  [ranking after](../../../data/validation/museum_county_leaders_2026-09-26/ranking_after.csv),
  [Jackson integrity checks](../../../data/validation/museum_county_leaders_2026-09-26/jackson_integrity_checks.csv),
  [Jackson validation log](../../../data/validation/museum_county_leaders_2026-09-26/jackson_validation.log)
- Read-only reproduction applies the archived `jackson_*_decisions_after.csv` with
  `dn_reconcile_museums()` to the unchanged saved `entities`, then `dn_museum_analysis()`;
  `build_check_county.R jackson` is this checkpoint's selective rebuild/check.[^report]
- One-time scripts (`prepare.R`, `apply_franklin.R`, `apply_greene.R`, `apply_jackson.R`)
  are frozen; never rerun them.

[^report]: County society leaders checkpoint report
