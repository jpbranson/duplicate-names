# Museum Depot and Wayne County checkpoint — September 26, 2026

**Headline review remains incomplete.** This pass examined the 20 provisional
Depot Museum and Wayne County Historical Society candidates, their related source
records, public names and operators. It applied supported corrections without
changing the automatic baseline or independent human labels.

## Validated results

| Measure | Before this pass | After this pass |
|---|---:|---:|
| Original source rows retained | 60,002 | 60,002 |
| Counted source rows in museum_records | 57,272 | 57,250 |
| Counted institutions | 52,557 | 52,539 |
| Eligible for name analysis | 52,425 | 52,407 |
| Explicit identity rows / cases | 125 / 51 | 160 / 63 |
| Complete factual reviews | 40 | 53 |
| Isolated source conflicts | 7 | 8 |
| Sourced not_museum decisions | 11 | 12 |
| Preferred public-name overrides | 2 | 18 |

The source-row count differs from the institution count: automatic clusters can
retain several counted source records, while analysis takes one canonical name
per institution. A sourced not_museum decision changes the analysis count, with
original source rows still preserved.

The ten bare Wayne County Historical Society candidates reduce to one unresolved
Tennessee record. The ten bare Depot Museum candidates now have more specific
operator or public-authority names. These are exact L2 group changes, not ten
museum closures and not proof that other similarly named museums are absent.
Franklin, Greene and Jackson county groups remain at six; Old Jail remains eight.
The new leading groups have nine provisional candidates and remain unreviewed.

## Corrections and evidence

- Four Corydon records now count once as Prairie Trails Museum. Piedmont, Lyons
  and Wayne also reconcile society/museum or mailing records. Current public names
  distinguish the museum from its operator's legal name.
- The Kentucky IMLS row with a Monticello address but Michael J Quill legal name
  and EIN is isolated. The IRS identifies that EIN in East Durham, New York. The
  accepted Kentucky institution does not inherit the contradictory row's aliases.
- Five Ironwood depot/society/building rows count once. Fort Payne, Enterprise,
  Two Harbors, Oroville and the 3M/Dwan building receive explicit membership
  corrections, retaining source coordinates and supporting rows.
- Stratford's museum and uncertain historical-society record are explicitly split.
  Different legal identities are not merged merely because a geocoder placed them
  together. The society's museum role remains pending.
- The current Enterprise operator identifies Pea River Museum and distinguishes
  its research library/shop. The latter is excluded as not_museum on affirmative
  operator evidence. The rendered source is documented in
  [the browser evidence note](museum_next_leaders_2026-09-26/enterprise_browser_evidence.md).
- Sourced common operators are recorded for Fairfield, Honesdale, Wakefield,
  Lake County Minnesota and Arkansas State Parks. Separate museums remain separate.
  The 3M museum's advertised 2026 repair closure is retained in its review note.

The packet includes 213 Overture context rows and 53 cached public sources. Four
cache failures remain explicit: both Ironwood operator domains, the Tennessee
museum URL and the Minnesota tourism page. The last was readable through web
research but returned HTTP 403 to the direct cache request. The Enterprise
JavaScript page required rendered browser inspection. Unrelated pharmacy links
in a Lake County detail-page template were ignored; identity was corroborated
against the state tourism source and recorded source addresses.

## Validation and remaining work

All **322 unit assertions** and **19 integrity checks** pass. The 60,002-row
automatic baseline, baseline multisite queue and 0.85 threshold are unchanged.
All **553 protected earlier evidence and label files** are byte-identical. Reviewed
Parquet and source-level identity audit were refreshed. The leading-name publication
gate fails as expected; the reviewed Pea River name passes the recorded-status gate.
A passing gate does not establish access, map accuracy, name-scope meaning or a
national maximum.

Eleven entries in this pass remain pending in
[follow_up.csv](museum_next_leaders_2026-09-26/follow_up.csv): affiliation or current
governance in Piedmont, Corydon, Ironwood, Oroville and Stratford; Kentucky visitor
address/point reconciliation; two generic Wakefield records; the uncertain
Stratford society role; Arcadia governance/access; and Tennessee society identity.
Operator/site failures are evidence-access blockers, not evidence of closure.
Other unresolved items remain research tasks, not completed reviews.

Next: review the newly exposed nine-member groups in
[ranking_after.csv](museum_next_leaders_2026-09-26/ranking_after.csv), then continue
the earlier county, Old Jail, Smithsonian and M2 queues. Museum headline
certification, independent church labels, church factual checks and deployment
remain unfinished. Both post bundles and the local explorer are draft artifacts.
Cloud resource spending remains **USD 0**, below the USD 5 ceiling.

Do not rerun prepare.R, apply_wayne.R or apply_depot.R. The selective rebuild and
checks are in build_validate.R. Preserve this packet before further decisions.
