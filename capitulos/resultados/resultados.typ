#import "@preview/lilaq:0.6.0" as lq
#import "resultados-lib.typ" : paired-boxplot, nested-overlay, nested-band


= Resultados
*_Ximena: En la parte gráfica para mostrar cómo se ven los clusterings entre espacios recomensaría agregar visualizaciones de espacios como GRAMBANK+BPE (por ejemplo configuración 39,51,57, diferentes clusters mismo espacio BPE), así como el mismo tipo de visualziación pero para un setting aleatorio para que se vea el contraste. 
Hacer énfasis que aunque los clusterings no son iguales entre Grambank+WALS y BPE, los clusters si muestran mucho más continuidad  en el espacio BPE que el aleatorio_*


*_También justificar porqué se elige una configuración alrededor de treinta y tantos: Porque en ese umbral no hay tantos NANS como en el lso 70s, donde tantos valores incompletos quizá empiezan a tener un efecto negativo en el clustering aunque el ARI sea alto_*


Reportamos los cinco experimentos descritos en la metodología, cada uno como la distribución de los valores de ARI que produce. Los organizamos en dos bloques, primero las tres comparaciones de $X_"BPE"$ frente a las bases lingüísticas, después las dos comparaciones entre las propias bases. 

== BPE frente a las bases lingüísticas

*BPE vs WALS.* El agrupamiento que induce $X_"BPE"$ coincide con el de $X_W$ por encima del azar (@wals-bpe-plot). De esta manera, replicamos el resultado de #cite(<ximena-bpe-2023>, form: "prose") con una metodología diferente.

#figure(
  paired-boxplot(
    "datos/percentiles/wals-bpe-percentiles.json",
    "datos/percentiles/wals-bpe-random-percentiles.json",
    label1: [$X_"BPE"$ vs $X_W$],
    label2: [$X_0$ vs $X_W$],
  ),
  caption: [Distribución de ARI entre $X_"BPE"$ y $X_W$ frente a la base de referencia $X_0$ vs $X_W$.]
)<wals-bpe-plot>

El ARI de $X_"BPE"$ vs $X_W$ se mantiene por encima del de la referencia $X_0$. Su mediana es $0.048$, frente a una referencia prácticamente nula. Aquí los rangos intercuartiles ni siquiera se solapan. El de $X_"BPE"$, entre $0.018$ y $0.084$, queda por completo por encima del de la referencia, que va de $-0.014$ a $0.016$.

El techo repite la separación de la mediana, con el percentil 99 de $X_"BPE"$ vs $X_W$ en $0.20$ frente a $0.065$ de la referencia, una brecha que el máximo real todavía amplía más, hasta $0.294$ contra $0.104$. En el extremo inferior ambos son comparables, con percentil 1 de $-0.032$ y $-0.043$.

*BPE vs Grambank.* El agrupamiento de $X_"BPE"$ también coincide con el de $X_G$ por encima del azar (@bpe-grambank-ari-plot), aunque por un margen más estrecho que con WALS.

// Bandas anidadas: BPE vs referencia X_0 (Grambank).
#figure(
  nested-overlay(
    "datos/percentiles/grambank-bpe-percentiles.json",
    "datos/percentiles/grambank-bpe-random-percentiles.json",
    label-a: [$X_"BPE"$ vs $X_G$],
    label-b: [$X_0$ vs $X_G$],
  ),
  caption: [ARI entre $X_"BPE"$ y $X_G$ frente a la referencia $X_0$, por número de
    características de Grambank. Halo exterior: mín--máx; banda media: P1--P99;
    banda interior: rango intercuartil.]
)<bpe-grambank-ari-plot>

La banda intercuartil de $X_"BPE"$ vs $X_G$ se mantiene por encima de la de la referencia $X_0$ en todo el barrido. No obstante, su mediana apenas se mueve, pues oscila entre $0.009$ y $0.028$ a lo largo de $d_G$, mientras que la de la referencia ronda cero, ligeramente negativa. El tercer cuartil de $X_"BPE"$ ronda $0.04$–$0.07$ y se mantiene por encima de toda la banda de la referencia, que no pasa de $0.024$. Los primeros cuartiles, en cambio, son ligeramente negativos y corren muy cerca uno del otro, con el de $X_"BPE"$ apenas por encima en todo el barrido.

