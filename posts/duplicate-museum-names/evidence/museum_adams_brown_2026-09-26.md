# Adams and Brown County museum review — September 26, 2026

## Validated checkpoint

Selective museum exports and 322 test assertions pass, with 18 integrity checks and all 638 protected earlier evidence/label files unchanged. All 60,002 original source rows and the automatic baseline remain unchanged. Reviewed outputs contain **57,239 counted source rows, 52,526 counted institutions and 52,394 eligible institutions**. There are **179 identity rows in 69 cases, 65 complete factual reviews, 15 sourced not_museum decisions and 27 public-name overrides**. The 0.85 threshold and archived human labels are unchanged.

This batch adds 19 explicit identity members in six cases, eighteen factual decisions, nine preferred names and twelve complete factual reviews. Bare Adams County Historical Society falls from nine to two unresolved Washington institutions; bare Brown County Historical Society falls from nine to one unresolved Nebraska institution. These are identity, affiliation and public-name corrections, not inferred closures. Seven leading names still count nine each. **No national M1/M2 winner is certified.**

## Decisions and primary evidence

| Area | Supported change | Primary evidence |
|---|---|---|
| Adams PA | Beyond the Battle Museum reconciles four current/former/mailing records. Shriver House Museum remains a separate institution; both belong to Gettysburg History. Preserve 368 Springs as a former site. | [Operator history](https://gettysburghistory.org/about-us/), [research room](https://gettysburghistory.org/research/), [Shriver ownership history](https://www.shriverhouse.org/our-history/), [2018 giving book](https://www.adamscountycf.org/accf2/wp-content/uploads/2018/09/2018-Giving-Book.pdf) |
| Adams ID | Historic P&IN Depot and society PO Box 352 are one museum. The 2025 building transfer to the city explicitly preserves society oversight and museum/exhibit use. | [Operator identity](https://historicpindepot.com/about/), [ownership timeline](https://historicpindepot.com/about/timeline/) |
| Adams IN | Adams County Historical Museum at Dugan Mansion, 420 West Monroe, and society PO Box 262 are one institution. | [Operator history and board](https://www.adamscountymuseum.org/page2), [contact](https://www.adamscountymuseum.org/form-map) |
| Adams CO | Existing cluster retained; public name Adams County Museum. Local board and one museum complex support independence; funding does not imply chain ownership. | [Operator](https://www.adamscountymuseum.com/about-us), [buildings](https://www.adamscountymuseum.com/museum-buildings) |
| Adams NE | Society record is affirmatively an archive, publishing and research organization within Hastings Museum, so excluded as not_museum. Hastings Museum remains separate and counted. | [Purpose and board](https://www.adamshistory.org/index.php?Itemid=158&id=11&option=com_content&view=article), [archive location](https://www.adamshistory.org/index.php?Itemid=4&id=3&option=com_content&view=article) |
| Brown IN | Society, Pioneer Museum and mailing row reconcile to one integrated Brown County History Center and adjacent historic-building campus. No distant branch is inferred. | [Operator](https://www.browncountyhistorycenter.org/), [village](https://www.browncountyhistorycenter.org/pioneer-village.html), [destination agency](https://browncounty.com/do-list/pioneer-village/), [2025 newsletter](https://www.browncountyhistorycenter.org/uploads/7/3/3/0/7330483/2025_february.pdf) |
| Brown KS | Five explicit members resolve into three identities: downtown society museum and agriculture museum remain distinct, with common society affiliation; genealogical library is separately excluded as not_museum. Its aliases cannot leak into either museum. | [City museum descriptions](https://www.cityofhiawatha.org/residents/page/museums), [county directory](https://www.brcoks.org/1209/Brown-County-Genealogy), [genealogical library history](https://brcountyksgs.org/history-of-the-society) |
| Brown WI | Society, Hazelwood Museum and current Overture record become one Hazelwood Historic House Museum. Office is in the same building; historical connections to other museums do not establish current ownership. | [Operator history](https://browncohistoricalsoc.org/features/historic-hazelwood/), [contact](https://browncohistoricalsoc.org/contact/), [board](https://browncohistoricalsoc.org/about/board-staff/) |
| Brown SD | Society is affirmatively a support/publishing organization for Dacotah Prairie Museum and its foundation, so its separate record is excluded as not_museum. Museum records are unchanged. | [Society purpose](https://bchsofsd.com/about/) |

## Six unresolved records

These remain pending, with evidence and exact gaps in [follow_up.csv](museum_adams_brown_2026-09-26/follow_up.csv). They are unfinished factual work, not automatic exclusions or approvals:

- **Adams WA (two):** current PO Box 526 Lind and rotating meeting sites do not bridge the IMLS 974 East Weber Road, Ritzville address or establish the museum role of both source points. Keep separate; directory claims are insufficient.
- **Adams WI:** society explicitly operates multiple museums, so common-parent affiliation is sourced. The generic PO Box 264 IMLS row is not yet assigned to one site. Preserve uncertainty rather than creating or merging sites.
- **Brown NE:** Coleman House history and county plan establish relevant museum context but do not bridge the old North Ash/PO Box record or settle current campus scope and governance. Do not merge into Sellors Barton.
- **Brown IL:** destination agency supports the name Whistle Stop Depot Museum. Old rural-route identity, governance and access remain unresolved.
- **Brown OH:** chamber supports Brown County Historical Society Museum at 200 East Cherry Street. Old PO Box 283, current governance and jail/library scope still need corroboration. Unrelated Grant, Rankin and Parker museums remain separate.

## Reproduction, preservation and limits

[Counts](museum_adams_brown_2026-09-26/counts.csv), [integrity results](museum_adams_brown_2026-09-26/integrity_checks.csv), [audit](museum_adams_brown_2026-09-26/identity_audit_after.csv), [ranking](museum_adams_brown_2026-09-26/ranking_after.csv) and [dispositions](museum_adams_brown_2026-09-26/candidate_dispositions.csv) capture the checkpoint. `build_validate.log` records all 322 assertions and the failed remaining-leader publication gate. `apply.R` has already applied successfully; do not rerun its live mode or one-time snapshot.

The packet contains 18 starting candidates, 172 related source rows and 88 pinned Overture context rows. Of 47 public-source cache attempts, 44 succeeded and three returned HTTP 403. The Idaho and Kansas city pages were readable through web retrieval; the old Gettysburg giving-book address was available through a primary-source search-index excerpt. These differences are recorded rather than treating failed raw downloads as successful archives. Saved HTML excerpts support the Nebraska archive and South Dakota support-organization decisions.

No source coordinates were rewritten. A complete factual record is not a visitor-access or map-point certification. Public-page access wording must be rechecked before publication. The museum post and explorer still represent the preceding Depot/Wayne checkpoint; refresh them after the next research batch. Church independent labels and the blog destination remain external dependencies. Cloud spending remains **USD 0**.
