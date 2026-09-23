# Provisional leaders — Museum of Illusions and Washington County Historical Society

**2026-09-23.** Reviewed all **26 starting candidates** of the two co-leading L2 names
(13 each). Eight identity cases cover 19 source rows. Washington County Historical
Society falls from **13 to 7** institutions and Museum of Illusions from **13 to 12**.
Thirteen institutions gain complete factual reviews. Both names still fail the
publication gate, and neither is a certified headline.

The [candidate dispositions](museum_leaders_review_2026-09-23/candidate_review.csv)
account for every starting candidate; count distinct resulting IDs, not ledger rows.

## Count effects

| Measure | Before | After |
|---|---:|---:|
| Source rows retained | 60,002 | 60,002 |
| Counted source rows | 57,305 | 57,293 |
| Counted institutions | 52,597 | 52,588 |
| Eligible for L2 name analysis | 52,465 | 52,456 |
| Museum of Illusions | 13 | 12 |
| Washington County Historical Society | 13 | 7 |
| Old Jail Museum | 12 | 12 |
| Institutions with complete factual review | 3 | 16 |

The live identity input now contains **90 rows in 36 cases**, including five isolated
source conflicts. Four names now tie at **12**: Museum of Illusions, Old Jail Museum,
Play Street Museum and Ripley's Believe It or Not. Three of those are single-brand
chains. [Count effects](museum_leaders_review_2026-09-23/count_effects.csv),
[ranking](museum_leaders_review_2026-09-23/ranking_after.csv),
[source audit](museum_leaders_review_2026-09-23/identity_audit.csv).

## Methodology question raised by this batch

