#import "@preview/lilaq:0.6.0" as lq
#import "resultados-lib.typ" : boxplot-from-csv, paired-boxplot

#let min_features = 0
#let max_features = 195


// TODO: Toda esta sección está en construcción. Esta la estructura pero falta colocar los datos correctamente.
= Resultados

== BPE vs WALS

A diferencia de los demás experimentos, este no barre sobre $d_"Grambank"$: $d_"WALS" = 15$ está fijado por la selección de características de @wals-features. La @wals-bpe-plot compara la distribución de ARI entre $X_"BPE"$ y $X_"WALS"$ con la base de referencia $X_0$ vs $X_"WALS"$.

#figure(
  paired-boxplot(
    "datos/wals-bpe.json",
    label1: [$X_"BPE"$ vs $X_"WALS"$],
    label2: [$X_0$ vs $X_"WALS"$],
  ),
  caption: [Distribución de ARI entre $X_"BPE"$ y $X_"WALS"$ frente a la base de referencia $X_0$ vs $X_"WALS"$.]
)<wals-bpe-plot>

El ARI del experimento $X_"BPE"$ vs $X_"WALS"$ se mantiene por encima del de la base de referencia $X_0$ vs $X_"WALS"$. Su mediana es $0.0478$, frente a $0.0007$ de la referencia: una diferencia de $+0.0471$. El 50% central de los valores de $X_"BPE"$ vs $X_"WALS"$ cae entre $0.0175$ y $0.0837$, mientras que el de la referencia está entre $-0.0131$ y $0.0175$. Ambos rangos no se traslapan: solo se tocan en $0.0175$.

$X_"BPE"$ vs $X_"WALS"$ también muestra más dispersión que la referencia. Sus valores llegan hasta $0.2939$, frente a $0.1386$ de $X_0$ vs $X_"WALS"$, y su 50% central es aproximadamente el doble de ancho ($0.0662$ contra $0.0306$). En el extremo inferior, ambos experimentos son comparables: $-0.0631$ para $X_"BPE"$ vs $X_"WALS"$ y $-0.0753$ para la referencia.

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto),
    align: (center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [],
    [], [], [],
    [], [], [],
    [], [], [],
    [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_"BPE"$ vs $X_"WALS"$.],
)<configs-bpe-wals>

== BPE vs Grambank

El experimento $X_"BPE"$ vs $X_"Grambank"$ se evalúa para cada $d_"Grambank" in [30, 80]$, lo que produce un barrido de 51 distribuciones de ARI. En paralelo se calcula la base de referencia $X_0$ vs $X_"Grambank"$ sobre los mismos valores de $d_"Grambank"$.

#figure(
  boxplot-from-csv("datos/grambank-bpe.json"),
  caption: [Distribución de ARI entre $X_"BPE"$ y $X_"Grambank"$ por número de características de Grambank.]
)<bpe-grambank-ari-plot>

#figure(
  boxplot-from-csv("datos/grambank-bpe-random.json"),
  caption: [Distribución de ARI entre $X_0$ y $X_"Grambank"$ (base de referencia).]
)<bpe-random-grambank-ari-plot>

$X_"BPE"$ vs $X_"Grambank"$ se mantiene por encima de $X_0$ vs $X_"Grambank"$ a lo largo del barrido, aunque la separación entre ambos depende de $d_"Grambank"$. La mediana del experimento principal es positiva para todos los valores de $d_"Grambank"$, mientras que la de la referencia es negativa para la mayoría de ellos. El 50% central de los valores cae aproximadamente entre $-0.1$ y $0.2$ para $X_"BPE"$ vs $X_"Grambank"$, frente a un rango más estrecho y centrado por debajo de cero para la referencia.

Algunos $d_"Grambank"$ destacan por presentar valores notablemente altos en $X_"BPE"$ vs $X_"Grambank"$: superan $0.4$ en $d_"Grambank" = 56$ y en $d_"Grambank" in {73, 74, 75, 76}$. La referencia no presenta este comportamiento: sus pocos valores que cruzan $0.25$ se concentran antes de $d_"Grambank" = 50$ y ninguno supera $0.3$.

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$d_"Grambank"$], [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_"BPE"$ vs $X_"Grambank"$.],
)<configs-bpe-grambank>

== BPE vs WALS+Grambank

El experimento $X_"BPE"$ vs $X_("WALS"+"Grambank")$ se evalúa para cada $d_"Grambank" in [30, 80]$. En paralelo se calcula la base de referencia $X_0$ vs $X_("WALS"+"Grambank")$ sobre los mismos valores de $d_"Grambank"$.

#figure(
  boxplot-from-csv("datos/grambankANDwals-bpe.json"),
  caption: [Distribución de ARI entre $X_"BPE"$ y $X_("WALS"+"Grambank")$ por número de características de Grambank.]
)<bpe-grambankwals-ari-plot>

