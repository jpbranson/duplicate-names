---
type: Publication
title: "Post 2: duplicate church names"
description: "The church post (D2) landing C1-C4: an unpublished research draft, frozen until post 1 publishes, with independent-label and factual gates still open."
resource: ../../posts/duplicate-church-names/
tags: [publication, post-2, churches]
sequence: 2
publication_state: unpublished draft (frozen)
slug: duplicate-church-names
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: post-readme
    resource: ../../posts/duplicate-church-names/README.md
    title: Church post bundle README
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md §2 deliverables, as of commit 7416eef
  - id: flight-log
    resource: ../project/flight-log.md
    title: Flight log, 2026-09-26 rescope entry
---

# Brief

Deliverable D2 is the counted namespace: it lands [C1](../metrics/c1-most-duplicated-church-name.md)
through [C4](../metrics/c4-naming-culture-profile.md), is carried by its maps, and flags posts
3 and 4 forward.[^design] Church work is frozen until post 1 publishes
([decision 14](../decisions/14-post-1-headline-sufficient-review.md)).[^flight-log]

# State

- The bundle builds from its own CSV payloads, local helpers and a prebuilt self-contained
  map without the analysis checkout. `preview.html` is the verified standalone preview;
  `index.Rmd` remains `draft: true`. `first-baptist-fallback.png` is the map's static key
  view.[^post-readme]
- Final blogdown/theme integration is unverified because the blog destination is still
  missing.[^post-readme]
- Counts and outputs follow the [church checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md).

# Required unfinished gates

Fresh independent matching/classifier labels, final cluster identities, leading-name and
high-ordinal factual checks, and actual blog integration/deployment. The draft is
provisional and must not become a certified claim.[^post-readme] See
[church independent labels](../inputs/church-independent-labels-v2.md) and
[open questions](../project/open-questions.md).

[^post-readme]: Church post bundle README
[^design]: DESIGN.md §2 deliverables, as of commit 7416eef
[^flight-log]: Flight log, 2026-09-26 rescope entry
