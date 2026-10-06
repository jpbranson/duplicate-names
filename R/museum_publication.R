# Publication coordinates are explicit sourced overlays, never replacements for raw points.
# No fallback to source coordinates is labelled as a checked visitor location.
dn_museum_publication_points <- function(x, locations, access, as_of = Sys.Date(), max_age_days = 30L) {
  required <- c("source", "source_id", "entity_id", "name_raw", "lon", "lat",
                "publication_lon", "publication_lat", "evidence_url", "point_basis", "reviewed_on")
  need_access <- c("source", "source_id", "access_status", "access_text", "access_evidence_url", "access_checked_on")
  if (!all(required %in% names(locations)) || !all(need_access %in% names(access))) stop("Publication point/access fields missing.")
  key <- function(z) paste(z$source, z$source_id, sep = ":")
  if (anyDuplicated(key(x)) || anyDuplicated(key(locations)) || anyDuplicated(key(access))) stop("Duplicate publication source key.")
  j <- match(key(locations), key(x)); k <- match(key(locations), key(access))
  if (anyNA(j) || anyNA(k) || anyNA(locations[required]) ||
      any(locations$entity_id != x$entity_id[j] | locations$name_raw != x$name_raw[j]) ||
      any(abs(locations$lon - x$lon[j]) > 1e-7 | abs(locations$lat - x$lat[j]) > 1e-7)) stop("Stale publication point guard or missing access check.")
  if (any(!is.finite(locations$publication_lon) | abs(locations$publication_lon) > 180 |
          !is.finite(locations$publication_lat) | abs(locations$publication_lat) > 90) ||
      any(!grepl("^https://", locations$evidence_url)) || any(!nzchar(locations$point_basis))) stop("Invalid publication point/evidence.")
  access <- access[k, , drop = FALSE]
  if (anyNA(access[need_access]) || any(!access$access_status %in% c("open", "appointment_or_event", "closed", "unknown")) ||
      any(!nzchar(access$access_text)) || any(!grepl("^https://", access$access_evidence_url))) stop("Invalid publication access check.")
  point_date <- as.Date(locations$reviewed_on); access_date <- as.Date(access$access_checked_on)
  if (anyNA(point_date) || anyNA(access_date) || any(point_date > as_of | access_date > as_of) ||
      any(as.integer(as_of - point_date) > max_age_days | as.integer(as_of - access_date) > max_age_days)) stop("Publication point/access evidence is stale or future-dated.")
  out <- x
  out$publication_lon <- out$publication_lat <- rep(NA_real_, nrow(x))
  for (field in c("point_evidence_url", "point_basis", "point_reviewed_on", "access_status", "access_text", "access_evidence_url", "access_checked_on", "publication_map_url")) out[[field]] <- rep(NA_character_, nrow(x))
  out$publication_lon[j] <- locations$publication_lon; out$publication_lat[j] <- locations$publication_lat
  out$point_evidence_url[j] <- locations$evidence_url; out$point_basis[j] <- locations$point_basis
  out$point_reviewed_on[j] <- as.character(point_date)
  for (field in need_access[-c(1, 2)]) out[[field]][j] <- access[[field]]
  out$publication_map_url[j] <- sprintf("https://www.google.com/maps?q=%.7f,%.7f", locations$publication_lat, locations$publication_lon)
  out$visitor_ready <- out$counted & out$review_status == "verified" & out$access_status %in% c("open", "appointment_or_event") & !is.na(out$publication_lon)
  out
}

# Post 1 tables under DESIGN decision 14. Lists every counted non-chain member of each
# group named in `headline_review` and whether it counts toward the name: a complete
# factual review with known affiliation, or a passing headline-review row. A recorded
# `public_name` must also normalize to the group's L2 name. A group is `confirmed` only
# when the publication gate passes and every member counts (at least two);
# `unresolved_record` keeps two counting members beside a record that does not count.
# Read-only: review statuses, affiliations, counts and source fields are unchanged.
dn_post1_groups <- function(analysis, headline_review, as_of = Sys.Date()) {
  key <- function(z) paste(z$source, z$source_id, sep = ":")
  x <- dplyr::filter(analysis, .data$counted, .data$name_expanded %in% headline_review$group,
                     .data$affiliation_status != "chain")
  i <- match(key(x), key(headline_review))
  j <- match(key(headline_review), key(x))
  if (anyNA(j) || any(headline_review$group != x$name_expanded[j])) {
    stop("Stale headline review row: no counted non-chain member under that name.", call. = FALSE)
  }
  complete <- x$review_status == "verified" & x$affiliation_status != "unknown"
  sufficient <- dn_headline_sufficient(x, headline_review, as_of)
  field <- function(name) if (name %in% names(headline_review)) as.character(headline_review[[name]][i]) else NA_character_
  public <- field("public_name")
  named <- is.na(public) | !nzchar(public) | dn_name_expand(dn_name_clean(public)) == x$name_expanded
  members <- tibble::tibble(
    group = x$name_expanded, source = x$source, source_id = x$source_id,
    place = field("place"), state = field("state"), public_name = public, operator = field("operator"),
    basis = dplyr::case_when(complete & named ~ "complete factual review",
                             is.na(i) ~ "not reviewed",
                             !complete & !sufficient ~ "failed check",
                             !named ~ "public name differs",
                             TRUE ~ "headline-sufficient check"),
    counts = x$analysis_eligible & named & (complete | sufficient),
    evidence_url = field("evidence_url"), checked_on = field("checked_on"), note = field("note")) |>
    dplyr::arrange(.data$group, dplyr::desc(.data$counts), .data$state, .data$place)
  gate <- function(name) {
    tryCatch({dn_assert_museum_publication_ready(analysis, name, headline_review, as_of); TRUE},
             error = function(e) FALSE)
  }
  groups <- members |>
    dplyr::group_by(.data$group) |>
    dplyr::summarise(records = dplyr::n(), counting = sum(.data$counts), .groups = "drop") |>
    dplyr::mutate(
      chain_locations = vapply(.data$group, function(name) {
        sum(analysis$counted & analysis$name_expanded %in% name & analysis$affiliation_status %in% "chain")
      }, integer(1), USE.NAMES = FALSE),
      gate_passed = vapply(.data$group, gate, logical(1), USE.NAMES = FALSE),
      status = dplyr::case_when(.data$gate_passed & .data$counting == .data$records &
                                  .data$counting >= 2L ~ "confirmed",
                                .data$counting >= 2L ~ "unresolved_record",
                                TRUE ~ "not_a_collision"))
  list(members = members, groups = groups)
}
