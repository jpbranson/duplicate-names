# Match city-suffixed Museum of Illusions records to the official directory's US map links.
for (f in list.files("R", pattern = "[.]R$", full.names = TRUE)) source(f)
packet <- "data/validation/museum_methodology_2026-09-23"
html <- readLines("data/raw/leaders_moi_directory_2026-09-23.html", warn = FALSE, encoding = "UTF-8")
links <- unique(unlist(regmatches(html, gregexpr("https://(www|maps)\\.google\\.com/maps/(dir|place)/[^\"]+", html))))
# Prefer the place coordinate (!3d lat !4d lon); fall back to the @lat,lon view centre.
coord <- function(u) {
  place <- regmatches(u, regexec("!3d(-?[0-9.]+)!4d(-?[0-9.]+)", u))[[1]]
  if (length(place) == 3L) return(as.numeric(place[2:3]))
  view <- regmatches(u, regexec("@(-?[0-9.]+),(-?[0-9.]+)", u))[[1]]
  as.numeric(view[2:3])
}
xy <- t(vapply(links, coord, numeric(2)))
directory <- tibble::tibble(map_link = links, directory_lat = xy[, 1], directory_lon = xy[, 2],
  directory_label = utils::URLdecode(gsub("\\+", " ", sub("^.*/maps/(dir|place)/+([^/]+)/.*$", "\\2", links))))
directory <- directory[directory$directory_lat > 18 & directory$directory_lat < 50 &
                       directory$directory_lon > -125 & directory$directory_lon < -66, ]
a <- targets::tar_read(museum_analysis)
suffixed <- a[a$analysis_eligible & grepl("^museum of illusions .+", a$name_expanded), ]
stopifnot(nrow(suffixed) == 15L)
km <- function(lat1, lon1, lat2, lon2) {
  as.numeric(sf::st_distance(sf::st_sfc(sf::st_point(c(lon1, lat1)), crs = 4326),
                             sf::st_sfc(sf::st_point(c(lon2, lat2)), crs = 4326))) / 1000
}
match <- dplyr::bind_rows(lapply(seq_len(nrow(suffixed)), function(i) {
  d <- vapply(seq_len(nrow(directory)), function(j)
    km(suffixed$lat[i], suffixed$lon[i], directory$directory_lat[j], directory$directory_lon[j]), numeric(1))
  j <- which.min(d)
  tibble::tibble(source = suffixed$source[i], source_id = suffixed$source_id[i],
    entity_id = suffixed$entity_id[i], name_raw = suffixed$name_raw[i],
    lat = suffixed$lat[i], lon = suffixed$lon[i], directory_label = directory$directory_label[j],
    directory_lat = directory$directory_lat[j], directory_lon = directory$directory_lon[j],
    distance_m = round(d[j] * 1000, 1), map_link = directory$map_link[j])
}))
readr::write_csv(match, file.path(packet, "moi_directory_match.csv"), na = "")
print(match[, c("name_raw", "directory_label", "distance_m")], n = Inf, width = Inf)
