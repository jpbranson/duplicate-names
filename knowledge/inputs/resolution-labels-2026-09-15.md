---
type: Label Set
title: Resolution labels, September 15 sample
description: Authoritative archive of 300 independent human pair labels used to score the museum matching rule; preserve it unchanged and score it with dn_score_labels().
resource: ../../data/validation/resolution_labelling_2026-09-15.csv
tags: [museums, matching, labels]
status: stable
implemented_in:
  - ../../R/validate_resolution.R
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: csv
    resource: ../../data/validation/resolution_labelling_2026-09-15.csv
    title: Archived human pair labels (resolution_labelling_2026-09-15.csv)
  - id: code
    resource: ../../R/validate_resolution.R
    title: Labelling sample and label scoring (R/validate_resolution.R)
  - id: resolve
    resource: ../../R/resolve.R
    title: Entity resolution constants and name similarity (R/resolve.R)
  - id: report
    resource: ../../data/validation/resolution_validation_2026-09-15.md
    title: Museum resolution validation report, 2026-09-15
  - id: export
    resource: ../../data/validation/museum_publication_2026-09-26/build_export.R
    title: Dated publication export script, 2026-09-26
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation evidence index at 7416eef, labels and reproduction
  - id: readme
    resource: 7416eef:README.md
    title: Project README at 7416eef, running and archive helper
  - id: agents
    resource: ../../AGENTS.md
    title: Repository guidelines for coding agents
---

# Purpose

The authoritative archive of 300 independent human pair labels; preserve it unchanged and use
it for scoring.[^index] It measures the museum resolution error rate, which has to come from a
human: if the process that made the clustering decisions also grades them, the rate measures
self-consistency, not correctness.[^code] The user labelled every pair.[^report] See the
[resolution validation](../evidence/museums/resolution_validation_2026-09-15.md),
[entity resolution](../methodology/entity-resolution.md) and
[decision 10](../decisions/10-retain-085-threshold.md).

# Schema

`dn_build_labelling_sample()` defines the layout; `dn_score_labels()` reads it with column
types guessed by `readr`.[^code]

| Column | Type | Description |
|---|---|---|
| `pair_id` | text | Sample pair ID (`P0001`, ...); unique |
| `band` | text | Similarity stratum: `0.00-0.60`, `0.60-0.75`, `0.75-0.85`, `0.85-0.95`, `0.95-1.00` |
| `similarity` | number | Similarity of the two L2 names, rounded to three decimals |
| `distance_m` | number | Distance between the two source points, rounded to metres |
| `name_a`, `source_a` | text | First record's raw name and source |
| `name_b`, `source_b` | text | Second record's raw name and source |
| `would_merge` | logical | The rule's decision: `similarity` at or above `DN_NAME_SIM_MIN` |
| `same_institution` | logical | Human label: same institution, different, or blank for "cannot tell" |

Candidate pairs lie within `DN_SITE_RADIUS_M` (150 m); the threshold is `DN_NAME_SIM_MIN`
(0.85). Similarity is the larger of Jaro-Winkler and token containment.[^resolve] The
generator describes labels as 1/0/blank; the archive stores `TRUE`/`FALSE`, which
`dn_score_labels()` interprets correctly.[^code][^report]

# Rules

- Matching accuracy requires independent human labels; do not self-grade clustering
  decisions. Identity evidence and factual review are not matching labels.[^agents][^index]
- Keep the 0.85 threshold. Its unweighted pair-level precision and recall do not establish
  dataset-wide or final-cluster accuracy.[^agents]
- Preserve the original labels; use fresh independent labels to evaluate changes suggested by
  the nine disagreements.[^agents]
- The `labelling_sheet` target rewrites `data/processed/resolution_labelling.csv`. Archive new
  completed labels outside `data/processed/` before a full `tar_make()` or that
  rebuild.[^agents]

# Current contents

As of commit 7416eef: 300 rows, 60 in each band. `would_merge` is `TRUE` for 120 and `FALSE`
for 180. `same_institution` is `TRUE` for 127, `FALSE` for 173, and blank for none. By band,
`TRUE` labels number 0, 1, 7, 59 and 60, lowest band first.[^csv] The SHA-256 at that commit is
`ef36a81cfe3d0c413b7cfb2c0641f318e7a3d578db731fbe39425c4e0dbfab05`, as the report
records.[^report]

At 0.85 the report finds 119 true merges, 1 false merge, 8 missed merges and 172 true
separations: precision 99.17%, recall 93.70%, sample error 3.00%. The threshold sweep selects
0.85.[^report]

# Consumers

- `dn_score_labels("data/validation/resolution_labelling_2026-09-15.csv")`, after sourcing
  `R/`; no pipeline target reads the archive.[^readme]
- `scripts/archive_museum_review.R` records its checksum.[^readme] Later packets list its hash
  among protected files, for example the M2 packet's `protected_files.csv`.
- The 2026-09-26 publication export copied it into the museum post bundle's
  evidence.[^export]
- Church labels are separate: see [church independent labels](church-independent-labels-v2.md).

# Preservation

- Never edit it. `.gitattributes` disables line-ending conversion so the checksum survives
  checkouts.[^report]
- The working copy `data/processed/resolution_labelling.csv` is ignored by Git. On another
  machine, restore it from this archive only if the working path is absent; preserve any newer
  completed labels separately before replacing a different working copy.[^index] See
  [preserve evidence](../playbooks/preserve-evidence.md).

[^csv]: Archived human pair labels (resolution_labelling_2026-09-15.csv)
[^code]: Labelling sample and label scoring (R/validate_resolution.R)
[^resolve]: Entity resolution constants and name similarity (R/resolve.R)
[^report]: Museum resolution validation report, 2026-09-15
[^export]: Dated publication export script, 2026-09-26
[^index]: Validation evidence index at 7416eef, labels and reproduction
[^readme]: Project README at 7416eef, running and archive helper
[^agents]: Repository guidelines for coding agents
