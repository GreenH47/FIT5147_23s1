update.packages(ask = FALSE, checkBuilt = TRUE)

install.packages("maps")
library(maps) 
map("nz")# what a cute country

update.packages(ask = FALSE, checkBuilt = TRUE)
install.packages(c("curl", "yaml"))
install.packages("devtools") 
devtools::install_github("hadley/ggplot2@v2.2.0")
devtools::install_github("dkahle/ggmap")

#install.packages("ggmap")
library(ggmap)
# Define location 3 ways
# 1. location/address
myLocation1 <- "Melbourne"
myLocation1

# 2. lat/long
myLocation2 <- c(lon=-95.3632715, lat=29.7632836)# not "Melbourne"
myLocation2

# 3. an area or bounding box (4 points), lower left lon, 
# lower left lat, upper right lon, upper right lat
# (a little glitchy for google maps)
myLocation3 <- c(-130, 30, -105, 50)
myLocation3

install.packages("tmaptools")
library(tmaptools)
# Convert location/address to its lat/long coordinates:
geocode_OSM("Melbourne")
# Yes, Melbourne is where it's supposed to be in, in Australia
# longitude 144.96316
# latitude -37.81422


install.packages("stamenmap")
# or help(get_stamenmap) 
# also try ?get_googlemap, ?get_openstreetmap and ?get_cloudmademap
?get_stamenmap 


myLocation4 <- geocode_OSM("Melbourne")
bboxVector <- as.vector(myLocation4$bbox)

bbox1 <- c(
  left = bboxVector[1], 
  bottom = bboxVector[2], 
  right = bboxVector[3], 
  top = bboxVector[4]
)

myMap <- get_stamenmap(
  bbox = bbox1, 
  maptype = "watercolor",
  zoom = 13
)
ggmap(myMap)


map(m, proj = 'orth', orient = c(41,-74,0))
map.grid(m, col = 2, nx = 6, ny = 5, label = FALSE, lty = 2)
points(
  mapproject(
    list(y = 41, x = -74)
  ),
  col = 3,
  pch = "x",
  cex = 2
)# centre on NY

require(mapproj)
# get unprojected world limits
m <- map('world', plot = FALSE)
# center on New York
map(m, proj = 'azequalarea', orient = c(41,-74,0))
map.grid(m, col = 2) # draw graticules