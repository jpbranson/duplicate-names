# Source adapters for the separate church pipeline. No museum inputs are changed.
DN_US_STATE_ABBRS <- c(state.abb, 'DC')
DN_HIFLD_SERVICE <- paste0('https://services.arcgis.com/XG15cJAlne2vxtgt/arcgis/rest/services/',
                          'All_Places_Of_Worship__HiFLD_Open_/FeatureServer/42')

# Construct exact raw types while preserving source values in cached context tables.
dn_church_raw <- function(source, id, name, lon, lat, category_raw,
                          retrieved = Sys.Date(), updated = as.Date(NA),
                          status = NA_character_) {
  n <- length(id)
  tibble::tibble(source = rep(source, n), source_id = as.character(id),
    category = rep('place_of_worship', n), category_raw = rep_len(as.character(category_raw), n),
    name_raw = as.character(name), lon = as.double(lon), lat = as.double(lat),
    country = rep('US', n), denomination = rep(NA_character_, n),
    religion = rep(NA_character_, n), operator = rep(NA_character_, n),
    wikidata_id = rep(NA_character_, n), confidence = rep(NA_real_, n),
    operating_status = rep_len(as.character(status), n),
    source_update_time = rep_len(as.Date(updated), n), retrieved = rep_len(as.Date(retrieved), n))
}

# 2021 Church is a geographic feature class, not proof of a current congregation.
src_gnis <- function(cache = 'data/raw/gnis_church_20210825_v2.parquet') {
  if (file.exists(cache)) return(dn_validate(tibble::as_tibble(arrow::read_parquet(cache)), dn_schema_raw()))
  url <- 'https://prd-tnm.s3.amazonaws.com/StagedProducts/GeographicNames/Archive/MainDomestic/NationalFile.zip'
  zip <- dn_fetch(url, 'gnis_20210825_archive', 'data/raw/gnis_NationalFile_20210825.zip')
  folder <- 'data/raw/gnis_20210825'
  dir.create(folder, recursive = TRUE, showWarnings = FALSE)
  txt <- file.path(folder, 'NationalFile_20210825.txt')
  if (!file.exists(txt)) utils::unzip(zip, exdir = folder)
  con <- DBI::dbConnect(duckdb::duckdb())
  on.exit(DBI::dbDisconnect(con))
  sql <- sprintf("SELECT * FROM read_csv(%s, delim='|', header=true, all_varchar=true) WHERE FEATURE_CLASS = 'Church' AND STATE_ALPHA IN (%s)",
    DBI::dbQuoteString(con, normalizePath(txt, winslash='/')), paste(DBI::dbQuoteString(con, DN_US_STATE_ABBRS), collapse=','))
  x <- tibble::as_tibble(DBI::dbGetQuery(con, sql))
  if (anyDuplicated(x$FEATURE_ID)) stop('GNIS feature IDs are not unique')
  arrow::write_parquet(x, 'data/raw/gnis_church_context_20210825.parquet')
  out <- dn_church_raw('gnis', x$FEATURE_ID, x$FEATURE_NAME,
    as.numeric(x$PRIM_LONG_DEC), as.numeric(x$PRIM_LAT_DEC), x$FEATURE_CLASS,
    updated = as.Date(x$DATE_EDITED, format='%m/%d/%Y'),
    status = ifelse(grepl('[(]historical[)]', x$FEATURE_NAME, ignore.case=TRUE), 'historical', NA_character_))
  out <- dn_validate(out, dn_schema_raw(), 'GNIS churches')
  arrow::write_parquet(out, cache)
  dn_record_query('gnis_church_adapter_v2', 'gnis', list(snapshot='2021-08-25', sql=sql,
    scope='50 states and DC; historical geographic features, not current census'), cache, nrow(out))
  out
}

