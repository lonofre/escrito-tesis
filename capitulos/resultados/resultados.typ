#import "@preview/lilaq:0.6.0" as lq
#import "resultados-lib.typ" : paired-boxplot, nested-overlay, nested-band

#let min_features = 0
#let max_features = 195

// TODO: Toda esta sección está en construcción. Esta la estructura pero falta colocar los datos correctamente.
= Resultados
*_Ximena: En la parte gráfica para mostrar cómo se ven los clusterings entre espacios recomensaría agregar visualizaciones de espacios como GRAMBANK+BPE (por ejemplo configuración 39,51,57, diferentes clusters mismo espacio BPE), así como el mismo tipo de visualziación pero para un setting aleatorio para que se vea el contraste. 
Hacer énfasis que aunque los clusterings no son iguales entre Grambank+WALS y BPE, los clusters si muestran mucho más continuidad  en el espacio BPE que el aleatorio_*


*_También justificar porqué se elige una configuración alrededor de treinta y tantos: Porque en ese umbral no hay tantos NANS como en el lso 70s, donde tantos valores incompletos quizá empiezan a tener un efecto negativo en el clustering aunque el ARI sea alto_*


== BPE vs WALS

El agrupamiento que induce $X_"BPE"$ coincide con el de $X_W$ por encima del azar (@wals-bpe-plot), replicando, bajo la metodología de este trabajo, el resultado de #cite(<ximena-bpe-2023>, form: "prose"). A diferencia de los demás experimentos, este no barre sobre $d_G$: $d_W = 15$ está fijado por la selección de características de @wals-features.

#figure(
  paired-boxplot(
    "datos/wals-bpe.json",
    label1: [$X_"BPE"$ vs $X_W$],
    label2: [$X_0$ vs $X_W$],
  ),
  caption: [Distribución de ARI entre $X_"BPE"$ y $X_W$ frente a la base de referencia $X_0$ vs $X_W$.]
)<wals-bpe-plot>

El ARI del experimento $X_"BPE"$ vs $X_W$ se mantiene por encima del de la línea de referencia $X_0$ vs $X_W$. Su mediana es $0.0479$, frente a $0.0011$ de la referencia: una diferencia de $0.0468$. El 50% central de los valores de $X_"BPE"$ vs $X_W$ cae entre $0.0175$ y $0.0837$, mientras que el de la referencia está entre $-0.0135$ y $0.0156$. Ambos rangos no se traslapan.

$X_"BPE"$ vs $X_W$ también muestra más dispersión que la línea referencia. Sus valores llegan hasta $0.1827$, frente a $0.0591$ de $X_0$ vs $X_W$. En el extremo inferior, ambos experimentos son comparables: $-0.0632$ para $X_"BPE"$ vs $X_W$ y $-0.0569$ para la línea referencia.

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
  caption: [Top 5 configuraciones con mayor ARI en $X_"BPE"$ vs $X_W$.],
)<configs-bpe-wals>

== BPE vs Grambank

El agrupamiento de $X_"BPE"$ también coincide con el de $X_G$ por encima del azar (@bpe-grambank-ari-plot), aunque por un margen más estrecho que con WALS. El experimento se evalúa para cada $d_G in [30, 80]$, lo que produce un barrido de 51 distribuciones de ARI; en paralelo se calcula la base de referencia $X_0$ vs $X_G$ sobre los mismos valores de $d_G$.

// Bandas anidadas: BPE vs referencia X_0 (Grambank).
#figure(
  nested-overlay(
    "datos/percentiles/grambank-bpe-percentiles.json",
    "datos/percentiles/grambank-bpe-random-percentiles.json",
    label-a: [$X_"BPE"$ vs $X_G$],
    label-b: [$X_0$ vs $X_G$],
  ),
  caption: [ARI entre $X_"BPE"$ y $X_G$ frente a la referencia $X_0$, por número de
    características de Grambank. Banda exterior: mín--máx; banda interior: rango
    intercuartil.]
)<bpe-grambank-ari-plot>

