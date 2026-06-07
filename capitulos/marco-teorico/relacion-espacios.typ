/* Explicación sobre el ARI
*/
== Medidas de similitud

Ese instrumento formal debe responder a una situación particular: dos espacios contienen los mismos objetos —en este caso, las mismas lenguas— pero los disponen de acuerdo a criterios distintos. Una vía para medir qué tan parecidas son esas dos disposiciones consiste en agrupar los objetos dentro de cada espacio y comparar las particiones resultantes: si dos espacios capturan estructura similar, sus agrupamientos deberían coincidir más allá de lo esperado por azar. Esta tesis sigue esa estrategia con dos herramientas concretas: K-medias para producir los agrupamientos y el Índice Rand Ajustado para compararlos.

=== Agrupamiento

El agrupamiento (_clustering_) es la tarea de dividir un conjunto de objetos en grupos —denominados clústeres— de modo que los objetos dentro de cada grupo resulten más parecidos entre sí que con los de otros grupos. Existen distintas familias de algoritmos para resolverla: jerárquicos, basados en densidad, basados en distribuciones, entre otros. Entre los algoritmos basados en centroides, K-medias es uno de los más extendidos y es el que utiliza esta tesis.

K-medias (_K-means_) @k-means-lloyd agrupa los datos en $k$ conjuntos asignando cada punto al centroide más cercano e iterando hasta que los grupos se estabilicen. La asignación depende de los centroides iniciales, lo que ha motivado estrategias de inicialización como `k-means++` @kmeans-plusplus, que distribuye las semillas iniciales de forma probabilística para acelerar la convergencia y reducir la sensibilidad a la inicialización.

=== Índice Rand

Una vez producidos los agrupamientos en cada espacio, el siguiente paso es compararlos. El Índice Rand (_Rand Index_, RI) @rand mide la similitud entre dos particiones del mismo conjunto contando, para cada par de objetos, si ambas particiones los colocan en el mismo grupo o en grupos distintos de forma consistente. La proporción de pares en los que ambas particiones coinciden define el valor del índice, que toma valores entre 0 (ningún acuerdo) y 1 (acuerdo completo).

Sin embargo, el Índice Rand presenta una limitación importante: dos particiones generadas al azar pueden alcanzar valores altos, ya que el índice no descuenta el grado de coincidencia esperado por azar @Hubert1985. Eso dificulta interpretar valores intermedios y motivó la formulación de una versión corregida: el Índice Rand Ajustado.

=== Índice Rand Ajustado

El Índice Rand Ajustado (_Adjusted Rand Index_, ARI) @Hubert1985 corrige esa limitación al descontar la coincidencia esperada por azar entre dos particiones. Así, mide qué tan parecidos son los agrupamientos generados en un espacio frente a los generados en otro, controlando por el componente aleatorio.

De esta manera, si un espacio $A$ presenta un agrupamiento $[a,a,b,b,c,c]$ y un espacio $B$ presenta $[c,c,a,a,b,b]$, el ARI indica que ambos agrupamientos son idénticos:

$ "ARI"([a,a,b,b,c,c], [c,c,a,a,b,b]) = 1 $<ari-ejemplo>

Un valor de ARI igual a 1 indica agrupamientos idénticos, un valor cercano a 0 indica un agrupamiento aleatorio, y un valor negativo indica una concordancia menor a la esperada por azar.

// La fórmula está en: Comparing Partitions - Hubert & Arabie
El ARI @Hubert1985 se define mediante la siguiente fórmula:

$
"ARI" =
frac(
  sum_(i j) binom(n_(i j), 2) - frac(lr([ sum_i binom(a_i, 2) sum_j binom(b_j, 2) ]), binom(n, 2), style: "horizontal"),
  frac(1, 2) lr([ sum_i binom(a_i, 2) + sum_j binom(b_j, 2) ]) - frac(lr([ sum_i binom(a_i, 2) sum_j binom(b_j, 2) ]), binom(n, 2), style: "horizontal")
)
$

donde:
- $n_(i j)$: elementos comunes entre el clúster $i$ y el clúster $j$.
- $a_i = sum_j n_(i j)$: tamaño del clúster $i$ en la partición $U$.
- $b_j = sum_i n_(i j)$: tamaño del clúster $j$ en la partición $V$.
- $n$: número total de elementos.

Como se observa en @ari-ejemplo, el ARI es una medida simétrica, lo que elimina la necesidad de considerar el orden de los agrupamientos al calcular el índice.

