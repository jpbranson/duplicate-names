---
type: Evidence Packet
title: Church acquisition and methodology checkpoint
description: First national church build with 1,032,223 source rows, 540,778 canonical Overture entities and 442,834 provisional eligible sites, plus the independent-review protocol and blank labels.
resource: ../../../data/validation/church_phase1_2026-09-26/README.md
tags: [churches, checkpoint, matching, labels]
status: deprecated
superseded_by: church_ordinal_review_2026-09-26.md
checkpoint: 2026-09-26
sequence: 1
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/church_phase1_2026-09-26/README.md
    title: Church acquisition and methodology checkpoint README
  - id: packet
    resource: ../../../data/validation/church_phase1_2026-09-26/
    title: Church acquisition packet (scripts, logs, checks, label samples)
  - id: protocol
    resource: ../../../data/validation/church_phase1_2026-09-26/INDEPENDENT_REVIEW.md
    title: Independent church validation protocol
  - id: browser-qa
    resource: ../../../data/validation/church_phase1_2026-09-26/browser_QA.md
    title: Church draft browser QA
  - id: ordinal-notes
    resource: ../../../data/validation/church_phase1_2026-09-26/ordinal_research_notes.md
    title: Early ordinal source review notes
---

# Scope

The first church checkpoint. It acquires the sources and builds the separate
`_targets_churches.R` pipeline, which leaves the museum store and its completed label sheet
untouched. It also adds church-specific matching guards and ordinal extraction, produces C1–C4
outputs and a standalone church draft with a map, and exports the blank independent-review
sample.[^report] No earlier church packet precedes it. Superseded by
[the ordinal and scope checkpoint](church_ordinal_review_2026-09-26.md): a later checkpoint
superseded its counts, but the packet remains valid historical evidence. Its
[independent-review protocol](../../../data/validation/church_phase1_2026-09-26/INDEPENDENT_REVIEW.md)
and the blank [version-2 labels](../../inputs/church-independent-labels-v2.md) are still live.

# Outcome

| Measure | Value |
|---|---:|
| Overture US-address records (release 2026-08-19.0) | 545,776 |
| GNIS Church features (2021-08-25 archive) | 231,707 |
| HIFLD legal-name/address records | 254,740 |
| Census 2023 incorporated places/CDPs | 32,037 |
| OSM elements in eight metro samples | 5,234 |
| Source rows retained | 1,032,223 |
| Canonical Overture entities | 540,778 |
| Eligible provisional Christian worship sites | 442,834 |

- Provisional scope is Overture's Christian worship categories within 50 states/DC, one chosen
  row per local automatic cluster. Other religions, broad organizations, missing names,
  closures and out-of-scope points stay as auditable holds. Scope reflects source
  classification, not anyone's religious identity.[^report]
- GNIS and HIFLD remain historical/legal comparison records; imprecise tax addresses cannot
  bridge current Overture churches. The retained 0.85 score gets church guards against
  conflicting ordinals, denomination families and transitive contradictions. These rules need
  independent evaluation; museum pair-level accuracy does not transfer.[^report]
- Ordinals are parsed through 999, with numbered streets and doctrinal proper names
  protected.[^report] Early source notes are diagnostic, not a final ranking: two `Thirty
  Eighth Baptist Church` records are 38th Avenue Baptist Church (correction then pending), and
  the 40th, Thirty-First and Twelfth Baptist cases still needed review.[^ordinal-notes] See
  [church name overrides](../../inputs/church-name-overrides.md).
- C2 correction: First Mesa Baptist Church is place-qualified, not ordinal one, and the distance
  exporter now limits both endpoints to the First cohort. The superseded territory summary and
  first blank-label packet are preserved.[^report]
- Validation: 322 unit assertions, 18 national-output checks and six museum preservation checks
  pass; all 453 protected evidence/label files are unchanged.[^report]
- The church draft renders in isolation with a self-contained map of 7,010 provisional First
  Baptist points. Browser QA found and fixed Unicode alias truncation, empty style objects, an
  overwritten map control, mobile table overflow and a data-URI iframe; the post frontmatter is
  still `draft: true`.[^browser-qa]
- Cloud resource spending USD 0; no paid account or service.[^report]

# Open actions

- Independent labels: use `independent_review_v2/` (300 blank matching pairs, 500 blank
  classifier labels, separate predictions and a final-cluster queue). No truth labels are
  filled, and the earlier `independent_review/` sample is superseded.[^report] Labelling rules
  are in the [protocol](../../../data/validation/church_phase1_2026-09-26/INDEPENDENT_REVIEW.md).[^protocol]
- Leading-name and high-ordinal factual reviews, final identity validation and the blog
  destination remain missing. Both posts are drafts; no national church record is
  certified.[^report]

# Files

- [Packet README (report)](../../../data/validation/church_phase1_2026-09-26/README.md)
- [Packet directory](../../../data/validation/church_phase1_2026-09-26/):
  [independent-review protocol](../../../data/validation/church_phase1_2026-09-26/INDEPENDENT_REVIEW.md),
  [version-2 blank labels](../../../data/validation/church_phase1_2026-09-26/independent_review_v2/),
  [national output checks](../../../data/validation/church_phase1_2026-09-26/national_output_checks.csv),
  [browser QA](../../../data/validation/church_phase1_2026-09-26/browser_QA.md),
  [ordinal notes](../../../data/validation/church_phase1_2026-09-26/ordinal_research_notes.md),
  [protected files](../../../data/validation/church_phase1_2026-09-26/protected_files.csv)
- Acquisition, build and validation scripts (`acquire_*.R`, `build.R`, `validate_outputs.R`
  and others) record this checkpoint's runs, with failed attempts kept in the logs. Treat them
  as frozen; never rerun them.

[^report]: Church acquisition and methodology checkpoint README
[^protocol]: Independent church validation protocol
[^browser-qa]: Church draft browser QA
[^ordinal-notes]: Early ordinal source review notes
