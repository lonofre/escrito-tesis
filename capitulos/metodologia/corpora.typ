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

// TODO: Mencionar que la tabla de lenguas está en el apéndice
Para la experimentación se seleccionó un conjunto de 47 lenguas por su diversidad tipológica, genealógica y geográfica @ximena-bpe-2023. Esta diversidad abarca América, Europa, Asia, África y Oceanía (véase @mapa-lenguas). Todas las lenguas están disponibles en el Corpus Paralelo de la Biblia (PBC), WALS y lang2vec; Grambank cubre un subconjunto de 38 de ellas, por lo que los experimentos que involucran esta base se restringen a dicho subconjunto (véase @bases-datos-linguisticas). Los nombres completos se listan en @tabla-de-lenguas.

=== Corpus

*Ximena: Sugiero no hacer sobre uso de guiones largos, pues suele ser un indicador de uso de ChatGPT, también puedes ocupar recursos como los paréntesis y las comas. Y recuerda hacer una declaración de uso si estás usando una IA generativa para apoyarte en la redacción *

El Corpus Paralelo de la Biblia (_Parallel Bible Corpus_, PBC) @mayer-cysouw-2014-creating reúne 994 traducciones de la Biblia distribuidas en 837 lenguas distintas según el estándar ISO 639-3, cobertura que incluye las 47 lenguas analizadas. Cada traducción está alineada a nivel de versículo mediante identificadores estandarizados, normalizada en Unicode y tokenizada a nivel de palabra, propiedades que lo hacen adecuado para el procesamiento computacional (véase @ejemplo-PBC). Al tratarse de un corpus paralelo, todas las lenguas comparten esencialmente el mismo contenido textual; esto hace comparables los modelos BPE entre lenguas, pues las diferencias que el algoritmo capture son atribuibles a la estructura de cada lengua y no a diferencias de dominio o tema.

De este corpus se utilizaron las mismas traducciones —una por lengua— empleadas en el experimento original de #cite(<ximena-bpe-2023>, form: "prose"), lo que hace los resultados directamente comparables con los de aquel estudio.

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

Cabe señalar que ninguna de estas bases de datos presenta una correspondencia uno a uno entre sí, y no todas las características cuentan con un valor asignado. _#underline[Ximena: Correspondencia uno a uno en términos de qué? lenguas, características codificadas, etc?]_

==== WALS

_#underline[Ximena: Aumentar y mejorar la descripción de WALS. Tienes más contenido en Lang2Vec que no es tan relevante para la tesis como WALS]_

#let database_footnote = [Se obtuvo los datos de WALS de #link("https://github.com/cldf-datasets/wals").]

De WALS, la información de interés fue el nombre de las lenguas y el valor de cada una de sus características#footnote(database_footnote). En concreto, se utilizó un subconjunto de 15 características que codifican información de tipología morfológica @ximena-bpe-2023; este subconjunto presenta una cantidad reducida de valores vacíos para las lenguas analizadas y se enumera de forma completa en @wals-features.

Para identificar las lenguas en WALS se utilizó el _WALS code_, ya que el ISO 639-3 puede ser compartido por varias lenguas, lo que dificultaría su distinción. No obstante, el ISO 639-3 se empleó como apoyo para mejorar la identificación de las lenguas.

==== Grambank

#let grambank_footnote = [Se obtuvo los datos de Grambank de su repositorio público #link("https://github.com/grambank/grambank").]

A pesar de las similitudes entre Grambank y WALS, las lenguas presentes en ambas bases no presentan una correspondencia uno a uno#footnote(grambank_footnote). Grambank utiliza identificadores propios ---los Glottocodes, asignados por Glottolog a cada lengua o variedad lingüística @grambank-paper ---, mientras que WALS opera con _WALS codes_. No obstante, los metadatos de Glottolog incluyen el ISO 639-3 asociado a cada Glottocode, y WALS también registra el ISO de cada lengua; esto permite usar el ISO 639-3 como identificador puente entre ambas bases (véase @iso-puente). El procedimiento operacional se detalla en la sección de procesamiento.

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

Cabe señalar, además, que Grambank no cuenta con información de todas las lenguas de interés ---incluyendo el español y el alemán---, por lo que el conjunto de lenguas analizado se redujo en consecuencia; la cobertura por lengua se detalla en @tabla-de-lenguas. Las lenguas excluidas abarcan Europa, África, Oceanía y América, y pertenecen a familias lingüísticas distintas, por lo que la reducción no concentra el sesgo en una sola región ni en una sola familia.

==== lang2vec

#let lang2vec_footnote = [El repositorio público se encuentra en #link("https://github.com/antonisa/lang2vec").]

lang2vec @littell2017uriel #footnote(lang2vec_footnote) es una biblioteca que proporciona representaciones vectoriales tipológicas de lenguas, integrando información de varias bases de datos lingüísticas (WALS, PHOIBLE, Ethnologue, Glottolog, entre otras). A partir de los códigos ISO 639-3 de un conjunto de lenguas, devuelve vectores cuyas características toman valores en el intervalo $[0, 1]$ y se agrupan en distintos conjuntos según el tipo de información (sintáctica, fonológica, entre otros).

En este estudio se emplearon los dos conjuntos sintácticos: `syntax_wals`, que extrae las características directamente de WALS, y `syntax_knn`, que aplica una técnica de $k$ vecinos más cercanos sobre la combinación de WALS, SSWL y Ethnologue para imputar valores faltantes. Ambos cubren las 47 lenguas del estudio; sin embargo, `syntax_wals` contiene valores vacíos para algunas características, mientras que `syntax_knn` no presenta valores vacíos gracias a la imputación.

Conviene aclarar que, en este estudio, coexisten dos vistas distintas sobre WALS: la matriz $X_"WALS"$, construida directamente con el subconjunto de 15 características de tipología morfológica descrito en la @wals-features, y la matriz $X_"lang2vec"$, basada en los conjuntos sintácticos `syntax_wals` y `syntax_knn`, ambos anclados en WALS pero centrados en tipología sintáctica. Las dos vistas son complementarias: cubren la misma fuente con énfasis en dimensiones tipológicas distintas ---morfológica frente a sintáctica---.