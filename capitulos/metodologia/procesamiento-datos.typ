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
Los vectores de las lenguas se agruparon en una matriz $X_("WALS") in RR^(n times m)$, donde $n$ es el número de lenguas y $m$ el número de características. Durante este procesamiento, se identificó que algunas lenguas carecen de valores para ciertas características. Dichos valores se dejaron como $0$ en la matriz. 

// TODO: Representar el espacio WALS usando PCA o algo parecido

// TODO: Agregar lo del StandarScaler también aquí.

=== Grambank

Grambank @grambank es otra base de datos lingüística que registra hasta 195 características de 2,467 lenguas y dialectos en el mundo.

A pesar de las similitudes entre Grambank y WALS, las lenguas presentes en ambas bases de datos no presentan una correspondencia uno a uno. Si bien algunas lenguas pueden relacionarse por nombre, como el inglés, en otros casos la relación es más compleja: una lengua en WALS puede corresponder a múltiples entradas en Grambank, y viceversa. Esta complejidad se acentúa debido a que Grambank utiliza identificadores propios y no el ISO 639-3, lo que dificulta aún más establecer una correspondencia entre ambas bases de datos.

Por consiguiente, para relacionar las lenguas de Grambank con las de WALS, se establecieron tres criterios de selección, priorizando siempre las lenguas con más características disponibles en Grambank.

El primer criterio fue la coincidencia exacta de nombre, relacionando directamente las lenguas que compartían el mismo nombre en ambas bases de datos, como _Modern Greek_ para el griego. El segundo criterio aplicó cuando solo existía una lengua con nombre similar, considerándola como equivalente; por ejemplo, _Lango (Uganda)_ en Grambank correspondió a _Lango_ en WALS. Finalmente, si existían múltiples lenguas con nombre similar, se eligió la que contara con más características disponibles; por ejemplo, _Hausa States Fulfulde_ se seleccionó sobre _Hausa_ por contar con más características en Grambank.

// TODO: Agregar que la información se puede ver en el apéndice
Cabe señalar que Grambank no cuenta con información de todas las lenguas de interés, como el español y el alemán, por lo que el conjunto de lenguas analizado se redujo en consecuencia.

#let grambank_footnote = [Se obtuvo los datos de Grambank de su repositorio público #link("https://github.com/grambank/grambank").]

La matriz $X_"Grambank"$ se construyó mediante el mismo método que $X_"WALS"$, leyendo los datos a través de CLDF#footnote(grambank_footnote). Cabe resaltar que, a diferencia de WALS, se utilizó el identificador propio de Grambank para identificar las lenguas.

Sin embargo, la selección de características de Grambank requirió una exploración previa, ya que no todas las lenguas cuentan con el mismo conjunto de características disponibles. Por ello, se priorizó la combinación de características que minimizara los valores vacíos, ordenándolas de mayor a menor según el número de lenguas que cubrían. Por ejemplo, GB107 cubre todas las lenguas y tendría alta prioridad, mientras que GB401 cubre pocas lenguas y se seleccionaría en los últimos lugares.

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

// Aquí continua explicando por qué se eligió cierto número de features
// También agrega qué lenguas tienen valores muy vacíos como limitaciones
//  Toma el top 5 (porque tampoco tenemos tantas lenguas) y haz el plot, también toma un promedio y haz el plot para graficar
Como se observa en @grambank-valores-vacios, a partir de las 80 características la tendencia de valores vacíos incrementa. Un análisis más detallado por lengua revela que algunas, como el barasano y el oromo, presentan una gran cantidad de valores vacíos, lo cual contribuye a este incremento.

// TODO: Agregar quizá una tabla de acuerdo al top 10 final.

No obstante, dado que la mayoría de las lenguas cuentan con un promedio aceptable de valores vacíos, no se descartó ninguna, con el fin de abarcar la mayor cantidad de lenguas posible.

// [TODO : Diagrama de media de valores perdidos y haciendo una comparación con los top 5 al menos]

Al igual que con WALS, los algoritmos requieren que la matriz de Grambank no contenga valores nulos, por lo que fue necesario imputar los valores faltantes. Para ello, se consideraron cuatro estrategias de imputación: reemplazar los valores nulos con $0$, asumiendo su ausencia; reemplazarlos con $-1$, modelando la ausencia como un valor desconocido; imputar la media del conjunto, basándose en los valores de las demás lenguas de la matriz; o imputar valores de lenguas cercanas, lo que proporcionaría una aproximación más informada, aunque esta opción se descartó por requerir conocimiento lingüístico especializado.

La decisión fue imputar con 0 los valores vacíos en $X_"Grambank"$, para intepretarlo como la ausencia de esta feature. Esta interpretación concuerda en la mayoría de las features de Grambank, que son binarias. 

// Pon que también se uso StandarScaler
Otra paso del procesamiento fue estandarizar y centrar los puntos que obtuvimos después de construir la matriz. Esto se logra con:

=== lang2vec

// TODO: Hay que ser específicos que se usó URIEL + los vectores aprendidos en el otro (también se cita)
// Por lo que correcto es decir que lang2vec es la herramienta adecuada en vez de sólo URIEL
// TODO: Otra cosa, agrega el por qué se usó las características sintácticas
Otro conjunto de datos utilizado fue URIEL @littell2017uriel, accedido mediante `lang2vec`, el cual recopila características sintácticas de las lenguas a partir de diversas bases lingüísticas, entre ellas WALS, aunque con una representación propia para codificarlas.

Las características sintácticas empleadas provienen de dos conjuntos: `syntax_wals`, basado directamente en WALS, y `syntax_knn`, que aplica una técnica de $k$ vecinos más cercanos sobre la combinación de WALS, _Syntactic Structures of the World's Languages_ (SSWL) y Ethnologue. Ambos conjuntos cubren las lenguas del estudio; sin embargo, `syntax_wals` puede contener valores vacíos para algunas características, mientras que `syntax_knn` no presenta ninguno.

// TODO: Considera acortar esto si lo ves necesario, porque en las otros tampoco entramos en detalle en cómo se ven las características. Sin embargo, mantén la decisión de por qué se imputó de una manera.
Las características de `lang2vec` son binarias: el valor 0.0 indica la ausencia de un fenómeno o que no pertenece a una clase determinada, mientras que 1.0 indica su presencia o pertenencia @littell2017uriel. Los valores faltantes, representados como `--`, se convirtieron en 0.0 para tratarlos como ausencia, de manera consistente con el criterio adoptado para Grambank.

// TODO: Agrega que se encontraron las lenguas usando el ISO code y que se encontró la mayoría de las lenguas con el ISO-CODE

// TODO: Agrega lo del StandarScaler también