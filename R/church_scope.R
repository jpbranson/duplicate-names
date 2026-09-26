# Narrow factual scope corrections; automatic matching and source facts stay intact.
# A supported scope exclusion is not a complete identity review or accuracy label.
dn_apply_church_scope <- function(analysis, records, decisions) {
  out <- analysis
  out$scope_review_evidence <- NA_character_
  if (!nrow(decisions)) return(out)
  need <- c('source', 'source_id', 'expected_name', 'expected_entity_id',
    'expected_coordinates', 'decision', 'evidence_url', 'evidence_note',
    'reviewed_by', 'reviewed_on')
  if (!all(need %in% names(decisions))) stop('Church scope decision columns missing')
  if (anyNA(decisions[,need]) || any(!nzchar(trimws(unlist(decisions[,need])))))
    stop('Church scope decisions require complete guards and evidence')
  if (any(decisions$decision != 'outside_christian_scope') ||
      any(!grepl('^https?://', decisions$evidence_url)))
    stop('Unsupported church scope decision or evidence')
  key <- function(x) paste(x$source, x$source_id, sep = ':')
  if (anyDuplicated(key(decisions))) stop('Duplicate church scope source key')
  i <- match(key(decisions), key(records))
  if (anyNA(i)) stop('Church scope source missing')
  if (any(decisions$expected_name != records$name_raw[i]) ||
      any(decisions$expected_entity_id != records$entity_id[i]) ||
      any(decisions$expected_coordinates != sprintf('%.7f,%.7f', records$lon[i], records$lat[i])))
    stop('Stale church scope guard')
  for (id in unique(decisions$expected_entity_id)) {
    d <- decisions[decisions$expected_entity_id == id, ]
    members <- records[records$entity_id == id, ]
    if (!setequal(key(d), key(members))) stop('Church scope decision requires every cluster member')
    row <- which(out$entity_id == id)
    if (length(row) != 1L) stop('Church scope requires one analysis row per entity')
    # Preserve any earlier exclusion reason, and attach this factual evidence.
    if (out$analysis_eligible[row]) out$analysis_exclusion[row] <- 'outside_christian_scope_source_review'
    out$analysis_eligible[row] <- FALSE
    out$scope_review_evidence[row] <- paste(unique(d$evidence_url), collapse = ' | ')
  }
  out
}
