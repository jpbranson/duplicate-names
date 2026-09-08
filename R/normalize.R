# normalize.R -------------------------------------------------------------
# The §4 ladder. This module decides every headline number in both posts, so it
# is the one place in the project where tests come before convenience.
#
# Phase 0 wires the stages together and implements only the parts that are
# unambiguous (L1, L2). L3 needs the gazetteer and L4 needs L3, so both pass
# through for now — clearly marked, because a silent pass-through here would
# produce plausible-looking but wrong duplicate counts.

# L2 abbreviation table -----------------------------------------------------
# Order matters: longer patterns first, so "A.M.E. Zion" isn't half-expanded
# into "African Methodist Episcopal Zion Zion".
#
# Replacements are LOWERCASE on purpose. L1 lowercases the string and every
# later stage assumes that invariant holds; a title-cased replacement here
# would silently break ordinal parsing further down.
DN_ABBREV <- c(
  # L1 has already turned "A.M.E." into "a m e", so these must match the
  # spaced form as well as the run-together one.
  "\\ba[. ]?m[. ]?e\\b\\s+zion\\b" = "african methodist episcopal zion",
  "\\ba[. ]?m[. ]?e\\b"            = "african methodist episcopal",
  "\\bu[. ]?m[. ]?c\\b"            = "united methodist church",
  "\\bste\\.?\\b"              = "sainte",
  "\\bst\\.?\\b"               = "saint",
  "\\bft\\.?\\b"               = "fort",
  "\\bmt\\.?\\b"               = "mount",
  "\\bassy\\.?\\b"             = "assembly",
  "\\bev\\.?\\b"               = "evangelical",
  "\\bluth\\.?\\b"             = "lutheran",
  "\\bpresb\\.?\\b"            = "presbyterian",
  "\\bbapt\\.?\\b"             = "baptist",
  "\\bcath\\.?\\b"             = "catholic",
  # Numeric ordinals map straight to their words, so downstream parsing has
  # exactly one representation to handle rather than two.
  "\\b1st\\b"  = "first",   "\\b2nd\\b"  = "second",  "\\b3rd\\b"  = "third",
  "\\b4th\\b"  = "fourth",  "\\b5th\\b"  = "fifth",   "\\b6th\\b"  = "sixth",
  "\\b7th\\b"  = "seventh", "\\b8th\\b"  = "eighth",  "\\b9th\\b"  = "ninth",
  "\\b10th\\b" = "tenth",   "\\b11th\\b" = "eleventh", "\\b12th\\b" = "twelfth",
  "\\b13th\\b" = "thirteenth", "\\b14th\\b" = "fourteenth", "\\b15th\\b" = "fifteenth",
  "\\b16th\\b" = "sixteenth", "\\b17th\\b" = "seventeenth", "\\b18th\\b" = "eighteenth",
  "\\b19th\\b" = "nineteenth", "\\b20th\\b" = "twentieth"
)

DN_ORDINAL_WORDS <- c(
  first = 1L, second = 2L, third = 3L, fourth = 4L, fifth = 5L,
  sixth = 6L, seventh = 7L, eighth = 8L, ninth = 9L, tenth = 10L,
  eleventh = 11L, twelfth = 12L, thirteenth = 13L, fourteenth = 14L,
  fifteenth = 15L, sixteenth = 16L, seventeenth = 17L, eighteenth = 18L,
  nineteenth = 19L, twentieth = 20L
)

# The ordinal-parser trap (§6.6). These begin with an ordinal word that is part
# of a denominational proper name, not a count. Tested explicitly.
DN_ORDINAL_EXCEPTIONS <- c(
  "first church of christ scientist",
  "first church of christ, scientist",
  "church of christ scientist"
)

#' L1 — case-fold, strip punctuation and diacritics, drop leading "The"
dn_name_clean <- function(x) {
  x |>
    stringi::stri_trans_nfkc() |>
    stringi::stri_trans_tolower() |>
    stringi::stri_trans_general("Latin-ASCII") |>
    stringi::stri_replace_all_regex("[^a-z0-9&' ]+", " ") |>
    stringi::stri_replace_all_regex("^\\s*the\\s+", "") |>
    stringi::stri_replace_all_regex("\\s+", " ") |>
    stringi::stri_trim_both()
}

#' L2 — expand abbreviations
dn_name_expand <- function(x) {
  for (pat in names(DN_ABBREV)) {
    x <- stringi::stri_replace_all_regex(x, pat, DN_ABBREV[[pat]], case_insensitive = TRUE)
  }
  stringi::stri_replace_all_regex(x, "\\s+", " ") |> stringi::stri_trim_both()
}

