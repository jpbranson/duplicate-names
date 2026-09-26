for (f in list.files('R', pattern='[.]R$', full.names=TRUE)) source(f)
library(dplyr)
p <- 'data/validation/church_phase1_2026-09-26'
folder <- 'data/processed/church_review'
read <- function(name) readr::read_csv(file.path(folder,paste0(name,'.csv')),show_col_types=FALSE)
x <- targets::tar_read(church_named_analysis,store='_targets_churches')
r <- targets::tar_read(church_records,store='_targets_churches')
raw <- targets::tar_read(church_raw,store='_targets_churches')
checks <- tibble::tibble(check=character(),passed=logical(),detail=character())
check <- function(name,value,detail='') {
  checks <<- bind_rows(checks,tibble::tibble(check=name,passed=isTRUE(value),detail=detail))
  if (!isTRUE(value)) stop(name)
}
check('source_rows_preserved',nrow(r)==nrow(raw),as.character(nrow(r)))
key <- function(z) paste(z$source,z$source_id,sep=':')
j <- match(key(raw),key(r))
check('source_keys_unique',!anyDuplicated(key(raw)) && !anyDuplicated(key(r)))
check('raw_name_coordinates_preserved',identical(raw$name_raw,r$name_raw[j]) &&
  identical(raw$lon,r$lon[j]) && identical(raw$lat,r$lat[j]))
check('one_analysis_row_per_spine_entity',!anyDuplicated(x$entity_id) && all(x$source=='overture'))
check('no_legacy_or_osm_counted',all(r$source[r$counted]=='overture') && !any(r$source=='osm'))
eligible <- x[x$analysis_eligible,]
check('scope_and_unverified_status',all(eligible$counted) && all(eligible$religion=='christian') &&
  all(eligible$state_match_status=='one_state') && all(x$review_status=='pending'))
check('denomination_conflicts_held',all(is.na(x$denom_norm[x$denom_conflict])))
counts <- read('duplicate_counts')
expected <- vapply(unique(counts$level),function(level) sum(!is.na(eligible[[level]]) & nzchar(eligible[[level]])),integer(1))
actual_counts <- tapply(counts$n_entities,counts$level,sum)
check('normalization_count_totals',all(actual_counts[names(expected)]==expected),
  paste(names(expected),expected,collapse='; '))
for (name in c('census_place_exclusivity','incorporated_place_exclusivity')) {
  tab <- read(name)
  check(paste0(name,'_denominator'),all(tab$n_occupied_places==tab$n_zero_first+tab$n_exactly_one_first+tab$n_multiple_first) &&
    all(abs(tab$exclusivity_rate-tab$n_exactly_one_first/tab$n_occupied_places)<1e-12))
}
dist <- read('territory_distances')
check('territory_contains_only_firsts',all(x$ordinal[match(dist$entity_id,x$entity_id)] %in% 1L))
check('neighbors_are_other_entities',all(is.na(dist$neighbor_id) | dist$neighbor_id!=dist$entity_id))
check('distances_nonnegative',all(is.na(dist$distance_km) | dist$distance_km>=0))
j <- match(dist$neighbor_id,eligible$entity_id)
check('neighbors_share_l3',all(is.na(j) | dist$name_core==eligible$name_core[j]))
idx <- which(is.finite(dist$distance_km));set.seed(20260926);idx <- sample(idx,min(200L,length(idx)))
a <- sf::st_as_sf(dist[idx,],coords=c('lon','lat'),crs=4326)
b <- sf::st_as_sf(eligible[j[idx],],coords=c('lon','lat'),crs=4326)
actual <- as.numeric(sf::st_distance(a,b,by_element=TRUE))/1000
check('reported_neighbor_distance_sample',all(abs(actual-dist$distance_km[idx])<1e-7),'200 seeded rows')
matching <- read('matching_labels_blank');styles <- read('classifier_labels_blank')
check('independent_labels_still_blank',all(is.na(matching$same_institution)) && all(is.na(styles$human_name_style)) && all(is.na(styles$human_denom_family)))
check('sample_sizes',nrow(matching)==300L && nrow(styles)==500L,paste(nrow(matching),nrow(styles)))
check('publication_gates_incomplete',all(read('publication_gates')$status=='incomplete'))
archive <- file.path(p,'independent_review_v2')
dir.create(archive,showWarnings=FALSE)
for (name in c('matching_labels_blank','matching_predictions','classifier_labels_blank','classifier_predictions','cluster_review')) {
  dest <- file.path(archive,paste0(name,'.csv'))
  # Never replace an archived sheet that might now contain human work.
  if(!file.exists(dest)) stopifnot(file.copy(file.path(folder,paste0(name,'.csv')),dest))
}
readr::write_csv(checks,file.path(p,'national_output_checks.csv'))
summary <- list(status='provisional',raw_records=nrow(raw),spine_entities=nrow(x),
  eligible_sites=nrow(eligible),counted_source_rows=sum(r$counted),
  excluded_entities=sum(!x$analysis_eligible),matching_labels=nrow(matching),classifier_labels=nrow(styles),
  checks=nrow(checks),cloud_cost_usd=0,publication_ready=FALSE,
  source_counts=as.list(table(raw$source)),leading_l3=head(as.data.frame(counts[counts$level=='name_core',]),10))
jsonlite::write_json(summary,file.path(p,'national_checkpoint.json'),pretty=TRUE,auto_unbox=TRUE)
print(summary)
source(file.path(p,'check_preservation.R'))


