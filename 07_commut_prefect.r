library(sf)
library(cartography)
# path to the geopackage file embedded in cartography
path_to_gpkg <- system.file("gpkg/mtq.gpkg", package="cartography")
# import to an sf object
mtq <- st_read(dsn = path_to_gpkg, quiet = TRUE)
# path to the csv file embedded in cartography
path_to_csv <- system.file("csv/mob.csv", package="cartography")
# import to a data.frame
mob <- read.csv(path_to_csv)
# select workplaces with administrative status = Prefecture or Sub-prefecture
mob <- mob[mob$sj != "Simple municipality",]
# create an sf object of links
mtq_mob <- getLinkLayer(
  x = mtq,
  xid = "INSEE_COM",
  df = mob,
  dfid = c("i","j")
)

# set figure background color
par(bg="grey25")
# plot municipalities
plot(st_geometry(mtq), col = "grey13", border = "grey25",
     bg = "grey25", lwd = 0.5)
# plot graduated links
gradLinkTypoLayer(
  x = mtq_mob,
  xid = c("i", "j"),
  df = mob,
  dfid = c("i","j"),
  var = "fij",
  breaks = c( 100,  500, 1200, 2500, 4679.0),
  lwd = c(1,4,8,16),
  legend.var.pos = "left",
  legend.var.title.txt = "Nb. of\nCommuters",
  var2 = "sj",
  col = c("grey85", "red4"),
  legend.var2.title.txt = "Workplace",
  legend.var2.pos = "topright"
)
# map layout
layoutLayer(title = "Commuting to Prefectures in Martinique",
            sources = "Sources: Insee and IGN, 2018",
            author = paste0("cartography ", packageVersion("cartography")),
            frame = FALSE, col = "grey25", coltitle = "white",
            tabtitle = TRUE)

#---------------- UPDATE --------------->

# set figure background color
par(bg="gainsboro")

# plot municipalities
plot(st_geometry(mtq), col = "lightgoldenrod1", border = "grey25",
     bg = "ivory2", lwd = 0.5)

# plot graduated links
gradLinkTypoLayer(
  x = mtq_mob,
  xid = c("i", "j"),
  df = mob,
  dfid = c("i","j"),
  var = "fij",
  breaks = c(100, 200, 500, 700,900,1200,1500, 2500, 3000, 4679.0),
  lwd = c(1,2,4,6,8,10,12,14,16),
#  col = pals::tol.rainbow(34),
  col = c("darkviolet", "deeppink"),
  legend.var.pos = "left",
  legend.var.title.txt = "Nb. of\nCommuters",
  var2 = "sj",
  legend.var2.title.txt = "Workplace",
  legend.var2.pos = "topright"
)
labelLayer(
  x = mtq,
  txt = "LIBGEO",
  col= "black",
  cex = 0.7,
  font = 1,
  halo = F,
  bg = "white",
  r = 0.1,
  overlap = FALSE,
  show.lines = FALSE
)
# map layout
layoutLayer(title = "Commuting to Prefectures of Martinique",
            sources = "Sources: Insee and IGN, 2025",
            author = paste0("cartography ", packageVersion("cartography")),
            frame = T, col = "grey25", coltitle = "white",
            tabtitle = TRUE)
