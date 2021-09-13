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
R nos permite leer los datos geoespaciales y tratarlos como un data frame, lo cual es conveniente para poder hacer mapas usando la libraría ggplot2 y agregar distintas capas como rellenos, leyendas, títulos, etc. El mapa más básico que podemos hacer es el que contiene solo las líneas fronterizas. Evidentemente, lo que buscamos es mostrar variables de una base de datos en el mapa. Los objetivos de esta guía son los siguientes:
* Elaborar un mapa base del Perú con límites departamentales.
* Mostrar la tasa de pobreza departamental y el promedio departamental de años de educación alcanzados en un mapa.
* Elaborar un mapa para cada variable de manera separada y también de manera conjunta, para ver la relación entre la pobreza y los años de educación en el mapa.

A continuación, se mostraran los pasos necesarios para alcanzar estos objetivos.

### Definir nuestro directorio de trabajo
En primer lugar, debemos declarar la estructura de nuestro directorio de trabajo. Esto nos permitirá tener un trabajo mucho más ordenado. La estructura que muestro es la misma que tiene este repositorio de Github.


```
username <- Sys.getenv("USERNAME")

wd            <- list()
wd$root       <- paste0("C:/Users/", username, "/Documents/GitHub/rmaps-peruvian-case/")
wd$inputs     <- paste0(wd$root, "01_inputs/")
wd$shapef     <- paste0(wd$inputs, "shapefiles/")
wd$datasets   <- paste0(wd$inputs, "datasets/")
wd$outputs    <- paste0(wd$root, "02_outputs/")
```

Los archivos con información georreferencial se guardaron en la subcarpeta "shapefiles" dentro de la carpeta "01_inputs". En la carpeta "02_outputs" guardaremos todos los gráficos que elaboremos.

### Importar los archivos shapefiles
Luego, debemos importar el archivo *shapefile*.

```
peru_sf <- st_read(paste0(wd$shapef, "INEI_LIMITE_DEPARTAMENTAL.shp"))
```

### Mapas base

El mapa más simple que podemos hacer es el Perú con sus límites departamentales.
```
# Mapa base: PERU
ggplot(data = peru_sf) +
  geom_sf()
```
![basemap_pe](https://user-images.githubusercontent.com/57784008/133008127-3fe4f6af-0c8d-4f5c-8247-c4fa9b348b11.png)

También podemos hacer mapas de un departamento en específico si filtramos. En este caso, yo graficaré el mapa de Junín (ya que la sangre wanka corre por mis venas).
```
ggplot(data = peru_sf %>%
         filter(NOMBDEP=="JUNIN")) +
  geom_sf()
```
![basemap_pejun](https://user-images.githubusercontent.com/57784008/133008181-db7c0e6f-798a-4634-a197-895d6f892187.png)






