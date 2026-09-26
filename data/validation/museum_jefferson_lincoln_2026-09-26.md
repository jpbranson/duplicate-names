# Jefferson and Lincoln County review - September 26, 2026

This is a factual source/identity checkpoint, not an independent matching evaluation
or a certified national headline. All 16 starting candidates have saved dispositions.
Nine additional institutions have complete factual reviews; eight reviewed outcomes
remain pending, including the isolated Iowa record. Seventeen outcomes are reviewed
because Newport has two distinct museums, both of which have complete factual reviews.

## Validated outputs

| Measure | Count |
|---|---:|
| Original source rows retained | 60,002 |
| Counted source rows | 57,156 |
| Counted museum institutions | 52,455 |
| Eligible for L2 analysis | 52,323 |
| Explicit identity rows / cases | 319 / 134 |
| Complete factual reviews, including exclusions | 132 |
| Sourced not-museum decisions | 22 |
| Preferred public names | 80 |
| Isolated source-conflict rows | 29 |

This batch adds 27 identity rows in 13 cases, 17 factual decisions and 11 preferred
names. It adds no not-museum exclusion. Jefferson County Historical Society's bare-name
non-chain group falls from eight to two; Lincoln County Historical Society falls from
eight to three. Current counts remain provisional.

The selective target/export build and **340 test assertions** pass. All **25 integrity
checks** pass, including hashes for **1,235 prior evidence/label files**, unchanged
automatic baseline and baseline multisite queue, unchanged source names/coordinates,
reviewed Parquet equality, full guarded replay and the 0.85 threshold. No algorithm or
schema changed in this batch. The first dry run rejected a former site sharing its
canonical site group; the draft was corrected before the successful one-time apply.

The explicit publication gate still rejects the leading group. Complete factual
reviews do not certify visitor access, map points, M2 semantics or independent
matching accuracy. Prior pending queues remain active. Post/explorer payloads still
reflect the older Clinton/Madison/Monroe checkpoint and have not been refreshed here.

## Decisions and evidence

### JEFF_NE - verified; affiliation chain

The society advertisement on PDF page 18 identifies its Rock Island Depot Railroad Museum, District 10 school museum and Steele City activities with 910 Bacon Road and telephone 402-729-5131. Current Jefferson County Visitors Committee listings corroborate the depot and separate school/Steele City locations. IRS EIN 476045558 retains 910 Bacon Road. Consolidate the society mailing record with the named depot at that address, not the separate Fairbury City Museum at 1128 Elm. The operator has multiple museum sites; record its shared affiliation. The old jeffersoncountyhistory.com page is an archive with unrelated spam, and historicjeffersoncounty.org now belongs to Madison, Indiana; neither redirect establishes an institutional relationship. The advertised jeffersoncohistory.org hostname failed DNS. Recheck dated visitor hours and map pin before export. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://fairbury.com/wp-content/uploads/2022/04/2022-Jefferson-County-Guide.pdf).

### JEFF_IN - verified; affiliation independent

Current operator identifies Jefferson County History & Art Center at 615 West First Street, Madison, phone 812-265-2335, matching both source rows and IRS EIN 237422529. It describes one campus containing local history/art and railroad passenger station exhibits, the Jefferson Room and archives; consolidate two source descriptions of that campus, not the separate Historic Madison or state museums nearby. Local society membership and IRS standalone organization support independent affiliation. Use the current full center name. Public hours are seasonal, with January/February closure; the page simultaneously advertises free admission and a price, so recheck access wording before publication. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://jchshc.org/).

### JEFF_CO - pending; affiliation unknown

County operator identifies Hiwan Museum at 28473 Meadow Drive and its partnership with Evergreen Mountain Area Historical Society. The society newsletter (Fall/Winter 2018, PDF page 2) explicitly connects its former Jefferson County Historical Society name to EMAHS. IMLS society and museum rows both list 4208 Timbervale at the same campus; society EIN 237355962 and PO Box 703 persist in IRS. Overture identifies Hiwan at the current county address. Consolidate all three campus records and use Hiwan Museum, preserving the old society name as source evidence. EMAHS also runs Medlen School programming; the county/society relationship is established, but museum network scope is not fully resolved. Affiliation and overall review stay pending. The society page transposes 28473 to 28743 and gives conflicting hours; prefer county contact for a future publication check. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://www.jeffco.us/1251/Hiwan-Heritage-Park).

