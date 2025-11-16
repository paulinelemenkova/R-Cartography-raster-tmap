library(sf)
library(cartography)
# path to the geopackage file embedded in cartography
path_to_gpkg <- system.file("gpkg/mtq.gpkg", package="cartography")
# import to an sf object
mtq <- st_read(dsn = path_to_gpkg, quiet = TRUE)
# Compute the population density (inhab./km2) using sf::st_area()
mtq$POPDENS <- as.numeric(1e6 * mtq$POP / st_area(mtq))
# Get a SpatialLinesDataFrame of countries borders
mtq.contig <- getBorders(mtq)

# plot municipalities (only the backgroung color is plotted)
plot(st_geometry(mtq), col = NA, border = NA, bg = "whitesmoke",
     xlim = c(690574, 745940))
# Plot the population density with custom breaks
choroLayer(x = mtq, var = "MED",
           breaks = c(min(mtq$MED), seq(13000, 21000, 2000), max(mtq$MED)),
           col = carto.pal("green.pal", 6),border = "white", lwd = 0.5,
           legend.pos = "topright", legend.title.txt = "Median Income\n(euros)",
           add = TRUE)
# Plot discontinuities
discLayer(
  x = mtq.contig,
  df = mtq,
  var = "MED",
  type = "rel",
  method = "geom",
  nclass = 3,
  threshold = 0.4,
  sizemin = 0.7,
  sizemax = 6,
  col = "red4",
  legend.values.rnd = 1,
  legend.title.txt = "Relative\nDiscontinuities",
  legend.pos = "right",
  add = TRUE
)
# Layout
layoutLayer(title = "Wealth Disparities in Martinique",
            author =  paste0("cartography ", packageVersion("cartography")),
            sources = "Sources: Insee and IGN, 2025",
            frame = FALSE, scale = 5, tabtitle = TRUE,theme = "grey.pal")
# north arrow
north(pos = "topleft")

#-----------------UPDATE--------------->
# plot municipalities (only the backgroung color is plotted)
plot(st_geometry(mtq), col = NA, border = NA, bg = "ivory",
     xlim = c(690574, 745940))
# Plot the population density with custom breaks
choroLayer(x = mtq, var = "MED",
    breaks = c(min(mtq$MED), seq(13000, 21000, 1000), max(mtq$MED)),
    col = pals::turbo(12), border = "white", lwd = 0.5,
    legend.pos = "topright",
    legend.title.txt = "Median Income\n(euros)", add = T)
# Plot discontinuities
discLayer(
  x = mtq.contig,
  df = mtq,
  var = "MED",
  type = "rel",
  method = "geom",
  nclass = 3,
  threshold = 0.4,
  sizemin = 0.7,
  sizemax = 6,
  col = "red4",
  legend.values.rnd = 1,
  legend.title.txt = "Relative\nDiscontinuities",
  legend.pos = "bottomright",
  add = TRUE
)
# Layout
layoutLayer(title = "Wealth Disparities in Martinique",
            author =  paste0("cartography ", packageVersion("cartography")),
            sources = "Sources: Insee and IGN, 2025",
            frame = FALSE, scale = 5, tabtitle = TRUE,theme = "grey.pal")
# north arrow
north(pos = "topleft")
