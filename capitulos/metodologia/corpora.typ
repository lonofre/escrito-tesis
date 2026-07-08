#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

/*
  En esta sección, vamos a describir los datos que usamos en 
*/
== Corpus y datos



=== Lenguas

#figure(
   image("img/lenguas-mapa.pdf", width: 80%),
   caption: [Distribución de las 47 lenguas en el mundo. Cada color representa una familia de lenguas distinta.]
)<mapa-lenguas>

Para la experimentación utilizamos un conjunto de 47 lenguas (véase @tabla-de-lenguas) que destaca por su diversidad tipológica, genealógica y geográfica @ximena-bpe-2023. Esto permitió que los resultados no estuvieran sesgados por pocas regiones o pocas familias lingüísticas (véase @mapa-lenguas). Para identificar a las lenguas, usamos el conjunto de códigos ISO 639-3 @iso6393.

Las 47 lenguas están disponibles en el Corpus Paralelo de la Biblia (PBC), y en las bases de datos WALS y lang2vec; mientras que en Grambank sólo están disponibles 40 de estas lenguas. Estas lenguas faltantes se encuentran en diferentes regiones, lo cual no representa un sesgo a las 40 faltantes. 

// TODO: Mejorar redacción y mejorar la justificación de esto
No obstante, cuando trabajamos con Grambank sólo usamos 38 lenguas. Quisimos también experimentar qué pasaría si quitamos las lenguas de coreano y birmano. Por tal motivo, los experimentos que llevaron Grambank se usaron un total de 38 lenguas (40 menos el coreano y birmano).


=== Corpus

Para obtener una caracterización de las 47 lenguas mediante PBE, usamos el Corpus Paralelo de la Biblia (_Parallel Bible Corpus_, PBC) @mayer-cysouw-2014-creating. Este corpus sirvió como entrada a BPE y así generar los modelos que permiten caracterizar a las lenguas.

El PBC reúne 994 traducciones de la Biblia distribuidas en 837 lenguas distintas según el estándar ISO 639-3, cobertura que incluye las 47 lenguas analizadas. Cada traducción está alineada a nivel de versículo mediante identificadores estandarizados, normalizada en Unicode y tokenizada a nivel de palabra, propiedades que lo hacen adecuado para el procesamiento computacional (véase @ejemplo-PBC). Al tratarse de un corpus paralelo, todas las lenguas comparten esencialmente el mismo contenido textual; esto hace comparables los modelos BPE entre lenguas, pues las diferencias que el algoritmo capture son atribuibles a la estructura de cada lengua y no a diferencias de dominio o tema.

De este corpus utilizamos las mismas traducciones, una por lengua, empleadas en el experimento original de #cite(<ximena-bpe-2023>, form: "prose"), lo que hace los resultados directamente comparables con los de aquel estudio.

#figure(
  table(
    columns: (1fr, 1fr),
    stroke: none,
    inset: (x: 8pt, y: 6pt),
    align: (left, left),
    table.hline(stroke: 0.5pt),
    [*EN*], [*ES*],
    table.hline(stroke: 0.3pt),
    [And straightway coming up out of the water , he saw the heavens opened , and the Spirit like a dove descending upon him :],
    [En cuanto Jesús salió del agua , vio que los cielos se abrían y que el Espíritu descendía sobre él como una paloma .],
    table.hline(stroke: 0.5pt),
  ),
  caption: [PBC Inglés-Español],
) <ejemplo-PBC>

Es importante subrayar que se usó únicamente el PBC porque es el corpus paralelo que abarca la mayor cantidad de lenguas. #cite(<ximena-bpe-2023>, form: "prose") usaron otros corpus de apoyo como La Declaración Universal de los Derechos Humanos (DUDH) y el JW300 @agic-vulic-2019-jw300. Sin embargo, la DUDH cubre sólo 25 lenguas de las 47, mientras que el JW300 cubre 31 usando el umbral que establecieron de 68 artículos paralelos por lengua.

=== Bases de datos lingüísticas <bases-datos-linguisticas>

