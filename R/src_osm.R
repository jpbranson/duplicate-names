# Bounded OSM samples are INTERNAL validation context only (ODbL). They are never
# bound into the permissive church analysis or published as independent labels.
src_osm <- function(bbox, label, country='US', endpoint='https://overpass-api.de/api/interpreter') {
  if(length(bbox)!=4L || any(!is.finite(bbox)) || bbox[1]>=bbox[3] || bbox[2]>=bbox[4]) stop('bbox must be south, west, north, east')
  if((bbox[3]-bbox[1])*(bbox[4]-bbox[2])>2) stop('Use a bounded validation region of at most 2 square degrees')
  if(!grepl('^[a-z0-9_]+$',label)) stop('Use a simple stable region label')
  query <- sprintf('[out:json][timeout:90];nwr["amenity"="place_of_worship"](%s);out center tags;',paste(bbox,collapse=','))
  path <- dn_fetch(paste0(endpoint,'?data=',utils::URLencode(query,reserved=TRUE)),
    paste0('osm_validation_',label),paste0('data/raw/osm_validation_',label,'.json'))
  j <- jsonlite::fromJSON(path,simplifyVector=FALSE)
  if(!is.null(j$remark)) stop('Overpass reported incomplete query: ',j$remark)
  elem <- j$elements
  if(!length(elem)) return(dn_schema_raw())
  field <- function(k) vapply(elem,function(e) as.character(e$tags[[k]] %||% NA_character_),character(1))
  out <- dn_church_raw('osm',vapply(elem,function(e) paste(e$type,e$id,sep='/'),character(1)),
    field('name'),vapply(elem,function(e) e$lon %||% e$center$lon %||% NA_real_,numeric(1)),
    vapply(elem,function(e) e$lat %||% e$center$lat %||% NA_real_,numeric(1)),'amenity=place_of_worship')
  out$country<-country;out$denomination<-field('denomination');out$religion<-field('religion')
  out$operator<-field('operator');out$wikidata_id<-field('wikidata')
  dn_validate(out,dn_schema_raw(),'OSM validation sample')
}
