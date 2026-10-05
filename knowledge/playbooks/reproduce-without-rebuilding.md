---
type: Playbook
title: "Reproduce results without rebuilding"
description: "Score the archived human labels and replay archived checkpoints read-only, without rebuilding targets or rewriting labels."
tags: [reproducibility, labels]
sequence: 4
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: validation-index
    resource: 7416eef:data/validation/README.md
    title: "data/validation/README.md Reproduce without rebuilding, as of commit 7416eef (moved here verbatim)"
---

Run from the repository root in the restored R 4.4.2 environment:

```r
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
dn_score_labels("data/validation/resolution_labelling_2026-09-15.csv")

# Requires the saved automatic entities target and the original working label
# copy noted below. Checks archived decisions and before/after counts in memory.
source("data/validation/museum_old_jail_review_2026-09-15/reproduce.R")

# Requires live identity decisions and saved reviewed targets/Parquet exports
# to match the methodology checkpoint, in addition to replaying archived decisions.
source("data/validation/museum_methodology_2026-09-23/validate.R")
```

The methodology, leaders and Union County validators check the saved state current at their
checkpoint as well as their archives. The leaders and Union County validators' live
comparisons now fail by design, because later decisions and the headline code changed that
state; their archived replays remain valid.
Keep the dated validator unchanged and record later verification in a new packet.

Both packet checks also verify protected-file hashes, including the original
`data/processed/resolution_labelling.csv`. That working copy is ignored by Git; on
another machine, restore it from the authoritative label archive only if the working
path is absent. Preserve any newer completed labels separately before replacing a
different working copy. Label scoring alone needs only the tracked archive.

These commands do not rebuild targets or rewrite labels. A full `tar_make()` or rebuild of
`labelling_sheet` can overwrite the working labels in `data/processed/`; archive any new
human decisions first. Before exporting selected headlines, explicitly call
`dn_assert_museum_publication_ready()` and complete the factual checks described in
[README.md](../playbooks/complete-museum-review.md). The pipeline does not call that
helper automatically.
