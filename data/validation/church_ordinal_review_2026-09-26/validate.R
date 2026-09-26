for(f in list.files('R',pattern='[.]R$',full.names=TRUE))source(f)
p<-'data/validation/church_ordinal_review_2026-09-26';store<-'_targets_churches'
checklist<-tibble::tibble(check=character(),passed=logical(),detail=character())
check<-function(name,value,detail='') {
 checklist<<-dplyr::bind_rows(checklist,tibble::tibble(check=name,passed=isTRUE(value),detail=detail))
 readr::write_csv(checklist,file.path(p,'integrity_checks.csv'))
 if(!isTRUE(value))stop(name)
}
before<-readRDS('data/processed/church_ordinal_analysis_before.rds')
after<-targets::tar_read(church_named_analysis,store=store)
raw<-targets::tar_read(church_raw,store=store)
norm<-targets::tar_read(church_normalized,store=store)
records<-targets::tar_read(church_records,store=store)
readr::write_csv(after[!is.na(after$scope_review_evidence),],file.path(p,'scope_holds.csv'),na='')
hashes<-readr::read_csv(file.path(p,'targets_before.csv'),show_col_types=FALSE)
check('raw_target_unchanged',digest::digest(raw,algo='sha256')==hashes$sha256[hashes$target=='church_raw'])
check('source_rows_retained',nrow(raw)==1032223L && nrow(norm)==nrow(raw) && nrow(records)==nrow(raw))
j<-match(paste(raw$source,raw$source_id),paste(records$source,records$source_id))
check('all_original_source_fields_retained',identical(raw[,names(dn_schema_raw())],records[j,names(dn_schema_raw())]))
j<-match(before$entity_id,after$entity_id)
check('canonical_inventory_preserved',nrow(after)==540778L && !anyDuplicated(after$entity_id) && !anyNA(j))
check('canonical_source_count_points_unchanged',identical(before[,c('entity_id','source_id','counted','lon','lat')],after[j,c('entity_id','source_id','counted','lon','lat')]))
check('only_two_sourced_scope_holds',sum(after$analysis_eligible)==442832L && sum(!is.na(after$scope_review_evidence))==2L && sum(before$analysis_eligible!=after$analysis_eligible[j])==2L)
check('scope_holds_preserve_raw_category',all(after$religion[!is.na(after$scope_review_evidence)]=='christian'))
check('no_full_review_status_promoted',all(after$review_status=='pending'))
check('threshold_retained',DN_NAME_SIM_MIN==0.85)
change<-which(!dplyr::coalesce(before$ordinal==after$ordinal[j],is.na(before$ordinal)&is.na(after$ordinal[j])))
changed<-after[j[change],];changed$ordinal_before<-before$ordinal[change]
readr::write_csv(changed,file.path(p,'analysis_ordinal_changes.csv'),na='')
read<-function(n) readr::read_csv(file.path('data/processed/church_review',paste0(n,'.csv')),show_col_types=FALSE)
for(n in c('matching_labels_blank','classifier_labels_blank')) {
 tab<-read(n);fields<-intersect(c('same_institution','human_name_style','human_denom_family','reviewer'),names(tab))
 check(paste0(n,'_blank'),all(is.na(as.matrix(tab[,fields]))))
}
check('all_publication_gates_incomplete',all(read('publication_gates')$status=='incomplete'))
counts<-read('duplicate_counts');e<-after[after$analysis_eligible,]
check('all_name_count_totals',all(vapply(unique(counts$level),function(level)
 sum(counts$n_entities[counts$level==level])==sum(!is.na(e[[level]]) & nzchar(e[[level]])),logical(1))))
for(n in c('census_place_exclusivity','incorporated_place_exclusivity')) {
 tab<-read(n);check(paste0(n,'_denominator'),all(tab$n_occupied_places==tab$n_zero_first+tab$n_exactly_one_first+tab$n_multiple_first))
}
territory<-read('territory_distances')
check('territory_only_firsts',all(after$ordinal[match(territory$entity_id,after$entity_id)]%in%1L))
check('no_self_neighbor',all(is.na(territory$neighbor_id)|territory$neighbor_id!=territory$entity_id))
oldmap<-readr::read_csv('posts/duplicate-church-names/payload/first-baptist-map.csv',show_col_types=FALSE)
newmap<-e[e$name_core=='first baptist church',]
k<-match(oldmap$entity_id,newmap$entity_id)
# Raw/canonical doubles were compared bit-for-bit above. CSV parsing can differ
# by one floating-point ULP; independently bound that serialization discrepancy.
check('existing_map_matches_serialized_precision',nrow(oldmap)==nrow(newmap) && !anyNA(k) &&
 max(abs(oldmap$lon-newmap$lon[k]))<1e-12 && max(abs(oldmap$lat-newmap$lat[k]))<1e-12,
 sprintf('max lon %.3g; max lat %.3g degrees',max(abs(oldmap$lon-newmap$lon[k])),max(abs(oldmap$lat-newmap$lat[k]))))
protected<-readr::read_csv(file.path(p,'protected_files.csv'),show_col_types=FALSE)
check('prior_evidence_byte_preserved',all(vapply(protected$path,digest::digest,character(1),algo='sha256',file=TRUE)==protected$sha256),as.character(nrow(protected)))
check('original_church_names_unchanged',identical(readBin('data/validation/church_name_overrides.csv','raw',n=1e6),readBin(file.path(p,'church_name_overrides.csv.before'),'raw',n=1e6)))
for(n in c('duplicate_counts','census_place_exclusivity','incorporated_place_exclusivity','territory_summary',
 'ordinal_ladders','naming_style_profile','municipal_multiplicity','coverage','publication_gates')) {
 stopifnot(file.copy(file.path('data/processed/church_review',paste0(n,'.csv')),file.path(p,paste0(n,'_after.csv'))))
}
summary<-list(status='validated_provisional',raw_rows=nrow(raw),canonical_entities=nrow(after),eligible=sum(after$analysis_eligible),
 scope_holds=2L,complete_factual_reviews=0L,analysis_ordinal_changes=length(change),checks=nrow(checklist),cloud_cost_usd=0,publication_ready=FALSE)
jsonlite::write_json(summary,file.path(p,'checkpoint.json'),auto_unbox=TRUE,pretty=TRUE)
print(summary)
