---
type: Evidence Packet
title: Adams and Brown County museum review
description: Eighteen Adams and Brown County Historical Society candidates reviewed; 52,526 counted and 52,394 eligible institutions, 65 complete factual reviews and six unresolved records.
resource: ../../../data/validation/museum_adams_brown_2026-09-26.md
tags: [museums, leaders, identity, not-museum, checkpoint]
status: deprecated
checkpoint: 2026-09-26
sequence: 17
superseded_by: museum_discovery_pioneer_2026-09-26.md
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: report
    resource: ../../../data/validation/museum_adams_brown_2026-09-26.md
    title: Adams and Brown County museum review checkpoint report
  - id: packet
    resource: ../../../data/validation/museum_adams_brown_2026-09-26/
    title: Adams and Brown County packet (candidates, context, decisions, audit, validation)
  - id: follow-up
    resource: ../../../data/validation/museum_adams_brown_2026-09-26/follow_up.csv
    title: Adams and Brown County unresolved records
---

# Scope

Reviews the bare Adams County and Brown County Historical Society groups: 18 starting
candidates, 172 related source rows and 88 pinned Overture context rows.[^report] Preceded
by [the Museum Depot and Wayne County checkpoint](museum_next_leaders_2026-09-26.md);
superseded by [the Children's Discovery Museum and Pioneer Village review](museum_discovery_pioneer_2026-09-26.md).
Deprecated: a later checkpoint superseded its counts; the packet remains valid historical
evidence.

# Outcome

The report gives no before/after count table; its counts and group changes:[^report]

| Measure | At this checkpoint |
|---|---:|
| Original source rows retained | 60,002 |
| Counted source rows | 57,239 |
| Counted institutions | 52,526 |
| Eligible institutions | 52,394 |
| Identity rows / cases | 179 / 69 |
| Complete factual reviews | 65 |
| Sourced not_museum decisions | 15 |
| Public-name overrides | 27 |

| Bare L2 group | Before | After |
|---|---:|---:|
| Adams County Historical Society | 9 | 2 (unresolved Washington institutions) |
| Brown County Historical Society | 9 | 1 (unresolved Nebraska institution) |

- The batch adds 19 explicit identity members in six cases, eighteen factual decisions, nine
  preferred names and twelve complete factual reviews. These are identity, affiliation and
  public-name corrections, not inferred closures. Seven leading names still count nine each;
  no national M1/M2 winner is certified.[^report]
- Reconciliations: Beyond the Battle Museum (Adams PA) reconciles four current/former/mailing
  records, with Shriver House Museum separate and both under Gettysburg History; the Adams ID
  depot, the Adams IN Dugan Mansion museum, Brown IN's History Center campus and Brown WI's
  Hazelwood Historic House Museum each count once.[^report]
- Not a museum: the Adams NE society (an archive, publishing and research organization
  within Hastings Museum), the Brown SD society (a support/publishing organization for
  Dacotah Prairie Museum) and the Brown KS genealogical library. The related museums remain
  counted; Brown KS keeps two distinct museums with common society affiliation.[^report]
- Validation: selective exports and 322 test assertions pass, with 18 integrity checks and
  all 638 protected earlier evidence/label files unchanged. The 0.85 threshold and archived
  human labels are unchanged. `build_validate.log` records the failed remaining-leader
  publication gate.[^report]
- Of 47 public-source cache attempts, 44 succeeded and three returned HTTP 403. No source
  coordinates were rewritten.[^report]

# Open actions

Six records remain pending in
[`follow_up.csv`](../../../data/validation/museum_adams_brown_2026-09-26/follow_up.csv): two
Adams WA records, Adams WI's generic PO Box row, Brown NE, Brown IL (Whistle Stop Depot
Museum) and Brown OH. They are unfinished factual work, not automatic exclusions or
approvals.[^report][^follow-up] Public-page access wording must be rechecked before
publication, and the museum post and explorer still represent the Depot/Wayne
checkpoint.[^report]

# Files

- [Checkpoint report](../../../data/validation/museum_adams_brown_2026-09-26.md)
- [Packet directory](../../../data/validation/museum_adams_brown_2026-09-26/):
  [counts](../../../data/validation/museum_adams_brown_2026-09-26/counts.csv),
  [candidate dispositions](../../../data/validation/museum_adams_brown_2026-09-26/candidate_dispositions.csv),
  [identity audit](../../../data/validation/museum_adams_brown_2026-09-26/identity_audit_after.csv),
  [ranking after](../../../data/validation/museum_adams_brown_2026-09-26/ranking_after.csv),
  [integrity checks](../../../data/validation/museum_adams_brown_2026-09-26/integrity_checks.csv),
  [build/validate log](../../../data/validation/museum_adams_brown_2026-09-26/build_validate.log)
- `apply.R` has already applied successfully; never rerun its live mode or the one-time
  `prepare.R` snapshot.[^report]

[^report]: Adams and Brown County museum review checkpoint report
[^follow-up]: Adams and Brown County unresolved records
