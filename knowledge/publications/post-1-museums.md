---
type: Publication
title: "Post 1: duplicate museum names"
description: "The museum post (D1): its brief under decision 14, the Old Jail Museum M1 headline, the surprising-collision shortlist, and what remains before publication."
resource: ../../posts/duplicate-museum-names/
tags: [publication, post-1, museums]
sequence: 1
publication_state: unpublished draft
slug: duplicate-museum-names
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: flight-log
    resource: ../project/flight-log.md
    title: Flight log, 2026-09-26 rescope and shortlist entries
  - id: post-readme
    resource: ../../posts/duplicate-museum-names/README.md
    title: Museum post bundle README
  - id: post1-review
    resource: ../../data/validation/post1_headline_review.csv
    title: Post 1 headline review (decision 14 evidence)
  - id: design
    resource: 7416eef:DESIGN.md
    title: DESIGN.md §2 deliverables and §7.3 blog defaults, as of commit 7416eef
---

# Brief

Deliverable D1 opens on Bangor's International Cryptozoology Museum and asks "who
checks?"[^design] Under [decision 14](../decisions/14-post-1-headline-sufficient-review.md)
the post answers two questions: which museum name is number one ([M1](../metrics/m1-most-duplicated-museum-name.md)),
and whether there are surprising collisions. Its publication target is the blogdown
site.[^flight-log] The planned slug is `duplicate-museum-names`.[^design]

# Headline (M1)

- Old Jail Museum: all eight non-chain members meet the decision 14 standard. Four already
  had complete factual reviews; four were rechecked on public sources (Winchester via state
  tourism; the city page returned 403). V = 8, above every other group (none at 7, 38 at
  6).[^flight-log]
- Upward-risk check: every L4 variant of the 38 six-member groups carries a place name, so
  none joins its L2 group. Karpeles Manuscript Library Museum (6 plus 3 city-suffixed) is a
  single-family network that belongs in the chain table; it cannot pass Old Jail either
  way.[^flight-log]
- Per-member evidence is in [`post1_headline_review.csv`](../inputs/post1-headline-review.md).[^post1-review]
  `dn_assert_museum_publication_ready()` passes for Old Jail when that file is supplied as
  `headline_review` (commit `5b50ab3`).[^flight-log] See the [publication gate](../methodology/publication-gate.md)
  for what the gate does not check.

# Surprising collisions

At most five groups are verified, and only to the decision 14 standard. The shortlist came
from 3,204 L2 names shared by two or more counted non-chain institutions, filtered to 220
with no place name, no naming template, no generic type word and every pair more than 40 km
apart, then quick web checks.[^flight-log]

| Shortlisted group (not yet verified to decision 14) | Members noted at screening |
|---|---|
| Billy the Kid Museum | Fort Sumner NM / Hico TX; a third record near Clovis NM to screen |
| 100th Meridian Museum | Cozad NE / Erick OK |
| Santa Claus Museum | Santa Claus IN / Columbus TX |
| The Mermaid Museum | Berlin MD / Hollywood CA record unconfirmed |
| Salt and Pepper Shaker Museum | Gatlinburg TN / Iowa record reported temporarily closed / 2018 IMLS San Francisco row |

Dropped at screening: Doc Holliday Museum, National Medal of Honor Museum, International
Police Museum, Gone With the Wind Museum and Eight Track Museum. Unflagged brands and touring
shows (Karpeles, Jurassic Quest, Candytopia, Sloomoo Institute, WNDR Museum, Medieval
Torture Museum, Challenger Learning Center, FamilySearch Center) belong in the M4 chain
table; all are at 6 or fewer, so M1 is unaffected.[^flight-log]

# Remaining before publication

1. Verify the surprising-collision groups to the decision 14 standard.[^flight-log]
2. Rewrite the draft to the original brief.[^flight-log]
3. Map and access checks apply only to institutions the post shows on a map
   ([decision 14](../decisions/14-post-1-headline-sufficient-review.md)); staged points
   and dated access wording are in [publication locations](../inputs/publication-locations.md).
4. Publish on the blogdown site. The bundle keeps `draft: true` until final factual checks
   and the explicit selected-name gate pass; its `payload/publication_blockers.csv` records
   the remaining work.[^post-readme]

Open issues from the 2026-09-26 documentation audit: 53 links inside the bundle's copied
evidence files point to packet folders that are not bundled; the bundle includes 8 of 18
September 26 reports; and the post template's `dn_root` default resolves above the
repository.[^flight-log]

# Bundle

[`posts/duplicate-museum-names/`](../../posts/duplicate-museum-names/README.md) reads only
`payload/`, `_setup.R` and its bundled `R/` helpers; it does not load targets or the
analysis checkout. Render with `rmarkdown::render("index.Rmd")` from that directory.[^post-readme]
Publishing follows [blog publishing](../architecture/blog-publishing.md) and the
[blog defaults](../architecture/blog-defaults.md).

[^flight-log]: Flight log, 2026-09-26 rescope and shortlist entries
[^post-readme]: Museum post bundle README
[^post1-review]: Post 1 headline review (decision 14 evidence)
[^design]: DESIGN.md §2 deliverables and §7.3 blog defaults, as of commit 7416eef
