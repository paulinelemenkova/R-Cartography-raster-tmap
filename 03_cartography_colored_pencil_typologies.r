library(sf)
library(cartography)
# path to the geopackage file embedded in cartography
path_to_gpkg <- system.file("gpkg/mtq.gpkg", package="cartography")
# import to an sf object
mtq <- st_read(dsn = path_to_gpkg, quiet = TRUE)
# transform municipality multipolygons to (multi)linestrings
mtq_pencil <- getPencilLayer(
  x = mtq,
  size = 400,
  lefthanded = F
)
# plot municipalities (only the backgroung color is plotted)
plot(st_geometry(mtq), col = "white", border = NA, bg = "lightblue1")
# plot administrative status
typoLayer(
  x = mtq_pencil,
  var="STATUS",
  col = c("aquamarine4", "yellow3","wheat"),
  lwd = .7,
  legend.values.order = c("Prefecture",
                          "Sub-prefecture",
                          "Simple municipality"),
  legend.pos = "topright",
  legend.title.txt = "",
  add = TRUE
)
#  plot municipalities
plot(st_geometry(mtq), lwd = 0.5, border = "grey20", add = TRUE, lty = 3)
# labels for a few  municipalities
labelLayer(x = mtq[mtq$STATUS != "Simple municipality",], txt = "LIBGEO",
           cex = 0.9, halo = TRUE, r = 0.15)
# title, source, author
layoutLayer(title = "Administrative Status",
            sources = "Sources: Insee and IGN, 2018",
            author = paste0("cartography ", packageVersion("cartography")),
            north = FALSE, tabtitle = TRUE, postitle = "right",
            col = "white", coltitle = "black")
# north arrow
north(pos = "topleft")
