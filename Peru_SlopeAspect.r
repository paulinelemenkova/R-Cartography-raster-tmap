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
alt = getData("alt", country = "Peru", path = tempdir())

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
tmap_mode("plot")
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
tmap_mode("plot")
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
    tm_layout(scale = .8,
        legend.position = c("left","top"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50")

# plot map
map3
tmap_save(map3, "Hillshade_Peru.jpg", height = 7)

############################# -- ELEVATION-- ######################
tmap_mode("plot")
map4 <-
    tmap_style("white") +
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
