# Gold-set tests for the §4 ladder.
#
# Everything both posts claim rests on these. When a case here changes, a
# published number changes with it — so add cases as real-world oddities turn
# up, and never adjust an expectation to make a test pass.

test_that("L1 folds case, strips punctuation and diacritics, drops leading 'The'", {
  expect_equal(dn_name_clean("The International Cryptozoology Museum"),
               "international cryptozoology museum")
  expect_equal(dn_name_clean("St. Mary's Catholic Church"),
               "st mary's catholic church")
  expect_equal(dn_name_clean("Iglesia Bautista Getsemaní"),
               "iglesia bautista getsemani")
  expect_equal(dn_name_clean("FIRST   BAPTIST\tCHURCH"),
               "first baptist church")
})

test_that("L1 only strips a LEADING 'the'", {
  # "Church of the Holy Cross" must keep its internal article.
  expect_equal(dn_name_clean("Church of the Holy Cross"),
               "church of the holy cross")
})

test_that("L2 expands abbreviations and stays lowercase", {
  expect_equal(dn_name_expand("st mary's catholic church"),
               "saint mary's catholic church")
  expect_equal(dn_name_expand("mt zion a m e church"),
               "mount zion african methodist episcopal church")
  expect_equal(dn_name_expand("2nd presbyterian church"),
               "second presbyterian church")

  # The invariant every later stage depends on.
  expect_equal(dn_name_expand("st john's"), tolower(dn_name_expand("st john's")))
})

test_that("L2 expands A.M.E. Zion without doubling 'zion'", {
  expect_equal(dn_name_expand("a m e zion church"),
               "african methodist episcopal zion church")
})

test_that("ordinals parse from words and numerals alike", {
  ord <- function(s) dn_parse_ordinal(dn_name_expand(dn_name_clean(s)))
  expect_equal(ord("First Presbyterian Church"), 1L)
  expect_equal(ord("2nd Presbyterian Church"),   2L)
  expect_equal(ord("Third Baptist Church"),      3L)
  expect_equal(ord("Nineteenth Street Baptist"), NA_integer_)  # toponym, see below
  expect_equal(ord("Grace Lutheran Church"),     NA_integer_)
})

test_that("an ordinal followed by a street word is a place, not a count", {
  ord <- function(s) dn_parse_ordinal(dn_name_expand(dn_name_clean(s)))
  # These are addresses. Counting them would inflate the C3 ladder hardest in
  # exactly the dense old cities where genuine high ordinals live.
  expect_equal(ord("Fourth Street Baptist Church"), NA_integer_)
  expect_equal(ord("Fifth Avenue Presbyterian Church"), NA_integer_)
  expect_equal(ord("Second Ward Baptist Church"), NA_integer_)
  # ...but the bare ordinal still counts.
  expect_equal(ord("Fourth Presbyterian Church"), 4L)
})

test_that("First Church of Christ, Scientist is not an ordinal (§6.6)", {
  ord <- function(s) dn_parse_ordinal(dn_name_expand(dn_name_clean(s)))
  expect_equal(ord("First Church of Christ, Scientist"), NA_integer_)
  expect_equal(ord("First Church of Christ Scientist"),  NA_integer_)
})

test_that("KNOWN GAP: compound ordinals are not yet parsed", {
  # Documents current behaviour rather than blessing it. C3's headline is the
  # highest observed ordinal, and the highest ones are compound, so this must
  # be fixed before the ladder metric ships. See TODO in R/normalize.R.
  ord <- function(s) dn_parse_ordinal(dn_name_expand(dn_name_clean(s)))
  expect_equal(ord("Twenty Third Street Baptist Church"), NA_integer_)
  expect_equal(ord("Twenty Third Presbyterian Church"),   NA_integer_)  # should be 23L
})

test_that("scope claims are extracted for the museum hubris ranking", {
  claim <- function(s) dn_parse_scope_claim(dn_name_clean(s))
  expect_equal(claim("The International Cryptozoology Museum"), "International")
  expect_equal(claim("National Museum of Funeral History"),     "National")
  expect_equal(claim("World Museum of Mining"),                 "World")
  expect_equal(claim("Springfield Historical Museum"),          NA_character_)
})

test_that("L4 sorts tokens and drops stopwords", {
  # These two orderings of the same institution must land on one key.
  expect_equal(dn_name_key("museum of the american quilt"),
               dn_name_key("american quilt museum"))
})

test_that("dn_normalize warns rather than silently producing bad name_core", {
  raw <- dn_schema_raw()
  raw <- dplyr::add_row(
    raw,
    source = "test", source_id = "1", category = "museum",
    name_raw = "The International Cryptozoology Museum",
    lon = -68.77, lat = 44.80, country = "US",
    denomination = NA_character_, religion = NA_character_,
    operator = NA_character_, wikidata_id = NA_character_,
    confidence = NA_real_, retrieved = Sys.Date()
  )
  expect_warning(dn_normalize(raw), "gazetteer")
})
