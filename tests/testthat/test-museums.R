museum_fixture <- function(names, ids = seq_along(names)) {
  out <- lapply(seq_along(names), function(i) {
    clean <- dn_name_clean(names[i])
    dplyr::add_row(dn_schema_entity(), source = "test", source_id = as.character(i),
      category = "museum", name_raw = names[i], primary_name = names[i],
      name_clean = clean, name_expanded = dn_name_expand(clean), name_core = clean,
      name_key = dn_name_key(clean), scope_claim = dn_parse_scope_claim(clean),
      entity_id = as.character(ids[i]), source_set = "test", n_sources = 1L,
      site_id = paste0("s", i), n_sites = 1L, is_primary_site = TRUE,
      counted = TRUE, is_franchise = NA, lon = -90, lat = 35,
      source_update_time = as.Date("2026-09-01"), confidence = 0.9, alt_names = "")
  })
  dplyr::bind_rows(out)
}

test_that("metrics count one canonical name per entity and obey counted flags", {
  x <- museum_fixture(c("County Historical Museum", "County Historical Society",
                        "County Historical Museum", "County Historical Museum"), c(1, 1, 2, 3))
  x$primary_name[2] <- x$primary_name[1]
  x$counted[4] <- FALSE
  x$exclusion_reason[4] <- "permanently_closed"
  result <- metric_duplicate_counts(x, levels = "name_expanded")
  expect_equal(result$name_value, "county historical museum")
  expect_equal(result$n_entities, 2L)
  expect_equal(metric_duplicate_counts(x[4:1, ], levels = "name_expanded"), result)
})

test_that("M2 uses L2 and keeps unknown affiliation separate from independence", {
  x <- museum_fixture(c("National Museum of Ohio", "National Museum of Maine",
                        "National Museum of Ohio", "National Museum of Ohio"))
  x$name_core <- "national museum"
  x$is_franchise <- c(FALSE, FALSE, NA, TRUE)
  result <- metric_singularity_collisions(x)
  expect_equal(result$name_expanded, "national museum of ohio")
  # The chain location is reported but is not a headline candidate.
  expect_equal(result$n_candidates, 2L)
  expect_equal(result$n_independent, 1L)
  expect_equal(result$n_affiliated, 1L)
  expect_equal(result$n_unknown, 1L)
})

test_that("headline counts separate chains, which are reported with their name overlaps", {
  x <- museum_fixture(c("Museum of Illusions", "Museum of Illusions", "Museum of Illusions Chicago",
                        "Museum of Illusions", "Play Street Museum", "Play Street Museum"))
  d <- tibble::tibble(source = "test", source_id = c("1", "2", "3", "5", "6"),
    expected_name = x$name_raw[c(1, 2, 3, 5, 6)], category_decision = "not_flagged",
    affiliation_status = "chain", chain_id = c("moi", "moi", "moi", "play", "play"),
    review_status = "verified", evidence_url = "https://example.org/locations",
    note = "Fixture network", reviewed_by = "Reviewer", reviewed_on = "2026-09-23")
  a <- dn_museum_analysis(x, decisions = d)
  ranking <- dn_museum_ranking(a)
  expect_equal(ranking$name_expanded, "museum of illusions")
  expect_equal(ranking$n_entities, 1L)
  expect_equal(ranking$n_chain, 2L)
  expect_false(ranking$publication_ready)
  chains <- dn_museum_chain_summary(a)
  expect_equal(chains$chain_id, c("moi", "play"))
  expect_equal(chains$n_locations, c(3L, 2L))
  expect_equal(chains$n_names, c(2L, 1L))
  overlap <- dn_museum_chain_overlap(a)
  expect_equal(overlap$name_expanded, "museum of illusions")
  expect_equal(c(overlap$n_chain, overlap$n_non_chain, overlap$n_affiliation_unknown), c(2L, 1L, 1L))
  dup <- metric_duplicate_counts(a, levels = "name_expanded", exclude_chains = TRUE)
  expect_equal(dup$n_entities[dup$name_value == "museum of illusions"], 1L)
  expect_false("play street museum" %in% dup$name_value)
  # A chain-only name is not a headline; the gate checks only non-chain institutions.
  expect_error(dn_assert_museum_publication_ready(a, "play street museum"), "completed identity")
  a$review_status[a$source_id == "4"] <- "verified"
  a$affiliation_status[a$source_id == "4"] <- "independent"
  expect_silent(dn_assert_museum_publication_ready(a, "museum of illusions"))
})

