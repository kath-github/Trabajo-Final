
### ANÁLISIS DE PROCESOS PUNTUALES


# Librerías a utilizar

library(plotrix)
library(rgeos)
library(readr)
library(dplyr)
library(spatstat)
library(sp)
library(rgdal)
library(raster)
library(dplyr)
library(maptools)
library(haven)


# Directorio de trabajo
setwd("C:/Users/Katherine/OneDrive/UCR/Maestria/Geoespacial/TrabajoFinal")

# Lectura de datos
datos<-as.data.frame(read_dta("C:/Users/Katherine/OneDrive/UCR/Maestria/Geoespacial/TrabajoFinal/megabaseprimariaActualizada13-06-19.dta"))


#El formato de los datos son solo coordenadas, hay que darles formato
## Las escuelas
## El fenómeno que se mueve es la variable que se está estudiando
## Variable respuesta es la disminución de la matrícula


coords <- datos %>%  dplyr::select(X2,Y2) %>% filter(is.na(X2) != T) #Eiliminar valores eprdodos
sp::coordinates(coords)=~X2+Y2
plot(coords)# Mapa de coordenadas


mapa <-readOGR("Distritos_R", "Distritosv2")
mapa <- spTransform(mapa, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
plot(mapa) #Mapa de distritos


#Una vez que se ha dado formato a las coordenadas se procede a limpiar los datos
#Se seleccionan las variables de interés
#En el caso de la matrícula se crean dos variables que puede ser interesante a explorar, las proyecciones de población del INEC señalan que la población con edades entre 5 a 9 años experimentarían un crecimiento del 2,05%, es decir el grupo de edad que más se aproxima al primer ciclo de la primaria, mientras que para el grupo de edad entre 10 a 14 años se experimentaría una dismminución del 7,7%. 
#Por esa razón interesa ver el análisis por grupos 

#Se eliminan los valores perdidos
data1 <- datos %>% filter(!is.na(X2))


#Se crean las variables de matrícula y se añaden dos que sea la diferencia entre la matrícula del 2011 y 2018 en términos porcentuales y absolutos

datos2 <- data1 %>%  dplyr::mutate(Mat_Total=  mit_11 + mit_12 + mit_13 + 
                                     mit_14 + mit_15+ mit_16+ mit_17+mit_18)%>%
  dplyr::mutate(Dif_abs= mit_18-mit_11)%>%
  dplyr::mutate(Dif_rel= (Dif_abs/mit_11)*100)%>%
  dplyr::select(cdpr16, cdcan16,cddis16,
                zona18,X2,Y2,nombre_ins,Mat_Total,Dif_abs)

datos2
dim(datos2)



#Set de datos con escuelas solo con disminuciones de la matrícula
datos3<- datos2 %>% dplyr:: filter(Dif_abs<0)
dim(datos3)
2402/4505 ##53% de las escuelas con disminuciones en la matrícula

# Se crea el set de datos espacial
sp::coordinates(datos3)=~X2+Y2
projection(datos3)=projection(mapa)
overlay <- over(datos3,mapa)
crs(datos3) <- CRS("+proj=longlat +datum=WGS84")
plot(mapa) + plot(datos3, add = T)




##Procesos puntuales
  
## Detección de duplicidades: No hay
zero <- zerodist(datos3) # Zerodiste elimina detecta si hay ubicaciones duplicadas
length(unique(zero[,1])) #Cantidad de ubicaciones duplicadas


## Análisis descriptivo
### Para el análisis que se realiza se requiere examinar la distribución espacial de los eventos y realizar inferencias sobre los patrones que se encuentren
### Se estiman los índices
media_centroX <- mean(datos3@coords[,1])
media_centroy <- mean(datos3@coords[,2])

sd_centroX <- mean(datos3@coords[,1])
sd_centroy <- mean(datos3@coords[,2])
standard_distance <- sqrt(sum(((datos3@coords[,1]-
                                  media_centroX)^2+(datos3@coords[,2]-
                                                      media_centroy)^2))/(nrow(datos3)))


## Se procede a graficar la dispersión de los datos con respecto a la media utilizando la distancia estándar
## Para esto se grafica el círculo de la media
plot(datos3,pch="+",cex=0.5,main="")
plot(mapa,add=T)
points(media_centroX,media_centroy,col="red",pch=16)
plotrix::draw.circle(media_centroX,media_centroy,radius=standard_distance,border="red",lwd=2)



# Se grafica nuevamente pero utilizando la elipse de la media en lugar del círculo, 
#esto permite incluir las desviaciones estándar de longitud y latitud mientras que en el cículo 
#se promediaban y no se visualizaba de forma correcta las dimensiones
plot(datos3,pch="+",cex=0.1,main="")
plot(mapa,add=T)
points(media_centroX,media_centroy,col="red",pch=16)
draw.ellipse(media_centroX,media_centroy,a=sd_centroX,b=sd_centroy,border="red",lwd=2)

# Eliminar duplicados
datos_uniq <- remove.duplicates(datos3)
dim(datos_uniq )


#Se define la ventana o área donde se ubican las observaciones bajo análisis**
  ##Se requiere determinar cuántos eventos se tienen en una ventana (área) predeterminada. 
  ##Se debe calcular la intensidad y densidad de los eventos 
  ##Lo primero es transformar el archivo en UTM

mapa.utm <- spTransform(mapa,CRS("+init=epsg:32630"))
datos3.utm <- spTransform(datos_uniq,CRS("+init=epsg:32630"))
window <- spatstat::as.owin(mapa.utm)



# Estimar la densidad e intensidad de los eventos
## 2.540001e-09
datos.ppp <- ppp(x=datos3.utm@coords[,1],y=datos3.utm@coords[,2],window=window)
datos.ppp$n/sum(sapply(slot(mapa.utm, "polygons"), slot, "area"))

## Se grafica la intensidad de los eventos para determinar si el proceso bajo análisis 
## es uniforme o homogéneo
## Para determinarlo en este caso se utiliza el recuento en cuadrantes (quadrat counting), que divide el número de eventos en cada rectángulo
plot(datos.ppp,pch="+",cex=0.5,main="")
plot(quadratcount(datos.ppp, nx = 4, ny = 4),add=T,col="red")


#Para dar mas precisión al análisis se extrae la información por división administrativa de la región de análisis esto produce más certeza y precisión de
#la cantidad de escuelas con disminuciones en la matrícula

Local.Intensity <- data.frame(Borough=factor(),Number=numeric())
## Provincia
#pdf("plots/Fig1a.pdf")
for(i in unique(mapa.utm$nom_prov)){
  sub.pol <- mapa.utm[mapa.utm$nom_prov==i,]
  sub.ppp <- ppp(x=datos.ppp$x,y=datos.ppp$y,window=as.owin(sub.pol))
  Local.Intensity <-rbind(Local.Intensity,
                          data.frame(Borough=factor(i,levels=unique(mapa.utm$nom_prov)),
                                     Number=sub.ppp$n))
}


# Intensidad por cantón
## Canton
Local.Intensity <- data.frame(Borough=factor(),Number=numeric())
for(i in unique(mapa.utm$nombre)){
  sub.pol <- mapa.utm[mapa.utm$nombre==i,]
  sub.ppp <- ppp(x=datos.ppp$x,y=datos.ppp$y,window=as.owin(sub.pol))
  Local.Intensity <-rbind(Local.Intensity,
                          data.frame(Borough=factor(i,levels=unique(mapa.utm$nombre)),
                                     Number=sub.ppp$n))
}
Local.Intensity %>% arrange(desc(Number)) %>% head(10)



#### Mapa de calor ####
#Este mapa dura mucho en correr, si da problema se puede hacer la versión que considera 
# solo la provincia de San Jose

par(mfrow=c(2,2))
plot(density.ppp(datos.ppp, sigma =
                   bw.diggle(datos.ppp),edge=T),main=paste("h =",round(bw.diggle(datos.ppp),2)))
plot(density.ppp(datos.ppp, sigma = bw.ppl(datos.ppp),edge=T),main=paste("h
=",round(bw.ppl(datos.ppp),2)))
plot(density.ppp(datos.ppp, sigma =
                   bw.scott(datos.ppp)[2],edge=T),main=paste("h
=",round(bw.scott(datos.ppp)[2],2)))
plot(density.ppp(datos.ppp, sigma =
                   bw.scott(datos.ppp)[1],edge=T),main=paste("h
=",round(bw.scott(datos.ppp)[1],2)))

# Estimación de la Función G
plot(Gest(datos.ppp),main="Función G para el cambio demográfico")


