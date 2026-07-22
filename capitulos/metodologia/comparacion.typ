/*
  El objetivo fue buscar una relación entre los diferentes espacios.
*/
== Comparación entre los espacios

Una vez construidos los espacios, el siguiente paso consistió en medir qué tan relacionados están entre sí. Nos interesaba saber si las lenguas se organizan de manera similar en el espacio BPE y en los espacios de características lingüísticas, es decir, si las lenguas vecinas a una lengua determinada en un espacio coinciden con sus vecinas en el otro. Esta coincidencia sería evidencia de que los vectores inducidos por BPE codifican información lingüística.

Para ello, creamos agrupamientos de las lenguas en cada espacio y medimos qué tan similares son esos agrupamientos entre sí. Esta similitud nos da un indicio de que las lenguas que se encuentran cercanas en un espacio también se encuentran cercanas en el otro. Además, trabajar con agrupamientos tiene la ventaja de que no es necesario preocuparnos por la dimensionalidad de cada espacio, la cual puede variar drásticamente entre BPE y las bases lingüísticas como WALS y Grambank, cuya dimensión es mayor.

#let kmeans_footnote = footnote[Usamos `KMeans` de #link("https://scikit-learn.org/stable/modules/generated/sklearn.cluster.KMeans.html")[scikit-learn].]
/*
A continuación una explicación y referencia para tenerlo aquí:
La función que usamos fue:  KMeans(n_clusters=n_clusters, random_state=seed, n_init="auto"). Como estamos usando scikit-learn 1.7.1, vamos a ver qué dice la documentación:
- Se usa kmeans++ por defecto. La documentación dice que usa greedy kmeans++
- random_state es usado para la inicialización del centroid
- n_init es la veces que el algoritmo se corre con diferentes centroides. Como usamos kmeans++, sólo se corre 1 vez

Ahora, respecto al número de semillas:
El código de esto es: seed1, seed2 in product(range(0, 100), repeat=2).
Esta función pertenece a itertools
*/
Para crear los agrupamientos en cada espacio, usamos el algoritmo de k-medias, que nos permitió controlar directamente el número de agrupamientos, a diferencia de otros algoritmos de agrupamiento. En particular, empleamos la variante k-medias++#kmeans_footnote, que ofrece una mejor inicialización de los centroides. En cuanto al número de agrupamientos, elegimos $k = 4$, que es un valor lo suficientemente grande para distinguir bien los agrupamientos (a diferencia de 2 o 3), pero no tan grande como para dificultar la interpretación de las relaciones entre ellos. Además, para no depender de una sola semilla en la inicialización de los centroides, utilizamos las semillas del conjunto ${0, 1, 2, dots, 99}$ en cada experimento, lo cual nos dio 100 agrupamientos distintos por espacio.

#let ari_footnote = footnote[Usamos `adjusted_rand_score` de #link("https://scikit-learn.org/stable/modules/generated/sklearn.metrics.adjusted_rand_score.html")[scikit-learn].]

Para medir qué tan parecidos son los agrupamientos entre espacios, utilizamos ARI#ari_footnote, que compara agrupamientos sin importar el orden de los grupos ni de sus elementos. Así, para cada par de espacios, comparamos los 100 agrupamientos de uno contra los 100 del otro, lo que produce $10,000$ valores de ARI por par de espacios.

En los experimentos que involucran a Grambank, el barrido generó un espacio distinto por cada valor de $d_G$, así que repetimos todo el procedimiento, los 100 agrupamientos y los 10,000 valores de ARI, para cada uno de esos espacios.

=== Experimentos

#let lenguas_grambank = 38

Realizamos cinco experimentos. El primero retoma la comparación entre $X_"BPE"$ y $X_W$ planteada por #cite(<ximena-bpe-2023>, form: "prose") (que evalúa si $X_"BPE"$ codifica información de morfología tipológica) y la aborda con la metodología descrita en este capítulo, estableciendo la línea base del trabajo. Los dos siguientes amplían el análisis incorporando Grambank: primero como base alternativa ($X_"BPE"$ vs $X_G$) y luego como complemento de WALS ($X_"BPE"$ vs $X_(W+G)$). Los dos últimos son experimentos auxiliares: comparan Grambank con WALS y con lang2vec para verificar qué tanto se parecen las bases lingüísticas entre sí, lo que da contexto a las comparaciones con BPE.

En los tres experimentos que involucran a $X_"BPE"$, calculamos en paralelo el ARI reemplazando $X_"BPE"$ por el espacio de referencia $X_0$ y manteniendo el resto de la configuración. Esto genera una distribución de referencia que permite distinguir si la similitud observada con $X_"BPE"$ está por encima de lo esperable por azar.

==== BPE vs WALS

Este experimento retoma la pregunta original (si $X_"BPE"$ codifica información de morfología tipológica) comparando $X_"BPE"$ con $X_W$. 

Utilizamos la configuración de lenguas y características establecida por #cite(<ximena-bpe-2023>, form: "prose"): el conjunto completo de $|L| = 47$ lenguas y las 15 características morfológicas de @wals-features. Esto produce una distribución de $10,000$ valores de ARI.


==== BPE vs Grambank
Este experimento evalúa la misma pregunta usando Grambank como base alternativa a WALS. 

Comparamos $X_"BPE"$ y $X_G in RR^(|L_G| times d_G)$, corriendo el experimento para cada valor de $d_G$ del barrido. Esto produce una distribución de $10,000$ valores de ARI por cada $d_G$ evaluado.

==== BPE vs WALS+Grambank
// TODO: Posteriormente, mencionar que en un apéndice se encuentra la tabla de las lenguas
Este experimento evalúa si combinar Grambank con WALS mejora la relación con $X_"BPE"$ frente a usarlas por separado. 

Construimos el espacio combinado $X_(W+G) = [X_W | X_G] in RR^(|L_G| times (d_W + d_G))$ por concatenación horizontal, con $|L_G| = #lenguas_grambank$ lenguas cubiertas por Grambank, $d_W = 15$ fijo (@wals-features) y $d_G$ variable a lo largo del barrido. Comparamos $X_"BPE"$ con $X_(W+G)$ para cada valor de $d_G$, produciendo una distribución de $10,000$ valores de ARI por cada $d_G$ evaluado.

==== Grambank vs WALS
Este experimento auxiliar verifica qué tan parecidos son entre sí $X_G$ y $X_W$, para situar los resultados de los tres experimentos anteriores. 

Comparamos $X_G in RR^(|L_G| times d_G)$ y $X_W$ restringido al mismo conjunto $L_G$ de lenguas, corriendo el experimento para cada valor de $d_G$ del barrido. Esto produce una distribución de $10,000$ valores de ARI por cada $d_G$ evaluado.

==== Grambank vs lang2vec

Este último experimento auxiliar extiende la comparación a otros recursos tipológicos, evaluando $X_G$ contra $X_"l2v"$, cuyas características son sintácticas. 

Comparamos $X_G in RR^(|L_G| times d_G)$ con $X_"l2v"$, corriendo el experimento para cada valor de $d_G$ del barrido. Esto produce una distribución de $10,000$ valores de ARI por cada $d_G$ evaluado.

