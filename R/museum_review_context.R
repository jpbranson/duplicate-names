# Recover names, addresses and source links already present in the immutable
# IMLS archive. This is review context, never evidence of current operation.
dn_schema_imls_context <- function() {
  tibble::tibble(source = character(), source_id = character(), imls_legal_name = character(),
                imls_parent = character(), imls_street = character(), imls_city = character(),
                imls_state = character(), imls_url_2018 = character(), imls_ein = character(),
                imls_physical_street = character(), imls_physical_city = character(),
                imls_physical_state = character(), imls_physical_zip = character(),
                imls_physical_zip5 = character(), imls_mailing_street = character(),
                imls_mailing_city = character(), imls_mailing_state = character(),
                imls_mailing_zip = character(), imls_mailing_zip5 = character(),
                imls_physical_address = character(), imls_mailing_address = character())
}

# Format each archive row before combining repeated MIDs, so alternative address
# components are never rearranged into an address the source did not supply.
dn_imls_address <- function(street, city, state, zip) {
  vapply(seq_along(street), function(i) {
    parts <- c(street[i], city[i], state[i], zip[i])
    parts <- parts[!is.na(parts) & nzchar(trimws(parts))]
    if (length(parts)) paste(parts, collapse = ", ") else NA_character_
  }, character(1), USE.NAMES = FALSE)
}

dn_imls_review_context <- function(archive) {
  members <- utils::unzip(archive, list = TRUE)$Name
  members <- members[grepl("[.]csv$", members)]
  if (!length(members)) stop("No CSVs in IMLS review archive.")
  directory <- tempfile("imls-review-")
  dir.create(directory)
  utils::unzip(archive, files = members, exdir = directory)
  parts <- lapply(members, function(member) {
    x <- readr::read_csv(file.path(directory, member),
                         col_types = readr::cols(.default = readr::col_character()),
                         locale = readr::locale(encoding = "Windows-1252"),
                         na = c("", "NULL", "NA"), show_col_types = FALSE)
    tibble::tibble(source = "imls", source_id = x$MID, imls_legal_name = x$LEGALNAME,
      # Retain the old coalesced convenience fields for existing review consumers.
      # Identity research must use the separate physical/mailing fields below.
      imls_parent = x$INSTNAME, imls_street = dplyr::coalesce(x$PHSTREET, x$ADSTREET),
      imls_city = dplyr::coalesce(x$PHCITY, x$ADCITY),
      imls_state = dplyr::coalesce(x$PHSTATE, x$ADSTATE), imls_url_2018 = x$WEBURL,
      imls_ein = x$EIN,
      imls_physical_street = x$PHSTREET, imls_physical_city = x$PHCITY,
      imls_physical_state = x$PHSTATE, imls_physical_zip = x$PHZIP,
      imls_physical_zip5 = x$PHZIP5,
      imls_mailing_street = x$ADSTREET, imls_mailing_city = x$ADCITY,
      imls_mailing_state = x$ADSTATE, imls_mailing_zip = x$ADZIP,
      imls_mailing_zip5 = x$ADZIP5,
      imls_physical_address = dn_imls_address(x$PHSTREET, x$PHCITY, x$PHSTATE,
                                             dplyr::coalesce(x$PHZIP, x$PHZIP5)),
      imls_mailing_address = dn_imls_address(x$ADSTREET, x$ADCITY, x$ADSTATE,
                                            dplyr::coalesce(x$ADZIP, x$ADZIP5)))
  })
  out <- dplyr::bind_rows(parts) |> dplyr::distinct()
  repeated <- duplicated(out$source_id) | duplicated(out$source_id, fromLast = TRUE)
  if (any(repeated)) {
    # The archive repeats one museum across files with differing supplementary
    # context. Preserve every supplied value while keeping a one-to-one join.
    combined <- out[repeated, ] |>
      dplyr::group_by(.data$source, .data$source_id) |>
      dplyr::summarise(dplyr::across(dplyr::everything(), function(z) {
        values <- sort(unique(stats::na.omit(z)))
        if (length(values)) paste(values, collapse = " | ") else NA_character_
      }), .groups = "drop")
    out <- dplyr::bind_rows(out[!repeated, ], combined)
  }
  dn_validate(out, dn_schema_imls_context())
}
