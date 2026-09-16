# Old Jail Museum — leading-name factual review

**2026-09-15.** Reviewed all **15 starting candidates** for the provisional leading L2
name, plus their source-cluster members and nearby museum/society records. The
[candidate dispositions](museum_old_jail_review_2026-09-15/candidate_review.csv) account
for every starting candidate. Old Jail
Museum now counts **12**; Union County Historical Society leads provisionally at **14**.
This completes a review batch, not the broader top-20 review or headline certification.

## Count effects

| Measure | Before | After |
|---|---:|---:|
| Source rows retained | 60,002 | 60,002 |
| Counted source rows | 57,327 | 57,313 |
| Counted institutions | 52,617 | 52,605 |
| Eligible for L2 name analysis | 52,485 | 52,473 |
| Old Jail Museum | 15 | 12 |
| Washington County Historical Society | 13 | 13 |
| Institutions with complete factual review | 0 | 2 |

The Old Jail decrease comes from one Winchester consolidation and two Dubuque holds.
Other consolidations remove society names and mailing records from separate institution
counts. Twenty-three explicitly listed source records from 20 baseline entities are
handled in nine new cases: eight canonical institutions and two isolated holdouts.
Jim Thorpe was already one automatic entity; its two counted source rows now have one
reviewed representative. The live input contains **56 rows in 22 cases**, with 20
canonical institutions and four isolated source conflicts.
[Counts](museum_old_jail_review_2026-09-15/count_effects.csv),
[ranking](museum_old_jail_review_2026-09-15/ranking_after.csv),
[source audit](museum_old_jail_review_2026-09-15/identity_audit.csv).

## Identity findings

| Location | Result |
|---|---|
| Winchester, TN | Combine Overture and IMLS Old Jail records. The city address and source phone match; preserve Bluff Street/Dinah Shore address variants and the displaced IMLS point. Leave the separate Franklin County Historical Society record unresolved: its current library history-room activity and different EIN do not establish museum membership. |
| Hayesville, NC | Combine the two museum-name records at 21 Davis Loop. The heritage authority and town plan link the historical/arts museum to Old Jail Museum. |
| Albion, IN | Combine Old Jail, the society record at 215 West Main and its displaced IMLS record. The operator supplies both that street and PO Box 152. |
| Allegan, MI | Combine Old Jail and two society records at 113 North Walnut. Retain John Pahl Historical Village separately; the operator explicitly distinguishes it. Ignore unrelated/obsolete source website fields when the local name/address evidence establishes membership. |
| Smethport, PA | Combine the two museum/society records at 502 West King with the IMLS mailing address at 500 West Main. Current operator wording also uses County Museum in the Old Jail; preferred-name review remains open. |
| Greenwood, AR | Combine Old Jail, its society and mailbox records, and the historical Sebastian County Jail alias. Retain the Coal Mine Memorial separately. Address variants and the offset historic-building point remain documented for visitor-map review. |
| Thompson Falls, MT | Combine the museum at 109 South Madison with the society's PO Box 774. State tourism and the chamber member profile provide the address/museum link. |
| Jim Thorpe, PA | Keep the existing entity; select one counted source representative. Official museum and IRS evidence agree on the legal identity and 128 West Broadway. Preserve the inconsistent IMLS physical ZIP as a source defect. |

Each case's evidence URLs and limitations are in the
[applied decisions](museum_old_jail_review_2026-09-15/applied_identity_decisions.csv).
The [ledger](museum_old_jail_review_2026-09-15/evidence.csv) also covers the candidates
whose memberships were unchanged. No source name or coordinate was overwritten.

