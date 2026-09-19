#import "@preview/lilaq:0.6.0" as lq
#import "resultados-lib.typ" : paired-boxplot, nested-overlay, nested-band, bar-ari-grambank, tabla-ari-grambank

= Resultados

Reportamos los cinco experimentos descritos en la metodología, cada uno como la distribución de los valores de ARI que produce. Los organizamos en dos bloques: primero las tres comparaciones de $X_"BPE"$ frente a las bases lingüísticas, después las dos comparaciones entre las propias bases. Al final presentamos el análisis cualitativo por característica.

== BPE frente a las bases lingüísticas

*BPE vs WALS.* Este primer experimento retoma la pregunta de #cite(<ximena-bpe-2023>, form: "prose"), si $X_"BPE"$ codifica información de morfología tipológica, ahora con las 15 características morfológicas de WALS. La @wals-bpe-plot es un diagrama de cajas que compara las dos distribuciones de este experimento: a la izquierda, el ARI entre $X_"BPE"$ y $X_W$; a la derecha, el de la referencia aleatoria $X_0$ contra $X_W$. En cada caja, la línea interior es la mediana y el cuerpo cubre el rango intercuartil (el 50% central de los datos); los bigotes llegan a los percentiles 1 y 99, y los dos círculos tenues marcan el mínimo y el máximo.

#figure(
  paired-boxplot(
    "datos/percentiles/wals-bpe-percentiles.json",
    "datos/percentiles/wals-bpe-random-percentiles.json",
    label1: [$X_"BPE"$ vs $X_W$],
    label2: [$X_0$ vs $X_W$],
  ),
  caption: [Distribución de ARI entre $X_"BPE"$ y $X_W$ frente a la base de referencia $X_0$ vs $X_W$.]
)<wals-bpe-plot>

La figura muestra que el agrupamiento que induce $X_"BPE"$ coincide con el de $X_W$ por encima del azar, con lo que replicamos el resultado de #cite(<ximena-bpe-2023>, form: "prose") bajo una metodología diferente. Esa coincidencia se ve mejor en el techo de las dos distribuciones, donde aparecen los grupos que dan más coincidencia entre los dos espacios. El percentil 99 de $X_"BPE"$ vs $X_W$ llega a $0.20$, frente a $0.065$ de la referencia, y el máximo real amplía la brecha todavía más, hasta $0.294$ contra $0.104$. Hay entonces configuraciones en que la partición de $X_"BPE"$ recupera parte de la de $X_W$; no es una coincidencia grande, pero tampoco la coincidencia casi nula a la que llega el azar.

El resto de la distribución sostiene esa lectura. La mediana de $X_"BPE"$ vs $X_W$ es $0.048$, frente a una referencia prácticamente nula, y los rangos intercuartiles ni siquiera se solapan: el de $X_"BPE"$, entre $0.018$ y $0.084$, queda por completo por encima del de la referencia, que va de $-0.014$ a $0.016$. El grueso de los valores de $X_"BPE"$ es mayor que el de $X_0$, así que la separación del techo no proviene de unas pocas configuraciones afortunadas.

*BPE vs Grambank.* Este experimento hace la misma pregunta con $X_"BPE"$ pero cambiando WALS por Grambank, la base de datos lingüística más reciente, que a diferencia de WALS no define un solo espacio, sino uno por cada número de características $d_G$ que tomemos. Así, no produce una distribución de ARI, sino 56, una por cada punto del barrido, y por eso la @bpe-grambank-ari-plot no se ve como la anterior. Su eje horizontal es $d_G$, el número de características de Grambank que forman el espacio, tomadas de mayor a menor cobertura (véase @grambank-valores-vacios de @grambank-procesamiento), y el vertical sigue siendo el ARI.

Cada corte vertical de la figura equivale a un diagrama de caja como los de la @wals-bpe-plot, y las bandas son el trazo que dejan esas cajas a lo largo del barrido. La banda interior, la más oscura, es el rango intercuartil; la intermedia va del percentil 1 al 99, y el halo exterior, casi transparente, llega del mínimo al máximo. El color naranja corresponde a $X_"BPE"$ vs $X_G$ y el azul a la referencia $X_0$.

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

