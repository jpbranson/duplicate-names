# resolve.R ---------------------------------------------------------------
# §4.3. One institution appearing in several sources must not count as several
# duplicates. This is the largest correctness risk in the project: an
# under-merge inflates every duplicate count, and inflated counts are exactly
# the finding we would most like to be true.
#
# Two distinct groupings, deliberately separated:
#
#   SITE   — records at the same place. Cross-source agreement lives here:
#            Overture and IMLS describing the same building.
#   ENTITY — one institution, which may occupy more than one site.
#
# The International Cryptozoology Museum is why the second layer exists. It
# opened its new Bangor home in June 2026, and Overture still carries the
# Portland address marked "open". (The 2016 move was within Portland.) Without
# an entity layer above sites, that can read as two independent museums.

DN_SITE_RADIUS_M <- 150   # records within this distance may be the same place

# Name-similarity floor for merging two records at the same location.
# Retained after the independent September 15 pair-label sample. That sample
# does not validate final clusters or multi-site matching; see the report.
DN_NAME_SIM_MIN <- 0.85

# A name found at more sites than this is a generic label, not one
# institution with branches. Below it, same-name sites merge into one entity.
# Deliberately small: over-merging silently deletes real museums from the
# count, which is a worse error than leaving two branches unmerged.
DN_MULTISITE_MAX <- 3L

# A relocation stays regional. Portland -> Bangor is 220 km; nothing legitimate
# spans an ocean, so same-name sites farther apart than this never merge.
DN_MULTISITE_MAX_KM <- 600

# A token appearing in more names than this is a generic museum word rather
# than an identity: "museum", "art" and "county" are everywhere,
# "cryptozoology" is not.
DN_RARE_TOKEN_MAX <- 25L

