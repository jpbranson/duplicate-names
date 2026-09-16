test_that("IMLS dossiers retain conflicting addresses, tax IDs and missing physical fields", {
  # This cached archive is a repository fixture; no source adapter or download runs.
  context <- dn_imls_review_context(test_path("data/raw/2018_csv_museum_data_files.zip"))
  expect_silent(dn_validate(context, dn_schema_imls_context()))
  expect_equal(anyDuplicated(context$source_id), 0L)

  venetia <- context[context$source_id %in% "8404201308", ]
  expect_equal(venetia$imls_ein, "251778027")
  expect_equal(venetia$imls_physical_city, "WASHINGTON")
  expect_equal(venetia$imls_mailing_city, "VENETIA")
  expect_equal(venetia$imls_physical_zip5, "15301")
  expect_equal(venetia$imls_mailing_zip5, "15367")
  expect_equal(venetia$imls_city, "WASHINGTON")
  expect_match(venetia$imls_physical_address, "PO BOX 208, WASHINGTON, PA, 15301")
  expect_match(venetia$imls_mailing_address, "PO BOX 208, VENETIA, PA, 15367")

  barrow <- context[context$source_id %in% "8404200022", ]
  expect_equal(barrow$imls_ein, "222260222")
  expect_match(barrow$imls_legal_name, "JOHN D BARROW")

  lemoyne <- context[context$source_id %in% "8404201136", ]
  expect_true(all(is.na(lemoyne[c("imls_physical_street", "imls_physical_city",
                                  "imls_physical_address")])))
  expect_equal(lemoyne$imls_mailing_street, "49 E MAIDEN ST")
  expect_equal(lemoyne$imls_street, "49 E MAIDEN ST")

  leading_zero <- context[context$source_id %in% "8400900037", ]
  expect_equal(leading_zero$imls_ein, "046112604")
  expect_equal(leading_zero$imls_mailing_zip, "06040")
  expect_equal(leading_zero$imls_mailing_zip5, "06040")

  # Two archive rows share this MID but disagree on the mailing street.
  avalon <- context[context$source_id %in% "8400602963X", ]
  expect_equal(avalon$imls_mailing_address,
    "1202 AVALON CANYON RD, AVALON, CA, 90704 | 1402 AVALON CANYON RD, AVALON, CA, 90704")
  expect_true(is.na(avalon$imls_physical_street))
  expect_equal(avalon$imls_physical_address, "AVALON, CA, 90704")
})

test_that("address summaries preserve partial and absent source addresses", {
  expect_equal(dn_imls_address(c(NA, "1 Main St", NA), c(NA, "Example", "Town"),
    c(NA, "CT", NA), c(NA, "06040-1234", NA)),
    c(NA_character_, "1 Main St, Example, CT, 06040-1234", "Town"))
  expect_identical(dn_imls_address(character(), character(), character(), character()), character())
})
