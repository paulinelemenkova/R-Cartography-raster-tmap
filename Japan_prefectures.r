library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

#Plotting maps-package maps with ggplot https://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html
# The maps package contains a lot of outlines of continents, countries, states, and counties that have been with R for a long time.
# The mapdata package contains a few more, higher-resolution outlines.

#china <- map_data("china")
japan <- map_data("japan")

dim(japan)

head(japan) # region
tail(japan)

japan <- map_data("japan")
ggplot() + geom_polygon(data = japan, aes(x=long, y = lat, group = group)) +
    coord_fixed(1.3)

############################### -- regions -- ##################

gg1 <- ggplot() +
    geom_polygon(data = japan, aes(x = long, y = lat, fill = region, group = group),
        color = "blue", linetype = 1, size = 0.2) +
    coord_fixed(1.3) +
    xlab("Longitude") +
    ylab("Latitude") +
    labs(title="Japan",
        subtitle = "Mapping: R",
        caption = "Packages: ggmap, ggplot2, mapdata, maps")# +
 #   guides(col = guide_legend(ncol = 2, byrow = TRUE))# do this to leave off the color legend
gg1

############################### -- transparent -- ##################

ggplot() +
geom_polygon(data = japan, aes(x=long, y = lat, group = group), fill = NA, color = "red") +
coord_fixed(1.3)

################################# -- color -- #################

gg2 <- ggplot() +
    geom_polygon(data = japan, aes(x=long, y = lat, group = group),
        fill = "pink", color = "blue", linetype = 1, size = 0.2) +
    coord_fixed(1.3) +
    xlab("Longitude") +
    ylab("Latitude") +
    labs(title="Japan",
        subtitle = "Mapping: R",
        caption = "Packages: ggmap, ggplot2, mapdata, maps")
gg2

################################################################
