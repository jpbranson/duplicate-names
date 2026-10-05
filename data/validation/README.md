# Validation and review evidence

This directory holds the project's evidence: the human-label archive, the live decision
inputs read by `_targets.R` and `_targets_churches.R`, and dated review packets. Git
preserves every file here byte for byte (see `.gitattributes`), so recorded checksums
survive checkouts. Never edit a dated packet; record later work in a new packet.

What these files mean, and which are current, is described in the
[knowledge bundle](../../knowledge/index.md):

- [Inputs](../../knowledge/inputs/index.md): one concept per live decision table and label
  set, with schema, rules, current contents and consumers.
- [Evidence](../../knowledge/evidence/index.md): one concept per dated packet, current first,
  by track (museums, churches, artifacts).
- [Preserving evidence](../../knowledge/playbooks/preserve-evidence.md) and
  [reproducing results without rebuilding](../../knowledge/playbooks/reproduce-without-rebuilding.md).
- [Current status](../../knowledge/project/status.md), including the latest checkpoints.

The previous version of this index is `git show 7416eef:data/validation/README.md`.
