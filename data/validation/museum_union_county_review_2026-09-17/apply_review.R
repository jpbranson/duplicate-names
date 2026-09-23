# One-time application of the explicitly listed, sourced Union County decisions.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_union_county_review_2026-09-17"
stopifnot(!file.exists(file.path(packet, "identity_decisions_after.csv")))
before <- readRDS("data/processed/union_review_before.rds")
baseline <- before$entities
ids_before <- dn_read_museum_review(file.path(packet, "identity_decisions_before.csv"),
                                   dn_schema_museum_identity_decisions())
names_before <- dn_read_museum_review(file.path(packet, "name_decisions_before.csv"),
                                     dn_schema_museum_decisions())
rules <- dn_read_museum_review(file.path(packet, "chain_rules.csv"), dn_schema_chain_rules())
review_date <- "2026-09-17"
evidence <- list(
  GA = list(url = paste("https://www.unioncountyhistory.org/",
    "https://www.unioncountyhistory.org/_files/ugd/b83337_d4d2401bc0564d09be5728d8074982a5.pdf",
    "https://www.unioncountyga.gov/312/Historical-Attractions", sep = " | "),
    note = paste("Official operator identifies its Old Courthouse Museum at 1 Town Square and PO Box 35.",
      "Both Overture society rows have the same official website and 706-745-5493 phone; the 3 Town Sq row is geographically displaced.",
      "IMLS gives 1 Town Square and PO Box 35. Reconcile only these three society records.",
      "The separately named Mountain Life Museum remains distinct. The generic courthouse attraction and Heritage Center require separate scope checks.",
      "Retained source name is an operator label; preferred museum name and local shared-operator affiliation remain pending.")),
  TN = list(url = paste("https://www.unioncountyhistoricalsocietytn.org/",
    "https://www.unioncountyhistoricalsocietytn.org/about-1", sep = " | "),
    note = paste("Official society operates the museum/library at 3824 Maynardville Highway, phone 865-992-2136, PO Box 95.",
      "Both Overture names share that street and phone; both IMLS records identify that street, with the society also using PO Box 95.",
      "Include every member of the existing Roy Acuff cluster; select its named museum record and retain the society as an alias.",
      "The official current heading is Union County Museum and Genealogical Library, so the retained Roy Acuff source label needs preferred-name review.",
      "Governance and visitor-point review remain pending.")),
  IL = list(url = paste("https://www.unioncountyilmuseum.com/contact-us",
    "https://www.unioncountyilmuseum.com/museum",
    "https://www.unioncountyilmuseum.com/in-the-news", sep = " | "),
    note = paste("Official operator contact identifies Union County Historical Society, PO Box 93, and the Union County Museum at 117 S Appleknocker.",
      "Overture points to the official operator site and the museum-page phone 618-893-2865; IMLS society is the PO Box 93 mailing record.",
      "Combine those two records only. Nearby Cobden Museum has a different source street (206 S Front) and phone and remains unresolved.",
      "Preferred museum name, resource-center scope and visitor point remain pending; current source operator label is retained.")),
  FL = list(url = paste("https://www.naturalnorthflorida.com/things-to-do/union-county-historical-museum/",
    "https://www.irs.gov/pub/irs-soi/eo_fl.csv", sep = " | "),
    note = paste("Regional tourism identifies Union County Historical Museum at 401 W Main Street Suite C and explicitly describes the society's museum collection.",
      "The archived 2026-09-15 IRS Florida row matches IMLS EIN 593163681 and its society mailing address 410 W Main Street.",
      "Treat museum and operator as one institution, with the society mailing record retained. The 401/410 address discrepancy and exact visitor point remain unresolved.",
      "This does not certify access or establish a second site.")),
  IA = list(url = paste("https://uchistoricalvillage.com/who-we-are/",
    "https://uchistoricalvillage.com/contact/",
    "https://www.unioncountyiowatourism.com/historical-sites/", sep = " | "),
    note = paste("Official operator identifies the Union County Historical Society as the nonprofit operating the Historical Village in McKinley Park with its own nine-member board and volunteers.",
      "Official contact gives 1600 S Stone, matching the Overture village website/address; county tourism confirms the village in McKinley Park.",
      "IMLS identifies the same society at 601 McKinley Street with PO Box 693. The park museum/operator records represent one institution.",
      "Retain the historical IMLS addresses without treating them as extra sites; use the current visitor address for access planning.")),
  NM = list(url = paste("https://www.herzsteinmuseum.com/history",
    "https://www.herzsteinmuseum.com/", sep = " | "),
    note = paste("Museum's own history connects the Union County Historical Society to the museum and establishes Herzstein Memorial Museum as its name since 1987.",
      "Current museum page and IMLS match 22 S Second Street and PO Box 75; Overture matches the official website and phone.",
      "Count the named museum once, retaining the society as a supporting alias. Current legal governance and affiliation still need confirmation."))
)
make_identity <- function(case, source_ids, roles) {
  x <- baseline[match(source_ids, baseline$source_id), ]
  stopifnot(!anyNA(x$source_id), length(roles) == nrow(x))
  tibble::tibble(case_id = paste0("Union_County_", case), source = x$source,
    source_id = x$source_id, expected_name = x$name_raw,
    expected_entity_id = x$entity_id, expected_coordinates = dn_identity_coordinates(x),
    role = roles, site_group = tolower(case), evidence_url = evidence[[case]]$url,
    evidence_note = evidence[[case]]$note, reviewed_by = "Codex source review",
    reviewed_on = review_date)
}
added <- dplyr::bind_rows(
  make_identity("GA", c("cc2a936a-b634-4b3b-a818-7ee5859ab8f2",
    "4a28b958-9a96-445f-93b5-cc21803391e0", "8401300409"),
    c("canonical", "mislocated", "mislocated")),
  make_identity("TN", c("29aa33ad-7c60-473d-904a-8757f1ffc3fc", "8404700044",
    "fcdc3086-3d5b-43a2-a461-64033d84e849", "8404700288"),
    c("canonical", "mislocated", "same_site", "mislocated")),
  make_identity("IL", c("e7510f8e-0832-445f-9683-c41138639bf9", "8401701115"),
    c("canonical", "mailing_address")),
  make_identity("FL", c("c560b9d8-d396-4cef-bc01-f2aaf135e6f5", "8401200927"),
    c("canonical", "mailing_address")),
  make_identity("IA", c("6144cfa5-647e-4aac-a4be-8300a2f04644", "8401900650"),
    c("canonical", "same_site")),
  make_identity("NM", c("63846205-a712-42e2-a1b2-bd29c123af52", "8403500111"),
    c("canonical", "same_site"))
)
identities <- dplyr::bind_rows(ids_before, added)
review <- dn_reconcile_museums(baseline, identities)
make_name <- function(source_id, url, note, affiliation = "unknown", status = "pending") {
  x <- baseline[match(source_id, baseline$source_id), ]
  tibble::tibble(source = x$source, source_id = source_id, expected_name = x$name_raw,
    category_decision = "not_flagged", affiliation_status = affiliation, chain_id = NA_character_,
    review_status = status, evidence_url = url, note = note,
    reviewed_by = "Codex source review", reviewed_on = review_date)
}
new_names <- dplyr::bind_rows(lapply(names(evidence), function(case) {
  anchor <- added$source_id[added$case_id == paste0("Union_County_", case) & added$role == "canonical"]
  make_name(anchor, evidence[[case]]$url, evidence[[case]]$note,
    if (case == "IA") "independent" else "unknown",
    if (case == "IA") "verified" else "pending")
}),
  make_name("59527f3f-99ff-4f83-b235-2d5f3b11f93b",
    "https://www.uchsohio.org/Museum | https://www.uchsohio.org/AboutUs",
    paste("Operator confirms its museum at 246 W Sixth Street, matching Overture address/phone and IMLS physical address.",
      "Existing two-source identity is supported and unchanged. IMLS also records 117 W Sixth as a mailing address.",
      "Confirm current governance, preferred museum label and visitor point before marking overall review verified.")),
  make_name("020cc712-f2e4-47a4-aa1e-8d83179974b6",
    "https://www.unioncopahistory.com/ | https://www.unioncopahistory.com/facilities | https://www.unioncopahistory.com/museum-collection",
    paste("Official society lists research library at 103 S Second Street, matching both source records; identity is supported and unchanged.",
      "Its museum collection is at the North Water Street Gallery; the operator acquired Packwood House/Annex in 2023 and describes a future Union County Museum there.",
      "Dale-Engle-Walker is another named site. Research-library versus museum counting, former Packwood records and shared-operator affiliation require follow-up; do not merge facilities merely for common ownership.")),
  make_name("8401800453", "https://uchistory.org/about-2/ | https://ucdc.us/business-directory/union-county-historical-society/ | https://www.irs.gov/pub/irs-soi/eo_in.csv",
    paste("Official society identifies the Depot Museum at One Liberty Street and PO Box 143; current IRS Indiana row matches IMLS EIN 351763921 and PO Box 143.",
      "This supports continuity of the society, not museum access at IMLS's older 488 S County Rd 10 mailing address.",
      "Related Overture Union County Historical Museum uses 156 E County Road 300 S and a directory URL; identity/address history remains insufficient for merger.",
      "The operator also preserves a cabin, Waterworks and an active church; site scope and affiliation remain pending.")),
  make_name("8404100121", "https://www.culturaltrust.org/wp-content/uploads/CNP_AlphaList_20251223.pdf | https://cityofunion.com/directory/union-county-museum/ | https://www.irs.gov/pub/irs-soi/eo_or.csv",
    paste("Oregon Cultural Trust lists Historical Society at Imbler separately from Union County Museum Society in Union; current IRS museum society EIN is 237031662.",
      "IMLS society row combines museum street/website with EIN 010975044 and La Grande PO Box 3361; its automatic cluster also contains Historical Treasure EIN 930836487 at that box.",
      "Neither old EIN was found in the current Oregon BMF; absence does not prove closure or identity. No supported split, merge or closure decision is applied.",
      "Resolve the conflicting source context and the two legal identities before publication; nearby Union County Museum records are left untouched.")),
  make_name("8403700530", "https://ncgenweb.us/union/research-resources/",
    paste("Genealogy resource directory corroborates the society's PO Box 397, also listed for Carolinas Genealogical Society.",
      "IMLS supplies no physical address and links the county historic-preservation commission. Research found no current operator/government evidence establishing a public museum at the source point.",
      "Retain the candidate pending dated museum, governance and visitor-location evidence; shared mailing address and absence of evidence do not establish merger or closure."))
)
decisions <- dplyr::bind_rows(names_before, new_names)
after <- dn_museum_analysis(review$records, rules, decisions)
stopifnot(nrow(added) == 15L, dplyr::n_distinct(added$case_id) == 6L,
  sum(after$analysis_eligible & after$name_expanded == "union county historical society", na.rm = TRUE) == 7L,
  sum(after$counted) == sum(before$analysis$counted) - 8L,
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
readr::write_csv(dplyr::filter(ranking, .data$n_entities >= ranking$n_entities[20L] |
  .data$name_expanded == "union county historical society"), file.path(packet, "ranking_after.csv"), na = "")
print(dn_museum_ranking(after)[1:12, ], width = Inf)
