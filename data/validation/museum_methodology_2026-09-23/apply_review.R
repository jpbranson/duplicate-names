# One-time application: Museum of Illusions city-suffixed network locations and the
# first sourced not-a-museum decisions. Run after prepare.R.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_methodology_2026-09-23"
stopifnot(!file.exists(file.path(packet, "identity_decisions_after.csv")))
before <- readRDS("data/processed/methodology_review_before.rds")
baseline <- before$entities
ids_before <- dn_read_museum_review(file.path(packet, "identity_decisions_before.csv"),
                                   dn_schema_museum_identity_decisions())
names_before <- dn_read_museum_review(file.path(packet, "name_decisions_before.csv"),
                                     dn_schema_museum_decisions())
rules <- dn_read_museum_review(file.path(packet, "chain_rules.csv"), dn_schema_chain_rules())
review_date <- "2026-09-23"
reviewer <- "Claude source review"
directory <- "https://www.museumofillusions.com/our-locations/"
match <- readr::read_csv(file.path(packet, "moi_directory_match.csv"), show_col_types = FALSE)
stopifnot(nrow(match) == 15L)

# Atlanta: two Overture records share 264 19th St NW and moiatlanta.com.
atlanta_note <- paste("Official directory lists Museum of Illusions Atlanta at 264 19th St NW; both Overture records give that street and moiatlanta.com.",
  "The canonical record is 27 m from the directory map point; the other is 458 m away and is a displaced duplicate listing.",
  "Count one network location.")
x <- baseline[match(c("ab8a0237-3bad-40ab-a04c-742a2662bcce", "3e303d66-b7db-4c79-8c1d-9091ffcff3a3"), baseline$source_id), ]
added <- tibble::tibble(case_id = "Methodology_MOI_Atlanta", source = x$source, source_id = x$source_id,
  expected_name = x$name_raw, expected_entity_id = x$entity_id,
  expected_coordinates = dn_identity_coordinates(x), role = c("canonical", "mislocated"),
  site_group = "atlanta", evidence_url = directory, evidence_note = atlanta_note,
  reviewed_by = reviewer, reviewed_on = review_date)
identities <- dplyr::bind_rows(ids_before, added)
review <- dn_reconcile_museums(baseline, identities)

make_name <- function(source_id, url, note, category = "not_flagged", affiliation = "unknown",
                      status = "pending", chain_id = NA_character_) {
  x <- baseline[match(source_id, baseline$source_id), ]
  stopifnot(!is.na(x$source_id))
  tibble::tibble(source = x$source, source_id = source_id, expected_name = x$name_raw,
    category_decision = category, affiliation_status = affiliation, chain_id = chain_id,
    review_status = status, evidence_url = url, note = note,
    reviewed_by = reviewer, reviewed_on = review_date)
}
# Fourteen city-suffixed locations (Atlanta once). Affiliation only: the individual
# location sites were not opened, so overall review stays pending.
locations <- match[match$source_id != "3e303d66-b7db-4c79-8c1d-9091ffcff3a3", ]
moi_names <- dplyr::bind_rows(lapply(seq_len(nrow(locations)), function(i) {
  m <- locations[i, ]
  offset <- if (m$distance_m > 100) {
    sprintf("The source point is %.0f m from the directory point, but its source address matches the directory address.", m$distance_m)
  } else sprintf("The source point is %.0f m from the directory map point.", m$distance_m)
  note <- paste0("Official global directory lists '", sub(" United States$", "", m$directory_label),
    "' among open US museums. ", offset,
    " Brand affiliation only: the city-suffixed name places this location in a separate L2 name group; location access was not checked.")
  if (m$source_id == "ab8a0237-3bad-40ab-a04c-742a2662bcce") note <- paste(note, atlanta_note)
  make_name(m$source_id, directory, note, affiliation = "chain", chain_id = "museum_of_illusions_global")
}))
not_museum <- dplyr::bind_rows(
  make_name("613a19b3-8df1-4fde-bac2-ed689e93d4ce",
    "https://wchs-ny.org/the-wing-northup-house/ | https://wchs-ny.org/heritage-research-library/",
    paste("Operator: the Wing-Northup House at 167 Broadway is 'the home of the Washington County Historical Society'; 'Our research facilities are open on Tuesdays and Wednesdays'.",
      "The society presents it as headquarters, research library and bookshop, with no exhibits or museum visits described. The NRHP-listed building is not itself presented as a house museum.",
      "The IMLS row is its mailing record. Old Fort House Museum (separate association) remains counted."),
    category = "not_museum", status = "verified"),
  make_name("8404900183",
    "https://wchsutah.org/wchs/about-wchs.php | https://wchsutah.org/buildings/old-county-courthouse9.php",
    paste("Operator: 'WCHS exists to encourage and assist all interested Washington County communities with the organization of their city historical societies'; its address is PO Box 404.",
      "It co-manages the Pioneer Courthouse with the City of St. George and three other groups, but that jointly managed site is not this record; the IMLS point is a PO-box geocode.",
      "The society record describes an umbrella/research organization, not a museum."),
    category = "not_museum", status = "verified"),
  make_name("f874863e-866e-49e1-9dca-17b4211ad14e",
    "https://www.wchshistory.org/visit-the-archives | https://www.wchshistory.org/visit-the-fearing-house",
    paste("Operator: 346 Muskingum Drive is 'The Archives of the Washington County Historical Society of Ohio', a research room open two days a week.",
      "The society's museums are separately named and already counted: The Henry Fearing House Museum and The Anchorage.",
      "The archives record, with its IMLS mailing row, is not an additional museum."),
    category = "not_museum", status = "verified")
)
new_names <- dplyr::bind_rows(moi_names, not_museum)
replaced <- names_before$source_id %in% new_names$source_id
stopifnot(sum(replaced) == 3L, nrow(moi_names) == 14L)
decisions <- dplyr::bind_rows(names_before[!replaced, ], new_names)
after <- dn_museum_analysis(review$records, rules, decisions)
n_name <- function(x, nm) sum(x$analysis_eligible & x$name_expanded == nm & x$affiliation_status != "chain", na.rm = TRUE)
chains <- dn_museum_chain_summary(after)
stopifnot(sum(after$counted) == sum(before$analysis$counted) - 4L,
  n_name(after, "washington county historical society") == 4L,
  chains$n_locations[chains$chain_id == "museum_of_illusions_global"] == 25L,
  sum(after$exclusion_reason == "reviewed_not_museum", na.rm = TRUE) == 3L,
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
readr::write_csv(chains, file.path(packet, "chain_summary_after.csv"), na = "")
readr::write_csv(dn_museum_chain_overlap(after), file.path(packet, "chain_overlap_after.csv"), na = "")
print(ranking[1:8, c("rank", "name_expanded", "n_entities", "n_chain")])
print(chains)
print(dn_museum_chain_overlap(after), width = Inf)
