################################################################################
# MAPAS EN R  : Una aplicación con casos peruanos
# Autor       : Ronny M. Condor (ronny.condor@unmsm.edu.pe)
# Objetivo    : Generar mapas en R usando datos georreferenciados y fuentes
#               secundarias de información, como la del INEI
# Comentarios : Las bases de datos usados fueron generadas a partir de la ENAHO
################################################################################

library(sf)
library(purrr)
library(tidyverse)
library(ggplot2)
library(ggrepel)

# Carpeta de datos
username <- Sys.getenv("USERNAME")

wd            <- list()
wd$root       <- paste0("C:/Users/", username, "/Documents/GitHub/rmaps-peruvian-case/")
wd$inputs     <- paste0(wd$root, "01_inputs/")
wd$shapef     <- paste0(wd$inputs, "shapefiles/")
wd$datasets   <- paste0(wd$inputs, "datasets/")
wd$outputs    <- paste0(wd$root, "02_outputs/")

# Importamos el archivo shapefile
peru_sf <- st_read(paste0(wd$shapef, "INEI_LIMITE_DEPARTAMENTAL.shp"))

# Mapa base: PERU
ggplot(data = peru_sf) +
  geom_sf()
ggsave(paste0(wd$outputs, "basemap_pe.png"))


# Mapa base: JUNIN
ggplot(data = peru_d %>%
         filter(NOMBDEP=="JUNIN")) +
  geom_sf()
ggsave(paste0(wd$outputs, "basemap_pejun.png"))

# CENTROIDES: Colocar el nombre de cada departamento en el mapa
## Creamos el cenrtroide
peru_sf <- peru_sf %>% mutate(centroid = map(geometry, st_centroid), 
                              coords = map(centroid, st_coordinates), 
                              coords_x = map_dbl(coords, 1), coords_y = map_dbl(coords, 2))

## Mapa con etiquetas
ggplot(data = peru_sf) +
  geom_sf(fill="skyblue3", color="black", alpha = 0.7)+ 
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2)
ggsave(paste0(wd$outputs, "map_centroid.png"))

# DATASETS
## Tasa de pobreza (2016)
povrate2016 <- read_csv(paste0(wd$datasets,"povrate2016.csv"))

## Tasa de autoempleo (2016)
selfrate2016 <- read_csv(paste0(wd$datasets,"selfrate2016.csv"))

# JUNTAR bases de datos con shapefile
peru_datos <- peru_sf %>%
              left_join(povrate2016) %>%
              left_join(selfrate2016)

# GRÁFICOS finales

## Gráfico 1: Tasa de pobreza (2016) sin etiquetas
ggplot(peru_datos) +
  geom_sf(aes(fill = poor))+
  labs(title = "Porcentaje de población pobre\npor departamento (2016)",
       caption = "Fuente: Enaho (2016)
       Elaboración propia",
       x="Longitud",
       y="Latitud",
       fill = "Tasa de pobreza")+
  scale_fill_gradient(low = "steelblue1", high = "steelblue4")+
  theme_bw()
ggsave(paste0(wd$outputs, "poormap1.png"))

## Gráfico 2: Tasa de pobreza (2016) con etiquetas
ggplot(peru_datos) +
  geom_sf(aes(fill = poor))+
  labs(title = "Porcentaje de población pobre\npor departamento (2016)",
       caption = "Fuente: Enaho (2016)
       Elaboración propia",
       x="Longitud",
       y="Latitud",
       fill = "Tasa de pobreza")+
  scale_fill_gradient(low = "steelblue1", high = "steelblue4")+
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2)+
  theme_bw()
ggsave(paste0(wd$outputs, "poormap2.png"))

## Gráfico 3: Tasa de autoempleo (2016) sin etiquetas
ggplot(peru_datos) +
  geom_sf(aes(fill = self_employed))+
  labs(title = "Porcentaje de población autoempleada\npor departamento (2016)",
       caption = "Fuente: Enaho (2016)
       Elaboración propia",
       x="Longitud",
       y="Latitud",
       fill = "Tasa de autoempleo")+
  scale_fill_gradient(low = "steelblue1", high = "steelblue4")+
  theme_bw()
ggsave(paste0(wd$outputs, "selfemployedmap1.png"))

## Gráfico 4: Tasa de autoempleo (2016) con etiquetas