Con esa lectura, el agrupamiento de $X_"BPE"$ también coincide con el de $X_G$ por encima del azar, aunque por un margen más estrecho que con WALS. Otra vez la coincidencia se concentra en el techo: el percentil 99 de $X_"BPE"$ vs $X_G$ sube de $0.17$ en $d_G = 30$ hasta su máximo de $0.28$ en $d_G = 75$, más del doble que el de la referencia, que permanece plano cerca de $0.09$. El máximo real recorre un rango más amplio, de $0.24$ a $0.49$, con su pico en $d_G = 68$, frente a $0.12$–$0.24$ de la referencia. Las mejores configuraciones del barrido llegan así más lejos que las de WALS, y ese techo se levanta conforme entran más características de Grambank al espacio.

El resto de la distribución sostiene la separación, aunque apenas se mueve. La banda intercuartil de $X_"BPE"$ vs $X_G$ se mantiene por encima de la de la referencia $X_0$ en todo el barrido, con una mediana casi plana que oscila entre $-0.002$ y $0.026$ a lo largo de $d_G$, mientras que la de la referencia ronda cero, ligeramente negativa. El tercer cuartil de $X_"BPE"$ ronda $0.03$–$0.07$ y queda por encima de toda la banda de la referencia, que no pasa de $0.024$; los primeros cuartiles, en cambio, son ligeramente negativos y corren muy cerca uno del otro, con el de $X_"BPE"$ apenas por encima en todo el barrido. En el extremo inferior ambas series vuelven a ser comparables, sin que el percentil 1 baje de $-0.075$.

*BPE vs WALS+Grambank.* Este experimento pregunta si juntar ambas bases en un solo espacio acerca más el agrupamiento de $X_"BPE"$ al de la información lingüística que usarlas por separado. La @bpe-grambankwals-ari-plot se lee igual que la anterior, ahora con el espacio combinado en lugar de Grambank sola.

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

Combinar WALS con Grambank en un espacio único no aumenta sensiblemente la coincidencia con $X_"BPE"$ frente a usar Grambank sola (@bpe-grambankwals-ari-plot). El techo se comporta igual que en el experimento anterior, con el percentil 99 subiendo de $0.17$ en $d_G = 30$ hasta $0.28$ cerca de $d_G = 74$, mientras el de la referencia no pasa de $0.12$, es decir, arranca y termina en los mismos valores que con Grambank sola. Lo que sí se levanta es el máximo real, que llega a $0.545$ en $d_G = 75$, frente a $0.493$ de Grambank sola y $0.12$–$0.20$ de la referencia. Es el valor más alto que alcanza $X_"BPE"$ en los tres experimentos y el único que pasa de $0.5$, así que hay indicios de que existen configuraciones en que su agrupamiento y el del espacio combinado comparten buena parte de su estructura.

El resto de la distribución se comporta como con Grambank sola. La banda intercuartil de $X_"BPE"$ vs $X_(W+G)$ se mantiene por encima de la referencia en todo el barrido, con una mediana casi plana, entre $0.003$ y $0.026$, y un tercer cuartil que ronda $0.04$–$0.08$ y supera a toda la banda de la referencia, que no pasa de $0.022$. Los primeros cuartiles, en cambio, son ligeramente negativos y corren muy cerca uno del otro, con el de $X_"BPE"$ apenas por encima en todo el barrido. En el extremo inferior ambas series son comparables, sin bajar de $-0.080$.

== Concordancia entre las bases lingüísticas

Los dos experimentos que siguen son auxiliares y no tienen relevancia directa para nuestra pregunta de investigación, porque no evalúan a $X_"BPE"$, sino que nos ofrecen una referencia sobre la tendencia de lo que codifica Grambank respecto al conjunto de características que usamos.

*Grambank vs WALS.* Este experimento auxiliar compara entre sí las dos bases que ya usamos, para tener una referencia de la coincidencia de las características de Grambank con las características morfológicas que obtenemos de WALS. A diferencia de las figuras anteriores, la @grambank-wals-ari-plot lleva una sola familia de bandas, porque este experimento auxiliar no se contrasta contra la referencia aleatoria.

// Bandas anidadas: experimento auxiliar de una sola serie (sin referencia).
#figure(
  nested-band(
    "datos/percentiles/grambank-wals-percentiles.json",
    label: [$X_G$ vs $X_W$],
  ),
  caption: [ARI entre $X_G$ y $X_W$ por número de características de Grambank. Halo
    exterior: mín--máx; banda media: P1--P99; banda interior: rango intercuartil.]
)<grambank-wals-ari-plot>

