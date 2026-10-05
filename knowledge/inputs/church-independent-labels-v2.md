---
type: Label Set
title: Church independent labels, version 2 (blank)
description: Blank version-2 church sample awaiting independent human labels, with 300 matching pairs, 500 naming-style and denomination items and a final-cluster review queue.
resource: ../../data/validation/church_phase1_2026-09-26/independent_review_v2/
tags: [churches, labels, matching]
status: draft
implemented_in: [../../R/church_analysis.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: protocol
    resource: ../../data/validation/church_phase1_2026-09-26/INDEPENDENT_REVIEW.md
    title: Independent church validation protocol
  - id: packet-readme
    resource: ../../data/validation/church_phase1_2026-09-26/README.md
    title: Church acquisition and methodology checkpoint README
  - id: labels
    resource: ../../data/validation/church_phase1_2026-09-26/independent_review_v2/
    title: Version-2 blank label sheets, predictions and cluster queue
  - id: superseded
    resource: ../../data/validation/church_phase1_2026-09-26/independent_review/README.md
    title: Superseded version-1 sample note
  - id: sample-impact
    resource: ../../data/validation/church_ordinal_review_2026-09-26/independent_sample_impact.json
    title: Independent sample impact at the church ordinal checkpoint
  - id: ordinal-readme
    resource: ../../data/validation/church_ordinal_review_2026-09-26/README.md
    title: Church ordinal and scope packet README
  - id: generator
    resource: ../../R/church_analysis.R
    title: Church analysis exports, including dn_export_church_label_samples()
---

# Purpose

Fresh, independent human labels for evaluating three things separately: pair-level church
matching, the naming-style and denomination-family heuristics, and final-cluster identity.
The museum sample's measured precision and recall do not transfer to churches.[^packet-readme]
This version follows the First Mesa ordinal/C2 correction. The earlier `independent_review/`
sample is superseded; do not label it.[^superseded] Described by the
[acquisition checkpoint](../evidence/churches/church_phase1_2026-09-26.md).

# Schema

`matching_labels_blank.csv` shows each pair without the predicted result.[^protocol]

| Column | Type | Description |
|---|---|---|
| `pair_id` | text | Sample pair ID (`C0001`, …); joins to the predictions file[^generator] |
| `source_a`, `source_id_a` | text | Source and source record ID of the first record |
| `name_a`, `lon_a`, `lat_a` | text, number | Raw name and source coordinates |
| `source_date_a` | text | Source update time |
| `source_b` … `source_date_b` | as above | The second record |
| `distance_m` | number | Distance between the two points, metres; all candidates within 150 m[^protocol] |
| `same_institution` | integer or blank | **Label:** 1 same institution, 0 distinct, blank unresolved[^protocol] |
| `reviewer`, `evidence_url`, `note` | text | Labeller, official evidence URL, notes on historical/current identity or uncertain points[^protocol] |

`matching_predictions.csv` keeps `row_a`, `row_b`, `distance_m`, `similarity`,
`ordinal_conflict`, `denom_conflict`, `would_merge`, `pair_type` (`spine` within Overture,
`cross_source` Overture versus historical/legal), `band` (similarity band), `n_stratum`
(stratum size) and `pair_id`.[^generator]

`classifier_labels_blank.csv` hides the predicted labels.[^protocol]

| Column | Type | Description |
|---|---|---|
| `label_id` | text | Sample item ID (`S0001`, …); joins to the predictions file[^generator] |
| `entity_id`, `source`, `source_id` | text | Canonical entity and its source record |
| `name_raw`, `lon`, `lat` | text, number | Raw name and source coordinates |
| `human_name_style` | text or blank | **Label:** `ordinal`, `saint`, `virtue`, `toponym`, `modern_brand`, `ethnolinguistic`, `descriptive` or `other`; unresolved allowed[^protocol] |
| `human_denom_family` | text or blank | **Label:** broad denomination family, when supported[^protocol] |
| `reviewer`, `evidence_url`, `note` | text | Labeller, evidence URL, notes |

`classifier_predictions.csv` keeps `label_id`, `entity_id`, `name_style`, `denom_norm`,
`denom_basis` and `n_stratum`. `cluster_review.csv` lists automatic multi-record Overture
clusters with their source and analysis fields, `n_cluster_records`, and blank
`human_cluster_decision` and `reviewer` columns.[^generator]

# Rules

- Labels must come from a human who independently checks the evidence. The assistant must not
  fill truth columns or use its factual decisions to measure its own accuracy.[^protocol]
- A shared name, tax address, website domain or denomination alone is not sufficient for a
  match label.[^protocol]
- Source research and factual reviews are not labels: scope research is not
  self-grading.[^ordinal-readme] OSM samples are not a substitute for independent human
  labels, and museum labels cannot evaluate this cohort.[^packet-readme][^protocol]
- State the classifier tie-breaking convention before scoring. A heuristic style, operator
  identity and a congregation's self-description can differ; do not infer members'
  demographics or history from names.[^protocol]
- Final-cluster identity needs review distinct from pair-level validation; multi-campus
  institutions, relocations and out-of-radius matches cannot be certified by the 150 m
  sample.[^protocol]
- When scoring, do not lower 0.85 or change gold labels; a threshold change needs a further
  independent set. Report coverage, uncertain labels, confusion matrix and per-stratum results;
  weighted estimates need the retained stratum sizes. No result estimates nationwide
  completeness or final transitive-cluster accuracy.[^protocol]
- Labels do not replace official-source checks of leading names, highest ordinals, current
  operation or congregation-versus-campus identity.[^protocol]

# Current contents

Row counts of the files in the folder:[^labels]

| File | Rows | Label columns |
|---|---:|---|
| `matching_labels_blank.csv` | 300 | `same_institution`, `reviewer`, `evidence_url`, `note` blank in every row |
| `matching_predictions.csv` | 300 | Predictions only; 30 pairs per `band` in each `pair_type` |
| `classifier_labels_blank.csv` | 500 | `human_name_style`, `human_denom_family`, `reviewer`, `evidence_url`, `note` blank in every row |
| `classifier_predictions.csv` | 500 | Predictions only |
| `cluster_review.csv` | 9,802 | `human_cluster_decision`, `reviewer` blank in every row |

The sampling seed is 20260926.[^protocol] No truth labels are filled.[^packet-readme] At the
ordinal checkpoint no version-2 sampled record was touched by the parser change or the two
scope holds, and `labels_modified` is false.[^sample-impact]

# Consumers

- `dn_export_church_label_samples()` in `R/church_analysis.R` generated this design. It runs
  from `dn_export_church_outputs()` (target `church_output_files`), which writes fresh working
  samples to `data/processed/church_review` and a `publication_gates` table that marks
  independent matching and classifier labels `incomplete`.[^generator]
- No code in `R/` reads or scores these files yet. After labels arrive, re-score current
  predictions on the fixed version-2 IDs; generated working samples can differ and do not
  replace received human work.[^sample-impact]

# Preservation

- Save completed work outside `data/processed/` as a new dated `data/validation/` file before
  rebuilding generated sheets, and keep the blank sample and predictions too.[^protocol]
- Keep the version-2 sample IDs and sampling design.[^sample-impact] Later packets byte-preserve
  these files in their `protected_files.csv`.[^ordinal-readme]
- The first blank-label packet is preserved;[^packet-readme] keep the superseded version-1
  folder unchanged and unlabelled.[^superseded]

[^protocol]: Independent church validation protocol
[^packet-readme]: Church acquisition and methodology checkpoint README
[^labels]: Version-2 blank label sheets, predictions and cluster queue
[^superseded]: Superseded version-1 sample note
[^sample-impact]: Independent sample impact at the church ordinal checkpoint
[^ordinal-readme]: Church ordinal and scope packet README
[^generator]: Church analysis exports, including dn_export_church_label_samples()
