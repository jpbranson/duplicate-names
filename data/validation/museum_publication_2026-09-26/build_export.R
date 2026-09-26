# Rebuild and export a visibly provisional bundle, retaining failed publication gates.
p <- "data/validation/museum_publication_2026-09-26"
targets::tar_make(names = c(museum_review_files, museum_identity_audit_file, museum_records_file, dup_museums, multisite_review, entities_file))
source("tests/testthat.R")
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
b <- readRDS("data/processed/publication_before.rds")
a <- targets::tar_read(museum_analysis); e <- targets::tar_read(entities); r <- targets::tar_read(museum_records)
stopifnot(identical(e, b$entities), identical(r, b$records), sum(a$counted) == 52557L,
  sum(a$analysis_eligible) == 52425L, sum(a$review_status == "verified") == 40L,
  identical(DN_NAME_SIM_MIN, 0.85))
protected <- readr::read_csv(file.path(p, "preserved_input_checksums.csv"), show_col_types = FALSE)
actual <- vapply(protected$path, function(f) digest::digest(file = f, algo = "sha256"), character(1))
stopifnot(identical(unname(actual), protected$sha256))
locations <- readr::read_csv("data/validation/museum_address_review_2026-09-15/publication_locations.csv", show_col_types = FALSE)
access <- readr::read_csv(file.path(p, "access_checks.csv"), col_types = readr::cols(.default = readr::col_character()))
points <- dn_museum_publication_points(a, locations, access, as_of = as.Date("2026-09-26"))
stopifnot(identical(points[names(a)], a), all(!points$visitor_ready[points$source_id == "0c882b11-f39b-402b-ba37-b0980564ab65"]))
readr::write_csv(points[points$source_id %in% locations$source_id, ], file.path(p, "publication_points.csv"), na = "")
ranks <- dn_museum_ranking(a)
selected <- unique(c(head(ranks$name_expanded, 20), "franklin county historical society", "greene county historical society", "jackson county historical society", "old jail museum", "smithsonian institution", "museum of illusions", "international cryptozoology museum"))
gates <- dplyr::bind_rows(lapply(selected, function(n) {
  reason <- tryCatch({dn_assert_museum_publication_ready(a, n); ""}, error = conditionMessage)
  tibble::tibble(name_expanded = n, gate_passed = !nzchar(reason), reason = reason)
}))
stopifnot(gates$gate_passed[gates$name_expanded == "international cryptozoology museum"], !gates$gate_passed[gates$name_expanded == "old jail museum"])
readr::write_csv(gates, file.path(p, "publication_gates.csv"))
# Export only the reviewed opening example as a selected-name count; no failed group
# is exported as a final headline. The before/after chart is a labelled review history.
dn_assert_museum_publication_ready(a, "international cryptozoology museum")
bundle <- "posts/duplicate-museum-names"
readr::write_csv(a[a$name_expanded == "international cryptozoology museum" & a$analysis_eligible, ], file.path(bundle, "payload/seed_institution.csv"), na = "")
changes <- tibble::tibble(group = rep(c("Franklin County Historical Society", "Greene County Historical Society", "Jackson County Historical Society", "Old Jail Museum"), each = 2), checkpoint = rep(c("Before review", "Current provisional"), 4), count = c(11L, 6L, 11L, 6L, 11L, 6L, 11L, 8L), status = "provisional; review incomplete")
current <- ranks$n_entities[match(unique(changes$group) |> tolower(), ranks$name_expanded)]
stopifnot(identical(as.integer(current), changes$count[changes$checkpoint == "Current provisional"]))
readr::write_csv(changes, file.path(bundle, "payload/review_count_changes.csv"))
blockers <- tibble::tribble(~step, ~status, ~remaining_work, ~evidence,
  "M1 leaders", "incomplete", "Finish county and newly exposed leading-name identity/name/category/affiliation reviews; four Old Jail cases remain pending", "Museum review queues and publication_gates.csv",
  "Old Jail operator evidence", "human_review_needed", "Hayesville current operator/name; Winchester current governance; Thompson Falls governance/address; Greenwood campus scope", "museum_jail_followup_2026-09-26/human_review.csv",
  "M2 collisions", "incomplete", "Review institution identities and affiliations alongside scope-word meanings; lexical candidates alone are insufficient", "museum_affiliation_followup_2026-09-26/m2_semantic_review.csv",
  "Smithsonian", "incomplete", "Three generic parent labels have unresolved roles; five affiliated labels still need complete identity/name reconciliation", "museum_affiliation_followup_2026-09-26/research_notes.md",
  "Museum of Illusions", "operator_evidence_needed", "Miami Beach operator page unavailable; do not infer closure from failed access. City-suffixed access reviews remain pending if quoted", "museum_leaders_review_2026-09-23/follow_up.csv",
  "Visitor maps", "incomplete", "Separate sourced points and access checks prepared for three earlier cases; these do not certify all selected museum identities or reopen Mandeville", "publication_points.csv",
  "Publication destination", "configuration_needed", "DUPNAMES_BLOG_DIR unset and ../blog absent. Draft remains local until evidence and destination are ready", "config_blog.R")
readr::write_csv(blockers, file.path(p, "publication_blockers.csv"))
readr::write_csv(blockers, file.path(bundle, "payload/publication_blockers.csv"))
readr::write_csv(gates, file.path(bundle, "payload/publication_gates.csv"))
counts <- tibble::tibble(original_source_rows = nrow(e), counted_source_rows = sum(r$counted), provisional_institutions = sum(a$counted), eligible_l2 = sum(a$analysis_eligible), complete_factual_reviews = sum(a$review_status == "verified"), national_winner_certified = FALSE)
readr::write_csv(counts, file.path(p, "counts.csv"))
readr::write_csv(counts, file.path(bundle, "payload/checkpoint.csv"))
dir.create(file.path(bundle, "evidence"), showWarnings = FALSE)
for (f in c("resolution_validation_2026-09-15.md", "museum_county_leaders_2026-09-26.md", "museum_jail_followup_2026-09-26.md", "museum_affiliation_followup_2026-09-26.md")) file.copy(file.path("data/validation", f), file.path(bundle, "evidence", f), overwrite = TRUE)
file.copy("data/validation/resolution_labelling_2026-09-15.csv", file.path(bundle, "evidence/resolution_labelling_2026-09-15.csv"), overwrite = TRUE)
file.copy("data/processed/museum_review/identity_audit.csv", file.path(p, "identity_audit_checkpoint.csv"), overwrite = TRUE)
file.copy("data/raw/MANIFEST.json", file.path(p, "manifest_after.json"), overwrite = TRUE)
checks <- tibble::tibble(check = c("Automatic baseline unchanged", "Reviewed source records unchanged", "418 protected evidence/label files unchanged", "52557 counted and 52425 eligible, 40 complete reviews", "Threshold remains 0.85", "Publication overlay preserves every original analysis field", "Mandeville closure blocks visitor-ready status", "Opening example explicit publication gate passes", "Old Jail explicit publication gate fails", "Provisional chart agrees with current ranks"), passed = TRUE)
readr::write_csv(checks, file.path(p, "integrity_checks.csv"))
message("10 integrity checks pass; ", nrow(protected), " protected files unchanged. Draft payload exported; final headlines blocked.")