La diferencia se concentra en el techo, donde el percentil 99 de $X_"BPE"$ vs $X_G$ oscila entre $0.14$ y $0.28$ sin una tendencia clara, con su mínimo en $d_G = 52$ y su máximo en $d_G = 70$. El de la referencia, en cambio, permanece plano cerca de $0.09$ y nunca llega a la mitad de ese máximo. El máximo real recorre un rango más amplio, de $0.24$ a $0.49$ con su pico en $d_G = 63$, frente a $0.12$–$0.24$ de la referencia, y en el extremo inferior ambas series vuelven a ser comparables, sin que el percentil 1 baje de $-0.075$.

*BPE vs WALS+Grambank.* Combinar WALS con Grambank en un espacio único no aumenta sensiblemente la coincidencia con $X_"BPE"$ frente a usar Grambank sola (@bpe-grambankwals-ari-plot).

// Bandas anidadas: BPE vs referencia X_0 (espacio combinado).
#figure(
  nested-overlay(
    "datos/percentiles/grambankANDwals-bpe-percentiles.json",
    "datos/percentiles/grambankANDwals-bpe-random-percentiles.json",
    label-a: [$X_"BPE"$ vs $X_(W+G)$],
    label-b: [$X_0$ vs $X_(W+G)$],
  ),
  caption: [ARI entre $X_"BPE"$ y el espacio combinado $X_(W+G)$ frente a la
    referencia $X_0$, por número de características de Grambank. Halo exterior:
    mín--máx; banda media: P1--P99; banda interior: rango intercuartil.]
)<bpe-grambankwals-ari-plot>

Como con Grambank sola, la banda intercuartil de $X_"BPE"$ vs $X_(W+G)$ se mantiene por encima de la referencia en todo el barrido, con una mediana casi plana, entre $0.011$ y $0.026$. Su tercer cuartil ronda $0.04$–$0.08$ y supera a toda la banda de la referencia, que no pasa de $0.024$. Los primeros cuartiles, en cambio, son ligeramente negativos y corren muy cerca uno del otro, con el de $X_"BPE"$ apenas por encima en todo el barrido.

La diferencia se concentra en el techo, donde el percentil 99 va de $0.17$ en $d_G = 30$ a $0.28$ cerca de $d_G = 69$, con una caída hasta $0.14$ en $d_G = 46$ antes de repuntar, mientras el de la referencia no pasa de $0.12$. Combinar WALS con Grambank no eleva este techo respecto a Grambank sola, ya que el percentil 99 arranca incluso más abajo, $0.17$ frente a $0.22$, y llega a un valor equivalente. El máximo real, en cambio, sí es más alto, $0.545$ en $d_G = 69$ frente a $0.493$ de Grambank sola y $0.14$–$0.20$ de la referencia. En el extremo inferior ambas series son comparables, sin que el percentil 1 baje de $-0.082$.

== Concordancia entre las bases lingüísticas

*Grambank vs WALS.* La mayor parte de las corridas de $X_G$ vs $X_W$ da valores más altos que cualquier comparación con $X_"BPE"$, aunque su máximo no (@grambank-wals-ari-plot). Este experimento auxiliar sitúa la magnitud de los tres resultados anteriores en una escala interpretable.

// Bandas anidadas: experimento auxiliar de una sola serie (sin referencia).
#figure(
  nested-band(
    "datos/percentiles/grambank-wals-percentiles.json",
    label: [$X_G$ vs $X_W$],
  ),
  caption: [ARI entre $X_G$ y $X_W$ por número de características de Grambank. Halo
    exterior: mín--máx; banda media: P1--P99; banda interior: rango intercuartil.]
)<grambank-wals-ari-plot>

