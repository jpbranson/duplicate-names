# Affiliation follow-up evidence and open questions

Research date: 2026-09-26 UTC. These are factual source decisions, not independent
matching labels. The supported changes are applied; selective rebuild validation
is recorded separately in validation.log and integrity_checks.csv.

## Evidence read

- [Smithsonian visitor directory](https://www.si.edu/visit/museums), read through
  the web tool; native cache returned 403. It lists the Smithsonian's own museums
  and distinguishes the separate Affiliates program. It supplies One Bowling Green
  for NMAI New York, 14390 Air and Space Museum Parkway for Udvar-Hazy, and 950
  Independence Avenue for African Art. Five parent-label records have corresponding
  addresses/domains and now carry parent affiliation, with full identity/name review
  still pending. This is not a rule for all museums carrying Smithsonian in a name.
- [Archives of American Art 2023 report](https://www.aaa.si.edu/sites/default/files/Documents/2023-Annual-Report.pdf),
  cached with checksum, explicitly separates its Washington/New York offices from
  its exhibition gallery. The offices are at 750 9th Street NW and 300 Park Avenue
  South; the gallery is at 8th and F Streets NW. The source records at the offices
  are excluded as extra museums. The [2012 relocation announcement](https://www.aaa.si.edu/news/new-york-research-center-moving.html)
  independently identifies the New York research center, rather than a new museum.
- [Madame Tussauds Las Vegas address](https://lasvegas-support.madametussauds.com/hc/en-us/articles/115002250572-What-is-your-address),
  read through the web tool (native cache 403), matches IMLS 3377 S Las Vegas Blvd.
  The [Las Vegas site](https://www.madametussauds.com/las-vegas/) and
  [brand directory](https://www.madametussauds.com/) were cached. The Overture wax
  museum record links the Las Vegas site. The two formerly unaffiliated same-name
  records are one attraction, now named Madame Tussauds Las Vegas in analysis.
  Original source names and both coordinates remain unchanged. This resolves the
  earlier wax-museum chain overlap; it does not certify a nationwide chain inventory.

## Remaining Smithsonian parent-label cases

- One Bowling Green: two generic parent records have identical address and phone,
  but one point is in Brooklyn. Named NMAI records also exist. Preserve all until
  a complete guarded identity case covers every baseline member and the contradictory
  point is handled explicitly. Parent affiliation is supported; no count merge yet.
- Udvar-Hazy: generic parent records and named museum records overlap; one generic
  row has 14890/Fairfax and distant coordinates rather than the operator's 14390
  Chantilly address. Institution/site scope with the Mall museum also needs review.
- 950 Independence: parent label overlaps the separately named African Art museum.
  Exact source membership/name reconciliation remains pending.
- 300 Maryland Avenue NE: source links si.edu, but the street/phone/site role does
  not match the checked visitor directory. Keep pending; do not treat a failed
  address search as proof of a non-museum.
- 1368 Euclid: no source found establishing museum role or operator at this point.
  A historic apartment-building record is only a research lead. No exclusion.
- 400 Herndon Parkway: source points to animalconnections.com. Smithsonian's own
  [2013 release](https://www.si.edu/es/newsdesk/releases/smithsonian-mobile-exhibit-explores-human-animal-bond-0)
  describes Animal Connections as a mobile exhibition, not a fixed museum there.
  This does not establish the identity of the Herndon record; keep pending.

The live group is now five affiliated pending records, three unknown pending records,
and two excluded office/research institutions. It is not a national collision headline.
Museum of Illusions Miami Beach remains unresolved; city-suffixed network access
reviews and earlier county queues are still open. No chain inventory totals are certified.

## Acquisition and preservation

prepare.R stopped after its input snapshot because a distance helper did not exist.
It was corrected to the same bounded coordinate-window dossier method used earlier;
resume_prepare.R completed only the remaining dossier. Do not rerun either snapshot.
There are 70 candidate records, 623 nearby/named source rows, 384 Overture metadata
records from the pinned release, and 366 protected prior evidence/label files.
cache_status.csv retains all failures. No access control was bypassed and no paid
cloud resource was used. Cloud resource spending USD 0.

### Local-operator consistency supplement

The source review also revisited two older verified-independent decisions. Current
wchsmn.org/about-us explicitly operates Heritage Center, Warden's House and Hay Lake
School; johnhaycenter.org presents Stevens and The Depot as separately named museum
tours with combined tours, membership and fundraising. Both groups now use shared
operator affiliations. Two completed reviews stay completed; four companion records
have affiliation only and remain pending. Museum counts and identity rows do not
change. The initial sub-checkpoint is retained as initial_*; final review input is
museum_decisions_final.csv. Final rebuild: 253 assertions, 17 checks, 366 protected
files unchanged. Publication-point helper tests were added afterward and are not
included in that assertion count.
