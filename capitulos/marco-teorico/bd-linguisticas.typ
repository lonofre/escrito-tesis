/* Explicación más a fondo de qué son estas bases de datos lingüísticas para que tengan mejor entendimiento en la metodología
*/

/*
== Bases de datos lingüísticas

La primera de esas piezas son las bases de datos tipológicas: repositorios construidos por lingüistas que registran, para cientos o miles de lenguas, los valores que cada una toma en un conjunto definido de rasgos estructurales. Esos rasgos describen la estructura de cada lengua de forma independiente al algoritmo de tokenización, lo cual los vuelve una referencia adecuada para contrastar con el espacio de BPE. De entre los recursos disponibles, esta tesis utiliza tres: WALS, Grambank y lang2vec.

=== WALS

WALS @wals es una base de datos que contiene información sobre las propiedades fonológicas, gramaticales y léxicas de hasta 2,662 lenguas y dialectos. Dichas propiedades se encuentran organizadas en hasta 192 características por lengua.

Las características de WALS toman un valor entero positivo y no tienen la misma distribución entre todas estas características. Esto implica que cada valor contiene un significado diferente que varía de acuerdo a cada característica. Por ejemplo, la característica 20A puede tomar 7 valores, 28A puede tomar hasta 4 y 49A hasta 9 valores diferentes.

// TODO: Poner ejemplos de WALS

=== Grambank

Grambank @grambank es otra base de datos lingüística que registra hasta 195 características de 2,467 lenguas y dialectos en el mundo.

Las características de Grambank en su mayoría son binarias. Así, toman los valores de 0 y 1 (0/no, 1/sí), algo que contrasta con el rango de valores que toman las características de WALS. De acuerdo a #cite(<haynie-etal-2023-grambanks>, form: "prose"), el uso de características binarias permitió evitar ambigüedades en la categorización de las características y permitió registrar los rasgos en términos de presencia o ausencia, en vez de categorizar sólo la más dominante. Sin embargo, no todas las características tienen asignado un valor en algunas lenguas, por lo cual toman un valor de desconocido (?/desconocido). Por ejemplo, considérese la característica GB020:

#align(center, box(width: 80%)[
  #set text(size: 11pt)
  #set align(left)
  1. Codifique con 1 si existe un morfema que pueda marcar definitud o especificidad sin transmitir también un significado deíctico espacial.

  2. Codifique con 0 si la fuente no menciona un artículo definido y no es posible encontrar uno en los ejemplos o textos de una gramática que, por lo demás, es exhaustiva.

  3. Codifique con ? si la gramática no contiene suficiente análisis para determinar si existe o no un artículo definido.

  4. Si ha codificado 1 para GB020 y 0 para GB021 y GB022, por favor escriba un comentario explicando la posición del artículo definido o específico.
])

=== Lang2vec

// Según el repositorio, cita:
// lang2vec -> URIEL papers
// + los vectores aprendidos -> Malayiva
Otro conjunto de datos utilizados es `lang2vec`, que entre sus datos recopila características sintácticas de las lenguas. Estas características vienen de URIEL @littell2017uriel y de características aprendidas @malaviya17emnlp que llenan los valores faltantes. Por lo cual, `lang2vec` proporciona otro punto de comparación en contraste a las características morfológicas.

Con estas tres bases, cada lengua queda representada como un vector en un espacio definido por lingüistas. Si BPE codifica información lingüística, su espacio debería organizar a las lenguas de manera similar a como lo hace alguno de estos espacios tipológicos. Comparar dos organizaciones del mismo conjunto de lenguas, sin embargo, requiere un instrumento formal: el que presenta la siguiente sección.
*/