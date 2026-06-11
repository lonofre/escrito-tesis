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

El ARI del experimento $X_"BPE"$ vs $X_"WALS"$ se mantiene por encima del de la línea de referencia $X_0$ vs $X_"WALS"$. Su mediana es $0.0479$, frente a $0.0011$ de la referencia: una diferencia de $0.0468$. El 50% central de los valores de $X_"BPE"$ vs $X_"WALS"$ cae entre $0.0175$ y $0.0837$, mientras que el de la referencia está entre $-0.0135$ y $0.0156$. Ambos rangos no se traslapan.

$X_"BPE"$ vs $X_"WALS"$ también muestra más dispersión que la línea referencia. Sus valores llegan hasta $0.1827$, frente a $0.0591$ de $X_0$ vs $X_"WALS"$. En el extremo inferior, ambos experimentos son comparables: $-0.0632$ para $X_"BPE"$ vs $X_"WALS"$ y $-0.0569$ para la línea referencia.

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

Promediando sobre el barrido, el ARI de $X_"BPE"$ vs $X_"Grambank"$ se mantiene por encima del de la línea de referencia $X_0$ vs $X_"Grambank"$. Su mediana promedio es $0.0159$, frente a $-0.0073$ de la referencia: una diferencia de $0.0232$. El 50% central promedio de los valores de $X_"BPE"$ vs $X_"Grambank"$ cae entre $-0.0136$ y $0.0524$, mientras que el de la referencia está entre $-0.0260$ y $0.0160$. Ambos rangos se traslapan parcialmente.

$X_"BPE"$ vs $X_"Grambank"$ también muestra más dispersión en el extremo superior que la línea de referencia. Sus valores llegan en promedio hasta $0.1510$, frente a $0.0787$ de $X_0$ vs $X_"Grambank"$. En el extremo inferior, ambos son comparables: $-0.0960$ para $X_"BPE"$ vs $X_"Grambank"$ y $-0.0750$ para la referencia.

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

Promediando sobre el barrido, el ARI de $X_"BPE"$ vs $X_("WALS"+"Grambank")$ se mantiene por encima del de la línea de referencia $X_0$ vs $X_("WALS"+"Grambank")$. Su mediana promedio es $0.0173$, frente a $-0.0084$ de la referencia: una diferencia de $0.0257$. El 50% central promedio de los valores de $X_"BPE"$ vs $X_("WALS"+"Grambank")$ cae entre $-0.0136$ y $0.0569$, mientras que el de la referencia está entre $-0.0270$ y $0.0156$. Ambos rangos se traslapan parcialmente.

$X_"BPE"$ vs $X_("WALS"+"Grambank")$ también muestra más dispersión en el extremo superior que la línea de referencia. Sus valores llegan en promedio hasta $0.1622$, frente a $0.0790$ de $X_0$ vs $X_("WALS"+"Grambank")$. En el extremo inferior, ambos son comparables: $-0.0884$ para $X_"BPE"$ vs $X_("WALS"+"Grambank")$ y $-0.0774$ para la referencia.

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

Promediando sobre el barrido, la mediana de ARI entre $X_"Grambank"$ y $X_"WALS"$ es $0.0528$. El 50% central promedio de los valores cae entre $0.0117$ y $0.1026$. Los valores alcanzan en promedio hasta $0.2387$ en el bigote superior y $-0.1071$ en el bigote inferior.

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

Promediando sobre el barrido, ambas variantes muestran las medianas de ARI más altas de los cinco experimentos. La variante `syntax_knn` alcanza una mediana promedio de $0.1630$, frente a $0.1448$ de `syntax_wals`: una diferencia de $0.0182$. El 50% central promedio de `syntax_knn` cae entre $0.1017$ y $0.2287$, mientras que el de `syntax_wals` está entre $0.0862$ y $0.2112$.

`syntax_knn` también muestra mayor dispersión en el extremo superior. Sus valores llegan en promedio hasta $0.4186$, frente a $0.3982$ de `syntax_wals`. En el extremo inferior, ambas variantes son comparables: $-0.0755$ para `syntax_knn` y $-0.0843$ para `syntax_wals`.

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
    [BPE vs WALS],                                  [—],  [$0.0479$], [$0.0662$], [$[-0.0632, 0.1827]$],
    [#h(1em) ref. $X_0$ vs WALS],                   [—],  [$0.0010$], [$0.0291$], [$[-0.0569, 0.0591]$],
    [BPE vs Grambank],                              [],   [$0.0159$], [$0.0660$], [$[-0.0960, 0.1510]$],
    [#h(1em) ref. $X_0$ vs Grambank],               [],   [$-0.0073$], [$0.0420$], [$[-0.0750, 0.0787]$],
    [BPE vs WALS+Grambank],                         [],   [$0.0173$], [$0.0705$], [$[-0.0884, 0.1622]$],
    [#h(1em) ref. $X_0$ vs WALS+Grambank],          [],   [$-0.0084$], [$0.0425$], [$[-0.0774, 0.0790]$],
    [Grambank vs WALS],                             [],   [$0.0528$], [$0.0910$], [$[-0.1071, 0.2387]$],
    [Grambank vs lang2vec (`syntax_wals`)],         [],   [$0.1448$], [$0.1250$], [$[-0.0843, 0.3982]$],
    [Grambank vs lang2vec (`syntax_knn`)],          [],   [$0.1630$], [$0.1270$], [$[-0.0755, 0.4186]$],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Resumen comparativo de los cinco experimentos. $d_"Grambank"^*$ es el valor de $d_"Grambank"$ donde se alcanza la mediana máxima de ARI; para BPE vs WALS no aplica porque $d_"WALS" = 15$ es fijo. Las filas con sangría reportan la base de referencia $X_0$ evaluada en el mismo $d_"Grambank"^*$ que la fila inmediatamente anterior.],
)<resumen-experimentos>

#pagebreak()
