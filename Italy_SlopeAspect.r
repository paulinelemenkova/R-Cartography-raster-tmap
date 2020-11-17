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

############################# -- GET DATA -- ######################
# Calculate terrain characteristics
# Elevation data is needed to create a hillshade map. The raster package provides an easy access to the SRTM 90 m resolution elevation data with the getData() function. For example, it is possible to download the elevation data for the whole country of "" using the code below: download the elevation data for the whole country of Slovenia
alt = getData("alt", country = "Italy", path = tempdir())
plot(alt)

############################# -- COORDINATE SYSTEM -- ######################
# Italy extent coordinates WESN: 6, 19, 36, 48.
crs(alt)
# Convert geodetic coordinate to UTM Zone 33 on the northern hemisphere
# EPSG:32633 WGS 84 / UTM zone 33N:
# +proj=longlat +datum=WGS84 +no_defs
# crs(alt) <- "+proj=utm +zone=33"
crs(alt) <- "+proj=longlat +datum=WGS84 +no_defs"
crs(alt)

# crop Raster* with Spatial* object
e <- as(extent(6, 19, 36, 48), 'SpatialPolygons')
crs(e) <- "+proj=utm +zone=33"
alt <- crop(alt, e)
plot(alt)

############################# -- Calculate terrain characteristics: SLOPE AND ASPECT -- ######################
# Hillshade maps are created based on certain terrain characteristics - slope and aspect. Both of them can be calculated with the terrain function and the opt argument set to "slope" or "aspect".
# A hillshade map can be created using the tmap package. This package builds maps by stacking different data layers. In this case, the first layer is the hillshade object (hill), colored using different levels of gray.

slope = terrain(alt, opt = "slope")
plot(slope)
aspect = terrain(alt, opt = "aspect")
plot(aspect)
hill = hillShade(slope, aspect, angle = 40, direction = 270)
plot(hill)

############################# -- Thematic Mapping -- ######################

# tmaptools::palette_explorer()

# initial mode: "plot"
# current.mode <- tmap_mode("plot")

############################# -- SLOPE-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
map1 <-
    tmap_style("classic") +
    tm_shape(slope, name = "Slope", title = "Slope") +
    tm_raster(
        palette = "Set2",
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
        legend.position = c("right","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50")

# plot map
map1
tmap_save(map1, "Italy_Slope.jpg", height = 7)

# library(sf)
# st_graticule Compute graticules and their parameters
g = st_graticule(alt, lon = c(-85, -70), lat = c(-20, -10, 0))

############################# -- ASPECT-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
map2 <-
    tmap_style("white") +
    tm_shape(aspect, name = "Aspect") +
    tm_raster(
        #palette = "Spectral",
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
        main.title = "Italy",
        main.title.position = "center",
        main.title.color = "blue",
        title = c("Aspect (0-360)"),
        title.color = "red",
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "purple",
        legend.position = c("right","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50")

# plot map
map2
tmap_save(map2, "Italy_Aspect.jpg", height = 7)

############################# -- HILLSHADE-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
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
    tm_credits("WGS84 datum", position = c("right", "bottom")) +
    tm_layout(scale = .8,
        main.title = "Italy",
        main.title.position = "center",
        main.title.color = "blue",
        title = c("Elevation (m asl)", "Title 2"),
        title.color = "red",
        legend.position = c("right","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50")

# plot map
map3
tmap_save(map3, "Italy_Hillshade.jpg", height = 7)

############################# -- ELEVATION-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
map4 <-
    tmap_style("white") +
    tm_shape(alt, name = "Elevation") +
    tm_raster(
        palette = terrain.colors(10),
        title = c("Heights, m")
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
    tm_credits("WGS84 datum", position = c("right", "bottom")) +
    tm_layout(scale = .8,
        main.title = "Italy",
        main.title.position = "center",
        main.title.color = "blue",
        title = "Elevation (m asl)",
        title.color = "red",
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "purple",
        legend.position = c("right","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50",
        legend.text.color = "brown")
# plot map
map4
tmap_save(map4, "Italy_Elevation.jpg", height = 7)

############################# -- HISTOGRAMS-- ######################
hist(hill, maxpixels=100000, plot=TRUE)
hist(alt, maxpixels=100000, plot=TRUE)
hist(slope, maxpixels=100000, plot=TRUE)
hist(aspect, maxpixels=100000, plot=TRUE)
