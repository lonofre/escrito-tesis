#import "@preview/lilaq:0.5.0" as lq

/*
  Esta es la introducción, debemos definir qué hicimos con las bases de datos lingüísticas. Más o menos como un TLDR para dar una idea.
*/
== Procesamiento computacional de las bases de datos lingüísticas

Con el objetivo de identificar similitudes y correlaciones con el espacio de BPE, se procesaron dos bases de datos lingüísticas: _World Atlas of Language Structures_ (WALS) y Grambank. Estas bases de datos contienen características tipológicas ---morfológicas, sintácticas y fonológicas--- de las lenguas analizadas, las cuales permiten corroborar posibles similitudes con las características morfológicas presentes en el espacio BPE. Sin embargo, ninguna de las dos bases de datos presenta una correspondencia uno a uno entre las lenguas que contienen, y no todas las características cuentan con un valor asignado. Por ello, fue necesario aplicar una serie de procesamientos previos antes de integrarlas al análisis junto con el espacio de BPE.

Dicho procesamiento fue posible dado que tanto Grambank como WALS siguen los _Cross-Linguistic Data Formats_ (CLDF) @cldf, un conjunto de estándares para estructurar, compartir y reutilizar datos lingüísticos. A partir de estas, se extrajeron las características lingüísticas de cada lengua, obteniendo una matriz $X_("Grambank") in RR^(n times m)$ y una matriz $X_("WALS") in RR^(n times m)$, denominadas espacio de Grambank y espacio de WALS, respectivamente.

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

#let database_footnote = [Se obtuvo los datos de WALS de su repositorio público #link("https://github.com/cldf-datasets/wals").]
#let processing_footnote = [A partir del repositorio de WALS, se construyó una base de datos relacional mediante `pycldf` @cldf. El uso de bases de datos relacionales, frente a otras modalidades disponibles como archivos `.csv` o llamadas a bibliotecas, proporcionó la flexibilidad necesaria para realizar consultas mediante SQL.]

De WALS, la información de interés fue el nombre de las lenguas y el valor de cada una de sus características#footnote(database_footnote). CLDF organiza esta información en tres componentes: las _lenguas_, que son los objetos de investigación; los _parámetros_, que representan los conceptos comparativos medidos entre lenguas y que en este estudio se denominarán características; y los _valores_, que corresponden a la medición concreta de una característica para una lengua específica.

A partir de la base de datos de WALS#footnote(processing_footnote), se procesó `ValueTable`, que contiene los valores de las características para cada lengua, para construir las representaciones vectoriales de las lenguas, convirtiendo cada una en un vector a partir de dichos valores. Por ejemplo, el inglés con las características de @wals-features produce el vector $v = (1, 2, 2, 2, 2, 2, 1, 2, 1, 2, 2, 5, 1, 2, 2)$.

// Además, podemos agregar que en el experimento original el imputer fue 0
Los vectores de las lenguas se agruparon en una matriz $X_("WALS") in RR^(n times m)$, donde $n$ es el número de lenguas y $m$ el número de características. Durante este procesamiento, se identificó que algunas lenguas carecen de valores para ciertas características, ya sea porque la base de datos lo indica explícitamente o porque la entrada simplemente no existe en `ValueTable`. En ambos casos, dichos valores se dejaron como $0$ en la matriz. 

// TODO: Representar el espacio WALS usando PCA o algo parecido

=== Grambank

Grambank @grambank es otra base de datos lingüística que registra hasta 195 características de 2,467 lenguas y dialectos en el mundo.

A pesar de las similitudes entre Grambank y WALS, las lenguas presentes en ambas bases de datos no presentan una correspondencia uno a uno. Si bien algunas lenguas pueden relacionarse por nombre, como el inglés, en otros casos la relación es más compleja: una lengua en WALS puede corresponder a múltiples entradas en Grambank, y viceversa. Esta complejidad se acentúa debido a que Grambank utiliza identificadores propios y no el ISO 639-3, lo que dificulta aún más establecer una correspondencia entre ambas bases de datos.

Por consiguiente, para relacionar las lenguas de Grambank con las de WALS, se establecieron tres criterios de selección, priorizando siempre las lenguas con más características disponibles en Grambank.

El primer criterio fue la coincidencia exacta de nombre, relacionando directamente las lenguas que compartían el mismo nombre en ambas bases de datos, como _Modern Greek_ para el griego. El segundo criterio aplicó cuando solo existía una lengua con nombre similar, considerándola como equivalente; por ejemplo, _Lango (Uganda)_ en Grambank correspondió a _Lango_ en WALS. Finalmente, si existían múltiples lenguas con nombre similar, se eligió la que contara con más características disponibles; por ejemplo, _Hausa States Fulfulde_ se seleccionó sobre _Hausa_ por contar con más características en Grambank.

// TODO: Agregar que la información se puede ver en el apéndice
Por último, cabe señalar que Grambank no cuenta con información de todas las lenguas de interés , como el español y el alemán, por lo que el conjunto de lenguas analizado se redujo en consecuencia.

=== Procesamiento

/*
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
*/


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
