# Hillshade map. Hillshade maps show the topographical shape of hills and mountains using levels of gray on a map. The role of this kind of maps is to display relative slopes, but not absolute height. https://geocompr.github.io/geocompkg/articles/maps.html
# set working directory to data folder
setwd("/Users/pauline/")

############################ -- LOAD PACKAGES -- ############
library(sp)
library(raster)
library(ncdf4)
library(RColorBrewer)
library(sf)
library(tmap)

############################# -- CROP -- ######################
DEM <- raster("GEBCO_2019.nc")
# Crop Red Sea (WESN)
e <- extent(-85, -70, -20, 1)
Peru <- crop(DEM, e)

############################# -- COORDINATE SYSTEM -- ######################
crs(Peru)
# CRS arguments: +proj=longlat +datum=WGS84 +no_defs
crs(Peru) <- "+proj=lcc +lat_1=-14 +lat_2=-7 +lon_0=-77 +datum=WGS84"
crs(Peru)
s <- trim(Peru)

############################ -- CREATE COLOUR PALETTE -- ############
blue.col <- colorRampPalette(c("darkblue", "lightblue"))
#grey.col <- colorRampPalette(c("white", "black"))
yel.col <- colorRampPalette(c("moccasin", "navajowhite4"))
palette <- function(x, b1=50, b2=50, r1=-2, r2=-2) {
 mi <- cellStats(x, stat="min")-100
 ma <- cellStats(x, stat="max")+100
 s1 <- unique(round(seq(mi, 0, 0-mi/b1),r1))
 s2 <- unique(round(seq(0, ma, ma/b2),r2))
 s3 <- c(s1, s2[-1])
 x <- list(length(s1)-1, length(s2)-1, s3)
}

############################# -- VISULIAZTION-- ######################
PeruMap <- palette(Peru)
plot(s, col=terrain.colors(256), alpha=NULL,
    main="Peru region. \nTopographic map: GEBCO 2019",
    sub="Plotting: R", npretty=4, xlab="N", ylab="E")
contour(s, add=TRUE)
#scalebar(1000, xy=c(30, 11), type='bar', divs=3, below = "km")

############################# -- GET DATA -- ######################
# Calculate terrain characteristics
# Elevation data is needed to create a hillshade map. The raster package provides an easy access to the SRTM 90 m resolution elevation data with the getData() function. For example, it is possible to download the elevation data for the whole country of "" using the code below: download the elevation data for the whole country of Slovenia
alt = getData("alt", country = "Peru", path = tempdir())

############################# -- Calculate terrain characteristics: SLOPE AND ASPECT -- ######################

# Hillshade maps are created based on certain terrain characteristics - slope and aspect. Both of them can be calculated with the terrain function and the opt argument set to "slope" or "aspect".

slope = terrain(alt, opt = "slope")
aspect = terrain(alt, opt = "aspect")
hill = hillShade(slope, aspect, angle = 40, direction = 270)
plot(hill)

slope = terrain(RedSea, opt = "slope", unit="radians", neighbors=8)
plot(slope)

aspect = terrain(RedSea, opt = "aspect")
plot(aspect)

hill = hillShade(slope, aspect, angle = 40, direction = 270)
plot(hill)

plot(aspect)
contour(RedSea, add=TRUE)

############################# -- Create a hillshade map -- ######################
# A hillshade map can be created using the tmap package. This package builds maps by stacking different data layers. In this case, the first layer is the hillshade object (hill), colored using different levels of gray.

# tmaptools::palette_explorer()

# initial mode: "plot"
current.mode <- tmap_mode("plot")

############################# -- SLOPE-- ######################
map1 <-
    tmap_style("classic") +
    tm_shape(slope, name = "Slope", title = "Slope") +
    tm_raster(
        palette = "-plasma",
        title = "Slope",
        legend.show = TRUE
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.5,
        text.color = "black",
        color.dark = "black",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1) +
    tm_compass(position=c("left", "bottom")) +
    tm_layout(scale = .8,
        legend.position = c("left","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50")

# plot map
map1
tmap_save(map1, "Slope_Peru.jpg", height = 7)

############################# -- ASPECT-- ######################
map2 <-
    tmap_style("white") +
    tm_shape(aspect, name = "Aspect") +
    tm_raster(
        palette = "Spectral",
        title = "Aspect",
        legend.show = TRUE
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.5,
        text.color = "black",
        color.dark = "black",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1,
        ) +
    tm_compass(position=c("left", "bottom")) +
    tm_layout(scale = .8,
        legend.position = c("left","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50")

# plot map
map2
tmap_save(map2, "Aspect_Peru.jpg", height = 7)

############################# -- HILLSHADE-- ######################

map3 <-
    tmap_style("cobalt") +
    tm_shape(hill, name = "Hillshade") +
    tm_raster(
        palette = "PiYG",
        title = "Hillshade",
        legend.show = TRUE
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.5,
        text.color = "white",
        color.dark = "grey",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1,
        ) +
    tm_compass(position=c("right", "bottom")) +
    tm_layout(scale = .8,
        legend.position = c("left","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50")

# plot map
map3
tmap_save(map3, "Hillshade_Peru.jpg", height = 7)

############################# -- ELEVATION-- ######################
vol <- raster::raster(t(volcano[, ncol(volcano):1]), xmn=0, xmx=870, ymn=0, ymx=610)
isolines <- smooth_map(alt, smooth.raster = FALSE, nlevels = 10)
isolines <- contour(alt)

map4 <-
    tm_shape(alt, name = "Elevation") +
    tm_raster(
        palette = terrain.colors(10),
        title = "Elevation (m asl)",
        legend.show = TRUE) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.5,
        text.color = "black",
        color.dark = "black",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1) +
    tm_compass(position=c("left", "bottom")) +
    tm_layout(scale = .8,
        legend.position = c("left","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50")

# plot map
map4
tmap_save(map4, "Elevation_Peru.jpg", height = 7)

############################# -- HISTOGRAMS-- ######################
hist(hill, maxpixels=100000, plot=TRUE)
hist(alt, maxpixels=100000, plot=TRUE)
hist(slope, maxpixels=100000, plot=TRUE)
hist(aspect, maxpixels=100000, plot=TRUE)


############################# -- GRID-- ######################
e <- as(raster::extent(30, 50, 10, 30), "SpatialPolygons") %>%
  st_as_sf()
grid <- st_make_grid(e, cellsize = c(5, 2.5))
plot(grid, add=TRUE, col = 'grey', pch=3)
