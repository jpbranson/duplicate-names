# gazetteer.R -------------------------------------------------------------
# The place-name gazetteer that L3 (§4.1) needs to strip locative tails, so
# that "Springfield Historical Museum" and "Historical Museum of Springfield"
# collapse to one key.
#
# Why a gazetteer and not a regex: a rule like "drop everything after 'of'"
# eats "Museum of Flight", "Church of Christ" and "Museum of Illusions", which
# are names, not locations. Stripping is only safe against a list of things
# that are actually places.

#' Build the US place-name gazetteer
#'
#' Census places (incorporated + CDP), counties, and states. Cached, because
#' tigris downloads ~50 state files.
dn_gazetteer <- function(cache = "data/raw/gazetteer_us.parquet", refresh = FALSE) {

  if (file.exists(cache) && !refresh) {
    return(tibble::as_tibble(arrow::read_parquet(cache)))
  }

  message("[gazetteer] downloading Census places, counties and states...")
  op <- options(tigris_use_cache = TRUE, tigris_progress = FALSE)
  on.exit(options(op), add = TRUE)

  places <- suppressMessages(tigris::places(cb = TRUE, year = 2023))
  counties <- suppressMessages(tigris::counties(cb = TRUE, year = 2023))
  states <- suppressMessages(tigris::states(cb = TRUE, year = 2023))

  strip_suffix <- function(x) {
    # "Springfield city" -> "Springfield"; "St. Louis County" -> "St. Louis".
    # Census NAME fields carry the legal descriptor, which never appears in an
    # institution's name.
    stringi::stri_replace_all_regex(
      x,
      "\\s+(city|town|village|borough|township|municipality|CDP|County|Parish|Census Area|Municipio|city and borough|consolidated government|metro government|urban county)$",
      "", case_insensitive = TRUE)
  }

  g <- dplyr::bind_rows(
    tibble::tibble(name = strip_suffix(places$NAME),   kind = "place"),
    tibble::tibble(name = strip_suffix(counties$NAME), kind = "county"),
    tibble::tibble(name = states$NAME,                 kind = "state"),
    tibble::tibble(name = states$STUSPS,               kind = "state_abbr")
  )

  g$name_norm <- dn_name_expand(dn_name_clean(g$name))
  g <- g[nzchar(g$name_norm), ]
  g <- dplyr::distinct(g, name_norm, .keep_all = TRUE)

  # Place names that are also ordinary words would eat real name parts.
  # "Museum of Industry" must not lose "Industry" because Industry, Texas
  # exists. This list is the single most important quality lever in L3 and
  # will grow as the gold set grows.
  g <- g[!g$name_norm %in% DN_GAZETTEER_BLOCKLIST, ]

  dir.create(dirname(cache), showWarnings = FALSE, recursive = TRUE)
  arrow::write_parquet(g, cache)
  message(sprintf("[gazetteer] %s names", format(nrow(g), big.mark = ",")))
  g
}

# Real US place names that are also common nouns, adjectives or subject words.
# Every entry here is a place we deliberately refuse to strip, because the cost
# of wrongly stripping ("Museum of Industry" -> "Museum of") is far worse than
# the cost of wrongly keeping a locative.
DN_GAZETTEER_BLOCKLIST <- c(
  "industry", "liberty", "union", "hope", "friendship", "enterprise", "eureka",
  "commerce", "science", "art", "arts", "history", "discovery", "heritage",
  "aurora", "phoenix", "surprise", "boring", "normal", "peculiar", "sandwich",
  "mars", "venus", "climax", "energy", "atomic city", "friend", "home",
  "national", "american", "america", "colonial", "pioneer", "frontier",
  "independence", "freedom", "victory", "progress", "advance", "success",
  "east", "west", "north", "south", "center", "central", "midway", "summit",
  "highland", "hillside", "riverside", "lakeside", "bayside", "seaside",
  "fairview", "clearwater", "greenfield", "springfield", "fairfield",
  "the plains", "cascade", "rainier", "aviation", "flight", "gold", "silver",
  "iron", "steel", "coal", "oil city", "quilt", "rose", "orange", "lima",
  "china", "peru", "mexico", "cuba", "egypt", "athens", "rome", "paris",
  "moscow", "berlin", "dublin", "vienna", "naples", "geneva", "lebanon",
  "memorial", "veteran", "veterans", "old", "new", "big", "little"
)

#' L3 — strip a locative head or tail using the gazetteer
#'
#' Handles both shapes:
#'   "historical museum of springfield" -> "historical museum"
#'   "springfield historical museum"    -> "historical museum"
#'
#' Longest match wins, so "west palm beach" is preferred over "palm beach".
#' A strip is refused if it would leave fewer than two tokens: "museum of
#' springfield" keeps its tail, because "museum" alone is not a name.
dn_strip_locative <- function(x, gaz) {
  places <- gaz$name_norm
  # Index by first token so we compare against a handful of candidates rather
  # than ~40k names per input string.
  first_tok <- stringi::stri_extract_first_regex(places, "^\\S+")
  by_tok <- split(places, first_tok)

  min_keep <- 2L

  vapply(x, function(s) {
    if (is.na(s) || !nzchar(s)) return(s)
    tok <- stringi::stri_split_fixed(s, " ")[[1]]
    if (length(tok) <= min_keep) return(s)

    # --- tail: "... of <place>" or "... <place>"
    for (start in seq(2L, length(tok))) {
      cand <- paste(tok[start:length(tok)], collapse = " ")
      pool <- by_tok[[tok[start]]]
      if (!is.null(pool) && cand %in% pool) {
        keep <- tok[seq_len(start - 1L)]
        if (length(keep) && keep[length(keep)] == "of") keep <- keep[-length(keep)]
        if (length(keep) >= min_keep) return(paste(keep, collapse = " "))
      }
    }

    # --- head: "<place> ..."
    for (end in seq(length(tok) - 1L, 1L)) {
      cand <- paste(tok[seq_len(end)], collapse = " ")
      pool <- by_tok[[tok[1]]]
      if (!is.null(pool) && cand %in% pool) {
        keep <- tok[(end + 1L):length(tok)]
        if (length(keep) >= min_keep) return(paste(keep, collapse = " "))
      }
    }

    s
  }, character(1), USE.NAMES = FALSE)
}
