# resolve.R ---------------------------------------------------------------
# §4.3. One institution appearing in Overture + OSM + GNIS + HIFLD must not
# count as four duplicates. This is the largest correctness risk in the project
# (DESIGN.md §4.3) — an under-merge inflates every duplicate count in both
# posts, and inflated counts are exactly the finding we would most want to be
# true, which is why it needs a measured error rate rather than a spot check.
#
# STUB — Phase 1.

DN_RESOLVE_RADIUS_M <- 150  # starting threshold; tune against a labelled sample

#' Resolve records across sources into entities
dn_resolve <- function(normalized, radius_m = DN_RESOLVE_RADIUS_M) {
  dn_validate(normalized, dn_schema_normalized(), label = "resolve input")

  # TODO(phase-1):
  #   1. block on name_key to keep the pairwise comparison tractable
  #   2. within a block, cluster by distance <= radius_m using sf::st_is_within_distance
  #      on s2 geometry (NOT a projection — see DESIGN.md §7)
  #   3. break ties with address where available
  #   4. entity_id = stable hash of the member source ids, so re-runs are stable
  #   5. n_sources / source_set = the cross-source agreement quality signal

  out <- dplyr::bind_cols(
    normalized,
    tibble::tibble(
      entity_id    = character(nrow(normalized)),
      n_sources    = integer(nrow(normalized)),
      source_set   = character(nrow(normalized)),
      is_franchise = logical(nrow(normalized)),
      chain_id     = character(nrow(normalized)),
      state_fips   = character(nrow(normalized)),
      county_fips  = character(nrow(normalized)),
      place_geoid  = character(nrow(normalized)),
      place_name   = character(nrow(normalized))
    )
  )

  dn_validate(out, dn_schema_entity(), label = "entities")
}

#' Franchise / branch detection (§4.4)
#'
#' Held separate from resolution on purpose: two Ripley's are genuinely two
#' institutions, so they must NOT merge — they just have to be excluded from
#' the "independent collision" headline, which is a labelling job, not a
#' merging one.
dn_flag_franchises <- function(entities) {
  # TODO(phase-2): shared operator, shared Wikidata parent, known-chain lexicon,
  # and productive templates ("Children's Museum of X", "X County Historical").
  entities
}

#' Attach Census geography — the C2 denominator
#'
#' The municipal exclusivity rate needs every congregation assigned to a place,
#' and every place that has congregations at all counted, including the ones
#' with exactly one. Joining only to occupied places would silently drop the
#' denominator and turn the headline result into a tautology.
dn_attach_places <- function(entities, places = NULL) {
  # TODO(phase-1): tigris::places() per state, sf::st_join, keep the full
  # place list separately as the denominator.
  entities
}
