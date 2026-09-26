# One-time supported Greene corrections. Unresolved reviews remain pending.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_county_leaders_2026-09-26"
stopifnot(!file.exists(file.path(packet, "greene_identity_decisions_after.csv")))
baseline <- targets::tar_read(entities)
ids_before <- dn_read_museum_review("data/validation/museum_identity_decisions.csv", dn_schema_museum_identity_decisions())
names_before <- dn_read_museum_review("data/validation/museum_decisions.csv", dn_schema_museum_decisions())
rules <- dn_read_museum_review("data/validation/museum_chain_rules.csv", dn_schema_chain_rules())
stopifnot(identical(ids_before, dn_read_museum_review(file.path(packet, "franklin_identity_decisions_after.csv"), dn_schema_museum_identity_decisions())),
  identical(names_before, dn_read_museum_review(file.path(packet, "franklin_name_decisions_after.csv"), dn_schema_museum_decisions())))
urls <- function(...) paste(c(...), collapse = " | ")
evidence <- list(
  PA = list(url = urls("https://greenecountyhistory.org/", "https://greenecountyhistory.org/about-us/"),
    note = paste("Operator identifies the incorporated local society's museum at 918 Rolling Meadows Road, open since 1971 with its own board and director.",
      "Overture museum and IMLS society share that physical street; IMLS point is displaced about 1.7 km. Count the museum-named Overture row once.",
      "The society's support for other historic sites does not merge those sites. Name, museum role, identity and local independent governance reviewed; recheck hours before visitor export.")),
  VA = list(url = "https://greenehistoryva.org/",
    note = paste("Operator explicitly documents moving its museum from the Old Jail at Court Square before 2015 to 360 Main Street; donations and a bequest funded the property.",
      "IMLS gives former 38 Court Street and greenehistory.org, linked by the current operator; Overture gives current 360 Main and 434-985-1834.",
      "Count the current site once and preserve the former site. Own board and membership support local independent governance.",
      "Preferred public name is Museum and Gallery, unlike the raw society label; that naming correction and visitor access remain pending.")),
  NY = list(url = urls("https://www.gchistory.org/what-we-do", "https://www.gchistory.org/bronck-museum-directions",
      "https://www.gchistory.org/trustees-staff", "https://www.gchistory.org/schedule-tour"),
    note = paste("Operator identifies Bronck Farmstead as society headquarters and Bronck Museum, plus a research library; same campus is not three visitor museums.",
      "Both Overture records and IMLS give 90 County Route 42. Museum phone 518-731-6490 matches operator; society phone 518-731-1033 is its office/library contact.",
      "Count Bronck Museum once. Museum buildings share the operator's tour. Local nonprofit governance and current museum name are confirmed; operator advertises seasonal May-October tours and 2026 programs.")),
  IA = list(url = urls("https://www.irs.gov/pub/irs-soi/eo_ia.csv",
      "https://greenecountynewsonline.com/2023/07/19/finding-civil-war-ancestors-topic-of-historical-society-program/",
      "https://www.experiencejeffersoniowa.com/directory/blog-post-title-two-3sg2n-3bgx7-eyex7-jbjy2-7zdct-dyhgp-8lgjc-lt6gh-belln-2hydb-3wdpb-ce7bw-ag4t7-pc83y-3p2sk-98mn7-mbhax-ctp96-prb3c-txnjp-nt33p"),
    note = paste("Society-authored program and local tourism identify the museum at 219 E Lincoln Way, phone 515-386-8544, matching Overture.",
      "Current IRS EIN 721548210 at that street matches IMLS's legal name/EIN and reconciles its PO Box 435 mailing record.",
      "Count the museum/society once; the conflicting bank-address museum row is separately isolated and contributes no aliases.",
      "Museum preferred name and complete affiliation/access review remain pending; legal existence alone is not the museum-role evidence.")),
  IA_conflict = list(url = urls("https://fraser.stlouisfed.org/files/docs/publications/fdic/CRAexamined/fdic_CRAexamined_19961119_387.pdf",
      "https://greenecountynewsonline.com/2023/07/19/finding-civil-war-ancestors-topic-of-historical-society-program/"),
    note = paste("Overture's Greene County Historical Museum row gives 115 W State St and hsbankiowa.com, a Home State Bank address/domain; FDIC identifies the bank at this address.",
      "Society's own museum program instead uses 219 E Lincoln Way. Preserve the contradictory source row as an uncounted source conflict, not a duplicate donor or evidence of a second museum.",
      "Do not propagate its disputed museum label or point to the accepted institution."))
)
make_identity <- function(case, keys, roles, groups = rep(paste0("greene_", tolower(case)), length(keys))) {
  x <- baseline[match(keys, baseline$source_id), ]
  stopifnot(!anyNA(x$source_id), length(roles) == nrow(x), length(groups) == nrow(x))
  tibble::tibble(case_id = paste0("County_Greene_", case), source = x$source,
    source_id = x$source_id, expected_name = x$name_raw, expected_entity_id = x$entity_id,
    expected_coordinates = dn_identity_coordinates(x), role = roles, site_group = groups,
    evidence_url = evidence[[case]]$url, evidence_note = evidence[[case]]$note,
    reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
}
added <- dplyr::bind_rows(
  make_identity("PA", c("ce425db9-ae71-48e9-a228-6a1cf01a16c4", "8404200979"), c("canonical", "mislocated")),
  make_identity("VA", c("ea3bd024-518f-4804-b09d-1ab65d97c6e3", "8405100530"), c("canonical", "former_site"), c("greene_va", "greene_va_old_jail")),
  make_identity("NY", c("e834d6d8-0981-4b9a-b796-b4b617633448", "7185e316-34b9-4f5d-9b6f-22f443c5289f", "8403600303"), c("canonical", "same_site", "mislocated")),
  make_identity("IA", c("ceb2f204-b657-4768-88fb-be45ca156056", "8401900692"), c("canonical", "mailing_address")),
  make_identity("IA_conflict", "8bdc4b3c-69de-4f5e-bfda-3f7e5090fc63", "source_conflict", "unresolved_source")
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
ga_note <- paste("City confirms a society-operated history museum and separate Old Rock Gaol, but gives conflicting East Greene/North East street wording.",
  "The Overture society record shares the gaol's point; IMLS is a PO Box 238 mailing row. Name, mailing identity and visitor point remain unresolved.",
  "Do not merge the society with the gaol from proximity or shared city website.")
new_names <- dplyr::bind_rows(
  make_name("ce425db9-ae71-48e9-a228-6a1cf01a16c4", evidence$PA$url, evidence$PA$note, "independent", "verified"),
  make_name("ea3bd024-518f-4804-b09d-1ab65d97c6e3", evidence$VA$url, evidence$VA$note, "independent"),
  make_name("e834d6d8-0981-4b9a-b796-b4b617633448", evidence$NY$url, evidence$NY$note, "independent", "verified"),
  make_name("ceb2f204-b657-4768-88fb-be45ca156056", evidence$IA$url, evidence$IA$note),
  make_name("8402900179", urls("https://www.greenecountyhistoricalsociety.com/about", "https://www.greenecountyhistoricalsociety.com/our-mission",
      "https://www.greenecountyhistoricalsociety.com/bylaws", "https://historymuseumonthesquare.org/our-museum-history/"),
    paste("Operator describes programs, publications and preservation projects, with society archives deposited at Missouri State University. PO Box 3466 matches IMLS.",
      "Society and museum histories distinguish its founding support for the History Museum from operating an additional museum under this society record.",
      "Exclude the outreach/preservation society record as not_museum; do not merge it into the separately operated History Museum merely from the historical association."),
    status = "verified", category = "not_museum"),
  make_name("e44e78c4-4c6a-473a-b50d-02e91a062c6d", "https://downtowngreensboroga.com/things-to-do-2", ga_note),
  make_name("8401300331", "https://downtowngreensboroga.com/things-to-do-2", ga_note),
  make_name("a9c4fa68-40e7-4b6c-ab11-d2db912e6755", urls("https://www.greenecoindianahistory.com/", "https://www.greenecountyhistoricalsociety.org/home.php"),
    "Current and former operator pages match the existing baseline Overture/IMLS cluster at 27 S Washington and PO Box 301. Own board and nonprofit archival/publication role confirmed. Current museum/exhibit function remains unresolved; no not_museum inference from an office label or unsuccessful search.", "independent"),
  make_name("dc7df26a-22e2-402d-a21c-43d6dd76bbb0", urls("https://www.greenecountyhistory.net/", "https://www.greenecountyhistory.net/about/history.php", "https://www.greenecountyhistory.net/support/facility-rental/rentals.php"),
    "Operator identifies headquarters at 310 Main Street/PO Box 746 in Vaughn-Morrow House, with event rentals and preservation tours. These confirm existing cluster identity, but a present museum/exhibit role and scope of separately preserved courthouse/seminary remain unresolved. Related courthouse row has a Missouri society website; no merger or unsupported exclusion applied.")
)
stopifnot(!any(new_names$source_id %in% names_before$source_id))
decisions <- dplyr::bind_rows(names_before, new_names)
after <- dn_museum_analysis(review$records, rules, decisions)
stopifnot(nrow(added) == 10L, dplyr::n_distinct(added$case_id) == 5L,
  nrow(identities) == 114L, sum(after$counted) == 52568L,
  sum(after$analysis_eligible) == 52436L, sum(review$records$counted) == 57278L,
  sum(after$analysis_eligible & after$name_expanded == "greene county historical society") == 6L,
  sum(after$review_status == "verified") == 24L,
  identical(review$records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
for (pair in list(c("greene_applied_identity_decisions.csv", "added"), c("greene_applied_name_decisions.csv", "new_names"),
                 c("greene_identity_decisions_after.csv", "identities"), c("greene_name_decisions_after.csv", "decisions"))) {
  readr::write_csv(get(pair[2]), file.path(packet, pair[1]), na = "")
}
readr::write_csv(review$audit, file.path(packet, "greene_identity_audit.csv"), na = "")
readr::write_csv(dn_museum_ranking(after), file.path(packet, "greene_ranking_after.csv"), na = "")
irs <- readr::read_csv("data/raw/county_greene_ia_irs_2026-09-26.csv", col_types = readr::cols(.default = "c"))
readr::write_csv(irs[irs$EIN == "721548210", ], file.path(packet, "irs_ia_selected.csv"))
readr::write_csv(identities, "data/validation/museum_identity_decisions.csv", na = "")
readr::write_csv(decisions, "data/validation/museum_decisions.csv", na = "")
message("Greene sub-batch applied: 10 identity rows / 5 cases; 52,568 counted institutions; Greene headline 11 -> 6.")
