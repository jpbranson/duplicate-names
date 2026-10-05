---
type: Lead
title: "Duplicate names nested inside duplicate names"
description: "County historical societies duplicate because counties do: inherited duplication as a third category."
tags: [leads, museums, post-1]
sequence: 10
lead_origin: surfaced
surfaced: 2026-09-07
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: leads
    resource: 7416eef:LEADS.md
    title: "LEADS.md 'Duplicate names nested inside duplicate names', as of commit 7416eef (moved here verbatim)"
---

The most duplicated museum names in the raw Overture + IMLS pull are not
singular claims at all — they are *productive templates*:
`Washington County Historical Society` (27), `Union County` (17), `Jackson
County` (15), `Monroe` (14), `Wayne` (13), `Franklin`/`Greene`/`Jefferson`/
`Madison` (12 each).

These are historical source-row observations, not verified institution totals. Phase 2
confirmed that the old metric still counted source rows and aliases. Selecting one
canonical museum name per entity gave 19 for `washington county historical society`.
The first [identity corrections](../evidence/museums/museum_identity_review_2026-09-15.md)
reduced this to 16 provisional entities; the
[focused follow-up](../evidence/museums/museum_focused_review_2026-09-15.md) reduced it to 14
after consolidating LeMoyne House and isolating contradictory source rows. The later
[address pass](../evidence/museums/museum_address_review_2026-09-15.md) reduces it to 13 by
linking Chipley's older mailing record to the museum through its EIN. Old Jail
Museum initially led at 15; its [focused review](../evidence/museums/museum_old_jail_review_2026-09-15.md)
reduces it to 12, leaving Union County Historical Society provisionally first at 14
at that checkpoint. The September 17
[Union County review](../evidence/museums/museum_union_county_review_2026-09-17.md) applies
six further identity corrections and reduces that exact-name group to seven.
The September 23 [leaders review](../evidence/museums/museum_leaders_review_2026-09-23.md) reduces
Washington County Historical Society from 13 to seven: five of its society records are the
operators of differently named museums (Stevens Memorial, Miller House, Port o' Plymouth,
Dewey Hotel, Washington County Heritage Center), and one IMLS row belongs to another
organization. Several remaining records describe a headquarters, archives or umbrella
society rather than a museum. By the September 26 M2 checkpoint, Washington County
Historical Society has four provisional institutions and Union County three; Old Jail Museum
leads provisionally at eight. No leading name is publication ready.

The interesting part is that this duplication is **downstream of a different
duplication**. There are ~31 Washington Counties in the US; the historical
societies are duplicated because the *counties* are. The collision isn't in the
museum namespace, it's inherited from the county namespace one level up.

**Question:** which duplicated names are original, and which are merely
inherited from a duplicated place name? That is a genuinely different question
from either "who claims to be THE one" or "which chains have many branches" —
a third category alongside the singular-claim and franchise cases, and it needs
its own treatment in post 1 rather than being lumped into the generic tail.
Repeated templates do not by themselves imply common ownership; classify inherited
duplication separately from the sourced affiliations now used for M4.
*Data:* already in hand. Census/GNIS county and place names give the upstream
duplication directly.