Además del PBC, empleamos bases de datos lingüísticas que contienen características tipológicas (morfológicas, sintácticas y fonológicas) de las lenguas analizadas. Estas características permiten corroborar posibles similitudes con la información morfológica presente en el espacio de BPE. Para ello, utilizamos el _World Atlas of Language Structures_ (WALS) y Grambank como las bases de datos principales; y lang2vec como soporte.

==== WALS

_#underline[Ximena: Aumentar y mejorar la descripción de WALS. Tienes más contenido en Lang2Vec que no es tan relevante para la tesis como WALS]_

#let database_footnote = [Los datos de WALS están disponibles en #link("https://github.com/cldf-datasets/wals").]

Usamos WALS #footnote(database_footnote) para tener una base con el experimento de #cite(<ximena-bpe-2023>, form: "prose"), lo cual permitió tener una comparación con los experimentos que involucraron WALS (con características de tipología morfológica) con los de otras bases que tienen otros tipos de características.

WALS @wals es una base de datos que contiene información sobre las propiedades fonológicas, gramaticales y léxicas de hasta 2,662 lenguas y dialectos. WALS está organizado en 144 capítulos donde cada uno representa una característica lingüística. No obstante, de WALS solo utilizamos un subconjunto de 15 características porque codifican información de tipología morfológica @ximena-bpe-2023. A su vez, este subconjunto presenta una cantidad reducida de valores vacíos para las lenguas analizadas y se enumera de forma completa en @wals-features.

Las características de WALS toman un valor entero positivo y no tienen la misma distribución, o sea el mismo rango de valores, entre todas estas características. Esto implica que cada valor contiene un significado diferente que varía de acuerdo a cada característica. Por ejemplo, la característica 20A puede tomar 7 valores (véase @ejemplo-feature-wals), 28A puede tomar hasta 4 y 49A hasta 9 valores diferentes.

#figure(
  table(
    columns: 2,
    align: (left, center),
    table.header(
      [*Nombre*], [*Valor*],
    ),
    [Exclusivamente concatenativo], [1],
    [Exclusivamente aislante], [2],
    [Exclusivamente tonal], [3],
    [Tonal/aislante], [4],
    [Tonal/concatenativo], [5],
    [Ablaut/concatenativo], [6],
    [Aislante/concatenativo], [7],
  ),
  caption: [Valores de la característica 20A en WALS.],
)<ejemplo-feature-wals>

Además del ISO 639-3, usamos el código WALS para identificar las lenguas, ya que varios códigos WALS pueden compartir un mismo código ISO 639-3 (como ocurre con algunos dialectos del alemán). Por eso, para cada código ISO 639-3, elegimos un solo código WALS y así trabajamos con una sola lengua por código.

==== Grambank

#let grambank_footnote = [Los datos de Grambank están disponibles en #link("https://github.com/grambank/grambank").]

Grambank#footnote(grambank_footnote) @grambank es otra base de datos lingüística que registra hasta 195 características de 2,467 lenguas y dialectos en el mundo. Grambank es más reciente que WALS (publicado en línea en 2008) y, en promedio, codifica cada lengua con más características que WALS @haynie-etal-2023-grambanks (145 en comparación con 30). Esto hace de Grambank una base atractiva para analizar diversas combinaciones de características.

Las características de Grambank en su mayoría son binarias. Así, toman los valores de 0 y 1 (0/no, 1/sí), algo que contrasta con el rango de valores que toman las características de WALS. De acuerdo a #cite(<haynie-etal-2023-grambanks>, form: "prose"), el uso de características binarias permitió evitar ambigüedades en la categorización de las características y permitió registrar los rasgos en términos de presencia o ausencia, en vez de categorizar sólo la más dominante. Sin embargo, no todas las características tienen asignado un valor en algunas lenguas, por lo cual toman un valor de desconocido (?/desconocido). Por ejemplo, considérese la característica GB020:

