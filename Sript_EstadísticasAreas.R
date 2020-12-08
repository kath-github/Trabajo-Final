#### Análisis Estadística de Áreas ####


#Se cargan las librerías a utilizar
library(dplyr)
library(spatstat)
library(sp)
library(rgdal)
library(raster)
library(maptools)
library(haven)
library(ggplot2)
library(spdep)
library(plotrix)
library(rgeos)
library(readr)
library(RColorBrewer)
library(mapview)


#Se fija el directorio de trabajo
setwd("C:/Users/Katherine/OneDrive/UCR/Maestria/Geoespacial/TrabajoFinal")

#Se cargan los datos
mapa <-readOGR("Distritos_R", "Distritosv2")
mapa <- spTransform(mapa, CRS("+proj=longlat +datum=WGS84 +no_defs +ellps=WGS84 +towgs84=0,0,0"))
#Se debe eliminar la Isla de Chira porque no tiene vecinos
mapa <- subset(mapa,mapa$nom_distr!="CHIRA")
data <- read_dta("megabaseprimariaActualizada13-06-19.dta")

# Se estiman las variables para el análisis
data1 <- data %>% filter(!is.na(X2))
datos2 <- data1 %>%  dplyr::mutate(Mat_Total=  mit_11 + mit_12 + mit_13 + 
                                     mit_14 + mit_15+ mit_16+ mit_17+mit_18)%>%
  dplyr::mutate(Dif_abs= mit_18-mit_11)%>%
  dplyr::mutate(Dif_rel= (Dif_abs/mit_11)*100)%>%
  dplyr::select(cdpr16, cdcan16,cddis16,
                zona18,X2,Y2,nombre_ins,Mat_Total,Dif_abs, Dif_rel)



# Se filtran las escuelas que han registrado disminuciones en la matricula
datos3<- datos2 %>% dplyr:: filter(Dif_rel<0)
datos3


###Se convierte a objeto espacial
sp::coordinates(datos3)=~X2+Y2
crs(datos3) <- CRS("+proj=longlat +datum=WGS84")


#Se concatena el mapa y la información de matrícula
projection(datos3)=projection(mapa)
overlay <- over(datos3,mapa)
datos3@data <- cbind(datos3@data, overlay)
names(datos3@data)[11] <- "nombre_cant"


#Se crea la variable cantidad de escuelas con disminución de la matrícula por distrito
datos4 <- datos3@data %>% 
  dplyr::group_by(cod_dta) %>% 
  dplyr::summarise(prom_difrel = mean(Dif_rel,na.rm=T ),
                   prom_matri = mean(Mat_Total, na.rm=T),
                   prom_difabs =mean(Dif_abs, na.rm=T),
                   cantidad=n(), na.rm=T )


tabla <-datos4%>% dplyr::mutate(abs_difrel= abs(prom_difrel),
                                abs_difabs= abs(prom_difabs))%>% 
  dplyr::select(cod_dta, prom_matri, abs_difrel)
tabla



completar <- left_join(mapa@data, tabla, by = "cod_dta")
completar[is.na(completar)] <- 0
mapa@data <- completar
xy <- coordinates(mapa)


#Definición y estimación de los vecinos a partir de la distancia
w <- knn2nb(knearneigh(xy, k=1), row.names=mapa@data$cod_dta)
plot(mapa, col='gray', border='blue', lwd=1)
plot(w, xy, col='red', lwd=2)


#Estimación de los pesos de los vecinos 
Sy0_lw_W <- nb2listw(w)
Sy0_lw_W 

names(Sy0_lw_W)
names(attributes(Sy0_lw_W))
1/rev(range(card(Sy0_lw_W$neighbours)))
summary(unlist(Sy0_lw_W$weights)) #Todo da 1
summary(sapply(Sy0_lw_W$weights, sum)) #todo da 1




# Análisis de la autocorrelación espacial
set.seed(2905)
n <- length(w)
rho <- 0.5
autocorr_x <- invIrW(Sy0_lw_W, rho) %*% mapa$abs_difrel


# Grafico de autocorrelación
oopar <- par(mfrow=c(1,2), mar=c(4,4,3,2)+0.1)
plot(autocorr_x, stats::lag(Sy0_lw_W, autocorr_x),
     xlab="", ylab="",
     main="Autocorrelated random variable", cex.main=0.8, cex.lab=0.8)
lines(lowess(autocorr_x, stats::lag(Sy0_lw_W, autocorr_x)), lty=2, lwd=2)



# Estimación de la I-Moran : -0.002079002
moran.test(mapa$abs_difrel, listw=Sy0_lw_W)
-1 / (n-1)




#Mapa con los distritos de influencia
oopar <- par(mfrow=c(1,2))
msp <- moran.plot(mapa$prom_matri, listw=nb2listw(w, style="S"), quiet=TRUE)
title("Moran scatterplot")

infl <- apply(msp["is_inf"], 1, any)
x <- abs(mapa$abs_difrel)
lhx <- cut(x, breaks=c(min(x), mean(x), max(x)), labels=c("L", "H"), include.lowest=TRUE)
wx <- stats::lag(nb2listw(w, style="S"), mapa$abs_difrel)
lhwx <- cut(wx, breaks=c(min(wx), mean(wx), max(wx)), labels=c("L", "H"), include.lowest=TRUE)
lhlh <- interaction(lhx, lhwx, infl, drop=TRUE)
cols <- rep(1, length(lhlh))
cols[lhlh == "H.L.TRUE"] <- 2
cols[lhlh == "L.H.TRUE"] <- 3
cols[lhlh == "H.H.TRUE"] <- 4
plot(mapa, col=brewer.pal(4, "Accent")[cols])
legend("topright", legend=c("None", "HL", "LH", "HH"), fill=brewer.pal(4, "Accent"), bty="n", cex=0.6, y.intersp=0.7)
title("Distritos de influencia")

mapView(mapa)


#Detección de clusters a partir de test locales
lm1 <- localmoran(mapa$abs_difrel, listw=nb2listw(w, style="C"))
r <- sum(mapa$abs_difrel)/sum(mapa$prom_matri)
rni <- r*mapa$prom_matri
lw <- nb2listw(w)
sdCR <- (mapa$abs_difrel- rni)/sqrt(rni)
wsdCR <- stats::lag(nb2listw(w, style="C"), mapa$abs_difrel)
I_CR <- sdCR * wsdCR

# Identificación de clusters según el supuesto estandar y de riesgos constantes
gry <- c(rev(brewer.pal(8, "Blues")[1:6]), brewer.pal(6, "Reds"))
mapa$Standard <- lm1[,1]
mapa$"Constant_risk" <- I_CR
#nms <- match(c("Standard", "Constant_risk"), names(NY8))
spplot(mapa, c("Standard", "Constant_risk"), at=c(-2.5,-1.4,-0.6,-0.2,0,0.2,0.6,4,7), col.regions=colorRampPalette(gry)(8))
spplot(mapa, c( "Constant_risk"), at=c(-2.5,-1.4,-0.6,-0.2,0,0.2,0.6,4,7), col.regions=colorRampPalette(gry)(8))




