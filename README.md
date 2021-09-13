# Mapas en R: una aplicación con datos peruanos
## Introducción
Una de las ventajas de R es que también nos permite trabajar con datos geoespaciales, los cuales son conocidos como shapefiles. Existen una diversidad de páginas para conseguir shapefiles. Personalmente, opto por usar la página [GEO GPS PERU](https://www.geogpsperu.com/) para conseguir datos geoespaciales del territorio peruano. Esta página contiene datos geoespaciales por límite departamental, provincial y distrital. Para este ejemplo, se descargó el *shapefile* por límite departamental. Se descarga un archivo comprimido que contiene distintas extensiones tal como se muestra en la siguiente figura. Guardamos todo esto en nuestra dirección de trabajo.

## Paquetes necesarios
Los paquetes requeridos para poder hacer mapas en R son, básicamente, los que se presentan a continuación.
```
library(sf)
library(purrr)
library(tidyverse)
library(ggplot2)
library(ggrepel)
```
## Creación de mapas
R nos permite leer los datos geoespaciales y tratarlos como un data frame, lo cual es conveniente para poder hacer mapas y agregar distintas capas como rellenos, leyendas, títulos, etc. El mapa más básico que podemos hacer es el que contiene solo las líneas fronterizas. Luego, podriamos agregar otras variables de interés que podrían ser presentadas usando un mapa. El objetivo de esta guía es elaborar un mapa que muestre el porcentaje de personas en condición de pobreza por departamentos.

```
dirmapas <- "C:/file/directory"
setwd(dirmapas)
peru_d <- st_read("DEPARTAMENTOS.shp")
```