test_that("a sourced not-a-museum decision leaves the museum count but stays auditable", {
  x <- museum_fixture(c("Example County Historical Society", "Example County Historical Society"))
  d <- dplyr::add_row(dn_schema_museum_decisions(), source = "test", source_id = "1",
    expected_name = x$name_raw[1], category_decision = "not_museum", affiliation_status = "unknown",
    review_status = "verified", evidence_url = "https://example.org/about",
    note = "Operator describes an office and research library, not a museum",
    reviewed_by = "Reviewer", reviewed_on = "2026-09-23")
  a <- dn_museum_analysis(x, decisions = d)
  expect_equal(nrow(a), 2L)
  expect_equal(a$counted, c(FALSE, TRUE))
  expect_equal(a$exclusion_reason[1], "reviewed_not_museum")
  expect_equal(a$analysis_exclusion[1], "reviewed_not_museum")
  expect_equal(a$analysis_eligible, c(FALSE, TRUE))
  expect_equal(dn_museum_ranking(a)$n_entities, 1L)
  expect_equal(dn_museum_ranking(a, FALSE)$n_entities, 1L)
  # Only not_museum may complete a review with affiliation unknown.
  d$category_decision <- "not_flagged"
  expect_error(dn_museum_analysis(x, decisions = d), "Verified institution review")
  d$category_decision <- "not_a_category"
  expect_error(dn_museum_analysis(x, decisions = d), "valid statuses")
})

test_that("category flags hold ambiguous names for review without deleting them", {
  x <- museum_fixture(c("Art Gallery", "Maui Art Gallery", "Planetarium"))
  out <- dn_museum_analysis(x)
  expect_equal(nrow(out), 3L)
  expect_equal(out$analysis_eligible, c(FALSE, TRUE, FALSE))
  expect_true(all(out$counted))
  decisions <- dplyr::add_row(dn_schema_museum_decisions(), source = "test", source_id = "1",
    expected_name = "Art Gallery", category_decision = "confirmed_name",
    affiliation_status = "independent", review_status = "verified",
    evidence_url = "https://example.org/signage", note = "Fixture evidence",
    reviewed_by = "Independent reviewer", reviewed_on = "2026-09-15")
  reviewed <- dn_museum_analysis(x, decisions = decisions)
  expect_true(reviewed$analysis_eligible[1])
  expect_false(reviewed$is_franchise[1])
  decisions$expected_name <- "Something else"
  expect_error(dn_museum_analysis(x, decisions = decisions), "Stale museum decision")
})

test_that("confirmed placeholders stay auditable and decisions cannot silently conflict", {
  x <- museum_fixture("Gallery")
  d <- dplyr::add_row(dn_schema_museum_decisions(), source = "test", source_id = "1",
    expected_name = "Gallery", category_decision = "placeholder", affiliation_status = "unknown",
    review_status = "pending", evidence_url = "https://example.org/name",
    note = "Fixture placeholder", reviewed_by = "Reviewer", reviewed_on = "2026-09-15")
  out <- dn_museum_analysis(x, decisions = d)
  expect_equal(out$analysis_exclusion, "confirmed_placeholder")
  expect_equal(out$name_raw, "Gallery")
  expect_error(dn_museum_analysis(x, decisions = dplyr::bind_rows(d, d)), "Multiple decisions")
})

