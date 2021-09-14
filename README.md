# Mapas en R: una aplicación con datos peruanos
[![DOI](https://zenodo.org/badge/404199765.svg)](https://zenodo.org/badge/latestdoi/404199765)
## Introducción
Una de las ventajas de R es que también nos permite trabajar con datos geoespaciales, los cuales son conocidos como shapefiles. Existen una diversidad de páginas para conseguir shapefiles. Podemos ingresar a la página [GEO GPS PERU](https://www.geogpsperu.com/) para conseguir datos geoespaciales del territorio peruano. Esta página contiene datos geoespaciales por límite departamental, provincial y distrital. Para este ejemplo, se descargó el *shapefile* por límite departamental. Se descarga un archivo comprimido que contiene distintas extensiones tal como se muestra en la siguiente figura. Guardamos todo esto en nuestra dirección de trabajo.

![shapefiles](https://user-images.githubusercontent.com/57784008/133181329-ad7cd661-ce46-4c61-a67c-3bf859d408f9.PNG)

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
R nos permite leer los datos geoespaciales y tratarlos como un data frame, lo cual es conveniente para poder hacer mapas usando la libraría [ggplot2](https://ggplot2.tidyverse.org/) y agregar distintas capas como rellenos, leyendas, títulos, etc. El mapa más básico que podemos hacer es el que contiene solo las líneas fronterizas. Evidentemente, lo que buscamos es mostrar variables de una base de datos en el mapa. Los objetivos de esta guía son los siguientes:
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

Asimismo, también podemos crear el mapa del Perú con una etiqueta para cada departamento si definimos los centroides de cada objeto.
```
peru_sf <- peru_sf %>% mutate(centroid = map(geometry, st_centroid), 
                              coords = map(centroid, st_coordinates), 
                              coords_x = map_dbl(coords, 1), coords_y = map_dbl(coords, 2))
```

Y luego estamos listo para graficar el mapa con etiquetas, solamente le agregaríamos una línea más al código que teníamos anteriormente. Además, para que no el mapa no se vea tan triste, le puse una tonalidad de celeste.
```
ggplot(data = peru_sf) +
  geom_sf(fill="skyblue3", color="black", alpha = 0.7)+ 
  geom_text_repel(mapping = aes(coords_x, coords_y, label = NOMBDEP), size = 2)
```
![map_centroid](https://user-images.githubusercontent.com/57784008/133008661-7e23d68c-2931-4468-949f-957de4b208f5.png)

### Juntar con bases de datos
Ya completamos el primer paso que es graficar un mapa. Evidentemente, lo que buscamos es reflejar algunos datos en él y para ello lo que debemos hacer es juntar el dataframe de datos referenciales con los archivos donde se encuentran las variables de interés. Para esta guía, se usó la Encuesta Nacional de Hogares del 2016, en específico, los módulos 3 y 34 para poder calcular la tasa de pobreza departamental y los años de educación promedio. Estos datos se encuentran en la carpeta "01_inputs/datasets" en archivos CSV.

Lo primero que haremos será importar estas dos bases de datos.
```
## Tasa de pobreza (2016)
povrate2016 <- read_csv(paste0(wd$datasets,"povrate2016.csv"))

## Años de educación promedio (2016)
educ2016 <- read_csv(paste0(wd$datasets,"educ2016.csv"))
```
Y luego, juntamos los datos georreferenciados "peru_sf" con las otras dos bases y lo nombramos "peru_datos". De esta manera, tenemos la información necesaria para generar los mapas y las variables de interés en un solo dataframe. Con esto, ya estaríamos listos para tener nuestros gráficos finales.

```
peru_datos <- peru_sf %>%
              left_join(povrate2016) %>%
              left_join(educ2016)
```

### Gráficos finales
#### Gráfico 1: Tasa de pobreza por departamento (2016)
```
ggplot(peru_datos) +
  geom_sf(aes(fill = poor))+
  labs(title = "Porcentaje de población pobre\npor departamento (2016)",
       caption = "Fuente: Enaho (2016)\nElaboración propia",
       x="Longitud",
       y="Latitud",
       fill = "Tasa de pobreza")+
  scale_fill_gradient(low = "steelblue1", high = "steelblue4")+
  theme_bw()
ggsave(paste0(wd$outputs, "poormap1.png"))
```
![poormap1](https://user-images.githubusercontent.com/57784008/133009342-8769f665-8146-4f06-81a4-bf1f0ac02369.png)

#### Gráfico 2: Años de educación promedio por departamento (2016)
```
ggplot(peru_datos) +
  geom_sf(aes(fill = educ))+
  labs(title = "Años de educación promedio\npor departamento (2016)",
       caption = "Fuente: Enaho (2016)\nElaboración propia",
       x="Longitud",
       y="Latitud",
       fill = "Años de educación")+
  scale_fill_gradient(low = "darkseagreen1", high = "darkseagreen4")+
  theme_bw()
ggsave(paste0(wd$outputs, "educmap1.png"))
```
![educmap1](https://user-images.githubusercontent.com/57784008/133009434-c003605b-6539-4884-bc4b-6adff70ab881.png)

#### Gráfico 3: Pobreza y años de educación (2016)
```
ggplot(peru_datos) +
  geom_sf(aes(fill = poor))+
  scale_fill_gradient(low = "steelblue1", high = "steelblue4")+
  geom_point(aes(coords_x, coords_y, size = educ), color = "darkseagreen3")+
  labs(title = "Pobreza y años de educación (2016)",
       caption = "Fuente: Enaho (2016)\nElaboración propia",
       x="Longitud",
       y="Latitud",
       fill = "Tasa de pobreza",
       size = "Años de educación")+
  theme_bw()
ggsave(paste0(wd$outputs, "povertyeduc.png"))
```

![povertyeduc](https://user-images.githubusercontent.com/57784008/133009470-05969771-fec2-42c7-bf4b-f16fab757e68.png)
