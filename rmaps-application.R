################################################################################
# MAPS IN R: An application with Peruvian cases
# Author: Ronny M. Condor
# Objective: Generate maps in R using georeferenced data and secondary sources
#            of information, such as INEI data
# Comments: The databases used were generated from ENAHO
################################################################################

library(sf)
library(purrr)
library(tidyverse)
library(ggplot2)
library(ggrepel)

# Data folder
username <- Sys.getenv("USERNAME")

wd            <- list()
wd$root       <- paste0("C:/Users/", username, "/Documents/GitHub/rmaps-peruvian-case/")
wd$inputs     <- paste0(wd$root, "01_inputs/")
wd$shapef     <- paste0(wd$inputs, "shapefiles/")
wd$datasets   <- paste0(wd$inputs, "datasets/")
wd$outputs    <- paste0(wd$root, "02_outputs/")

# Import the shapefile
peru_sf <- st_read(paste0(wd$shapef, "INEI_LIMITE_DEPARTAMENTAL.shp"))

# Base map: PERU
ggplot(data = peru_sf) +
  geom_sf()
ggsave(paste0(wd$outputs, "basemap_pe.png"))


# Base map: JUNIN
ggplot(data = peru_sf %>%
         filter(NOMBDEP=="JUNIN")) +
  geom_sf()
ggsave(paste0(wd$outputs, "basemap_pejun.png"))

# CENTROIDS: Place the name of each department on the map
## Create the centroid
peru_sf <- peru_sf %>% mutate(centroid = map(geometry, st_centroid),
                              coords = map(centroid, st_coordinates),
                              coords_x = map_dbl(coords, 1), coords_y = map_dbl(coords, 2))

## Map with labels
ggplot(data = peru_sf) +
  geom_sf(fill="skyblue3", color="black", alpha = 0.7)+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2)
ggsave(paste0(wd$outputs, "map_centroid.png"))

# DATASETS
## Poverty rate (2016)
povrate2016 <- read_csv(paste0(wd$datasets,"povrate2016.csv"))

## Average years of education (2016)
educ2016 <- read_csv(paste0(wd$datasets,"educ2016.csv"))

# MERGE databases with shapefile
peru_datos <- peru_sf %>%
  left_join(povrate2016) %>%
  left_join(educ2016)

# FINAL GRAPHS

## Graph 1: Poverty rate (2016) without labels
ggplot(peru_datos) +
  geom_sf(aes(fill = poor))+
  labs(title = "Percentage of poor population\nby department (2016)",
       caption = "Source: Enaho (2016)\nSelf-made",
       x="Longitude",
       y="Latitude",
       fill = "Poverty Rate")+
  scale_fill_gradient(low = "steelblue1", high = "steelblue4")+
  theme_bw()
ggsave(paste0(wd$outputs, "poormap1.png"))

## Graph 2: Poverty rate (2016) with labels
ggplot(peru_datos) +
  geom_sf(aes(fill = poor))+
  labs(title = "Percentage of poor population\nby department (2016)",
       caption = "Source: Enaho (2016)\nSelf-made",
       x="Longitude",
       y="Latitude",
       fill = "Poverty Rate")+
  scale_fill_gradient(low = "steelblue1", high = "steelblue4")+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2)+
  theme_bw()
ggsave(paste0(wd$outputs, "poormap2.png"))

## Graph 3: Average years of education (2016) without labels
ggplot(peru_datos) +
  geom_sf(aes(fill = educ))+
  labs(title = "Average years of education\nby department (2016)",
       caption = "Source: Enaho (2016)\nSelf-made",
       x="Longitude",
       y="Latitude",
       fill = "Years of Education")+
  scale_fill_gradient(low = "darkseagreen1", high = "darkseagreen4")+
  theme_bw()
ggsave(paste0(wd$outputs, "educmap1.png"))

## Graph 4: Average years of education (2016) with labels
ggplot(peru_datos) +
  geom_sf(aes(fill = educ))+
  labs(title = "Average years of education\nby department (2016)",
       caption = "Source: Enaho (2016)\nSelf-made",
       x="Longitude",
       y="Latitude",
       fill = "Years of Education")+
  scale_fill_gradient(low = "darkseagreen1", high = "darkseagreen4")+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2)+
  theme_bw()
ggsave(paste0(wd$outputs, "educmap2.png"))

# Graph 5: Poverty and years of education (2016)
ggplot(peru_datos) +
  geom_sf(aes(fill = poor))+
  scale_fill_gradient(low = "steelblue1", high = "steelblue4")+
  geom_point(aes(coords_x, coords_y, size = educ), color = "darkseagreen3")+
  labs(title = "Poverty and years of education (2016)",
       caption = "Source: Enaho (2016)\nSelf-made",
       x="Longitude",
       y="Latitude",
       fill = "Poverty Rate",
       size = "Years of Education")+
  theme_bw()
ggsave(paste0(wd$outputs, "povertyeduc.png"))