# Resumable, bounded pages from the public FEMA service linked by EPA's IRS 2024 item.
# Source modification dates are NOT assigned to individual congregations.
src_hifld <- function(cache = 'data/raw/hifld_worship_fema_20260926.parquet', page_size = 2000L) {
  if (file.exists(cache)) return(dn_validate(tibble::as_tibble(arrow::read_parquet(cache)), dn_schema_raw()))
  folder <- 'data/raw/hifld_worship_20260926'
  dir.create(folder, recursive=TRUE, showWarnings=FALSE)
  meta_file <- dn_fetch(paste0(DN_HIFLD_SERVICE, '?f=json'), 'hifld_fema_metadata_20260926', file.path(folder,'metadata.json'))
  meta <- jsonlite::fromJSON(meta_file)
  if (!is.null(meta$error)) stop(meta$error$message)
  count_file <- dn_fetch(paste0(DN_HIFLD_SERVICE, '/query?where=1%3D1&returnCountOnly=true&f=json'),
    'hifld_fema_count_20260926', file.path(folder, 'count.json'))
  total <- jsonlite::fromJSON(count_file)$count
  if (is.null(total) || total < 1L) stop('HIFLD count unavailable')
  fields <- c('FID','EIN','NAME','STREET','CITY','STATE','ZIP','AFFILIATIO','RULING','NTEE_CD',
              'LOC_NAME','ADDR_TYPE','MATCH_TYPE','SCORE','GEOCODED_S','MATCH_ADDR','X','Y')
  fields <- intersect(fields, meta$fields$name)
  pages <- vector('list', ceiling(total/page_size))
  for (i in seq_along(pages)) {
    offset <- (i-1L)*page_size
    url <- paste0(DN_HIFLD_SERVICE, '/query?where=1%3D1&outFields=', paste(fields, collapse=','),
      '&outSR=4326&returnGeometry=true&orderByFields=FID&resultOffset=',offset,
      '&resultRecordCount=',page_size,'&f=json')
    path <- dn_fetch(url, sprintf('hifld_fema_page_%04d',i), file.path(folder,sprintf('page_%04d.json',i)))
    j <- jsonlite::fromJSON(path)
    if (!is.null(j$error)) stop(j$error$message)
    if (is.null(j$features$attributes)) stop('Empty or invalid HIFLD page ',i)
    pages[[i]] <- tibble::as_tibble(j$features$attributes)
    pages[[i]]$geometry_lon <- j$features$geometry$x
    pages[[i]]$geometry_lat <- j$features$geometry$y
    expected <- min(page_size,total-offset)
    if (nrow(pages[[i]]) != expected) stop('Incomplete HIFLD page ',i)
  }
  x <- dplyr::bind_rows(pages)
  if (nrow(x) != total || anyDuplicated(x$FID)) stop('HIFLD count/ID integrity failure')
  live <- jsonlite::fromJSON(rawToChar(curl::curl_fetch_memory(paste0(DN_HIFLD_SERVICE,'?f=json'))$content))
  if (!identical(meta$editingInfo$dataLastEditDate, live$editingInfo$dataLastEditDate)) stop('HIFLD changed during extraction')
  arrow::write_parquet(x, 'data/raw/hifld_worship_context_20260926.parquet')
  x <- dplyr::filter(x, .data$STATE %in% DN_US_STATE_ABBRS)
  out <- dn_church_raw('hifld', x$FID, x$NAME, x$geometry_lon, x$geometry_lat, 'IRS places of worship')
  out <- dn_validate(out, dn_schema_raw(), 'HIFLD worship')
  arrow::write_parquet(out, cache)
  dn_record_query('hifld_fema_adapter', 'hifld', list(service=DN_HIFLD_SERVICE,
    publisher='FEMA_HQ_Preparedness_NIC', epa_item='02934d1d566c4ce6b48887f767e3cfab',
    dataLastEditDate=meta$editingInfo$dataLastEditDate,total_service_rows=total,
    scope='50 states and DC; legal names/geocoded tax addresses; operation unknown'),cache,nrow(out))
  out
}


