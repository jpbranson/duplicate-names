# One-time application of the explicitly listed, sourced decisions for the two
# co-leading names: Museum of Illusions and Washington County Historical Society.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_leaders_review_2026-09-23"
stopifnot(!file.exists(file.path(packet, "identity_decisions_after.csv")))
before <- readRDS("data/processed/leaders_review_before.rds")
baseline <- before$entities
ids_before <- dn_read_museum_review(file.path(packet, "identity_decisions_before.csv"),
                                   dn_schema_museum_identity_decisions())
names_before <- dn_read_museum_review(file.path(packet, "name_decisions_before.csv"),
                                     dn_schema_museum_decisions())
rules <- dn_read_museum_review(file.path(packet, "chain_rules.csv"), dn_schema_chain_rules())
review_date <- "2026-09-23"
reviewer <- "Claude source review"
urls <- function(...) paste(c(...), collapse = " | ")

evidence <- list(
  IN = list(url = urls("https://www.johnhaycenter.org/index.php/attractions/stevens-memorial-museum",
    "https://www.johnhaycenter.org/index.php/contact-john-hay-center",
    "https://www.johnhaycenter.org/index.php/about/staff-leadership"),
    note = paste("Operator: the Stevens Memorial Museum 'is the centerpiece of the John Hay Center, founded by the Washington County Historical Society', at 307 E. Market Street, Salem.",
      "Overture society and Stevens records share that street, johnhaycenter.org and 812-883-6495; IMLS society EIN 356063713 uses the same street and website.",
      "Count the named museum once and retain the society rows as same-site support. The Depot Railroad Museum is a separately named John Hay Center site and is not merged.",
      "The operator's preferred umbrella name is John Hay Center.")),
  MD = list(url = urls("https://msa.maryland.gov/msa/mdmanual/01glance/museums/wa/html/wa.html",
    "https://washcohistory.org/miller-house/"),
    note = paste("Maryland Manual lists 'Miller House Museum Washington County Historical Society, 135 West Washington St.' with 301-797-8782.",
      "Overture society and Miller House records share that street and phone; both IMLS rows carry the society's legal name, EIN 526047982 and 135 W Washington St.",
      "Count Miller House Museum once, with society rows as same-site support. The Beaver Creek School named in one IMLS row is listed by the Maryland Manual as closed in 2016 and is not a current second site.",
      "The IMLS society row's hswcv.org website belongs to the Historical Society of Washington County, Virginia; its EIN, legal name and address are Maryland, so no conflicting identity is transferred.",
      "The operator website was in maintenance at review time; governance and current tour hours remain pending.")),
  NC = list(url = urls("https://portoplymouthmuseum.org/about-port-o-plymouth-museum/",
    "https://portoplymouthmuseum.org/about-port-o-plymouth-museum/plan-a-visit-2/"),
    note = paste("Operator: 'Opened in 1989, the Port o' Plymouth Museum is owned and operated by the Washington County Historical Society', at 302 E. Water St.",
      "IMLS society (EIN 561538852) gives physical address 302 E Water Street and PO Box 296, but its point is about 2.3 km from the museum; Overture places the museum at 302 E Water St.",
      "Count the museum once and treat the IMLS point as mislocated. The Roanoke River Lighthouse and Maritime Museum at 206 W Water St is a different institution.",
      "Governance beyond an operator board and current access need a complete review.")),
  OK = list(url = urls("https://www.okhistory.org/publications/enc/entry?entry=DE017",
    "https://www.wchs-ok.org/", "https://www.okhistory.org/sites/tommix"),
    note = paste("Oklahoma Historical Society: the Dewey Hotel was 'Donated to the Washington County Historical Society in 1967'. The operator site presents the society and Dewey Hotel Museum together.",
      "IMLS society EIN 736103633 has physical address 801 N Delaware and wchs-ok.org, matching both Dewey Hotel records; Overture's Dewey Hotel phone 918-534-0215 is the society's.",
      "Count Dewey Hotel Museum once with the society as same-site support. Tom Mix Museum is an OHS affiliate managed by Tom Mix Museum, Inc. and remains separate.",
      "Governance and preferred-name review remain pending.")),
  MN = list(url = urls("https://www.wchsmn.org/about-us/", "https://www.wchsmn.org/about-us/contact/"),
    note = paste("Operator: 'Founded April 11, 1934, the Washington County Historical Society is a private, non-profit educational institution'; it 'operates three museum sites', including the Washington County Heritage Center at 1862 Greeley Street South, its mailing address.",
      "Overture's Heritage Center shares wchsmn.org; IMLS society (EIN 416038333) gives PO Box 167, still the IRS address, and its point matches no society site.",
      "Count the Heritage Center once and retain IMLS as the society mailing record. Warden's House Museum and Hay Lake School are separately named sites and are not merged.")),
  OH = list(url = urls("https://www.wchshistory.org/visit-the-archives",
    "https://www.wchshistory.org/about-wchs",
    "https://projects.propublica.org/nonprofits/api/v2/organizations/316039450.json"),
    note = paste("Operator's Archives page: 'The Archives of the Washington County Historical Society of Ohio' at 346 Muskingum Drive, matching the Overture society record.",
      "IMLS 'Washington County Historical Society of Ohio' (EIN 316039450, PO Box 103) is the only Marietta IRS record for this name; its point matches no society site.",
      "Treat the IMLS row as the same organization's mailing record. 346 Muskingum Drive is an archives/research room; the society's Fearing House and Anchorage are separately named sites.",
      "Whether the counted society record should represent a museum at all remains pending.")),
  AR = list(url = urls("https://projects.propublica.org/nonprofits/api/v2/organizations/300212518.json",
    "https://washcohistoricalsociety.org/Properties"),
    note = paste("IMLS displays WASHINGTON COUNTY HISTORICAL SOCIETY, but its legal name and EIN 300212518 identify The Washington County Historic Preservation Association, a separate small exempt organization.",
      "Its 617 W Lafayette mailing address is a private historic house in the IRS care-of record; no museum was found there or elsewhere for this association.",
      "The Historical Society itself is already counted once as Headquarters House. Isolate this mixed row without transferring its displayed name to either organization.")),
  LA = list(url = urls("https://illusions-la.com/", "https://illusions-la.com/museum-of-illusions/",
    "https://www.museumofillusions.com/our-locations/"),
    note = paste("Operator: 'WonderWalk is the new name of World of Illusions at 6751 Hollywood Blvd - same place, same three attractions, same entrance'; one ticket covers 'the Museum of Illusions, the Giant's House and the Upside Down House'.",
      "Both Overture records give 6751 Hollywood Blvd, laillusions.com and 800-593-2902. Count the venue once; Museum of Illusions is a sub-attraction, retained as a same-site alias.",
      "The operator says Museum of Illusions Santa Monica is a separate business, and the venue is absent from the global Museum of Illusions directory. Its own affiliation remains unknown."))
)
make_identity <- function(case, source_ids, roles, site_group = tolower(case)) {
  x <- baseline[match(source_ids, baseline$source_id), ]
  stopifnot(!anyNA(x$source_id), length(roles) == nrow(x))
  tibble::tibble(case_id = paste0("Leaders_", case), source = x$source,
    source_id = x$source_id, expected_name = x$name_raw,
    expected_entity_id = x$entity_id, expected_coordinates = dn_identity_coordinates(x),
    role = roles, site_group = site_group, evidence_url = evidence[[case]]$url,
    evidence_note = evidence[[case]]$note, reviewed_by = reviewer, reviewed_on = review_date)
}
added <- dplyr::bind_rows(
  make_identity("IN", c("128b5b25-e15b-4e75-be9b-50de8321e93b", "df057a04-1a97-4b93-8a80-3210dc121a49",
    "8401800656"), c("canonical", "same_site", "same_site")),
  make_identity("MD", c("7de4411b-c2f7-41d0-8a71-341f74508fb4", "7697d60a-34be-4d3d-adac-d6e8d3f4470e",
    "8402400599", "8402400040"), c("canonical", "same_site", "same_site", "same_site")),
  make_identity("NC", c("ae837bd5-a2b6-40bf-bfa2-1be4a7b40cc4", "8403700551"),
    c("canonical", "mislocated")),
  make_identity("OK", c("b71c8d0b-0fc7-434f-8509-b7a23747f3ec", "8404000089", "8404000520"),
    c("canonical", "same_site", "same_site")),
  make_identity("MN", c("68d726b1-08a1-4bf5-948e-16e3f24bc530", "8402700638"),
    c("canonical", "mailing_address")),
  make_identity("OH", c("f874863e-866e-49e1-9dca-17b4211ad14e", "8403900852"),
    c("canonical", "mailing_address")),
  make_identity("AR", "8400500101", "source_conflict", "unresolved_source"),
  make_identity("LA", c("5528c66a-a815-4597-84d0-dbabfa444a20", "7034b742-415d-4469-9198-89faf43da7b3"),
    c("canonical", "same_site"))
)
identities <- dplyr::bind_rows(ids_before, added)
review <- dn_reconcile_museums(baseline, identities)