#' Resolve records into sites, then sites into entities
dn_resolve <- function(normalized, radius_m = DN_SITE_RADIUS_M) {
  dn_validate(normalized, dn_schema_normalized(), label = "resolve input")

  if (nrow(normalized) == 0L) {
    return(dn_validate(
      dplyr::bind_cols(normalized, dn_empty_entity_cols(0L)),
      dn_schema_entity(), label = "entities"))
  }

  x <- normalized
  x$.row <- seq_len(nrow(x))

  # --- 1. sites: geographically close AND similarly named ---------------
  # Blocking is geographic rather than by name. Sources disagree about names
  # far more often than about locations, so an exact-name block never puts an
  # Overture record and its IMLS counterpart in the same bucket to compare.
  x$site_id <- dn_cluster_sites(x, radius_m)

  # --- 2. entities: sites sharing a DISTINCTIVE name --------------------
  # Merging every site that shares a name is wrong, and wrong at scale: dozens
  # of unrelated "Art Gallery" records across the country are not one
  # institution with dozens of branches. But three sites called "International
  # Cryptozoology Museum" almost certainly ARE one institution that moved.
  #
  # Rarity is what separates them. A name found at many distant sites is a
  # generic label; a name found at one or two is an identity. Above the
  # threshold each site stands alone; at or below it, sites merge and
  # dn_flag_multisite_review() puts the result in front of a human.
  n_sites_for_name <- x |>
    dplyr::distinct(.data$name_key, .data$category, .data$site_id) |>
    dplyr::count(.data$name_key, .data$category, name = "n_name_sites")

  x <- dplyr::left_join(x, n_sites_for_name, by = c("name_key", "category"))

  # Site count alone is not enough. "State Art Museum" occurs at three sites
  # ~8,000 km apart and is plainly three institutions; every token in it is a
  # generic museum word. "International Cryptozoology Museum" is three sites
  # too, but "cryptozoology" appears in a handful of names nationwide.
  #
  # So require a DISTINCTIVE token — one rare across the corpus — and cap the
  # geographic spread. A museum can relocate across a state (Portland to
  # Bangor is 220 km); it does not relocate across an ocean.
  x$has_rare_token <- dn_has_rare_token(x$name_key)
  spread <- x |>
    dplyr::group_by(.data$name_key, .data$category) |>
    dplyr::summarise(name_spread_km = dn_pairwise_km(.data$lon, .data$lat),
                     .groups = "drop")
  x <- dplyr::left_join(x, spread, by = c("name_key", "category"))

  mergeable <- x$n_name_sites <= DN_MULTISITE_MAX &
    x$has_rare_token &
    x$name_spread_km <= DN_MULTISITE_MAX_KM

  key <- dplyr::if_else(
    mergeable,
    paste(x$name_key, x$category, sep = "|"),        # one entity, many sites
    paste(x$site_id, x$category, sep = "|")          # each site its own entity
  )
  x$entity_id <- vapply(key,
    function(k) substr(digest::digest(k, algo = "xxhash64"), 1, 12),
    character(1), USE.NAMES = FALSE)
  x$n_name_sites <- NULL; x$has_rare_token <- NULL; x$name_spread_km <- NULL

  # --- 3. per-entity rollups -------------------------------------------
  x <- x |>
    dplyr::group_by(.data$entity_id) |>
    dplyr::mutate(
      n_sources  = dplyr::n_distinct(.data$source),
      source_set = paste(sort(unique(.data$source)), collapse = "|"),
      n_sites    = dplyr::n_distinct(.data$site_id)
    ) |>
    dplyr::ungroup()

  # --- 4. which site is the institution actually at now? ---------------
  # Rank sites by freshness, then confidence. This is what correctly picks
  # Bangor (0.98, updated 2026-08) over the two Portland ghosts (0.88 and
  # 0.77, updated 2025-08).
  site_rank <- x |>
    dplyr::group_by(.data$entity_id, .data$site_id) |>
    dplyr::summarise(
      site_update = suppressWarnings(max(.data$source_update_time, na.rm = TRUE)),
      site_conf   = suppressWarnings(max(.data$confidence, na.rm = TRUE)),
      any_closed  = any(.data$operating_status %in% "permanently_closed"),
      .groups = "drop"
    ) |>
    dplyr::mutate(
      site_update = dplyr::if_else(is.finite(as.numeric(.data$site_update)),
                                   .data$site_update, as.Date(NA)),
      site_conf   = dplyr::if_else(is.finite(.data$site_conf), .data$site_conf, NA_real_)
    ) |>
    dplyr::group_by(.data$entity_id) |>
    # Closed sites lose to open ones regardless of freshness.
    dplyr::arrange(.data$any_closed,
                   dplyr::desc(.data$site_update),
                   dplyr::desc(.data$site_conf),
                   .by_group = TRUE) |>
    dplyr::mutate(is_primary_site = dplyr::row_number() == 1L) |>
    dplyr::ungroup() |>
    dplyr::select("entity_id", "site_id", "is_primary_site")

  x <- dplyr::left_join(x, site_rank, by = c("entity_id", "site_id"))

  # --- 5. display name and alternates ----------------------------------
  # "Merged under the museum": where an entity's records include a museum-type
  # name, that name leads. Ties break on freshness, then confidence. Every
  # other distinct name is kept in alt_names for the map footnote.
  x <- x |>
    dplyr::group_by(.data$entity_id) |>
    dplyr::mutate(
      .is_museum = dn_institution_type(.data$name_expanded) %in% c("museum", "museums"),
      .ord = order(order(!.data$.is_museum,
                         dplyr::desc(.data$source_update_time),
                         dplyr::desc(dplyr::coalesce(.data$confidence, -1)))),
      primary_name = .data$name_raw[which.min(.data$.ord)],
      alt_names = paste(setdiff(unique(.data$name_raw), .data$primary_name[1]),
                        collapse = " | ")
    ) |>
    dplyr::ungroup() |>
    dplyr::select(-".is_museum", -".ord")

  out <- x |>
    dplyr::mutate(
      is_franchise     = FALSE,          # set by dn_flag_franchises()
      chain_id         = NA_character_,
      state_fips       = NA_character_,
      county_fips      = NA_character_,
      place_geoid      = NA_character_,
      place_name       = NA_character_,
      counted          = NA,             # set by dn_apply_counting_policy()
      exclusion_reason = NA_character_
    ) |>
    dplyr::select(-".row")

  dn_validate(out, dn_schema_entity(), label = "entities")
}

