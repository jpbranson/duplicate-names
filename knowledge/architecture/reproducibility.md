---
type: Design Note
title: "Reproducibility and provenance"
description: "MANIFEST.json, dated packets and checksums; what the manifest does and does not guarantee."
tags: [architecture, provenance, reproducibility]
sequence: 2
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §7 Reproducibility, as of commit 7416eef (moved here verbatim)"
---

**Reproducibility.** `data/raw/MANIFEST.json` records the museum inputs and research
acquisitions with provenance, retrieval time and SHA-256. Dated review packets preserve
decision inputs, evidence and checksums. The Census gazetteer is pinned to 2023 in code
but still lacks manifest coverage. `dn_fetch()` checks cached downloads against their
recorded hash; a supplied `expect_sha256` also guards new downloads. Source adapters
can read existing Parquet caches directly, so manifest hashes should not be described
as an automatic check on every pipeline run. The [validation index](../evidence/index.md)
maps current decision inputs to the dated checkpoints. Archive manifests record file
contents at a checkpoint; later documentation and live decision edits do not justify
rewriting historical hashes. The general archive helper reads saved targets and omits
identity artifacts; see [README.md](../../README.md#running) before preserving a new review.
