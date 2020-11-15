# set working directory to data folder
setwd("/Users/pauline/")

############################ -- LOAD PACKAGES -- ############
library(sp)
library(raster)
library(ncdf4)
library(RColorBrewer)
library(sf)

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

############################# -- CROP -- ######################
DEM <- raster("GEBCO_2019.nc")
# Crop Red Sea (WESN)
e <- extent(30, 50, 10, 30)
RedSea <- crop(DEM, e)

############################# -- COORDINATE SYSTEM -- ######################
r <- raster()
crs(RedSea)
# CRS arguments: +proj=longlat +datum=WGS84 +no_defs
crs(RedSea) <- "+proj=lcc +lat_1=15 +lat_2=25 +lon_0=40 +datum=WGS84"
crs(RedSea)
#w <- wkt(RedSea)
#w
#cat(w, "\n")

s <- trim(RedSea)

############################# -- VISULIAZTION-- ######################
RedSeaMap <- palette(RedSea)
#plot(RedSea, col=c(blue.col(RedSeaMap[[1]]), terrain.colors(RedSeaMap[[2]])), breaks=RedSeaMap[[3]],
 #   main="Red Sea region. \nTopographic map: GEBCO 2019",
  #  sub="Plotting: R")
#plot(RedSea, col=c(blue.col(RedSeaMap[[1]]), grey.col(RedSeaMap[[2]])), breaks=RedSeaMap[[3]],
 #   main="Red Sea region. \nTopographic map: GEBCO 2019",
  #  sub="Plotting: R")
plot(s, col=c(blue.col(RedSeaMap[[1]]), yel.col(RedSeaMap[[2]])), breaks=RedSeaMap[[3]],
    main="Red Sea region. \nTopographic map: GEBCO 2019",
    sub="Plotting: R", npretty=4, xlab="N", ylab="E")
contour(s, add=TRUE)
#scalebar(1000, xy=c(30, 11), type='bar', divs=3, below = "km")

############################# -- GRID-- ######################
e <- as(raster::extent(30, 50, 10, 30), "SpatialPolygons") %>%
  st_as_sf()
grid <- st_make_grid(e, cellsize = c(5, 2.5))
plot(grid, add=TRUE)

############################# -- HISTOGRAMS-- ######################
hist(RedSea, maxpixels=100000, plot=TRUE)


