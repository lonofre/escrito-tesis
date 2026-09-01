= Metodología

Nuestra hipótesis dice que, si las lenguas se agrupan de forma parecida en el espacio de BPE y en los espacios construidos a partir de las bases de datos lingüísticas, entonces BPE captura parte de la estructura que describen los lingüistas. Para ponerla a prueba, representamos cada fuente de la misma manera: como un espacio donde representamos a las lenguas mediante características, sin importar si esas características vienen de contar subpalabras o de la descripciones realizadas por lingüistas. Sobre esos espacios agrupamos a las lenguas y medimos qué tanto coinciden los agrupamientos.

#let footnote_repo = [
  El código y los datos de los experimentos se encuentran en en
  #link("https://github.com/lonofre/bpe-comparacion").
]

El capítulo se divide en tres partes. Primero describimos de dónde vienen los datos: el corpus paralelo con el que generamos los modelos de BPE y las bases de datos lingüísticas (WALS, Grambank y lang2vec) de donde tomamos las características descritas por especialistas. Después explicamos cómo convertimos cada fuente en un espacio, pues cada base cubre un conjunto distinto de lenguas y codifica sus características de forma distinta. Al final planteamos cómo medimos el parecido entre los espacios y qué experimentos hicimos con ellos.#footnote(footnote_repo)

Para sostener la hipótesis, esa coincidencia debe cumplir tres condiciones, y cada una determinó una decisión de esta metodología. La primera es que esté por encima del azar, por lo que construimos un espacio aleatorio de referencia y comparamos siempre contra él. La segunda es que no dependa de la base de datos, por lo que repetimos la comparación con WALS, con Grambank y con ambas juntas. La tercera es que no dependa de la inicialización del agrupamiento, por lo que usamos cien semillas en lugar de una. A esto se suma la última pregunta de investigación, sobre qué características lingüísticas contribuyen más a la coincidencia, que abordamos desglosando la comparación característica por característica.

#include "corpora.typ"
#include "procesamiento-datos.typ"
#include "comparacion.typ"

#pagebreak()