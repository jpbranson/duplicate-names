# One-time supported Old Jail decisions, with remaining gaps kept pending.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_jail_followup_2026-09-26"
stopifnot(!file.exists(file.path(packet, "name_decisions_after.csv")))
before <- readRDS("data/processed/jail_followup_before.rds")
baseline <- targets::tar_read(entities)
ids <- dn_read_museum_review("data/validation/museum_identity_decisions.csv", dn_schema_museum_identity_decisions())
decisions <- dn_read_museum_review("data/validation/museum_decisions.csv", dn_schema_museum_decisions())
rules <- dn_read_museum_review("data/validation/museum_chain_rules.csv", dn_schema_chain_rules())
overrides <- dn_read_museum_review("data/validation/museum_name_overrides.csv", dn_schema_museum_name_overrides())
stopifnot(nrow(overrides) == 0L, identical(baseline, before$entities),
  identical(ids, dn_read_museum_review(file.path(packet, "identity_decisions_before.csv"), dn_schema_museum_identity_decisions())),
  identical(decisions, dn_read_museum_review(file.path(packet, "name_decisions_before.csv"), dn_schema_museum_decisions())))
readr::write_csv(overrides, file.path(packet, "name_overrides_before.csv"))
urls <- function(...) paste(c(...), collapse = " | ")
barnesville_url <- urls("https://www.blchs.com/", "https://ecorp.sos.ga.gov/BusinessSearch/DownloadFile?filingNo=16843804")
barnesville_note <- paste("Operator distinguishes Old Jail Museum at 326 Thomaston from its Graveyard Alley Archives/research office at 110-C Merchants Way.",
  "Georgia's 2019 corporate filing identifies IMLS's 858 Thomaston address as principal office and registered-agent/CFO address, not another visitor museum.",
  "Reconcile the society's administrative/mailing record with its current archives, exclude that non-museum institution, and keep the separately named jail museum.",
  "The nonprofit's local officers are documented by the filing and its current site identifies the society as operator. A research archive is not a second museum branch.")
