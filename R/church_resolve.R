# Church candidate matching uses the retained 0.85 score plus two church guards.
# Museum entities and the museum multi-site heuristic are never called here.
dn_church_candidate_pairs <- function(x,radius_m=DN_SITE_RADIUS_M) {
  empty<-tibble::tibble(row_a=integer(),row_b=integer(),distance_m=double(),similarity=double(),
    ordinal_conflict=logical(),denom_conflict=logical(),would_merge=logical())
  valid<-is.finite(x$lon) & is.finite(x$lat) & abs(x$lon)<=180 & abs(x$lat)<=90
  spine<-x$source=='overture' & x$religion %in% 'christian' &
    x$category_raw!='religious_organization' & !x$operating_status %in% c('permanently_closed','historical') &
    !is.na(x$name_expanded) & nzchar(x$name_expanded)
  query<-which(valid & spine)
  targets<-which(valid & (spine | x$source!='overture'))
  if(!length(query) || length(targets)<2L) return(empty)
  pts<-sf::st_as_sf(x[targets,c('lon','lat')],coords=c('lon','lat'),crs=4326)
  q<-match(query,targets)
  message('[church pairs] ',length(query),' worship-site queries; ',length(targets),' source targets')
  near<-sf::st_is_within_distance(pts[q,],pts,dist=units::set_units(radius_m,'m'))
  a<-rep(query,lengths(near));b<-targets[unlist(near,use.names=FALSE)]
  keep<-x$source[b]!='overture' | b>a
  a<-a[keep];b<-b[keep]
  if(!length(a)) return(empty)
  message('[church pairs] scoring ',length(a),' candidate pairs; no legacy-only comparisons')
  # Score in bounded batches to avoid several simultaneous copies of millions of
  # token lists. Source and row IDs remain exact for reproducible label samples.
  chunks<-split(seq_along(a),ceiling(seq_along(a)/50000L))
  out<-lapply(seq_along(chunks),function(k) {
    take<-chunks[[k]];aa<-a[take];bb<-b[take]
    sim<-dn_name_similarity(x$name_expanded[aa],x$name_expanded[bb])
    ord_conflict<-!is.na(x$ordinal[aa]) & !is.na(x$ordinal[bb]) & x$ordinal[aa]!=x$ordinal[bb]
    denom_conflict<-!is.na(x$denom_norm[aa]) & !is.na(x$denom_norm[bb]) & x$denom_norm[aa]!=x$denom_norm[bb]
    distance<-as.numeric(sf::st_distance(pts[match(aa,targets),],pts[match(bb,targets),],by_element=TRUE))
    message('[church pairs] batch ',k,'/',length(chunks))
    tibble::tibble(row_a=aa,row_b=bb,distance_m=distance,similarity=sim,
      ordinal_conflict=ord_conflict,denom_conflict=denom_conflict,
      would_merge=sim>=DN_NAME_SIM_MIN & !ord_conflict & !denom_conflict &
        !is.na(x$name_expanded[bb]) & nzchar(x$name_expanded[bb]))
  })
  dplyr::bind_rows(out)
}
# Connected components on the contemporary spine only. Historical/legal inputs
# stay independent comparisons until matching is independently evaluated. In
# particular, one imprecise tax address cannot bridge two Overture congregations.
dn_resolve_churches <- function(x,pairs=dn_church_candidate_pairs(x)) {
  dn_validate(x,dn_schema_normalized(),'church resolution input')
  n <- nrow(x)
  if(!n) return(dn_schema_entity())
  parent <- seq_len(n)
  ord_parent <- x$ordinal; denom_parent <- x$denom_norm; religion_parent <- x$religion
  root <- function(i) { while(parent[i]!=i) i<-parent[i];i }
  edges <- pairs[pairs$would_merge & x$source[pairs$row_a]=='overture' & x$source[pairs$row_b]=='overture',]
  # Guard closure and broad religious-organization holdouts against joining the
  # current physical-worship spine. These rows still appear in diagnostics.
  eligible <- x$category_raw!='religious_organization' & x$religion %in% 'christian' &
    !x$operating_status %in% c('permanently_closed','historical')
  for(k in seq_len(nrow(edges))) {
    a<-edges$row_a[k];b<-edges$row_b[k]
    if(!isTRUE(eligible[a]) || !isTRUE(eligible[b])) next
    ra<-root(a);rb<-root(b)
    if(ra!=rb) {
      conflict <- function(z) !is.na(z[ra]) && !is.na(z[rb]) && z[ra]!=z[rb]
      if(conflict(ord_parent) || conflict(denom_parent) || conflict(religion_parent)) next
      keep<-min(ra,rb);drop<-max(ra,rb);parent[drop]<-keep
      ord_parent[keep]<-dplyr::coalesce(ord_parent[keep],ord_parent[drop])
      denom_parent[keep]<-dplyr::coalesce(denom_parent[keep],denom_parent[drop])
      religion_parent[keep]<-dplyr::coalesce(religion_parent[keep],religion_parent[drop])
    }
  }
  comp <- vapply(seq_len(n),root,integer(1))
  keys<-paste(x$source,x$source_id,sep=':')
  # An anchor source key is already unique. Sorting makes IDs independent of
  # input order, without a million singleton digest/group-mutate calls.
  anchor_order<-order(comp,keys)
  anchors<-anchor_order[!duplicated(comp[anchor_order])]
  anchor_for<-anchors[match(comp,comp[anchors])]
  x$entity_id<-paste0('church_',keys[anchor_for])
  canonical_order<-order(comp,-as.numeric(x$source_update_time),-x$confidence,x$source_id,na.last=TRUE)
  canonical<-canonical_order[!duplicated(comp[canonical_order])]
  canonical_for<-canonical[match(comp,comp[canonical])]
  x$n_sources<-rep(1L,n);x$source_set<-x$source
  x$is_franchise<-rep(NA,n);x$chain_id<-rep(NA_character_,n)
  x$site_id<-paste0('site_',x$entity_id);x$n_sites<-rep(1L,n);x$is_primary_site<-rep(TRUE,n)
  x$primary_name<-x$name_raw[canonical_for];x$alt_names<-rep('',n)
  multi<-comp %in% comp[duplicated(comp)]
  for(idx in split(which(multi),comp[multi])) {
    aliases<-paste(setdiff(unique(x$name_raw[idx]),x$primary_name[idx[1]]),collapse=' | ')
    x$alt_names[idx]<-aliases
  }
  x$counted<-seq_len(n)==canonical_for
  x$exclusion_reason<-ifelse(x$counted,NA_character_,'automatic_duplicate_record')
  x$state_fips<-rep(NA_character_,n);x$county_fips<-rep(NA_character_,n)
  x$place_geoid<-rep(NA_character_,n);x$place_name<-rep(NA_character_,n)
  reason <- dplyr::case_when(
    x$source!='overture' ~ 'historical_or_legal_comparison_only',
    x$operating_status %in% 'permanently_closed' ~ 'source_permanently_closed',
    x$category_raw=='religious_organization' ~ 'organization_not_verified_worship_site',
    !x$religion %in% 'christian' ~ 'outside_christian_category_or_unknown',
    !is.finite(x$lon) | !is.finite(x$lat) | abs(x$lon)>180 | abs(x$lat)>90 ~ 'invalid_coordinates',
    is.na(x$name_core) | !nzchar(x$name_core) ~ 'no_name',
    TRUE ~ x$exclusion_reason)
  x$counted <- is.na(reason)
  x$exclusion_reason <- reason
  x<-x[order(x$entity_id,seq_len(n)!=canonical_for,x$source_id),]
  dn_validate(x,dn_schema_entity(),'church records')
}

