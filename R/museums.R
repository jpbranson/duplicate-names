# Phase 2 interpretation is separate from resolution. No matching thresholds,
# entity IDs, source records, or independent resolution labels change here.

DN_CATEGORY_ONLY <- c(
  "museum", "museums", "gallery", "art gallery", "fine arts gallery",
  "university art gallery", "art museum", "history museum", "science museum",
  "natural history museum", "museum of natural history", "museum of anthropology",
  "children's museum", "childrens museum", "planetarium"
)

# Deliberately bounded vocabulary. Unknown topics remain NA. Multiple detected
# subjects survive as pipe-separated values; these are name-derived hypotheses.
DN_SUBJECT_PATTERNS <- c(
  cryptozoology = "\\bcryptozoology\\b",
  natural_history = "\\bnatural (history|science)\\b",
  children = "\\bchildren'?s?\\b",
  fire = "\\b(fire|firefighting|firefighter[s]?|firemen[s]?)\\b",
  railroad = "\\b(railroad|railway|railways|railroads|rail)\\b",
  quilts = "\\bquilts?\\b",
  barbed_wire = "\\bbarbed wire\\b",
  aviation = "\\b(aviation|aerospace|aircraft|flight)\\b",
  maritime = "\\b(maritime|nautical|seaport)\\b",
  military = "\\b(military|veterans?|civil war|vietnam war|army|naval)\\b",
  anthropology = "\\b(anthropology|archaeology|archeology)\\b",
  art = "\\b(art|arts)\\b",
  science = "\\b(science|technology|planetarium)\\b",
  history = "\\b(history|historical|heritage)\\b",
  botany = "\\b(botanical|arboretum)\\b",
  zoology = "\\b(zoo|zoological|aquarium)\\b"
)

dn_extract_subject <- function(name_core, category = rep("museum", length(name_core))) {
  if (!length(name_core)) return(character())
  hits_by_topic <- lapply(DN_SUBJECT_PATTERNS, function(p) grepl(p, name_core, perl = TRUE))
  matched <- do.call(cbind, hits_by_topic)
  matched[is.na(name_core) | !category %in% "museum", ] <- FALSE
  matched[matched[, "natural_history"], c("history", "science")] <- FALSE
  vapply(seq_along(name_core), function(i) {
    hits <- colnames(matched)[matched[i, ]]
    if (!length(hits)) NA_character_ else paste(hits, collapse = "|")
  }, character(1), USE.NAMES = FALSE)
}

dn_naming_template <- function(x) {
  dplyr::case_when(
    grepl("\\bcounty historical (society|museum)\\b", x) ~ "county_historical",
    grepl("^children'?s? museum of .+", x) ~ "children_of_place",
    TRUE ~ "other"
  )
}

dn_read_museum_review <- function(path, proto) {
  x <- readr::read_csv(path, col_types = readr::cols(.default = readr::col_character()),
                       show_col_types = FALSE, na = c("", "NA"))
  dn_validate(x, proto, label = basename(path))
}

