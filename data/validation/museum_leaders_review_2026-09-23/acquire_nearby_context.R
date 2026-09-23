# Second pinned-release query: named museums near the candidate societies, which the
# first query's name filter did not include.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_leaders_review_2026-09-23"
ids <- c("128b5b25-e15b-4e75-be9b-50de8321e93b", "2e03a301-90df-48b5-a2e9-d39efc4f87b9",
  "7de4411b-c2f7-41d0-8a71-341f74508fb4", "b71c8d0b-0fc7-434f-8509-b7a23747f3ec",
  "e86b58f2-280f-45b5-af2f-3659960971e7", "ae837bd5-a2b6-40bf-bfa2-1be4a7b40cc4",
  "9832f3f9-63f6-4619-9e08-b4034a1c9ad1", "6bbaaa21-4cec-42e5-b2e8-8a7d9365778e",
  "ab3bae62-5671-4936-a294-475feffc010c", "b23a408a-b80b-494a-a3e8-1d5659930846",
  "9af7f732-8277-46e3-bbe8-74905cfec832", "fc7fc664-15e9-4d1c-99da-0e1d5e8ee2fd",
  "5d2a75f7-aea5-41b1-8ff3-f7dbba8a7256", "ff6574a6-2332-4c5e-b285-b1ddc3d3bd72",
  "f7568790-92b8-46f6-b086-0ccd033a53c8", "58f1aeb5-b88a-479e-8cfa-d01c5b8109d6",
  "11aca0e5-d05d-4aae-a11f-04805c2ac265", "cb7581ed-3ce4-4e71-af13-6451c34711be")
sql <- sprintf("SELECT id AS source_id, names.primary AS name_raw,
  CAST(addresses AS VARCHAR) AS addresses, CAST(websites AS VARCHAR) AS websites,
  CAST(sources AS VARCHAR) AS sources, CAST(phones AS VARCHAR) AS phones
  FROM read_parquet('%s') WHERE bbox.xmin BETWEEN -130 AND -65
  AND bbox.ymin BETWEEN 24 AND 50 AND id IN (%s)",
  dn_overture_path(), paste(sprintf("'%s'", ids), collapse = ","))
path <- "data/raw/overture_leaders_nearby_context_2026-09-23.csv"
if (!file.exists(path)) {
  con <- dn_duckdb()
  context <- DBI::dbGetQuery(con, sql)
  DBI::dbDisconnect(con)
  stopifnot(setequal(context$source_id, ids))
  readr::write_csv(context, path, na = "")
  dn_record_query(label = "overture_leaders_nearby_context", source = "overture",
    detail = list(release = DN_OVERTURE_RELEASE, source_ids = ids, sql = sql),
    path = path, n_rows = nrow(context))
}
file.copy(path, file.path(packet, "overture_nearby_context.csv"), overwrite = FALSE)
