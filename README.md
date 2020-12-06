# Trabajo-Final
Patrones del Cambio Demográfico en las Escuelas Públicas de Costa Rica

# Resumen
Este repositorio contiene el código y datos de la presentación sobre el proyecto final del curso SP-1649 Tópicos de Estadística Espacial Aplicada: Estudio de patrones geográficos de la exclusión escolar en secundaria en Costa Rica, 2015, desarrollado por Mariana Cubero Corella, como parte de la Maestría en Estadística de la Universidad de Costa Rica. El documento del informe final está disponible de forma abierta en Overleaf en el siguiente enlace: https://www.overleaf.com/read/vqvmxgnbhcwj.

Estudio de patrones geográficos de la exclusión escolar en secundaria en Costa Rica, 2015
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
* miit_15	Numérico	4	Matrícula inicial Total 2015 VF

* miih_15	Numérico	4	Matrícula inicial Hombres 2015 VF

* miit07_15	Numérico	3	Matrícula inicial 7º 2015 VF

* miih07_15	Numérico	3	Matrícula inicial Hombres 7º 2015 VF

* miit08_15	Numérico	3	Matrícula inicial 8º 2015 VF

* miih08_15	Numérico	3	Matrícula inicial Hombres 8º 2015 VF

* miit09_15	Numérico	3	Matrícula inicial 9º 2015 VF

* miih09_15	Numérico	3	Matrícula inicial Hombres 9º 2015 VF

* miit10_15	Numérico	3	Matrícula inicial 10º 2015 VF

* miih10_15	Numérico	3	Matrícula inicial Hombres 10º 2015 VF

* miit11_15	Numérico	3	Matrícula inicial 11º 2015 VF

* miih11_15	Numérico	3	Matrícula inicial Hombres 11º 2015 VF

* miit12_15	Numérico	3	Matrícula inicial 12º 2015 VF

* miih12_15	Numérico	3	Matrícula inicial Hombres 12º 2015 VF

Las variables disponibles sobre la exclusión escolar del año 2015: 
* desa_15	Numérico	3	Abandono Total 2015

* desah_15	Numérico	3	Abandono Hombres 2015

* desa7_15	Numérico	3	Abandono 7º 2015

* desah7_15	Numérico	3	Abandono Hombres 7º 2015

* desa8_15	Numérico	3	Abandono 8º 2015

* desah8_15	Numérico	2	Abandono Hombres 8º 2015

* desa9_15	Numérico	3	Abandono 9º 2015

* desah9_15	Numérico	2	Abandono Hombres 9º 2015

* desa10_15	Numérico	3	Abandono 10º 2015

* desah10_15	Numérico	2	Abandono Hombres 10º 2015

* desa11_15	Numérico	2	Abandono 11º 2015

* desah11_15	Numérico	2	Abandono Hombres 11º 2015

* desa12_15	Numérico	2	Abandono 12º 2015

* desah12_15	Numérico	2	Abandono Hombres 12º 2015

Coordenadas de los centros educativos

* Y2	Numérico	5	Y2

* X2	Numérico	6	X2

Tipo de Centro educativo 

* rama15	Numérico	2	Modalidad y horario 2015


#### Variables asociada al shape de distritos de Costa Rica 
* nom_cant Factor: Nombre del cantón

* nom_prov Factor: Nombre de la provincia

* canton   Factor: Nombre del cantón en mayúscula

* nom_distr Factor: Nombre del distrito  

* nombre    Factor: Nombre del distrito en mayúscula

* cod_dta   Numérico: Código provincia-cantón-distrito

# Procesamientos
Los datos fueron procesados usando R, ya que, aunque el formato de las escuelas están en un formato naturalmente compatible con software de pago R permite compatibilidad para accesar los datos y prepararlos para el análisis. Como primer paso se hice una limpieza y unión de los datos, para terminar con shapes files adecuados para cada modelo. Seguidamente, se realizan distintos análisis de los datos en R. 

# Análisis

El análisis de los datos se describe en los scripts correspondientes:
 * [procesospuntuales.R](https://mcubero05.github.io/ProyectoFinal-SP1649/procesospuntuales.R)
 * [EstadisticaAreas.R](https://mcubero05.github.io/ProyectoFinal-SP1649/EstadisticaAreas.R)
 
 
y el artículo vinculado al repositorio.

Estos datos se analizaron mediante dos métodos geoestadísticos, primeramente como un proceso puntual definido como la presencia de aquellos centros educativos con una exclusión educativa mayor a 3 puntos porcentuales. Donde se busca la presencia de un patrón sistemático, para examinar cuál es la escala espacial en la que ocurre. También, examinar si se presentan puntos de calor con mayor porcentaje de exclusión. El segundo método a utilizar es el de estadística de áreas, se prueban distintos métodos para determinar los vecinos y los pesos entre estos a nivel distrital. Una vez selecionados los vecinos y los pesos se usa la prueba de la I de Moran para determinar la existencia de auto-correlación espacial entre los distritos.
  
# Contact info

Mariana Cubero Corella

Email personal: mari.cubero511@gmail.com 

Email académico: mariana.cubero@ucr.ac.cr

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
    <td width="25%">  <a href="Poster_Secundaria_MarianaCuberoCorella.pdf"> Entrega 1 </td>
  </tr>
  <tr>
    <td width="10%"> Métodos propuestos </td>
    <td width="25%">  <a href="Avance3_Mariana.pdf"> Entrega 2 </td>
  </tr>
  <tr>
    <td width="10%"> Artículo </td>
    <td width="25%">  <a href="ArticuloFinal.pdf"> Documento final</td>
  </tr>
    <tr>
    <td width="10%"> Presentación </td>
    <td width="25%">  <a href="PresentacionFinal.pdf"> Presentación </td>
  </tr>
    </tr>
    <tr>
    <td width="10%"> Video  </td>
    <td width="25%">  <a href="PresentacionFinal.pdf"> Presentación grabada </td>
  </tr>
 </table>
