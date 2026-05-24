#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

/*
   Esta sección es sobre cómo vamos a generar el espacio de BPE.
*/
== Corpus y datos

=== Lenguas

#figure(
   image("img/lenguas-mapa.pdf", width: 80%),
   caption: [Distribución de las 47 lenguas en el mundo.]
)<mapa-lenguas>

// TODO: Mencionar que la tabla de lenguas está en el apéndice
Para la experimentación, se realizó el uso de 47 lenguas. Estas están distribuidas alrededor de América, Europa, Asia, África e Oceanía (véase @mapa-lenguas). El nombre completo de las lenguas están en [placeholder del apéndice].

Este conjunto de lenguas fue seleccionado por estar diseñado para representar diversidad tipológica y geográfica, no simplemente por disponibilidad de datos en línea @ximena-bpe-2023. Estas lenguas están disponibles en el Corpus Paralelo de la Biblia (PBC), WALS, sólo una porción en Grambank y en lang2vec.

=== Corpus

En base a las lenguas seleccionadas, se utilizó el Corpus Paralelo de la Biblia (_Parallel Bible Corpus_, PBC) @mayer-cysouw-2014-creating para generar un espacio BPE.

PBC contiene datos de 994 traducciones de la Biblia. En especial, contiene las 47 lenguas que se están analizando.

Este es un ejemplo de corpus:

#quote[41001010	And straightway coming up out of the water , he saw the heavens opened , and the Spirit like a dove descending upon him :]

#quote[41001010	En cuanto Jesús salió del agua , vio que los cielos se abrían y que el Espíritu descendía sobre él como una paloma .]

Cabe destacar que este corpus está en normalizado Unicode. Además, está tokenizado a nivel palabra, separados por espacios en blanco.

=== Bases de datos lingüísticas <bases-datos-linguisticas>

Además del corpus textual, se emplearon bases de datos lingüísticas que contienen características tipológicas ---morfológicas, sintácticas y fonológicas--- de las lenguas analizadas. Estas características permiten corroborar posibles similitudes con la información morfológica presente en el espacio de BPE. Para ello, se utilizaron el _World Atlas of Language Structures_ (WALS), Grambank y lang2vec.

Tanto WALS como Grambank siguen los _Cross-Linguistic Data Formats_ (CLDF) @cldf, un conjunto de estándares para estructurar, compartir y reutilizar datos lingüísticos. Bajo este formato, la información se organiza en tres componentes: las _lenguas_, que son los objetos de investigación; los _parámetros_, que representan los conceptos comparativos medidos entre lenguas y que en este estudio se denominarán características; y los _valores_, que corresponden a la medición concreta de una característica para una lengua específica. Cabe señalar que ninguna de estas bases de datos presenta una correspondencia uno a uno entre las lenguas que contienen, y que no todas las características cuentan con un valor asignado.

==== WALS

#let database_footnote = [Se obtuvo los datos de WALS de su repositorio público #link("https://github.com/cldf-datasets/wals").]

De WALS, la información de interés fue el nombre de las lenguas y el valor de cada una de sus características#footnote(database_footnote). En concreto, se utilizó un subconjunto de 15 características que codifican información de tipología morfológica @ximena-bpe-2023 (véase @wals-features). Dicho subconjunto presenta una cantidad reducida de valores vacíos para las lenguas analizadas.

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

==== Grambank

#let grambank_footnote = [Se obtuvo los datos de Grambank de su repositorio público #link("https://github.com/grambank/grambank").]

A pesar de las similitudes entre Grambank y WALS, las lenguas presentes en ambas bases de datos no presentan una correspondencia uno a uno#footnote(grambank_footnote). Si bien algunas lenguas pueden relacionarse por nombre, como el inglés, en otros casos la relación es más compleja: una lengua en WALS puede corresponder a múltiples entradas en Grambank, y viceversa. Esta complejidad se acentúa debido a que Grambank utiliza identificadores propios y no el ISO 639-3, lo que dificulta aún más establecer una correspondencia entre ambas bases de datos.

// TODO: Agregar que la información se puede ver en el apéndice
Cabe señalar, además, que Grambank no cuenta con información de todas las lenguas de interés, como el español y el alemán, por lo que el conjunto de lenguas analizado se redujo en consecuencia.

==== lang2vec

#let lang2vec_footnote = [El repositorio público se encuentra en #link("https://github.com/antonisa/lang2vec").]

// Los knn se aplican sobre: WALS, _Syntactic Structures of the World's Languages_ (SSWL) y Ethnologue
// Sería bueno mencionar a todos? Sería buscar de nuevo la cita de SSWL y Ethnologue (aunque este es privado, de pago creo)
Las características sintácticas empleadas provienen de lang2vec#footnote(lang2vec_footnote), en concreto de dos conjuntos: `syntax_wals`, basado directamente en WALS, y `syntax_knn`, que aplica una técnica de $k$ vecinos más cercanos sobre la combinación de WALS y otras bases de datos. Ambos conjuntos cubren las lenguas del estudio; sin embargo, `syntax_wals` puede contener valores vacíos para algunas características, mientras que `syntax_knn` no presenta ningún valor vacío por las características aprendidas.

// TODO: Agregar referencia a tabla o al apéndice después
// TODO: Posiblemente expandir un poco más
En cuanto a la cobertura de lenguas, `lang2vec` incluye todas las descritas en (placeholder), identificándolas mediante sus códigos ISO.

