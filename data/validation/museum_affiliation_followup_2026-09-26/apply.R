# Supported affiliation and identity changes; unresolved parent-label rows stay pending.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
p <- "data/validation/museum_affiliation_followup_2026-09-26"
stopifnot(!file.exists(file.path(p, "museum_decisions_after.csv")))
before <- readRDS("data/processed/affiliation_followup_before.rds")
e <- targets::tar_read(entities)
stopifnot(identical(e, before$entities))
ids <- dn_read_museum_review(file.path(p, "museum_identity_decisions_before.csv"), dn_schema_museum_identity_decisions())
d <- dn_read_museum_review(file.path(p, "museum_decisions_before.csv"), dn_schema_museum_decisions())
o <- dn_read_museum_review(file.path(p, "museum_name_overrides_before.csv"), dn_schema_museum_name_overrides())
rules <- dn_read_museum_review(file.path(p, "museum_chain_rules_before.csv"), dn_schema_chain_rules())
stopifnot(identical(d, dn_read_museum_review("data/validation/museum_decisions.csv", dn_schema_museum_decisions())))
vegas_url <- "https://lasvegas-support.madametussauds.com/hc/en-us/articles/115002250572-What-is-your-address | https://www.madametussauds.com/las-vegas/ | https://www.madametussauds.com/"
vegas_note <- "Official operator lists Madame Tussauds Las Vegas at 3377 S Las Vegas Blvd Suite 2001, matching IMLS physical address; the nearby Overture wax-museum record links the same Las Vegas operator site. These two separately counted records describe one attraction. Keep both source points and aliases; precise publication point still needs checking. Record brand affiliation and the current public name, not an independent naming collision."
keys <- c("1efb0840-65fe-4aba-800d-11a5af9adc7f", "8409401138")
x <- e[match(keys, e$source_id), ]
added_ids <- tibble::tibble(case_id = "Affiliation_Las_Vegas_Tussauds", source = x$source, source_id = x$source_id,
  expected_name = x$name_raw, expected_entity_id = x$entity_id, expected_coordinates = dn_identity_coordinates(x),
  role = c("canonical", "same_site"), site_group = "las_vegas_attraction", evidence_url = vegas_url, evidence_note = vegas_note,
  reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
ids <- dplyr::bind_rows(ids, added_ids)
r <- dn_reconcile_museums(e, ids)
make_decision <- function(key, url, note, category = "not_flagged", affiliation = "chain", chain = "smithsonian_institution", status = "pending") {
  row <- e[match(key, e$source_id), ]; stopifnot(!is.na(row$source_id))
  tibble::tibble(source = row$source, source_id = key, expected_name = row$name_raw, category_decision = category,
    affiliation_status = affiliation, chain_id = chain, review_status = status, evidence_url = url, note = note,
    reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
}
si_url <- "https://www.si.edu/visit/museums"
parent_note <- "Official Smithsonian directory establishes common operation of the named Smithsonian museums, separately from the independently governed Affiliates program. This parent-label source has a corresponding museum address/domain in saved Overture context. Brand/parent affiliation is established; exact institution membership, public name and conflicting source points still need reconciliation, so overall review remains pending. No blanket Smithsonian-prefix rule applied to affiliates, traveling exhibits or unrelated names."
si_keys <- c("42bf97d5-2d95-4162-8347-3101c836b23b", "62556f95-6f92-49ec-81f1-a2f777bad70e", "51f834d9-d695-44b2-a3f7-1f5a446eda8d", "372b1e05-9dac-4305-9016-c7e649dd58de", "d77f645c-01ad-46a7-83a1-aa0fe1d1e0a2")
new_d <- dplyr::bind_rows(lapply(si_keys, function(key) make_decision(key, si_url, parent_note)))
office_url <- "https://www.aaa.si.edu/sites/default/files/Documents/2023-Annual-Report.pdf | https://www.aaa.si.edu/news/new-york-research-center-moving.html"
office_note <- "Archives of American Art's own 2023 annual report explicitly distinguishes OFFICES at 750 9th Street NW in Washington and 300 Park Avenue South in New York from its exhibition gallery at 8th and F Streets in Washington. The New York relocation announcement describes research services. Saved source addresses match these office/research sites; IMLS 8401100067 supplies only the Washington mailing address. These records are not additional visitor museums. Do not merge them into the separate exhibition gallery or use absence from a directory as exclusion evidence."
new_d <- dplyr::bind_rows(new_d,
  make_decision("114f3684-06e7-4d5d-9af4-0569753b8336", office_url, office_note, category = "not_museum", status = "verified"),
  make_decision("3a320a08-4e22-4bb9-a8b7-0145f4ec081c", office_url, office_note, category = "not_museum", status = "verified"),
  make_decision(keys[1], vegas_url, vegas_note, chain = "madame_tussauds", status = "verified"))
d <- dplyr::bind_rows(d[!d$source_id %in% new_d$source_id, ], new_d)
anchor <- r$records[match(keys[1], r$records$source_id), ]
new_o <- tibble::tibble(source = anchor$source, source_id = anchor$source_id, expected_name = anchor$name_raw,
  expected_entity_id = anchor$entity_id, preferred_name = "Madame Tussauds Las Vegas", evidence_url = vegas_url,
  evidence_note = vegas_note, reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
o <- dplyr::bind_rows(o, new_o)
a <- dn_museum_analysis(r$records, rules, d, o, targets::tar_read(gazetteer))
counts <- tibble::tibble(counted_source = sum(r$records$counted), counted_institutions = sum(a$counted), eligible = sum(a$analysis_eligible), verified = sum(a$review_status == "verified"), identity_rows = nrow(ids), identity_cases = dplyr::n_distinct(ids$case_id), not_museum = sum(a$category_decision == "not_museum"))
print(counts, width = Inf)
stopifnot(counts$counted_source == 57272L, counts$counted_institutions == 52557L, counts$eligible == 52425L, counts$verified == 39L, counts$identity_rows == 125L)
for (pair in list(c("museum_identity_decisions", "ids"), c("museum_decisions", "d"), c("museum_name_overrides", "o"))) {
  readr::write_csv(get(pair[2]), file.path(p, paste0(pair[1], "_after.csv")), na = "")
  readr::write_csv(get(pair[2]), paste0("data/validation/", pair[1], ".csv"), na = "")
}
readr::write_csv(new_d, file.path(p, "applied_decisions.csv"), na = "")
readr::write_csv(added_ids, file.path(p, "applied_identity.csv"), na = "")
readr::write_csv(new_o, file.path(p, "applied_name_override.csv"), na = "")
readr::write_csv(counts, file.path(p, "counts_after.csv"))
readr::write_csv(dn_museum_ranking(a), file.path(p, "ranking_after.csv"))
readr::write_csv(a[a$name_raw == "Smithsonian Institution", ], file.path(p, "smithsonian_after.csv"), na = "")
message("Supported changes applied; remaining Smithsonian identity/name questions are not complete.")