### JEFF_KS - pending; affiliation unknown

Current society operator presents Old Jefferson Town museum, grounds and research library at 703 Walnut Street, Oskaloosa, PO Box 146, with its own 2026 executive board. IMLS EIN 237004883 instead lists 16786 126th Street, Winchester; current IRS repeats that address care of Mary Janith Luse. The operator identity is a strong lead, but the old contact-to-public-museum link has not been independently established from a specific primary record. Preserve this source separately from the Old Jefferson Town Overture row; do not assume the Winchester record is a second museum or exclude it from failed searches. Overall and affiliation reviews remain pending. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://www.jchsks.com/).

### JEFF_NY - verified; affiliation independent

Current operator explicitly calls its public institution Jefferson County Historical Society Museum in the Paddock Mansion, 228 Washington Street, Watertown. Both source records, phone 315-782-3491 and IRS EIN 150564076 agree. Its own board of trustees and local society ownership support independent governance. Consolidate the two descriptions and use the complete museum name, retaining Paddock Mansion as location context. Fall hours are Friday through Monday 10-4; reconfirm before visitor publication. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://www.jeffersoncountyhistoricalsociety.com/about).

### JEFF_IA - pending; affiliation unknown

IMLS 8401900383 combines Iowa EIN 421154792 and 105 W Adams, Fairfield, with jchs.mvn.net, the website field also attached to the Illinois society record EIN 371041417 at 1411 N 27th, Mount Vernon. Current Illinois operator and IRS substantiate that separate Historical Village. Iowa municipal Carnegie Museum minutes and the separately incorporated Carnegie Museum Foundation do not establish identity with this mixed row. Isolate it as source_conflict, with no accepted aliases and no merger into either institution. This is not a not_museum finding; the Iowa society role, address and domain error require resolution. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://jchshistoricalvillage.org/).

### JEFF_GA - pending; affiliation unknown

Current city page describes the volunteer society and genealogy files in the Knights of Pythias building on East Broad Street. An older regional comprehensive plan (PDF page 106) describes public exhibits and archives in its owned Quincy Building; IRS EIN 582187800 now lists 112 W Broad Street, consistent with the archival directory, while IMLS has PO Box 491. These sources establish the society but leave current museum display scope and East/West/building identity unresolved. Preserve the counted source pending review, without a not_museum inference from archive wording or a failed obsolete city domain. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://www.cityoflouisvillegeorgia.com/jefferson-county-historical-society/).

### JEFF_IL - verified; affiliation independent

Current society operator and city welcome guide identify Jefferson County Historical Village at 1411 N 27th Street, Mount Vernon, telephone 618-246-0033. IRS EIN 371041417 repeats the address; Overture has the named village and the IMLS record has the society at the same address with a displaced coordinate. Consolidate as one village campus, using the Overture representative and full public name. The volunteer society operates the campus and offers local membership/donations, consistent with the standalone IRS organization. Do not treat individual display buildings as separate institutions. Current schedule is weekends May through October; retain IMLS source coordinates in the audit. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://jchshistoricalvillage.org/).

### LINCOLN_KY - pending; affiliation unknown

The society describes the Old Presbyterian Meeting House at 315 W Main as a county-owned museum and organizes events at several historic sites. Its contact page describes an all-volunteer organization; the city also associates society offices with the courthouse. IMLS gives 222 Whitley Avenue, EIN 611352323; current IRS instead gives PO Box 570 care of Jane Vanhook. No primary record yet establishes which museum, if any, the 222 Whitley record denotes or whether the society only supports separately operated sites. Preserve it separately, with no ownership inference from promotional links and no not_museum decision. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://lincolncountykyhistory.org/second-saturday-250/presbyterian-meeting-house-activity/).

### LINCOLN_WA - pending; affiliation unknown

