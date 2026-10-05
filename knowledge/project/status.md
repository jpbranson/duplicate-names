---
type: Status Report
title: Current project status
description: "Where the project stands at the last recorded checkpoint (2026-09-26): post 1 ships first, museum counts at the M2 checkpoint, church work and the explorer frozen, nothing published."
tags: [status, museums, churches, post-1]
sequence: 1
checkpoint: 2026-09-26
stale_after: 2026-11-05T00:00:00Z
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: flight-log
    resource: flight-log.md
    title: Flight log, entries through "Gate change committed; surprising-collision shortlist"
  - id: m2-report
    resource: ../../data/validation/museum_m2_leaders_2026-09-26.md
    title: Leading M2 groups checkpoint report
  - id: church-report
    resource: ../../data/validation/church_ordinal_review_2026-09-26.md
    title: Church ordinal/scope checkpoint report
  - id: handoff
    resource: 7416eef:HANDOFF.md
    title: HANDOFF.md header paragraphs, as of commit 7416eef
  - id: validation-index
    resource: 7416eef:data/validation/README.md
    title: data/validation/README.md current-checkpoint and church sections, as of commit 7416eef
  - id: post1-review
    resource: ../../data/validation/post1_headline_review.csv
    title: Post 1 headline review (decision 14 evidence)
---

# Summary

Refresh this report at the next checkpoint, and no later than its `stale_after` date. It
synthesizes the sources below; the [mission board](mission.md) and [flight log](flight-log.md)
hold the step-by-step record.

- **Scope: post 1 ships first.** Under [decision 14](../decisions/14-post-1-headline-sufficient-review.md),
  approved on 2026-09-26, post 1 answers two questions: which museum name is number one, and
  whether there are surprising collisions. Its publication target is the blogdown site.
  Church work, including the 23-decision scope proposal, and the explorer are frozen until
  post 1 publishes.[^flight-log]
- **Nothing is published.** Both post bundles and the explorer are local, unpublished
  drafts.[^handoff]
- **Cloud spending:** USD 0 against a budget of strictly less than USD 5.[^flight-log]

# Post 1 (museums)

- **M1 headline.** All eight non-chain Old Jail Museum members meet the decision 14
  standard, with per-member evidence in
  [`post1_headline_review.csv`](../inputs/post1-headline-review.md). V = 8, above every
  other group (none at 7, 38 at 6). The upward-risk check on the 38 six-member groups found
  that every L4 variant carries a place name, so none joins its L2 group.[^flight-log] The
  flight log records this as the M1 stopping rule applied: Old Jail Museum is the headline. Details are in
  [post 1](../publications/post-1-museums.md).
- **Publication gate.** `dn_assert_museum_publication_ready()` now accepts a
  `headline_review` table. Old Jail passes with `post1_headline_review.csv` (4 verified + 4
  decision-14 members); committed as `5b50ab3` with 366 tests passing.[^flight-log] The gate
  checks recorded statuses, not evidence: see the [publication gate](../methodology/publication-gate.md).
- **Surprising collisions.** Five candidate groups are shortlisted but not yet verified to
  decision 14: Billy the Kid Museum, 100th Meridian Museum, Santa Claus Museum, The Mermaid
  Museum, and Salt and Pepper Shaker Museum.[^flight-log]
- **Remaining for post 1:** verify at most five surprising-collision groups, rewrite the
  draft to the original brief, then publish on the blogdown site. No further leader
  batches.[^flight-log]

# Museum counts (M2 checkpoint, latest)

| Measure | Value |
|---|---:|
| Preserved source rows | 60,002 |
| Counted source rows | 57,083 |
| Counted institutions | 52,387 |
| Eligible for L2 analysis | 52,255 |
| Guarded identity rows / cases | 440 / 185 |
| Complete factual reviews, including exclusions | 174 |
| Positive not-museum exclusions | 25 |
| Isolated source conflicts | 35 |
| Open review actions | 28 |

Source: the [M2 leading-groups checkpoint](../evidence/museums/museum_m2_leaders_2026-09-26.md).[^m2-report]
Counts remain provisional; unknown affiliation is not independence.[^validation-index] The
[count history](count-history.md) shows how earlier checkpoints reached these numbers.

# Churches (frozen until post 1 publishes)

- The [ordinal/scope checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md)
  keeps 1,032,223 source rows and 540,778 canonical descriptions, 442,832 of them eligible
  after two sourced scope holds. There are zero complete factual reviews.[^church-report]
- Independent version-2 labels are blank; source research does not grade them. See
  [church independent labels](../inputs/church-independent-labels-v2.md).[^validation-index]
- The [scope follow-up proposal](../evidence/churches/church_scope_followup_2026-09-26.md)
  (23 guarded decisions; dry run passed; eligible would become 442,818) awaits user approval
  and is frozen. Live inputs and counts are unchanged.[^handoff]

# Explorer and drafts (frozen)

The [explorer](../publications/explorer.md) and both drafts were refreshed locally at the M2
and church checkpoints. Browser CSV saving remains unverified and no deployment destination
is configured.[^handoff]

# Operational notes

- `tar_outdated()` lists museum source targets, including `raw_overture_museums`, as
  outdated. Use the selective `tar_make(names = ...)` commands in the
  [README](../../README.md#running), not a full build.[^flight-log]
- `.gitignore` excludes 30 full-table snapshots (671 MB) whose hashes are recorded in later
  packets' `protected_files.csv`; the files remain on disk.[^flight-log]
- Use `C:\Program Files\R\R-4.4.2\bin\Rscript.exe`; the `Rscript` on `PATH` is 4.3.2
  without the renv library. An earlier 4.3.2 attempt left an untracked `renv/library/R-4.3`
  for the user to remove.[^flight-log]
- One-time packet scripts (`prepare`, `apply`, `propose`) are frozen; never rerun them.

[^flight-log]: Flight log, entries through "Gate change committed; surprising-collision shortlist"
[^m2-report]: Leading M2 groups checkpoint report
[^church-report]: Church ordinal/scope checkpoint report
[^handoff]: HANDOFF.md header paragraphs, as of commit 7416eef
[^validation-index]: data/validation/README.md current-checkpoint and church sections, as of commit 7416eef