dn_affiliation_evidence <- function(entities, rules = dn_schema_chain_rules()) {
  dn_validate(rules, dn_schema_chain_rules())
  if (anyDuplicated(rules$rule_id) || any(!rules$match_on %in% c("name", "operator", "candidate")) ||
      any(is.na(rules$pattern) | !nzchar(rules$pattern)) ||
      any(is.na(rules$evidence_url) | !grepl("^https://", rules$evidence_url)) ||
      any(is.na(rules$chain_id) | is.na(rules$rule_id)) ||
      any(is.na(rules$reviewed_by) | is.na(rules$reviewed_on))) {
    stop("Chain rules require unique IDs, valid match modes and sourced review metadata.")
  }
  # Evaluate each original record, then propagate evidence across its entity.
  # Never infer that the operator of one entity controls a similarly named one.
  out <- tibble::tibble(entity_id = unique(entities$entity_id),
                        chain_id = NA_character_, affiliation_evidence = NA_character_,
                        chain_candidate = NA_character_)
  name <- dn_name_expand(dn_name_clean(entities$name_raw))
  operator <- dn_name_clean(entities$operator)
  for (i in seq_len(nrow(rules))) {
    value <- if (rules$match_on[i] == "operator") operator else name
    ids <- unique(entities$entity_id[which(grepl(rules$pattern[i], value, perl = TRUE))])
    idx <- match(ids, out$entity_id)
    if (rules$match_on[i] == "candidate") {
      out$chain_candidate[idx] <- rules$chain_id[i]
    } else {
      previous <- out$chain_id[idx]
      if (any(!is.na(previous) & previous != rules$chain_id[i])) {
        stop("Conflicting chain rules for an entity; resolve the evidence before counting.")
      }
      out$chain_id[idx] <- rules$chain_id[i]
      out$affiliation_evidence[idx] <- rules$evidence_url[i]
    }
  }
  out
}

# One counted location, one canonical name, one vote. The saved entities target
# has multiple source rows per entity; distinct(entity_id, name) is insufficient
# because it still gives aliases extra votes. Keep wholly excluded entities too.
dn_canonical_entities <- function(entities) {
  canonical <- entities |>
    dplyr::arrange(.data$entity_id, dplyr::desc(.data$name_raw == .data$primary_name),
                   dplyr::desc(.data$source_update_time), dplyr::desc(.data$confidence),
                   .data$source, .data$source_id) |>
    dplyr::distinct(.data$entity_id, .keep_all = TRUE)
  fields <- c("name_clean", "name_expanded", "name_core", "name_key", "scope_claim", "subject")
  out <- entities |>
    dplyr::arrange(.data$entity_id, dplyr::desc(.data$counted),
                   dplyr::desc(.data$is_primary_site),
                   dplyr::desc(.data$source_update_time), dplyr::desc(.data$confidence),
                   .data$source, .data$source_id) |>
    dplyr::distinct(.data$entity_id, .keep_all = TRUE)
  out[fields] <- canonical[match(out$entity_id, canonical$entity_id), fields]
  out
}

# IMLS discipline is an independent coarse comparison, not a gold label for
# the topic phrase. GMU means general/uncategorized: never call it agreement.
dn_subject_check <- function(subject, disciplines) {
  expected <- list(natural_history = "NAT", children = "CMU", art = "ART",
                   science = "SCI", history = c("HST", "HSC"),
                   botany = "BOT", zoology = "ZAW")
  vapply(seq_along(subject), function(i) {
    if (is.na(subject[i])) return("no_name_subject")
    if (is.na(disciplines[i]) || !nzchar(disciplines[i])) return("no_imls")
    topics <- strsplit(subject[i], "|", fixed = TRUE)[[1]]
    codes <- strsplit(disciplines[i], "|", fixed = TRUE)[[1]]
    compare <- unique(unlist(expected[intersect(topics, names(expected))]))
    if (!length(compare) || all(codes %in% "GMU")) return("not_comparable")
    if (any(codes %in% compare)) "compatible" else "review"
  }, character(1), USE.NAMES = FALSE)
}

