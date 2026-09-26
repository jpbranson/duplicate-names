# Pinned August taxonomy; no changes to the museum adapter or release.
src_overture_worship <- function(release = DN_OVERTURE_RELEASE,
                                 cache = 'data/raw/overture_worship_2026-08-19.0.parquet') {
  if (file.exists(cache)) return(dn_validate(tibble::as_tibble(arrow::read_parquet(cache)), dn_schema_raw()))
  con <- dn_duckdb()
  on.exit(DBI::dbDisconnect(con))
  sql <- sprintf("SELECT id, names.primary AS name_raw, categories.primary AS legacy_category,
    taxonomy.primary AS taxonomy_primary, array_to_string(taxonomy.hierarchy, '|') AS hierarchy,
    ST_X(geometry) AS lon, ST_Y(geometry) AS lat, addresses[1].country AS country,
    addresses, websites, phones, brand.names.primary AS operator, brand.wikidata AS wikidata_id,
    confidence, operating_status,
    CAST(list_max(list_transform(list_filter(sources, s -> s.provider IS DISTINCT FROM 'overture'),
      s -> try_cast(s.update_time AS TIMESTAMP))) AS DATE) AS source_update_time
    FROM read_parquet('%s') WHERE addresses[1].country = 'US'
    AND (list_contains(taxonomy.hierarchy, 'place_of_worship') OR taxonomy.primary = 'religious_organization')",
    dn_overture_path(release))
  message('[church Overture] querying pinned worship hierarchy and organization holdouts')
  x <- tibble::as_tibble(DBI::dbGetQuery(con, sql))
  if (anyDuplicated(x$id)) stop('Duplicate Overture IDs')
  context <- sub('[.]parquet$', '_context.parquet', cache)
  arrow::write_parquet(x, context)
  out <- dn_church_raw('overture', x$id, x$name_raw, x$lon, x$lat, x$taxonomy_primary,
    updated=x$source_update_time, status=x$operating_status)
  out$country <- x$country
  out$operator <- x$operator
  out$wikidata_id <- x$wikidata_id
  out$confidence <- x$confidence
  denominations <- c(baptist_place_of_worship='baptist', roman_catholic_place_of_worship='roman_catholic',
    pentecostal_place_of_worship='pentecostal', anglican_or_episcopal_place_of_worship='anglican_episcopal',
    jehovahs_witness_place_of_worship='jehovahs_witness')
  out$denomination <- unname(denominations[x$taxonomy_primary])
  out$religion <- ifelse(grepl('(^|[|])christian_place_of_worship([|]|$)',x$hierarchy),'christian',NA_character_)
  other <- c(jewish_place_of_worship='jewish',muslim_place_of_worship='muslim',buddhist_place_of_worship='buddhist',
             hindu_place_of_worship='hindu',sikh_place_of_worship='sikh')
  other_idx <- x$taxonomy_primary %in% names(other)
  out$religion[other_idx] <- unname(other[x$taxonomy_primary[other_idx]])
  out <- dn_validate(out,dn_schema_raw(),'Overture worship')
  arrow::write_parquet(out,cache)
  dn_record_query('overture_worship', 'overture', list(release=release,sql=sql,
    scope='US address country, all worship descendants plus religious-organization holdouts',
    license='CDLA-Permissive-2.0 / Apache-2.0; no OSM enrichment'),cache,nrow(out))
  dn_record_query('overture_worship_context','overture',list(release=release,sql=sql),context,nrow(x))
  out
}

# Full-resolution 2023 TIGER place polygons for the C2 denominator. CDPs retained
# and distinguished from incorporated places; Census place != municipality.
src_census_places <- function(year = 2023L, cache = 'data/raw/census_places_2023.rds') {
  if (file.exists(cache)) return(readRDS(cache))
  codes <- c('01','02','04','05','06','08','09','10','11','12','13','15','16','17','18','19',
    '20','21','22','23','24','25','26','27','28','29','30','31','32','33','34','35','36','37',
    '38','39','40','41','42','44','45','46','47','48','49','50','51','53','54','55','56')
  out <- lapply(codes,function(st) {
    name <- sprintf('tl_%s_%s_place.zip',year,st)
    zip <- dn_fetch(sprintf('https://www2.census.gov/geo/tiger/TIGER%s/PLACE/%s',year,name),
      sprintf('census_%s_places_%s',year,st),file.path('data/raw/census_places',name))
    x <- sf::st_read(paste0('/vsizip/',normalizePath(zip,winslash='/')),quiet=TRUE)
    x[,c('STATEFP','PLACEFP','GEOID','NAME','NAMELSAD','CLASSFP','FUNCSTAT')]
  })
  x <- sf::st_transform(do.call(rbind,out),4326)
  if (anyDuplicated(x$GEOID)) stop('Duplicate Census place GEOIDs')
  x <- sf::st_make_valid(x)
  saveRDS(x,cache)
  dn_record_query('census_places_2023','census',list(year=year,scope='50 states and DC',
    geometry='Full TIGER/Line; incorporated places and census-designated places retained'),cache,nrow(x))
  x
}
# State geometry supplies the 50-state/DC scope, including points outside places.
src_census_states <- function(cache='data/raw/census_states_2023.rds') {
  if(file.exists(cache)) return(readRDS(cache))
  zip<-dn_fetch('https://www2.census.gov/geo/tiger/TIGER2023/STATE/tl_2023_us_state.zip',
    'census_2023_states','data/raw/tl_2023_us_state.zip')
  x<-sf::st_read(paste0('/vsizip/',normalizePath(zip,winslash='/')),quiet=TRUE)
  x<-x[x$STUSPS %in% DN_US_STATE_ABBRS,c('STATEFP','STUSPS','NAME')]
  x<-sf::st_make_valid(sf::st_transform(x,4326))
  saveRDS(x,cache)
  dn_record_query('census_states_2023','census',list(year=2023,scope='50 states and DC',geometry='Full TIGER/Line'),cache,nrow(x))
  x
}
