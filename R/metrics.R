# metrics.R ---------------------------------------------------------------
# §5, pre-registered. One function per named metric, so a number in a post can
# be traced to exactly one definition rather than to an ad-hoc pipe in a chunk.

#' Duplicate counts, reported with a sensitivity band
#'
#' The band is not decoration. A collision that appears at L4 (token-sorted,
#' stopwords dropped) but not at L3 is a fuzzy-match artifact, and a headline
#' that only survives at L4 is not a headline (DESIGN.md §4.1).
#'
#' NOTE ON LEVEL CHOICE — the levels answer different questions, and for
#' museums the default is L2 (`name_expanded`), not L3.
#'
#' L3 strips place names, which is right for churches: in "First Baptist Church
#' of Springfield" the place is a qualifier on a name the denomination reuses
#' everywhere. It is wrong for museums, where the place name is usually part of
#' the institution's identity. Stripping turns "Pacific Tsunami Museum" into
#' "Tsunami Museum" and merges "Maui Art Gallery" with every other "Art
#' Gallery" in the country.
#'
#' So for museums:
#'   L2 (name_expanded) answers "which NAMES are duplicated"      <- M1, M2
#'   L3 (name_core)     compares names with geography stripped
#' M3 uses explicit subject extraction, not L3 name counts.
#'
#' `exclude_chains` drops locations with established chain affiliation, as the
#' museum headline does; the chains are reported separately.
metric_duplicate_counts <- function(entities, category = NULL,
                                    levels = c("name_expanded", "name_core", "name_key"),
                                    exclude_chains = FALSE) {
  if (!is.null(category)) {
    entities <- dplyr::filter(entities, .data$category %in% !!category)
  }
  entities <- dn_canonical_entities(entities) |>
    dplyr::filter(.data$counted)
  if ("analysis_eligible" %in% names(entities)) {
    entities <- dplyr::filter(entities, .data$analysis_eligible)
  }
  if (exclude_chains) entities <- dplyr::filter(entities, !.data$is_franchise %in% TRUE)
  out <- lapply(levels, function(lv) {
    entities |>
      dplyr::filter(!is.na(.data[[lv]]), nzchar(.data[[lv]])) |>
      dplyr::count(level = lv, name_value = .data[[lv]], name = "n_entities") |>
      dplyr::arrange(dplyr::desc(.data$n_entities), .data$name_value)
  })
  dplyr::bind_rows(out)
}

#' Singularity Collision Index (M2)
#'
#' L2 candidate collisions, with reviewed independence separated from unknowns.
#' Missing affiliation evidence must never become a claim of independence.
#' Chain locations are reported (n_affiliated) but excluded from n_candidates.
metric_singularity_collisions <- function(entities) {
  x <- dn_canonical_entities(entities) |>
    dplyr::filter(.data$counted, .data$category == "museum", !is.na(.data$scope_claim),
                  !is.na(.data$name_expanded), nzchar(.data$name_expanded))
  if ("analysis_eligible" %in% names(x)) x <- dplyr::filter(x, .data$analysis_eligible)
  x |>
    dplyr::group_by(.data$name_expanded, .data$scope_claim) |>
    dplyr::summarise(n_candidates = dplyr::n_distinct(.data$entity_id[!.data$is_franchise %in% TRUE]),
                     n_independent = sum(.data$is_franchise %in% FALSE),
                     n_affiliated = sum(.data$is_franchise %in% TRUE),
                     n_unknown = sum(is.na(.data$is_franchise)), .groups = "drop") |>
    dplyr::filter(.data$n_candidates > 1L) |>
    dplyr::arrange(dplyr::desc(.data$n_independent), dplyr::desc(.data$n_candidates),
                   .data$name_expanded)
}


