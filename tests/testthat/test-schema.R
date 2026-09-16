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

test_that("empty source data pass through normalization, resolution and counting", {
  normalized <- dn_normalize(dn_bind_sources(src_osm(), src_gnis(), src_hifld()))
  resolved <- dn_resolve(normalized)
  expect_identical(resolved, dn_schema_entity())
  expect_identical(dn_apply_counting_policy(resolved), resolved)
  expect_error(dn_resolve(normalized[, -1]), "missing column")
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

test_that("rare-token gate distinguishes identity from generic label", {
  # A shared name only implies a shared institution when the name is
  # distinctive. Both of these appear at ~3 sites; only one is one museum.
  corpus <- c(rep("art museum state", 40), rep("gallery art county", 40),
              "cryptozoology international museum", "museum quilt barbed wire")
  rare <- dn_has_rare_token(corpus)
  expect_false(rare[1])                       # "state art museum" - all generic
  expect_true(rare[length(corpus) - 1L])      # "cryptozoology" is rare
  expect_true(rare[length(corpus)])
})

test_that("institution-type variants merge, but only with enough name left", {
  # Decided 2026-09-07: the physical institution is the subject, so the
  # society that runs a museum is the same place as the museum.
  expect_gte(dn_name_similarity("washington county historical museum",
                                "washington county historical society"),
             DN_NAME_SIM_MIN)
  expect_gte(dn_name_similarity("midland county history museum",
                                "midland county history society"),
             DN_NAME_SIM_MIN)

  # The two-token guard stops the TYPE-STRIPPED measure from collapsing
  # "springfield museum" to "springfield" and matching everything nearby.
  expect_equal(dn_strip_institution_type("springfield museum"), "springfield")

  # KNOWN RISK, documented rather than asserted away: Jaro-Winkler's prefix
  # weighting scores this pair ~0.90 on the shared "springfield " prefix alone,
  # so the guard above does not actually keep them apart. Names sharing a long
  # place prefix and differing only in the distinguishing word are the most
  # likely over-merge in the whole pipeline — "Springfield Art Museum" vs
  # "Springfield Science Museum" is a real configuration.
  #
  # The September 15 sample supports retaining 0.85, but does not certify this
  # pair or final clusters. See HANDOFF.md, open question 1.
  expect_gt(dn_name_similarity("springfield museum", "springfield society"), 0.85)
})

test_that("the museum name leads and the alternate is preserved", {
  expect_equal(dn_institution_type("county historical society"), "society")
  expect_equal(dn_institution_type("county historical museum"), "museum")
  expect_true(is.na(dn_institution_type("old jail")))
})
