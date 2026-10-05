---
type: Reference
title: "Known traps"
description: "Seven analytical traps: signage vs legal names, closed institutions, chains, the First Baptist split, messy denominations, Christian Science, ladder survivorship."
tags: [pitfalls, museums, churches]
sequence: 8
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §6, as of commit 7416eef (moved here verbatim)"
---

1. **Signage name ≠ legal name ≠ OSM name.** The IRS says `FIRST BAPTIST CHURCH OF
   SPRINGFIELD INC`; the sign says `Springfield First Baptist`; OSM says `First Baptist
   Church`. Pick one authority per question and say which one.
2. **Closed institutions.** POI data is full of ghosts, and museums close constantly.
   Duplicate counts inflate if we count the dead. Overture confidence and cross-source
   presence help prioritize research; current operation needs source checks. Keep
   excluded records and evidence rather than deleting them.
3. **Chains masquerading as collisions** — see [chain detection](chain-detection.md).
4. **The First Baptist duplication has a history.** Many Southern towns hold two
   congregations with near-identical names because of post-Reconstruction racial splits,
   commonly `First Baptist Church` alongside `First African Baptist Church` (or, in the
   historical record, `First Baptist Church (Colored)`). Any honest analysis of "why do
   some towns have two Firsts" runs straight into this. It is real, well documented, and
   probably one of the most substantive findings available.
   **Decided: its own post (D4).** Post 2 surfaces the pattern in the exclusivity data,
   names it plainly, and points forward; it does not try to tell the history in a
   sub-section. Post 4 does that with proper historical sourcing — denominational
   histories, NRHP nominations (which frequently narrate exactly this split in their
   significance statements), and secondary literature — rather than inferring history from
   POI names, which the name data alone cannot support.
5. **Denomination is not clean.** "Baptist" spans SBC, ABC-USA, NBC, CBF, and thousands of
   independents. Report at the granularity the data supports, not the granularity that
   makes a better sentence.
6. **`First Church of Christ, Scientist`** and its kin — the ordinal-parser trap. Maintain
   an explicit exception list, under test.
7. **Survivorship in the ladder.** A missing Third may never have existed, or may have
   burned down in 1911.
