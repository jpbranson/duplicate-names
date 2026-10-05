---
type: Evidence Packet
title: Church scope follow-up proposal (draft, not applied)
description: Twenty-three proposed guarded Christian-scope decisions for linked Church of God and Saints of Christ records; a read-only dry run passed, but nothing was applied pending user approval.
resource: ../../../data/validation/church_scope_followup_2026-09-26/
tags: [churches, checkpoint, scope]
status: draft
checkpoint: 2026-09-26
sequence: 3
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/church_scope_followup_2026-09-26/dry_run_summary.json
    title: Scope follow-up dry-run summary (the packet has no written report)
  - id: packet
    resource: ../../../data/validation/church_scope_followup_2026-09-26/
    title: Church scope follow-up packet (snapshots, cached sources, proposal, dry run)
  - id: proposal
    resource: ../../../data/validation/church_scope_followup_2026-09-26/scope_decisions_proposed.csv
    title: Proposed church scope decisions
  - id: human-review
    resource: ../../../data/validation/church_scope_followup_2026-09-26/human_review.csv
    title: Scope follow-up human review queue
  - id: identity-followup
    resource: ../../../data/validation/church_scope_followup_2026-09-26/identity_followup.csv
    title: Scope follow-up identity next actions
  - id: index
    resource: 7416eef:data/validation/README.md
    title: Validation and review evidence index
  - id: flight-log
    resource: ../../project/flight-log.md
    title: Flight log, 2026-09-26 19:53 and 20:00 UTC entries and the post 1 rescope entry
---

# Scope

A proposal packet. It snapshots 36 linked candidates and all their cluster members, caches
operator and parent-directory pages, and drafts guarded `outside_christian_scope` decisions.
The research separates the Judaism-identifying cogasoc.org organization from similarly named
Christian branches; there are no blanket name-based exclusions.[^flight-log] Preceded by
[the ordinal and scope checkpoint](church_ordinal_review_2026-09-26.md), which remains the
current church checkpoint.

**Nothing was applied.** The proposal awaits user approval; the live
[church scope decisions](../../inputs/church-scope-decisions.md) file still has two rows and
442,832 eligible.[^index] Church work, including this proposal, is frozen until post 1
publishes ([decision 14](../../decisions/14-post-1-headline-sufficient-review.md)).[^flight-log]
The packet has no written report; `dry_run_summary.json` and the flight log summarize it.

# Outcome

| Measure | Live | Dry run (proposed) |
|---|---:|---:|
| Canonical descriptions | 540,778 | 540,778 |
| Eligible | 442,832 | 442,818 |
| Proposed scope decisions | — | 23 |
| Entities changed | — | 21 |
| Newly ineligible | — | 14 |
| Earlier holds given scope evidence | — | 7 |

Values are copied from the dry-run summary, whose status is `dry_run_only`.[^report]

- The read-only `dry_run.R` (R 4.4.2) left pipeline target hashes and all 2,129 protected files
  unchanged; live decisions equal the snapshot, and the replay reproduces the before RDS
  exactly. No non-scope column changes; zero `verified` (complete factual) reviews.[^flight-log]
- The proposal was cross-checked against cached text. Every cited parent-directory,
  cogasoc.net directory and local-operator address was found, as were the Judaism
  self-descriptions (cogasoc.org parent, Jacksonville, Southern Pines) and the Christian
  self-descriptions (cogasoc.net, cogsoconline). Only 21 Montour Street Binghamton is absent
  from both directories.[^flight-log]
- Each proposed row carries name, entity and coordinate guards, an evidence URL and note, and
  `reviewed_by = assistant_official_source_review`. The notes describe a narrow correction of
  Christian-only analytical scope, not of source religion or automatic identity.[^proposal]
- Ten Christian-branch or pending-identity rows stay eligible; three unresolved rows go to human
  review.[^flight-log]
- Source caching (20 + 4 follow-up) retained its failures (cogsoconline `/about` 404,
  Hyattsville DNS, Detroit and Newark expired certificates); no security bypass.[^flight-log]
- Independent labels remain missing; this source research does not supply them.[^flight-log]

# Open actions

- On user approval: apply `scope_decisions_proposed.csv` once to
  `data/validation/church_scope_decisions.csv`, then run a selective church rebuild, tests and
  validation.[^flight-log] Not before post 1 publishes.
- Detroit (15511 Dexter Avenue), Newark (343 Meeker Avenue) and Binghamton (21 Montour Street)
  need current operator, address or relocation evidence, in
  [`human_review.csv`](../../../data/validation/church_scope_followup_2026-09-26/human_review.csv).[^human-review]
- [`identity_followup.csv`](../../../data/validation/church_scope_followup_2026-09-26/identity_followup.csv)
  lists per-record next actions (identity, current name, point, worship status); its notes say
  no full review is certified.[^identity-followup]
- An Rscript 4.3.2 attempt bootstrapped an untracked `renv/library/R-4.3` (renv only); deleting
  it was declined, so it remains for the user.[^flight-log]

# Files

- [Packet directory](../../../data/validation/church_scope_followup_2026-09-26/):
  [proposed decisions](../../../data/validation/church_scope_followup_2026-09-26/scope_decisions_proposed.csv),
  [dry-run summary](../../../data/validation/church_scope_followup_2026-09-26/dry_run_summary.json),
  [dry-run impact](../../../data/validation/church_scope_followup_2026-09-26/dry_run_impact.csv),
  [review ledger](../../../data/validation/church_scope_followup_2026-09-26/review_ledger.csv),
  [cache status](../../../data/validation/church_scope_followup_2026-09-26/cache_status.csv)
- `*.before` files snapshot the live church and museum decision inputs, and
  `working_labels_before/` archives the working label blanks.[^flight-log]
- `prepare.R` and `propose.py` are one-time; never rerun them.[^flight-log] `dry_run.R` is
  read-only.

[^report]: Scope follow-up dry-run summary (the packet has no written report)
[^proposal]: Proposed church scope decisions
[^human-review]: Scope follow-up human review queue
[^identity-followup]: Scope follow-up identity next actions
[^index]: Validation and review evidence index
[^flight-log]: Flight log, 2026-09-26 19:53 and 20:00 UTC entries and the post 1 rescope entry
