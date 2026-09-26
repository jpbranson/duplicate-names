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