# Full TIGER polygons; a boundary hit on several places is kept unresolved.
dn_attach_church_places <- function(x,places) {
  if(!inherits(places,'sf') || !all(c('GEOID','STATEFP','NAME','CLASSFP') %in% names(places))) stop('Full Census place geometry required')
  if(anyDuplicated(places$GEOID)) stop('Duplicate place GEOIDs')
  valid <- which(is.finite(x$lon) & is.finite(x$lat) & abs(x$lon)<=180 & abs(x$lat)<=90)
  x$place_match_status <- 'invalid_coordinates'
  x$place_class <- NA_character_
  if(length(valid)) {
    pts <- sf::st_as_sf(x[valid,c('lon','lat')],coords=c('lon','lat'),crs=4326)
    hits <- sf::st_intersects(pts,sf::st_transform(places,4326))
    x$place_match_status[valid] <- ifelse(lengths(hits)==1L,'one_place',ifelse(lengths(hits)==0L,'outside_census_place','ambiguous_boundary'))
    ok <- which(lengths(hits)==1L); rows<-valid[ok];j<-unlist(hits[ok],use.names=FALSE)
    x$place_geoid[rows]<-places$GEOID[j];x$place_name[rows]<-places$NAME[j]
    x$state_fips[rows]<-places$STATEFP[j];x$place_class[rows]<-places$CLASSFP[j]
  }
  x
}




