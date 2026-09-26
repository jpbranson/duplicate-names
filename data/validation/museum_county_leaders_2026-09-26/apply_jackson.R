# One-time sourced corrections; preserve all unresolved decisions as pending.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_county_leaders_2026-09-26"
stopifnot(!file.exists(file.path(packet, "jackson_identity_decisions_after.csv")))
baseline <- targets::tar_read(entities)
ids_before <- dn_read_museum_review("data/validation/museum_identity_decisions.csv", dn_schema_museum_identity_decisions())
names_before <- dn_read_museum_review("data/validation/museum_decisions.csv", dn_schema_museum_decisions())
rules <- dn_read_museum_review("data/validation/museum_chain_rules.csv", dn_schema_chain_rules())
stopifnot(identical(ids_before, dn_read_museum_review(file.path(packet, "greene_identity_decisions_after.csv"), dn_schema_museum_identity_decisions())),
  identical(names_before, dn_read_museum_review(file.path(packet, "greene_name_decisions_after.csv"), dn_schema_museum_decisions())))
urls <- function(...) paste(c(...), collapse = " | ")
county_ia <- "https://jackson.county.iowa.sites.gmdsolutions.net/recorder/genealogy/"
evidence <- list(
  MN = list(url = urls("https://www.jchsmn.org/", "https://www.jchsmn.org/about-us", "https://www.jchsmn.org/about-us/staff-and-directors"),
    note = paste("Operator confirms museum at 307 North Highway 86, phone 507-662-5505 and PO Box 238. Both source rows identify this same institution; IMLS point is displaced.",
      "Count museum-named Overture row once. Own board confirmed, but county financial statements describe a legally separate fiscally dependent component unit with a county appointee.",
      "Leave complete affiliation/current public-name review pending; do not infer independence merely from a local board.")),
  MO = list(url = urls("https://www.jchs.org/truman-courthouse", "https://www.jchs.org/1859jailmuseum", "https://www.jchs.org/plan-your-visit", "https://www.jchs.org/mission-1"),
    note = paste("Operator distinguishes its History Center with rotating artifact exhibits at 112 W Lexington Suite 120 from its 1859 Jail Museum at 217 N Main.",
      "The baseline society cluster incorrectly joins Overture at the jail and IMLS at the History Center. Explicitly split that cluster, while consolidating the two jail-named rows with the Overture society row at 217 N Main/816-252-1892.",
      "Retain two counted visitor institutions with separate reviewed IDs and aliases, not one operator-wide museum. Both share the Jackson County Missouri Historical Society operator.",
      "The History Center's current preferred public name differs from its IMLS legal society name and remains pending.")),
  IA_conflict = list(url = urls("https://www.irs.gov/pub/irs-soi/eo_ia.csv", county_ia, "https://www.greatgiveday.org/organization/Jackson-County-Historical-Society-4"),
    note = paste("IMLS EIN 900885953/PO Box 91 identifies the Baldwin Society subordinate in current IRS data, but its physical street and website refer to the Maquoketa museum at 1212 E Quarry (parent EIN 420984105).",
      "Preserve this mixed Baldwin/Maquoketa source row as an uncounted source conflict with no donated aliases. This does not assert that Baldwin has no museum.",
      "County directory and foundation profile corroborate the parent museum; the jciahs.com website has unrelated commercial text and failed TLS validation, so is not sole evidence."))
)
make_identity <- function(case, keys, roles, groups = rep(paste0("jackson_", tolower(case)), length(keys))) {
  x <- baseline[match(keys, baseline$source_id), ]
  stopifnot(!anyNA(x$source_id), length(roles) == nrow(x), length(groups) == nrow(x))
  tibble::tibble(case_id = paste0("County_Jackson_", case), source = x$source,
    source_id = x$source_id, expected_name = x$name_raw, expected_entity_id = x$entity_id,
    expected_coordinates = dn_identity_coordinates(x), role = roles, site_group = groups,
    evidence_url = evidence[[case]]$url, evidence_note = evidence[[case]]$note,
    reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
}
added <- dplyr::bind_rows(
  make_identity("MN", c("b4ee8d7b-3852-4d1d-aff7-f42ee258febf", "8402700338"), c("canonical", "mislocated")),
  make_identity("MO", c("c4d698e3-5e35-45c6-a955-46e6af9bfca3", "3dd7d9f9-6688-44d7-a4ce-210205555063", "8402900125", "8402900687"),
    c("split_canonical", "same_site", "same_site", "split_canonical"), c("jackson_mo_jail", "jackson_mo_jail", "jackson_mo_jail", "jackson_mo_history_center")),
  make_identity("IA_conflict", "8401900708", "source_conflict", "unresolved_source")
)
identities <- dplyr::bind_rows(ids_before, added)
review <- dn_reconcile_museums(baseline, identities)
make_name <- function(key, url, note, affiliation = "unknown", status = "pending", category = "not_flagged", chain = NA_character_) {
  x <- baseline[match(key, baseline$source_id), ]
  stopifnot(!is.na(x$source_id))
  tibble::tibble(source = x$source, source_id = key, expected_name = x$name_raw,
    category_decision = category, affiliation_status = affiliation, chain_id = chain,
    review_status = status, evidence_url = url, note = note,
    reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
}
new_names <- dplyr::bind_rows(
  make_name("b4ee8d7b-3852-4d1d-aff7-f42ee258febf", evidence$MN$url, evidence$MN$note),
  make_name("c4d698e3-5e35-45c6-a955-46e6af9bfca3", evidence$MO$url,
    paste(evidence$MO$note, "The jail's museum name, visitor address, identity and common operator are verified; seasonal access is advertised April-October, with holiday December weekends; recheck before visitor export."),
    "chain", "verified", chain = "jackson_county_mo_historical_society"),
  make_name("8402900687", evidence$MO$url, evidence$MO$note, "chain", chain = "jackson_county_mo_historical_society"),
  make_name("cacd25a7-8dfa-4a6c-a113-10f6d18e6fbf", urls("https://www.jchsil.org/", "https://www.jchsil.org/index.php/about/about-us", "https://www.jchsil.org/index.php/about/history"),
    "Operator documents its museum collections, changing exhibits and research library at 1616 Edith Street, matching both already clustered sources. Own elected volunteer board and nonprofit governance support independent local operation. Museum use under the society name is explicit; preserve it rather than excluding the institution merely because it also provides genealogy services.", "independent", "verified"),
  make_name("8400500285", urls("https://jacksonhistory.net/jchs-history/", "https://jacksonhistory.net/our-mission/", "https://www.irs.gov/pub/irs-soi/eo_ar.csv"),
    "Operator history documents transfer of Jacksonport courthouse to state control and majority artifact donation after the 1997 tornado. Current society publishes history and supports state-park staff, rather than operating a separate museum under this record. IRS EIN 716057799 and PO Box 430 match the IMLS society. Exclude this preservation/support society as not_museum; retain the separately operated Jacksonport courthouse museum. Ignore uncorroborated IMLS jchdonline.org website.", status = "verified", category = "not_museum"),
  make_name("8401900280", urls("https://www.irs.gov/pub/irs-soi/eo_ia.csv", county_ia),
    "IRS EIN 320335904 and PO Box 1065 identify Jackson County Genealogical Library. County recorder distinguishes this volunteer genealogy research chapter from the county historical museum at 1212 E Quarry. Exclude the library/research-only record as not_museum, retain parent museum separately, and do not infer identity from the shared IRS legal name.", status = "verified", category = "not_museum"),
  make_name("8402000064", urls("https://sites.google.com/site/jchsks/", "https://sites.google.com/site/jchsks/contact-us"),
    "Operator distinguishes Roebke House Museum at 216 New York and Jackson County Museum at 327 New York, with research house at 208. IMLS gives mailing 2116 New York. Generic society record cannot be assigned to one museum from common operation alone; current identity, preferred name and scope remain pending."),
  make_name("8402600479", "https://www.myjacksonhistorical.org/about",
    "Current website describes a society founded in 2020, after the IMLS 2018 snapshot. It does not establish the fate of the source legal organization EIN 381861466 at West Michigan Avenue. Keep pending; no museum exclusion or successor merge inferred."),
  make_name("8401300277", urls("https://www.jacksoncountygov.com/695/Historic-Archives", "https://www.prlib.org/commerce-public-library-heritage-room"),
    "County and library sources document society preservation and genealogy support. These do not fully resolve the current museum role of EIN 300387455/PO Box 1234 or historical exhibits at Crawford Long Museum. Keep pending; do not merge from older headquarters association."),
  make_name("8404000398", "https://www.sai.ok.gov/Search%20Reports/database/JacksonCoOp15WebFinal.pdf",
    "State audit distinguishes historical society and local museum organizations, but does not establish the museum role of EIN 731359340 at 20485 E County Road 168. Current identity, name and affiliation remain pending; no exclusion inferred from sparse records."),
  make_name("8401900706", "https://www.irs.gov/pub/irs-soi/eo_ia.csv",
    "IMLS identifies EIN 870791319 at 127 East Main, Spragueville. Current chapter identity and museum role remain unresolved. Other Jackson County Iowa organizations with the same legal name have distinct EINs. Absence from the current IRS file does not establish closure or not_museum; preserve pending.")
)
stopifnot(!any(new_names$source_id %in% names_before$source_id))
decisions <- dplyr::bind_rows(names_before, new_names)
after <- dn_museum_analysis(review$records, rules, decisions)
counts <- tibble::tibble(counted_source_records = sum(review$records$counted), counted_institutions = sum(after$counted),
  eligible = sum(after$analysis_eligible), identity_rows = nrow(identities), identity_cases = dplyr::n_distinct(identities$case_id),
  verified = sum(after$review_status == "verified"), jackson_nonchain = sum(after$analysis_eligible & after$name_expanded == "jackson county historical society" & !after$is_franchise %in% TRUE))
print(counts, width = Inf)
stopifnot(nrow(added) == 7L, nrow(new_names) == 11L, nrow(identities) == 121L,
  sum(after$counted) == 52563L, sum(after$analysis_eligible) == 52431L,
  sum(review$records$counted) == 57274L, counts$jackson_nonchain == 6L,
  sum(after$review_status == "verified") == 28L,
  identical(review$records[names(dn_schema_normalized())], baseline[names(dn_schema_normalized())]))
for (pair in list(c("jackson_applied_identity_decisions.csv", "added"), c("jackson_applied_name_decisions.csv", "new_names"),
                 c("jackson_identity_decisions_after.csv", "identities"), c("jackson_name_decisions_after.csv", "decisions"))) {
  readr::write_csv(get(pair[2]), file.path(packet, pair[1]), na = "")
}
readr::write_csv(review$audit, file.path(packet, "jackson_identity_audit.csv"), na = "")
readr::write_csv(dn_museum_ranking(after), file.path(packet, "jackson_ranking_after.csv"), na = "")
irs <- readr::read_csv("data/raw/county_greene_ia_irs_2026-09-26.csv", col_types = readr::cols(.default = "c"))
readr::write_csv(irs[irs$NAME == "JACKSON COUNTY HISTORICAL SOCIETY", ], file.path(packet, "irs_jackson_ia_selected.csv"))
irs_ar <- readr::read_csv("data/raw/irs_eo_ar_2026-09-15.csv", col_types = readr::cols(.default = "c"))
readr::write_csv(irs_ar[irs_ar$EIN == "716057799", ], file.path(packet, "irs_jackson_ar_selected.csv"))
readr::write_csv(identities, "data/validation/museum_identity_decisions.csv", na = "")
readr::write_csv(decisions, "data/validation/museum_decisions.csv", na = "")
message("Jackson sub-batch applied; publication readiness remains pending.")