#' Territory radius (C2): leave-one-out nearest same-name congregation on s2.
metric_territory_radius <- function(entities, name_value) {
  x <- dn_church_metric_rows(entities)
  x <- x[x$name_core %in% name_value,]
  x$neighbor_id <- NA_character_; x$distance_km <- NA_real_
  groups <- split(seq_len(nrow(x)),x$name_core)
  for (idx in groups) {
    if(length(idx)<2L) next
    nn <- dn_leave_one_out_s2(x$lon[idx],x$lat[idx])
    x$neighbor_id[idx] <- x$entity_id[idx[nn$neighbor]]
    x$distance_km[idx] <- nn$distance_m/1000
  }
  x[,c('entity_id','name_core','denom_norm','lon','lat','neighbor_id','distance_km')]
}

#' Municipal exclusivity: occupied denominator includes ZERO-First places.
#' Census CDPs are not municipalities; callers report a separate incorporated cut.
metric_municipal_exclusivity <- function(entities, all_places) {
  if(!'GEOID' %in% names(all_places) || anyDuplicated(all_places$GEOID)) stop('Unique Census place universe required')
  x <- dn_church_metric_rows(entities)
  if(any(!is.na(x$place_geoid) & !x$place_geoid %in% all_places$GEOID)) stop('Entity place absent from Census universe')
  occupied <- x |>
    dplyr::filter(!is.na(.data$place_geoid),!is.na(.data$denom_norm)) |>
    dplyr::group_by(.data$denom_norm,.data$place_geoid) |>
    dplyr::summarise(n_congregations=dplyr::n(),n_first=sum(.data$ordinal %in% 1L),.groups='drop')
  occupied |>
    dplyr::group_by(.data$denom_norm) |>
    dplyr::summarise(n_occupied_places=dplyr::n(),n_zero_first=sum(.data$n_first==0L),
      n_exactly_one_first=sum(.data$n_first==1L),n_multiple_first=sum(.data$n_first>=2L),
      exclusivity_rate=.data$n_exactly_one_first/.data$n_occupied_places,.groups='drop')
}

metric_ladder_completeness <- function(entities) {
  x <- dn_church_metric_rows(entities)
  if(any(!is.na(x$ordinal) & (x$ordinal<1L | x$ordinal!=floor(x$ordinal)))) stop('Positive integer ordinals required')
  x |>
    dplyr::filter(!is.na(.data$place_geoid),!is.na(.data$denom_norm),!is.na(.data$ordinal)) |>
    dplyr::group_by(.data$place_geoid,.data$place_name,.data$denom_norm) |>
    dplyr::summarise(max_ordinal=max(.data$ordinal),n_observed_rungs=dplyr::n_distinct(.data$ordinal),
      observed_rungs=paste(sort(unique(.data$ordinal)),collapse='|'),
      missing_rungs=paste(setdiff(seq_len(max(.data$ordinal)),unique(.data$ordinal)),collapse='|'),
      completeness=.data$n_observed_rungs/.data$max_ordinal,.groups='drop') |>
    dplyr::arrange(dplyr::desc(.data$max_ordinal),.data$place_geoid,.data$denom_norm)
}

metric_name_style_profile <- function(entities) {
  x <- dn_church_metric_rows(entities)
  x |>
    dplyr::mutate(denom_norm=dplyr::coalesce(.data$denom_norm,'unknown'),
      name_style=dplyr::coalesce(.data$name_style,'unclassified')) |>
    dplyr::count(.data$denom_norm,.data$name_style,name='n_entities') |>
    dplyr::group_by(.data$denom_norm) |>
    dplyr::mutate(n_family=sum(.data$n_entities),share=.data$n_entities/.data$n_family) |>
    dplyr::ungroup()
}

artifact_municipal_multiplicity <- function(entities) {
  x <- dn_church_metric_rows(entities)
  x |>
    dplyr::filter(!is.na(.data$place_geoid),!is.na(.data$denom_norm),.data$ordinal %in% 1L) |>
    dplyr::group_by(.data$place_geoid,.data$place_name,.data$denom_norm) |>
    dplyr::summarise(n_first=dplyr::n(),entity_ids=paste(sort(.data$entity_id),collapse='|'),
      names=paste(sort(unique(.data$primary_name)),collapse=' | '),.groups='drop') |>
    dplyr::filter(.data$n_first>=2L) |>
    dplyr::arrange(dplyr::desc(.data$n_first),.data$place_geoid)
}