#' Similarity between two institution names
#'
#' Two measures, because the sources fail in different ways.
#'
#'   Jaro-Winkler catches spelling and punctuation drift between two records
#'   of the same signage name.
#'
#'   Token containment catches the signage-vs-legal-name gap (§6.1), which
#'   edit distance handles badly: "springfield art museum" against
#'   "springfield art museum association incorporated" is a long edit distance
#'   but perfect containment. IMLS carries legal names, so this case is not an
#'   edge case here — it is most of the cross-source work.
#'
#' The maximum of the two is used: either kind of agreement is agreement.
dn_name_similarity <- function(a, b) {
  jw <- 1 - stringdist::stringdist(a, b, method = "jw", p = 0.1)

  ta <- stringi::stri_split_fixed(a, " ")
  tb <- stringi::stri_split_fixed(b, " ")
  contain <- vapply(seq_along(ta), function(i) {
    x <- setdiff(unique(ta[[i]]), DN_NAME_STOPWORDS)
    y <- setdiff(unique(tb[[i]]), DN_NAME_STOPWORDS)
    if (!length(x) || !length(y)) return(0)
    length(intersect(x, y)) / min(length(x), length(y))
  }, numeric(1))

  # Third measure: compare with the institution-TYPE word removed.
  #
  # "Washington County Historical Museum" and "Washington County Historical
  # Society" are one physical institution — the society runs the museum, in
  # the same building. Both reduce to "washington county historical", so this
  # merges them while the other two measures do not.
  #
  # Guarded by requiring at least two tokens to survive on both sides, so
  # "Springfield Museum" and "Springfield Society" do not collapse to
  # "springfield" and match everything nearby. Proximity does the rest: these
  # pairs are only ever compared within 150m.
  ca <- dn_strip_institution_type(a)
  cb <- dn_strip_institution_type(b)
  ok <- lengths(stringi::stri_split_fixed(ca, " ")) >= 2L &
        lengths(stringi::stri_split_fixed(cb, " ")) >= 2L
  type_sim <- ifelse(ok, 1 - stringdist::stringdist(ca, cb, method = "jw", p = 0.1), 0)

  pmax(jw, contain, type_sim, na.rm = TRUE)
}

DN_NAME_STOPWORDS <- c("of", "the", "at", "in", "and", "a", "inc",
                       "incorporated", "association", "foundation", "trust")

# Words naming what KIND of body an institution is, rather than which one.
# Two records at one address differing only in this word are one place.
DN_INSTITUTION_TYPES <- c(
  "museum", "museums", "society", "center", "centre", "association",
  "foundation", "institute", "archives", "archive", "collection",
  "collections", "trust", "inc", "incorporated", "corporation"
)

dn_strip_institution_type <- function(x) {
  vapply(stringi::stri_split_fixed(x, " "), function(tk) {
    paste(tk[!tk %in% DN_INSTITUTION_TYPES & nzchar(tk)], collapse = " ")
  }, character(1), USE.NAMES = FALSE)
}

#' Which kind of body does this name describe?
#'
#' Used to choose the entity's display name. The physical institution is the
#' subject of the analysis, so where a site has both, the museum name leads and
#' the society name is kept as an alternate.
dn_institution_type <- function(x) {
  tok <- stringi::stri_split_fixed(x, " ")
  vapply(tok, function(tk) {
    hit <- intersect(DN_INSTITUTION_TYPES, tk)
    if (!length(hit)) return(NA_character_)
    hit[1]
  }, character(1), USE.NAMES = FALSE)
}

#' Cluster records into sites: geographically close AND similarly named
#'
#' Blocking is geographic, not by name. That is the inversion that makes
#' cross-source matching work at all: Overture and IMLS frequently disagree
#' about a museum's name but rarely about where it is, so an exact-name block
#' never puts the two records in the same bucket to be compared.
#'
#' Distances come from sf on s2 geometry — true great-circle metres. Do not
#' project to a national CRS and measure Euclidean distance (DESIGN.md §7).
dn_cluster_sites <- function(x, radius_m, min_sim = DN_NAME_SIM_MIN) {
  pts  <- sf::st_as_sf(x[, c("lon", "lat")], coords = c("lon", "lat"), crs = 4326)
  near <- sf::st_is_within_distance(pts, dist = units::set_units(radius_m, "m"))

  n <- nrow(x)
  adj <- vector("list", n)
  for (i in seq_len(n)) {
    cand <- near[[i]]
    cand <- cand[cand > i]                     # each pair considered once
    if (!length(cand)) { adj[[i]] <- integer(0); next }
    sim <- dn_name_similarity(rep(x$name_expanded[i], length(cand)),
                              x$name_expanded[cand])
    adj[[i]] <- cand[sim >= min_sim]
  }

  # Symmetrise, then take connected components.
  sym <- vector("list", n)
  for (i in seq_len(n)) for (j in adj[[i]]) {
    sym[[i]] <- c(sym[[i]], j); sym[[j]] <- c(sym[[j]], i)
  }

  comp <- integer(n); k <- 0L
  for (i in seq_len(n)) {
    if (comp[i] != 0L) next
    k <- k + 1L
    stack <- i
    while (length(stack)) {
      j <- stack[1]; stack <- stack[-1]
      if (comp[j] != 0L) next
      comp[j] <- k
      nb <- sym[[j]]
      if (length(nb)) stack <- c(stack, nb[comp[nb] == 0L])
    }
  }
  sprintf("s%06d", comp)
}

