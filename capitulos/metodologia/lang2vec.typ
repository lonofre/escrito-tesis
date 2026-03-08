/*
  Nos interesa introducir a lang2vec en esta historia.
*/
== lang2vec

// TODO: Hay que definir en algún lado lo de la sintaxis.
Otra conjunto de datos que utilizamos fue URIEL @littell2017uriel en su forma de `lang2vec` para obtener características sintácticas de las lenguas. Estos valores son una recopilación de otras bases lingüísticas, entre ellas WALS. Sin embargo, `lang2vec` tiene su propia representación para codificar a estas características.

Las características sintácticas que usamos provienen del conjunto `syntax wals` y de `syntax_knn`. El primer conjunto está basado en WALS, mientras que el segundo conjunto aplica una técnica de los $k$ vecinos más cercanos sobre la combinación de los datos de WALS, de _Syntactic Structures of the World's Languages_ (SSWL) y Ethnologue. 
Estos dos conjuntos cubren las lenguas de nuestro estudio, sin embargo, `syntax_wals` puede contener valores vacíos para algunas características mientras que `syntax_knn` no tiene ninguno.

Hay que recalcar que las características de `lang2vec` son binarias. Usualmente sus valores oscilan entre 0.0, que indica que un fenómeno está ausente o que no pertenece a una clase determinada, y 1.0, que indica que dicho fenómeno está presente o que sí pertenece a dicha clase @littell2017uriel. No obstante, `lang2vec` representa a los valores faltantes como `--`. A estos valores decidimos convertirlos en 0.0 para considerarlos como la ausencia, como en Grambank.