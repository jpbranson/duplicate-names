---
type: Status Report
title: Current project status
description: "Where the project stands at the last recorded checkpoint (2026-10-05): post 1 is rewritten, verified to decision 14 and staged as a draft awaiting the user's go-ahead to publish; museum counts unchanged; church work and the explorer frozen."
tags: [status, museums, churches, post-1]
sequence: 1
checkpoint: 2026-10-05
stale_after: 2026-11-05T00:00:00Z
generated: { by: claude-code/claude-fable-5-1, at: 2026-10-06T03:45:00Z }
sources:
  - id: flight-log
    resource: flight-log.md
    title: Flight log, entries through "Post 1 collisions verified; draft rewritten and staged"
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

- **Scope: post 1 ships first, and the scope held.** Under [decision 14](../decisions/14-post-1-headline-sufficient-review.md),
  approved on 2026-09-26, post 1 answers two questions: which museum name is number one, and
  whether there are surprising collisions. A check on 2026-10-05 found no dated packet after
  2026-09-26, the church scope proposal unapplied, and no change to church or explorer code
  since the rescope commit.[^flight-log]
- **Post 1 is ready for the user's review, not published.** The draft is rewritten to the
  brief and staged with `draft: true` in the blog repository. Publishing needs the user's
  explicit go-ahead.[^flight-log]
- **Nothing is published.** Both post bundles and the explorer remain unpublished.[^flight-log]
- **Cloud spending:** USD 0 against a budget of strictly less than USD 5.[^flight-log]

# Post 1 (museums)

- **M1 headline.** All eight non-chain Old Jail Museum members meet the decision 14
  standard, with per-member evidence in
  [`post1_headline_review.csv`](../inputs/post1-headline-review.md). V = 8, above every
  other group (none at 7, 38 at 6). The eight evidence pages were re-read on 2026-10-05 and
  are live.[^flight-log] Three more locations share the name but belong to multi-museum
  operators and are reported beside the headline.[^post1-review]
- **Surprising collisions (five groups, twelve records, checked 2026-10-05).**[^post1-review]

  | Group | Records | Count | Result |
  |---|---:|---:|---|
  | 100th Meridian Museum | 2 | 2 | Confirmed: Cozad NE and Erick OK; passes the gate |
  | Billy the Kid Museum | 3 | 2 | Fort Sumner NM and Hico TX count; the Clovis NM record matches no museum, so the gate fails for the name |
  | Santa Claus Museum | 2 | 1 | Columbus TX counts; the Indiana row duplicates the separately counted Santa Claus Museum and Village |
  | Mermaid Museum | 2 | 1 | Berlin MD counts; the Los Angeles record sits beside the venue of a four-day 2018 pop-up |
  | Salt and Pepper Shaker Museum | 3 | 1 | Gatlinburg TN counts; one row duplicates it; Traer IA calls itself a Gallery |

- **Publication gate.** `dn_assert_museum_publication_ready()` passes for Old Jail Museum and
  100th Meridian Museum with `post1_headline_review.csv`. `dn_post1_groups()` reports each
  member and marks a group confirmed only when the gate passes and every member counts. The
  gate checks recorded statuses, not evidence: see the
  [publication gate](../methodology/publication-gate.md).[^flight-log]
- **Draft.** [Post 1](../publications/post-1-museums.md) is rewritten to the original brief
  with a payload exported by `scripts/export_post1_payload.R`. It knits in isolation and
  builds as a draft in the blog's theme.[^flight-log]
- **Remaining for post 1:** the user reads the draft and approves publication; then set
  `draft: false`, commit and push the blog repository. See
  [publishing a post](../playbooks/publish-post.md).[^flight-log]
- **Deferred until after post 1.** Five records failed the check and are still counted in
  the data: the Clovis, Los Angeles, Indiana (IMLS) and San Francisco-coordinate rows, and
  Traer's public name. Each needs a sourced decision through the correction layer and a
  dated packet; none was applied, so no count changed.[^flight-log]

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
[count history](count-history.md) shows how earlier checkpoints reached these numbers. The
2026-10-05 work changed no decision, status, count or target.[^flight-log]

# Churches (frozen until post 1 publishes)

- The [ordinal/scope checkpoint](../evidence/churches/church_ordinal_review_2026-09-26.md)
  keeps 1,032,223 source rows and 540,778 canonical descriptions, 442,832 of them eligible
  after two sourced scope holds. There are zero complete factual reviews.[^church-report]
- Independent version-2 labels are blank; source research does not grade them. See
  [church independent labels](../inputs/church-independent-labels-v2.md).[^validation-index]
- The [scope follow-up proposal](../evidence/churches/church_scope_followup_2026-09-26.md)
  (23 guarded decisions; dry run passed; eligible would become 442,818) awaits user approval
  and is frozen. Live inputs and counts are unchanged.[^handoff]

# Explorer and church draft (frozen)

The [explorer](../publications/explorer.md) and the church draft were refreshed locally at the
M2 and church checkpoints. Browser CSV saving remains unverified and the explorer has no
deployment destination.[^handoff]

# Operational notes

- The blog is the `goodsite` repository beside this one (`jpbranson/goodsite`, branch
  `master`, served by Netlify at `jpbranson.rbind.io`). `DUPNAMES_BLOG_DIR` is not set in
  any `.Renviron`; pass it when staging. See [blog defaults](../architecture/blog-defaults.md).[^flight-log]
- `tar_outdated()` lists museum source targets, including `raw_overture_museums`, as
  outdated. Use the selective `tar_make(names = ...)` commands in the
  [README](../../README.md#running), not a full build.[^flight-log]
- `.gitignore` excludes 30 full-table snapshots (671 MB) whose hashes are recorded in later
  packets' `protected_files.csv`; the files remain on disk.[^flight-log]
- Use `C:\Program Files\R\R-4.4.2\bin\Rscript.exe`; the `Rscript` on `PATH` is 4.3.2
  without the renv library. An earlier 4.3.2 attempt left an untracked `renv/library/R-4.3`
  for the user to remove.[^flight-log]
- Neither Pandoc nor Hugo is on `PATH`. Knit with the portable Pandoc 3.11 under
  `data/processed/tools/pandoc/` (set `RSTUDIO_PANDOC`).[^flight-log]
- One-time packet scripts (`prepare`, `apply`, `propose`) are frozen; never rerun them.

[^flight-log]: Flight log, entries through "Post 1 collisions verified; draft rewritten and staged"
[^m2-report]: Leading M2 groups checkpoint report
[^church-report]: Church ordinal/scope checkpoint report
[^handoff]: HANDOFF.md header paragraphs, as of commit 7416eef
[^validation-index]: data/validation/README.md current-checkpoint and church sections, as of commit 7416eef
[^post1-review]: Post 1 headline review (decision 14 evidence)
