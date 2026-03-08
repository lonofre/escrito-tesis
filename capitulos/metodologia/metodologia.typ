= Metodología

// TODO: Agrega una pequeña introducción de todo lo que hice, o sea, de lo que está abajo.
Queremos hacer una relación entre los espacios dados por los vectores generados por BPE, los generados por el subconjunto de características de WALS y por las características de Grambank. Para ello, vamos a procesar estos datos dado un conjunto de lenguas para luego aplicar una serie de métricas que nos permitan relacionarlos.

#include "corpora.typ"
#include "procesamiento-datos.typ"
#include "lang2vec.typ"
#include "baseline.typ"
#include "comparacion.typ"

#pagebreak()