Promediando sobre el barrido, el ARI de $X_"BPE"$ vs $X_G$ se mantiene por encima del de la línea de referencia $X_0$ vs $X_G$. Su mediana promedio es $0.0159$, frente a $-0.0073$ de la referencia: una diferencia de $0.0232$. El 50% central promedio de los valores de $X_"BPE"$ vs $X_G$ cae entre $-0.0136$ y $0.0524$, mientras que el de la referencia está entre $-0.0260$ y $0.0160$. Ambos rangos se traslapan parcialmente.

$X_"BPE"$ vs $X_G$ también muestra más dispersión en el extremo superior que la línea de referencia. Sus valores llegan en promedio hasta $0.1510$, frente a $0.0787$ de $X_0$ vs $X_G$. En el extremo inferior, ambos son comparables: $-0.0960$ para $X_"BPE"$ vs $X_G$ y $-0.0750$ para la referencia.

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$d_G$], [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_"BPE"$ vs $X_G$.],
)<configs-bpe-grambank>

== BPE vs WALS+Grambank

Combinar WALS con Grambank en un espacio único no aumenta sensiblemente la coincidencia con $X_"BPE"$ frente a usar Grambank sola (@bpe-grambankwals-ari-plot). El experimento se evalúa para cada $d_G in [30, 80]$; en paralelo se calcula la base de referencia $X_0$ vs $X_(W+G)$ sobre los mismos valores de $d_G$.

// Bandas anidadas: BPE vs referencia X_0 (espacio combinado).
#figure(
  nested-overlay(
    "datos/percentiles/grambankANDwals-bpe-percentiles.json",
    "datos/percentiles/grambankANDwals-bpe-random-percentiles.json",
    label-a: [$X_"BPE"$ vs $X_(W+G)$],
    label-b: [$X_0$ vs $X_(W+G)$],
  ),
  caption: [ARI entre $X_"BPE"$ y el espacio combinado $X_(W+G)$ frente a la
    referencia $X_0$, por número de características de Grambank. Banda exterior:
    mín--máx; banda interior: rango intercuartil.]
)<bpe-grambankwals-ari-plot>

Promediando sobre el barrido, el ARI de $X_"BPE"$ vs $X_(W+G)$ se mantiene por encima del de la línea de referencia $X_0$ vs $X_(W+G)$. Su mediana promedio es $0.0173$, frente a $-0.0084$ de la referencia: una diferencia de $0.0257$. El 50% central promedio de los valores de $X_"BPE"$ vs $X_(W+G)$ cae entre $-0.0136$ y $0.0569$, mientras que el de la referencia está entre $-0.0270$ y $0.0156$. Ambos rangos se traslapan parcialmente.

$X_"BPE"$ vs $X_(W+G)$ también muestra más dispersión en el extremo superior que la línea de referencia. Sus valores llegan en promedio hasta $0.1622$, frente a $0.0790$ de $X_0$ vs $X_(W+G)$. En el extremo inferior, ambos son comparables: $-0.0884$ para $X_"BPE"$ vs $X_(W+G)$ y $-0.0774$ para la referencia.

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$d_G$], [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_"BPE"$ vs $X_(W+G)$.],
)<configs-bpe-grambankwals>

== Grambank vs WALS

$X_G$ y $X_W$ coinciden entre sí más que cualquiera de ellas con $X_"BPE"$ (@grambank-wals-ari-plot). Este experimento auxiliar sitúa la magnitud de los tres resultados anteriores en una escala interpretable: compara $X_G$ con $X_W$ para cada $d_G in [30, 80]$. Al no involucrar $X_"BPE"$, no se calcula base de referencia.

// Bandas anidadas: experimento auxiliar de una sola serie (sin referencia).
#figure(
  nested-band(
    "datos/percentiles/grambank-wals-percentiles.json",
    label: [$X_G$ vs $X_W$],
  ),
  caption: [ARI entre $X_G$ y $X_W$ por número de características de Grambank. Banda
    exterior: mín--máx; banda interior: rango intercuartil.]
)<grambank-wals-ari-plot>