dn_empty_entity_cols <- function(n) {
  tibble::tibble(
    entity_id = character(n), n_sources = integer(n), source_set = character(n),
    is_franchise = logical(n), chain_id = character(n),
    site_id = character(n), n_sites = integer(n), is_primary_site = logical(n),
    primary_name = character(n), alt_names = character(n),
    counted = logical(n), exclusion_reason = character(n),
    state_fips = character(n), county_fips = character(n),
    place_geoid = character(n), place_name = character(n)
  )
}

#' Apply the counting policy
#'
#' Exclusions are FLAGS, not deletions: every excluded record stays in the
#' published dataset with its reason attached, so a reader can audit the
#' decision or reverse it. Headline numbers are computed over counted == TRUE.
dn_apply_counting_policy <- function(entities, stale_before = NULL) {
  if (nrow(entities) == 0L) return(entities)

  # A record attested only by a source that stopped updating years ago is not
  # evidence the institution exists now. IMLS froze in 2018.
  stale_before <- stale_before %||% (Sys.Date() - 365 * 5)

  entities |>
    dplyr::mutate(
      exclusion_reason = dplyr::case_when(
        .data$operating_status %in% "permanently_closed" ~ "permanently_closed",
        !.data$is_primary_site                           ~ "non_primary_site",
        is.na(.data$name_core) | !nzchar(.data$name_core) ~ "no_name",
        TRUE                                             ~ NA_character_
      ),
      counted = is.na(.data$exclusion_reason)
    )
}

#' Franchise / branch detection (§4.4)
#'
#' Held separate from resolution on purpose: two Ripley's are genuinely two
#' institutions, so they must NOT merge — they only have to be excluded from
#' the "independent collision" headline, which is a labelling job.
dn_flag_franchises <- function(entities, rules = dn_schema_chain_rules()) {
  evidence <- dn_affiliation_evidence(entities, rules)
  idx <- match(entities$entity_id, evidence$entity_id)
  # NA means unreviewed, not independent. Only a sourced rule establishes
  # affiliation; a nonempty operator or a repeated template cannot do that.
  entities$is_franchise <- ifelse(!is.na(evidence$chain_id[idx]), TRUE, NA)
  entities$chain_id <- evidence$chain_id[idx]
  entities
}

#' Entities whose sites are far apart — for manual review
#'
#' A relocation and two unrelated same-named museums are indistinguishable from
#' names and coordinates. This is the list a human has to look at, and it is
#' short enough to be worth doing before anything is published.
dn_flag_multisite_review <- function(entities, min_km = 25) {
  if (nrow(entities) == 0L) return(entities[0, ])
  entities |>
    dplyr::filter(.data$n_sites > 1L) |>
    dplyr::group_by(.data$entity_id, .data$name_core) |>
    dplyr::summarise(
      n_sites = dplyr::first(.data$n_sites),
      spread_km = round(max(dn_pairwise_km(.data$lon, .data$lat)), 1),
      .groups = "drop"
    ) |>
    dplyr::filter(.data$spread_km >= min_km) |>
    dplyr::arrange(dplyr::desc(.data$spread_km))
}

#' Does a name contain at least one token that is rare across the corpus?
#'
#' Rarity is what turns a shared name into evidence of shared identity.
#' Without it, any few sites sharing a generic name merge into one institution
#' and the rest silently vanish from the count.
dn_has_rare_token <- function(name_key) {
  toks <- stringi::stri_split_fixed(name_key, " ")
  df <- table(unlist(lapply(toks, unique)))
  vapply(toks, function(tk) {
    tk <- tk[nzchar(tk)]
    if (!length(tk)) return(FALSE)
    any(as.integer(df[tk]) <= DN_RARE_TOKEN_MAX, na.rm = TRUE)
  }, logical(1))
}

dn_pairwise_km <- function(lon, lat) {
  if (length(lon) < 2L) return(0)
  p <- sf::st_as_sf(data.frame(lon, lat), coords = c("lon", "lat"), crs = 4326)
  as.numeric(max(sf::st_distance(p))) / 1000
}

#' Attach Census geography — the C2 denominator (Phase 1b)
dn_attach_places <- function(entities, places = NULL) {
  # TODO(phase-1b): tigris::places() + sf::st_join. Museums do not need this;
  # the municipal exclusivity test is a churches metric.
  entities
}
