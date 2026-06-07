/*
  El objetivo fue buscar una relación entre los diferentes espacios.
*/
== Comparación entre los espacios

Siguiendo la convención establecida en la sección anterior, los experimentos que involucran Grambank operan sobre el subconjunto de $L_G = 38$ lenguas, mientras que los demás utilizan las $L = 47$ lenguas completas. En los experimentos que usan Grambank, $d_"Grambank"$ no se fija: se barre sobre el conjunto $D = {30, 31, dots, 80}$, donde el límite superior corresponde al umbral identificado en @grambank-valores-vacios, a partir del cual los valores faltantes crecen rápidamente.

// El código de esto es: seed1, seed2 in permutations(range(0, 100), 2):
Para calcular la similitud entre un espacio $X$ y un espacio $Y$, se utilizó el ARI#footnote[Se usó `adjusted_rand_score` de #link("https://scikit-learn.org/stable/modules/generated/sklearn.metrics.adjusted_rand_score.html")[scikit-learn].] sobre los agrupamientos de cada espacio, obtenidos mediante k-medias++#footnote[Se usó `KMeans` de #link("https://scikit-learn.org/stable/modules/generated/sklearn.cluster.KMeans.html")[scikit-learn].] con $k = 4$, siguiendo el experimento original de #cite(<ximena-bpe-2023>, form: "prose"). Con un $k$ menor el agrupamiento resultaría trivial. Este algoritmo depende de una semilla de inicialización, por lo que los resultados pueden variar entre ejecuciones. Para dar cuenta de esta variabilidad, se evaluaron todos los pares ordenados $(s_1, s_2)$ con $s_1 != s_2$ tomados de ${0, 1, dots, 99}$, lo que generó un total de $9,900$ valores de ARI para cada par de espacios $X, Y$. Se eligieron pares ordenados ---y no combinaciones--- porque $s_1$ inicializa el agrupamiento de $X$ y $s_2$ el de $Y$ de forma independiente, por lo que invertir el par produce agrupamientos distintos y, en consecuencia, otro valor de ARI.

En todos los experimentos que involucran $X_"BPE"$, se calculó en paralelo el ARI reemplazando $X_"BPE"$ por $X_0$, manteniendo el resto de la configuración del experimento. Esto produce una distribución de referencia que permite distinguir si la similitud observada con $X_"BPE"$ está por encima de lo esperable por azar.

=== Experimentos

#let lenguas_grambank = 38

Se realizaron cinco experimentos. El primero retoma la comparación entre $X_"BPE"$ y $X_"WALS"$ planteada por #cite(<ximena-bpe-2023>, form: "prose") ---que evalúa si $X_"BPE"$ codifica información de morfología tipológica--- y la aborda con la metodología descrita en este capítulo, estableciendo la línea base del trabajo. Los dos siguientes amplían el análisis incorporando Grambank: primero como base alternativa ($X_"BPE"$ vs $X_"Grambank"$) y luego como complemento de WALS ($X_"BPE"$ vs $X_("WALS"+"Grambank")$). Los dos últimos son experimentos auxiliares: comparan Grambank con WALS y con lang2vec para verificar qué tanto se parecen las bases lingüísticas entre sí, lo que da contexto a las comparaciones con BPE.

==== BPE vs WALS

Este experimento retoma la pregunta original ---si $X_"BPE"$ codifica información de morfología tipológica--- comparando $X_"BPE"$ con $X_"WALS"$. Se utilizó la configuración de lenguas y características establecida por #cite(<ximena-bpe-2023>, form: "prose"): el conjunto completo de $L = 47$ lenguas y las 15 características morfológicas de @wals-features. Esto produce una distribución de $9,900$ valores de ARI.

==== BPE vs Grambank
Este experimento evalúa la misma pregunta usando Grambank como base alternativa a WALS. Se compararon $X_"BPE"$ y $X_"Grambank" in RR^(L_G times d_"Grambank")$, corriendo el experimento para cada valor de $d_"Grambank"$ en el conjunto $D$. Esto produce una distribución de $9,900$ valores de ARI por cada $d_"Grambank"$ evaluado.

==== BPE vs WALS+Grambank
// TODO: Posteriormente, mencionar que en un apéndice se encuentra la tabla de las lenguas
Este experimento evalúa si combinar Grambank con WALS mejora la relación con $X_"BPE"$ frente a usarlas por separado. Se construyó el espacio combinado $X_("WALS"+"Grambank") = [X_"WALS" | X_"Grambank"] in RR^(L_G times (d_"WALS" + d_"Grambank"))$ por concatenación horizontal, con $L_G = #lenguas_grambank$ lenguas cubiertas por Grambank, $d_"WALS" = 15$ fijo (@wals-features) y $d_"Grambank"$ variable sobre $D$. Se comparó $X_"BPE"$ con $X_("WALS"+"Grambank")$ para cada valor de $d_"Grambank"$, produciendo una distribución de $9,900$ valores de ARI por cada $d_"Grambank"$ evaluado.

==== Grambank vs WALS
Este experimento auxiliar verifica qué tan parecidos son entre sí $X_"Grambank"$ y $X_"WALS"$, para situar los resultados de los tres experimentos anteriores. Se compararon $X_"Grambank" in RR^(L_G times d_"Grambank")$ y $X_"WALS"$ restringido al mismo conjunto $L_G$ de lenguas, corriendo el experimento para cada valor de $d_"Grambank"$ en $D$. Esto produce una distribución de $9,900$ valores de ARI por cada $d_"Grambank"$ evaluado.

==== Grambank vs lang2vec

Este último experimento auxiliar extiende la comparación a otros recursos tipológicos, evaluando $X_"Grambank"$ contra $X_"lang2vec"$, cuyas características son sintácticas. Se compararon $X_"Grambank" in RR^(L_G times d_"Grambank")$ con $X_"lang2vec"$ en sus dos variantes ---`syntax_wals` y `syntax_knn`---, corriendo el experimento para cada valor de $d_"Grambank"$ en $D$. Esto produce una distribución de $9,900$ valores de ARI por cada $d_"Grambank"$ evaluado y por cada variante de lang2vec.