The museum operator legacy site gives 600 7th Street, Davenport, and describes its Lincoln County Historical Society collections. IMLS Park and 7th / PO Box 585 and EIN 910839913 align with current IRS, while Overture has the same named museum at 600 7th and phone 509-725-6711. Consolidate these records and use the public museum name. The IMLS source point is displaced north of town. The lincolncountymuseums.org pages appear in search cache with a Visitor Center name, but the actual fetched bytes are a parked-page redirect script; retain them as failed substantive evidence, do not follow advertising redirects. Current operator governance and visitor status need confirmation, so affiliation and overall review stay pending. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://lincolncountymuseum.weebly.com/contact-us.html).

### LINCOLN_CO - verified; affiliation independent

Town of Hugo identifies the Hedlund House Museum, town ownership and maintenance with volunteer staffing. The society fundraising notice in The Leader of April 24, 2025 (PDF page 12) explicitly links the museum at 617 3rd Avenue and society PO Box 124; IRS EIN 237219469 retains that mailbox. The extra pinned Overture query confirms Hedlund House at 617 3rd Avenue. Consolidate the society mailing record with the museum; local town/society operation is independent of other county museums such as Limon. Tours require appointments. The dated notice reports floor damage and repairs; recheck access and the town corner description before a visitor export. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://townhugo.com/museum/).

### LINCOLN_TN - pending; affiliation unknown

The chamber 2019 directory search extract lists separate Historical Society meetings and Lincoln County Museum Association contacts; its native PDF fetch returned 404, so it is a research lead only. IMLS society EIN 581416255 at 65 West Point / PO Box 435 differs from museum association EIN 621243037, 521 S Main / PO Box 54, which remains in IRS. This supports keeping the records separate pending a direct society role source; IRS absence is not evidence of closure or non-museum scope. No merge, exclusion or complete review. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://939c9b01811224bb3dcf-d6f090436a6f3838a347f2f22505b78d.ssl.cf5.rackcdn.com/uploads/editions/12473/original_bb5db226ac43e74fdd5534214763cfc7ec7b9112.pdf).

### LINCOLN_NM - pending; affiliation independent

Current society operator gives 406 Central Avenue, PO Box 555, Carrizozo, visits by appointment, holdings and an elected board. IRS EIN 850370409 connects the IMLS society formerly listed at 711 Calle La Placita / PO Box 91, Lincoln, to current PO Box 555. Overture matches the current operator, address and website. Consolidate the older listed location with the current society, retaining its historical contact context; the old county-domain listing alone does not identify a different institution. Society governance is independent, but whether the current holdings are curated museum displays or primarily archival resources remains unverified; overall review remains pending. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://www.nmlincolncountyhistoricalsociety.com/).

### LINCOLN_NE - verified; affiliation independent

Current operator identifies Lincoln County Historical Museum as the society-built museum opened in 1976, with main exhibits and an eight-acre historic village. Both source records and IRS EIN 237147860 give 2403 N Buffalo Bill Avenue, North Platte; Overture matches its phone and website. Consolidate one museum campus and use the public museum name. Local society ownership/membership and standalone IRS organization support independent affiliation. Historic village structures are parts of the campus. Seasonal hours end September 30, with winter appointments; recheck access before publication. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://lincolncountymuseum.org/about-our-museum/).

### LINCOLN_GA - verified; affiliation independent

Current operator explicitly identifies its Lincoln County Historical Park, created and operated by the local nonprofit society, with relocated historic buildings and displays. Its home page gives 147 Lumber Street, Lincolnton and the 2026 Pioneer Day event. IRS EIN 581798955, IMLS and both Overture names agree with that address. Consolidate three source rows as one park campus, not separate institutions for each house or display. Record independent local-society affiliation and the park public name. Sponsorship by county government and churches does not establish common museum ownership. The state tourism page was readable in web search but native fetch was 403; use the cached operator evidence. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://www.lincolncountyhistoricalsocietyga.com/about).

### LINCOLN_OR_BURROWS - verified; affiliation chain

The society explicitly identifies Burrows House Museum at 545 SW 9th Street, Newport, with current exhibits and weekend hours. IMLS society EIN 930545940 and IRS use that same address; Overture has Burrows House there. Consolidate these two descriptions at this museum. The same operator separately maintains Pacific Maritime Heritage Center at 333 SE Bay Boulevard; retain it as a distinct museum with shared society affiliation. The adjacent Log Cabin is now a research library, not a third museum inferred from its historical name. North Lincoln County Historical Museum in Lincoln City has a different EIN and operator and remains separate. Current visitor hours require publication recheck. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://oregoncoasthistory.org/museums-exhibits/burrows-house/).

