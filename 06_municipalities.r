library(sf)
library(cartography)
# path to the geopackage file embedded in cartography
path_to_gpkg <- system.file("gpkg/mtq.gpkg", package="cartography")
# import to an sf object
mtq <- st_read(dsn = path_to_gpkg, quiet = TRUE)

nrow(mtq)

# plot municipalities
plot(st_geometry(mtq), col = pals::jet(34),
    border = "goldenrod4",
    bg = "snow", lwd = 0.5)
# plot labels
labelLayer(
  x = mtq,
  txt = "LIBGEO",
  col= "black",
  cex = 0.8,
  font = 1,
  halo = TRUE,
  bg = "white",
  r = 0.1,
  overlap = FALSE,
  show.lines = FALSE
)
# map layout
layoutLayer(
  title = "Municipalities of Martinique",
  sources = "Sources: Insee and IGN, 2025",
  author = paste0("cartography ", packageVersion("cartography")),
  frame = T,
  north = TRUE,
  tabtitle = TRUE,
  theme = "taupe.pal"
)
