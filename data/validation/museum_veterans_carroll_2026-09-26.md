# Veterans Memorial Museum and Carroll County review — September 26, 2026

## Validated checkpoint

Selective exports, **322 test assertions and 20 integrity checks pass**. All **754 protected earlier evidence and label files** are unchanged. The automatic baseline, all 60,002 original source rows and normalized fields, baseline multisite queue, source coordinates, prior factual decisions and 0.85 threshold are preserved.

The saved outputs contain **57,216 counted source rows, 52,506 counted institutions and 52,374 eligible institutions**. The live review has **220 identity members in 86 cases, 85 complete factual reviews, 16 not_museum decisions, 41 preferred names and eleven isolated source conflicts**. This batch adds 22 identity members in nine cases, nineteen factual decisions, eight names and nine complete reviews.

Bare Veterans Memorial Museum falls from nine to **three** non-chain candidates; Carroll County Historical Society falls from nine to **one**. Clinton, Madison and Monroe County Historical Society remain tied at nine. **No national M1/M2 winner is certified.** Ten new reviews remain pending.

## Supported changes

| Area | Result | Main evidence |
|---|---|---|
| Chehalis/Centralia WA | Three rows become one museum; preserve Centralia as a former site and the IMLS mailing record as supporting evidence. | [Operator](https://www.veteransmuseum.org/), [city relocation history](https://www.ci.chehalis.wa.us/community/page/attraction-spotlight-veterans-memorial-museum), [IRS Washington](https://www.irs.gov/pub/irs-soi/eo_wa.csv) |
| Laurel MS | Two Overture points and one IMLS row describe one museum at 920 Hillcrest. Its local board supports independent operation. | [Museum history](https://www.veterans-memorial-museum.org/about-us.html), [board](https://www.veterans-memorial-museum.org/about-the-board.html) |
| Branson MO | Current public name is Branson Veterans Memorial Museum; private local operation is supported. | [Operator](https://veteransmemorialbranson.com/), [founder and director](https://veteransmemorialbranson.com/about/) |
| Shenandoah IA / Hinton WV | Apply the supported fuller public names; leave governance/address gaps pending. | [Shenandoah operator](https://www.veteransmuseumswia.org/), [Hinton destination listing](https://visitwv.com/partners/veterans-memorial-museum-of-southern-wv-inc/), [participant history](https://www.jimleslie2020.com/about-1) |
| Berryville AR | Society and courthouse rows become one Carroll County Heritage Museum. Wider park/museum scope remains pending. | [Museum](https://ccheritagemuseum.com/), [city park relationship](https://berryvillear.gov/about-berryville/parks/pioneer-park/) |
| Carrollton MO | Exact EIN 436074684 at 510 N Mason resolves the IMLS street-number transposition. Society and museum count once. | [Operator](https://carrollton-mo-museum.com/), [state tourism](https://www.visitmo.com/things-to-do/carroll-county-historical-museum), [IRS Missouri](https://www.irs.gov/pub/irs-soi/eo_mo.csv) |
| Mount Carroll IL | Three accepted records count once as Miles Museum, affiliated with the society that also operates Oakville Settlement. Isolate the fourth, contradictory row. | [Illinois operator](https://www.historyincarrollcounty.org/about/), [Ohio operator-domain reference](https://www.ohiohistory.org/visit/browse-historical-sites/mccook-house/) |
| Delphi IN | Physical museum and PO277 legal record count once as Carroll County Historical Museum. Nearby canal and archive operators remain separate. | [Operator](https://www.carrollcountymuseum.org/), [board/history](https://www.carrollcountymuseum.org/about-us), [city museum description](https://cityofdelphi.org/community/explore/museums) |
| Carrollton OH | Reconcile the two McCook House rows; retain Algonquin Mill as a separate affiliated campus and leave generic parent PO174 pending. | [State McCook record](https://www.ohiohistory.org/visit/browse-historical-sites/mccook-house/), [local operator](https://sites.google.com/view/carrollcountyhistoricalsociety/), [mill complex](https://sites.google.com/view/carrollcountyhistoricalsociety/algonquin-mill-complex) |
| McKenzie TN | Isolate the society row carrying an animal-shelter URL. Preserve its clean IMLS parent and the separate clean Gordon Browning record while museum-unit scope is reviewed. | [Current society operator](https://www.gordonbrowningmuseumcarrollcountyhistoricalsociety.org/), [city](https://mckenzietn.org/residents/community-resources/tourism/), [different humane society](https://cchspet.org/) |
| Carrollton GA | Split historical and genealogical societies with different EINs. Exclude only the genealogy organization on affirmative research/library-role evidence; the historical museum remains pending. | [Genealogy organization](https://ccgsga.org/about/), [collections and separate historical-society link](https://ccgsga.org/resources/), [state directory](https://dlg.usg.edu/record/dlg_ggpd_y-ga-bs700-pa7-bs1-bd5-b1996) |

Source conflict handling is deliberately explicit. The Illinois row combines local museum contact data with the Ohio society domain. The Tennessee row combines museum contact data with the humane society domain. Each gets a separate uncounted ID and cannot contribute aliases to an accepted museum. Missouri's old URL is not used as an identity bridge: the exact legal EIN and IRS physical-address match resolve that case. All original source strings remain available.

The single chain field records McCook under Ohio History Connection. Evidence notes also preserve its local management by the same society as Algonquin Mill; this overlapping relationship must not be mistaken for two unrelated operators or fully represented network membership.

## Ten pending reviews

[follow_up.csv](museum_veterans_carroll_2026-09-26/follow_up.csv) retains exact IDs, status, sources and detailed gaps:

- Shenandoah: current governance and legal/operator scope.
- Hinton: 419 versus 423 Ballengee, current governance and visitor access.
- Johnstown: arena operator confirms a lobby military museum, but exact name, operational responsibility, counting scope and general access need verification. A field-trip program is not a closure or exclusion.
- Berryville: courthouse museum versus Pioneer Park satellite/branch scope.
- Illinois mixed source row: resolve contradictory state/operator context; remains isolated.
- Ohio generic society: assign or exclude the parent record only with affirmative institution-scope evidence.
- Tennessee generic society and Gordon Browning museum: determine whether the two named museum units are separately countable; no arbitrary parent merger.
- Tennessee mixed source row: resolve the museum/humane-society source conflict; remains isolated.
- Georgia historical society: verify present legal/address linkage, museum name, operation and access. Its old website contains unrelated spam; IRS absence is not evidence of closure.

These are unfinished factual reviews. Source-access failures are recorded separately; they have not been treated as evidence of closure, independence or absence of a museum. No independent matching labels were generated.

## Reproduction and evidence

The packet contains eighteen starting candidates, 261 related baseline rows, 115 pinned Overture context rows, selected IRS rows, guarded specifications and the source-level identity audit. Of **49 cache attempts, 45 succeeded**. Chehalis city and Berryville operator returned raw HTTP403; Delphi city and the ambiguous society domain failed certificate validation. Useful official web text/search results remained readable for the first three. Certificate checks were not disabled. The Ohio parent organization independently identifies the ambiguous domain.

[Counts](museum_veterans_carroll_2026-09-26/counts.csv), [checks](museum_veterans_carroll_2026-09-26/integrity_checks.csv), [ranking](museum_veterans_carroll_2026-09-26/ranking_after.csv), [candidate dispositions](museum_veterans_carroll_2026-09-26/candidate_dispositions.csv), [audit](museum_veterans_carroll_2026-09-26/identity_audit_after.csv), [specification](museum_veterans_carroll_2026-09-26/decisions_spec.json) and [cache outcomes](museum_veterans_carroll_2026-09-26/cache_status.csv) preserve the checkpoint. `build_validate.log` records the successful first validation pass. The one-time prepare and live apply scripts have already run; do not replay them.

The local museum draft and explorer have been refreshed and checked: see [artifact QA](museum_veterans_carroll_2026-09-26/artifact_QA.md). Isolated render, all serialized L2/L3 payload checks and nineteen JavaScript assertions pass. Browser verification shows the current Veterans group and its two verified/one pending records. Actual CSV filesystem saving remains unverified from the prior IAB limitations. Visitor map points and current access still need separate publication checks. Church independent labels and a real blog destination remain external dependencies. **Cloud resource spending: USD 0.**
