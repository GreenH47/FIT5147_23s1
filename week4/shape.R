install.packages("maptools")
install.packages("rgdal")

library(maptools)
library(rgdal) #we will use this package to read shape files


nz <- readOGR("NZL_adm0.shp")
plot(nz)

world <- readOGR("ne_110m_land.shp")
plot(world)

library(ggplot2)
world_shp <- readOGR("ne_110m_land.shp")
ggplot(
  world_shp,
  aes(
    x=long,
    y=lat,
    group=group
  )
) + 
  geom_path()

library(ggmap) # Load the shapes and transform
library(maptools)
area <- readOGR("ne_10m_parks_and_protected_lands_area.shp")
area.points <- fortify(area) # transform to table structure

library(RColorBrewer)
colors <- brewer.pal(9,"BuGn")

margin = 15
bbox1 <- c(
  left = -118 - margin, 
  bottom = 37.5 - margin, 
  right = -118 + margin, 
  top = 37.5 + margin
)


mapImage <- get_stamenmap(
  bbox = bbox1,
  color = "color",
  maptype = "terrain",
  zoom =6
)

ggmap(mapImage) +
  geom_polygon(
    aes(x=long, y=lat, group=group),
    data = area.points,
    color = colors[9],
    fill = colors[6],
    alpha =0.5
  ) +
  labs(x="Longitude", y="Latitude")
#Step by step.

# Plot the base map
plot(mapImage)