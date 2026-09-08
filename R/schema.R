# schema.R ----------------------------------------------------------------
# The contract between pipeline stages. Every stage declares what it returns
# and is checked against it, so a shape error surfaces at the stage that caused
# it rather than three stages downstream in a metric that quietly returns zero.

#' Raw source schema — what every src_*() function must return
#'
#' Deliberately thin. Source modules do format wrangling and nothing else; all
#' interpretation happens in normalize. `country` is here from day one so the
#' global follow-up (DESIGN.md §7) doesn't need a migration.
dn_schema_raw <- function() {
  tibble::tibble(
    source       = character(),  # "overture" | "osm" | "gnis" | "imls" | "hifld"
    source_id    = character(),  # id within that source; unique per source
    category     = character(),  # "museum" | "place_of_worship"

    # The source's own subtype (Overture "history_museum", IMLS DISCIPL code,
    # OSM museum=*). An independent check on the name-derived `subject` in
    # §4.2 — a place called "Heritage Center" that Overture types as
    # history_museum is evidence the name alone would have missed.
    category_raw = character(),

    name_raw     = character(),
    lon          = double(),
    lat          = double(),
    country      = character(),  # ISO 3166-1 alpha-2; "US" for now
    denomination = character(),  # tag-derived where available, else NA
    religion     = character(),
    operator     = character(),  # drives franchise detection (§4.4)
    wikidata_id  = character(),
    confidence   = double(),     # source's own, NA where not provided

    # Trap §6.2: POI data is full of ghosts and museums close constantly.
    # Counting the dead inflates every duplicate count, so carry the source's
    # own liveness signal rather than discovering the problem in a figure.
    operating_status = character(),

    retrieved    = as.Date(character())
  )
}

#' Normalized schema — raw plus the §4 ladder and extracted fields
dn_schema_normalized <- function() {
  dplyr::bind_cols(
    dn_schema_raw(),
    tibble::tibble(
      # §4.1 ladder. All levels retained so duplicate counts can be reported
      # with a sensitivity band rather than a single fragile number.
      name_clean    = character(),
      name_expanded = character(),
      name_core     = character(),
      name_key      = character(),

      # §4.2 extraction
      ordinal      = integer(),    # 1, 2, 3 ... NA where not ordinal
      scope_claim  = character(),  # International | National | World | ...
      subject      = character(),  # museums: the topic noun phrase
      name_style   = character(),  # see dn_name_styles()
      denom_norm   = character()   # reconciled denomination
    )
  )
}

#' Entity schema — one row per real-world institution, post-resolution
dn_schema_entity <- function() {
  dplyr::bind_cols(
    dn_schema_normalized(),
    tibble::tibble(
      entity_id    = character(),  # stable hash; survives re-runs
      n_sources    = integer(),    # cross-source agreement = the quality signal
      source_set   = character(),  # e.g. "gnis|hifld|overture"
      is_franchise = logical(),    # §4.4; excluded from headline collisions
      chain_id     = character(),

      # Geographic joins. place_geoid is the denominator for the municipal
      # exclusivity test (C2), which is the core churches result.
      state_fips  = character(),
      county_fips = character(),
      place_geoid = character(),
      place_name  = character()
    )
  )
}

#' Controlled vocabulary for name_style (§4.2)
dn_name_styles <- function() {
  c("ordinal", "saint", "virtue", "toponym", "modern_brand",
    "ethnolinguistic", "descriptive", "other")
}

#' Controlled vocabulary for scope_claim (§4.2)
dn_scope_claims <- function() {
  c("International", "National", "World", "Global", "Universal",
    "American", "Only", "Original")
}

#' Check a table against a prototype
#'
#' Checks names and types, not row count — an empty table is a valid table, and
#' that is exactly what the Phase 0 no-op pipeline produces.
dn_validate <- function(x, proto, label = deparse(substitute(x))) {
  want <- names(proto)
  got  <- names(x)

  missing <- setdiff(want, got)
  if (length(missing)) {
    stop(sprintf("[%s] missing column(s): %s", label,
                 paste(missing, collapse = ", ")), call. = FALSE)
  }

  extra <- setdiff(got, want)
  if (length(extra)) {
    stop(sprintf("[%s] unexpected column(s): %s\nAdd them to the schema in R/schema.R if intended.",
                 label, paste(extra, collapse = ", ")), call. = FALSE)
  }

  bad <- want[vapply(want, function(k) {
    !identical(class(x[[k]])[1], class(proto[[k]])[1])
  }, logical(1))]
  if (length(bad)) {
    detail <- vapply(bad, function(k) {
      sprintf("%s (got %s, want %s)", k, class(x[[k]])[1], class(proto[[k]])[1])
    }, character(1))
    stop(sprintf("[%s] wrong type(s): %s", label,
                 paste(detail, collapse = "; ")), call. = FALSE)
  }

  x[want]
}
