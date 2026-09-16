identity_fixture <- function() {
  names <- c("Current Museum", "Former Museum", "Museum Mailing Record", "Other Museum")
  dplyr::bind_rows(lapply(seq_along(names), function(i) {
    dplyr::add_row(dn_schema_entity(), source = "test", source_id = as.character(i),
      category = "museum", name_raw = names[i], primary_name = names[i], alt_names = "",
      name_clean = tolower(names[i]), name_expanded = tolower(names[i]),
      name_core = tolower(names[i]), name_key = dn_name_key(tolower(names[i])),
      lon = -90 + i, lat = 35, entity_id = paste0("e", i), site_id = paste0("s", i),
      n_sources = 1L, source_set = "test", n_sites = 1L, is_primary_site = TRUE,
      counted = TRUE, is_franchise = NA, confidence = 0.9,
      source_update_time = as.Date("2026-09-01"))
  }))
}

identity_decisions_fixture <- function(x) {
  x <- x[1:3, ]
  tibble::tibble(case_id = "documented_move", source = x$source, source_id = x$source_id,
    expected_name = x$name_raw, expected_entity_id = x$entity_id,
    expected_coordinates = dn_identity_coordinates(x),
    role = c("canonical", "former_site", "mailing_address"),
    site_group = c("current", "former", "current"),
    evidence_url = "https://example.org/history", evidence_note = "Fixture evidence",
    reviewed_by = "Source reviewer", reviewed_on = "2026-09-15")
}

test_that("curated identities preserve source evidence and keep unrelated records unchanged", {
  x <- identity_fixture()
  d <- identity_decisions_fixture(x)
  result <- dn_reconcile_museums(x, d)
  out <- result$records
  expect_identical(out[4, ], x[4, ])
  expect_identical(out[names(dn_schema_normalized())], x[names(dn_schema_normalized())])
  expect_equal(out$entity_id, c("e1", "e1", "e1", "e4"))
  expect_equal(out$site_id, c("s1", "s2", "s1", "s4"))
  expect_equal(out$n_sites, c(2L, 2L, 2L, 1L))
  expect_equal(out$counted, c(TRUE, FALSE, FALSE, TRUE))
  expect_equal(out$exclusion_reason[2:3], c("reviewed_former_site", "reviewed_mailing_address"))
  expect_true(all(grepl("Former Museum", out$alt_names[1:3])))
  expect_equal(result$audit$before_entity_id, c("e1", "e2", "e3"))
  expect_equal(result$audit$after_entity_id, rep("e1", 3))
  a <- dn_museum_analysis(out)
  expect_equal(sum(a$analysis_eligible), 2L)
  expect_true(all(a$review_status == "pending"))
  expect_equal(dn_canonical_entities(out)$lon, c(-89, -86))
})

test_that("identity decisions reject stale data and incomplete baseline membership", {
  x <- identity_fixture()
  d <- identity_decisions_fixture(x)
  y <- x; y$name_raw[2] <- "Unreviewed new name"
  expect_error(dn_reconcile_museums(y, d), "Stale identity")
  y <- x; y$lon[2] <- y$lon[2] + 0.01
  expect_error(dn_reconcile_museums(y, d), "Stale identity")
  y <- x; y$entity_id[2] <- "new_cluster"
  expect_error(dn_reconcile_museums(y, d), "Stale identity")
  y <- x; y$entity_id[4] <- y$entity_id[1]
  expect_error(dn_reconcile_museums(y, d), "every member")
  expect_error(dn_reconcile_museums(x, dplyr::bind_rows(d, d[1, ])), "Duplicate source")
  d$source_id[2] <- "missing"
  expect_error(dn_reconcile_museums(x, d), "Stale identity")
})