dn_museum_analysis <- function(entities, rules = dn_schema_chain_rules(),
                               decisions = dn_schema_museum_decisions()) {
  dn_validate(entities, dn_schema_entity())
  dn_validate(decisions, dn_schema_museum_decisions())
  records <- dplyr::filter(entities, .data$category == "museum")
  x <- dn_canonical_entities(records)
  affiliations <- dn_affiliation_evidence(records, rules)
  j <- match(x$entity_id, affiliations$entity_id)
  x$chain_id <- affiliations$chain_id[j]
  x$is_franchise <- ifelse(!is.na(x$chain_id), TRUE, NA)
  x$category_only <- x$name_expanded %in% DN_CATEGORY_ONLY
  x$category_decision <- dplyr::if_else(x$category_only, "pending", "not_flagged")
  x$affiliation_status <- dplyr::if_else(x$is_franchise %in% TRUE, "chain", "unknown")
  x$affiliation_evidence <- affiliations$affiliation_evidence[j]
  x$chain_candidate <- affiliations$chain_candidate[j]
  x$naming_template <- dn_naming_template(x$name_expanded)
  disciplines <- records |>
    dplyr::filter(.data$source == "imls", !is.na(.data$category_raw)) |>
    dplyr::group_by(.data$entity_id) |>
    dplyr::summarise(imls_disciplines = paste(sort(unique(.data$category_raw)), collapse = "|"),
                     .groups = "drop")
  x$imls_disciplines <- disciplines$imls_disciplines[match(x$entity_id, disciplines$entity_id)]
  x$subject <- dn_extract_subject(x$name_core)
  x$subject_check <- dn_subject_check(x$subject, x$imls_disciplines)
  x$review_status <- rep("pending", nrow(x))
  x$review_evidence <- rep(NA_character_, nrow(x))
  x$review_note <- rep(NA_character_, nrow(x))
  if (nrow(decisions)) {
    key <- paste(records$source, records$source_id, sep = ":")
    idx <- match(paste(decisions$source, decisions$source_id, sep = ":"), key)
    if (anyNA(idx) || anyNA(decisions$expected_name) ||
        any(decisions$expected_name != records$name_raw[idx])) {
      stop("Stale museum decision: source record missing or expected_name changed.")
    }
    ids <- records$entity_id[idx]
    if (anyDuplicated(ids)) stop("Multiple decisions address the same museum entity.")
    if (any(!decisions$category_decision %in% c("pending", "confirmed_name", "placeholder", "historical_name", "not_flagged")) ||
        any(!decisions$affiliation_status %in% c("unknown", "chain", "independent")) ||
        any(!decisions$review_status %in% c("pending", "verified")) ||
        any(is.na(decisions$evidence_url) | !grepl("^https://", decisions$evidence_url)) ||
        any(is.na(decisions$reviewed_by) | is.na(decisions$reviewed_on))) {
      stop("Museum decisions require valid statuses, evidence and reviewer/date.")
    }
    if (any(decisions$affiliation_status == "chain" & is.na(decisions$chain_id))) {
      stop("Affiliated decisions require a chain_id.")
    }
    if (any(decisions$review_status == "verified" &
            (decisions$category_decision == "pending" | decisions$affiliation_status == "unknown"))) {
      stop("Verified institution review requires resolved category and affiliation decisions.")
    }
    k <- match(ids, x$entity_id)
    x$category_decision[k] <- decisions$category_decision
    x$affiliation_status[k] <- decisions$affiliation_status
    x$chain_id[k] <- ifelse(decisions$affiliation_status == "chain", decisions$chain_id, NA_character_)
    x$is_franchise[k] <- ifelse(decisions$affiliation_status == "unknown", NA,
                                decisions$affiliation_status == "chain")
    x$affiliation_evidence[k] <- decisions$evidence_url
    x$review_status[k] <- decisions$review_status
    x$review_evidence[k] <- decisions$evidence_url
    x$review_note[k] <- decisions$note
  }
  x$analysis_exclusion <- dplyr::case_when(
    !x$counted ~ x$exclusion_reason,
    x$category_only & x$category_decision %in% c("pending", "not_flagged") ~ "category_pending",
    x$category_decision == "placeholder" ~ "confirmed_placeholder",
    x$category_decision == "historical_name" ~ "historical_name",
    TRUE ~ NA_character_
  )
  x$analysis_eligible <- x$counted & is.na(x$analysis_exclusion)
  dn_validate(x, dn_schema_museum_analysis(), label = "museum analysis")
}

