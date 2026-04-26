/*
  El objetivo fue buscar una relación entre los diferentes espacios.
*/
== Comparación entre los espacios

=== Índice Rand Ajustado

Se realizó el calculo del Índice Rand Ajustado (_Adjusted Rand Index_, ARI)@Hubert1985 para observar una relación entre los espacios. La relación mediante el ARI se da a ver en qué tan parecidos son los agrupamientos que se generan en un espacio con los de otro espacio.

De esta manera, si un espacio $A$ presenta un agrupamiento $[a,a,b,b,c,c]$ y un espacio $B$ presenta $[c,c,a,a,b,b]$, el ARI indicaría que ambos agrupamientos son idénticos:

$ "ARI"([a,a,b,b,c,c], [c,c,a,a,b,b]) = 1 $<ari-ejemplo>

// Valdría la pena expandir sobre valores negativos a 0? O sólo mencionarlo y ya?
Un valor de ARI igual a 1 indica agrupamientos idénticos, un valor cercano a 0 indica un agrupamiento aleatorio, y un valor negativo indica una concordancia menor a la esperada por azar.


#let ari_footnote = [Para los experimentos con ARI, se usó `adjusted_rand_score` de #link("https://scikit-learn.org/stable/modules/generated/sklearn.metrics.adjusted_rand_score.html")[scikit-learn.]]

// Tengo que citar a Hubert otra vez?
// La fórmula está en: Comparing Partitions - Hubert & Arabie
El calculo del ARI @Hubert1985 sigue la siguiente fórmula#footnote(ari_footnote):

$
"ARI" = 
frac(
  sum_(i j) binom(n_(i j), 2) - frac(lr([ sum_i binom(a_i, 2) sum_j binom(b_j, 2) ]), binom(n, 2), style: "horizontal"),
  frac(1, 2) lr([ sum_i binom(a_i, 2) + sum_j binom(b_j, 2) ]) - frac(lr([ sum_i binom(a_i, 2) sum_j binom(b_j, 2) ]), binom(n, 2), style: "horizontal")
)
$

donde:
- $n_(i j)$: elementos comunes entre cluster $i$ y cluster $j$.
- $a_i = sum_j n_(i j)$: tamaño del cluster $i$ en la partición $U$.
- $b_j = sum_i n_(i j)$: tamaño del cluster $j$ en la partición $V$.
- $n$: número total de elementos.

Como se observa en @ari-ejemplo, ARI es una medida simétrica, lo que proporciona libertad en la disposición de los clusters durante el cálculo y elimina la necesidad de considerar el orden de los agrupamientos al alimentar el algoritmo.

=== k-medias

Para generar los agrupamientos se utilizó K-medias (_K-means_) @k-means-lloyd, un algoritmo que agrupa datos en $k$ conjuntos asignando cada punto al centroide más cercano e iterando hasta que los grupos se estabilicen.

#let kmeans_footnote = [Se usó `Kmeans` de #link("https://scikit-learn.org/stable/modules/generated/sklearn.metrics.adjusted_rand_score.html")[scikit-learn.]]

// El código de esto es: KMeans(n_clusters=4, random_state=seed, n_init="auto")
El agrupamiento#footnote(kmeans_footnote) se realizó con 4 clústeres. Los centroides iniciales se seleccionaron mediante el método `k-means++` @kmeans-plusplus, que distribuye las semillas iniciales de forma probabilística para acelerar la convergencia y reducir la sensibilidad a la inicialización. Se fijó una semilla aleatoria para garantizar la reproducibilidad de los resultados.

// El código de esto es: seed1, seed2 in permutations(range(0, 100), 2):
Para mitigar la dependencia de una configuración particular, se evaluaron todas las permutaciones ordenadas de dos semillas tomadas del conjunto $\{0, 1, dots, 99\}$.

=== Experimentos

// Voy a poner los experimentos a alto nivel
// Mencionar la combinación de semillas que se usó
BPE v WALS y Grambank

BPE v Grambank

BPE v WALS

Grambank v lang2vec

