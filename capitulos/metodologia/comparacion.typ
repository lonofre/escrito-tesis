/*
  El objetivo fue buscar una relación entre los diferentes espacios.
*/
== Comparación entre los espacios

// El código de esto es: seed1, seed2 in permutations(range(0, 100), 2):
Para mitigar la dependencia de una configuración particular, se evaluaron todas las permutaciones ordenadas de dos semillas tomadas del conjunto $\{0, 1, dots, 99\}$

=== Experimentos
// TODO: Ser más precisos con el número de features en Grambank

_BPE vs WALS+Grambank._ Se juntó el espacio de WALS $X_"WALS"$ con cada configuración de características de Grambank $X_"Grambank"$. Esto resultó en un espacio $X_("Grambank"+"WALS")$.

Con estas configuraciones, se obtuvo el ARI respecto a $X_"BPE"$. En total se corrieron $n$ experimentos por cada configuración de características

_BPE vs WALS._ Se realizó el cálculo de ARI sobre los espacios de $X_"BPE"$ y de $X_"WALS"$.

_BPE vs Grambank._ Se realizó el cálculo de ARI sobre los espacios de $X_"BPE"$ y de $X_"Grambank"$.

_Grambank vs Lang2Vec._ Se realizó el cálculo de ARI sobre los espacios de $X_"Grambank"$ y de $X_"Lang2vec"$. 

