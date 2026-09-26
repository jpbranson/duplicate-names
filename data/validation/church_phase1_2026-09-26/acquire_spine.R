for (f in list.files('R',pattern='[.]R$',full.names=TRUE)) source(f)
# Correct the parser's DATE_EDIT typo from retained raw context without redownload.
x <- tibble::as_tibble(arrow::read_parquet('data/raw/gnis_church_context_20210825.parquet'))
y <- tibble::as_tibble(arrow::read_parquet('data/raw/gnis_church_20210825.parquet'))
stopifnot(identical(x$FEATURE_ID,y$source_id))
y$source_update_time <- as.Date(x$DATE_EDITED,format='%m/%d/%Y')
arrow::write_parquet(y,'data/raw/gnis_church_20210825_v2.parquet')
dn_record_query('gnis_church_adapter_v2','gnis',list(snapshot='2021-08-25',class='Church',states=DN_US_STATE_ABBRS,
  date_field='DATE_EDITED', scope='historical geographic features, not current census'),
  'data/raw/gnis_church_20210825_v2.parquet',nrow(y))
x <- src_overture_worship()
message('Overture acquired: ',nrow(x))
print(table(x$category_raw))
p <- src_census_places()
message('Census places acquired: ',nrow(p))

