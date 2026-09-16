# Leads Register

Analogous name-collision phenomena worth a future post. Seeded before analysis; **append
here whenever something surfaces during Phase 2/3 work** rather than chasing it inline.

Format: one heading per lead, with the question, why it's interesting, and a data note.

**Status, 2026-09-15:** Phase 1a's human-label scoring is complete. Phase 2 starts with
category-only name handling and a cleaned museum ranking for top-20 review. The counts
below are exploratory September 7 observations, not verified publication figures; see
[HANDOFF.md](HANDOFF.md) for current work and the
[validation report](data/validation/resolution_validation_2026-09-15.md) for sample limits.

---

## Seeded leads

### "First National Bank"
The same ordinal convention as churches, but with an actual regulator — the OCC issued
numbered national bank charters starting in 1863, and charter #1 is a matter of record.
**Question:** does a regulated namespace produce different collision behavior than an
unregulated one? This is the natural control group for the churches post.
*Data:* FDIC BankFind institution history, FFIEC, OCC charter numbers. Excellent coverage.

### "The Original Ray's Pizza"
NYC's famous unresolvable naming war — Ray's, Famous Ray's, Original Ray's, Famous Original
Ray's. A namespace where the *claim of priority itself* became the productive template.
**Question:** what other trade names escalate adjectivally when they can't be enforced?
*Data:* NY State DOS business filings, Overture places. Small-n but delightful.

### "World Famous" / "World's Largest"
Roadside attraction hubris at scale. World's Largest Ball of Twine has at least four
credible claimants with competing definitions (largest by one man, largest by a community,
largest sisal). **Question:** superlative claims as a genre — how do claimants carve up a
superlative they can't share?
*Data:* Roadside America, Atlas Obscura, Wikipedia list articles. Scraping-dependent.

### Central High School / Lincoln High School
Schools have a governing body per district, so collisions are cross-district by
construction. **Question:** the "Washington/Lincoln/Central/Memorial" naming exhaustion —
and the recent renaming wave (Confederate-named schools) as a natural experiment in what
replaces a name when one is forcibly retired.
*Data:* NCES Common Core of Data. Very clean, full US coverage, with year-over-year files
that make renames directly observable. **Strongest lead in this list after banks.**

### Saint-named hospitals
Same saint lexicon as Catholic churches, but with mergers producing absurd compound names
(Saint Luke's–Roosevelt, CHRISTUS St. Vincent). **Question:** what happens to a duplicated
name namespace under consolidation pressure? Churches merge too — a direct comparison.
*Data:* CMS Provider of Services file, AHA. Good coverage.

### Masonic lodges, VFW posts, Elks lodges
Explicitly *numbered* namespaces with a central registrar — the numbers are assigned, not
claimed. **Question:** the fully administered case at the opposite end of the spectrum
from museums. Together with banks (regulated) and churches (self-numbered) this gives a
three-point scale of namespace governance.
*Data:* fraternal order directories; patchy but enumerable.

### Main Street / Second Street
The classic duplicate-toponym result (Second Street outnumbers First Street in the US, for
a nice reason: many towns' First Street is called Main). **Question:** already
well-covered ground — include only as a callback, not a post.
*Data:* TIGER/Line. Trivial to compute.

### Theater names: Bijou, Rialto, Orpheum, Roxy
A vanished naming fashion with sharp date boundaries — these cluster hard in 1900–1930.
**Question:** the cleanest available test of "naming conventions have eras," which is
exactly C5's claim. Might belong inside the deferred naming-over-time post (D3) as
supporting evidence.
*Data:* Cinema Treasures, NRHP. Decent.

### Breweries: Common, Union, Anchor, Wolf
The modern craft-brewery naming collapse — a small lexicon exhausted within a decade,
producing trademark fights. **Question:** what does a namespace look like *while* it
saturates, rather than centuries after?
*Data:* TTB Brewer's Notice list (public, dated). Dates are the strong point here.

---

## Surfaced during analysis

### Duplicate names nested inside duplicate names (Phase 1a, 2026-09-07)
The most duplicated museum names in the raw Overture + IMLS pull are not
singular claims at all — they are *productive templates*:
`Washington County Historical Society` (27), `Union County` (17), `Jackson
County` (15), `Monroe` (14), `Wayne` (13), `Franklin`/`Greene`/`Jefferson`/
`Madison` (12 each).

These are observations from before the society-under-museum merge. That rule moved
`washington county historical society` from 27 to 19 in the saved results. Recompute and
verify the ranking in Phase 2 before citing any of these counts as findings.

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
duplication separately from franchises when implementing M4.
*Data:* already in hand. Census/GNIS county and place names give the upstream
duplication directly.

### Institutions whose name is just their category
The saved September 7 results include `art gallery` (37), `planetarium` (14),
`fine arts gallery` (12), plus 17 rows with an empty name. Empty names are already excluded
by the counting policy. The category-like strings may be mapper-supplied placeholders or
actual signage; the existing names alone do not distinguish them.

Confirmed placeholders must not count as duplicate institution names, but this
raises a real question for the churches post too: how many institutions have no
distinct name at all? A congregation listed only as "Church" is a data gap, but
a museum whose actual signage reads "Art Gallery" is a naming *choice*, and the
two are hard to tell apart from POI data alone. Worth a paragraph, not a post.

**Phase 2 action:** introduce an auditable flag and review rule, preserve source records,
and record evidence for exclusion or retention. Resolve ambiguous leading cases before
publishing the top-20 ranking. This is the first analysis task, not a completed cleanup.
