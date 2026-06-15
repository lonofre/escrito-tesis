= Metodología

Para que la pregunta planteada en la introducción tenga respuesta empírica, hace falta una forma común de comparar lenguas desde distintas perspectivas: la de BPE y la de cada base tipológica. La estrategia que sigue este capítulo es construir un espacio vectorial por cada fuente sobre el mismo conjunto de lenguas y comparar los agrupamientos que esos espacios inducen.

El capítulo se organiza en tres partes. La primera presenta las fuentes de datos —el corpus paralelo, WALS, Grambank y lang2vec— y las 47 lenguas seleccionadas. La segunda describe cómo se convierte cada fuente en un espacio vectorial estandarizado, y construye un espacio aleatorio adicional que servirá como línea base. La tercera define los cinco experimentos que comparan esos espacios mediante K-medias y el Índice Rand Ajustado.

#include "corpora.typ"
#include "procesamiento-datos.typ"
#include "comparacion.typ"

#pagebreak()