# Museum identity reconciliation — first pass

**Subsequent update:** the [focused follow-up](museum_focused_review_2026-09-15.md)
consolidates LeMoyne House, isolates two contradictory Pennsylvania source rows and
confirms Mandeville's operator map destination. Counts and the dated packet below
retain the first-pass checkpoint.

**2026-09-15.** Applied nine source-supported corrections: **25 source records,
previously assigned to 24 entities, now represent nine institutions** in the reviewed
layer. The automatic baseline is retained. This is a factual correction pass, not a
new evaluation of matching accuracy or a completed top-20 publication review.

## Effects on counts

| Measure | Before | After |
|---|---:|---:|
| Counted entities in museum working data | 52,636 | 52,621 |
| Eligible for provisional name analysis | 52,501 | 52,489 |
| Washington County Historical Society | 19 | 16 |
| National Electronics Museum | 4 | 1 |
| National Vietnam War Museum | 5 | 2 |
| Martin Museum of Art | 2 | 1 |
| Brown House Museum | 3 | 2 |
| Old Jail Museum | 15 | 15 |

The [count comparison](museum_identity_review_2026-09-15/count_effects.csv) and
[name comparison](museum_identity_review_2026-09-15/name_count_effects.csv) are generated
from the before/after analysis. The 15-entity reduction changes name-analysis eligibility
by 12 because three former gallery names were already held out. They now survive as
aliases of their current institutions. Five confirmed University Art Gallery candidates
remain eligible; NMSU is the remaining explicit historical-name holdout.

The leading name is still Washington County Historical Society, at **16 provisional
entities**. Neither that number nor the two remaining National Vietnam War Museum
candidates is certified as a count of independent current museums.
[Updated ranking](museum_identity_review_2026-09-15/ranking_after.csv).

## Corrections applied

| Case | Baseline entities → reviewed institutions | Evidence supporting the correction |
|---|---:|---|
| National Electronics Museum | 5 → 1 | Relocation history connects Linthicum, Hunt Valley and Middle River; the Historical Electronics name and PO box also belong to this institution. |
| Texas Vietnam museum | 3 → 1 | Two Overture records and IMLS share the official Mineral Wells Highway address; two coordinates are misplaced. |
| Florida Smedley museum | 2 → 1 | Full Overture name, IMLS legal name and both street addresses identify the Smedley museum. Its current full name leads. |
| Baylor galleries | 3 → 1 | Martin Museum records share its address and university website; the university documents consolidation with University Art Gallery. |
| Stony Brook gallery | 2 → 1 | Official history explicitly identifies University Art Gallery as the former name of Paul W. Zuccaire Gallery. |
| UCSD gallery | 2 → 1 | Official history connects University Art Gallery to Mandeville Art Gallery; both source addresses use the campus address. |
| Sandersville Old Jail | 2 → 1 | The museum and society records give 129 Jones Street; the operator identifies the physical venue as Old Jail. |
| Sandersville Brown House | 3 → 1 | Museum and society records give 268 North Harris Street. The IMLS point and its Molly Brown website are erroneous; local name/address and operator evidence support this case. |
| Fayetteville Headquarters House | 2 → 1 | Three source rows share 118 East Dickson Street; the operator describes Headquarters House as its headquarters and period museum. |

