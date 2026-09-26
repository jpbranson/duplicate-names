museum_name_fixture <- function() {
  labels <- c("Current Museum", "Former Museum", "Museum Mailing Record", "Other Museum")
  dplyr::bind_rows(lapply(seq_along(labels), function(i) {
    clean <- dn_name_clean(labels[i])
    dplyr::add_row(dn_schema_entity(), source = "test", source_id = as.character(i),
      category = "museum", name_raw = labels[i], primary_name = labels[i], alt_names = "",
      name_clean = clean, name_expanded = clean, name_core = clean, name_key = dn_name_key(clean),
      lon = -90 + i, lat = 35, entity_id = paste0("e", i), site_id = paste0("s", i),
      n_sources = 1L, source_set = "test", n_sites = 1L, is_primary_site = TRUE,
      counted = TRUE, is_franchise = NA, confidence = 0.9, source_update_time = as.Date("2026-09-01"))
  }))
}

test_that("preferred names change analysis metrics without rewriting source evidence", {
  x <- museum_name_fixture()
  d <- tibble::tibble(source = "test", source_id = "1", expected_name = "Current Museum",
    expected_entity_id = "e1", preferred_name = "The National Museum of Ohio",
    evidence_url = "https://example.org/museum", evidence_note = "Fixture public name",
    reviewed_by = "Reviewer", reviewed_on = "2026-09-26")
  g <- tibble::tibble(name_norm = "ohio")
  a <- dn_museum_analysis(x, name_overrides = d, gazetteer = g)
  expect_identical(a$name_raw, x$name_raw)
  expect_identical(a$lon, x$lon)
  expect_identical(a$source_primary_name, x$primary_name)
  expect_equal(a$primary_name[1], "The National Museum of Ohio")
  expect_equal(a$name_expanded[1], "national museum of ohio")
  expect_equal(a$name_core[1], "national museum")
  expect_equal(a$scope_claim[1], "National")
  expect_equal(a$alt_names[1], "Current Museum")
  expect_equal(a$name_override_evidence[1], d$evidence_url)
  expect_equal(a$review_status[1], "pending")
  expect_false("current museum" %in% dn_museum_ranking(a)$name_expanded)
  expect_true("national museum of ohio" %in% dn_museum_ranking(a)$name_expanded)
  expect_error(dn_assert_museum_publication_ready(a, "national museum of ohio"), "completed identity")
  expect_identical(dn_museum_analysis(x)$name_expanded, x$name_expanded)
})

test_that("preferred name decisions reject stale, duplicate and unsupported inputs", {
  x <- museum_name_fixture()
  d <- tibble::tibble(source = "test", source_id = "1", expected_name = "Current Museum",
    expected_entity_id = "e1", preferred_name = "New Museum", evidence_url = "https://example.org/name",
    evidence_note = "Fixture", reviewed_by = "Reviewer", reviewed_on = "2026-09-26")
  g <- tibble::tibble(name_norm = character())
  expect_error(dn_museum_analysis(x, name_overrides = d), "gazetteer")
  bad <- d; bad$expected_entity_id <- "old_id"
  expect_error(dn_museum_analysis(x, name_overrides = bad, gazetteer = g), "Stale")
  bad <- d; bad$expected_name <- "Incorrect source name"
  expect_error(dn_museum_analysis(x, name_overrides = bad, gazetteer = g), "Stale")
  bad <- d; bad$source_id <- "missing"
  expect_error(dn_museum_analysis(x, name_overrides = bad, gazetteer = g), "Stale")
  expect_error(dn_museum_analysis(x, name_overrides = dplyr::bind_rows(d, d), gazetteer = g), "Multiple")
  bad <- d; bad$evidence_url <- ""
  expect_error(dn_museum_analysis(x, name_overrides = bad, gazetteer = g), "complete sourced")
  bad <- d; bad$preferred_name <- "!!!"
  expect_error(dn_museum_analysis(x, name_overrides = bad, gazetteer = g), "usable name")
  x$counted[1] <- FALSE
  expect_error(dn_museum_analysis(x, name_overrides = d, gazetteer = g), "Stale")
})

