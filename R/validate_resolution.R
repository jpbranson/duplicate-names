# validate_resolution.R ---------------------------------------------------
# Phase 1a's exit criterion is a MEASURED entity-resolution error rate, not a
# spot check (DESIGN.md §8). Resolution is the largest correctness risk in the
# project: under-merging inflates every duplicate count, and inflated counts
# are exactly the finding we would most like to be true.
#
# The measurement has to come from a human. If the same process that made the
# clustering decisions also grades them, the error rate measures self-
# consistency rather than correctness.

#' Build a stratified sample of candidate pairs for hand labelling
#'
#' Sampling is stratified by similarity band, deliberately. A uniform sample
#' would be almost entirely obvious non-matches, and would say nothing about
#' the only region that matters: the band around the threshold where the
#' decision is actually in doubt. Strata above and below the cut are included
#' so the sample measures both false merges and missed merges.
#'
#' @param n_per_band pairs to draw from each similarity band
#' @param out path for the CSV the labeller fills in
dn_build_labelling_sample <- function(normalized,
                                      radius_m = DN_SITE_RADIUS_M,
                                      n_per_band = 60L,
                                      out = "data/processed/resolution_labelling.csv",
                                      seed = 20260907L) {

  pairs <- dn_candidate_pairs(normalized, radius_m)
  if (nrow(pairs) == 0L) stop("No candidate pairs found.", call. = FALSE)

  # Bands straddle DN_NAME_SIM_MIN so the sample can move the threshold in
  # either direction rather than only confirming it.
  pairs$band <- cut(
    pairs$similarity,
    breaks = c(-Inf, 0.60, 0.75, 0.85, 0.95, Inf),
    labels = c("0.00-0.60", "0.60-0.75", "0.75-0.85", "0.85-0.95", "0.95-1.00"),
    right  = FALSE
  )

  set.seed(seed)
  samp <- pairs |>
    dplyr::group_by(.data$band) |>
    dplyr::slice_sample(n = n_per_band) |>
    dplyr::ungroup() |>
    dplyr::arrange(.data$band, dplyr::desc(.data$similarity))

  samp <- samp |>
    dplyr::transmute(
      pair_id  = sprintf("P%04d", dplyr::row_number()),
      .data$band,
      similarity = round(.data$similarity, 3),
      distance_m = round(.data$distance_m),
      name_a   = .data$name_a, source_a = .data$source_a,
      name_b   = .data$name_b, source_b = .data$source_b,
      would_merge = .data$similarity >= DN_NAME_SIM_MIN,
      # The one column the human fills in: 1 = same institution, 0 = not,
      # blank = cannot tell. "Cannot tell" is a real answer and is reported
      # separately rather than being forced into one of the other two.
      same_institution = NA_integer_
    )

  dir.create(dirname(out), showWarnings = FALSE, recursive = TRUE)
  readr::write_csv(samp, out, na = "")
  # tar_target(format = "file") tracks the path.
  message(sprintf("[validate] wrote %d pairs to %s", nrow(samp), out))
  message("Fill in `same_institution` (1 / 0 / blank), then run dn_score_labels().")
  invisible(out)
}

#' All candidate pairs: within radius, with their name similarity
dn_candidate_pairs <- function(x, radius_m = DN_SITE_RADIUS_M) {
  pts  <- sf::st_as_sf(x[, c("lon", "lat")], coords = c("lon", "lat"), crs = 4326)
  near <- sf::st_is_within_distance(pts, dist = units::set_units(radius_m, "m"))

  ii <- rep(seq_along(near), lengths(near))
  jj <- unlist(near, use.names = FALSE)
  keep <- jj > ii                                  # each unordered pair once
  ii <- ii[keep]; jj <- jj[keep]
  if (!length(ii)) return(tibble::tibble())

  d <- sf::st_distance(pts[ii, ], pts[jj, ], by_element = TRUE)

  tibble::tibble(
    row_a = ii, row_b = jj,
    name_a = x$name_raw[ii], source_a = x$source[ii],
    name_b = x$name_raw[jj], source_b = x$source[jj],
    distance_m = as.numeric(d),
    similarity = dn_name_similarity(x$name_expanded[ii], x$name_expanded[jj])
  )
}

#' Score a filled-in labelling sheet
#'
#' Reports precision and recall of the merge rule against the human labels,
#' and — the point of the exercise — what the threshold SHOULD be.
#'
#' Precision and recall are not interchangeable here. A false merge deletes a
#' real museum from the count; a missed merge invents one. Both distort the
#' duplicate counts, in opposite directions, so neither can be traded away
#' quietly and both are reported.
dn_score_labels <- function(path = "data/processed/resolution_labelling.csv") {
  lab <- readr::read_csv(path, show_col_types = FALSE, progress = FALSE)

  done <- lab[!is.na(lab$same_institution), ]
  if (nrow(done) == 0L) {
    stop("No labels found in ", path, " — fill in `same_institution` first.",
         call. = FALSE)
  }
  message(sprintf("[validate] %d of %d pairs labelled (%d left blank as 'cannot tell')",
                  nrow(done), nrow(lab), nrow(lab) - nrow(done)))

  truth <- done$same_institution == 1L
  pred  <- done$would_merge

  tp <- sum(pred & truth); fp <- sum(pred & !truth)
  fn <- sum(!pred & truth); tn <- sum(!pred & !truth)

  # Sweep the threshold to see whether a different cut would do better on
  # this sample. Reported, never applied automatically.
  grid <- seq(0.50, 0.99, by = 0.01)
  sweep <- vapply(grid, function(t) {
    p <- done$similarity >= t
    f1 <- if (sum(p) == 0 || sum(truth) == 0) 0 else {
      prec <- sum(p & truth) / max(sum(p), 1)
      rec  <- sum(p & truth) / max(sum(truth), 1)
      if (prec + rec == 0) 0 else 2 * prec * rec / (prec + rec)
    }
    f1
  }, numeric(1))

  list(
    threshold  = DN_NAME_SIM_MIN,
    n_labelled = nrow(done),
    n_unsure   = nrow(lab) - nrow(done),
    confusion  = c(true_merge = tp, false_merge = fp,
                   missed_merge = fn, true_separate = tn),
    precision  = if (tp + fp > 0) tp / (tp + fp) else NA_real_,
    recall     = if (tp + fn > 0) tp / (tp + fn) else NA_real_,
    error_rate = (fp + fn) / nrow(done),
    best_threshold_on_sample = grid[which.max(sweep)]
  )
}
