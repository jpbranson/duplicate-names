# African American Museum and Imagination Station source review — September 26, 2026

This packet reviews the 16 starting candidates in two eight-member L2 groups.
Supported corrections are applied and validated. Eight factual reviews remain
incomplete, and no national M1 or M2 winner is certified.

## Validated checkpoint

| Measure | Before | After |
|---|---:|---:|
| Original source rows | 60,002 | 60,002 |
| Counted source rows | 57,202 | 57,191 |
| Counted institutions | 52,493 | 52,480 |
| Eligible institutions | 52,361 | 52,348 |
| Guarded identity rows / cases | 243 / 98 | 258 / 106 |
| Complete factual reviews, including exclusions | 101 | 110 |
| `not_museum` decisions | 18 | 21 |
| Preferred public names | 55 | 57 |
| Isolated source conflicts | 19 | 23 |

The selected museum review, identity-audit and Parquet targets rebuilt successfully.
All 322 test assertions and 21 integrity checks passed. All 977 protected earlier
evidence and human-label files are unchanged. The automatic baseline, baseline
multisite queue, original source/normalized fields, source coordinates, 0.85
matching threshold and every earlier factual decision are preserved.

The batch adds 15 explicit identity rows in eight cases, 17 factual decisions and
two public-name overrides. Six museum reviews and three affirmative non-museum
exclusions are complete. These are factual source reviews, not independent
matching-accuracy labels.

## Effects on the selected names

| L2 name | Before, non-chain | After, non-chain | Remaining review |
|---|---:|---:|---|
| African American Museum | 8 | 3 | Bowling Green verified; Tacoma and Galveston pending |
| Imagination Station | 8 | 2 | Toledo and Lafayette verified |

St. Martinville's African American Museum is now reported with municipal
affiliations, while its institution/campus overlap remains pending. Carbondale
uses its fuller public name. Consolidated museums continue to count once under
their current canonical names. Bowling Green retains the operator's bare public
name; no locality suffix was invented to reduce a duplicate-name count.

The explicit recorded-status gate passes for the two remaining Imagination
Stations. That result does not certify visitor points/access, M2 scope-word
meaning or a national maximum. The next national leader still fails the gate.

## Decisions and evidence