make_name <- function(source_id, url, note, affiliation = "unknown", status = "pending",
                      chain_id = NA_character_) {
  x <- baseline[match(source_id, baseline$source_id), ]
  stopifnot(!is.na(x$source_id))
  tibble::tibble(source = x$source, source_id = source_id, expected_name = x$name_raw,
    category_decision = "not_flagged", affiliation_status = affiliation, chain_id = chain_id,
    review_status = status, evidence_url = url, note = note,
    reviewed_by = reviewer, reviewed_on = review_date)
}
# Resulting institutions from the new identity cases (the AR conflict row is uncounted).
case_names <- dplyr::bind_rows(
  make_name("128b5b25-e15b-4e75-be9b-50de8321e93b", evidence$IN$url,
    paste(evidence$IN$note, "Governance: the operator lists its own elected WCHS board and officers, with no county or other parent operator; IRS lists a 501(c)(3). Operator hours are posted for 2026. Complete factual review; this is not a field survey of the map point."),
    "independent", "verified"),
  make_name("7de4411b-c2f7-41d0-8a71-341f74508fb4", evidence$MD$url, evidence$MD$note),
  make_name("ae837bd5-a2b6-40bf-bfa2-1be4a7b40cc4", evidence$NC$url, evidence$NC$note),
  make_name("b71c8d0b-0fc7-434f-8509-b7a23747f3ec", evidence$OK$url, evidence$OK$note),
  make_name("68d726b1-08a1-4bf5-948e-16e3f24bc530", evidence$MN$url,
    paste(evidence$MN$note, "The operator's own governance description supports independent local operation; Heritage Center hours are posted. Complete factual review; not a field survey of the map point."),
    "independent", "verified"),
  make_name("f874863e-866e-49e1-9dca-17b4211ad14e", evidence$OH$url, evidence$OH$note),
  make_name("5528c66a-a815-4597-84d0-dbabfa444a20", evidence$LA$url, evidence$LA$note)
)
# Remaining Washington County candidates: evidence recorded, no identity change.
wchs_names <- dplyr::bind_rows(
  make_name("8402000305", urls("https://sites.google.com/view/wchistorical/home",
    "https://sites.google.com/view/wchistorical/contact-us-hours-open", "https://www.irs.gov/pub/irs-soi/eo_ks.csv"),
    paste("Operator site: 'The Washington County Museum was purchased by the Historical Society in 1981'; the society also owns a Sheriff's Residence & Jail at 23 C St.",
      "Operator contact and current IRS row (EIN 480882253) give 216 Ballard Street; IMLS gives only PO Box 31, and its point is unconfirmed.",
      "Preferred museum name (Washington County Museum), visitor point and governance remain pending.")),
  make_name("8401900181", "https://iagenweb.org/washington/wchs.htm",
    paste("County genealogy page (updated 2025-08-28) describes the society's Conger House Museum at 903 E. Washington St, open 2nd and 4th Sundays in 2025, plus schoolhouse and store sites.",
      "The IMLS website no longer resolves and IRS gives PO Box 924. This page is not an operator source.",
      "Operator/government confirmation, preferred museum name, current access and visitor point remain pending.")),
  make_name("613a19b3-8df1-4fde-bac2-ed689e93d4ce", urls("https://wchs-ny.org/the-wing-northup-house/",
    "https://wchs-ny.org/heritage-research-library/", "https://villageoffortedward.gov/attractions/oldforthousemuseum/"),
    paste("Operator: 167 Broadway is the Wing-Northup House, 'the home of the Washington County Historical Society', housing its Heritage Research Library, open Tuesdays and Wednesdays. It is presented as headquarters and library, not a house museum.",
      "The Old Fort House Museum at 29 Broadway belongs to the separate Fort Edward Historical Association and is not merged.",
      "Whether this headquarters/library belongs in a museum count remains pending; no exclusion category exists for it yet.")),
  make_name("8404900183", urls("https://wchsutah.org/wchs/about-wchs.php",
    "https://wchsutah.org/buildings/old-county-courthouse9.php", "https://wchsutah.org/museums/museums.php"),
    paste("Operator: 'WCHS exists to encourage and assist all interested Washington County communities with the organization of their city historical societies'; its address is PO Box 404.",
      "It co-manages the Pioneer Courthouse with the City of St. George and three other groups, but operates no museum of its own. Its IMLS point coincides with an unrelated Southwest Indian Museum record.",
      "Retained pending: the record appears to describe a non-museum umbrella society, which the current decision schema cannot exclude.")),
  make_name("8402800165", urls("https://www.mississippihistory.org/local-historical-societies",
    "https://apps.irs.gov/pub/epostcard/data-download-revocation.zip",
    "https://projects.propublica.org/nonprofits/api/v2/organizations/475558530.json"),
    paste("The state historical society directory lists the society at 166 Nowell Road, with no museum. IRS revoked EIN 640594458 (PO Box 506) on 2013-05-15 with no reinstatement found.",
      "Nearby Greenville History Museum is a separate nonprofit (EIN 475558530). Revocation does not establish dissolution, and no museum operated by the society was found.",
      "Retained pending: current existence and any museum role are unconfirmed."))
)
# Museum of Illusions: complete the 11 network reviews and record Miami's status.
moi_sites <- tibble::tribble(
  ~source_id, ~city, ~site, ~open_note,
  "b265eee2-199c-45f3-882a-e529d744f4c6", "Pittsburgh", "https://moipittsburgh.com/contact-us/", "Official site lists 267 North Shore Drive with current hours and ticketing.",
  "aca0587b-dbde-4d67-a74c-e7ebe7b874ca", "Detroit", "https://www.moidetroit.com/contact-us/", "Official site lists 1545 Woodward Ave with current hours and ticketing.",
  "4c750539-2063-49ac-9e98-d9e0f79cb279", "Charlotte", "https://moicharlotte.com/", "Official site lists 601 S. Tryon Street; a 2026 banner announces new illusions and reopening in late October, so access is temporarily closed.",
  "27260a45-e524-43e3-8267-937dcaeaeb9b", "Denver", "https://moidenver.com/", "Official site lists 951 16th Street Mall; a 2026 banner announces new illusions and reopening in November, so access is temporarily closed.",
  "27cf1f4b-2da0-4506-963d-3dac0622c113", "Mall of America", "https://moimallofamerica.com/contact-us/", "Official site lists 60 E Broadway (281 Central Parkway inside the mall) with current hours.",
  "4839d27e-d755-418c-9a26-a6c30f0dcd43", "San Diego", "https://moisandiego.com/contact-us/", "Official site lists 665 Fifth Ave with current hours.",
  "94f0e826-ace4-490f-aa7e-a20408c96b77", "Scottsdale", "https://moiscottsdale.com/contact-us/", "Official site lists 9500 East Via de Ventura with current hours.",
  "717a473d-6a94-4a75-8de1-0fe50f19f450", "Santa Monica", "https://moisantamonica.com/contact-us/", "Official site lists 1232 3rd Street Promenade with current hours.",
  "10d4d837-5673-4dfc-a618-7b5a72b0f37b", "Philadelphia", "https://moiphilly.com/contact-us/", "Official site lists 401 Market Street with current hours.",
  "0a7d550c-5085-4969-b80d-15b9be6451eb", "Washington DC", "https://moiwashington.com/contact-us/", "Official site lists CityCenterDC, 927 H Street NW with current hours.",
  "ded6189f-7f83-43b2-b59c-26db0d6e6632", "Kansas City", "https://moikansascity.com/contact-us/", "Official site lists Union Station, 30 W Pershing Rd with current hours; the source's museumofillusions.us address redirects there."
)
moi_names <- dplyr::bind_rows(lapply(seq_len(nrow(moi_sites)), function(i) {
  make_name(moi_sites$source_id[i], urls("https://www.museumofillusions.com/our-locations/", moi_sites$site[i]),
    paste("Official global directory lists", moi_sites$city[i], "and the location site states 'This museum is part of the global Museum of Illusions group'.",
      moi_sites$open_note[i], "Source address agrees. Brand affiliation only: the sites do not state franchise versus company ownership.",
      "Complete factual review of identity, name and affiliation; recheck access before any publication map."),
    "chain", "verified", "museum_of_illusions_global")
}),
  make_name("7c3aed7a-dd9d-4c56-a984-c5f8a303a9f0", "https://www.museumofillusions.com/our-locations/",
    paste("Absent from the global Museum of Illusions directory. The source website miaillusions.com no longer resolves; its last indexed title was 'Closed in Miami Beach' and referred visitors to World of Illusions Los Angeles and a San Francisco illusions museum.",
      "That suggests the WonderWalk operator group rather than the global network, but no direct operator page or dated closure was retrieved.",
      "Retained pending: neither a failed domain nor an index snippet establishes permanent closure or ownership."))
)
replaced <- names_before$source_id %in% moi_names$source_id
stopifnot(sum(replaced) == 11L)
new_names <- dplyr::bind_rows(case_names, wchs_names, moi_names)
decisions <- dplyr::bind_rows(names_before[!replaced, ], new_names)
after <- dn_museum_analysis(review$records, rules, decisions)
n_name <- function(x, nm) sum(x$analysis_eligible & x$name_expanded == nm, na.rm = TRUE)
message("Counted institutions: ", sum(before$analysis$counted), " -> ", sum(after$counted))
message("WCHS: ", n_name(before$analysis, "washington county historical society"), " -> ", n_name(after, "washington county historical society"))
message("MOI: ", n_name(before$analysis, "museum of illusions"), " -> ", n_name(after, "museum of illusions"))
stopifnot(nrow(added) == 19L, dplyr::n_distinct(added$case_id) == 8L,
  n_name(after, "washington county historical society") == 7L,
  n_name(after, "museum of illusions") == 12L,
  sum(after$counted) == sum(before$analysis$counted) - 9L,
  identical(review$records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
for (item in list(c("applied_identity_decisions.csv", "added"),
                  c("applied_name_decisions.csv", "new_names"),
                  c("identity_decisions_after.csv", "identities"),
                  c("name_decisions_after.csv", "decisions"))) {
  readr::write_csv(get(item[2]), file.path(packet, item[1]), na = "")
}
readr::write_csv(identities, "data/validation/museum_identity_decisions.csv", na = "")
readr::write_csv(decisions, "data/validation/museum_decisions.csv", na = "")
readr::write_csv(review$audit, file.path(packet, "identity_audit.csv"), na = "")
ranking <- dn_museum_ranking(after)
readr::write_csv(dplyr::filter(ranking, .data$n_entities >= ranking$n_entities[20L]),
                 file.path(packet, "ranking_after.csv"), na = "")
print(ranking[1:12, ], width = Inf)
