---
type: Method
title: "Franchise and branch detection (M4)"
description: "How sourced chain rules separate brand locations from independent collisions; unknown affiliation is NA, never independence."
tags: [chains, affiliation, museums]
sequence: 5
questions: [M4]
implemented_in: [../../R/museums.R, ../../R/resolve.R]
generated: { by: claude-code/claude-opus-5-5, at: 2026-10-05T02:28:14Z }
sources:
  - id: design
    resource: 7416eef:DESIGN.md
    title: "DESIGN.md §4.4, as of commit 7416eef (moved here verbatim)"
---

Flag collisions with evidence of common ownership or branch affiliation so they can be
held out of the "independent collision" headline. Since 2026-09-23, M1 and M2 count only
non-chain institutions; `museum_chains` summarizes each chain's locations and L2 names,
and `museum_chain_overlap` lists names a chain shares with other institutions. Evidence can include a shared operator,
a verified Wikidata parent, or a sourced chain lexicon. A nonempty operator field alone
does not establish a chain. Sourced rules in `data/validation/museum_chain_rules.csv`
replace that shortcut. Specific brand names can establish network affiliation; location
identity and liveness remain separate review questions. Name-only rules for ambiguous
labels such as Museum of Illusions and Smithsonian Institution are review hints. Sourced
location-specific decisions now verify 11 Museum of Illusions network locations and
affiliate the directory's 14 city-suffixed locations, 25 in all under 15 L2 names.
Hollywood's is a sub-attraction of the separately operated WonderWalk venue and counts
with it; Miami Beach remains unknown. `is_franchise = NA` means unknown;
only an explicit reviewed decision can establish independence.

Classify productive templates such as `Children's Museum of X` / `X County Historical
Museum` separately. Shared wording or inherited place names are not evidence of shared
ownership. Keep institution identity, affiliation, and name-pattern explanations distinct.