El techo de $X_G$ vs $X_W$, medido por el percentil 99, va de $0.18$ a $0.29$, y el máximo real sube todavía más, entre $0.32$ y $0.53$, con su pico en $d_G = 35$. Ese pico llega temprano en el barrido, cuando el espacio se forma con pocas características de Grambank y con menos valores vacíos, lo que puede sugerir una relación morfológica más fuerte en esa zona que cuando entran todas las características.

El cuerpo de la distribución se queda bastante más abajo. El rango intercuartil de $X_G$ vs $X_W$ se mantiene en valores positivos a lo largo del barrido, salvo dos puntos en que el primer cuartil roza el cero por debajo, sin que ese cuartil pase de $0.020$ y con el tercero entre $0.059$ y $0.124$. Su mediana va de $0.025$ a $0.066$ y el percentil 1 no baja de $-0.075$.

*Grambank vs lang2vec.* Este segundo experimento auxiliar compara Grambank con lang2vec, cuyas características son exclusivamente sintácticas, para explorar si Grambank tiende a codificar información más cercana a la sintaxis que a la morfología. De igual manera, la @grambank-lang2vec-ari-plot lleva una sola familia de bandas, porque este experimento auxiliar no se contrasta contra la referencia aleatoria.

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

Grambank coincide bastante más con lang2vec que con las características morfológicas de WALS (@grambank-lang2vec-ari-plot), y esta vez la diferencia no se limita al techo. El techo, de todos modos, es el más alto de cuantos hemos reportado, con el percentil 99 en $0.45$ cerca de $d_G = 39$ y el máximo real todavía mayor, hasta $0.75$ cerca de $d_G = 42$.

El cuerpo de la distribución también es mayor que en el experimento con $X_W$, pues la mediana de $X_G$ vs $X_"l2v"$ va de $0.13$ a $0.19$, con su punto más alto alrededor de $d_G = 38$, muy por encima del $0.025$–$0.066$ que alcanza $X_G$ vs $X_W$, y su rango intercuartil, entre $0.08$ y $0.25$, queda muy por encima de cero. A diferencia de $X_G$ vs $X_W$, su percentil 1 apenas roza valores negativos, entre $-0.03$ y $0.01$.

== Resumen de los experimentos

En las tres comparaciones, el agrupamiento que induce $X_"BPE"$ coincide con el de las bases lingüísticas por encima de la referencia aleatoria. La separación es más clara con WALS, donde los rangos intercuartiles de $X_"BPE"$ y de $X_0$ ni siquiera se solapan, y más estrecha con Grambank y con el espacio combinado, donde se sostiene en todo el barrido pero por un margen menor. El techo de esa coincidencia llega hasta $0.545$ con WALS+Grambank, más del doble del máximo que alcanza la referencia en ese mismo experimento (@resumen-experimentos).

Esa coincidencia aparece en el techo de las distribuciones y no en su centro. Las medianas de los barridos se quedan cerca de cero, entre $-0.002$ y $0.026$ contra Grambank y entre $0.003$ y $0.026$ contra el espacio combinado, y solo contra WALS llegan a $0.048$. El primer cuartil es ligeramente negativo en los tres casos. Hay entonces configuraciones de agrupamiento en las que los dos espacios coinciden con claridad, y muchas otras en las que no.

Con esto replicamos la observación de #cite(<ximena-bpe-2023>, form: "prose") bajo otra métrica y sobre miles de pares de semillas, y la extendemos a otra base lingüística que es Grambank. La coincidencia no desaparece ni con la base de datos ni con la inicialización del agrupamiento.