test_that("review requires an explicit representative, site relationships and evidence", {
  x <- identity_fixture()
  d <- identity_decisions_fixture(x)
  bad <- d; bad$role[1] <- "same_site"
  expect_error(dn_reconcile_museums(x, bad), "exactly one")
  bad <- d; bad$role[2] <- "canonical"
  expect_error(dn_reconcile_museums(x, bad), "exactly one")
  bad <- d; bad$site_group[2] <- "current"
  expect_error(dn_reconcile_museums(x, bad), "Former sites")
  bad <- d; bad$site_group[3] <- "mailbox"
  expect_error(dn_reconcile_museums(x, bad), "Former sites")
  bad <- d; bad$evidence_url[2] <- NA_character_
  expect_error(dn_reconcile_museums(x, bad), "complete review")
  y <- x; y$counted[1] <- FALSE
  expect_error(dn_reconcile_museums(y, d), "counted canonical")
  y <- x; y$category[3] <- "place_of_worship"
  expect_error(dn_reconcile_museums(y, d), "other categories")
})

test_that("shared owners and same names do not expand explicit correction membership", {
  x <- identity_fixture()
  x$name_raw[4] <- x$name_raw[1]
  x$operator <- "Shared Operator"
  d <- identity_decisions_fixture(x)
  out <- dn_reconcile_museums(x, d)$records
  expect_identical(out[4, ], x[4, ])
  # A different case can describe a different museum under the same operator.
  other <- d[1, ]
  other$case_id <- "second_museum"
  other$source_id <- "4"
  other$expected_entity_id <- x$entity_id[4]
  other$expected_coordinates <- dn_identity_coordinates(x[4, ])
  out <- dn_reconcile_museums(x, dplyr::bind_rows(d, other))$records
  expect_equal(dplyr::n_distinct(out$entity_id), 2L)
})

test_that("an empty identity review preserves both data and stage contracts", {
  x <- identity_fixture()
  out <- dn_reconcile_museums(x)
  expect_identical(out$records, x)
  expect_equal(nrow(out$audit), 0L)
  expect_silent(dn_validate(dn_reconcile_museums(dn_schema_entity())$records, dn_schema_entity()))
})

test_that("mixed source rows are isolated without leaking aliases into accepted museums", {
  x <- identity_fixture()
  x$entity_id[3] <- x$entity_id[2]
  x$alt_names[2:3] <- "Disputed alias"
  d <- identity_decisions_fixture(x)
  d$role <- c("canonical", "same_site", "source_conflict")
  d$site_group <- c("current", "current", "unresolved_source")
  result <- dn_reconcile_museums(x, d)
  out <- result$records
  expect_identical(out[names(dn_schema_normalized())], x[names(dn_schema_normalized())])
  expect_identical(out[4, ], x[4, ])
  expect_equal(out$entity_id[1:2], c("e1", "e1"))
  expect_false(out$entity_id[3] %in% x$entity_id)
  expect_equal(out$counted, c(TRUE, FALSE, FALSE, TRUE))
  expect_equal(out$exclusion_reason[3], "reviewed_source_conflict")
  expect_equal(out$alt_names[1:2], rep("Former Museum", 2))
  expect_equal(out$alt_names[3], "")
  expect_equal(out$primary_name[3], x$name_raw[3])
  expect_false(out$is_primary_site[3])
  expect_equal(out$n_sources[3], 1L)
  expect_equal(out$source_set[3], "test")
  expect_equal(result$audit$after_entity_id[3], out$entity_id[3])
  expect_false(dn_museum_analysis(out)$analysis_eligible[
    dn_museum_analysis(out)$source_id == "3"])
  reordered <- dn_reconcile_museums(x[4:1, ], d[3:1, ])$records
  expect_equal(reordered$entity_id[reordered$source_id == "3"], out$entity_id[3])
  expect_error(dn_reconcile_museums(x, d[1:2, ]), "every member")
  bad <- d; bad$site_group[3] <- "current"
  expect_error(dn_reconcile_museums(x, bad), "unresolved_source")
  bad <- d; bad$role[1] <- "same_site"
  expect_error(dn_reconcile_museums(x, bad), "exactly one")
})

test_that("an entirely contradictory entity can be held out without a canonical assignment", {
  x <- identity_fixture()
  d <- identity_decisions_fixture(x)[1, ]
  d$role <- "source_conflict"
  d$site_group <- "unresolved_source"
  out <- dn_reconcile_museums(x, d)$records
  expect_identical(out[2:4, ], x[2:4, ])
  expect_false(out$counted[1])
  expect_equal(out$exclusion_reason[1], "reviewed_source_conflict")
  expect_false(out$entity_id[1] %in% x$entity_id)
})
