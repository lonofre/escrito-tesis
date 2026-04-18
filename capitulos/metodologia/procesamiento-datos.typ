#import "@preview/lilaq:0.5.0" as lq

/*
  Esta es la introducción, debemos definir qué hicimos con las bases de datos lingüísticas. Más o menos como un TLDR para dar una idea.
*/
== Procesamiento computacional de las bases de datos lingüísticas

Con el objetivo de identificar similitudes y correlaciones con el espacio de BPE, se procesaron dos bases de datos lingüísticas: _World Atlas of Language Structures_ (WALS) y Grambank. Estas bases de datos contienen características tipológicas —morfológicas, sintácticas y fonológicas— de las lenguas analizadas, las cuales permiten corroborar posibles similitudes con las características morfológicas presentes en el espacio BPE. Sin embargo, ninguna de las dos bases de datos presenta una correspondencia uno a uno entre las lenguas que contienen, y no todas las características cuentan con un valor asignado. Por ello, fue necesario aplicar una serie de procesamientos previos antes de integrarlas al análisis junto con el espacio de BPE.

=== WALS

WALS @wals es una base de datos que contiene información sobre las propiedades fonológicas, gramaticales y léxicas de hasta 2,662 lenguas y dialectos. Dichas propiedades se encuentran organizadas en hasta 192 características por lengua.

Se utilizó un subconjunto de 15 características de WALS que codifican información de tipología morfológica @ximena-bpe-2023 (véase @wals-features). Dicho subconjunto presenta una cantidad reducida de valores vacíos para las lenguas analizadas.


// TODO: Quizá reducir el tamaño del texto de esto. O moverlo al apéndice
#figure(
  placement: auto,
    table(
    columns: (auto, auto),
    align: left,
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
    
  ),
  caption: [Tabla de rasgos de WALS usados por para describir tipología morfológica @ximena-bpe-2023]
)<wals-features>

Para identificar las lenguas en WALS se utilizó el _WALS code_, ya que el ISO 639-3 puede ser compartido por varias lenguas, lo que dificultaría su distinción. No obstante, el ISO 639-3 se empleó como apoyo para mejorar la identificación de las lenguas.

=== Grambank

Grambank @grambank es otra base de datos lingüística que registra hasta 195 características de 2,467 lenguas y dialectos en el mundo.

A pesar de las similitudes entre Grambank y WALS, las lenguas presentes en ambas bases de datos no presentan una correspondencia uno a uno. Si bien algunas lenguas pueden relacionarse por nombre, como el inglés, en otros casos la relación es más compleja: una lengua en WALS puede corresponder a múltiples entradas en Grambank, y viceversa. Esta complejidad se acentúa debido a que Grambank utiliza identificadores propios y no el ISO 639-3, lo que dificulta aún más establecer una correspondencia entre ambas bases de datos.

Por consiguiente, para relacionar las lenguas de Grambank con las de WALS, se establecieron tres criterios de selección, priorizando siempre las lenguas con más características disponibles en Grambank.

El primer criterio fue la coincidencia exacta de nombre, relacionando directamente las lenguas que compartían el mismo nombre en ambas bases de datos, como _Modern Greek_ para el griego. El segundo criterio aplicó cuando solo existía una lengua con nombre similar, considerándola como equivalente; por ejemplo, _Lango (Uganda)_ en Grambank correspondió a _Lango_ en WALS. Finalmente, si existían múltiples lenguas con nombre similar, se eligió la que contara con más características disponibles; por ejemplo, _Hausa States Fulfulde_ se seleccionó sobre _Hausa_ por contar con más características en Grambank.

// TODO: Agregar que la información se puede ver en el apéndice
Por último, cabe señalar que Grambank no cuenta con información de todas las lenguas de interés , como el español y el alemán, por lo que el conjunto de lenguas analizado se redujo en consecuencia.

=== Procesamiento

// Ajustar bien los indices de los espacios: X_grambank y X_wals
Procesamos de manera similar a Grambank y WALS. Estas bases de datos siguen los Cross-Linguistic Data Formats (CLDF) @cldf, que son un conjunto de estándares para estructurar, compartir y reutilizar datos lingüísticos. Así logramos obtener las características lingüísticas de las lenguas con el fin de tener una matriz $X_("Grambank") in RR^(n times m)$ y una matriz $X_("WALS") in RR^(n times m)$, a los cuales llamamos espacio de Grambank y espacio de WALS.

Así, la información de WALS y Grambank que nos interesó fue el nombre de las lenguas y el valor de cada una de sus características. CLDF presenta esta información como:

- _Lenguas_, que son los objetos de investigación.
- _Parámetros_, que son los conceptos comparativos medidos y comparados entre lenguas. Para nuestro estudio, nos referiremos a estos como las características.
- _Valores_, que son las mediciones concretas de un parámetro sobre una lengua.

