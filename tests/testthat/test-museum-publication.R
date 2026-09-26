publication_fixture <- function() {
  x <- tibble::tibble(source = c("overture", "imls"), source_id = c("one", "two"), entity_id = c("e1", "e2"),
    name_raw = c("Museum A", "Museum B"), lon = c(-80, -81), lat = c(40, 41), counted = TRUE, review_status = "verified")
  point <- dplyr::mutate(x[1, 1:7], publication_lon = -80.001, publication_lat = 40.001,
    evidence_url = "https://operator.example/location", point_basis = "operator GPS", reviewed_on = "2026-09-15")
  access <- tibble::tibble(source = "overture", source_id = "one", access_status = "appointment_or_event",
    access_text = "By appointment", access_evidence_url = "https://operator.example/visit", access_checked_on = "2026-09-26")
  list(x = x, point = point, access = access)
}
test_that("publication overlay preserves sources and does not certify unchecked points", {
  f <- publication_fixture(); x <- dn_museum_publication_points(f$x, f$point, f$access, as.Date("2026-09-26"))
  expect_identical(x[names(f$x)], f$x)
  expect_equal(x$publication_lon, c(-80.001, NA))
  expect_equal(x$visitor_ready, c(TRUE, FALSE))
  f$access$access_status <- "closed"
  expect_false(dn_museum_publication_points(f$x, f$point, f$access, as.Date("2026-09-26"))$visitor_ready[1])
  f$access$access_status <- "open"; f$x$review_status[1] <- "pending"
  expect_false(dn_museum_publication_points(f$x, f$point, f$access, as.Date("2026-09-26"))$visitor_ready[1])
})
test_that("publication rejects stale identities, missing access, and expired evidence", {
  f <- publication_fixture(); run <- function() dn_museum_publication_points(f$x, f$point, f$access, as.Date("2026-09-26"))
  f$point$entity_id <- "other"; expect_error(run(), "Stale")
  f <- publication_fixture(); f$point$lon <- -82; expect_error(run(), "Stale")
  f <- publication_fixture(); f$access$source_id <- "other"; expect_error(run(), "Stale")
  f <- publication_fixture(); f$point$publication_lat <- 100; expect_error(run(), "Invalid")
  f <- publication_fixture(); f$point$reviewed_on <- "2026-07-01"; expect_error(run(), "stale")
  f <- publication_fixture(); f$access$access_checked_on <- "2027-01-01"; expect_error(run(), "future")
  f <- publication_fixture(); f$access <- dplyr::bind_rows(f$access, f$access); expect_error(run(), "Duplicate")
})
