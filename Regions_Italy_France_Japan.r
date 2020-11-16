library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

#Plotting maps-package maps with ggplot https://eriqande.github.io/rep-res-web/lectures/making-maps-with-R.html
# The maps package contains a lot of outlines of continents, countries, states, and counties that have been with R for a long time.
# The mapdata package contains a few more, higher-resolution outlines.

#china <- map_data("china")
japan <- map_data("japan")
italy <- map_data("italy")
france <- map_data("france")

dim(japan)

head(japan) # region
tail(japan)

head(france)

japan <- map_data("japan")
ggplot() + geom_polygon(data = japan, aes(x=long, y = lat, group = group)) +
    coord_fixed(1.3)

############################### -- regions Japan -- ##################

gg1 <- ggplot() +
    geom_polygon(data = japan, aes(x = long, y = lat, fill = region, group = group),
        color = "blue", linetype = 1, size = 0.2) +
    coord_fixed(1.3) +
    xlab("Longitude") +
    ylab("Latitude") +
    labs(title="Japan",
        subtitle = "Mapping: R",
        caption = "Packages: ggmap, ggplot2, mapdata, maps")
gg1

############################### -- regions France -- ##################

gg1 <- ggplot() +
    geom_polygon(data = france, aes(x = long, y = lat, fill = region, group = group),
        color = "blue", linetype = 1, size = 0.2) +
    coord_fixed(1.3) +
    xlab("Longitude") +
    ylab("Latitude") +
    labs(title="France",
        subtitle = "Mapping: R",
        caption = "Packages: ggmap, ggplot2, mapdata, maps") +
    guides(fill = guide_legend(reverse=TRUE))
    #guides(fill=TRUE)
gg1

############################### -- regions Italy -- ##################

gg1 <- ggplot() +
    geom_polygon(data = italy, aes(x = long, y = lat, fill = region, group = group),
        color = "blue", linetype = 1, size = 0.2) +
    coord_fixed(1.3) +
    xlab("Longitude") +
    ylab("Latitude") +
    labs(title="Italy",
        subtitle = "Mapping: R",
        caption = "Packages: ggmap, ggplot2, mapdata, maps") +
    guides(fill = guide_legend(reverse=TRUE))
 #   guides(col = guide_legend(ncol = 2, byrow = TRUE))# do this to leave off the color legend
gg1

map('italy', fill = TRUE, col = 1:95)
map('italy', fill = TRUE, col = 1:10)

############################### -- transparent -- ##################

ggplot() +
geom_polygon(data = japan, aes(x=long, y = lat, group = group), fill = NA, color = "red") +
coord_fixed(1.3)

ggplot() +
geom_polygon(data = france, aes(x=long, y = lat, group = group), fill = NA, color = "red") +
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
