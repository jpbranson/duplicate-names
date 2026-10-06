# Export post 1's payload (DESIGN decision 14) from saved targets.
# Reads museum_analysis, museum_records and data/validation/post1_headline_review.csv;
# writes only posts/duplicate-museum-names/payload/. Builds no target and changes no
# decision, status or count. Stops unless the M1 headline passes the explicit gate.
# Example: Rscript scripts/export_post1_payload.R
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
headline <- "old jail museum"
seed <- "international cryptozoology museum"
payload <- "posts/duplicate-museum-names/payload"
analysis <- targets::tar_read(museum_analysis)
records <- targets::tar_read(museum_records)
review <- readr::read_csv("data/validation/post1_headline_review.csv",
                          col_types = readr::cols(.default = "c"))

dn_assert_museum_publication_ready(analysis, headline, headline_review = review)
dn_assert_museum_publication_ready(analysis, seed)
post <- dn_post1_groups(analysis, review)
ranking <- dn_museum_ranking(analysis)
top <- post$groups[post$groups$group == headline, ]
runner_up <- ranking$n_entities[2]
stopifnot(ranking$name_expanded[1] == headline, ranking$n_entities[1] > runner_up,
          top$status == "confirmed", top$counting == ranking$n_entities[1])

title <- function(x) tools::toTitleCase(x)
related <- analysis |>
  dplyr::filter(.data$analysis_eligible, grepl("old jail", .data$name_expanded, fixed = TRUE)) |>
  dplyr::count(.data$name_expanded, name = "museums", sort = TRUE)
tables <- list(
  checkpoint = tibble::tibble(
    source_rows = nrow(records), counted_source_rows = sum(records$counted),
    counted_institutions = sum(analysis$counted), eligible_institutions = sum(analysis$analysis_eligible),
    chain_locations = sum(analysis$analysis_eligible & analysis$affiliation_status == "chain"),
    non_chain_institutions = sum(ranking$n_entities), distinct_names = nrow(ranking),
    names_used_once = sum(ranking$n_entities == 1L), names_shared = sum(ranking$n_entities > 1L),
    complete_factual_reviews = sum(analysis$review_status == "verified"),
    exported_on = as.character(Sys.Date())),
  name_ladder = ranking |>
    dplyr::count(museums_sharing = .data$n_entities, name = "names") |>
    dplyr::mutate(museums = .data$museums_sharing * .data$names),
  headline = tibble::tibble(
    name = headline, display_name = title(headline), museums = top$counting,
    chain_locations = top$chain_locations, runner_up_museums = runner_up,
    runner_up_names = sum(ranking$n_entities == runner_up),
    related_names = nrow(related), related_museums = sum(related$museums)),
  headline_members = post$members |>
    dplyr::filter(.data$group == headline) |>
    dplyr::select("place", "state", "operator", "basis", "evidence_url", "checked_on"),
  headline_related_names = related,
  runner_up_names = ranking |>
    dplyr::filter(.data$n_entities == runner_up) |>
    dplyr::select("name_expanded", museums = "n_entities", chain_locations = "n_chain"),
  collision_groups = post$groups |>
    dplyr::filter(.data$group != headline) |>
    dplyr::mutate(display_name = title(.data$group), .after = "group") |>
    dplyr::select(-"chain_locations"),
  collision_members = post$members |>
    dplyr::filter(.data$group != headline) |>
    dplyr::mutate(display_name = title(.data$group), .after = "group"),
  chains = dn_museum_chain_summary(analysis) |>
    dplyr::select("chain_id", "n_locations", "n_verified", "n_names"),
  seed_records = records |>
    dplyr::filter(grepl("cryptozoolog", tolower(.data$name_raw), fixed = TRUE)) |>
    dplyr::select("source", "source_id", "name_raw", "lon", "lat", "counted", "exclusion_reason", "entity_id")
)
stopifnot(sum(tables$name_ladder$museums) == tables$checkpoint$non_chain_institutions,
          nrow(tables$headline_members) == top$counting, !anyNA(tables$headline_members))
dir.create(payload, showWarnings = FALSE, recursive = TRUE)
for (name in names(tables)) {
  readr::write_csv(tables[[name]], file.path(payload, paste0(name, ".csv")), na = "")
}
message("Post 1 payload exported: ", title(headline), " at ", top$counting, "; ",
        sum(tables$collision_groups$status == "confirmed"), " of ", nrow(tables$collision_groups),
        " shortlisted collisions confirmed.")
