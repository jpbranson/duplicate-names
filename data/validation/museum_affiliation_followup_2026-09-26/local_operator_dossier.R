for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
p <- "data/validation/museum_affiliation_followup_2026-09-26"
a <- targets::tar_read(museum_analysis); e <- targets::tar_read(entities)
x <- a[grepl("warden|hay lake|erickson|depot railroad|stevens", a$name_raw, ignore.case = TRUE) & (abs(a$lon + 92.806) < .2 & abs(a$lat - 45.055) < .3 | abs(a$lon + 86.1) < .2 & abs(a$lat - 38.61) < .2), ]
readr::write_csv(x, file.path(p, "local_operator_candidates.csv"), na = "")
print(x[c("source_id", "name_raw", "lon", "lat", "entity_id", "affiliation_status")], width = Inf)
readr::write_csv(e[e$entity_id %in% x$entity_id, ], file.path(p, "local_operator_records.csv"), na = "")
