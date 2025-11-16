library(sf)
library(cartography)
# path to the geopackage file embedded in cartography
path_to_gpkg <- system.file("gpkg/mtq.gpkg", package="cartography")
# list.files(system.file("gpkg/", package = "cartography"))
# list.files(system.file("gpkg/", package = "sf"))
# import to an sf object
mtq <- st_read(dsn = path_to_gpkg, quiet = TRUE)

# devtools::install_github("riatelab/maptiles")
library(maptiles)

# dowload osm tiles and compose raster (SpatRaster)
mtq.osm <- maptiles::get_tiles(
    x = mtq,
    zoom = 11, crop = T, cachedir = tempdir(),
    verbose = T, retina = T
)

# display map
plot_tiles(mtq.osm)

# plot municipalities (only borders are plotted)
plot(st_geometry(mtq), col = NA, border = "red", add=TRUE)

# plot population
propSymbolsLayer(
  x = mtq,
  var = "POP",
  inches = 0.15,
  col = pals::ocean.ice(5),
  legend.pos = "bottom",
  legend.title.txt = "Total population"
)
# layout
layoutLayer(title = "Population Distribution in Martinique",
            sources = "Sources: Insee and IGN, 2025\n© OpenStreetMap contributors.\nTiles style under CC BY-SA, www.openstreetmap.org/copyright.", scale = "auto",
            author = paste0("cartography ", packageVersion("cartography")),
            frame = T, north = T, tabtitle = TRUE)
# north arrow
north(pos = "topleft")
