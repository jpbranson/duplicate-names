# Continue the same packet; preserve the first validated sub-checkpoint.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
p <- "data/validation/museum_affiliation_followup_2026-09-26"
stopifnot(!file.exists(file.path(p, "museum_decisions_final.csv")))
for (f in c("validation.log", "integrity_checks.csv", "ranking_after.csv", "verified_institutions.csv", "manifest_after.json")) stopifnot(file.copy(file.path(p, f), file.path(p, paste0("initial_", f))))
d <- dn_read_museum_review("data/validation/museum_decisions.csv", dn_schema_museum_decisions())
e <- targets::tar_read(entities)
mn_url <- "https://www.wchsmn.org/about-us/"
in_url <- "https://www.johnhaycenter.org/index.php/attractions/stevens-memorial-museum | https://www.johnhaycenter.org/index.php/attractions/the-depot-railroad-museum"
mn_note <- "Current operator explicitly operates three museums: Heritage Center, Warden's House and Hay Lake School/Erickson Log Home. Its own local board establishes nonprofit governance but does not make those museums independent of each other. Correct affiliation consistently with other shared local operators. Preserve the previously reviewed Heritage Center identity and museum role. Hay Lake source duplicates and companion institutions still need full review; no merge or new complete-review claim."
in_note <- "John Hay Center's own pages present Stevens Memorial Museum and The Depot Railroad Museum as distinct museum tours under the Washington County Historical Society, with combined tours, membership and a shared fundraising program. Depot hosts the separate Monon society's archives but remains a named John Hay Center attraction. Correct the former independent flag to shared-operator affiliation, consistently with the other local museum groups. Existing Stevens identity remains; the Depot's full review stays pending."
mn <- c("68d726b1-08a1-4bf5-948e-16e3f24bc530", "646da399-7b75-4ad0-b5e6-deebb018ea33", "cc173fe8-7677-49b1-ae15-a42bf33fd401", "db6bc644-3dcb-469c-87a6-2c6aba16b6b8")
in_keys <- c("128b5b25-e15b-4e75-be9b-50de8321e93b", "2e03a301-90df-48b5-a2e9-d39efc4f87b9")
rows <- lapply(c(mn, in_keys), function(key) {
  prior <- d[d$source_id == key, ]
  x <- e[match(key, e$source_id), ]; stopifnot(!is.na(x$source_id))
  is_mn <- key %in% mn
  tibble::tibble(source = x$source, source_id = key, expected_name = x$name_raw,
    category_decision = if (nrow(prior)) prior$category_decision else "not_flagged", affiliation_status = "chain",
    chain_id = if (is_mn) "washington_county_mn_historical_society" else "washington_county_in_historical_society",
    review_status = if (nrow(prior)) prior$review_status else "pending", evidence_url = if (is_mn) mn_url else in_url,
    note = paste(if (nrow(prior)) prior$note else "", if (is_mn) mn_note else in_note),
    reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
})
new <- dplyr::bind_rows(rows)
d <- dplyr::bind_rows(d[!d$source_id %in% new$source_id, ], new)
a <- dn_museum_analysis(targets::tar_read(museum_records), targets::tar_read(museum_chain_rules), d,
  targets::tar_read(museum_name_overrides), targets::tar_read(gazetteer))
stopifnot(sum(a$counted) == 52557L, sum(a$review_status == "verified") == 39L)
readr::write_csv(new, file.path(p, "local_operator_decisions.csv"), na = "")
readr::write_csv(d, file.path(p, "museum_decisions_final.csv"), na = "")
readr::write_csv(d, "data/validation/museum_decisions.csv", na = "")
readr::write_csv(dn_museum_ranking(a), file.path(p, "ranking_final.csv"))
message("Six local-operator affiliations aligned; two existing complete reviews retained and four companions pending.")