Obtuvimos esta información de repositorios de Grambank y WALS para convertirlas en bases de datos SQLite. Logramos crear estas bases de datos relacionales usando `pycldf` @cldf sobre los datos de los repositorios. Si bien los mismos repositorios permitieron otras modalidades de acceder a los datos, mediante archivos `.csv` o llamadas a bibliotecas, usar bases de datos relacionales nos proporcionó la flexibilidad de hacer consultas mediante SQL. 

Así, las tablas relevantes que usamos fueron las que siguen el formato de CLDF:

- _LanguageTable_, que contiene información general de las lenguas, como el nombre de la lengua y su identificador único. Aquí, Grambank usa sus propios identificadores, mientras que WALS usa su identificador único también como un identificador ISO 639-3.
- _ParameterTable_, que contiene información de las características de las lenguas, como el nombre y el identificador, pero no el valor.
- _ValueTable_, que contiene información de los valores de las características para cada lengua. En Grambank y WALS, estos valores son numéricos. 

// TODO: Hacer un diagrama para ver cómo se relacionan las lenguas
Estas tablas  están relacionadas entre sí. `ValueTable` es la tabla que está relacionada con `LanguageTable` y `ParameterTable`. A continuación, un fragmento de la tabla `ValueTable` en Grambank.

#figure(
  table(
    stroke: none,
    align: left, 
    columns: (auto, auto, auto),
    table.header(
      [*cldf_languageReference*], [*cldf_parameterReference*], [*cldf_value*],
      table.hline(stroke: 1pt + black)
    ),
    [abad1241], [GB025], [1],
    [abad1241], [GB026], [0],
    [abad1241], [GB027], [0], 
    [abad1241], [GB028], [1],
    [abad1241], [GB030], [0],
  ),
  caption: [Fragmento de `ValueTable`]
)

// Quizá representar el vector en un espacio? Quizá también es ruido
Al procesar `ValueTable`, esta nos dio las representaciones vectoriales de las lenguas. Convertimos cada lengua en un vector usando los valores de sus características. Por ejemplo, el inglés con las características GB020, GB021, GB022 y GB023 de Grambank produce el vector $v = (1, 1, 1, 0)$.

En Grambank, juntamos los vectores de las lenguas para crear una matriz $X_("Grambank")$. Esta matriz es de dimensión $n times m$, donde $n$ es el número de lenguas y $m$ el número de características. Al procesar estos datos, encontramos que algunas lenguas no tienen valores para ciertas características. A veces la base de datos explica por qué, otras veces la entrada simplemente no existe en `ValueTable`. En estos casos, dejamos esos valores como nulos en la matriz.

// Checar lo del número de columnas
De manera similar, en WALS usamos las características proporcionadas en @wals-features. Por lo cual, la matriz $X_("WALS")$ tiene una dimensión de $n times n$, donde $n$ es el número de lenguas. Estas lenguas aún tenían algunos valores vacíos para sus características.

// TODO: !Importante
// A partir de este texto, hay un rango de mejora sobre como presentamos la información, 
// tanto como imputeamos los datos o cosas así. Esto es para otro borrador.
// Además, tenemos que hablar de cómo elegimos el conjunto de características de Grambank también, y forma parte de la metodología. Quizá aquí o en otra sección.
Sin embargo, los algoritmos que utilizamos necesitaban que los datos de la matriz no sean nulos. Para tratar estos casos de valores inexistentes, usamos la imputación de estos valores. Tuvimos considerar que hay varias formas de hacer este relleno de valores nulos:

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

// Datos obtenidos del notebook seleccion_por_disponibilidad.ipynb
#figure(
  {
    let features_availability = csv("datos/availability.csv", row-type: array).map(x => x.at(2)).slice(1).map(x => int(x))
    let languages = 38
    
    let accumulated = ()
    accumulated.push(languages  - features_availability.at(0))
    for n in range(1, features_availability.len()) {
      let sum = accumulated.at(n - 1) + languages - features_availability.at(n)
      accumulated.push(sum)
    }
    
    lq.diagram(
      ylabel: text(size: 11pt)[Valores faltantes],
      xlabel: text(size: 11pt)[Número de características],
      lq.plot(
        range(features_availability.len()),
        x => accumulated.at(x)
      ),
    
      width: 80%
    )
  },
  caption: [Número de valores faltantes al ir agregando más características.]
)<grambank-valores-vacios>

Para el espacio $X_("Grambank")$, seleccionamos las primeras 30 a 40 características. En este rango, las características no tienen demasiados valores faltantes como observamos en @grambank-valores-vacios. Si bien en rangos menos tenemos aún menos valores vacíos, procuramos trabajar con una mayor cobertura de características. A su vez, agregando al espacio más características incrementa exponencialmente el número de valores faltantes, lo cual puede tener un impacto negativo al realizar una imputación.
