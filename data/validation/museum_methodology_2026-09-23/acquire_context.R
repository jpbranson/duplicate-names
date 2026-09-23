# Pinned-release context for the 15 city-suffixed Museum of Illusions records.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_methodology_2026-09-23"
match <- readr::read_csv(file.path(packet, "moi_directory_match.csv"), show_col_types = FALSE)
ids <- match$source_id[match$source == "overture"]
stopifnot(length(ids) == 15L)
sql <- sprintf("SELECT id AS source_id, names.primary AS name_raw,
  CAST(addresses AS VARCHAR) AS addresses, CAST(websites AS VARCHAR) AS websites,
  CAST(sources AS VARCHAR) AS sources, CAST(phones AS VARCHAR) AS phones
  FROM read_parquet('%s') WHERE bbox.xmin BETWEEN -130 AND -65
  AND bbox.ymin BETWEEN 24 AND 50 AND id IN (%s)",
  dn_overture_path(), paste(sprintf("'%s'", ids), collapse = ","))
path <- "data/raw/overture_moi_suffixed_context_2026-09-23.csv"
if (!file.exists(path)) {
  con <- dn_duckdb()
  context <- DBI::dbGetQuery(con, sql)
  DBI::dbDisconnect(con)
  stopifnot(setequal(context$source_id, ids))
  readr::write_csv(context, path, na = "")
  dn_record_query(label = "overture_moi_suffixed_context", source = "overture",
    detail = list(release = DN_OVERTURE_RELEASE, source_ids = ids, sql = sql),
    path = path, n_rows = nrow(context))
}
file.copy(path, file.path(packet, "overture_context.csv"), overwrite = FALSE)
x <- readr::read_csv(path, show_col_types = FALSE)
for (i in seq_len(nrow(x))) cat(x$source_id[i], "|", x$name_raw[i], "|", x$addresses[i], "|", x$websites[i], "\n")
