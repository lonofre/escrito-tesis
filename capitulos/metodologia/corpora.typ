#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

/*
  En esta sección, vamos a describir los datos que usamos en 
*/
== Corpus y datos

=== Lenguas

#figure(
   image("img/lenguas-mapa.pdf", width: 80%),
   caption: [Distribución de las 47 lenguas en el mundo.]
)<mapa-lenguas>

// TODO: Mencionar que la tabla de lenguas está en el apéndice
Para la experimentación se seleccionó un conjunto de 47 lenguas, no por disponibilidad de datos en línea sino por su diversidad tipológica y geográfica @ximena-bpe-2023. Esta diversidad abarca América, Europa, Asia, África y Oceanía (véase @mapa-lenguas). Todas las lenguas están disponibles en el Corpus Paralelo de la Biblia (PBC), WALS y lang2vec; Grambank cubre un subconjunto de 38 de ellas, por lo que los experimentos que involucran esta base se restringen a dicho subconjunto (véase @bases-datos-linguisticas). Los nombres completos se listan en @tabla-de-lenguas.

=== Corpus

El Corpus Paralelo de la Biblia (Parallel Bible Corpus, PBC) @mayer-cysouw-2014-creating fue utilizado para generar el espacio BPE, dado que reúne 994 traducciones distribuidas en 837 lenguas distintas según el estándar ISO 639-3, cobertura que incluye las 47 lenguas analizadas. Este corpus está normalizado en Unicode y tokenizado a nivel de palabra, propiedades que lo hacen adecuado para el procesamiento computacional (véase @ejemplo-PBC).

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

=== Bases de datos lingüísticas <bases-datos-linguisticas>

Además del PBC, se emplearon bases de datos lingüísticas que contienen características tipológicas ---morfológicas, sintácticas y fonológicas--- de las lenguas analizadas. Estas características permiten corroborar posibles similitudes con la información morfológica presente en el espacio de BPE. Para ello, se utilizaron el _World Atlas of Language Structures_ (WALS), Grambank y lang2vec.

Cabe señalar que ninguna de estas bases de datos presenta una correspondencia uno a uno entre sí, y no todas las características cuentan con un valor asignado.

==== WALS

#let database_footnote = [Se obtuvo los datos de WALS de #link("https://github.com/cldf-datasets/wals").]

De WALS, la información de interés fue el nombre de las lenguas y el valor de cada una de sus características#footnote(database_footnote). En concreto, se utilizó un subconjunto de 15 características que codifican información de tipología morfológica @ximena-bpe-2023 (véase @wals-features). Dicho subconjunto presenta una cantidad reducida de valores vacíos para las lenguas analizadas.

// TODO: Quizá reducir el tamaño del texto de esto. O moverlo al apéndice
#figure(
  placement: auto,
    table(
    columns: (auto, auto),
    align: left,
    stroke: none,
    table.header(
      [*Característica*], [*Nombre*],
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
  caption: [Características de WALS usadas para describir tipología morfológica. Tomado de @ximena-bpe-2023.]
)<wals-features>

Para identificar las lenguas en WALS se utilizó el _WALS code_, ya que el ISO 639-3 puede ser compartido por varias lenguas, lo que dificultaría su distinción. No obstante, el ISO 639-3 se empleó como apoyo para mejorar la identificación de las lenguas.

==== Grambank

#let grambank_footnote = [Se obtuvo los datos de Grambank de su repositorio público #link("https://github.com/grambank/grambank").]

A pesar de las similitudes entre Grambank y WALS, las lenguas presentes en ambas bases no presentan una correspondencia uno a uno#footnote(grambank_footnote). Grambank utiliza identificadores propios ---los Glottocodes, asignados por Glottolog a cada lengua o variedad lingüística @grambank-paper ---, mientras que WALS opera con _WALS codes_. No obstante, los metadatos de Glottolog incluyen el ISO 639-3 asociado a cada Glottocode, y WALS también registra el ISO de cada lengua; esto permite usar el ISO 639-3 como identificador puente entre ambas bases. El procedimiento operacional se detalla en la sección de procesamiento.

// TODO: Agregar que la información se puede ver en el apéndice
Cabe señalar, además, que Grambank no cuenta con información de todas las lenguas de interés, como el español y el alemán, por lo que el conjunto de lenguas analizado se redujo en consecuencia.

==== lang2vec

#let lang2vec_footnote = [El repositorio público se encuentra en #link("https://github.com/antonisa/lang2vec").]

lang2vec @littell2017uriel #footnote(lang2vec_footnote) es una biblioteca que proporciona representaciones vectoriales tipológicas de lenguas, integrando información de varias bases de datos lingüísticas (WALS, PHOIBLE, Ethnologue, Glottolog, entre otras). A partir de los códigos ISO 639-3 de un conjunto de lenguas, devuelve vectores cuyas características toman valores en el intervalo $[0, 1]$ y se agrupan en distintos conjuntos según el tipo de información (sintáctica, fonológica, entre otros).

En este estudio se emplearon los dos conjuntos sintácticos: `syntax_wals`, que extrae las características directamente de WALS, y `syntax_knn`, que aplica una técnica de $k$ vecinos más cercanos sobre la combinación de WALS, SSWL y Ethnologue para imputar valores faltantes. Ambos cubren las 47 lenguas del estudio; sin embargo, `syntax_wals` contiene valores vacíos para algunas características, mientras que `syntax_knn` no presenta valores vacíos gracias a la imputación.

Conviene aclarar que, en este estudio, coexisten dos vistas distintas sobre WALS: la matriz $X_"WALS"$, construida directamente con el subconjunto de 15 características de tipología morfológica descrito en la @wals-features, y la matriz $X_"lang2vec"$, basada en los conjuntos sintácticos `syntax_wals` y `syntax_knn`, ambos anclados en WALS pero centrados en tipología sintáctica. Las dos vistas son complementarias: cubren dimensiones tipológicas distintas ---morfológica frente a sintáctica--- sobre la misma fuente, sin solaparse en características.