Por último, las dos comparaciones entre bases lingüísticas nos dan una referencia sobre qué codifica Grambank, aunque estas comparaciones son solo secundarias. $X_G$ vs $X_"l2v"$ alcanza medianas bastante más altas que $X_G$ vs $X_W$, lo que apunta a que las características de Grambank recogen más sintaxis que morfología.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto),
    align: (left, center, center, center, center),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [*Experimento*], [*Mediana*], [*P99*], [*Máximo*], [*P99 de $X_0$*],
    ),
    table.hline(stroke: 0.3pt),
    [BPE vs WALS],          [$0.048$],          [$0.20$],        [$0.29$],        [$0.065$],
    [BPE vs Grambank],      [$-0.002$–$0.026$], [$0.14$–$0.28$], [$0.24$–$0.49$], [$0.06$–$0.11$],
    [BPE vs WALS+Grambank], [$0.003$–$0.026$],  [$0.14$–$0.28$], [$0.24$–$0.55$], [$0.07$–$0.12$],
    table.hline(stroke: 0.3pt),
    [Grambank vs WALS],     [$0.025$–$0.066$],  [$0.18$–$0.29$], [$0.32$–$0.53$], [---],
    [Grambank vs lang2vec], [$0.13$–$0.19$],    [$0.35$–$0.45$], [$0.56$–$0.75$], [---],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Resumen de las cinco comparaciones entre espacios. Cada celda es el rango que
    recorre el estadístico a lo largo del barrido de $d_G$; para BPE vs WALS, que no barre
    ($d_W = 15$ fijo), es un valor único. La última columna da el percentil 99 de la
    referencia aleatoria, la altura que alcanza el azar en ese mismo experimento, y está
    vacía en los dos experimentos auxiliares, que no se contrastan contra ella. El máximo
    es el mayor ARI real observado, más alto que el percentil 99 pero también más sensible
    a una sola pareja de semillas.],
)<resumen-experimentos>

== Análisis cualitativo de características <seccion-resultados-analisis-caracteristicas>

Este análisis incluye lo cualitativo y desglosa las características de Grambank a partir de una de las comparaciones anteriores. Nos centramos en $X_"BPE"$ vs $X_G$ porque Grambank es la base que incorporamos en este trabajo, y nos interesó saber qué características suyas juegan un papel importante en la similitud con BPE. Para ello agrupamos las lenguas con cada característica de Grambank por separado, es decir, con un espacio de una sola dimensión, y promediamos el ARI que obtiene contra $X_"BPE"$ para quitar el ruido de agrupar con tan poca información. Esta lectura es cualitativa porque la categoría gramatical de cada característica, si es morfológica, sintáctica o morfosintáctica (combinación de las dos anteriores), es una anotación que realizamos con criterio lingüístico a partir de la pregunta que formula cada característica.

Para realizar este análisis, fijamos el análisis en $d_G = 39$. Como vimos en los experimentos anteriores, ese punto del barrido ya reúne valores altos de ARI y todavía no arrastra las características con valores incompletos que aparecen más adelante (@grambank-valores-vacios en @grambank-procesamiento), y a la vez deja suficientes características para comparar entre categorías.

Es importante mencionar que, para este análisis, fue necesario recurrir al criterio de una especialista para clasificar cada una de las características de Grambank analizadas según su relación predominante con fenómenos morfológicos, morfosintácticos o sintácticos de la lengua. Esta clasificación no siempre es directa o unívoca, ya que algunas características involucran más de un nivel de análisis lingüístico y, en ciertos casos, su clasificación depende del criterio del lingüista.


La @ranking-ari-grambank-bar es un diagrama de barras con el ARI promedio de cada una de esas 39 características, ordenadas de mayor a menor. Cada barra es una característica, el eje vertical es su ARI promedio y el color indica la clasificación que le fue asignada (morfología, morfosintaxis o sintaxis).

#figure(
  bar-ari-grambank(),
  caption: [ARI promedio al agrupar las lenguas con cada característica de Grambank por separado ($d_G = 39$), en orden descendente. El asterisco (\*) marca las preguntas (características) que hablan de un patrón morfológico productivo. Los nombres están en @tabla-ari-grambank.],
)<ranking-ari-grambank-bar>

Las 39 características se reparten casi por igual entre las tres categorías: 13 morfológicas, 14 morfosintácticas y 12 sintácticas. Notemos que la morfología aporta 9 de las 15 primeras.

Entre esas primeras posiciones pesa la productividad morfológica, que es donde se espera que BPE opere. De las 39 características, 6 preguntan por un patrón morfológico productivo, y 5 de ellas están entre las 14 primeras; la sexta cae en la posición 35. Las cinco son morfológicas, así que más de la mitad de las 9 morfológicas del top 15 preguntan por productividad. La @tabla-ari-grambank da el ARI promedio de las 39 características con su nombre, su descripción y su categoría, y sombrea las seis filas de productividad.

#[
  #show figure: set block(breakable: true)
  #figure(
    tabla-ari-grambank(),
    caption: [ARI promedio de las 39 características de Grambank ($d_G = 39$), en orden descendente.],
  )<tabla-ari-grambank>
]

#pagebreak()
