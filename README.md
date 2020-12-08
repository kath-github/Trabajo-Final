# Trabajo-Final
Patrones del Cambio Demográfico en las Escuelas Públicas de Costa Rica: 2010-2019

# Resumen
En este repositorio se puede encontrar toda la información relacionada con la entrega final del curso de SP-1649 del 

Este repositorio contiene el código y datos de la presentación sobre el proyecto final del curso SP-1649 Tópicos de Estadística Espacial Aplicada: Estudio de patrones geográficos de la exclusión escolar en secundaria en Costa Rica, 2015, desarrollado por Mariana Cubero Corella, como parte de la Maestría en Estadística de la Universidad de Costa Rica. El documento del informe final está disponible de forma abierta en Overleaf en el siguiente enlace: https://www.overleaf.com/project/5fcee925a7eb144643a69677.

Patrones del Cambio Demográfico en las Escuelas Públicas de Costa Rica: 2010-2019
* Resumen
  * Estructura del repositorio
* Datos
* Fuentes de información
* Descripción de datos
    * Procesamiento y análisis de los datos
    * Limpieza
    * Análisis
    * Gráficos
* Preguntas
* Licencia

# Estructura del repositorio
El repositorio está compuesto por dos archivos de R, usados para cada metodología de análisis, procesos puntuales y estadística de áreas, y dos carpetas que contienen los datos y los gráficos producidos y usados en el artículo final:

Los archivos de R, disponibles en formato .R, contienen los procedimientos usados para el análisis de procesos puntuales(procesospuntuales.R)y otro para el análisis de estadística de áreas presentados en el informe final y la presentación (EstadísticaAreas.R).

La carpeta datos contiene los datos usados y producidos por los scripts mencionados anteriormente, mientras que la carpeta plots contiene los gráficos producidos y usados en el artículo. 

# Datos

Esta investigación utiliza la información de las características de los colegios públicos y privados en Costa Rica del año 2015, se consideran únicamente los centros educativos académicos diurnos con una exclusión escolar porcentual mayor a 3 puntos porcentuales, que se encuentren georeferenciados. 

Se cuenta con 401 observaciones en todo el país con datos del año 2015. Se consideran variables puntuales, como matrícula total al inicio del año, exclusión escolar a final de ciclo, latitud y longitud de cada centro educativo.

Los datos y su correspondiente diccionario de datos son obtenidos del repositorio de bases de datos del [Programa Estado de la Nación](https://estadonacion.or.cr/base-datos/)

Para el shapefile de Costa Rica se usó el mapa de Costa Rica a nivel de distrito, contiene 483 polígonos. El archivo de este mapa se unió con los datos de exclusión escolar mencionados anteriormente para crear un solo shapefile que contiene el mapa y los datos de análisis. Además, las variables de exclusión se agregaron por distrito, de manera que se crearon nuevas variables con el promedio para cada indicador.
# Variables 
#### Variables de los centros educativos
Las variables disponibles sobre la matrícula del año 2015: 
* mit_11	Numérico	Matrícula inicial Total 2011 VF

* mit_12	Numérico	Matrícula inicial Total 2011 VF

* mit_13	Numérico	Matrícula inicial Total 2012 VF

* mit_14	Numérico	Matrícula inicial Total 2012 VF

* mit_15	Numérico	Matrícula inicial Total 2012 VF

* mit_16	Numérico	Matrícula inicial Total 2012 VF

* mit_17	Numérico	Matrícula inicial Total 2012 VF

* mit_18	Numérico	Matrícula inicial Total 2012 VF

Coordenadas de los centros educativos

* Y2	Numérico		Y2

* X2	Numérico		X2


#### Variables asociada al shape de distritos de Costa Rica 
* nom_cant Factor: Nombre del cantón

* nom_prov Factor: Nombre de la provincia

* nom_distr Factor: Nombre del distrito  

* cod_dta   Numérico: Código concatenado en provincia-cantón-distrito

# Procesamientos
El procesamiento de los datos se realizó con el software estadístico R. El primer paso consistió en realizar una limpieza de los datos y concatenar la información geoespacial que se encontraba en otras carpetas en formatos de shape que son necesarios para analizar y estimar cada uno de los métodos empleados en el análisis. Se crean las variables que cuantifican las disminuciones absolutas y relativas en la matrícula y en los casos pertienentes se trabaja con set de datos en donde solo se experimentan las reducciones en la matrícula.

# Análisis

Para dar respuesta a la pregunta de investigación de la que parte el proyecto final se realizó un análisis de procesos puntuales y un análisis de estadística de áreas, los pasos y códigos empleados para su desarrollo se presentan en los siguientes enlaces. El primer método pretende determinar si la distribución espacial de los eventos tiene un patrón aleatorio o si podria sugerirse la existencia de algunas agruapaciones, se estima además la intensidad y densidad de los eventos a partir de la identificación de puntos de calor. En el segundo caso, se analiza la disminución de la matrícula presentada a nivel distrital y se detecta si hay dependencia espacial entre las áreas de interés asi como la identificación de clusters con test locales la identificación de los distritos de influencia.


 * [Script_ProcesosPuntuales.R](https://github.com/kath-github/Trabajo-Final/blob/main/Script_ProcesosPuntuales.R)
 * [Sript_EstadísticasAreas.R](https://github.com/kath-github/Trabajo-Final/blob/main/Sript_Estad%C3%ADsticasAreas.R)

  
# Contact info

Katherine Barquero Mejías

Email: kath30.bm@gmail.com



# Licencia

El código usado y presentado en este repositorio tiene una licencia [MIT](https://opensource.org/licenses/MIT), mientras que los datos y figuras tienen una licencia [CC-BY](https://creativecommons.org/licenses/by/4.0/deed.es), a menos que se especifique explicitamente otra licencia. Las condiciones de las licencias anteriormente mencionadas están descritas en el archivo LICENSE de este repositorio.

<a rel="license" href="http://creativecommons.org/licenses/by/4.0/"><img alt="Creative Commons License" style="border-width:0" src="https://i.creativecommons.org/l/by/4.0/88x31.png" /></a><br />This work is licensed under a <a rel="license" href="http://creativecommons.org/licenses/by/4.0/">Creative Commons Attribution 4.0 International License</a>.

Licencia Creative Commons
Esta obra está bajo una Licencia Creative Commons Atribución 4.0 Internacional.

# Resumen de entregas
<table style="width:100%">
  <tr>
    <th width="50%"> Entrega </th>
    <th width="50%">  Documento </th>
  </tr>
  <tr>
    <td width="10%"> Poster </td>
    <td width="25%">  <a href="Poster_kbm.pdf"> Entrega 1 </td>
  </tr>
  <tr>
    <td width="10%"> Métodos propuestos </td>
    <td width="25%">  <a href="Avance3_KatherineBarquero.pdf"> Entrega 2 </td>
  </tr>
  <tr>
    <td width="10%"> Artículo </td>
    <td width="25%">  <a href="TrabajoFinal.pdf"> Documento final</td>
  </tr>
    <tr>
    <td width="10%"> Presentación </td>
    <td width="25%">  <a href="Presentacion.pdf"> Presentación </td>
  </tr>
    </tr>
    <tr>
    <td width="10%"> Video  </td>
    <td width="25%">  <a href="PresentacionTrabajoFinal_KatherineBarquero.mp4"> Presentación grabada </td>
  </tr>
 </table>
