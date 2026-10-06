---
type: Plan
title: "Phases"
description: "Phase plan and exit criteria, from the Phase 0 scaffold to posts 3 and 4, with each phase's state at the 2026-10-05 checkpoint."
tags: [planning]
sequence: 6
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-06T04:30:00Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §8, including the Immediate Phase 2 deliverable, as of commit 7416eef (moved here verbatim)"
  - id: flight-log
    resource: flight-log.md
    title: Flight log, 2026-09-26 rescope entry and 2026-10-06 post 1 entry
---

| Phase | Work | Exit criterion |
|---|---|---|
| **0. Scaffold** ✅ **done 2026-09-07** | `git init`, RStudio project, renv pinned to R 4.4 (138 packages), schema contract, manifest machinery, source stubs, gold-set tests | ✅ `targets::tar_make()` runs end to end; 42 tests pass; `entities.parquet` written with 0 rows / 31 cols matching the contract |
| **1a. Acquire + resolve — MUSEUMS** ✅ **milestone met 2026-09-15** | Overture + IMLS; the L3 gazetteer; entity resolution; 300 human-labelled pairs scored | Museum entities generated and pair-level validation measured; final clusters and multi-site cases remain subject to review ([entity resolution](../methodology/entity-resolution.md)) |
| **2. Museums analysis → D1** ◀ **in progress** (post 1 drafted, knitted in isolation and staged as a blog draft on 2026-10-05; publication awaits the user's go-ahead)[^flight-log] | Analysis tooling and focused source/identity passes complete; headline and collision checks done to [decision 14](../decisions/14-post-1-headline-sufficient-review.md); draft written and staged | Post 1 knits from its bundle and small payloads without the analysis checkout or pipeline; every headline number checked against evidence |
| **1b. Acquire + resolve — CHURCHES** ◀ **frozen until post 1 publishes** (national build complete; independent labels and identity validation pending)[^flight-log] | GNIS, HIFLD, OSM, Overture religious categories; Census places denominator | Same, extended to ~250k congregations |
| **3. Churches analysis → D2** ◀ **frozen until post 1 publishes** (C1–C4 outputs and local draft; factual and label gates pending) | C1–C4; territory maps as `mapgl` embeds; ladder; naming cultures; emit the multiplicity list for post 4 | Post 2 drafted; embeds load standalone in a bare browser tab and have static fallbacks |
| **4. Dashboard → D6** ◀ **frozen until post 1 publishes** (local static draft built; deployment blocked) | Generalize the post-2 embeds into an arbitrary-category explorer | Deployed and queryable beyond churches and museums |
| **5. Post 4 → D4** *(later)* | Historical sourcing on the multiplicity list from Phase 3 | — |
| **6. Post 3 → D3** *(later)* | Founding-date acquisition; cohort analysis | — |

Phases 2 and 3 feed the [leads register](../leads/index.md) continuously. Phase 1 is the long pole — probably 60% of
total effort to ship posts 1 and 2 — and the temptation to shortcut it should be resisted,
because everything downstream inherits its errors.

Phases 5 and 6 are sequenced after the dashboard on the reasoning that D3 and D4 both need
new data acquisition, while the dashboard needs nothing that Phase 1 hasn't already built.
Reorder freely if the writing momentum runs the other way.

# Immediate Phase 2 deliverable (as of 2026-09-26)

Superseded for post 1 by [decision 14](../decisions/14-post-1-headline-sufficient-review.md); the [status report](status.md) holds the live state.

The cleaned provisional L2 ranking and institution/source review sheets are available;
the [M2 leading-group checkpoint](../evidence/museums/museum_m2_leaders_2026-09-26.md) is the latest:
52,387 counted institutions and 52,255 eligible for name analysis. Chains leave the headline
(decision 12) and sourced `not_museum` records (25) leave the count (decision 13). Old Jail
Museum is the provisional non-chain leader at eight with four pending reviews; 174
institutions have complete factual reviews, 28 actions remain open, and no leading group
passes the publication gate. The
[methodology checkpoint](../evidence/museums/museum_methodology_2026-09-23.md) and
[provisional leaders report](../evidence/museums/museum_leaders_review_2026-09-23.md) preserve
earlier states; the [validation index](../evidence/index.md) lists every dated packet.
The [initial Phase 2 report](../evidence/museums/museum_analysis_2026-09-15.md)
preserves the earlier implementation checkpoint.
Category handling, affiliation rules, subject extraction, canonical entity counting and
M2's L2 correction are implemented and tested. Check identities, relevant multi-site
cases, category decisions and affiliations before certifying counts. An assistant can
research official sources and apply supported factual decisions; see the
[first source-verification pass](../evidence/museums/museum_source_review_2026-09-15.md).
The `verified` institution status means the factual review is complete, not that a
human supplied an independent matching label. Record evidence for factual corrections
and use fresh independent human labels to evaluate matching changes. Then export the
post payloads and write the headlines.
This work does not require reopening the matching threshold.

[^flight-log]: Flight log, 2026-09-26 rescope entry and 2026-10-06 post 1 entry
