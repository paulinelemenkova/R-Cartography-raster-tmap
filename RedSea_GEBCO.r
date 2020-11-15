# set working directory to data folder
setwd("/Users/pauline/")

############################ -- LOAD PACKAGES -- ############
library(sp)
library(raster)
library(ncdf4)

############################ -- CREATE COLOUR PALETTE -- ############
blue.col <- colorRampPalette(c("darkblue", "lightblue"))
palette <- function(x, b1=50, b2=50, r1=-2, r2=-2) {
 mi <- cellStats(x, stat="min")-100
 ma <- cellStats(x, stat="max")+100
 s1 <- unique(round(seq(mi, 0, 0-mi/b1),r1))
 s2 <- unique(round(seq(0, ma, ma/b2),r2))
 s3 <- c(s1, s2[-1])
 x <- list(length(s1)-1, length(s2)-1, s3)
}

############################# -- CROP and VISULIAZTION-- ######################
DEM <- raster("GEBCO_2019.nc")
# Crop Red Sea (WESN)
e <- extent(30, 50, 10, 30)
RedSea <- crop(DEM, e)

RedSeaMap <- palette(RedSea)
plot(RedSea, col=c(blue.col(RedSeaMap[[1]]), terrain.colors(RedSeaMap[[2]])), breaks=RedSeaMap[[3]],
    main="Red Sea region. \nTopographic map: GEBCO 2019",
    sub="Plotting: R",)
contour(RedSea, add=TRUE)