test_that("historical names stay auditable without becoming current name collisions", {
  x <- museum_fixture(c("University Art Gallery", "University Art Gallery"))
  d <- tibble::tibble(source = "test", source_id = c("1", "2"),
    expected_name = "University Art Gallery", category_decision = c("historical_name", "confirmed_name"),
    affiliation_status = "unknown", chain_id = NA_character_, review_status = "pending",
    evidence_url = "https://example.org/history", note = "Source check only",
    reviewed_by = "Codex source review", reviewed_on = "2026-09-15")
  a <- dn_museum_analysis(x, decisions = d)
  expect_true(all(a$counted))
  expect_equal(a$entity_id, x$entity_id)
  expect_equal(a$analysis_exclusion, c("historical_name", NA_character_))
  expect_equal(a$analysis_eligible, c(FALSE, TRUE))
  expect_equal(dn_museum_ranking(a)$n_entities, 1L)
  expect_equal(dn_museum_ranking(a, FALSE)$n_entities, 2L)
  expect_error(dn_assert_museum_publication_ready(a, a$name_expanded), "completed identity")
})

test_that("location-specific affiliation does not spread to unrelated same-name entities", {
  x <- museum_fixture(rep("Museum of Illusions", 2))
  d <- dplyr::add_row(dn_schema_museum_decisions(), source = "test", source_id = "1",
    expected_name = "Museum of Illusions", category_decision = "not_flagged",
    affiliation_status = "chain", chain_id = "example_network", review_status = "pending",
    evidence_url = "https://example.org/locations", note = "Only this location was checked",
    reviewed_by = "Codex source review", reviewed_on = "2026-09-15")
  a <- dn_museum_analysis(x, decisions = d)
  expect_equal(a$is_franchise, c(TRUE, NA))
  expect_equal(dn_museum_ranking(a)$n_chain, 1L)
  expect_equal(dn_museum_ranking(a)$n_affiliation_unknown, 1L)
  expect_false(dn_museum_ranking(a)$publication_ready)
})

test_that("operator presence and productive templates do not establish chains", {
  x <- museum_fixture(c("Union County Historical Society", "Children's Museum of Springfield",
                        "Example Brand Museum", "Example Brand Museum Annex"), c(1, 2, 3, 3))
  x$operator <- c("County Society", "Children's Museum", "Verified Brand", NA)
  out <- dn_flag_franchises(x)
  expect_true(all(is.na(out$is_franchise)))
  rules <- dplyr::add_row(dn_schema_chain_rules(), rule_id = "example", chain_id = "brand",
    match_on = "operator", pattern = "^verified brand$", evidence_url = "https://example.org/network",
    evidence_note = "Fixture", reviewed_by = "Reviewer", reviewed_on = "2026-09-15")
  out <- dn_flag_franchises(x, rules)
  expect_equal(out$is_franchise, c(NA, NA, TRUE, TRUE))
  expect_equal(dn_naming_template(x$name_expanded)[1:2], c("county_historical", "children_of_place"))
  rules$match_on <- "candidate"
  rules$pattern <- "^example brand"
  expect_true(all(is.na(dn_flag_franchises(x, rules)$is_franchise)))
})

test_that("subjects are explicit topics with unknowns and multiple topics retained", {
  expect_equal(dn_extract_subject(c("international cryptozoology museum", "museum of natural history",
    "children's museum", "fire museum", "railroad museum", "quilt museum", "barbed wire museum",
    "arts and science center", "imagination station", NA_character_)),
    c("cryptozoology", "natural_history", "children", "fire", "railroad", "quilts",
      "barbed_wire", "art|science", NA, NA))
  expect_true(is.na(dn_extract_subject("art church", "place_of_worship")))
  expect_equal(dn_subject_check(c("art", "children", "history", "fire", NA, "art"),
    c("ART", "HST", "GMU", "HST", "SCI", NA)),
    c("compatible", "review", "not_comparable", "not_comparable", "no_name_subject", "no_imls"))
})