dn_museum_ranking <- function(x, eligible_only = TRUE) {
  if (eligible_only) x <- dplyr::filter(x, .data$analysis_eligible)
  x |>
    dplyr::filter(.data$counted, !is.na(.data$name_expanded), nzchar(.data$name_expanded)) |>
    dplyr::group_by(.data$name_expanded) |>
    dplyr::summarise(
      n_entities = dplyr::n_distinct(.data$entity_id),
      n_chain = sum(.data$affiliation_status == "chain"),
      n_independent_verified = sum(.data$affiliation_status == "independent" & .data$review_status == "verified"),
      n_affiliation_unknown = sum(.data$affiliation_status == "unknown"),
      n_category_pending = sum(.data$category_only & .data$category_decision == "pending"),
      n_multisite = sum(.data$n_sites > 1L),
      n_review_pending = sum(.data$review_status != "verified"),
      publication_ready = all(.data$review_status == "verified" & .data$analysis_eligible),
      .groups = "drop"
    ) |>
    dplyr::arrange(dplyr::desc(.data$n_entities), .data$name_expanded) |>
    dplyr::mutate(rank = dplyr::row_number(), .before = 1)
}

dn_museum_review_sheets <- function(analysis, records, ranking, n = 20L,
                                   imls_context = dn_schema_imls_context()) {
  # Include all ties at the cutoff. Keep the unfiltered top 20 as well so a
  # category holdout cannot silently disappear from the review assignment.
  take <- function(x) {
    if (!nrow(x)) return(character())
    x$name_expanded[x$n_entities >= x$n_entities[min(n, nrow(x))]]
  }
  m1_names <- union(take(ranking), take(dn_museum_ranking(analysis, FALSE)))
  m2 <- metric_singularity_collisions(analysis)
  m2_names <- if (nrow(m2)) m2$name_expanded[m2$n_candidates >= m2$n_candidates[min(n, nrow(m2))]] else character()
  seed <- "international cryptozoology museum"
  names <- union(union(m1_names, m2_names), seed)
  top <- analysis |> dplyr::filter(.data$name_expanded %in% names, .data$counted)
  top$review_scope <- ifelse(top$name_expanded %in% m1_names, "M1", "M2")
  top$review_scope[top$name_expanded == seed] <- "seed"
  top$map_url <- sprintf("https://www.google.com/maps?q=%.7f,%.7f", top$lat, top$lon)
  # Review every retained source record and excluded site behind these entities.
  source_rows <- records |> dplyr::filter(.data$entity_id %in% top$entity_id)
  # Also surface excluded same-L2 records with a different entity ID.
  source_rows <- dplyr::bind_rows(source_rows, records |>
    dplyr::filter(.data$name_expanded %in% names)) |>
    dplyr::distinct(.data$source, .data$source_id, .keep_all = TRUE) |>
    dplyr::left_join(imls_context, by = c("source", "source_id"))
  context <- source_rows |>
    dplyr::filter(.data$source == "imls", !is.na(.data$imls_city)) |>
    dplyr::group_by(.data$entity_id) |>
    dplyr::summarise(imls_location_2018 = paste(sort(unique(paste(.data$imls_city, .data$imls_state))), collapse = " | "),
      imls_parent_2018 = paste(sort(unique(stats::na.omit(.data$imls_parent))), collapse = " | "),
      .groups = "drop")
  top <- dplyr::left_join(top, context, by = "entity_id")
  # Keep source IDs attached to dossier summaries; multiple IMLS records in one
  # institution can disagree. A missing physical address stays missing.
  source_values <- function(values, ids) {
    keep <- !is.na(values) & nzchar(values)
    if (!any(keep)) return(NA_character_)
    paste(sort(unique(paste(ids[keep], values[keep], sep = ": "))), collapse = " | ")
  }
  details <- source_rows |>
    dplyr::filter(.data$source == "imls") |>
    dplyr::group_by(.data$entity_id) |>
    dplyr::summarise(dplyr::across(
      dplyr::all_of(c("imls_ein", "imls_physical_address", "imls_mailing_address")),
      ~ source_values(.x, .data$source_id), .names = "{.col}_2018"), .groups = "drop")
  top <- dplyr::left_join(top, details, by = "entity_id")
  multisite <- source_rows |> dplyr::filter(.data$n_sites > 1L)
  list(institutions = top, source_records = source_rows, multisite_records = multisite,
       nearby_pairs = dn_museum_nearby_pairs(top))
}