#figure(
  boxplot-from-csv("datos/grambankANDwals-bpe-random.json"),
  caption: [Distribución de ARI entre $X_0$ y $X_("WALS"+"Grambank")$ (base de referencia).]
)<bpe-random-grambankwals-ari-plot>

$X_"BPE"$ vs $X_("WALS"+"Grambank")$ se mantiene por encima de $X_0$ vs $X_("WALS"+"Grambank")$ a lo largo del barrido. La mediana del experimento principal es positiva para todos los valores de $d_"Grambank"$, mientras que la de la referencia se vuelve negativa a partir de $d_"Grambank" = 43$. El 50% central de los valores cae aproximadamente entre $-0.1$ y $0.2$ para el experimento principal, frente a un rango más estrecho y centrado cerca de cero para la referencia.

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$d_"Grambank"$], [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_"BPE"$ vs $X_("WALS"+"Grambank")$.],
)<configs-bpe-grambankwals>

== Grambank vs WALS

Este experimento auxiliar compara $X_"Grambank"$ con $X_"WALS"$ para cada $d_"Grambank" in [30, 80]$. Al no involucrar $X_"BPE"$, no se calcula base de referencia.

#figure(
  boxplot-from-csv("datos/grambank-wals.json"),
  caption: [Distribución de ARI entre $X_"Grambank"$ y $X_"WALS"$ por número de características de Grambank.]
)<grambank-wals-ari-plot>

La mediana de ARI entre $X_"Grambank"$ y $X_"WALS"$ es positiva para todos los valores de $d_"Grambank"$, manteniéndose cercana a $0.05$. El 50% central de los valores se mantiene aproximadamente entre $-0.1$ y $0.2$ en la mayor parte del barrido.

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$d_"Grambank"$], [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_"Grambank"$ vs $X_"WALS"$.],
)<configs-grambank-wals>

== Grambank vs Lang2Vec

Este experimento auxiliar compara $X_"Grambank"$ con $X_"lang2vec"$ en sus dos variantes (`syntax_wals` y `syntax_knn`) para cada $d_"Grambank" in [30, 80]$. Al no involucrar $X_"BPE"$, no se calcula base de referencia.

#figure(
  boxplot-from-csv("datos/grambank-lang2vec-syntax-wals.json"),
  caption: [Distribución de ARI entre $X_"Grambank"$ y $X_"lang2vec"$ usando `syntax_wals`.]
)<grambank-lang2vec-syntaxwals-ari-plot>

#figure(
  boxplot-from-csv("datos/grambank-lang2vec-syntax-knn.json"),
  caption: [Distribución de ARI entre $X_"Grambank"$ y $X_"lang2vec"$ usando `syntax_knn`.]
)<grambank-lang2vec-syntaxknn-ari-plot>

Ambas variantes muestran medianas de ARI por encima de $0.1$ para todos los valores de $d_"Grambank"$, las más altas de los cinco experimentos. `syntax_knn` presenta más dispersión que `syntax_wals`: el 50% central de sus valores se extiende por encima de $0.4$ a partir de $d_"Grambank" = 50$, mientras que en `syntax_wals` la dispersión es comparable a la de los experimentos con WALS y Grambank.

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$d_"Grambank"$], [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_"Grambank"$ vs $X_"lang2vec"$ usando `syntax_wals`.],
)<configs-grambank-lang2vec-wals>

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$d_"Grambank"$], [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_"Grambank"$ vs $X_"lang2vec"$ usando `syntax_knn`.],
)<configs-grambank-lang2vec-knn>

== Resumen

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [*Experimento*], [$d_"Grambank"^*$], [*Mediana*], [*IQR*], [*[mín, máx]*],
    ),
    table.hline(stroke: 0.3pt),
    [BPE vs WALS],                                  [—],  [], [], [],
    [#h(1em) ref. $X_0$ vs WALS],                   [—],  [], [], [],
    [BPE vs Grambank],                              [],   [], [], [],
    [#h(1em) ref. $X_0$ vs Grambank],               [],   [], [], [],
    [BPE vs WALS+Grambank],                         [],   [], [], [],
    [#h(1em) ref. $X_0$ vs WALS+Grambank],          [],   [], [], [],
    [Grambank vs WALS],                             [],   [], [], [],
    [Grambank vs lang2vec (`syntax_wals`)],         [],   [], [], [],
    [Grambank vs lang2vec (`syntax_knn`)],          [],   [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Resumen comparativo de los cinco experimentos. $d_"Grambank"^*$ es el valor de $d_"Grambank"$ donde se alcanza la mediana máxima de ARI; para BPE vs WALS no aplica porque $d_"WALS" = 15$ es fijo. Las filas con sangría reportan la base de referencia $X_0$ evaluada en el mismo $d_"Grambank"^*$ que la fila inmediatamente anterior.],
)<resumen-experimentos>

#pagebreak()
