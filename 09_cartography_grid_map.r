library(sf)
library(cartography)
# path to the geopackage file embedded in cartography
path_to_gpkg <- system.file("gpkg/mtq.gpkg", package="cartography")
# import to an sf object
mtq <- st_read(dsn = path_to_gpkg, quiet = TRUE)
# Create a grid layer, cell size area match the median municipality area
mygrid <- getGridLayer(
  x = mtq,
  cellsize = median(as.numeric(st_area(mtq))),
  var = "POP",
  type = "hexagonal"
)
# Compute population density in people per km2
mygrid$POPDENS <- 1e6 * mygrid$POP / mygrid$gridarea
# plot municipalities (only the backgroung color is plotted)
plot(st_geometry(mtq), col = NA, border = NA, bg = "#deffff")
# Plot the population density
choroLayer(x = mygrid, var = "POPDENS", method = "geom", nclass=5,
           col = carto.pal(pal1 = "turquoise.pal", n1 = 5), border = "grey80",
           lwd = 0.5, legend.pos = "bottomleftextra", add = TRUE,
           legend.title.txt = "Population Density\n(people per km2)")
layoutLayer(title = "Population Distribution in Martinique",
            sources = "Sources: Insee and IGN, 2018",
            author = paste0("cartography ", packageVersion("cartography")),
            frame = FALSE, north = FALSE, tabtitle = TRUE,
            theme = "turquoise.pal")
# north arrow
north(pos = "topleft")
