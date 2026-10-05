---
type: Lead
title: "Institutions whose name is just their category"
description: "Placeholder or real signage? Category-like names such as Art Gallery and Planetarium."
tags: [leads, museums, category-names]
sequence: 11
lead_origin: surfaced
surfaced: 2026-09-07
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: leads
    resource: 7416eef:LEADS.md
    title: "LEADS.md 'Institutions whose name is just their category', as of commit 7416eef (moved here verbatim)"
---

The saved September 7 results include `art gallery` (37), `planetarium` (14),
`fine arts gallery` (12), plus 17 rows with an empty name. Empty names are already excluded
by the counting policy. The category-like strings may be mapper-supplied placeholders or
actual signage; the existing names alone do not distinguish them.

Confirmed placeholders must not count as duplicate institution names, but this
raises a real question for the churches post too: how many institutions have no
distinct name at all? A congregation listed only as "Church" is a data gap, but
a museum whose actual signage reads "Art Gallery" is a naming *choice*, and the
two are hard to tell apart from POI data alone. Worth a paragraph, not a post.

**Phase 2 implementation:** category-only flags now create reviewable holdouts, with
source-level evidence decisions and an unfiltered comparison ranking. Cal Poly actually
uses [University Art Gallery](https://cla.calpoly.edu/university-art-gallery) as a name;
UC San Diego documents that same wording as the former name of its
[Mandeville Art Gallery](https://mandevilleartgallery.ucsd.edu/about/history.html).
That is both a naming phenomenon and a snapshot-age problem. The identity pass now
retains the UCSD, Baylor and Stony Brook former names as aliases of their current
institutions. Five University Art Gallery names are confirmed; NMSU remains a
historical-name holdout, and 131 category decisions remain pending across the full queue.
These are naming decisions, not completed institution reviews.