#align(center, box(width: 80%)[
  #set text(size: 11pt)
  #set align(left)
  1. Codifique con 1 si existe un morfema que pueda marcar definitud o especificidad sin transmitir también un significado deíctico espacial.

  2. Codifique con 0 si la fuente no menciona un artículo definido y no es posible encontrar uno en los ejemplos o textos de una gramática que, por lo demás, es exhaustiva.

  3. Codifique con ? si la gramática no contiene suficiente análisis para determinar si existe o no un artículo definido.

  4. Si ha codificado 1 para GB020 y 0 para GB021 y GB022, por favor escriba un comentario explicando la posición del artículo definido o específico.
])

Otra diferencia con WALS es que las lenguas presentes en ambas bases no presentan una correspondencia uno a uno. Grambank utiliza identificadores propios (los Glottocodes, asignados por Glottolog a cada lengua o variedad lingüística @grambank-paper), mientras que WALS opera con códigos WALS. No obstante, los metadatos de Glottolog incluyen el ISO 639-3 asociado a cada Glottocode, y WALS también registra el ISO de cada lengua; esto nos permitió usar el ISO 639-3 como identificador puente entre ambas bases (véase @iso-puente). El procedimiento operacional se detalla en la sección de procesamiento.

#figure(
  diagram(
    spacing: (20mm, 10mm),
    node-stroke: 0.5pt,
    node-corner-radius: 3pt,

    node((0,0), [WALS], name: <wals>),
    node((1,0), [ISO 639-3], name: <iso>,
      stroke: 1pt,
      inset: 8pt,
    ),
    node((2,0), [Grambank], name: <gram>),

    edge(<wals>, <iso>, "<->"),
    edge(<iso>, <gram>, "<->"),
  ),
  caption: [ISO 639-3 como identificador puente entre los \ códigos propios de WALS y Grambank.],
)<iso-puente>

/*
Pienso que esto está repetido arriba en la sección de lenguas

Cabe señalar, además, que Grambank no cuenta con información de todas las lenguas de interés, incluyendo el español y el alemán, por lo que el conjunto de lenguas analizado se redujo en consecuencia; la cobertura por lengua se detalla en @tabla-de-lenguas. Las lenguas excluidas abarcan Europa, África, Oceanía y América, y pertenecen a familias lingüísticas distintas, por lo que la reducción no concentra el sesgo en una sola región ni en una sola familia.*/


// TODO: Reevaluar lang2vec para ver si solo reportamos un conjunto de características en el texto principal y mandar otro conjunto al apéndice.
==== lang2vec

#let lang2vec_footnote = [El repositorio público se encuentra en #link("https://github.com/antonisa/lang2vec").]

lang2vec @littell2017uriel #footnote(lang2vec_footnote) es una biblioteca que proporciona representaciones vectoriales tipológicas de lenguas, integrando información de varias bases de datos lingüísticas (WALS, PHOIBLE, Ethnologue, Glottolog, entre otras). Usamos lang2vec por sus conjuntos de características sintácticas.

En este estudio se emplearon los dos conjuntos sintácticos: `syntax_wals`, que extrae las características directamente de WALS, y `syntax_knn`, que aplica una técnica de $k$ vecinos más cercanos sobre la combinación de WALS, SSWL y Ethnologue para imputar valores faltantes. Ambos cubren las 47 lenguas del estudio; sin embargo, `syntax_wals` contiene valores vacíos para algunas características, mientras que `syntax_knn` no presenta valores vacíos gracias a la imputación.

Conviene aclarar que, en este estudio, coexisten dos vistas distintas sobre WALS: la matriz $X_W$, construida directamente con el subconjunto de 15 características de tipología morfológica descrito en la @wals-features, y la matriz de lang2vec $X_"l2v"$, basada en los conjuntos sintácticos `syntax_wals` y `syntax_knn`, ambos anclados en WALS pero centrados en tipología sintáctica. Las dos vistas son complementarias: cubren la misma fuente con énfasis en dimensiones tipológicas distintas, morfológica frente a sintáctica.

Por último, en contraste a Grambank, lang2vec usa el iSO 639-3 para la identificación de lenguas. Por ende, se usó la misma relación con los Glottocodes para relacionar a lang2vec con Grambank.