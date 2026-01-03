== Procesamiento computacional de la base de datos Grambank

Para el análisis se usó bases de datos lingüísticas, que contienen información que podemos procesar para corroborar la hipótesis. La principal base de datos que usamos es Grambank @grambank. Esta base de datos contiene información de 2,467 lenguas y dialectos en el mundo, y registra un máximo de 195 características por lengua.

Otra base de datos que usamos para validar es _World Atlas of Language Structures_ (WALS) @wals. Esta base de datos contiene información de las propiedades fonológicas, gramaticales y léxicas de las lenguas. WALS contiene información de 2,662 lenguas y dialectos y registra hasta 192 características por lengua.

// Citar con Grambank Wiki?
Hay que considerar que si bien Grambank y WALS pueden ser similares, no hay una relación uno a uno entre ellas. En primer lugar, Grambank está basada en diversos cuestionarios, entre ellos incluido WALS. Además, pudimos corroborar que hay lenguas, como el español, que están presentes en WALS pero no en Grambank.

// Citar con Grambank Wiki?
Sin embargo, de acuerdo a los autores de Grambank, esta base de datos está más enfocado al análisis computacional que WALS.

Estas dos bases de datos siguen el estándar de Cross-Linguistic Data Formats (CLDF) @cldf. El modelo de datos que este estándar ofrece es:
- Lenguas que son los objetos de investigación.
- Parámetros, que son los conceptos comparativos medidos y comparados entre lenguas. Para nuestro estudio, nos referiremos a estos como las características.
- Valores, que son las mediciones concretas de un parámetro sobre una lengua.
- Fuentes, ya que cada valor puede venir de diferentes fuentes.

Para nuestro fin, queremos obtener el valor de las características para cada lengua en cada una de estas bases de datos.

Para hacer el análisis, necesitábamos representaciones vectoriales de las lenguas que capturaran conocimiento lingüístico. Obtuvimos estos datos de Grambank y WALS, dos bases de datos lingüísticas públicas. Como ambas usan el estándar CLDF, el procesamiento fue similar en ambos casos.

Cada repositorio ofrece varias formas de acceder a los datos @cldf : archivos CSV, una biblioteca de Python, acceso mediante R o una base de datos SQLite. Usamos SQLite por la flexibilidad para hacer consultas con filtros y relaciones.

Las tablas relevantes en las bases de datos SQLite, que siguen el estándar CLDF @cldf, fueron:

- `LanguageTable`, que contiene información general de las lenguas, como el nombre de la lengua.
- `ParameterTable`, que contiene información de las características de las lenguas, pero no el valor específico correspondiente a cada lengua.
- `ValueTable`, que contiene información de los valores de las características para una lengua en específica. En Grambank y WALS, estos valores son númericos. 

// TODO: Hacer un diagrama para ver cómo se relacionan las lenguas
Estas tablas  están relacionadas entre sí, siendo `ValueTable` la que está relacionada con `LanguageTable` y `ParameterTable`.

A continuación, un fragmento de la tabla `ValueTable` en Grambank:

#table(
  stroke: none,
  columns: (auto, auto, auto, auto),
  table.header([*cldf_id*], [*cldf_languageReference*], [*cldf_parameterReference*], [*cldf_value*]),
  [GB025-abad1241], [abad1241], [GB025], [1],
  [GB026-abad1241], [abad1241], [GB026], [0],
  [GB027-abad1241], [abad1241], [GB027], [0], 
  [GB028-abad1241], [abad1241], [GB028], [1],
  [GB030-abad1241], [abad1241], [GB030], [0],
)

ValueTable nos dio las representaciones vectoriales de las lenguas. Cada lengua se convierte en un vector usando los valores de sus características. Por ejemplo, el inglés con las características GB020, GB021, GB022 y GB023 de Grambank produce el vector $v = (1, 1, 1, 0)$.

Para procesar todas las lenguas, usamos una matriz de dimensión $n times m$ donde $n$ es el número de lenguas y $m$ el número de características. Al procesar estos datos, encontramos que algunas lenguas no tienen valores para ciertas características. A veces la base de datos explica por qué, otras veces la entrada simplemente no existe en `ValueTable`. En estos casos, dejamos esos valores como nulos en la matriz.

Sin embargo, los algoritmos utilizados necesitaban que los datos de la matriz no fueran nulos. Para tratar estos casos de valores inexistentes, usamos la imputación de estos valores con un valor constante 0.