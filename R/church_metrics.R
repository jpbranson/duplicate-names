# Reusable church metric guards and exact leave-one-out spherical nearest neighbors.
dn_church_metric_rows <- function(x) {
  required <- c('entity_id','counted','category','name_core','ordinal','denom_norm')
  if(!all(required %in% names(x))) stop('Church entity columns missing')
  x <- x[x$counted %in% TRUE & x$category=='place_of_worship',]
  if(anyDuplicated(x$entity_id)) stop('Church metrics require one counted canonical row per entity')
  if('analysis_eligible' %in% names(x)) x<-x[x$analysis_eligible %in% TRUE,]
  x
}


# Query the two nearest distinct TARGET FEATURES (not vertices) in s2's index.
# Remove the query's own row explicitly. If ties omit self, both returned features
# are co-located and either is a valid zero-distance neighbor. The API's output is
# not assumed distance-sorted. Distances are then measured with sf on s2 geography.
dn_leave_one_out_s2 <- function(lon,lat) {
  if(any(!is.finite(lon) | !is.finite(lat) | abs(lon)>180 | abs(lat)>90)) stop('Valid geographic coordinates required')
  n<-length(lon)
  if(n<2L) return(list(neighbor=rep(NA_integer_,n),distance_m=rep(NA_real_,n)))
  geo<-s2::s2_lnglat(lon,lat)
  candidates<-s2::s2_closest_edges(geo,geo,k=2L)
  neighbor<-vapply(seq_len(n),function(i) {
    other<-candidates[[i]][candidates[[i]]!=i]
    if(!length(other)) stop('S2 did not return another feature')
    other[1]
  },integer(1))
  pts<-sf::st_as_sf(data.frame(lon,lat),coords=c('lon','lat'),crs=4326)
  list(neighbor=neighbor,distance_m=as.numeric(sf::st_distance(pts,pts[neighbor,],by_element=TRUE)))
}
