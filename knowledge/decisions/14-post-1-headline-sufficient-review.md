---
type: Decision
title: "Headline-sufficient review and stopping rules for post 1"
description: "Post 1's per-member evidence standard, the M1 stopping rule, at most five surprising collisions, and the church/explorer freeze."
tags: [decisions, post-1, museums, publication]
decision: 14
decided: 2026-09-26
approved_by: human:jpbranson
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §9 decision 14, as of commit 7416eef (moved here verbatim)"
  - id: flight-log
    resource: 7416eef:FLIGHT_LOG.md
    title: "FLIGHT_LOG.md 2026-09-26 entry: rescope to post 1 (user approval)"
---

**Headline-sufficient review and stopping rules for post 1 (2026-09-26).** Post 1
answers two questions: which museum name is number one, and whether there are
surprising collisions. An institution counts toward a named headline group when
source evidence shows that it is (a) a distinct public museum, not a duplicate
record, office, mailing address, former site or support facility; (b) plausibly
operating; and (c) not sharing a brand or operator with another member of the
group. Governance, campus scope, visitor access and exact map points are outside
this standard unless they change (a)-(c). Map and access checks apply only to
institutions the post shows on a map. This standard does not change
`review_status = verified`, which still means a complete factual review; the
post's per-member evidence goes in one flat CSV, not a new packet.
**M1 stopping rule:** resolve Old Jail Museum's pending members to this standard
to get V. If V is 7 or more (above every other provisional group), Old Jail is
the headline, after checking that no six-member group can reach V through pending
renames or near-variant names. If V is 6 or less, report the tie plateau; do not
open further leader batches. **Surprising collisions:** select at most five
groups and verify only those to this standard. Church work and the explorer are
frozen until post 1 publishes.