The official [Museum of Illusions directory](https://www.museumofillusions.com/our-locations/)
lists **25 open US locations**. Eleven appear under the bare name in Overture. The other
fourteen are all present, but carry city suffixes ("Museum of Illusions - Atlanta",
"Museum of Illusions Chicago"). L2 therefore places them in fourteen separate name groups.
The exact-name count of 12 undercounts the brand. It also measures how one chain labels
its listings, not independent naming. Play Street Museum and Ripley's are likewise
entirely chain-affiliated. Whether the M1 headline should exclude verified chains, or
normalize brand-plus-city names, is a methodology decision. This batch leaves the
normalizer and ranking rules unchanged.

## Supported identity corrections

| Place | Decision and evidence | Remaining limit |
|---|---|---|
| Salem, IN | Count **Stevens Memorial Museum** once; both society rows are same-site support. The operator calls it "the centerpiece of the John Hay Center, founded by the Washington County Historical Society" at 307 E. Market Street. Overture rows share street, website and phone; IMLS shares street and website. [Museum](https://www.johnhaycenter.org/index.php/attractions/stevens-memorial-museum), [contact](https://www.johnhaycenter.org/index.php/contact-john-hay-center). | **Verified independent:** own elected board, no parent operator, 2026 hours. Depot Railroad Museum is a separately named site and is not merged. |
| Hagerstown, MD | Count **Miller House Museum** once with three supporting rows. The Maryland Manual lists "Miller House Museum Washington County Historical Society, 135 West Washington St." Both IMLS rows carry the society's legal name, EIN 526047982 and street. [Maryland Manual](https://msa.maryland.gov/msa/mdmanual/01glance/museums/wa/html/wa.html). | IMLS's hswcv.org belongs to the Virginia society; the EIN, name and address are Maryland, so the row is not isolated. Beaver Creek School closed in 2016. The operator site was in maintenance; governance and hours pending. |
| Plymouth, NC | Count **Port o' Plymouth Museum** once. The operator states it "is owned and operated by the Washington County Historical Society" at 302 E. Water St., IMLS's physical address. The IMLS point is 2.3 km away and is treated as mislocated. [Operator](https://portoplymouthmuseum.org/about-port-o-plymouth-museum/). | The Roanoke River Lighthouse and Maritime Museum is separate. Governance pending. |
| Dewey, OK | Count **Dewey Hotel Museum** once. The hotel was "Donated to the Washington County Historical Society in 1967"; IMLS's society row gives 801 N Delaware and wchs-ok.org; the Overture museum phone is the society's. [Oklahoma Historical Society](https://www.okhistory.org/publications/enc/entry?entry=DE017). | Tom Mix Museum, an OHS affiliate managed by its own nonprofit, is separate. Governance pending. |
| Stillwater, MN | Count **Washington County Heritage Center** once; IMLS society is its PO Box 167 mailing record. The operator is "a private, non-profit educational institution" that "operates three museum sites"; the Heritage Center is its mailing address. [About](https://www.wchsmn.org/about-us/). | **Verified independent.** Warden's House Museum and Hay Lake School are separate named sites. |
| Marietta, OH | Combine the Overture society with IMLS "Washington County Historical Society of Ohio" (EIN 316039450). The operator's page names "The Archives of the Washington County Historical Society of Ohio" at the Overture address. [Archives](https://www.wchshistory.org/visit-the-archives). | 346 Muskingum Drive is an archives room, not a museum; Fearing House and Anchorage are separate named sites. The counted record stays pending. |
| Fayetteville, AR | **Isolate** IMLS 8400500101 as a source conflict. Its displayed name is the Historical Society, but its legal name and EIN 300212518 identify the separate Washington County Historic Preservation Association, with a care-of address at a private house. [IRS/ProPublica](https://projects.propublica.org/nonprofits/api/v2/organizations/300212518.json). | The Historical Society already counts once as Headquarters House. |
| Hollywood, CA | Count the venue once as **World of Illusions Los Angeles**, with Museum of Illusions as a same-site alias. The operator: "WonderWalk is the new name of World of Illusions at 6751 Hollywood Blvd - same place, same three attractions, same entrance", one of which is the Museum of Illusions. Both records share address, website and phone. [Operator](https://illusions-la.com/). | Not in the global network; the operator calls Santa Monica "a separate business". Venue affiliation pending. |

## Museum of Illusions network locations

All 11 affiliated locations are now **verified chain members**. Each official location site
lists the source address and states "This museum is part of the global Museum of
Illusions group". Nine post current hours and ticketing. Charlotte and Denver are
temporarily closed for new exhibits, with reopening announced for late October and
November 2026; recheck access before any map is published. The sites do not state
franchise versus company ownership, so this is brand affiliation, not common ownership.
Kansas City's source domain redirects to its official site.

Miami Beach remains **pending**. It is absent from the global directory; its operator
domain no longer resolves, and the last indexed page read "Closed in Miami Beach". That
page referred visitors to the Los Angeles and San Francisco illusions venues. No direct
operator page or dated closure was retrieved, so no closure or ownership is asserted.

## Washington County candidates retained

- **Washington, KS:** the society owns the Washington County Museum; the operator and IRS
  give 216 Ballard Street, while IMLS has only a PO box. [Operator](https://sites.google.com/view/wchistorical/home).
- **Washington, IA:** a county genealogy page describes the Conger House Museum; the
  IMLS website is dead and no operator source was found. [Page](https://iagenweb.org/washington/wchs.htm).
- **Fort Edward, NY:** 167 Broadway is the Wing-Northup House, the society's headquarters
  and research library, not presented as a museum. Old Fort House belongs to a separate
  association. [Operator](https://wchs-ny.org/the-wing-northup-house/).
- **St. George, UT:** an umbrella society that helps city societies organize and co-manages
  the Pioneer Courthouse; it operates no museum. [Operator](https://wchsutah.org/wchs/about-wchs.php).
- **Greenville, MS:** no museum found. IRS revoked EIN 640594458 on 2013-05-15; the nearby
  Greenville History Museum is a separate nonprofit. Revocation does not prove dissolution.
- **Marietta, OH:** retained as noted above.
- **Chipley, FL:** Sunbiz lists an active nonprofit with its own directors, but the operator
  site returns 404 and current hours are unconfirmed.

Four of these (New York, Utah, Ohio and Mississippi) appear not to describe a museum
visitor site. The decision schema has no sourced non-museum exclusion, so they remain
counted and pending. Adding one would change methodology and needs tests; it is the
first schema item in the [follow-up queue](museum_leaders_review_2026-09-23/follow_up.csv).

## Evidence and reproducibility

Two queries of the pinned Overture release recovered context for 22 candidate and
closely related records, then 18 nearby named museums. Their SQL, checksums and retrieval times are in
`data/raw/MANIFEST.json`, with tracked copies ([candidates](museum_leaders_review_2026-09-23/overture_context.csv),
[nearby](museum_leaders_review_2026-09-23/overture_nearby_context.csv)). The
[IMLS dossier](museum_leaders_review_2026-09-23/imls_context.csv) retains separate
addresses and EINs. IMLS is a 2018 source, not evidence of present operation.

Forty-six public documents were cached, including IRS Kansas and Mississippi extracts
and the IRS revocation list; two attempts failed and are recorded in
[cache status](museum_leaders_review_2026-09-23/cache_status.csv). Some cached operator
pages render with JavaScript, so their files may hold less text than was read at review
time. Selected IRS rows are in [irs_selected.csv](museum_leaders_review_2026-09-23/irs_selected.csv),
[irs_revocation_selected.txt](museum_leaders_review_2026-09-23/irs_revocation_selected.txt)
and [irs_ein_lookup.csv](museum_leaders_review_2026-09-23/irs_ein_lookup.csv). Research
agents gathered the leads; the key operator statements for each merge and each
independent verification were rechecked directly before applying decisions.

The automatic resolver, 0.85 threshold, source names and coordinates, human labels and
earlier packets are unchanged. No new matching-accuracy claim is made. The manifest
update re-ran upstream targets; the rebuilt baseline and multisite queue are identical
to the saved pre-review state.

R 4.4.2: **195 assertions passed**, with no failures, warnings or skips. **25 integrity
checks passed**, including 168 protected files, both Parquet exports and the unchanged
automatic baseline. All **48 acquisition hashes** match. The generated review now holds
493 institutions, 598 source rows and 154 nearby pairs, because the lower top-20 cutoff
(8) admits more names. [Log](museum_leaders_review_2026-09-23/validation.log),
[checks](museum_leaders_review_2026-09-23/integrity_checks.csv).

```r
source("data/validation/museum_leaders_review_2026-09-23/validate.R")
```

The explicit publication gate rejects both names: Museum of Illusions because Miami is
pending, and Washington County Historical Society because all seven remaining
institutions are pending. No headline was published.
