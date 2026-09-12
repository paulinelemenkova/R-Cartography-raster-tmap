# ============================================================================
# DEM-based terrain relief of Bulgaria in R (tmap + raster): slope, aspect,
# hillshade and elevation mapping
#
# This script produced the R figures in the peer-reviewed article:
#   Lemenkova, P. (2022). Geocomputation of DEM Based Terrain Relief in Bulgaria
#   Using GMT and R Scripting Approaches. Annual of the University of
#   Architecture, Civil Engineering and Geodesy (UACEG), Sofia, 55(1), 169-181.
#   DOI (Zenodo): https://doi.org/10.5281/zenodo.6405154
#   HAL:          https://hal.science/hal-03627173
#   SSRN:         https://papers.ssrn.com/sol3/papers.cfm?abstract_id=4072391
#
# The article combines GMT and R; this repository holds the R (tmap/raster)
# scripts.
#
# Author: Polina Lemenkova  |  ORCID: 0000-0002-5759-1089
# ============================================================================

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
alt = getData("alt", country = "Bulgaria", path = tempdir())

############################# -- Calculate terrain characteristics: SLOPE AND ASPECT -- ######################
# Hillshade maps are created based on certain terrain characteristics - slope and aspect. Both of them can be calculated with the terrain function and the opt argument set to "slope" or "aspect".
# A hillshade map can be created using the tmap package. This package builds maps by stacking different data layers. In this case, the first layer is the hillshade object (hill), colored using different levels of gray.

slope = terrain(alt, opt = "slope")
plot(slope)
aspect = terrain(alt, opt = "aspect")
plot(aspect)
hill = hillShade(slope, aspect, angle = 40, direction = 270)
plot(hill)
plot(alt)

############################# -- SLOPE-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
#data(World)
map1 <-
    tmap_style("white") +
#"classic"  "white", "gray", "natural", "cobalt", "col_blind", "albatross", "beaver", "bw", "watercolor"
    tm_shape(slope, name = "Slope", title = "Slope") +
    tm_raster(
        title = "Slope (0\u00B0-90\u00B0)",
        palette = "plasma",
      #  style = "fisher",
      #  style = "kmeans",
        style = "quantile", n = 6,
        breaks = c(5, 15, 30, 60, 75, 90),
#        labels = c("gentle", "moderate", "strong", "very strong", "steep", "extreme"),
        legend.show = T,
        legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.8,
        text.color = "black",
        color.dark = "black",
        color.light = "white",
        position=c("right", "bottom"),
        lwd = 1) +
    tm_compass(
        type = "radar", position=c("left", "bottom"), size = 10.0) +