#' L3 — strip the locative tail
#'
#' `First Baptist Church of Springfield` and `Springfield First Baptist Church`
#' must collapse to the same key. This needs a real gazetteer at both head and
#' tail positions; a regex for "of <anything>" would eat "Church of Christ" and
#' "Museum of Flight", which are names, not locations.
dn_name_core <- function(x, gazetteer = NULL) {
  if (is.null(gazetteer)) {
    # PHASE 0: pass-through. Duplicate counts computed on this are WRONG —
    # they will scatter one congregation across many keys. dn_normalize()
    # warns loudly rather than letting that pass unnoticed.
    return(x)
  }
  stop("dn_name_core(): gazetteer path not implemented (Phase 1).", call. = FALSE)
}

#' L4 — token sort + stopword removal, for fuzzy grouping
dn_name_key <- function(x) {
  vapply(stringi::stri_split_regex(x, " "), function(tok) {
    tok <- tok[nzchar(tok) & !tok %in% c("of", "the", "at", "in", "and", "a")]
    paste(sort(tok), collapse = " ")
  }, character(1))
}

# An ordinal followed by one of these is a PLACE, not a count:
# "Fourth Street Baptist Church" is on Fourth Street; it is not the fourth
# Baptist church in town. Left unguarded this inflates the ordinal ladder (C3)
# and does it worst in exactly the dense old cities where the real high
# ordinals live, so the error would look like signal.
DN_ORDINAL_TOPONYM_FOLLOWERS <- c(
  "street", "avenue", "ave", "road", "boulevard", "blvd", "lane", "drive",
  "place", "ward", "district", "precinct", "hill", "creek", "river", "lake",
  "mile", "line", "addition"
)

#' Ordinal extraction (§4.2), honouring the exception lists
#'
#' TODO(phase-3): compound ordinals ("twenty third") are not parsed and return
#' NA. That matters specifically for C3, whose headline is the HIGHEST observed
#' ordinal — the highest ones are the compound ones, so the current parser
#' biases that number downward. Fix before the ladder metric ships.
dn_parse_ordinal <- function(name_expanded) {
  toks <- stringi::stri_split_regex(name_expanded, " ")

  out <- vapply(toks, function(tk) {
    if (!length(tk)) return(NA_integer_)
    n <- unname(DN_ORDINAL_WORDS[tk[1]])
    if (is.na(n)) return(NA_integer_)
    if (length(tk) >= 2L && tk[2] %in% DN_ORDINAL_TOPONYM_FOLLOWERS) return(NA_integer_)
    n
  }, integer(1))

  out[name_expanded %in% DN_ORDINAL_EXCEPTIONS] <- NA_integer_
  out
}

#' Scope-claim extraction (§4.2) — drives the museum hubris ranking
dn_parse_scope_claim <- function(name_clean) {
  claims <- tolower(dn_scope_claims())
  pat <- paste0("\\b(", paste(claims, collapse = "|"), ")\\b")
  hit <- stringi::stri_extract_first_regex(name_clean, pat)
  # match() on NA yields NA, so indexing gives NA_character_ for a miss.
  # Avoid ifelse() here: on zero-row input it returns logical(0) rather than
  # character(0), and the schema check rightly rejects that.
  as.character(dn_scope_claims()[match(hit, claims)])
}

#' Run the full ladder
dn_normalize <- function(raw, gazetteer = NULL) {
  dn_validate(raw, dn_schema_raw(), label = "normalize input")

  if (is.null(gazetteer) && nrow(raw) > 0L) {
    warning("dn_normalize(): no gazetteer supplied — name_core is a pass-through ",
            "of name_expanded. Duplicate counts from this run are NOT valid.",
            call. = FALSE)
  }

  clean    <- dn_name_clean(raw$name_raw)
  expanded <- dn_name_expand(clean)
  core     <- dn_name_core(expanded, gazetteer)

  out <- dplyr::bind_cols(
    raw,
    tibble::tibble(
      name_clean    = clean,
      name_expanded = expanded,
      name_core     = core,
      name_key      = dn_name_key(core),
      ordinal       = dn_parse_ordinal(expanded),
      scope_claim   = dn_parse_scope_claim(clean),
      subject       = NA_character_,      # TODO(phase-2): museum topic phrase
      name_style    = NA_character_,      # TODO(phase-3): §4.2 taxonomy
      denom_norm    = NA_character_       # TODO(phase-1): reconcile tags vs name
    )
  )

  dn_validate(out, dn_schema_normalized(), label = "normalized")
}
