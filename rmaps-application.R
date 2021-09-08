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
peru_d <- st_read("DEPARTAMENTOS.shp")