---
type: Decision
title: "Retain the 0.85 matching threshold"
description: "The 300-pair human-labelled sample supports 0.85; lowering to 0.80 adds false merges for little recall."
tags: [decisions, matching, labels]
decision: 10
decided: 2026-09-15
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 10, as of commit 7416eef (moved here verbatim)"
---

**Retain the 0.85 matching threshold after measured validation (2026-09-15).** The
300-pair sample supports this threshold; lowering it to 0.80 adds 30 false merges
while recovering only two true matches. Archive the human labels unchanged. The
result completes the Phase 1a validation milestone without asserting dataset-wide
accuracy or validating final clusters.
