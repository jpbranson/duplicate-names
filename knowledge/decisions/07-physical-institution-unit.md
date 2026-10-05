---
type: Decision
title: "The physical institution is the unit of analysis"
description: "Count one entity per physical museum; society names go to alt_names, which the map must expose."
tags: [decisions, museums, identity, counting]
decision: 7
decided: 2026-09-07
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 7, as of commit 7416eef (moved here verbatim)"
---

**The physical institution is the unit of analysis.** Where source evidence establishes
that museum and society records identify the same museum, count one entity: the museum
name leads and the society name is preserved in `alt_names`. Co-location or shared
ownership alone is insufficient; an operator's distinct museums remain separate.
Same for a documented relocation — the
International Cryptozoology Museum is one entity, at Bangor, with the Portland records
retained and flagged rather than dropped.

**`alt_names` carries a publication obligation, not just bookkeeping.** The eventual map
must footnote the alternate names, so a reader can see that "Washington County
Historical Museum" and "Washington County Historical Society" were treated as one place
and judge that call themselves. The automatic baseline contains 6,181 counted entities
with an alternate name.

The old source-row/alias metric gave `washington county historical society` 27;
canonical-entity counting gives 19 on the baseline. Nine explicit identity cases
subsequently reduce this name to 16 provisional entities, then the focused LeMoyne
correction and Venetia source-conflict hold reduce it to 14. The address pass's
Chipley mailing consolidation reduces it to 13. These are separate changes and
must be distinguished in the post.
