---
type: Evidence Packet
title: Resolution validation — original human-label evaluation
description: The user's 300 independent pair labels score the 0.85 matching threshold at 99.17% precision and 93.70% recall on a sample of pairs within 150 m, not dataset-wide or final-cluster accuracy.
resource: ../../../data/validation/resolution_validation_2026-09-15.md
tags: [museums, checkpoint, matching, labels]
status: stable
checkpoint: 2026-09-15
sequence: 1
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/resolution_validation_2026-09-15.md
    title: Museum resolution validation report, 2026-09-15
  - id: labels
    resource: ../../../data/validation/resolution_labelling_2026-09-15.csv
    title: Archived human pair labels, 2026-09-15
---

# Scope

The user labelled all 300 candidate pairs from the resolution labelling sheet: **127 same
institution, 173 different, 0 unsure**.[^report] This report scores the automatic matcher's
direct pair decisions against those [archived labels](../../inputs/resolution-labels-2026-09-15.md).[^labels]
It is the first museum checkpoint; nothing precedes it. Later museum checkpoints are factual
source reviews and do not supply a new independent matching evaluation, so this evaluation
stays current.[^report]

# Outcome

| Rule decision at 0.85 | Human: same institution | Human: different |
|---|---:|---:|
| Merge | 119 | 1 |
| Keep separate | 8 | 172 |

- Precision **119 / 120 = 99.17%**, recall **119 / 127 = 93.70%**, sample error
  **9 / 300 = 3.00%**, F1 **238 / 247 = 96.36%**.[^report]
- The scorer's threshold sweep (0.50–0.99 in 0.01 steps) selects **0.85** by sample F1.
  Lowering it to 0.80 adds 30 false merges while recovering only two true matches. Retain
  `DN_NAME_SIM_MIN <- 0.85`; no threshold or resolution code was changed.[^report] See
  [decision 10](../../decisions/10-retain-085-threshold.md).
- Nine disagreements: eight missed merges and one false merge (P0181, Trinidad History
  Museum versus Trinidad Historical Society, similarity 0.945). The missed matches suggest
  investigating aliases, abbreviations and name changes; P0181 shows that substituting
  museum and society terms can join different institutions.[^report]
- Provenance: the archive is a byte-for-byte copy of the working sheet, with SHA-256
  `ef36a81cfe3d0c413b7cfb2c0641f318e7a3d578db731fbe39425c4e0dbfab05` for both files. Scoring
  used `R/validate_resolution.R` at commit `2fefd93` under R 4.4.2. Recomputed similarities
  and stored `would_merge` decisions all agree.[^report]

**Limits, as the report states them.**[^report] Sampling deliberately selected 60 pairs from
each of five similarity bands, all within 150 m. These pooled, unweighted results describe
that sample. They do not estimate the error rate among all US museums or all candidate pairs.
Recall excludes matches outside the radius. The score evaluates direct pair decisions, not
transitive site clustering, multi-site entity merging, or the counting policy. Threshold
selection uses the same sample, not a separate held-out evaluation, and uses similarities
rounded to three decimals.

# Open actions

- The nine disagreements remain to investigate. They preserve the user's labels and are not
  new judgements about the institutions. Evaluate any resulting rule change on fresh
  independent labels before claiming an improvement beyond this sample.[^report]
- Use the archived CSV for future scoring. Rebuilding `labelling_sheet` rewrites the generated
  working copy in `data/processed/`; it cannot reproduce the human judgements.[^report]

There is no follow-up queue for this checkpoint.

# Files

- [Validation report](../../../data/validation/resolution_validation_2026-09-15.md)
- [Archived label set](../../../data/validation/resolution_labelling_2026-09-15.csv)
  (authoritative; preserve unchanged)
- [Scoring code](../../../R/validate_resolution.R)
- No packet directory. Reproduce the score without rebuilding (see
  [the playbook](../../playbooks/reproduce-without-rebuilding.md)):

  ```r
  for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
  dn_score_labels("data/validation/resolution_labelling_2026-09-15.csv")
  ```

[^report]: Museum resolution validation report, 2026-09-15
[^labels]: Archived human pair labels, 2026-09-15
