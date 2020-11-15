library(raster)
# https://rspatial.org/raster/spatial/8-rastermanip.html

# set working directory to data folder
setwd("/Users/pauline/")

library(raster)
library(rgdal)
library(sp)


# RasterLayer with the default parameters
x <- raster()
x
## class      : RasterLayer
## dimensions : 180, 360, 64800  (nrow, ncol, ncell)
## resolution : 1, 1  (x, y)
## extent     : -180, 180, -90, 90  (xmin, xmax, ymin, ymax)
## crs        : +proj=longlat +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0

# With some other parameters
x <- raster(ncol=36, nrow=18, xmn=-1000, xmx=1000, ymn=-100, ymx=900)

These parameters can be changed. Resolution:

res(x)
## [1] 55.55556 55.55556
res(x) <- 100
res(x)
## [1] 100 100

Change the number of columns (this affects the resolution).

ncol(x)
## [1] 20
ncol(x) <- 18
ncol(x)
## [1] 18
res(x)
## [1] 111.1111 100.0000

#Set the coordinate reference system (CRS) (i.e., define the projection).
projection(x) <- "+proj=utm +zone=48 +datum=WGS84"
x
## class      : RasterLayer
## dimensions : 10, 18, 180  (nrow, ncol, ncell)
## resolution : 111.1111, 100  (x, y)
## extent     : -1000, 1000, -100, 900  (xmin, xmax, ymin, ymax)
## crs        : +proj=utm +zone=48 +datum=WGS84 +ellps=WGS84 +towgs84=0,0,0

#First another example empty raster geometry.

r <- raster(ncol=10, nrow=10)
ncell(r)
## [1] 100
hasValues(r)
## [1] FALSE
values(r) <- 1:ncell(r)

#Another example.
set.seed(0)
values(r) <- runif(ncell(r))
hasValues(r)
## [1] TRUE
inMemory(r)
## [1] TRUE
values(r)[1:10]
##  [1] 0.8966972 0.2655087 0.3721239 0.5728534 0.9082078 0.2016819 0.8983897
##  [8] 0.9446753 0.6607978 0.6291140
plot(r, main='Raster with 100 cells')

# It is more common, however, to create a RasterLayer object from a file. The raster package can use raster files in several formats, including some ‘natively’ supported formats and other formats via the rgdal package.
# Do not use this system.file construction of your own files (just type the file name; don’t forget the forward slashes).

#new_raster <- raster("raster_filepath")
#r <- raster("/Users/pauline/rt_TPI.tif")
r <- raster("/Users/pauline/ETOPO1_KKT_EAC.tif")
filename(r)
plot(r)

############################# -- 1. VISUALIZATION -- #############
# GeoTIFF
DEM <- raster("S_GLC.tif")
# look at the raster attributes.
DEM
plot(DEM)

# NetCDF
DEM <- raster("/Users/pauline/ct_grav.nc")
# look at the raster attributes.
DEM
plot(DEM)

# NetCDF
DEM <- raster("ct_grav.nc")
# look at the raster attributes.
DEM
plot(DEM, main="Polina's RasterLayer")

# GRD
DEM <- raster("ETOPO1_Ice_g_gmt4.grd")
# look at the raster attributes.
DEM
plot(DEM)

############################ -- COLOUR BREAK POINTS: START -- ############
# Function to calculate colour break points
# x = raster, b1 & b2 = number of divisions for each sequence, r1 & r2 = rounding value

blue.col <- colorRampPalette(c("darkblue", "lightblue"))
colbr <- function(x, b1=50, b2=50, r1=-2, r2=-2) {
     # Min/max values of the raster (x)
 mi <- cellStats(x, stat="min")-100
 ma <- cellStats(x, stat="max")+100
 # Create sequences, but only use unique numbers
 s1 <- unique(round(seq(mi, 0, 0-mi/b1),r1))
 s2 <- unique(round(seq(0, ma, ma/b2),r2))
     # Combine sequence for our break points, removing duplicate 0
 s3 <- c(s1, s2[-1])
 # Create a list with the outputs
     # [[1]] = length of the first sequence minus 1 (water)
     # [[2]] = length of the second sequence minus 1 (land)
     # [[3]] = The break points
 x <- list(length(s1)-1, length(s2)-1, s3)
}
############################ -- COLOUR BREAK POINTS: FINISH -- ############

############################# -- CROP and COLOR-- ######################
library(raster)
library(ncdf4)
library(RColorBrewer)
library(rasterVis)
# crop returns a geographic subset of an object as specified by an Extent object (or object from which an extent object can be extracted/created).
DEM <- raster("ETOPO1_Ice_g_gmt4.grd")
DEM <- raster("GEBCO_2019.nc")
# WESN
# Red Sea
e <- extent(30, 50, 10, 30)
RedSea <- crop(DEM, e)
# just 3 colors
# plot(RedSea, col=terrain.colors(3), alpha=NULL)
# 256 colors
plot(RedSea, col=terrain.colors(256), alpha=NULL)
# color ramp
plot(RedSea, col=colorRampPalette(c("red", "white", "blue"))(255))
# viridis
plot(RedSea, col=heat.colors(256), alpha=NULL)
RedSea <- crop(DEM, e)
pr.br <- colbr(RedSea)
plot(RedSea, col=c(blue.col(pr.br[[1]]), terrain.colors(pr.br[[2]])), breaks=pr.br[[3]],
    gridded=TRUE, main="Red Sea region. \nTopographic map: GEBCO 2019",
    sub="Plotting: R",)
