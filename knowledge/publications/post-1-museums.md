---
type: Publication
title: "Post 1: duplicate museum names"
description: "The museum post (D1): its brief under decision 14, the Old Jail Museum M1 headline, the five checked collisions, the rewritten draft staged in the blog repository, and what remains before publication."
resource: ../../posts/duplicate-museum-names/
tags: [publication, post-1, museums]
sequence: 1
publication_state: draft staged in the blog repository; unpublished
slug: duplicate-museum-names
generated: { by: claude-code/claude-fable-5-1, at: 2026-10-06T03:45:00Z }
sources:
  - id: flight-log
    resource: ../project/flight-log.md
    title: Flight log, 2026-09-26 rescope and shortlist entries and the 2026-10-06 post 1 entry
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
site.[^flight-log] The slug is `duplicate-museum-names`.[^design]

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
- All eight evidence pages were re-read on 2026-10-05 and are live. Two carry a longer form
  of the name: the Albion operator page is headed "Old Jail Museum of Noble County, Indiana",
  and Tennessee's tourism listing calls Winchester's the "Franklin County Old Jail Museum".
  Decision 14 has no public-name criterion and the headline is unchanged; the post states
  the Winchester variant in its method note.[^flight-log]
- Three more counted locations share the name but belong to operators with other museums
  (`historic_tours_of_america`, `allegan_county_historical_society`,
  `washington_county_ga_historical_society`). The post reports them beside the headline.[^flight-log]

# Surprising collisions

At most five groups are verified, and only to the decision 14 standard. The shortlist came
from 3,204 L2 names shared by two or more counted non-chain institutions, filtered to 220
with no place name, no naming template, no generic type word and every pair more than 40 km
apart, then quick web checks.[^flight-log]

All five were checked on 2026-10-05, record by record.[^post1-review] "Counts" is the
number of members that meet the standard and whose public name normalizes to the group
name.

| Group | Records | Counts | Finding |
|---|---:|---:|---|
| 100th Meridian Museum | 2 | 2 | Confirmed. Cozad NE (Cozad Historical Society) and Erick OK (The 100th Meridian Museum Inc). Passes the gate. |
| Billy the Kid Museum | 3 | 2 | Fort Sumner NM (Sweet family) and Hico TX (Hico Billy The Kid Museum Inc) count. The Clovis NM record matches a directory listing at 1121 W 7th St that carries Hico's website; another listing gives that address to a tire shop. The gate fails for the name. |
| Santa Claus Museum | 2 | 1 | Columbus TX counts. The Indiana IMLS row and Overture's separately counted Santa Claus Museum and Village are one institution, whose site is titled Santa Claus Museum & Village. |
| Mermaid Museum | 2 | 1 | Berlin MD counts. The Los Angeles record is within about 150 m of the venue of the POPSUGAR x Freeform Mermaid Museum, a pop-up of March 22-25, 2018; that attribution rests on name and location. |
| Salt and Pepper Shaker Museum | 3 | 1 | Gatlinburg TN counts. The IMLS row is the same museum with San Francisco coordinates. Traer IA is a real city-owned attraction that calls itself the Salt & Pepper Shaker Gallery. |

The post presents the first as real, the second as real with a phantom third record, and the
other three as collisions the lists invented.[^flight-log]

Dropped at screening: Doc Holliday Museum, National Medal of Honor Museum, International
Police Museum, Gone With the Wind Museum and Eight Track Museum. Unflagged brands and touring
shows (Karpeles, Jurassic Quest, Candytopia, Sloomoo Institute, WNDR Museum, Medieval
Torture Museum, Challenger Learning Center, FamilySearch Center) belong in the M4 chain
table; all are at 6 or fewer, so M1 is unaffected.[^flight-log]

# Corrections found and deferred

Five records failed the check and are still counted in the data: the Clovis, Los Angeles,
Indiana (IMLS) and San Francisco-coordinate rows, and Traer's public name. The Hico museum is
also counted twice, under two L2 names. Each needs a sourced decision through the
[correction layer](../methodology/identity-corrections.md) and a dated packet. Decision 14
keeps post 1's evidence in one flat file, so none was applied and no count changed. The post
says so.[^flight-log]

# Draft

The draft was rewritten to the brief on 2026-10-05.[^flight-log] It opens on Bangor, names
Old Jail Museum, describes the 38-way tie at six, reports chains beside the headline, walks
through the five collisions with one figure, returns to Bangor, and ends with a short method
note. It shows no map, so decision 14's map and access checks do not apply.

`scripts/export_post1_payload.R` writes the payload from saved targets and stops unless the
headline passes the gate. The knit itself stops if a re-export changes a result the prose
names.[^post-readme]

# Remaining before publication

1. The user reads the staged draft and approves publication.[^flight-log]
2. Set `draft: false`, re-knit, then commit and push the blog repository. Steps are in
   [publishing a post](../playbooks/publish-post.md).
3. Confirm the live page and record the publication in this concept, the
   [status report](../project/status.md) and the [mission board](../project/mission.md).

Resolved on 2026-10-05: the bundle no longer copies packet reports, so the 53 broken links
and the partial set of September 26 reports from the 2026-09-26 documentation audit are
gone; the template's `dn_root` default now resolves to the repository root.[^flight-log]

# Bundle

[`posts/duplicate-museum-names/`](../../posts/duplicate-museum-names/README.md) reads only
`payload/`, `_setup.R` and its bundled `R/` helpers; it does not load targets or the
analysis checkout.[^post-readme] `scripts/stage_post.R museums` copies it to the blog
repository and knits it there. Publishing follows
[blog publishing](../architecture/blog-publishing.md) and the
[blog defaults](../architecture/blog-defaults.md).

[^flight-log]: Flight log, 2026-09-26 rescope and shortlist entries and the 2026-10-06 post 1 entry
[^post-readme]: Museum post bundle README
[^post1-review]: Post 1 headline review (decision 14 evidence)
[^design]: DESIGN.md §2 deliverables and §7.3 blog defaults, as of commit 7416eef
