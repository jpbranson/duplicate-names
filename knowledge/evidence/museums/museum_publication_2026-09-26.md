---
type: Evidence Packet
title: Museum publication preparation — unpublished draft and opening example
description: Prepares an unpublished museum draft, completes the International Cryptozoology Museum seed review and adds publication-point tooling; 52,557 counted and 52,425 eligible institutions, 40 complete factual reviews.
resource: ../../../data/validation/museum_publication_2026-09-26.md
tags: [museums, publication, post-1, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 15
superseded_by: museum_next_leaders_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_publication_2026-09-26.md
    title: Museum publication preparation checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_publication_2026-09-26/
    title: Publication preparation packet
  - id: blockers
    resource: ../../../data/validation/museum_publication_2026-09-26/publication_blockers.csv
    title: Publication blockers at the publication-preparation checkpoint
---

# Scope

Prepares an unpublished draft of the museum post, not a certified museum winner: one
opening-example review, publication-point tooling and an isolated render of the draft
bundle.[^report] Preceded by [the affiliation follow-up](museum_affiliation_followup_2026-09-26.md);
superseded by [the Museum Depot and Wayne County checkpoint](museum_next_leaders_2026-09-26.md).
Deprecated: a later checkpoint superseded its counts; the packet remains valid historical
evidence.

# Outcome

The report gives no before/after table. Its counts:[^report]

| Measure | At this checkpoint |
|---|---:|
| Original records retained | 60,002 |
| Counted source rows | 57,272 |
| Counted institutions | 52,557 |
| Eligible L2 institutions | 52,425 |
| Identity rows / cases | 125 / 51 |
| Isolated source conflicts | 7 |
| Sourced not-museum decisions | 11 |
| Complete factual reviews | 40 |

- The International Cryptozoology Museum seed now has a complete factual review: its
  operator documents the current Bangor location, closed older locations and its own
  nonprofit governance. Four historical source records represent one reviewed institution.
  This does not establish worldwide uniqueness.[^report]
- The explicit selected-name [publication gate](../../methodology/publication-gate.md)
  passes for this seed; the leading M1/M2 groups remain uncertified.[^report]
- `dn_museum_publication_points()` checks source identity/name/coordinate guards, evidence
  and dates, and adds separate publication coordinates and access wording; it never replaces
  source points. The three sourced
  [address overrides](../../inputs/publication-locations.md) have fresh operator access
  checks: Mandeville remains closed, Smedley lists weekend access, and Wright House lists
  events or arranged tours. Pending identity reviews still prevent visitor-ready status, and
  these checks expire after 30 days by default.[^report]
- The [museum bundle](../../../posts/duplicate-museum-names/README.md) holds its own payloads
  and helpers, a clearly provisional count-comparison chart and matching validation evidence;
  its front matter retains `draft: true`. It was rendered in an isolated directory with a
  portable, checksum-verified official Pandoc release. The first attempt exposed helper
  scoping, which was fixed; the original failed log is retained.[^report]
- Validation: 265 assertions and 10 integrity checks pass; all 418 protected prior files are
  unchanged. The original independent labels, automatic museum baseline, source fields and
  0.85 threshold are preserved. These checks do not certify factual judgments or
  final-cluster accuracy.[^report]
- [Decision 14](../../decisions/14-post-1-headline-sufficient-review.md) later set the
  headline standard for [post 1](../../publications/post-1-museums.md).

# Open actions

County/Old Jail and new leader reviews, unresolved Smithsonian roles, M2 meaning and identity
checks, final headline payloads and publication remain incomplete. No blog checkout is
configured, the default destination is absent and no site was published.[^report] Remaining
steps are listed in
[`publication_blockers.csv`](../../../data/validation/museum_publication_2026-09-26/publication_blockers.csv).[^blockers]

# Files

- [Checkpoint report](../../../data/validation/museum_publication_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_publication_2026-09-26/):
  [publication gates](../../../data/validation/museum_publication_2026-09-26/publication_gates.csv),
  [publication points](../../../data/validation/museum_publication_2026-09-26/publication_points.csv),
  [access checks](../../../data/validation/museum_publication_2026-09-26/access_checks.csv),
  [seed decision](../../../data/validation/museum_publication_2026-09-26/seed_decision.csv),
  [standalone build](../../../data/validation/museum_publication_2026-09-26/standalone_build.json),
  [integrity checks](../../../data/validation/museum_publication_2026-09-26/integrity_checks.csv)
- `build_export.R` rebuilds targets and writes both this packet's outputs and the draft
  bundle's `payload/` files.[^packet]
- One-time scripts (`prepare.R`, `apply_seed.R`) are frozen; never rerun them.

[^report]: Museum publication preparation checkpoint report
[^blockers]: Publication blockers at the publication-preparation checkpoint
[^packet]: Publication preparation packet
