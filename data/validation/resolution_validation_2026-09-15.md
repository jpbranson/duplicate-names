# Museum resolution validation — 2026-09-15

All 300 candidate pairs were labelled by the user: **127 same institution, 173 different,
0 unsure**. `TRUE`/`FALSE` labels are interpreted correctly by `dn_score_labels()`.

## Provenance and reproduction

- Original: `data/processed/resolution_labelling.csv`, left unchanged.
- Archive: [resolution_labelling_2026-09-15.csv](resolution_labelling_2026-09-15.csv),
  copied byte for byte outside the pipeline's generated-file paths and Git ignore rules.
- SHA-256 of both files: `ef36a81cfe3d0c413b7cfb2c0641f318e7a3d578db731fbe39425c4e0dbfab05`.
- `.gitattributes` disables line-ending conversion for archived validation CSVs so
  the recorded checksum survives commits and checkouts on other platforms.
- Scoring code: `R/validate_resolution.R` at commit `2fefd93`, run with R 4.4.2.
- Checked 300 unique pair IDs, valid labels, and CSV parsing. Recomputed similarities
  from both raw names with the current normalizer and matcher: all rounded scores and
  all stored `would_merge` decisions agree.

Run from the repository root:

```r
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
dn_score_labels("data/validation/resolution_labelling_2026-09-15.csv")
```

## Results at the current 0.85 threshold

| Rule decision | Human: same institution | Human: different |
|---|---:|---:|
| Merge | 119 | 1 |
| Keep separate | 8 | 172 |

- Precision: **119 / 120 = 99.17%**.
- Recall: **119 / 127 = 93.70%**.
- Sample error: **9 / 300 = 3.00%**.
- F1: **238 / 247 = 96.36%**.

The scorer's threshold sweep (0.50–0.99 in 0.01 steps) selects **0.85** by sample F1.
Selected comparisons, using the CSV's rounded similarities:

| Threshold | True merges | False merges | Missed merges | Precision | Recall |
|---|---:|---:|---:|---:|---:|
| 0.80 | 121 | 31 | 6 | 79.61% | 95.28% |
| 0.85 | 119 | 1 | 8 | 99.17% | 93.70% |
| 0.90 | 87 | 1 | 40 | 98.86% | 68.50% |
| 0.95 | 60 | 0 | 67 | 100.00% | 47.24% |

Retain `DN_NAME_SIM_MIN <- 0.85`. Lowering the threshold to 0.80 adds 30 false merges
while recovering only two true matches. No threshold or resolution code was changed.

## Disagreements to investigate

These preserve the user's labels; they are not new judgements about the institutions.

| Pair | Similarity | Name A | Name B | Error |
|---|---:|---|---|---|
| P0076 | 0.667 | Union Bank Museum | Black Archives Union Bank Building | Missed merge |
| P0138 | 0.827 | DD LIVING HISTORY FARM | DOUBLE-D LIVING HISTORY FARM | Missed merge |
| P0150 | 0.805 | NATIONAL BOWLING HALL OF FAME AND MUSEUM | INTERNATIONAL BOWLING MUSEUM & HALL OF FAME | Missed merge |
| P0159 | 0.788 | QC AfricanAmerican Museum | QUAD CITIES AFRICAN AMERICAN MUSEUM | Missed merge |
| P0168 | 0.774 | GREATER BATON ROUGE ZOO | BREC'S BATON ROUGE ZOO | Missed merge |
| P0177 | 0.750 | NATIONAL GUARD MUSEUM & ARCHIVES | MASSACHUSETTS NATIONAL GUARD MUSEUM | Missed merge |
| P0179 | 0.750 | La Mesa Depot Museum | Pacific Southwest Railway Museum - La Mesa | Missed merge |
| P0180 | 0.750 | Lake Bluff History Museum | VLIET MUSEUM OF LAKE BLUFF | Missed merge |
| P0181 | 0.945 | Trinidad History Museum | TRINIDAD HISTORICAL SOCIETY | False merge |

The missed matches suggest investigating aliases, abbreviations, and name changes.
P0181 shows that substituting museum and society terms can join different institutions.
Evaluate any resulting rule changes on fresh independent labels before claiming an
improvement beyond this sample.

## Scope and project status

Sampling deliberately selected 60 pairs from each of five similarity bands, all within
150 m. These pooled, unweighted results describe that sample. They do not estimate the
error rate among all US museums or all candidate pairs. Recall excludes matches outside
the radius. The score evaluates direct pair decisions, not transitive site clustering,
multi-site entity merging, or the counting policy. Threshold selection uses the same
sample, not a separate held-out evaluation, and uses similarities rounded to three decimals.

Phase 1a's measured-validation milestone is complete. Phase 2 still needs category-only
name handling, franchise detection, subject extraction, L2 alignment for M1/M2, and manual
verification of leading collisions. `metric_singularity_collisions()` still groups on L3;
the documentation update records this gap without changing the code. Repeated naming
templates alone do not establish franchise affiliation.

The next deliverable is a cleaned museum collision ranking and a review sheet identifying
the institutions behind the top 20 names, including relevant cases from the existing
multi-site queue. See [HANDOFF.md](../../HANDOFF.md) for the sequence and
[DESIGN.md](../../DESIGN.md) for methodology. The pipeline was not rebuilt; saved entity
counts remain provisional and unchanged.

Use this archived CSV for future scoring. Rebuilding `labelling_sheet` rewrites the
generated working copy in `data/processed/`; it cannot reproduce the human judgements.
