== Procesamiento computacional de la base de datos Grambank

Para hacer uso de los datos de Grambank y WALS, tuvimos que almacenar sus datos en una base de datos SQLite y representar esos datos en vectores. Este proceso es similar para ambas bases de datos, debido a que ambas usan el estándar de CLDF.

Las bases de datos de Grambank y WALS se encuentran disponibles en repositorios públicos. El proceso de construcción de una base de datos SQLite pudo ser llevada a cabo gracias a una de las herramientas que el estándar de CLDF @cldf trae consigo, que es una biblioteca en Python para hacer este procesamiento.

Una vez con las bases de datos SQLite, las tablas de las bases de datos de nuestro interés fueron las siguientes, que siguen el estándar de CLDF @cldf:
- LanguageTable, que contiene información de las lenguas.
- ParameterTable, que contiene información de las características.
- ValueTable, que contiene información de los valores de las características para una lengua en específica.

Estas tablas  están relacionadas entre sí, siendo ValueTable la que está conectada con LanguageTable y ParameterTable.

Por ejemplo, este es un fragmento de la tabla ValueTable en Grambank.
#table(
  stroke: none,
  columns: (auto, auto, auto, auto),
  table.header([cldf_id], [cldf_languageReference], [cldf_parameterReference], [cldf_value]),
  [GB025-abad1241], [abad1241], [GB025], [1],
  [GB026-abad1241], [abad1241], [GB026], [0],
  [GB027-abad1241], [abad1241], [GB027], [0], 
  [GB028-abad1241], [abad1241], [GB028], [1],
  [GB030-abad1241], [abad1241], [GB030], [0],
)

La tabla ValueTable es la que nos permitió crear representaciones vectoriales de las lenguas. Por cada lengua y un conjunto de características, podemos crear un vector con los valores de las características asociadas a esa lengua. Por ejemplo, para inglés con las características GB020, GB021, GB022 y GB023 de Grambank, podemos crear el vector $v = (1, 1, 1, 0)$.

Cuando procesamos esta información, tenemos que considerar que para algunas lenguas, el valor para una característica no puede existir no está disponible. En algunos casos, la base de datos tiene una explicación acerca de esto; en otros, la entrada es inexistente en la tabla de ValueTable.

Para tratar los casos de valores inexistentes, usamos la imputación de estos valores con un valor constante 0.