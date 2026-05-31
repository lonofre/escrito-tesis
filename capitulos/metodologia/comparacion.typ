/*
  El objetivo fue buscar una relación entre los diferentes espacios.
*/
== Comparación entre los espacios

Siguiendo la convención establecida en la sección anterior, los experimentos que involucran Grambank operan sobre el subconjunto de $L_G = 38$ lenguas, mientras que los demás utilizan las $L = 47$ lenguas completas.

// El código de esto es: seed1, seed2 in permutations(range(0, 100), 2):
Para calcular la similitud entre un espacio $X$ y un espacio $Y$, se utilizó el ARI sobre los agrupamientos de cada espacio, obtenidos mediante k-medias++. Este algoritmo depende de una semilla de inicialización, por lo que los resultados pueden variar entre ejecuciones. Para dar cuenta de esta variabilidad, se evaluaron todas las permutaciones ordenadas de pares de semillas $s_1, s_2 in {0, 1, dots, 99}$. Estas permutaciones generaron un total de $10,000$ valores de ARI para cada par de espacios $X, Y$.

// TODO: Cambiar BPE-r por otra cosa para decir que es random
En todos los experimentos que involucran $X_"BPE"$, se calculó también el ARI con $X_"BPE-r"$ como marco de referencia.

=== Experimentos

#let lenguas_grambank = 38

==== BPE vs WALS+Grambank 
El objetivo de este experimento fue comprobar si Grambank, como una extensión de WALS, ayuda a mejorar los valores de relación con BPE.

// TODO: Posteriormente, mencionar que en un apéndice se encuentra la tabla de las lenguas
Para realizar esto, se construyó $X_("WALS+Grambank")$ mediante la concatenación horizontal de $X_"WALS"$ y $X_"Grambank"$, es decir, $X_("WALS"+"Grambank") = [X_"WALS" | X_"Grambank"]$. Como Grambank ofrece un menor soporte de lenguas, se tuvo que reducir el número de lenguas en WALS para que coincidieran con las de Grambank

Esto resultó en el espacio $X_("WALS"+"Grambank") in RR^(L_G times (d_"WALS" + d_"Grambank"))$, donde $L_G = #lenguas_grambank$ es el subconjunto de lenguas cubierto por Grambank, $d_"WALS" = 15$ es fijo (@wals-features) y $d_"Grambank"$ varía según la selección descrita en la sección anterior. Como el experimento se corrió por cada valor de $d_"Grambank"$ en el conjunto $D$ de tamaños evaluados, se obtuvieron en total $10,000 times |D|$ valores de ARI.

==== BPE vs WALS

Para evaluar la similitud entre $X_"BPE"$ y $X_"WALS"$, se siguió la configuración de lenguas y características de WALS establecida por #cite(<ximena-bpe-2023>, form: "prose"). A diferencia del experimento anterior, aquí se conservó el conjunto completo de lenguas, sin la reducción impuesta por Grambank.

==== BPE vs Grambank
El objetivo de este experimento fue evaluar la relación entre $X_"BPE"$ y $X_"Grambank"$ de manera aislada. Para esto, se utilizó $X_"Grambank" in RR^(L_G times d_"Grambank")$. Como $d_"Grambank"$ se barre sobre el conjunto $D$ de tamaños evaluados, se obtuvieron en total $10,000 times |D|$ valores de ARI.

==== Grambank vs WALS
El objetivo de este experimento fue evaluar la relación entre $X_"BPE"$ y $X_"Grambank"$ de manera aislada. Para esto, se utilizó $X_"Grambank" in RR^(L_G times d_"Grambank")$. Como $d_"Grambank"$ se barre sobre el conjunto $D$ de tamaños evaluados, se obtuvieron en total $10,000 times |D|$ valores de ARI. 

==== Grambank vs lang2Vec

Se calculó el ARI entre $X_"Grambank"$ y de $X_"lang2vec"$ para evaluar qué tan similares son los agrupamientos cuando uno de los espacios se basa en características sintácticas. De lang2vec, se utilizaron los conjuntos syntax_wals y syntax_knn, con un número fijo de características $m$. Para Grambank, el número de características $n$ se mantuvo variable como en los experimentos anteriores, resultando en $10,000 times n$ valores de ARI.

