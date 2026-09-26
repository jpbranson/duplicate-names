# Apply this sub-batch once; do not treat the county packet as finished.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_county_leaders_2026-09-26"
stopifnot(!file.exists(file.path(packet, "franklin_identity_decisions_after.csv")))
before <- readRDS("data/processed/county_leaders_before.rds")
baseline <- before$entities
ids_before <- dn_read_museum_review(file.path(packet, "identity_decisions_before.csv"), dn_schema_museum_identity_decisions())
names_before <- dn_read_museum_review(file.path(packet, "name_decisions_before.csv"), dn_schema_museum_decisions())
rules <- dn_read_museum_review(file.path(packet, "chain_rules.csv"), dn_schema_chain_rules())
stopifnot(identical(ids_before, dn_read_museum_review("data/validation/museum_identity_decisions.csv", dn_schema_museum_identity_decisions())),
  identical(names_before, dn_read_museum_review("data/validation/museum_decisions.csv", dn_schema_museum_decisions())))
urls <- function(...) paste(c(...), collapse = " | ")
evidence <- list(
  PA = list(url = urls("https://www.franklinhistorical.org/", "https://www.franklinhistorical.org/about", "https://www.franklinhistorical.org/visit"),
    note = paste("Operator identifies the society headquarters and Old Jail museum at 175 E King St; its nonprofit board is listed.",
      "Both Overture rows give 175 E King St and 717-264-1667. IMLS 8404201394 gives the same address and pafch.tripod.com, also the Old Jail source website.",
      "Count The Old Jail once. John Brown House is a separately named museum with its own tour and is not merged.",
      "Identity, name, category and local independent governance reviewed. Operator posts September hours and an October 5-November 4 closure; recheck access before publication.")),
  VA = list(url = urls("https://franklincountyvahistoricalsociety.org/contact.html", "https://franklincountyvahistoricalsociety.org/aboutUs.html", "https://visitfranklincountyva.com/27/Things-to-Do"),
    note = paste("Operator identifies its history museum and research library at 460 S Main Street with PO Box 905 and 540-483-1890; membership elects its own board.",
      "IMLS 8405100628 matches both physical and mailing addresses, and the museum Overture row matches address and phone.",
      "Count the named museum once. The separate Overture society row at 65 E Court Street is not included: source address/phone history remains unresolved.",
      "Current access text is dated 2022 and preferred-name/old-address follow-up remains pending.")),
  OH = list(url = urls("https://cosi.org/about-cosi/history-of-cosi", "https://cosi.org/exhibits/dinos",
      "https://columbus.legistar.com/LegislationDetail.aspx?GUID=A80F490B-CA43-46F6-ADA6-51FB614C78FF&ID=4694386&Options=&Search=", "https://www.irs.gov/pub/irs-soi/eo_oh.csv"),
    note = paste("COSI and the city identify the Franklin County Historical Society as dba COSI at 333 W Broad Street; city tax ID and current IRS EIN 314383802 match IMLS 8403900842.",
      "Overture COSI gives the same address, cosi.org and 614-228-2674. The second Overture Center of science and industry (columbus) point is on the same museum site, 104 m from the canonical point.",
      "IMLS CENTER OF SCIENCE AND INDUSTRY has the same physical address but a displaced point and different EIN 311351334; the historical legal-entity distinction is retained, not treated as a second visitor museum.",
      "The Dinosaur Gallery shares address, website and phone; COSI explicitly describes it as its permanent exhibit included with admission.",
      "Count COSI once. No other Columbus historical society is merged. Complete governance/current access review remains pending.")),
  KS = list(url = urls("https://olddepotmuseum.org/historical-sites/franklin-county-records-research-center/",
      "https://olddepotmuseum.org/old-depot-museum-records-center-hours-and-restrictions-as-of-september-12-2021/",
      "https://ottawalibrary.pbworks.com/f/Genealogy.pdf", "https://olddepotmuseum.org/historical-sites/old-depot-museum/"),
    note = paste("The operator distinguishes the Archives & Research Center from Old Depot Museum: stored collections and research files are at the archives, exhibits are at the museum.",
      "The Ottawa library's genealogy guide lists the former records center at 1124 W 7th St Terrace with 785-242-1232, matching the Overture society phone and vicinity (source address variant 1140 W 7th St).",
      "Current operator archives address is 2011 E Logan. Operator mailing address PO Box 145 matches IMLS 8402000249 and its olddepotmuseum.org website.",
      "Treat the society administrative/mailing records as one non-museum record; do not count it in addition to Old Depot Museum. The museum and separately named Dietrich Cabin are not merged.",
      "Source points and address variants remain unchanged; no visitor point is exported for the excluded archives record."))
)
make_identity <- function(case, keys, roles) {
  x <- baseline[match(keys, baseline$source_id), ]
  stopifnot(!anyNA(x$source_id), length(roles) == nrow(x))
  tibble::tibble(case_id = paste0("County_Franklin_", case), source = x$source,
    source_id = x$source_id, expected_name = x$name_raw, expected_entity_id = x$entity_id,
    expected_coordinates = dn_identity_coordinates(x), role = roles,
    site_group = paste0("franklin_", tolower(case)), evidence_url = evidence[[case]]$url,
    evidence_note = evidence[[case]]$note, reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
}
added <- dplyr::bind_rows(
  make_identity("PA", c("0d75bfd8-a6a7-4bcd-b4b8-fa824929726f", "73e263dc-870a-405b-9005-b0075cece747", "8404201394"), c("canonical", "same_site", "same_site")),
  make_identity("VA", c("10e7fc9e-03f9-4f19-9721-866275411ebb", "8405100628"), c("canonical", "same_site")),
  make_identity("OH", c("e8066634-621e-4b73-9e1e-70324c0142c0", "9ab04429-8f37-4ca9-9b8b-3fcbc90b7429", "cd3a9e1b-32e7-4ab5-a567-47d9fb2270ff", "8403900675", "8403900842"),
    c("canonical", "same_site", "same_site", "mislocated", "mislocated")),
  make_identity("KS", c("d1b65814-90f9-4717-a126-79192a1664b4", "8402000249"), c("canonical", "mailing_address"))
)
identities <- dplyr::bind_rows(ids_before, added)
review <- dn_reconcile_museums(baseline, identities)
make_name <- function(key, url, note, affiliation = "unknown", status = "pending", category = "not_flagged") {
  x <- baseline[match(key, baseline$source_id), ]
  stopifnot(!is.na(x$source_id))
  tibble::tibble(source = x$source, source_id = key, expected_name = x$name_raw,
    category_decision = category, affiliation_status = affiliation, chain_id = NA_character_,
    review_status = status, evidence_url = url, note = note,
    reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
}
new_names <- dplyr::bind_rows(
  make_name("0d75bfd8-a6a7-4bcd-b4b8-fa824929726f", evidence$PA$url, evidence$PA$note, "independent", "verified"),
  make_name("10e7fc9e-03f9-4f19-9721-866275411ebb", evidence$VA$url, evidence$VA$note, "independent"),
  make_name("e8066634-621e-4b73-9e1e-70324c0142c0", evidence$OH$url, evidence$OH$note),
  make_name("d1b65814-90f9-4717-a126-79192a1664b4", evidence$KS$url, evidence$KS$note, status = "verified", category = "not_museum"),
  make_name("8404700168", "https://www.franklincountytnhistory.com/",
    "Operator confirms the volunteer nonprofit, PO Box 130 and a history-room contact at the county library. Earlier Old Jail review identifies a separate museum EIN. Historical society involvement with the jail does not establish present identity. Museum scope remains pending; no merger or not_museum inference from a mailing address."),
  make_name("8401300470", urls("https://www.franklin-county.com/business-directory.php", "https://andreakfreeland.my.canva.site/franklin-co-historical-society-georgia"),
    "Chamber and operator confirm the society. Operator identifies an office at 280 Busha Rd and Crow House meeting house; IMLS gives officer address 255 North Fork Rd. The related Overture Georgia-suffixed row uses 280 Busha and the operator phone. Museum role and administrative-record reconciliation remain pending; no inferred exclusion."),
  make_name("8401800641", urls("https://franklincountyin.com/wp-content/uploads/2019/03/Brookville-Historic-Tour-2016.pdf", "https://fclibraries.org/in-search-of/"),
    "County tourism describes the society-owned Franklin Seminary museum at 412 Fifth St; library material corroborates the collection. IMLS uses 826 Main St. Current operator name, access and the mailing-address connection remain pending. The former operator website failed to load; this is not evidence of closure."),
  make_name("8403700497", "https://www.louisburg.edu/_resources/tar-river-center/pdfs-files/Jail-Stabilization.pdf",
    "Louisburg College's 2018 report describes the society's former museum use of the county jail and the later restoration by another organization. Current society museum status and 3585 US 401 Hwy S mailing/address identity remain unresolved. Do not substitute the college center or infer permanent closure from the old report."),
  make_name("9fd03a7f-b35a-4ad9-a00a-b04f20cead24", "https://franklincountyvahistoricalsociety.org/contact.html",
    "Current operator museum address is 460 S Main Street, phone 540-483-1890. This source gives 65 E Court Street and 540-483-6828; its website domain matches the other museum source. Historical address evidence requires further checking before treating this as a former site. Keep pending and separate."),
  make_name("8401900675", "https://fchsiowa.org/historical-museum",
    "Operator page identifies Franklin County Historical Museum at 1000 Central Avenue West, with PO Box 114 matching IMLS, and appointment access. The source's society name does not establish the preferred museum name. The society's other historic properties, source point and preferred-name correction remain pending.")
)
stopifnot(!any(new_names$source_id %in% names_before$source_id))
decisions <- dplyr::bind_rows(names_before, new_names)
after <- dn_museum_analysis(review$records, rules, decisions)
stopifnot(nrow(added) == 12L, dplyr::n_distinct(added$case_id) == 4L,
  nrow(identities) == 104L, sum(after$counted) == 52575L,
  sum(after$analysis_eligible & after$name_expanded == "franklin county historical society") == 6L,
  identical(review$records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
for (pair in list(c("franklin_applied_identity_decisions.csv", "added"), c("franklin_applied_name_decisions.csv", "new_names"),
                 c("franklin_identity_decisions_after.csv", "identities"), c("franklin_name_decisions_after.csv", "decisions"))) {
  readr::write_csv(get(pair[2]), file.path(packet, pair[1]), na = "")
}
readr::write_csv(review$audit, file.path(packet, "franklin_identity_audit.csv"), na = "")
readr::write_csv(dn_museum_ranking(after), file.path(packet, "franklin_ranking_after.csv"), na = "")
readr::write_csv(identities, "data/validation/museum_identity_decisions.csv", na = "")
readr::write_csv(decisions, "data/validation/museum_decisions.csv", na = "")
message("Franklin sub-batch applied: 12 identity rows / 4 cases; 52,575 counted institutions; Franklin headline 11 -> 6.")
