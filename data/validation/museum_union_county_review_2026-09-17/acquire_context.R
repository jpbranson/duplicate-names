for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_union_county_review_2026-09-17"
related <- readr::read_csv(file.path(packet, "related_baseline_records.csv"), show_col_types = FALSE)
keep <- grepl("Union County|Herzstein|Cobden|Roy Acuff|Mountain Life|Blairsville", related$name_raw, ignore.case = TRUE)
ids <- related$source_id[related$source == "overture" & keep]
sql <- sprintf("SELECT id AS source_id, names.primary AS name_raw,
  CAST(addresses AS VARCHAR) AS addresses, CAST(websites AS VARCHAR) AS websites,
  CAST(sources AS VARCHAR) AS sources, CAST(phones AS VARCHAR) AS phones
  FROM read_parquet('%s') WHERE bbox.xmin BETWEEN -130 AND -65
  AND bbox.ymin BETWEEN 24 AND 50 AND id IN (%s)",
  dn_overture_path(), paste(sprintf("'%s'", ids), collapse = ","))
path <- "data/raw/overture_union_county_context_2026-09-17.csv"
if (!file.exists(path)) {
  con <- dn_duckdb()
  context <- DBI::dbGetQuery(con, sql)
  DBI::dbDisconnect(con)
  stopifnot(setequal(context$source_id, ids))
  readr::write_csv(context, path, na = "")
  dn_record_query(label = "overture_union_county_context", source = "overture",
    detail = list(release = DN_OVERTURE_RELEASE, source_ids = ids, sql = sql),
    path = path, n_rows = nrow(context))
}
file.copy(path, file.path(packet, "overture_context.csv"), overwrite = FALSE)
imls <- dn_imls_review_context("data/raw/2018_csv_museum_data_files.zip")
readr::write_csv(dplyr::filter(imls, .data$source_id %in% related$source_id),
                 file.path(packet, "imls_context.csv"), na = "")
