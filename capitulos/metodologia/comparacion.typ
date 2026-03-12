/*
  El objetivo fue buscar una relación entre los diferentes espacios.
*/
== Comparación

Uno de los enfoque que utilizamos para comparar ambos espacios fue el índice Rand ajustado (_Adjusted Rand Index_, ARI) @Hubert1985. Este índice mide la similitud entre dos agrupamientos. Así, nuestro objetivo fue crear agrupamientos entre dos distintos espacios para ver qué tan similares son estos grupos. 

ARI encuentra esta similitud mediante la siguiente fórmula:

// Mejorar esta fórmula y verificar si viene así del paper
$
"ARI" = 
frac(
  sum_(i j) binom(n_(i j), 2) - frac(lr([ sum_i binom(a_i, 2) sum_j binom(b_j, 2) ]), binom(n, 2), style: "horizontal"),
  frac(1, 2) lr([ sum_i binom(a_i, 2) + sum_j binom(b_j, 2) ]) - frac(lr([ sum_i binom(a_i, 2) sum_j binom(b_j, 2) ]), binom(n, 2), style: "horizontal")
)
$

donde:
- $n_(i j)$: elementos comunes entre cluster $i$ y cluster $j$
- $a_i = sum_j n_(i j)$: tamaño del cluster $i$ en la partición $U$
- $b_j = sum_i n_(i j)$: tamaño del cluster $j$ en la partición $V$
- $n$: número total de elementos

ARI toma valores entre -1 y 1. El 1 sugiere un acuerdo perfecto, el 0 uno equivalente al azar y menor a 0 pero que el azar. Una de sus ventajas es que una medida simétrica.

// Buscar quién público k-means
Para generar los agrupamientos usamos K-medias (K-means). Este es un algoritmo de agrupamiento que agrupa datos en k grupos, asignando cada punto al centroide más cercano e iterando hasta que los grupos se estabilicen.

// Aquí quizá abordar más el setup de scikit learn
Usamos una configuración especial en K-means.

// Y aquí hablar más de la configuración de estas pruebas con las semillas
Además, hicimos la exploración sobre una permutación de semillas para obtener mejores resultados y no depender de una sola configuración.

