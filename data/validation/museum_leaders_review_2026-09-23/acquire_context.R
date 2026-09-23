# Recover address, website, phone and provider context from the pinned Overture release.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_leaders_review_2026-09-23"
b <- readRDS("data/processed/leaders_review_before.rds")$records
candidates <- readr::read_csv(file.path(packet, "candidates_before.csv"), show_col_types = FALSE)
members <- b$source_id[b$source == "overture" & b$entity_id %in% candidates$entity_id]
nearby_names <- c("Stevens Memorial Museum", "Miller House Museum", "Dewey Hotel Museum", "Tom Mix Museum",
  "Washington County Heritage Center", "The Port o’ Plymouth Museum", "World of Illusions Los Angeles",
  "Greenville History Museum", "Washington City Museum", "Old Fort House Museum", "Roanoke River Maritime Museum")
related <- readr::read_csv(file.path(packet, "related_baseline_records.csv"), show_col_types = FALSE)
extra <- related$source_id[related$source == "overture" & related$name_raw %in% nearby_names]
ids <- unique(c(members, extra))
sql <- sprintf("SELECT id AS source_id, names.primary AS name_raw,
  CAST(addresses AS VARCHAR) AS addresses, CAST(websites AS VARCHAR) AS websites,
  CAST(sources AS VARCHAR) AS sources, CAST(phones AS VARCHAR) AS phones
  FROM read_parquet('%s') WHERE bbox.xmin BETWEEN -130 AND -65
  AND bbox.ymin BETWEEN 24 AND 50 AND id IN (%s)",
  dn_overture_path(), paste(sprintf("'%s'", ids), collapse = ","))
path <- "data/raw/overture_leaders_context_2026-09-23.csv"
if (!file.exists(path)) {
  con <- dn_duckdb()
  context <- DBI::dbGetQuery(con, sql)
  DBI::dbDisconnect(con)
  stopifnot(setequal(context$source_id, ids))
  readr::write_csv(context, path, na = "")
  dn_record_query(label = "overture_leaders_context", source = "overture",
    detail = list(release = DN_OVERTURE_RELEASE, source_ids = ids, sql = sql),
    path = path, n_rows = nrow(context))
}
file.copy(path, file.path(packet, "overture_context.csv"), overwrite = FALSE)
