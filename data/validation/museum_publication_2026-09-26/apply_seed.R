# One-time completion of the opening example's factual review.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
p <- "data/validation/museum_publication_2026-09-26"
stopifnot(!file.exists(file.path(p, "museum_decisions_after.csv")))
d <- dn_read_museum_review("data/validation/museum_decisions.csv", dn_schema_museum_decisions())
stopifnot(identical(d, dn_read_museum_review(file.path(p, "museum_decisions_before.csv"), dn_schema_museum_decisions())))
key <- "6d77967f-48ef-4e2c-a928-dd4d4d935614"
e <- targets::tar_read(entities); row <- e[match(key, e$source_id), ]
new <- tibble::tibble(source = row$source, source_id = key, expected_name = row$name_raw,
  category_decision = "not_flagged", affiliation_status = "independent", chain_id = NA_character_, review_status = "verified",
  evidence_url = "https://cryptozoologymuseum.com/ | https://cryptozoologymuseum.com/plan-your-visit/ | https://cryptozoologymuseum.com/about-icm/ | https://cryptozoologymuseum.com/board-of-directors/ | https://cryptozoologymuseum.com/our-history/",
  note = "The institution's current operator identifies its public name, exhibits and single current visitor home at 490 Broadway Bangor, opened June 1 2026. It explicitly closes both 32 Resurgam Place Portland and 585 Hammond Street Bangor; its history documents earlier Avon Street/Portland moves. Own incorporated nonprofit and named board establish independent operation. The four baseline records already form one institution with Bangor counted and old Portland records excluded; no identity or source-coordinate change is required. Complete factual review of this institution, not independent algorithm validation, a global uniqueness census, or a field survey. Holiday exceptions differ between operator pages, so no universal seven-day access guarantee is made.",
  reviewed_by = "Codex source review", reviewed_on = "2026-09-26")
d <- dplyr::bind_rows(d[d$source_id != key, ], new)
a <- dn_museum_analysis(targets::tar_read(museum_records), targets::tar_read(museum_chain_rules), d, targets::tar_read(museum_name_overrides), targets::tar_read(gazetteer))
stopifnot(sum(a$counted) == 52557L, sum(a$review_status == "verified") == 40L)
dn_assert_museum_publication_ready(a, "international cryptozoology museum")
readr::write_csv(d, file.path(p, "museum_decisions_after.csv"), na = "")
readr::write_csv(d, "data/validation/museum_decisions.csv", na = "")
readr::write_csv(new, file.path(p, "seed_decision.csv"), na = "")
message("Seed factual review complete and explicit selected-name gate passes; no national or global uniqueness assertion.")
