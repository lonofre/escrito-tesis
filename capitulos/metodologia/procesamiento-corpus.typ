== Procesamiento computacional de las bases de datos lingüísticas

Para hacer el análisis, necesitamos representaciones vectoriales de cada lengua que codificara información lingüística. Para esto, usamos bases de datos lingüísticas. En particular nos enfocamos en bases de datos que contienen rasgos tipológicos de las lenguas, que pueden incluir rasgos morfológicos que son apropiados para corroborar la hipótesis.

=== WALS

La base de datos _World Atlas of Language Structures_ (WALS) @wals fue una de las bases de datos que usamos para realizar la validación. Esta base de datos contiene información de las propiedades fonológicas, gramaticales y léxicas de hasta 2,662 lenguas y dialectos. Además, WALS registra hasta 192 características por lengua.

WALS maneja las características...
// Podemos dar un pequeño contexto de WAL

Nuestro enfoque con WALS fue usar las mismas características que #cite(<ximena-bpe-2023>, form: "prose"). @wals-features muestra las características codifican la tipología morfológica de las lenguas.

#figure(
  placement: auto,
    table(
    columns: (auto, 1fr),
    align: (col, row) => (if col == 0 { center } else { left }),
    stroke: none,
    table.header(
      [*Rasgo*], [*Nombre*],
      table.hline(stroke: 1pt + black)
    ),
    [20A], [Fusión de formativos flexivos seleccionados],
    [22A], [Síntesis flexiva],
    [26A], [Prefijación vs. sufijación en la morfología flexiva],
    [28A], [Sincretismo de caso],
    [29A], [Sincretismo en la marcación de persona/número verbal],
    [49A], [Número de casos],
    [59A], [Clasificación posesiva],
    [65A], [Aspecto perfectivo/imperfectivo],
    [66A], [El tiempo pasado],
    [67A], [El tiempo futuro],
    [69A], [Posición de los afijos de tiempo/aspecto],
    [70A], [El imperativo morfológico],
    [78A], [Codificación de la evidencialidad],
    [102A], [Marcación de persona verbal],
    [112A], [Morfemas negativos],
    
    table.hline(stroke: 1pt + black)
  ),
  caption: [Tabla de rasgos usados por para describir tipología morfológica @ximena-bpe-2023]
)<wals-features>

Cada rasgo puede tomar diferentes rangos de valores, por lo que dos rasgos no necesariamente tengan el mismo rango ni tampoco tienen el mismo significado. Por ejemplo, el rasgo 20A puede tomar 7 valores, 28A puede tomar hasta 4 y 49A hasta 9 valores diferentes.

// Quizá hacer una pequeña exploración aquí
Sin embargo, no todas las features tienen un valor para cada lengua. Por ejemplo, la lengua Thai no tiene ningún valor para el rasgo 20A.

Por último, WALS tiene asignado un identificador propio para cada lengua (_WALS code_), pero también hace el uso del ISO 639-3 que permite identificar a las lenguas mediante tres letras.

=== Grambank

La principal base de datos que usamos es Grambank @grambank. Esta base de datos contiene información de 2,467 lenguas y dialectos en el mundo, y registra un máximo de 195 características por lengua.


Las características de Grambank tienen algo en particular respecto a las de WALS. La mayoría usa valores binarios (0/no, 1/sí). De acuerdo a #cite(<haynie-etal-2023-grambanks>, form: "prose"), usar características binarias permiten evitar ambigüedades en la categorización las características y permite registrar los rasgos en términos de presencia o ausencia, en vez de categorizar sólo la más dominante.

Por ejemplo, la característica GB020:

#align(center)[
  1. Codifique con 1 si existe un morfema que pueda marcar definitud o especificidad sin transmitir también un significado deíctico espacial.

  2. Codifique con 0 si la fuente no menciona un artículo definido y no es posible encontrar uno en los ejemplos o textos de una gramática que, por lo demás, es exhaustiva.

  3. Codifique con ? si la gramática no contiene suficiente análisis para determinar si existe o no un artículo definido.

  4. Si ha codificado 1 para GB020 y 0 para GB021 y GB022, por favor escriba un comentario explicando la posición del artículo definido o específico.
]

Nos percatamos que algunas características tienen una codificación de que no se tiene o no hay suficiente información para hacer una clasificación (?/desconocido).

Otra aspecto a destacar es que Grambank no hace uso del ISO 639-3 para identificar las lenguas. Sólo hace uso del identificador que ellos generan para cada lengua.

// Podemos abordar más a fondo Grambank aquí, diferencias, etc

// Citar con Grambank Wiki?
Sin embargo, de acuerdo a los autores de Grambank, esta base de datos está más enfocado al análisis computacional que WALS.

=== Diferencias entre Grambank y WALS

// // Citar con Grambank Wiki?
Hay que considerar que si bien Grambank y WALS pueden ser similares, no hay una relación uno a uno entre ellas, ni para los rasgos ni para las lenguas. En primer lugar Grambank, la base de datos más reciente, está basada en diversos cuestionarios, entre ellos incluido WALS. Además pudimos corroboramos que lenguas, como el español, están presentes en WALS pero no en Grambank. En segundo lugar, como podemos contrastar, Grambank hace uso de rasgos binarios en su mayoría, mientras que WALS pueden tomar hasta más de 2 de valores.

