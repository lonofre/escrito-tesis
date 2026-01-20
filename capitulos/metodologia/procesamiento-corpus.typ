== Procesamiento computacional de las bases de datos lingüísticas

Para hacer el análisis, necesitamos representaciones vectoriales de cada lengua que codificara información lingüística. Para esto, usamos bases de datos lingüísticas, que contienen información que podemos procesar para corroborar la hipótesis.

=== WALS

Una de las bases de datos que usamos para validar fue WALS @wals. Esta base de datos contiene información de las propiedades fonológicas, gramaticales y léxicas de las lenguas. WALS contiene información de 2,662 lenguas y dialectos y registra hasta 192 características por lengua.

Nuestro enfoque con WALS es usar las mismas características que #cite(<ximena-bpe-2023>, form: "prose"). Esto consistió en el uso de X características.

WALS maneja las características...
// Podemos dar un pequeño contexto de WALS

=== Grambank

La principal base de datos que usamos es Grambank @grambank. Esta base de datos contiene información de 2,467 lenguas y dialectos en el mundo, y registra un máximo de 195 características por lengua.

// // Citar con Grambank Wiki?
Hay que considerar que si bien Grambank y WALS pueden ser similares, no hay una relación uno a uno entre ellas. En primer lugar, Grambank está basada en diversos cuestionarios, entre ellos incluido WALS. Además, pudimos corroborar que hay lenguas, como el español, que están presentes en WALS pero no en Grambank.

Las características de Grambank tienen algo en particular respecto a las de WALS. La mayoría usa valores binarios (0/no, 1/sí). De acuerdo a #cite(<haynie-etal-2023-grambanks>, form: "prose"), usar características binarias permiten evitar ambigüedades en la categorización las características y permite registrar los rasgos en términos de presencia o ausencia, en vez de categorizar sólo la más dominante.

Por ejemplo, la característica GB020:

#align(center)[
  1. Codifique con 1 si existe un morfema que pueda marcar definitud o especificidad sin transmitir también un significado deíctico espacial.

  2. Codifique con 0 si la fuente no menciona un artículo definido y no es posible encontrar uno en los ejemplos o textos de una gramática que, por lo demás, es exhaustiva.

  3. Codifique con ? si la gramática no contiene suficiente análisis para determinar si existe o no un artículo definido.

  4. Si ha codificado 1 para GB020 y 0 para GB021 y GB022, por favor escriba un comentario explicando la posición del artículo definido o específico.

]

Nos percatamos que algunas características tienen una codificación de que no se tiene o no hay suficiente información para hacer una clasificación (?/desconocido).

// Podemos abordar más a fondo Grambank aquí, diferencias, etc

// Citar con Grambank Wiki?
Sin embargo, de acuerdo a los autores de Grambank, esta base de datos está más enfocado al análisis computacional que WALS.


=== Lenguas usadas

Grambank y WALS comparten varias lenguas en común. Sin embargo, no todas esas lenguas tienen una relación uno a uno, así tuvimos que realizar una serie de elección de lenguas debido a cómo se presentan en Grambank. Por ejemplo, en WALS sólo tenemos identificado una lengua para un nombre, mientras que Grambank tiene para esa misma lengua varias. Por ejemplo, el (poner una lengua de ejemplo):

// Quizá poner un diagrama

// Poner cita de por qué no tienen esas lenguas
Otra diferencia es que Grambank no tiene lenguas como el español y el alemán. Según ellos...

=== Procesamiento

Grambank y WALS siguen el estándar de Cross-Linguistic Data Formats (CLDF) @cldf. Parte de la información que el modelo de datos que CLDF ofrece es:

- Lenguas que son los objetos de investigación.
- Parámetros, que son los conceptos comparativos medidos y comparados entre lenguas. Para nuestro estudio, nos referiremos a estos como las características.
- Valores, que son las mediciones concretas de un parámetro sobre una lengua.
- Fuentes, ya que cada valor puede venir de diferentes fuentes.

Gracias a que ambas bases de datos siguen el mismo estándar, el procesamiento de ambas es similar. Obtuvimos los datos de Grambank y WALS de repositorios públicos de GitHub. Cada repositorio ofrece varias formas de acceder a los datos @cldf : archivos CSV, una biblioteca de Python, acceso mediante R o un programa para crear una base de datos SQLite. Usamos el enfoque de  SQLite por la flexibilidad para hacer consultas con filtros y relaciones entre las tablas.

Las tablas relevantes en las bases de datos SQLite, que siguen el estándar CLDF @cldf, fueron:

- _LanguageTable_, que contiene información general de las lenguas, como el nombre de la lengua.
- _ParameterTable_, que contiene información de las características de las lenguas, pero no el valor específico correspondiente a cada lengua.
- _ValueTable_, que contiene información de los valores de las características para una lengua en específica. En Grambank y WALS, estos valores son numéricos. 

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

Sin embargo, los algoritmos utilizados necesitaban que los datos de la matriz no fueran nulos. Para tratar estos casos de valores inexistentes, usamos la imputación de estos valores. Tuvimos considerar que hay varias formas de hacer este relleno de valores nulos.

// Podemos citar también?
- Usar valores en 0. Usando este, asumimos que el valor nulo se puede asumir como ausencia de.
- Usar valores en -1. De igual manera, asumimos que la ausencia se puede modelar como algo desconocido.
- Usar valores de la media del conjunto. Esto es, base en los valores de otras lenguas que están en la matriz.
- Usar valores de lenguas cercanas a esa lengua. Con esto, tenemos un aproximado del valor de la otra lengua. Sin embargo, como no tenemos conocimientos lingüísticos, dudamos en implementar esta opción.

// Pon que también se uso StandarScaler
Otra paso del procesamiento fue estandarizar y centrar los puntos que obutivmos después de construir la matriz. Esto se logra con:

// Poner ambas formulas matemáticas de Standar Scaler

Otra cosa importante fue seleccionar cuáles son las características que queremos usar para cada lengua. Para WALS, usamos las lenguas descritas en el trabajo de #cite(<ximena-bpe-2023>, form: "prose"). Mientras que para Grambank, esperamos obtener el menor número de valores nulos.

1. Ordenamos las características de acuerdo a qué tantas lenguas cubren.
2. Después, seleccionamos de acuerdo a ese ordenamiento para obtener $n$ características.