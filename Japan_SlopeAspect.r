# Set working directory
setwd("/Users/pauline/")

############################ -- LOAD PACKAGES -- ############
library(sp)
library(raster)
library(ncdf4)
library(RColorBrewer)
library(sf)
library(tmap)

############################# -- CHECK UP AVAILABLE FONTS -- ######################
library(showtext)
font_families()
font_paths()
font_files()

############################# -- GET DATA -- ######################
alt = getData("alt", country = "Japan", path = tempdir())

############################# -- COORDINATE SYSTEM -- ######################
crs(alt) <- "+proj=longlat +datum=WGS84 +no_defs"
# Default CRS arguments: +proj=longlat +datum=WGS84 +no_defs
crs(alt) <- "+proj=lcc +lat_1=-30 +lat_2=40 +lon_0=140 +datum=WGS84"
crs(alt)

# -- Calculate terrain characteristics: SLOPE, ASPECT, HILLSHADE -- #
cols <- rainbow(255)
# Slope
slope = terrain(alt, opt = "slope")
cols <- bpy.colors(255)
plot(slope, col=cols, main='Slope', xlab = "lon", ylab = "lat")
# Aspect
aspect = terrain(alt, opt = "aspect")
cols <- terrain.colors(255)
plot(aspect, col=cols, main='Exposure', xlab = "lon", ylab = "lat")
# Hillshade
hill = hillShade(slope, aspect, angle = 40, direction = 270)
cols <- rev(topo.colors(255))
cols <- topo.colors(255)
plot(hill, col=cols, main='Hillshade', xlab = "lon", ylab = "lat")
# Elevation
cols <- rainbow(255)
plot(alt, col=cols, main='Elevation', xlab = "lon", ylab = "lat")

############################# -- Thematic Mapping -- ######################
# tmaptools::palette_explorer()
# initial mode: "plot"
# current.mode <- tmap_mode("plot")

############################# -- SLOPE-- ######################
# tmap_style available styles: "white", "gray", "natural", "cobalt", "col_blind", "albatross", "beaver", "bw", "watercolor"
tmap_mode("plot")
map1 <-
    tmap_style("albatross"
        ) +
    tm_shape(slope, name = "Slope", title = "Slope",
        raster.downsample = T,
        ) +
    tm_raster(
        title = "Slope (0\u00B0-90\u00B0)", palette = "-plasma",
        style = "quantile", n = 6, breaks = c(5, 15, 30, 60, 75, 90),
        labels = c("gentle", "moderate", "strong", "very strong", "extreme", "steep"),
        legend.show = T,legend.hist = T, legend.hist.z = 0,
        ) +
    tm_scale_bar(
        width = 0.5,
        text.size = 1.5, text.color = "darkgoldenrod1",
        color.dark = "lightsteelblue4", color.light = "white",
        position=c("left", "bottom"), lwd = 1,
        ) +
    tm_compass(
        type = "radar", position=c("right", "bottom")
        ) +
    tm_layout(scale = .8,
        main.title = "Slope: terrain analysis based on SRTM90 DEM of Italy. Mapping: R",
        main.title.position = "center",
        main.title.color = "black", main.title.size = 1.4,
        title = "Data: SRTM90 DEM",
        title.color = "darkgoldenrod1",
        title.size = 1.2, title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.2, legend.position = c("right","bottom"),
        legend.bg.color = "grey90", legend.bg.alpha = .2,
        legend.frame = "gray50", legend.outside = FALSE,
        legend.width = 0.9, legend.height = .5,
        legend.hist.height = 0.3, legend.title.size = 1.2,
        legend.text.size = 0.6, legend.text.fontface = "plain",
        legend.text.fontfamily = "Helvetica",
        inner.margins = 0.1,
        ) +
    tm_graticules(
        ticks = T, lines = T, labels.rot = c(15, 15),
        col = "azure3", lwd = 1, labels.size = 1.2
        )
# plot map
map1
tmap_save(map1, "Slope_Japan.jpg", height = 7)

############################# -- ASPECT-- ######################
tmap_mode("plot")
map2 <-
    tmap_style("albatross"
        ) +
    tm_shape(aspect, name = "Aspect", title = "Aspect",
        raster.downsample = T,
        ) +
    tm_raster(
        title = "Aspect (West-East-South-North)", palette = "Spectral",
        style = "sd", labels = c("West", "East", "South", "North"),
        legend.show = T, legend.hist = T, legend.hist.z = 0,
        ) +
    tm_scale_bar(
        width = 0.5,
        text.size = 1.5, text.color = "darkgoldenrod1",
        color.dark = "lightsteelblue4", color.light = "white",
        position=c("left", "bottom"), lwd = 1,
        ) +
    tm_compass(
        type = "radar", position=c("right", "bottom")
        ) +
    tm_layout(scale = .8,
        main.title = "Aspect: terrain analysis based on SRTM90 DEM of Italy. Mapping: R",
        main.title.position = "center",
        main.title.color = "black", main.title.size = 1.4,
        title = "Data: SRTM90 DEM. Aspect (W-E-S-N)",
        title.color = "darkgoldenrod1",
        title.size = 1.2, title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.2, legend.position = c("left","top"),
        legend.bg.color = "grey90", legend.bg.alpha = .2,
        legend.frame = "gray50", legend.outside = FALSE,
        legend.width = .3, legend.height = .5,
        legend.hist.height = .3, legend.title.size = 1.2,
        legend.text.size = 1.2, legend.text.fontface = "plain",
        legend.text.fontfamily = "Helvetica",
        inner.margins = 0,
        ) +
    tm_graticules(
        ticks = T, lines = T, labels.rot = c(15, 15),
        col = "azure3", lwd = 1, labels.size = 1.2
        )
# plot map
map2
tmap_save(map2, "Aspect_Japan.jpg", height = 7)

############################# -- HILLSHADE-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
map3 <-
    tmap_style("albatross") +
    tm_shape(hill, name = "Hillshade", title = "Slope",
        auto.palette.mapping = FALSE,) +
    tm_raster(
        title = "Histogram \n(data distribution)",
        palette = "cividis", style = "kmeans",
        legend.show = T, legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 1.2, text.color = "darkgoldenrod1",
        color.dark = "lightsteelblue4", color.light = "white",
        position=c("right", "bottom"), lwd = 1) +
    tm_compass(
        type = "radar", position=c("left", "bottom")) +
    tm_layout(scale = .8,
        main.title = "Hillshade: Terrain analysis based on SRTM90 DEM of Japan. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 1.4, title = "Hillshade (0\u00B0-90\u00B0)",
        title.color = "darkgoldenrod1",
        title.size = 1.2, title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        legend.position = c("left","top"), legend.bg.color = "grey90",
        legend.bg.alpha = .2, legend.frame = "gray50",
        legend.outside = FALSE, legend.width = .3,
        legend.height = .5, legend.hist.height = .2,
        legend.text.size = 1.0, legend.text.fontface = "plain",
        legend.title.size = 1.2,
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE, lines = TRUE,
        col = "azure3", lwd = 1,
        labels.size = 1.0,
        labels.col = "black")
# plot map
map3
tmap_save(map3, "Japan_Hillshade.jpg", height = 7)

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

mymaps <- tmap_arrange(map2, map3)
mymaps <- tmap_arrange(aspect, hill)
mymaps

############################# -- HISTOGRAMS-- ######################
hist(hill, maxpixels=100000, plot=TRUE)
hist(alt, maxpixels=100000, plot=TRUE)
hist(slope, maxpixels=100000, plot=TRUE)
hist(aspect, maxpixels=100000, plot=TRUE)
