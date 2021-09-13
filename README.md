# Mapas en R: una aplicaci�n con datos peruanos
## Introducci�n
Una de las ventajas de R es que tambi�n nos permite trabajar con datos geoespaciales, los cuales son conocidos como shapefiles. Existen una diversidad de p�ginas para conseguir shapefiles. Personalmente, opto por usar la p�gina [GEO GPS PERU](https://www.geogpsperu.com/) para conseguir datos geoespaciales del territorio peruano. Esta p�gina contiene datos geoespaciales por l�mite departamental, provincial y distrital. Para este ejemplo, se descarg� el *shapefile* por l�mite departamental. Se descarga un archivo comprimido que contiene distintas extensiones tal como se muestra en la siguiente figura. Guardamos todo esto en nuestra direcci�n de trabajo.

## Paquetes necesarios
Los paquetes requeridos para poder hacer mapas en R son, b�sicamente, los que se presentan a continuaci�n.
```
library(sf)
library(purrr)
library(tidyverse)
library(ggplot2)
library(ggrepel)
```
## Creaci�n de mapas
R nos permite leer los datos geoespaciales y tratarlos como un data frame, lo cual es conveniente para poder hacer mapas y agregar distintas capas como rellenos, leyendas, t�tulos, etc. El mapa m�s b�sico que podemos hacer es el que contiene solo las l�neas fronterizas. Luego, podriamos agregar otras variables de inter�s que podr�an ser presentadas usando un mapa. El objetivo de esta gu�a es elaborar un mapa que muestre el porcentaje de personas en condici�n de pobreza por departamentos.

```
dirmapas <- "C:/file/directory"
setwd(dirmapas)
peru_d <- st_read("DEPARTAMENTOS.shp")
```
