setwd("/Users/pauline/")

############################ -- LOAD PACKAGES -- ############
library(showtext)
library(ggplot2)
library(ggmap)
library(maps)
library(mapdata)

############################ -- GET & INSPECT DATA -- ############
japan <- map_data("japan")
# Compactly display the internal structure of an R object
str(japan)
# indicate column with regions as factor value (variable)
japan$region =as.factor(japan$region)
str(japan)
dim(japan)
head(japan)
tail(japan)

############################# -- CHECK UP AVAILABLE FONTS -- ######################
library(showtext)
font_families()
font_paths()
font_files()

############################### -- regions Japan, expanding color palettes(1) -- ##################
# inspect number of variable (prefectures of Japan)
length(unique(japan$region))
# 47
#expanding color palettes(1)
colourCount = length(unique(japan$region))
colorRampPalette(brewer.pal(name="Spectral", n = 8))(47)
getPalette = colorRampPalette(brewer.pal(9, "Spectral"))

# plotting map
gg1 <- ggplot() +
    geom_polygon(data = japan, aes(x = long, y=lat, fill = region, group = group),
        color = "blue", linetype = 1, size = 0.2 ) +
    coord_fixed(1.3) +
    xlab("Longitude") +
    ylab("Latitude") +
    scale_fill_manual(values = getPalette(colourCount)) +
    labs(title="Japan",
        subtitle = "Mapping: R",
        caption = "Packages: ggmap, ggplot2, mapdata, maps") +
    theme(legend.title = element_text(colour="blue", size=16, face="bold"),
        plot.title = element_text(family = "Chalkboard", colour="blue", size=16, face="bold"),
        plot.subtitle = element_text(family = "Chalkboard", colour="blue", face = "plain", size = 14),
        plot.caption = element_text(face = "italic", size = 10),
        legend.box = "vertical",
        legend.box.background = element_rect(colour = "honeydew4",size=0.2),
        legend.background = element_rect(fill = "white"),
        panel.grid.major = element_line("white", size = 0.3, linetype = "solid"),
        panel.grid.minor = element_line("white", size = 0.2, linetype = "dotted"),
        axis.text.x = element_text(family = "Arial", face = 3, color = "gray24",size = 10, angle = 15),
        axis.text.y = element_text(family = "Arial", face = 3, color = "gray24",size = 10, angle = 90),
        ) +
    scale_x_continuous(breaks = c(seq(120, 150, by = 5))) +
    guides(fill = guide_legend(ncol = 2,
        title = "Prefectures", title.position = "top"))
gg1











############################### -- regions Japan, expanding color palettes (2nd variant) -- ##################
length(unique(japan$region))
# 47
nb.cols <- 47
mycolors <- colorRampPalette(brewer.pal(8, "Set1"))(nb.cols)
# Create a ggplot with 47 colors
# Use scale_fill_manual
gg1 <- ggplot() +
    geom_polygon(data = japan, aes(x = long, y=lat, fill = region, group=group),
        color = "blue", linetype = 1, size = 0.2 ) +
    coord_fixed(1.3) +
    xlab("Longitude") +
    ylab("Latitude") +
    scale_fill_manual(values = mycolors) +
    labs(title="Japan",
        subtitle = "Mapping: R",
        caption = "Packages: ggmap, ggplot2, mapdata, maps") +
    theme(legend.title = element_text(colour="blue", size=16, face="bold"),
            plot.title = element_text(family="AquaKana", face="bold", colour="blue", size=16)) +
    guides(fill = guide_legend(ncol = 2,
            title = "Prefectures", title.position = "top"))
gg1


# Other filling
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
