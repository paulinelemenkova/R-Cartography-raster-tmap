library(sp)
library(cartography)
data("nuts2006")
# Plot a layer with the extent of the EU28 countries with only a background color
plot(nuts0.spdf, border = NA, col = NA, bg = "#A6CAE0")
# Plot non european space
plot(world.spdf, col  = "#E3DEBF", border = NA, add = TRUE)
# Plot Nuts2 regions
plot(nuts0.spdf, col = "grey60",border = "white", lwd = 0.4, add = TRUE)
# plot the countries population
propSymbolsLayer(
  spdf = nuts0.spdf,
  df = nuts0.df,
  spdfid = "id",
  dfid = "id",
  var = "pop2008",
  legend.pos = "topright",
  col = "red4",
  border = "white",
  legend.title.txt = "Population"
)
# layout
layoutLayer(title = "Population in Europe, 2008",
            sources = "Data: Eurostat, 2008",
            author =  paste0("cartography ", packageVersion("cartography")),
            scale = 500, frame = TRUE, col = "#688994")
# north arrow
north("topleft")
