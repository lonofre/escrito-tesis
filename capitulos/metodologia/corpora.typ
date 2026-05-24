#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

/*
   Esta sección es sobre cómo vamos a generar el espacio de BPE.
*/
// Lo cambiaría a generación del espacio de BPE????
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

=== Bases de datos lingüísticas