Promediando sobre el barrido, la mediana de ARI entre $X_G$ y $X_W$ es $0.0528$. El 50% central promedio de los valores cae entre $0.0117$ y $0.1026$. Los valores alcanzan en promedio hasta $0.2387$ en el bigote superior y $-0.1071$ en el bigote inferior.

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$d_G$], [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_G$ vs $X_W$.],
)<configs-grambank-wals>

== Grambank vs Lang2Vec

Las medianas de ARI más altas de los cinco experimentos aparecen al comparar $X_G$ con $X_"l2v"$ (@grambank-lang2vec-ari-plot). Este experimento auxiliar amplía la calibración anterior con un recurso tipológico que sintetiza varias fuentes en un único espacio vectorial. Se evalúa la variante `syntax_knn` de lang2vec para cada $d_G in [30, 80]$; al no involucrar $X_"BPE"$, no se calcula base de referencia.

// Bandas anidadas: experimento auxiliar de una sola serie (sin referencia).
#figure(
  nested-band(
    "datos/percentiles/grambank-lang2vec-syntax-knn-percentiles.json",
    label: [$X_G$ vs $X_"l2v"$],
  ),
  caption: [ARI entre $X_G$ y $X_"l2v"$ (`syntax_knn`) por número de características de
    Grambank. Banda exterior: mín--máx; banda interior: rango intercuartil.]
)<grambank-lang2vec-ari-plot>

Promediando sobre el barrido, `syntax_knn` alcanza la mediana de ARI más alta de los cinco experimentos: $0.1630$. El 50% central promedio de sus valores cae entre $0.1017$ y $0.2287$, y su dispersión llega en promedio hasta $0.4186$ en el extremo superior y $-0.0755$ en el inferior.

// TODO: Revisar criterio de selección — actualmente top 5 por ARI máximo. Considerar top por mediana o filtrar primero a configuraciones con mediana alta, para mayor robustez al seed.
#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [$d_G$], [$s_1$], [$s_2$], [*ARI*],
    ),
    table.hline(stroke: 0.3pt),
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    [], [], [], [],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Top 5 configuraciones con mayor ARI en $X_G$ vs $X_"l2v"$.],
)<configs-grambank-lang2vec-knn>

== Resumen

Las tres comparaciones con $X_"BPE"$ superan su línea de referencia, pero las comparaciones entre bases lingüísticas alcanzan medianas varias veces mayores, en particular contra lang2vec (@resumen-experimentos).

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [*Experimento*], [$d_G^*$], [*Mediana*], [*IQR*], [*[mín, máx]*],
    ),
    table.hline(stroke: 0.3pt),
    [BPE vs WALS],                                  [—],  [$0.0479$], [$0.0662$], [$[-0.0632, 0.1827]$],
    [#h(1em) ref. $X_0$ vs WALS],                   [—],  [$0.0010$], [$0.0291$], [$[-0.0569, 0.0591]$],
    [BPE vs Grambank],                              [],   [$0.0159$], [$0.0660$], [$[-0.0960, 0.1510]$],
    [#h(1em) ref. $X_0$ vs Grambank],               [],   [$-0.0073$], [$0.0420$], [$[-0.0750, 0.0787]$],
    [BPE vs WALS+Grambank],                         [],   [$0.0173$], [$0.0705$], [$[-0.0884, 0.1622]$],
    [#h(1em) ref. $X_0$ vs WALS+Grambank],          [],   [$-0.0084$], [$0.0425$], [$[-0.0774, 0.0790]$],
    [Grambank vs WALS],                             [],   [$0.0528$], [$0.0910$], [$[-0.1071, 0.2387]$],
    [Grambank vs lang2vec],                         [],   [$0.1630$], [$0.1270$], [$[-0.0755, 0.4186]$],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Resumen comparativo de los cinco experimentos. $d_G^*$ es el valor de $d_G$ donde se alcanza la mediana máxima de ARI; para BPE vs WALS no aplica porque $d_W = 15$ es fijo. Las filas con sangría reportan la base de referencia $X_0$ evaluada en el mismo $d_G^*$ que la fila inmediatamente anterior.],
)<resumen-experimentos>

#pagebreak()