- **Monroe, Louisiana:** Three clean records become one Northeast Louisiana
  Delta African American Heritage Museum. The operator's current address is
  1051 Chennault Park Drive; the former Plum Street museum moved to the new
  facility in August 2011, as described in a director/board interview and
  corroborated by historical and current address sources. A fourth row combines
  Monroe contact details with the Dallas museum domain and stays isolated.
  [Current visitor page](https://www.monroeblackheritagemuseum.org/visit),
  [operator/board interview](https://bayoulifemag.com/finishing-the-dream/).
- **Dallas:** The Fair Park point, exact-address Overture row and IMLS record
  describe one museum at 3536 Grand Avenue. Operator history establishes its
  independent nonprofit status and move to Fair Park. The IMLS ZIP anomaly is
  retained rather than used to invent another institution. A stale reopening
  header conflicts with a later dated exhibition page, so access needs a fresh
  check before publication. [History](https://aamdallas.org/history/),
  [2026 exhibition visit page](https://aamdallas.org/nelson-mandela-exhibition-plan-your-visit/).
- **Bowling Green:** The two old State Street records are retained as former
  sites of the current Chestnut Street institution. Its native operator site
  documents the independent nonprofit, board and 2014 lease. Three buildings
  are one museum property. Public name: African American Museum; tours by
  appointment. [Operator history](https://aambg.squarespace.com/about-us),
  [board and access](https://aambg.squarespace.com/board-of-directors).
- **Carbondale:** The operator identifies African American Museum of Southern
  Illinois, its founders, board/volunteers and continuous University Mall
  location. This supports the fuller public name and independent institution.
  A donor endowment does not imply community-foundation ownership.
  [Museum history](https://aamsi.org/about-us/),
  [fund administrator](https://www.sicf.org/ourfunds/aamsi/).
- **St. Martinville:** City hiring/pay records and current municipal museum
  services support affiliation with the city's museum operation. The generic
  Cultural Heritage Center houses two named museums; its 101 S New Market row
  and the African American Museum's 125 S New Market row remain separate and
  pending until the counting scope and visitor entrance are reconciled. The
  scanned budget has tourism totals, not museum-specific governance evidence.
  [2022 staffing minutes](https://stmartinville.gov/wp-content/uploads/2025/08/af6bd-8-01-22-minutes.pdf),
  [2024 staffing minutes](https://stmartinville.gov/wp-content/uploads/2025/08/fef6e-10-07-24-minutes.pdf),
  [city attractions](https://stmartinville.gov/attractions/).
- **Toledo and Lafayette:** COSI Toledo is a former name at the same Discovery
  Way site, now consolidated with Imagination Station. Lafayette's ASSET-operated
  science museum remains one institution at 600 N 4th Street. Both operators
  document their own governance and museum programs. Similar names, grants and
  individual board members' university employment do not establish a chain.
  [Toledo timeline](https://www.imaginationstationtoledo.org/about/timeline),
  [Lafayette history](https://www.imagination-station.org/mission-history).
- **Marshfield and Zeeland:** Operator descriptions affirmatively identify
  childcare facilities at the source addresses/phones. Both are excluded as
  `not_museum`, with original rows preserved.
  [Marshfield policies](https://imaginationstationmarshfield.com/wp-content/uploads/2023/08/ISM-Policies-2023-Aug-Update.pdf),
  [Zeeland operator](https://www.istation.org/).
- **Pensacola:** The former WSRE/PSC learning space at Wahoos Stadium had been
  gutted and connected to the visiting-team clubhouse by March 2025. This
  affirmative repurposing supports excluding the stale stadium-space record
  from the current museum count; it is not a blanket rule about closed museums.
  [College description](https://pensacolastate.smartcatalogiq.com/en/2016-2017/catalog/academic-and-student-services/wsre),
  [stadium operator's construction report](https://www.milb.com/news/blue-wahoos-stadium-improvements).
- **Missoula, Stratford and Woodstock:** Two rows use the Wilson, North
  Carolina museum website for unrelated Montana/Connecticut addresses; the
  Stratford IMLS row links to a web-design business. They receive separate
  uncounted source-conflict IDs, with no aliases transferred to accepted
  museums. Local roles and provider lineage remain unresolved.
  [Wilson operator](https://scienceandhistory.org/),
  [Stratford operator columns](https://highplainsobserverstratford.com/index198.htm),
  [archived website field](http://www.scribblesdesigns.net/index.html).

## Unfinished reviews and source limitations

The [eight-item human-review queue](museum_african_imagination_2026-09-26/human_review.csv)
gives exact missing evidence and next actions. Tacoma's present address/status
and Galveston's operator succession/access remain unresolved. Two St. Martinville
records have a campus-counting overlap. Four source conflicts need provider/local
identity evidence. No outreach is authorized or sent; no failed search, mailbox,
TLS failure or HTTP denial is treated as evidence of non-museum status.

There were 52 bounded public download attempts: 46 cached and six failures (two
HTTP 403 and four TLS checks). No TLS/security bypass was used. Bowling Green's
native Squarespace operator host was independently present in Overture context.
The legacy St. Martinville .org domain is now privately operated, so municipal
decisions use .gov sources. The WSRE annual-report URL returned HTML despite a
PDF filename; that mismatch is recorded and the bytes were not cited as a PDF.

The 36-page city budget is scanned. Physical PDF pages 1-3 and 9-13 were rendered
with Poppler and visually inspected; tourism totals do not identify museum
ownership. `fitz` and BeautifulSoup were unavailable: existing Poppler and the
standard-library HTML parser provided the necessary inspection without installs.
The first dry run rejected an HTTP-leading evidence field; the same evidence
list was reordered to begin with its real HTTPS source. Validation was not weakened.

## Artifacts, reproduction and next work

The packet contains the before snapshot metadata, 16 candidate dispositions,
840 related baseline rows, 438 Overture context rows, source acquisition status,
full factual notes, guarded proposed/applied inputs, source-level identity audit,
rankings, checks and follow-up queue. The before RDS is in ignored processed data;
tracked CSVs preserve the research context. The acquisition SQL/release and
download hashes are recorded in the raw manifest and packet snapshot.

Never rerun `prepare.R` or `apply.R --apply`: the one-time application marker is
`applied.json`. The read-only `build_validate.R --verify-only` checks the saved
checkpoint while it remains the live pipeline state. Later batches will correctly
make its fixed-count checks obsolete; use its dated outputs as historical evidence.

Continue Cass County Historical Society, Chester Historical Society and Crawford
County Historical Society (eight candidates each), then the other eight-member
leaders and earlier unresolved/M2 queues. Final maps/access and publication gates
remain open. Museum draft/explorer artifacts still reflect the preceding
Clinton/Madison/Monroe checkpoint; they will be refreshed after the next source
review stage. Church independent labels and the blog destination remain missing.
Cloud resource spending remains USD 0, strictly below USD 5.