**Dubuque requires a hold, not another inferred merge.** Both rows carry a
`sanderscounty.org` website despite Iowa addresses. One names the historical jail at
36 East 8th Street; the other uses the river-museum address at 350 East 3rd Street.
An older city history page describes museum use, while the county's current directory
places Veteran Services in the old jail. These mixed/historical records do not establish
two current Old Jail museums. Both receive separate `reviewed_source_conflict` exclusions;
neither is assigned to the river museum or to Montana. This does not assert a resolved
closure date. [Current county directory](https://www.dubuquecountyiowa.gov/directory.aspx?did=35),
[county building history](https://www.dubuquecountyiowa.gov/471/Historic-Old-Jail),
[older city history](https://www.flydbq.com/704/Dubuque-County-Jail).

## Names, affiliation and factual review

Albion and Jim Thorpe now have `review_status = verified` and reviewed independent
affiliation. Albion's own society identifies its museum, street/mail addresses and local
governance; Jim Thorpe explicitly identifies family ownership, museum name and current
tours, corroborated by the matching IRS legal entity/address. These are factual source
decisions, **not independent human matching labels**.
[Albion operator](https://www.noblehistory.org/),
[Albion museum](https://www.noblehistory.org/old-jail/old-jail-museum-of-noble-county-historical-society.html),
[Jim Thorpe operator](https://theoldjailmuseum.com/),
[IRS Pennsylvania file](https://www.irs.gov/pub/irs-soi/eo_pa.csv).

St. Augustine receives the sourced `historic_tours_of_america` affiliation. The operator
lists Old Jail within its attraction portfolio. Nearby Oldest Store and St. Augustine
History Museum remain separate attractions; the generic operator/campus record requires
its own count review. This institution remains overall pending.
[Operator portfolio](https://www.historictours.com/st-augustine),
[museum site](https://www.staugustineoldjail.com/).

The twelve remaining Old Jail candidates therefore include **two verified independent**,
**one affiliated** and **nine affiliation-unknown** institutions; ten overall reviews
remain pending. Shared operation of differently named local facilities still needs a
consistent M4 treatment. It is not automatically independence. Barnesville's operator
distinguishes its jail museum from Graveyard Alley Archives; Sandersville's operator
distinguishes its jail, Brown House and Warthen site. Those separate sites were preserved.
[Barnesville](https://www.blchs.com/), [Sandersville](https://wacohistorical.org/genealogy/).

## Evidence and validation

The pinned Overture release was queried for **41 source records** to recover addresses,
websites, phones and provider provenance. The SQL, raw checksum and release remain in
`data/raw/MANIFEST.json`; the [context CSV](museum_old_jail_review_2026-09-15/overture_context.csv)
is tracked. Nineteen public source pages were cached. The Winchester city page was
readable in search results but direct retrieval returned 403; the Thompson Falls chamber
profile was readable through the web tool but direct caching returned 404. These limits
are retained in [cache status](museum_old_jail_review_2026-09-15/cache_status.csv).

R 4.4.2: **192 assertions and 23 integrity checks passed**. There were no test failures,
warnings or skips; existing Windows locale warnings occurred at startup. Fifteen targets
rebuilt and thirteen were skipped. Current review sheets have **449 institutions,
553 source rows and 147 nearby pairs**. The source-row increase reflects newly attached
supporting records, not additional counted institutions.

All **92 protected files** and **20 new acquisition/query hashes** match. Baseline
entities, the baseline multi-site queue, normalized source fields, unaffected records,
both human-label copies and prior packets are unchanged. Both Parquet exports match
their saved targets. Only `labelling_sheet` is outdated and was not rebuilt. The matching
threshold remains 0.85; original label scores remain 119 true merges, one false merge,
eight missed merges and 172 true separations.

`dn_assert_museum_publication_ready()` was explicitly run for `old jail museum` and
**correctly rejected** the remaining pending reviews/unknown affiliations. No headline
was published.

Reproduce archived counts and preservation checks without rebuilding:
`source("data/validation/museum_old_jail_review_2026-09-15/reproduce.R")`.

Next: review Union County Historical Society's 14 candidates and resolve the remaining
Old Jail ownership/name/record questions in the [queue](museum_old_jail_review_2026-09-15/follow_up.csv).
Bankhead and Lafayette Street remain unchanged unresolved cases from the
[address checkpoint](museum_address_review_2026-09-15.md). Staged publication coordinates
from that packet still await export integration and a fresh access check.
