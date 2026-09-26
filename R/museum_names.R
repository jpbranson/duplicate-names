# Sourced preferred names affect analysis only, never original source records or
# the automatic baseline. An override does not certify the rest of a review.
dn_apply_museum_name_overrides <- function(x, overrides = dn_schema_museum_name_overrides(), gazetteer = NULL) {
  dn_validate(overrides, dn_schema_museum_name_overrides())
  x$source_primary_name <- x$primary_name
  x$name_override_evidence <- rep(NA_character_, nrow(x))
  if (!nrow(overrides)) return(x)
  if (is.null(gazetteer)) stop("Preferred museum names require a gazetteer for consistent L3 normalization.")
  missing <- vapply(overrides, function(v) any(is.na(v) | !nzchar(trimws(v))), logical(1))
  if (any(missing) || any(!grepl("^https://", overrides$evidence_url))) {
    stop("Preferred museum names require complete sourced review metadata.")
  }
  keys <- paste(x$source, x$source_id)
  idx <- match(paste(overrides$source, overrides$source_id), keys)
  if (anyNA(idx) || any(overrides$expected_name != x$name_raw[idx]) ||
      any(overrides$expected_entity_id != x$entity_id[idx]) || any(!x$counted[idx])) {
    stop("Stale preferred-name decision: canonical source, entity or name changed.")
  }
  if (anyDuplicated(idx)) stop("Multiple preferred-name decisions address the same institution.")
  preferred <- trimws(overrides$preferred_name)
  clean <- dn_name_clean(preferred)
  expanded <- dn_name_expand(clean)
  if (any(!nzchar(expanded))) stop("Preferred museum name must contain a usable name.")
  core <- dn_name_core(expanded, gazetteer)
  x$alt_names[idx] <- vapply(seq_along(idx), function(i) {
    k <- idx[i]
    aliases <- c(x$primary_name[k], unlist(strsplit(x$alt_names[k], "\\s*\\|\\s*")))
    aliases <- sort(unique(aliases[!is.na(aliases) & nzchar(aliases)]))
    paste(setdiff(aliases, preferred[i]), collapse = " | ")
  }, character(1))
  x$primary_name[idx] <- preferred
  x$name_clean[idx] <- clean
  x$name_expanded[idx] <- expanded
  x$name_core[idx] <- core
  x$name_key[idx] <- dn_name_key(core)
  x$scope_claim[idx] <- dn_parse_scope_claim(clean)
  x$ordinal[idx] <- dn_parse_ordinal(expanded)
  x$name_override_evidence[idx] <- overrides$evidence_url
  x
}
