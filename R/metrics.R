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
metric_duplicate_counts <- function(entities, category = NULL,
                                    levels = c("name_expanded", "name_core", "name_key")) {
  if (!is.null(category)) {
    entities <- dplyr::filter(entities, .data$category %in% !!category)
  }
  entities <- dn_canonical_entities(entities) |>
    dplyr::filter(.data$counted)
  if ("analysis_eligible" %in% names(entities)) {
    entities <- dplyr::filter(entities, .data$analysis_eligible)
  }
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
metric_singularity_collisions <- function(entities) {
  x <- dn_canonical_entities(entities) |>
    dplyr::filter(.data$counted, .data$category == "museum", !is.na(.data$scope_claim),
                  !is.na(.data$name_expanded), nzchar(.data$name_expanded))
  if ("analysis_eligible" %in% names(x)) x <- dplyr::filter(x, .data$analysis_eligible)
  x |>
    dplyr::group_by(.data$name_expanded, .data$scope_claim) |>
    dplyr::summarise(n_candidates = dplyr::n_distinct(.data$entity_id),
                     n_independent = sum(.data$is_franchise %in% FALSE),
                     n_affiliated = sum(.data$is_franchise %in% TRUE),
                     n_unknown = sum(is.na(.data$is_franchise)), .groups = "drop") |>
    dplyr::filter(.data$n_candidates > 1L) |>
    dplyr::arrange(dplyr::desc(.data$n_independent), dplyr::desc(.data$n_candidates),
                   .data$name_expanded)
}

#' Territory radius (C2, descriptive half)
#'
#' Nearest-neighbour distance between same-name congregations, on s2 geometry.
#' Never project first — see DESIGN.md §7.
metric_territory_radius <- function(entities, name_value) {
  # TODO(phase-3): sf::st_nearest_feature + st_distance within each name class
  stop("metric_territory_radius(): Phase 3.", call. = FALSE)
}

#' Municipal exclusivity rate (C2, the actual test)
#'
#' Of all places holding at least one congregation of denomination D, what
#' fraction hold exactly one "First D Church"? This is the hypothesis the
#' churches post turns on: that the apparent spacing rule is really a
#' one-per-settlement rule, and observed distances are settlement distances.
#'
#' `all_places` is required rather than optional: computing this from occupied
#' places alone makes the denominator conditional on the numerator.
metric_municipal_exclusivity <- function(entities, all_places) {
  # TODO(phase-3)
  stop("metric_municipal_exclusivity(): Phase 3.", call. = FALSE)
}

#' Ordinal ladder completeness (C3)
#'
#' For each place with a maximum ordinal N, what share of 1..N is present?
#' Missing rungs are stories — mergers, closures, renames — but also possibly
#' data gaps, and the post has to be honest about not being able to tell those
#' apart from names alone.
metric_ladder_completeness <- function(entities) {
  # TODO(phase-3)
  stop("metric_ladder_completeness(): Phase 3.", call. = FALSE)
}

#' Naming-culture profile (C4)
metric_name_style_profile <- function(entities) {
  # TODO(phase-3)
  stop("metric_name_style_profile(): Phase 3.", call. = FALSE)
}

#' Places holding two or more "First <denomination>" congregations
#'
#' Emitted as a named artifact because it is the raw material for post 4
#' (DESIGN.md §5, §6.4), not because post 2 plots it directly.
artifact_municipal_multiplicity <- function(entities) {
  # TODO(phase-3)
  stop("artifact_municipal_multiplicity(): Phase 3.", call. = FALSE)
}