test_that("review sheets retain all cutoff ties and excluded multi-site records", {
  x <- museum_fixture(c("Alpha Museum", "Beta Museum", "Gamma Museum", "Former Alpha Museum"), c(1, 2, 3, 1))
  x$primary_name[4] <- "Alpha Museum"
  x$n_sites[c(1, 4)] <- 2L
  x$is_primary_site[4] <- FALSE
  x$counted[4] <- FALSE
  x$exclusion_reason[4] <- "non_primary_site"
  a <- dn_museum_analysis(x)
  sheets <- dn_museum_review_sheets(a, x, dn_museum_ranking(a), n = 2L)
  expect_equal(nrow(sheets$institutions), 3L)
  expect_equal(nrow(sheets$source_records), 4L)
  expect_true("Former Alpha Museum" %in% sheets$multisite_records$name_raw)
})

test_that("IMLS dossier summaries preserve source membership and both address types", {
  x <- museum_fixture(c("Example Museum", "Example Museum", "Other Museum"), c(1, 1, 2))
  x$source[1:2] <- "imls"
  x$counted[2] <- FALSE
  x$exclusion_reason[2] <- "reviewed_duplicate_record"
  x$n_sites[1:2] <- 2L
  context <- dplyr::add_row(dn_schema_imls_context(), source = "imls", source_id = "1",
    imls_ein = "012345678", imls_physical_city = "Physical town",
    imls_mailing_city = "Mail town", imls_physical_address = "1 Main St, Physical town",
    imls_mailing_address = "PO Box 1, Mail town") |>
    dplyr::add_row(source = "imls", source_id = "2", imls_ein = "098765432",
      imls_mailing_address = "PO Box 2, Other town")
  a <- dn_museum_analysis(x)
  sheets <- dn_museum_review_sheets(a, x, dn_museum_ranking(a), imls_context = context)
  institution <- sheets$institutions[sheets$institutions$entity_id == "1", ]
  expect_equal(institution$imls_ein_2018, "1: 012345678 | 2: 098765432")
  expect_equal(institution$imls_physical_address_2018, "1: 1 Main St, Physical town")
  expect_equal(institution$imls_mailing_address_2018,
    "1: PO Box 1, Mail town | 2: PO Box 2, Other town")
  expect_true(is.na(sheets$institutions$imls_ein_2018[sheets$institutions$entity_id == "2"]))
  expect_equal(nrow(sheets$source_records), nrow(x))
  expect_equal(sheets$source_records$counted, x$counted)
  expect_equal(sheets$multisite_records$imls_ein, c("012345678", "098765432"))
  expect_true(all(names(context) %in% names(sheets$source_records)))
})

test_that("Phase 2 empty stages conform to their contracts", {
  expect_silent(dn_validate(dn_flag_franchises(dn_schema_entity()), dn_schema_entity()))
  a <- dn_museum_analysis(dn_schema_entity())
  expect_silent(dn_validate(a, dn_schema_museum_analysis()))
  expect_equal(nrow(metric_singularity_collisions(a)), 0L)
  expect_equal(nrow(dn_museum_ranking(a)), 0L)
  expect_equal(nrow(metric_museum_subjects(a)), 0L)
})

test_that("publication cannot use a provisional ranking or unsourced decisions", {
  x <- museum_fixture("Museum of Examples")
  a <- dn_museum_analysis(x)
  expect_error(dn_assert_museum_publication_ready(a, a$name_expanded), "completed identity")
  expect_error(dn_assert_museum_publication_ready(a, "absent museum"), "completed identity")
  a$review_status <- "verified"
  a$affiliation_status <- "independent"
  expect_silent(dn_assert_museum_publication_ready(a, a$name_expanded))
})

test_that("nearby review pairs use distances without assigning matching labels", {
  x <- museum_fixture(rep("Example Museum", 3))
  x$lon <- c(-90, -90.01, -100)
  pairs <- dn_museum_nearby_pairs(x)
  expect_equal(nrow(pairs), 1L)
  expect_equal(pairs$entity_a, "1")
  expect_equal(pairs$entity_b, "2")
  expect_gt(pairs$distance_km, 0.8)
  expect_lt(pairs$distance_km, 1.0)
  expect_true(is.na(pairs$same_institution))
})