### LINCOLN_OR_MARITIME - verified; affiliation chain

Society operator and city museum directory identify Pacific Maritime Heritage Center at 333 SE Bay Boulevard, Newport. Both Overture records at that address use the operator website and phone 541-265-7509: one is the named museum and one the society listing. Consolidate those two, retaining this museum separately from Burrows House at 545 SW 9th. The society board and explicit two-location description establish shared operation; apply the same affiliation to both museums. No change to North Lincoln County Historical Museum in Lincoln City or automatic source coordinates. Evidence packet: data/validation/museum_jefferson_lincoln_2026-09-26; original source fields and coordinates retained.

[Primary source or recorded research lead](https://oregoncoasthistory.org/about-us/).

## Pending human actions

See [human_review.csv](museum_jefferson_lincoln_2026-09-26/human_review.csv) for stable
source/entity keys, evidence and precise actions. No outreach has been sent.

- **JEFF_CO:** Confirm whether Hiwan and Medlen School are separate museums under a common operator; document museum affiliation scope and current county visitor entrance/hours.
- **JEFF_KS:** Obtain a society filing or historical newsletter explicitly linking EIN 237004883 / Mary Janith Luse at 16786 126th Street to Old Jefferson Town, and establish whether the Winchester address ever represented a separate museum.
- **JEFF_IA:** Resolve the Iowa society EIN 421154792 and 105 W Adams listing from original filings or society records, then determine museum identity without importing the Illinois domain or conflating the Carnegie Museum Foundation.
- **JEFF_GA:** Confirm current public exhibits, correct East/West Broad entrance and building identity, and document current society governance before certifying museum scope.
- **LINCOLN_KY:** Link the 222 Whitley Avenue record to a documented museum or administrative role, distinguishing society programming from county ownership of the Meeting House and other attractions.
- **LINCOLN_WA:** Verify the current Davenport museum operator, public name, governance and access using a current government/library or operator record; the former museum domain is parked and the legacy website is undated.
- **LINCOLN_TN:** Obtain a current society statement or filing for EIN 581416255 / PO Box 435 to establish museum versus historical-program role; keep the separately incorporated Museum Association distinct.
- **LINCOLN_NM:** Confirm public museum display scope at 406 Central Avenue and document the former 711 Calle La Placita location as museum versus contact/office, with current appointment access.

## Acquisition and preservation

The packet contains 175 initially related baseline records plus Hedlund House, which
lies outside the old society mailbox's spatial neighborhood. Separate pinned Overture
queries preserve the institution address context, and IMLS physical/mailing fields
remain distinct. The extra Hedlund query is recorded in the raw manifest.

Fifty-one of 55 public downloads succeeded; four failures remain recorded (two DNS,
one HTTP 404 and one HTTP 403). Two successful Davenport HTML downloads contain only
parked-page redirect scripts and are expressly **not substantive operator evidence**.
No access restriction was bypassed and no advertising redirect was followed. Search
extracts whose native source failed are research leads, not certification evidence.
Existing state IRS caches were reused; five new public state files were cached.

Fairbury guide page 18, the Hedlund operator notice on page 12 and the EMAHS rename
newsletter page 2 were rendered and visually inspected. Source PDFs, hashes and text
extractions are indexed in the evidence register. Original caches are ignored raw
files; tracked extracts, selected IRS records, manifest snapshots and page images
preserve the evidence for review.

The applied marker prevents rerunning the correction batch. Do not rerun `prepare.R`,
`acquire_hedlund.R` or `apply.R`. The saved scripts and before/after artifacts document
the operation; a new review requires a new snapshot. Cloud resource spending remains
**USD 0**. No correspondence, commit, push or external publication was initiated.

## Resume

Continue Madison Historical Society, Marion County Historical Society and Milton
Historical Society (eight each), then earlier unresolved and M2 queues. Keep the four
Old Jail blockers visible. Review final counts and explicit publication gates before
refreshing and exporting the provisional post/explorer; a deployment destination and
independent church labels are still missing.
