# A curated layer over the unchanged automatic resolver. Every participating
# source record must be named; names/proximity never expand a correction's scope.
# This records factual corrections, not independent matching-validation labels.

dn_identity_coordinates <- function(x) sprintf("%.7f,%.7f", x$lon, x$lat)

dn_museum_identity_audit <- function(before, after, decisions) {
  fields <- c("entity_id", "site_id", "primary_name", "alt_names", "n_sources", "source_set",
              "is_franchise", "chain_id", "n_sites",
              "is_primary_site", "counted", "exclusion_reason")
  idx <- match(paste(decisions$source, decisions$source_id), paste(before$source, before$source_id))
  old <- before[idx, fields]
  new <- after[idx, fields]
  names(old) <- paste0("before_", fields)
  names(new) <- paste0("after_", fields)
  dplyr::bind_cols(decisions, old, new)
}

dn_reconcile_museums <- function(entities, decisions = dn_schema_museum_identity_decisions()) {
  dn_validate(entities, dn_schema_entity(), label = "identity baseline")
  dn_validate(decisions, dn_schema_museum_identity_decisions())
  if (!nrow(decisions)) {
    return(list(records = entities, audit = dn_museum_identity_audit(entities, entities, decisions)))
  }
  required <- vapply(decisions, function(x) any(is.na(x) | !nzchar(trimws(x))), logical(1))
  if (any(required) || any(!grepl("^https://", decisions$evidence_url)) ||
      any(!decisions$role %in% c("canonical", "same_site", "former_site", "mislocated", "mailing_address",
                                "source_conflict"))) {
    stop("Identity decisions require valid roles, evidence and complete review metadata.")
  }
  key <- paste(entities$source, entities$source_id, sep = ":")
  reviewed_key <- paste(decisions$source, decisions$source_id, sep = ":")
  if (anyDuplicated(key) || anyDuplicated(reviewed_key)) stop("Duplicate source key in identity review.")
  idx <- match(reviewed_key, key)
  if (anyNA(idx) || any(decisions$expected_name != entities$name_raw[idx]) ||
      any(decisions$expected_entity_id != entities$entity_id[idx]) ||
      any(decisions$expected_coordinates != dn_identity_coordinates(entities[idx, ]))) {
    stop("Stale identity decision: source name, entity or coordinates changed.")
  }
  # An automatic cluster cannot be partly or implicitly pulled into a merge.
  affected <- entities$entity_id %in% decisions$expected_entity_id
  if (!setequal(key[affected], reviewed_key)) stop("Identity review must list every member of affected baseline entities.")
  membership <- split(decisions$case_id, decisions$expected_entity_id)
  if (any(vapply(membership, function(x) length(unique(x)) != 1L, logical(1)))) {
    stop("A baseline entity cannot appear in multiple identity cases; review a split separately.")
  }
  if (any(entities$category[idx] != "museum")) stop("Museum identity review cannot change other categories.")
  out <- entities
  for (case in unique(decisions$case_id)) {
    di <- which(decisions$case_id == case)
    ei <- idx[di]
    d <- decisions[di, ]
    # A mixed source row is evidence of neither institution. Isolate it from
    # the accepted members, retaining its source fields without propagating
    # its disputed name/aliases into a current museum. Full baseline membership
    # and the same stale-data guards still apply to these explicit holdouts.
    conflict <- d$role == "source_conflict"
    if (any(conflict)) {
      if (any(d$site_group[conflict] != "unresolved_source")) {
        stop("Source conflicts require the unresolved_source site group.")
      }
      ci <- ei[conflict]
      conflict_ids <- vapply(key[ci], function(k) {
        substr(digest::digest(paste0("museum_source_conflict:", k), algo = "sha256"), 1L, 12L)
      }, character(1))
      if (any(conflict_ids %in% c(entities$entity_id, entities$site_id)) || anyDuplicated(conflict_ids)) {
        stop("Source-conflict ID collision.")
      }
      out$entity_id[ci] <- conflict_ids
      out$site_id[ci] <- conflict_ids
      out$n_sources[ci] <- 1L
      out$source_set[ci] <- entities$source[ci]
      out$n_sites[ci] <- 1L
      out$is_primary_site[ci] <- FALSE
      out$primary_name[ci] <- entities$name_raw[ci]
      out$alt_names[ci] <- ""
      out$is_franchise[ci] <- NA
      out$chain_id[ci] <- NA_character_
      out$counted[ci] <- FALSE
      out$exclusion_reason[ci] <- "reviewed_source_conflict"
      ei <- ei[!conflict]
      d <- d[!conflict, ]
      if (!length(ei)) next
    }
    anchor <- which(d$role == "canonical")
    if (length(anchor) != 1L || !isTRUE(entities$counted[ei[anchor]])) {
      stop("Each identity case needs exactly one counted canonical record.")
    }
    anchor_row <- ei[anchor]
    current_group <- d$site_group[anchor]
    if (any((d$role == "former_site") == (d$site_group == current_group))) {
      stop("Former sites must have separate site groups; all other roles use the canonical site group.")
    }
    out$entity_id[ei] <- entities$entity_id[anchor_row]
    for (site in unique(d$site_group)) {
      si <- ei[d$site_group == site]
      site_id <- if (site == current_group) entities$site_id[anchor_row] else min(entities$site_id[si])
      out$site_id[si] <- site_id
    }
    out$n_sources[ei] <- dplyr::n_distinct(entities$source[ei])
    out$source_set[ei] <- paste(sort(unique(entities$source[ei])), collapse = "|")
    out$n_sites[ei] <- dplyr::n_distinct(out$site_id[ei])
    out$is_primary_site[ei] <- d$site_group == current_group
    out$primary_name[ei] <- entities$name_raw[anchor_row]
    # Rebuild aliases from accepted members after a conflict split; inherited
    # baseline aliases may have come from the quarantined row.
    aliases <- entities$name_raw[ei]
    if (!any(conflict)) aliases <- c(aliases, unlist(strsplit(entities$alt_names[ei], "\\s*\\|\\s*")))
    aliases <- sort(unique(aliases[!is.na(aliases) & nzchar(aliases)]))
    out$alt_names[ei] <- paste(setdiff(aliases, entities$name_raw[anchor_row]), collapse = " | ")
    # One explicit source representative supplies the reviewed name and point.
    # Original names/coordinates stay intact; excluded supporting rows remain
    # available for provenance. Unreviewed entities retain their baseline policy.
    out$counted[ei] <- d$role == "canonical"
    out$exclusion_reason[ei] <- dplyr::case_when(
      d$role == "canonical" ~ NA_character_,
      d$role == "former_site" ~ "reviewed_former_site",
      d$role == "mailing_address" ~ "reviewed_mailing_address",
      d$role == "mislocated" ~ "reviewed_mislocated_record",
      TRUE ~ "reviewed_duplicate_record"
    )
  }
  dn_validate(out, dn_schema_entity(), label = "reviewed museum records")
  list(records = out, audit = dn_museum_identity_audit(entities, out, decisions))
}

dn_export_museum_identity <- function(review, directory = "data/processed/museum_review") {
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  path <- file.path(directory, "identity_audit.csv")
  readr::write_csv(review$audit, path, na = "")
  path
}