keys <- c("c22b0c13-6dd7-472c-9000-c32a0a87e095", "8401300390")
x <- baseline[match(keys, baseline$source_id), ]
added_ids <- tibble::tibble(case_id = "Jail_followup_Barnesville_archives", source = x$source,
  source_id = x$source_id, expected_name = x$name_raw, expected_entity_id = x$entity_id,
  expected_coordinates = dn_identity_coordinates(x), role = c("canonical", "mailing_address"),
  site_group = "barnesville_archives", evidence_url = barnesville_url, evidence_note = barnesville_note,
  reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
ids <- dplyr::bind_rows(ids, added_ids)
review <- dn_reconcile_museums(baseline, ids)
make_name <- function(key, url, note, affiliation = "unknown", status = "pending", category = "not_flagged", chain = NA_character_) {
  x <- baseline[match(key, baseline$source_id), ]
  stopifnot(!is.na(x$source_id))
  tibble::tibble(source = x$source, source_id = key, expected_name = x$name_raw,
    category_decision = category, affiliation_status = affiliation, chain_id = chain,
    review_status = status, evidence_url = url, note = note,
    reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
}
allegan_url <- urls("https://alleganoldjailmuseum.com/", "https://alleganoldjailmuseum.com/about/", "https://alleganoldjailmuseum.com/the-village/")
allegan_note <- paste("The local society's own board operates two distinct visitor institutions: Old Jail Museum at 113 N Walnut and John Pahl Historical Village at the fairgrounds.",
  "The village's historical buildings open during the county fair and Michigan Fiber Festival. This establishes common museum operation, despite a locally independent nonprofit board.",
  "Keep separate entities and assign the same sourced affiliation; do not merge their collections or count the village's 18 buildings as 18 institutions.")
sandersville_url <- urls("https://wacohistorical.org/about-us/", "https://wacohistorical.org/genealogy/")
sandersville_note <- paste("Society explicitly states its elected board oversees the Old Jail/Genealogy Research Center at 129 Jones and Brown House Museum at 268 N Harris.",
  "Old Jail retains museum tours, cells and artifacts; archive services do not remove its museum role. Both visitor institutions share a local operator and receive the same affiliation while remaining separate.")
chambersburg_url <- "https://www.franklinhistorical.org/"
chambersburg_note <- paste("Operator explicitly offers tours of Old Jail and John Brown House museums, at separate visitor sites.",
  "Correct the prior independent flag to common-operator affiliation: the society has its own local board but these museums are not independent of each other.",
  "Keep the reviewed Old Jail identity and separate John Brown institution; no ownership inferred from a repeated name.")
smethport_url <- urls("https://www.mchsmuseum.org/", "https://www.mchsmuseum.org/museum-info")
smethport_note <- paste("Current operator homepage prominently names The County Museum in The Old Jail. Apply that preferred name in the separate override input, retaining Old Jail Museum as source name/alias.",
  "Existing identity at 502 W King and separate mailing address 500 W Main is unchanged. Own nine-director/four-officer nonprofit governance and museum operations are explicit.",
  "Courthouse display cases and a temporary county-fair display are outreach, not additional museum branches. Museum access is seasonal; published hours require a dated recheck.")
hta_url <- urls("https://www.historictours.com/st-augustine", "https://www.staugustineoldjail.com/")
new_names <- dplyr::bind_rows(
  make_name("f58c3429-be3f-40c5-8c6a-fdd0b2327aa3", allegan_url, allegan_note, "chain", "verified", chain = "allegan_county_historical_society"),
  make_name("170d0c1d-d5dc-4253-a7cd-82d8e973a35c", allegan_url, paste(allegan_note, "Village's complete source-level identity/name review remains pending."), "chain", chain = "allegan_county_historical_society"),
  make_name("b21c579d-6e19-4e64-83d4-051f763f8e05", sandersville_url, sandersville_note, "chain", "verified", chain = "washington_county_ga_historical_society"),
  make_name("d959641b-361a-4a3c-8608-ac664bbff0e2", sandersville_url, paste(sandersville_note, "Brown House's complete review remains pending."), "chain", chain = "washington_county_ga_historical_society"),
  make_name("0d75bfd8-a6a7-4bcd-b4b8-fa824929726f", chambersburg_url, chambersburg_note, "chain", "verified", chain = "franklin_county_pa_historical_society"),
  make_name("1fe73458-f3c7-4a04-9128-2a333ff0858a", chambersburg_url, paste(chambersburg_note, "John Brown House's full review remains pending."), "chain", chain = "franklin_county_pa_historical_society"),
  make_name("bd9c1f07-e7c7-493a-9471-a98499e86838", smethport_url, smethport_note, "independent", "verified"),
  make_name("32cfb026-f4db-4a5d-b3cb-ee80f1552029", urls("https://lawrencecountytn.gov/county-services/get-involved/", "https://lawrencecountytn.gov/visitors/attractions/", "http://home.lorettotel.net/~lcarchives/lchistsoc.htm"),
    "Current county government links the local society's operator page, last updated February 2024. It identifies Old Jail on Waterloo Street, names its officers and directors, explains membership/donation funding and limited county/city support, and documents museum exhibits. This establishes local independent governance and museum role, not a branch of the unrelated cellblock7.org listed in Overture. Source website defect retained. Use Waterloo address; precise visitor map point still needs publication checking.", "independent", "verified"),
  make_name("b8639a00-9b98-4ccb-a3e1-c6ca9b06162a", barnesville_url, barnesville_note, "independent", "verified"),
  make_name("c22b0c13-6dd7-472c-9000-c32a0a87e095", barnesville_url, barnesville_note, status = "verified", category = "not_museum"),
  make_name("9715e25c-8c45-4e06-ba1a-0093b1a08a53", hta_url,
    "Operator portfolio explicitly names Old Jail Museum among distinct ticketed attractions, matching the museum's own site and 167 San Marco Avenue. Name, museum role, identity and Historic Tours of America affiliation are verified. Preserve nearby Oldest Store and St Augustine History Museum separately; exclude generic operator listing as not an additional museum. Daily tours advertised with holiday exceptions; recheck before publication.", "chain", "verified", chain = "historic_tours_of_america"),
  make_name("0b67fafb-eb60-4bbd-abe2-b3b8baac8c71", hta_url,
    "Generic Historic Tours Of America record at 167 San Marco denotes the tour operator/campus. Its own portfolio separately identifies and tickets Old Jail, Oldest Store and St Augustine History Museum, all represented independently. This umbrella/operator row is not an additional museum; exclude as not_museum without merging the named attractions or assigning the umbrella alias to one of them.", status = "verified", category = "not_museum")
)
decisions <- dplyr::bind_rows(decisions[!decisions$source_id %in% new_names$source_id, ], new_names)
anchor <- review$records[review$records$source_id == "bd9c1f07-e7c7-493a-9471-a98499e86838", ]
overrides <- tibble::tibble(source = anchor$source, source_id = anchor$source_id, expected_name = anchor$name_raw,
  expected_entity_id = anchor$entity_id, preferred_name = "The County Museum in The Old Jail", evidence_url = smethport_url,
  evidence_note = smethport_note, reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
after <- dn_museum_analysis(review$records, rules, decisions, overrides, targets::tar_read(gazetteer))
counts <- tibble::tibble(source_records = nrow(review$records), counted_source = sum(review$records$counted),
  counted_institutions = sum(after$counted), eligible = sum(after$analysis_eligible), verified = sum(after$review_status == "verified"),
  old_jail_nonchain = sum(after$analysis_eligible & after$name_expanded == "old jail museum" & after$affiliation_status != "chain"))
print(counts, width = Inf)
stopifnot(sum(after$counted) == 52560L, sum(after$analysis_eligible) == 52428L,
  sum(review$records$counted) == 57273L, nrow(ids) == 123L, counts$old_jail_nonchain == 8L,
  sum(after$review_status == "verified") == 36L)
for (pair in list(c("applied_identity_decisions.csv", "added_ids"), c("applied_name_decisions.csv", "new_names"),
  c("identity_decisions_after.csv", "ids"), c("name_decisions_after.csv", "decisions"), c("name_overrides_after.csv", "overrides"))) {
  readr::write_csv(get(pair[2]), file.path(packet, pair[1]), na = "")
}
readr::write_csv(counts, file.path(packet, "counts_after.csv"))
readr::write_csv(dn_museum_ranking(after), file.path(packet, "ranking_after.csv"))
readr::write_csv(review$audit, file.path(packet, "identity_audit_after.csv"), na = "")
readr::write_csv(ids, "data/validation/museum_identity_decisions.csv", na = "")
readr::write_csv(decisions, "data/validation/museum_decisions.csv", na = "")
readr::write_csv(overrides, "data/validation/museum_name_overrides.csv", na = "")
message("Supported Old Jail follow-up applied; eight non-chain Old Jail institutions remain, with unfinished reviews.")