// Poner cita de por qué no tienen esas lenguas
Otra diferencia es que Grambank no tiene lenguas como el español y el alemán. Según ellos...

A pesar de que Grambank y WALS comparten varias lenguas en común, no todas esas lenguas tienen una relación uno a uno. Esto es más evidente a que cada base de datos usa su propio identificador para cada lengua y Grambank no hace uso del ISO 639-3. Entonces, para hacer una relación uno a uno lo más cercano posible, tuvimos que realizar la elección de lenguas en Grambank de acorde a lo siguiente:
// Aquí elaborar más sobre cada cosa
- Respecto al nombre. 
- Respecto a las características disponibles.
- Respecto a lenguas con el nombre similar.

// Quizá poner un diagrama


=== Procesamiento

Grambank y WALS siguen los Cross-Linguistic Data Formats (CLDF) @cldf, que son un conjunto de estándares para estructurar, compartir y reutilizar datos lingüísticos. Parte de la información que el modelo de datos que CLDF ofrece es:

- _Lenguas_, que son los objetos de investigación.
- _Parámetros_, que son los conceptos comparativos medidos y comparados entre lenguas. Para nuestro estudio, nos referiremos a estos como las características.
- _Valores_, que son las mediciones concretas de un parámetro sobre una lengua.
- _Fuentes_, ya que cada valor puede venir de diferentes fuentes.

Gracias a que Grambank y WALS siguen CLDF, el procesamiento de ambas bases de datos es similar. Obtuvimos los datos de Grambank y WALS de repositorios públicos de GitHub. Cada repositorio ofrece varias formas de acceder a los datos debido a la especificación de CLDF como las herramientas desarrolladas por #cite(<cldf>, form: "prose"): 
- mediante archivos CSV, 
- por una biblioteca de Python en código, 
- acceso mediante R , o 
- pycldf, un programa en Python para crear una base de datos SQLite. 

Usamos el enfoque de SQLite por construir una base de datos relacional. Esto nos da la flexibilidad para hacer consultas con filtros, relaciones entre las tablas y poder ordenar los datos.

Las tablas relevantes que usamos fueron las que siguen CLDF:

- _LanguageTable_, que contiene información general de las lenguas, como el nombre de la lengua y su identificador único.
- _ParameterTable_, que contiene información de las características de las lenguas, pero no el valor específico correspondiente a cada lengua.
- _ValueTable_, que contiene información de los valores de las características para una lengua en específica. En Grambank y WALS, estos valores son numéricos. 

// TODO: Hacer un diagrama para ver cómo se relacionan las lenguas
Estas tablas  están relacionadas entre sí, siendo `ValueTable` la que está relacionada con `LanguageTable` y `ParameterTable`. A continuación, un fragmento de la tabla `ValueTable` en Grambank:

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

El procesamiento de `ValueTable` nos dio las representaciones vectoriales de las lenguas. Cada lengua se convierte en un vector usando los valores de sus características. Por ejemplo, el inglés con las características GB020, GB021, GB022 y GB023 de Grambank produce el vector $v = (1, 1, 1, 0)$.

Para procesar todas las lenguas, usamos una matriz de dimensión $n times m$ donde $n$ es el número de lenguas y $m$ el número de características. Al procesar estos datos, encontramos que algunas lenguas no tienen valores para ciertas características. A veces la base de datos explica por qué, otras veces la entrada simplemente no existe en `ValueTable`. En estos casos, dejamos esos valores como nulos en la matriz.

Sin embargo, los algoritmos que utilizamos necesitaban que los datos de la matriz no sean nulos. Para tratar estos casos de valores inexistentes, usamos la imputación de estos valores. Tuvimos considerar que hay varias formas de hacer este relleno de valores nulos.

// Podemos citar también?
- Usar valores en 0. Usando este, asumimos que el valor nulo se puede asumir como ausencia de.
- Usar valores en -1. De igual manera, asumimos que la ausencia se puede modelar como algo desconocido.
- Usar valores de la media del conjunto. Esto es, base en los valores de otras lenguas que están en la matriz.
- Usar valores de lenguas cercanas a esa lengua. Con esto, tenemos un aproximado del valor de la otra lengua. Sin embargo, como no tenemos conocimientos lingüísticos, dudamos en implementar esta opción.

// Pon que también se uso StandarScaler
Otra paso del procesamiento fue estandarizar y centrar los puntos que obtuvimos después de construir la matriz. Esto se logra con:

// Poner ambas formulas matemáticas de Standar Scaler

Otra cosa importante fue seleccionar cuáles son las características que queremos usar para cada lengua. Para WALS, usamos las lenguas descritas en el trabajo de #cite(<ximena-bpe-2023>, form: "prose"). Mientras que para Grambank, esperamos obtener el menor número de valores nulos.

1. Ordenamos las características de acuerdo a qué tantas lenguas cubren.
2. Después, seleccionamos de acuerdo a ese ordenamiento para obtener $n$ características.