contour(RedSea, add=TRUE)
############################# -- CROP and COLOR-- ######################



############################ -- 3. CONTOURS -- ############
#Contour plot of a RasterLayer.
plot(RedSea, col=heat.colors(256), alpha=NULL)
contour(RedSea, add=TRUE)

# England
e <- extent(-11, 5, 49, 60)
Eng <- crop(DEM, e)
plot(Eng)

############################ --
# https://www.benjaminbell.co.uk/2019/08/bathymetric-maps-in-r-colour-palettes.html
# Load packages
library(raster)
# Import data ### See part 1 of this guide ###
etopo.i <- raster("ETOPO1_Bed_g_geotiff.tif")
# Calculate min and max values. Here we use the cellStats() function from the raster package to calculate the stat we want (min and max). Due to rounding issues, we'll decrease the minimum value by -100, and increase the max value by 100 (the reason for this will become evident in subsequent sections).
#  When dealing with large raster files, calculating the min and max values can take a long time (this is particularly evident with the GEBCO_2019 data).

You can see the results in the R console:
mi <- cellStats(etopo.i, stat="min")-100
ma <- cellStats(etopo.i, stat="max")+100
mi
#[1] -10998
ma
#[1] 8371

# We'll create two sequences of evenly spaced break points. The first from our minimum elevation to 0 (mean sea level), and the second from 0 to our max elevation. These will represent water and land.
# Break points sequence for below sea level
s1 <- seq(from=mi, to=0, by=0 - mi / 50)
# Break points sequence for above sea level
s2 <- seq(from=0, to=ma, by=ma / 50)
# In order to create evenly spaced break points, we take the minimum value (which is -10998), and divide this by 50. We do the same for the maximum value (8371). The number you divide these by can be anything you like, depending on how many break points you want. Let's take a look at the first sequence in R:
s1
s2
#Now this looks pretty messy. We'll use the round() function to tidy it up.
# For first sequence, we need to round down to the nearest 100, and for the second sequence, we need to round up to the nearest 100. However, the round function will always round to the nearest 100, which may be up or down. This could create problems with our colour scale (depending on the data), so an easy work around is to decrease and increase the min (mi) and max (ma) values respectively, of the raster data, which we have already done (in the earlier code).
# Round sequence to nearest 100
s1 <- round(s1, -2)
s2 <- round(s2, -2)

# We'll also use the unique() function to remove any duplicate numbers from our two sequences (if any), as break points can not contain the same number twice.
# Only show unique numbers
s1 <- unique(s1)
s2 <- unique(s2)
s1
s2
# Now we have 2 unique sequences which we will combine to create our break points. But, since both sequences contain "0", we'll remove one of these when we combine:

# Combine sequences and remove the first value from second sequence
s3 <- c(s1, s2[-1])

# Before we use these break points, we should confirm the number of break points we actually have. Since we divided the min and max values by 50, we should have at least 50 break points. However, this is not always the case, as the number of break points created depends on the min and max values, the rounding, and the unique numbers (more on this in the next section).

length(s1)
length(s2)
length(s3)
# Our two sequences have 51 break points, but the combined sequence has 101 break points (since we removed a 0 value from the second sequence when combining).

plot(etopo.i)
plot(etopo.i, col=topo.colors(100))

blue.col <- colorRampPalette(c("darkblue", "lightblue"))


############################ -- PORTUGAL CROP -- ############

# Load packages
library(raster)
library(ncdf4)
# Import data ### See part 1 of this guide ###
gebco <- raster("GEBCO_2019.nc")
# Create extent (our map area)
pr.e <- extent(-18, -6, 34, 44)
# Create a crop of the bathymetric data
pr.gebco <- crop(gebco, pr.e)

pr.br <- colbr(pr.gebco)


cellStats(pr.gebco, stat="min")-100
cellStats(pr.gebco, stat="max")+100

############################ add country shapefiles to make it look better ######
# Portugal
pr <- getData("GADM", country="PRT", level=0)
# Spain
esp <- getData("GADM", country="ESP", level=0)
# Colour palette
blue.col <- colorRampPalette(c("darkblue", "lightblue"))
# Plot GEBCO_2019 coast of Portugal
plot(pr.gebco, col=c(blue.col(pr.br[[1]]), terrain.colors(pr.br[[2]])), breaks=pr.br[[3]])
plot(pr, add=TRUE)
plot(esp, add=TRUE)
contour(pr.gebco, add=TRUE)


############################ -- 6. VECTOR LAYER -- ############
# list.files(system.file("gpkg/", package = "cartography"))
# list.files(system.file("external/", package = "raster"))
# Example: Luxemburg
p <- shapefile(system.file("external/lux.shp", package="raster"))
plot(p)

n <- length(p)
plot(p, col=rainbow(n))

#One colour per region (NAME_1)
u <- unique(p$NAME_1)
u
## [1] "Diekirch"     "Grevenmacher" "Luxembourg"
m <- match(p$NAME_1, u)
plot(p, col=rainbow(n)[m])
text(p, 'NAME_2', cex=.75, halo=TRUE)

# levelplot
spplot(p, 'AREA')
plot(p, col=rainbow(n)[m])



