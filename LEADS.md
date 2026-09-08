# Leads Register

Analogous name-collision phenomena worth a future post. Seeded before analysis; **append
here whenever something surfaces during Phase 2/3 work** rather than chasing it inline.

Format: one heading per lead, with the question, why it's interesting, and a data note.

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
exactly C5's claim. Might belong *inside* the churches post as supporting evidence.
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

The interesting part is that this duplication is **downstream of a different
duplication**. There are ~31 Washington Counties in the US; the historical
societies are duplicated because the *counties* are. The collision isn't in the
museum namespace, it's inherited from the county namespace one level up.

**Question:** which duplicated names are original, and which are merely
inherited from a duplicated place name? That is a genuinely different question
from either "who claims to be THE one" or "which chains have many branches" —
a third category alongside the singular-claim and franchise cases, and it needs
its own treatment in post 1 rather than being lumped into the generic tail.
*Data:* already in hand. Census/GNIS county and place names give the upstream
duplication directly.

### Institutions whose name is just their category
`art gallery` (37), `planetarium` (14), `fine arts gallery` (12), plus 17 rows
with an empty name. These are POI records where the mapper typed the category
instead of a name.

Mostly a cleaning problem — they must not be counted as duplicates — but it
raises a real question for the churches post too: how many institutions have no
distinct name at all? A congregation listed only as "Church" is a data gap, but
a museum whose actual signage reads "Art Gallery" is a naming *choice*, and the
two are hard to tell apart from POI data alone. Worth a paragraph, not a post.
