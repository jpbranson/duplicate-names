---
type: Design Note
title: "Data licensing"
description: "Build the published dataset on permissive sources and keep OSM (ODbL) as an internal validation layer, or license the release ODbL."
tags: [architecture, licensing, publication]
sequence: 5
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §7 Licensing, as of commit 7416eef (moved here verbatim)"
---

**Licensing — matters, because this gets published.** OSM is ODbL: a derived database
distributed publicly carries share-alike and attribution obligations. Overture Places is
CDLA-Permissive/Apache, much friendlier. *Recommendation:* build the publishable derived
dataset on the permissive sources (Overture + GNIS + IMLS + HIFLD, all permissive or public
domain) and use OSM as an internal enrichment and validation layer whose contribution stays
out of the released tables. If OSM tags end up load-bearing in the released data, license
the release ODbL and attribute properly. Decide before publishing, not after.
