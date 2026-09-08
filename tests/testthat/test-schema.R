# The schema contract (R/schema.R). These checks exist so a shape error
# surfaces at the stage that caused it rather than as a metric quietly
# returning zero rows three stages later.

test_that("dn_validate accepts a conforming empty table", {
  expect_silent(dn_validate(dn_schema_raw(), dn_schema_raw()))
  expect_silent(dn_validate(dn_schema_entity(), dn_schema_entity()))
})

test_that("dn_validate rejects missing, extra and mistyped columns", {
  proto <- dn_schema_raw()

  expect_error(dn_validate(proto[, -1], proto), "missing column")

  extra <- proto
  extra$surprise <- character()
  expect_error(dn_validate(extra, proto), "unexpected column")

  wrong <- proto
  wrong$lon <- character()
  expect_error(dn_validate(wrong, proto), "wrong type")
})

test_that("dn_validate returns columns in schema order", {
  shuffled <- dn_schema_raw()[, rev(names(dn_schema_raw()))]
  expect_equal(names(dn_validate(shuffled, dn_schema_raw())),
               names(dn_schema_raw()))
})

test_that("the schemas nest as documented", {
  expect_true(all(names(dn_schema_raw())        %in% names(dn_schema_normalized())))
  expect_true(all(names(dn_schema_normalized()) %in% names(dn_schema_entity())))
})

test_that("controlled vocabularies are non-empty and unique", {
  expect_true(length(dn_name_styles()) > 0L)
  expect_false(anyDuplicated(dn_name_styles()) > 0L)
  expect_false(anyDuplicated(dn_scope_claims()) > 0L)
})

test_that("dn_bind_sources catches a duplicate source_id", {
  one <- dplyr::add_row(
    dn_schema_raw(),
    source = "gnis", source_id = "dup", category = "place_of_worship",
    category_raw = "religious_organization",
    name_raw = "First Baptist Church", lon = -90, lat = 35, country = "US",
    denomination = NA_character_, religion = NA_character_,
    operator = NA_character_, wikidata_id = NA_character_,
    confidence = NA_real_, operating_status = NA_character_, retrieved = Sys.Date()
  )
  # An EXACT duplicate is the source shipping one record twice — IMLS does
  # this once, where a museum appears in two of its three files. Collapse it.
  expect_message(out <- dn_bind_sources(one, one), "collapsed")
  expect_equal(nrow(out), 1L)
})

test_that("dn_bind_sources rejects a reused source_id with different content", {
  base <- dplyr::add_row(
    dn_schema_raw(),
    source = "gnis", source_id = "dup", category = "place_of_worship",
    category_raw = "religious_organization",
    name_raw = "First Baptist Church", lon = -90, lat = 35, country = "US",
    denomination = NA_character_, religion = NA_character_,
    operator = NA_character_, wikidata_id = NA_character_,
    confidence = NA_real_, operating_status = NA_character_, retrieved = Sys.Date()
  )
  other <- base
  other$name_raw <- "Second Baptist Church"

  # Same id, different record: a paging bug, or source_id is not a key.
  # Downstream this would look exactly like a duplicate NAME, which is the
  # thing this project measures — so refuse rather than guess.
  expect_error(dn_bind_sources(base, other), "DIFFERING content")
})

test_that("dn_bind_sources accepts the empty church stubs", {
  # Only the Phase 1b stubs: src_overture() and src_imls() now hit the network
  # and the filesystem, so they do not belong in a unit test.
  expect_silent(dn_bind_sources(src_osm(), src_gnis(), src_hifld()))
})
