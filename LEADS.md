# Leads Register

Analogous name-collision phenomena worth a future post. Seeded before analysis; **append
here whenever something surfaces during Phase 2/3 work** rather than chasing it inline.

Format: one heading per lead, with the question, why it's interesting, and a data note.

**Status, 2026-09-23:** Phase 2 tooling and the source/identity passes through the
[provisional leaders review](data/validation/museum_leaders_review_2026-09-23.md)
are complete. Remaining headline checks precede the post. The dated counts below remain
exploratory observations, not verified publication figures; see
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

These are historical source-row observations, not verified institution totals. Phase 2
confirmed that the old metric still counted source rows and aliases. Selecting one
canonical museum name per entity gave 19 for `washington county historical society`.
The first [identity corrections](data/validation/museum_identity_review_2026-09-15.md)
reduced this to 16 provisional entities; the
[focused follow-up](data/validation/museum_focused_review_2026-09-15.md) reduced it to 14
after consolidating LeMoyne House and isolating contradictory source rows. The later
[address pass](data/validation/museum_address_review_2026-09-15.md) reduces it to 13 by
linking Chipley's older mailing record to the museum through its EIN. Old Jail
Museum initially led at 15; its [focused review](data/validation/museum_old_jail_review_2026-09-15.md)
reduces it to 12, leaving Union County Historical Society provisionally first at 14
at that checkpoint. The September 17
[Union County review](data/validation/museum_union_county_review_2026-09-17.md) applies
six further identity corrections and reduces that exact-name group to seven.
The September 23 [leaders review](data/validation/museum_leaders_review_2026-09-23.md) reduces
Washington County Historical Society from 13 to seven: five of its society records are the
operators of differently named museums (Stevens Memorial, Miller House, Port o' Plymouth,
Dewey Hotel, Washington County Heritage Center), and one IMLS row belongs to another
organization. Several remaining records describe a headquarters, archives or umbrella
society rather than a museum. No leading name is publication ready.

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

**Phase 2 implementation:** category-only flags now create reviewable holdouts, with
source-level evidence decisions and an unfiltered comparison ranking. Cal Poly actually
uses [University Art Gallery](https://cla.calpoly.edu/university-art-gallery) as a name;
UC San Diego documents that same wording as the former name of its
[Mandeville Art Gallery](https://mandevilleartgallery.ucsd.edu/about/history.html).
That is both a naming phenomenon and a snapshot-age problem. The identity pass now
retains the UCSD, Baylor and Stony Brook former names as aliases of their current
institutions. Five University Art Gallery names are confirmed; NMSU remains a
historical-name holdout, and 131 category decisions remain pending across the full queue.
These are naming decisions, not completed institution reviews.

### Two networks can share a chain-sounding name (Phase 2, 2026-09-15)
Museum of Illusions cannot safely be assigned to one parent from its name alone.
The [global network's location directory](https://www.museumofillusions.com/our-locations/)
and [Los Angeles attraction](https://illusions-la.com/) need location-level reconciliation.
A [2021 court order](https://business.cch.com/ipld/MetamorfozaBigFunny20210727.pdf)
describes separate operators using the wording in Los Angeles and Miami. This is a
research lead, not a conclusion about current ownership or the merits of a legal claim.
The first source pass established global-network affiliation for 11 candidate locations.
The [leaders review](data/validation/museum_leaders_review_2026-09-23.md) verifies them and finds Hollywood's
"Museum of Illusions" is one of three attractions in the WonderWalk venue, whose operator
calls the Santa Monica museum "a separate business"; Miami Beach's operator domain has lapsed.
The official directory lists 25 open US locations; 14 carry city-suffixed names, so an
exact-name count measures one chain's listing style, not independent naming. Brand affiliation does not establish common
legal ownership. See the [source report](data/validation/museum_source_review_2026-09-15.md).

### Relocations can impersonate national collisions (Phase 2, 2026-09-15)
The initial candidate ranking had four National Electronics Museum entities. Its own
[history](https://www.nationalelectronicsmuseum.org/about-us/history-mission/) documents
a move from Linthicum to Hunt Valley and reopening in November 2024. The name-based
multi-site gate stops merging once too many sites appear, so extra stale/geocoded
records can make one institution look more independent, not less. The
[identity pass](data/validation/museum_identity_review_2026-09-15.md) now reconciles
those four and the Historical Electronics alias into one institution using relocation,
address and website evidence, including the later Middle River move. Public reopening
is not established. The automatic rule is unchanged; evaluate any future rule change
with fresh independent labels before claiming improved matching accuracy. Nearby-pair
diagnostics also cover cases outside the original 150 m candidate radius.

### Mixed records can create collisions as well as duplicates (Phase 2, 2026-09-15)
The [focused Pennsylvania review](data/validation/museum_focused_review_2026-09-15.md)
found one IMLS row mixing a Pennsylvania society's common name/address with a New York
gallery's legal name, website and EIN. Another used the society's name with a different
organization's EIN and Venetia mailing address. Neither row can establish a museum
identity from its name alone; both now remain isolated, uncounted and auditable.
**Question:** how much apparent name duplication comes from fields belonging to different
institutions being combined into one source record? Generated dossiers and future review
archives now retain original tax IDs and separate physical/mailing addresses; the legacy
coalesced address can hide the contradiction. These additions support the next source
checks without changing the existing identity decisions. The subsequent address pass
confirms Peters Creek's physical museum and consolidates its two accepted Overture
records, while preserving the contradictory IMLS row as a separate holdout. Tax IDs
help identify an organization; they do not justify copying all fields from a mixed row.
