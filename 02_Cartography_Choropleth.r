library(sf)
library(cartography)
# path to the geopackage file embedded in cartography
path_to_gpkg <- system.file("gpkg/mtq.gpkg", package="cartography")
# import to an sf object
mtq <- st_read(dsn = path_to_gpkg, quiet = TRUE)
# population density (inhab./km2) using sf::st_area()
mtq$POPDENS <- 1e6 * mtq$POP / st_area(mtq)
# plot municipalities (only the backgroung color is plotted)
plot(st_geometry(mtq), col = NA, border = NA, bg = "#aadaff")
# plot population density
choroLayer(
  x = mtq,
  var = "POPDENS",
  method = "geom",
  nclass=5,
  col = carto.pal(pal1 = "sand.pal", n1 = 5),
  border = "white",
  lwd = 0.5,
  legend.pos = "topright",
  legend.title.txt = "Population Density\n(people per km2)",
  add = TRUE
)
# layout
layoutLayer(title = "Population Distribution in Martinique",
            sources = "Sources: Insee and IGN, 2018",
            author = paste0("cartography ", packageVersion("cartography")),
            frame = FALSE, north = FALSE, tabtitle = TRUE, theme= "sand.pal")
# north arrow
north(pos = "topleft")
