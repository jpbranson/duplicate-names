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
    name_raw = "First Baptist Church", lon = -90, lat = 35, country = "US",
    denomination = NA_character_, religion = NA_character_,
    operator = NA_character_, wikidata_id = NA_character_,
    confidence = NA_real_, retrieved = Sys.Date()
  )
  # A repeated id means a paging bug in a fetcher. Downstream it would look
  # exactly like a duplicate NAME, which is the thing this project measures.
  expect_error(dn_bind_sources(one, one), "Duplicate source_id")
})

test_that("dn_bind_sources accepts the empty Phase 0 sources", {
  expect_silent(
    dn_bind_sources(src_overture(), src_osm(), src_gnis(), src_imls(), src_hifld())
  )
})