# Diagnostic sample for fresh independent labels. Nearby same-name entities
# may be separate museums, stale sites, duplicate POIs, or facilities on one
# campus. Distances do not adjudicate them and never feed back into matching.
dn_museum_nearby_pairs <- function(x, max_km = 25) {
  proto <- tibble::tibble(name_expanded = character(), entity_a = character(), entity_b = character(),
                          distance_km = double(), same_institution = character(),
                          evidence_url = character(), review_note = character())
  pairs <- lapply(split(x, x$name_expanded), function(group) {
    if (nrow(group) < 2L) return(proto)
    pts <- sf::st_as_sf(group, coords = c("lon", "lat"), crs = 4326)
    distances <- sf::st_distance(pts)
    idx <- which(upper.tri(distances) & distances <= units::set_units(max_km, "km"), arr.ind = TRUE)
    tibble::tibble(name_expanded = rep(group$name_expanded[1], nrow(idx)),
      entity_a = group$entity_id[idx[, 1]], entity_b = group$entity_id[idx[, 2]],
      distance_km = as.numeric(distances[idx]) / 1000,
      same_institution = rep(NA_character_, nrow(idx)), evidence_url = rep(NA_character_, nrow(idx)),
      review_note = rep(NA_character_, nrow(idx)))
  })
  dplyr::bind_rows(c(list(proto), pairs)) |>
    dplyr::arrange(.data$distance_km, .data$name_expanded)
}

metric_museum_subjects <- function(analysis) {
  analysis |>
    dplyr::filter(.data$analysis_eligible) |>
    dplyr::mutate(subject = dplyr::coalesce(.data$subject, "unclassified")) |>
    tidyr::separate_longer_delim("subject", delim = "|") |>
    dplyr::group_by(.data$subject) |>
    dplyr::summarise(n_entities = dplyr::n_distinct(.data$entity_id),
                     n_imls_comparable = sum(.data$subject_check %in% c("compatible", "review")),
                     n_imls_review = sum(.data$subject_check == "review"), .groups = "drop") |>
    dplyr::arrange(dplyr::desc(.data$n_entities), .data$subject)
}

dn_export_museum_review <- function(analysis, ranking, m2, subjects, sheets,
                                   directory = "data/processed/museum_review") {
  dir.create(directory, recursive = TRUE, showWarnings = FALSE)
  tables <- c(list(ranking = ranking, ranking_before_category_review = dn_museum_ranking(analysis, FALSE),
                   singularity_candidates = m2, subjects = subjects,
                   category_review = dplyr::filter(analysis, .data$category_only),
                   affiliation_summary = dplyr::count(analysis, .data$affiliation_status, .data$chain_id),
                   subject_review = dplyr::filter(analysis, .data$subject_check == "review")), sheets)
  paths <- file.path(directory, paste0(names(tables), ".csv"))
  for (i in seq_along(tables)) readr::write_csv(tables[[i]], paths[i], na = "")
  paths
}

# Publication requires completed factual identity/count review. An assistant can
# research official sources; a partial evidence note alone does not finish review.
# This status is never an independent human label or matching-accuracy measure.
dn_assert_museum_publication_ready <- function(analysis, name_values) {
  x <- dplyr::filter(analysis, .data$counted, .data$name_expanded %in% name_values)
  if (!length(name_values) || !all(name_values %in% x$name_expanded) ||
      any(!x$analysis_eligible | x$review_status != "verified" |
            x$affiliation_status == "unknown")) {
    stop("Museum headlines require completed identity, category and affiliation review.", call. = FALSE)
  }
  invisible(TRUE)
}
