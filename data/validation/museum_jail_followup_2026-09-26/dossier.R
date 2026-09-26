for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_jail_followup_2026-09-26"
x <- targets::tar_read(museum_records)
keys <- c("170d0c1d-d5dc-4253-a7cd-82d8e973a35c", "d959641b-361a-4a3c-8608-ac664bbff0e2",
  "1fe73458-f3c7-4a04-9128-2a333ff0858a", "0b67fafb-eb60-4bbd-abe2-b3b8baac8c71",
  "c22b0c13-6dd7-472c-9000-c32a0a87e095", "b8639a00-9b98-4ccb-a3e1-c6ca9b06162a")
include <- x$source_id %in% keys | grepl("barnesville", x$name_raw, ignore.case = TRUE)
include <- x$entity_id %in% x$entity_id[include]
rows <- x[include, ]
readr::write_csv(rows, file.path(packet, "related_records.csv"), na = "")
ctx <- dn_imls_review_context("data/raw/2018_csv_museum_data_files.zip")
readr::write_csv(ctx[ctx$source_id %in% rows$source_id, ], file.path(packet, "imls_context.csv"), na = "")
print(rows[, c("source_id", "name_raw", "entity_id", "counted", "lon", "lat")], n = Inf, width = Inf)
print(ctx[ctx$source_id %in% rows$source_id, c("source_id", "imls_ein", "imls_physical_address", "imls_mailing_address")], n = Inf, width = Inf)