El tercer cuartil de $X_G$ vs $X_W$ se sitúa por encima del de cualquier comparación con $X_"BPE"$ en todo el barrido. Su rango intercuartil se mantiene en valores positivos, salvo un punto del barrido en que el primer cuartil roza el cero por debajo. Ese cuartil no pasa de $0.020$ y el tercero va entre $0.085$ y $0.124$. Su mediana va de $0.041$ a $0.066$, un rango que se solapa con el valor único de $X_"BPE"$ vs $X_W$ ($0.048$). El techo, medido por el percentil 99, va de $0.23$ a $0.29$, sin que el percentil 1 baje de $-0.075$, y el máximo real sube todavía más, entre $0.37$ y $0.53$, con su pico en $d_G = 30$. Ese techo, a diferencia del resto, no se despega del de las comparaciones con $X_"BPE"$, que lo alcanzan alrededor de $d_G = 70$.

*Grambank vs lang2vec.* Las medianas de ARI más altas de los cinco experimentos aparecen al comparar $X_G$ con $X_"l2v"$ (@grambank-lang2vec-ari-plot). Este experimento auxiliar amplía la calibración anterior.

// Bandas anidadas: experimento auxiliar de una sola serie (sin referencia).
#figure(
  nested-band(
    "datos/percentiles/grambank-lang2vec-syntax-knn-percentiles.json",
    label: [$X_G$ vs $X_"l2v"$],
  ),
  caption: [ARI entre $X_G$ y $X_"l2v"$ (`syntax_knn`) por número de características de
    Grambank. Halo exterior: mín--máx; banda media: P1--P99; banda interior: rango
    intercuartil.]
)<grambank-lang2vec-ari-plot>

$X_G$ vs $X_"l2v"$ alcanza las medianas más altas de los cinco experimentos. Su mediana va de $0.13$ a $0.19$, con el máximo alrededor de $d_G = 33$. Su rango intercuartil, entre $0.08$ y $0.25$, queda muy por encima de cero. El techo es también el más alto, con el percentil 99 en $0.45$ cerca de $d_G = 34$ y el máximo real todavía mayor, hasta $0.75$ cerca de $d_G = 36$, el más alto de los cinco experimentos. A diferencia de los demás experimentos, su percentil 1 apenas roza valores negativos, entre $-0.03$ y $0.01$.

//== Resumen

Las tres comparaciones con $X_"BPE"$ superan su línea de referencia, pero las comparaciones entre bases lingüísticas concentran más corridas en valores altos, con un tercer cuartil que supera al de cualquier comparación con $X_"BPE"$ y, contra lang2vec, medianas varias veces mayores (@resumen-experimentos).

#figure(
  table(
    columns: (auto, auto, auto, auto),
    align: (left, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [*Experimento*], [*Mediana*], [*P99*], [*Máximo*],
    ),
    table.hline(stroke: 0.3pt),
    [BPE vs WALS],          [$0.048$],         [$0.20$], [$0.29$],
    [BPE vs Grambank],      [$0.009$–$0.028$], [$0.28$], [$0.24$–$0.49$],
    [BPE vs WALS+Grambank], [$0.011$–$0.026$], [$0.28$], [$0.24$–$0.55$],
    [Grambank vs WALS],     [$0.041$–$0.066$], [$0.29$], [$0.37$–$0.53$],
    [Grambank vs lang2vec], [$0.13$–$0.19$],   [$0.45$], [$0.56$–$0.75$],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Resumen de los cinco experimentos. La mediana se reporta como el rango que
    recorre a lo largo del barrido de $d_G$; para BPE vs WALS, que no barre ($d_W = 15$
    fijo), es un valor único. P99 es el máximo del percentil 99 sobre el barrido, el
    techo de coincidencia alcanzado. Máximo es el rango que recorre el mayor ARI real
    observado en cada punto del barrido, más alto pero también más sensible a una sola
    pareja de semillas.],
)<resumen-experimentos>

#pagebreak()
