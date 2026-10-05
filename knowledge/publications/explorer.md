---
type: Publication
title: Duplicate-name explorer (D6)
description: "The static, local-first explorer in dashboard/: built and checked locally, not deployed, frozen until post 1 publishes."
resource: ../../dashboard/
tags: [publication, explorer]
sequence: 3
publication_state: local draft, not deployed (frozen)
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: dashboard-readme
    resource: ../../dashboard/README.md
    title: Dashboard README
  - id: flight-log
    resource: ../project/flight-log.md
    title: Flight log, 2026-09-26 artifact refresh and rescope entries
---

# What it is

A static, local-first explorer for the museum and church snapshots. It shows L2/L3
comparisons, names, source aliases, factual-review status, affiliation and holds. Museum
defaults exclude known chains without calling unknowns independent; church counts remain
provisional worship sites. No headline or accuracy gate is cleared by this
interface.[^dashboard-readme] Design rationale is in [dashboard design](../architecture/dashboard.md).

# State

- Built and validated locally; deployment is blocked by the missing destination, and saving
  the exported CSV to disk from the browser remains unverified.[^dashboard-readme]
- Latest refresh: 52,719 museum descriptions including holds (52,255 eligible) and 540,778
  church records; all four serialized L2/L3 checks and 19 JS assertions passed at the
  2026-09-26 artifact refresh.[^flight-log] See the [artifact refresh](../evidence/artifacts/artifact_refresh_2026-09-26.md)
  and the [church checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md), which
  holds the latest build metadata.[^dashboard-readme]
- Frozen until post 1 publishes ([decision 14](../decisions/14-post-1-headline-sufficient-review.md)).[^flight-log]

# Build and checks

Build and validation commands are in the [dashboard README](../../dashboard/README.md). Use a
fresh dated evidence directory for each review checkpoint; rebuilding never overwrites
archived validation evidence.[^dashboard-readme]

[^dashboard-readme]: Dashboard README
[^flight-log]: Flight log, 2026-09-26 artifact refresh and rescope entries
