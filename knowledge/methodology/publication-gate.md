---
type: Method
title: "Museum publication gate"
description: "What dn_assert_museum_publication_ready() checks before headline export, how decision 14's headline_review changes it, and what it cannot check."
tags: [publication, museums, post-1]
sequence: 7
implemented_in: [../../R/museums.R, ../../R/museum_publication.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-06T04:30:00Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §5 implementation status, as of commit 7416eef (moved here verbatim)"
  - id: flight-log
    resource: ../project/flight-log.md
    title: Flight log, 2026-10-06 post 1 entry
---

**Implementation status:** `_targets.R` emits canonical L2 duplicate and singularity
candidate counts, subject summaries, affiliation splits, and review sheets. M2 reports
unknown affiliation separately from reviewed independence; its lexical scope claims
still require semantic review (American can describe a subject rather than assert
singularity). No candidate count is a verified count of independent institutions.

`dn_assert_museum_publication_ready()` checks the non-chain institutions of selected L2
names for counted, eligible, verified rows with resolved affiliation; a chain-only name fails. It is an explicit pre-export check, not a target
automatically invoked by `_targets.R`. Under decision 14, an optional `headline_review`
table can instead pass a member with dated, sourced evidence for all three criteria. The ranking's `publication_ready` column summarizes
recorded review statuses; neither mechanism verifies evidence, semantic scope claims or
map/access details. At the [M2 checkpoint](../evidence/museums/museum_m2_leaders_2026-09-26.md),
174 institutions have complete factual reviews, including exclusions. Old Jail Museum is the
provisional non-chain leader at eight with four pending reviews, so no leading group passes
the explicit publication check without a `headline_review` table; with decision 14's table it
passes (see below). The [September 17 batch](../evidence/museums/museum_union_county_review_2026-09-17.md)
reduces Union County's provisional count from 14 to seven; the
[September 23 batch](../evidence/museums/museum_leaders_review_2026-09-23.md) reduces Washington County's from 13 to seven.
A supported identity or naming decision alone does not complete a review.

# Post 1 group summary (2026-10-05)

`dn_post1_groups()` in `R/museum_publication.R` lists every counted non-chain member of each
name in the [post 1 headline review](../inputs/post1-headline-review.md) with its basis:
complete factual review, headline-sufficient check, failed check, public name differs, or
not reviewed. It marks a name `confirmed` only when the gate passes and every member counts.
That is stricter than the gate, which does not read `public_name`. The function is
read-only. `scripts/export_post1_payload.R` calls the gate for the headline and stops if it
fails.[^flight-log]

At that checkpoint Old Jail Museum and 100th Meridian Museum pass the gate. Billy the Kid
Museum has two counting members and one record that matches no museum, so the gate fails
for the name and the post says why.[^flight-log]

[^flight-log]: Flight log, 2026-10-06 post 1 entry