# "arrow", "4star", "8star", "radar", "rose"
    tm_layout(scale = .8,
        main.title = "Slope terrain analysis based on DEM of Bulgaria. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 1.0,
        title = "Slope (0\u00B0-90\u00B0)",
        title.color = "black",
        title.size = 1.0,
        title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.0,
        legend.position = c("right","bottom"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
#        legend.frame = "gray50",
        legend.outside = FALSE,
        legend.width = .3,
        legend.height = .5,
        legend.hist.height = .15,
        legend.title.size = 0.9,
        legend.text.size = 0.8,
#        bg.color="cornsilk",
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE,
        lines = TRUE,
        labels.rot = c(15, 15),
        col = "azure3", lwd = 1,
        labels.size = 1.0)
# plot map
map1
tmap_save(map1, "Bulgaria_Slope.jpg", dpi = 300, height = 10)

############################# -- ASPECT-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
map2 <-
    tmap_style("white") +
#"classic"  "white", "gray", "natural", "cobalt", "col_blind", "albatross", "beaver", "bw", "watercolor"
    tm_shape(aspect, name = "Slope", title = "Slope") +
    tm_raster(
        title = "Aspect (West-East-South-North)",
        palette = "Spectral",
      #  style = "fisher",
      #  style = "kmeans",
        style = "quantile", n = 6,
        breaks = c(5, 15, 30, 60, 75, 90),
#        labels = c("gentle", "moderate", "strong", "very strong", "steep", "extreme"),
        legend.show = T,
        legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.9,
        text.color = "black",
        color.dark = "black",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1) +
    tm_compass(
        type = "rose", position=c("right", "top"), size = 10.0) +
# "arrow", "4star", "8star", "radar", "rose"
    tm_layout(scale = .8,
        main.title = "Aspect terrain analysis based on DEM of Bulgaria. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 0.9,
        title = "Aspect (W-E-S-N)",
        title.color = "black",
        title.size = 1.0,
        title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.0,
        legend.position = c("right","bottom"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
#        legend.frame = "gray50",
        legend.outside = FALSE,
        legend.width = .3,
        legend.height = .5,
        legend.hist.height = .14,
        legend.title.size = 0.9,
        legend.text.size = 0.9,
#        bg.color="cornsilk",
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE,
        lines = TRUE,
        labels.rot = c(15, 15),
        col = "azure3", lwd = 1,
        labels.size = 1.0)
# plot map
map2
tmap_save(map2, "Bulgaria_Aspect.jpg", dpi = 300, height = 10)

Twomaps <- tmap_arrange(map1, map2)
Twomaps
tmap_save(Twomaps, "Serbia_SlopeAspect.jpg", dpi = 300, height = 10, width = 15)

############################# -- HILLSHADE-- ######################
# tmaptools::palette_explorer()
tmap_mode("plot")
map3 <-
    tmap_style("cobalt") +
#"classic"  "white", "gray", "natural", "cobalt", "col_blind", "albatross", "beaver", "bw", "watercolor"
    tm_shape(hill, name = "Hillshade", title = "Hillshade",
        auto.palette.mapping = FALSE,) +
    tm_raster(
        title = "Histogram \n(data distribution)",
        palette = "cividis",
        style = "kmeans",
        legend.show = T,
        legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.9,
        text.color = "white",
        color.dark = "grey",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1) +
    tm_compass(
        type = "rose", position=c("right", "top"), size = 10.0) +
# "arrow", "4star", "8star", "radar", "rose"
    tm_layout(scale = .9,
        main.title = "Hillshade terrain analysis based on DEM of Bulgaria. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 1.0,
        title = "Hillshade (0\u00B0-90\u00B0)",
        title.color = "darkgoldenrod1",
        title.size = 1.0,
        title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.0,
        legend.position = c("right","bottom"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
        legend.frame = "gray50",
        legend.outside = FALSE,
        legend.width = .3,
        legend.height = .5,
        legend.hist.height = .13,
        legend.title.size = 1.1,
        legend.text.size = 0.9,
#        bg.color="cornsilk",
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE,
        lines = TRUE,
        col = "azure3",
        lwd = 1,
        labels.size = 1.0,
# labels.rot = c(30, 30),
        labels.col = "black")
# plot map
map3
tmap_save(map3, "Bulgaria_Hillshade.jpg", height = 10)

############################# -- ELEVATION-- ######################
tmap_mode("plot")
map4 <-
    tmap_style("cobalt") +
#"classic"  "white", "gray", "natural", "cobalt", "col_blind", "albatross", "beaver", "bw", "watercolor"
    tm_shape(alt, name = "Elevation", title = "Elevation") +
    tm_raster(
        title = "Elevation (m asl)",
        palette = terrain.colors(256),
        legend.show = T,
        legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.9,
        text.color = "white",
        color.dark = "black",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1) +
    tm_compass(
        type = "8star", position=c("right", "bottom"), size = 10.0) +
# "arrow", "4star", "8star", "radar", "rose"
    tm_layout(scale = .8,
        main.title = "Elevation terrain analysis based on DEM of Bulgaria. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 1.0,
        title = "Elevation (m)",
        title.color = "white",
        title.size = 1.0,
        title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.0,
        legend.position = c("right","bottom"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
#        legend.frame = "gray50",
        legend.outside = FALSE,
        legend.width = .3,
        legend.height = .5,
        legend.hist.height = .2,
        legend.title.size = 0.9,
        legend.text.size = 0.9,
#        bg.color="cornsilk",
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE,
        lines = TRUE,
        labels.rot = c(15, 15),
        col = "azure3", lwd = 1,
        labels.size = 1.0)
# plot map
map4
tmap_save(map4, "Bulgaria_Elevation.jpg", dpi = 300, height = 10)

############################# -- COMBINED: ELEVATION+HILLSHADE-- ######################
tmap_mode("plot")
map4 <-
    tmap_style("cobalt") +
#"classic"  "white", "gray", "natural", "cobalt", "col_blind", "albatross", "beaver", "bw", "watercolor"
    tm_shape(hill) +
    tm_raster(palette = gray(0:10 / 10), legend.show = F) +
    tm_shape(alt, name = "Elevation", title = "Elevation") +
    tm_raster(
        title = "Elevation (m asl)",
        alpha = 0.5,
        palette = terrain.colors(256),
        legend.show = T,
        legend.hist = T,
        legend.hist.z=0,
        ) +
    tm_scale_bar(
        width = 0.25,
        text.size = 0.9,
        text.color = "white",
        color.dark = "gray50",
        color.light = "white",
        position=c("left", "bottom"),
        lwd = 1) +
    tm_compass(
        type = "8star", position=c("right", "top"), size = 10.0) +
# "arrow", "4star", "8star", "radar", "rose"
    tm_layout(scale = .8,
        main.title = "Elevation terrain analysis and hillshade relief based on DEM of Bulgaria. Mapping: R",
        main.title.position = "center",
        main.title.color = "black",
        main.title.size = 1.0,
        title = "Elevation (m)",
        title.color = "white",
        title.size = 1.0,
        title.position = c("left", "top"),
        panel.labels = c("R packages: tmap, raster, sp, sf"),
        panel.label.color = "darkslateblue",
        panel.label.size = 1.0,
        legend.position = c("right","bottom"),
        legend.bg.color = "grey90",
        legend.bg.alpha = .2,
#        legend.frame = "gray50",
        legend.outside = FALSE,
        legend.width = .3,
        legend.height = .5,
        legend.hist.height = .14,
        legend.title.size = 0.9,
        legend.text.size = 0.9,
#        bg.color="cornsilk",
        inner.margins = 0) +
    tm_graticules(
        ticks = TRUE,
        lines = TRUE,
        labels.rot = c(15, 15),
        col = "azure3", lwd = 1,
        labels.size = 1.0)
# plot map
map4
tmap_save(map4, "Bulgaria_Elevation.jpg", dpi = 300, height = 10)


tm_shape(hill) +
  tm_raster(palette = gray(0:10 / 10), style = "cont", legend.show = FALSE) +
  tm_layout(legend.position = c("RIGHT", "BOTTOM"))

Twomaps <- tmap_arrange(map3, map4)
Twomaps
tmap_save(Twomaps, "Bulgaria_HillElev.jpg", dpi = 300, height = 10, width = 15)

############################# -- HISTOGRAMS-- ######################
hist(hill, maxpixels=100000, plot=TRUE)
hist(alt, maxpixels=100000, plot=TRUE)
hist(slope, maxpixels=100000, plot=TRUE)
hist(aspect, maxpixels=100000, plot=TRUE)