The **Brown House and Old Jail remain distinct museums**. Shared society ownership
does not merge them. Their corresponding society names survive as aliases.
[Operator's two-site contact page](https://wacohistorical.org/contact/),
[Brown House](https://wacohistorical.org/the-brown-house-museum/),
[Old Jail](https://wacohistorical.org/genealogy/).

Other primary evidence: [Texas address and map](https://www.nationalvnwarmuseum.org/contact-map-1),
[Smedley museum](https://www.smedleymuseum.com/),
[Florida address](https://theoriginalbunker.wixsite.com/orlando/contact),
[Baylor history](https://magazine.web.baylor.edu/news/story/2006/art-angels),
[Martin Museum](https://martinmuseum.artsandsciences.baylor.edu/),
[Zuccaire history](https://zuccairegallery.stonybrook.edu/about/),
[Mandeville history](https://mandevilleartgallery.ucsd.edu/about/history.html),
[Headquarters House](https://washcohistoricalsociety.org/Properties).

### Electronics relocation clarified

The first source pass found conflicting location signals. The museum's home page now
provides the missing connection: Hunt Valley tours ended **January 30, 2026**, and the
museum is relocating to the Maryland Aerospace Heritage Center in Middle River. Its
directions page names **2323 Eastern Boulevard**, matching the third Overture record.
This establishes institutional continuity, not public reopening.
[Museum announcement](https://www.nationalelectronicsmuseum.org/),
[destination](https://www.nationalelectronicsmuseum.org/visitor-info/get-directions/to-nem/).

The history page connects the former Historical Electronics name and Linthicum venue;
the museum's rental form documents PO Box 1693. Both physical former sites remain in
the reviewed data; the mailbox is not counted as another site. The older hours page
still lists Hunt Valley, so its address should not override the relocation announcement.
[History](https://www.nationalelectronicsmuseum.org/about-us/history-mission/),
[mailing-address evidence](https://www.nationalelectronicsmuseum.org/wp-content/uploads/NEM-PH-Rental-Agreement-2022.pdf),
[older visitor page](https://www.nationalelectronicsmuseum.org/visitor-info/hours-admission/).

## Implementation and provenance

`entities` remains the automatic baseline. New target `museum_records` applies
[museum_identity_decisions.csv](museum_identity_decisions.csv) through
`R/museum_identity.R`, and supplies the museum metrics and review exports.
`data/processed/entities.parquet` remains the baseline export;
`data/processed/museum_records.parquet` is the reviewed export.

Each correction lists every source member of its affected baseline entities, an
explicit canonical record, physical-site groups, evidence and reviewer/date. Name,
entity and coordinate guards reject stale inputs. Missing cluster members, duplicate
source keys and contradictory site roles fail before producing output. No name pattern,
shared operator or proximity search expands a correction automatically.

Only the selected representative counts within each reviewed institution. Other rows
remain with reasons distinguishing duplicate, former-site, mailbox and misplaced-point
records. Raw names, coordinates and other normalized source fields are unchanged.
The [audit](museum_identity_review_2026-09-15/identity_audit.csv) includes original and
corrected IDs, display names, aliases, site counts and counting flags.

The additional [Overture context](museum_identity_review_2026-09-15/overture_context.csv)
contains addresses, websites and provider provenance for 38 records from the same
**2026-08-19.0** release. The query, selected IDs, retrieval time and checksum are in
`data/raw/MANIFEST.json`; a tracked copy preserves this small research input. The
[before records](museum_identity_review_2026-09-15/records_before.csv) also retain original
IMLS legal names, campus parents and addresses. Earlier dated packets are unchanged.

## Remaining cases and validation

The [focused follow-up list](museum_identity_review_2026-09-15/unresolved_cases.csv)
separates six remaining research tasks. The Texas Bankhead Drive record has a different
address and no website; it remains unmerged. Fayetteville's Lafayette Street and
Chipley's older preservation-society records also remain unresolved.

Pennsylvania needs a split/correction investigation: one already-clustered IMLS row
claims Washington County Historical Society at 49 East Maiden Street, but its legal
name and website identify the John D. Barrow gallery. That gallery's own report places
it in Skaneateles, New York. The conflicting row is preserved; no merger with LeMoyne
House or the society's PO box was applied.
[Barrow gallery report](https://www.barrowgallery.org/uploads/b/c7c5fe60-a0af-11ec-b22b-9f956a0d0501/Barrow_AnnualReport_2023_NjEzMz.pdf),
[LeMoyne House](https://wchspa.org/lemoyne-houses/).

Smedley and Mandeville identity is supported, but their selected source coordinates
still require map verification. Mandeville's visit page also reports a closure with an
unspecified end date. These identity decisions do not certify either a precise visitor
point or current operating hours. [Mandeville visitor information](https://mandevilleartgallery.ucsd.edu/visit/index.html).

**139 assertions passed** under R 4.4.2, with no test failures, warnings or skips.
The selective rebuild completed 15 targets. Integration checks verified that the
baseline, all normalized source fields, every unreviewed record, and both human-label
files are unchanged. The 300-label result stays at 119 true merges, one false merge,
eight missed merges and 172 true separations at **0.85**. That score evaluates the
original matching sample, not these curated decisions. Generated diagnostic labels
remain blank. `labelling_sheet` is the only outdated target and was deliberately skipped.
R emitted its existing Windows locale warnings during startup.

Next: finish the remaining top-20 source checks and focused cases, then certify the
specific headline counts before figures and the standalone post. This step does not
require the user to approve routine source research or supply labels for the whole packet.
