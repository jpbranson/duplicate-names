---
type: Dataset
title: Wikidata
description: "Inception dates, instance-of museum/church building, operator chains and disambiguation pages."
resource: https://www.wikidata.org/
tags: [datasets, museums, churches]
sequence: 9
license: CC0
role: planned (not implemented)
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md §3 supporting and temporal sources, as of commit 7416eef
---

# Role

Inception dates, instance-of museum/church building, operator chains and disambiguation pages: the only clean structured source for founding years. It may also support M4 affiliation checks, but it is not wired into the pipeline.[^design] Founding-date acquisition is deferred to post 3
([decision 3](../decisions/03-temporal-c5-deferred.md)); see the
[data sources overview](overview.md).

[^design]: DESIGN.md §3 supporting and temporal sources, as of commit 7416eef
