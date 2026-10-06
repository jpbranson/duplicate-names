---
type: Mission
title: "Mission, constraints and status board"
description: "The 2026-09-25 authorized mission: order of work, the USD 5 cloud budget, the step status board (rescoped by decision 14) and how to resume."
tags: [mission, status]
sequence: 2
generated: { by: claude-code/claude-fable-5-1, at: 2026-10-06T03:45:00Z }
sources:
  - id: flight-log
    resource: 7416eef:FLIGHT_LOG.md
    title: "FLIGHT_LOG.md Mission, Status board and Resume here, as of commit 7416eef (moved here verbatim)"
  - id: flight-log-current
    resource: flight-log.md
    title: Flight log, entries through "Post 1 collisions verified; draft rewritten and staged"
---

# Mission and constraints

Authorized 2026-09-25 (America/Chicago): complete the museum reviews and post,
then church acquisition/analysis/post and the dashboard, in order. Keep a durable
resume record. Record genuine blockers for human review and continue independent
work where possible. Never mark unfinished work complete.

Cloud resource budget: **strictly less than USD 5 total**. Spending initiated by
this work: **USD 0**. Use local computation and public, anonymous downloads; do not
provision paid services or incur recurring charges without a known bounded cost.
Record every paid resource in the flight log before use. This ledger covers cloud resources
created/used for the project, not the user's existing assistant subscription.

# Status board

Rescoped by [decision 14](../decisions/14-post-1-headline-sufficient-review.md) on
2026-09-26 and brought up to date on 2026-10-05.[^flight-log-current] "Done to decision 14"
means the headline-sufficient standard, not a complete factual review.

| Step | Status | Completion evidence / remaining work |
|---|---|---|
| 1. Museum headline (M1) | Done to decision 14 | Old Jail Museum, V = 8; all eight members in `post1_headline_review.csv`; gate passes; evidence pages re-read 2026-10-05 |
| 2. Surprising collisions | Done to decision 14 | Five groups, twelve records checked 2026-10-05: one confirmed, one real with a record that matches no museum, three not collisions |
| 3. Post 1 payload and draft | Done; awaiting the user's read | `scripts/export_post1_payload.R`; draft rewritten to the brief; isolated knit and blog-theme draft build pass |
| 4. Publish post 1 | **Blocked on the user's go-ahead** | Staged with `draft: true` in the blog repository; set `draft: false`, commit and push `goodsite` |
| 5a. Church acquisition and resolution | Frozen until post 1 publishes | National build complete; 442,832 provisional eligible sites; independent labels and final identity validation pending |
| 5b. Church analysis and post | Frozen until post 1 publishes | C1-C4 outputs and isolated draft exist; factual and independent-label gates pending; 23-decision scope proposal awaits approval |
| 5c. Duplicate-name explorer | Frozen until post 1 publishes | Local draft built; browser save check and deployment destination missing |
| Not required for post 1 | Deferred by decision 14 | Remaining leader groups, M2 identities and meanings, affiliations, the 28 open review actions and the multi-site queue; five records that failed the 2026-10-05 check still need sourced corrections |

# Resume here

1. Read this file, the [status report](status.md), and the latest flight-log entry.
2. Inspect the working tree of this repository and of the blog repository; preserve any
   in-progress files and completed labels.
3. Continue the first unfinished step. A research lead is not a factual decision;
   a factual decision is not an independent matching-accuracy label.
4. Keep L2 museum headlines, non-chain scope, unknown affiliation, original source
   rows/coordinates, and the 0.85 matching threshold. Preserve old dated packets.
5. Update the [flight log](flight-log.md) at each meaningful checkpoint, including exact commands/files
   needed to resume and any failures or blockers.

**Next action (2026-10-05):** the user reads the staged draft and approves publication.
Then follow [publishing a post](../playbooks/publish-post.md): set `draft: false`, re-knit,
commit and push the blog repository, and confirm the live page. Do not publish without that
go-ahead. After post 1 publishes, the church freeze lifts; the 23-decision scope proposal
still needs its own approval.[^flight-log-current]

**Rescoped 2026-09-26 (user-approved; [decision 14](../decisions/14-post-1-headline-sufficient-review.md)):** ship post 1 first. Resolve
Old Jail Museum's pending members to the headline-sufficient standard and apply the M1
stopping rule; verify at most five surprising-collision groups; rewrite the draft to the
original brief; publish on the blogdown site. No further leader batches. Church work
(including the 23-decision scope proposal below) and the explorer are frozen until post 1
publishes. This supersedes the next action below.

Superseded next action: the church scope follow-up proposal (23 guarded COGASOC scope decisions; read-only dry run passed, eligible would become 442,818) awaits user approval before its one-time apply, rebuild and validation. Then continue remaining museum headline and church factual source checks. Project documentation was audited and synchronized at 20:15 UTC. Five highest-ordinal cases are flagged for human review. Independent church labels and publication destination remain missing. Counts: museums 52,387 counted / 52,255 eligible / 174 complete reviews; churches 540,778 canonical / 442,832 eligible / zero complete reviews. Do not rerun frozen packet scripts. Cloud spending USD 0.

[^flight-log-current]: Flight log, entries through "Post 1 collisions verified; draft rewritten and staged"
