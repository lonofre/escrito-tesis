#import "@preview/lilaq:0.6.0" as lq
#import "resultados-lib.typ" : paired-boxplot, nested-overlay, nested-band, bar-ari-grambank, tabla-ari-grambank

= Resultados

*_Ximena: También justificar por qué se elige una configuración alrededor de treinta y tantos: Porque en ese umbral no hay tantos NANS como en los 70s, donde tantos valores incompletos quizá empiezan a tener un efecto negativo en el clustering aunque el ARI sea alto_*

Reportamos los cinco experimentos descritos en la metodología, cada uno como la distribución de los valores de ARI que produce. Los organizamos en dos bloques, primero las tres comparaciones de $X_"BPE"$ frente a las bases lingüísticas, después las dos comparaciones entre las propias bases. Al final presentamos el análisis cualitativo por característica.

== BPE frente a las bases lingüísticas

#underline[_Ximena: Antes de dar una interpretación de los resultados, guía al lector en la descripción de la figura (qué estamos viendo ahí, qué tipo de diagrama es, etc)  antes de concluir sí coincide o no _]

*BPE vs WALS.* El agrupamiento que induce $X_"BPE"$ coincide con el de $X_W$ por encima del azar (@wals-bpe-plot). De esta manera, replicamos el resultado de #cite(<ximena-bpe-2023>, form: "prose") bajo una diferente metodología.

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


#underline[_Ximena: En las gráficas con barrido de Grambank, especificar muy bien que estamos viendo en el eje de las Xs. y de alguna manera recordarle al lector porqué este tipo de visualziacioens se ven diferentes a la anterior de BPE vs WALS_]

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

La banda intercuartil de $X_"BPE"$ vs $X_G$ se mantiene por encima de la de la referencia $X_0$ en todo el barrido. No obstante, su mediana apenas se mueve, pues oscila entre $-0.002$ y $0.026$ a lo largo de $d_G$, mientras que la de la referencia ronda cero, ligeramente negativa. El tercer cuartil de $X_"BPE"$ ronda $0.03$–$0.07$ y se mantiene por encima de toda la banda de la referencia, que no pasa de $0.024$. Los primeros cuartiles, en cambio, son ligeramente negativos y corren muy cerca uno del otro, con el de $X_"BPE"$ apenas por encima en todo el barrido.

La diferencia se concentra en el techo, donde el percentil 99 de $X_"BPE"$ vs $X_G$ sube de $0.17$ en $d_G = 30$ hasta su máximo de $0.28$ en $d_G = 75$, más del doble que el de la referencia, que permanece plano cerca de $0.09$. El máximo real recorre un rango más amplio, de $0.24$ a $0.49$ con su pico en $d_G = 68$, frente a $0.12$–$0.24$ de la referencia, y en el extremo inferior ambas series vuelven a ser comparables, sin que el percentil 1 baje de $-0.075$.

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

Como con Grambank sola, la banda intercuartil de $X_"BPE"$ vs $X_(W+G)$ se mantiene por encima de la referencia en todo el barrido, con una mediana casi plana, entre $0.003$ y $0.026$. Su tercer cuartil ronda $0.04$–$0.08$ y supera a toda la banda de la referencia, que no pasa de $0.022$. Los primeros cuartiles, en cambio, son ligeramente negativos y corren muy cerca uno del otro, con el de $X_"BPE"$ apenas por encima en todo el barrido.

La diferencia se concentra en el techo, donde el percentil 99 sube de $0.17$ en $d_G = 30$ hasta $0.28$ cerca de $d_G = 74$, mientras el de la referencia no pasa de $0.12$. Combinar WALS con Grambank no eleva este techo respecto a Grambank sola, ya que el percentil 99 arranca en el mismo valor, $0.17$, y llega a uno equivalente. El máximo real, en cambio, sí es más alto, $0.545$ en $d_G = 75$ frente a $0.493$ de Grambank sola y $0.12$–$0.20$ de la referencia. En el extremo inferior ambas series son comparables, sin bajar de $-0.080$.

#underline[_Ximena: Las descripciones estadísticas que haces de las gráficas parecen estar bien; sin embargo, yo agregaría un poco más de hilo narrativo, resaltando los puntos que, a tu criterio, son importantes. Por ejemplo, se puede señalar que hay configuraciones de clustering que alcanzan ARI de más de 0.5, lo cual nos habla de cierta coincidencia. Desde luego, no estamos hablando de espacios iguales: cada uno aparentemente está codificando información diferente, pero aun así hay cierto grado de coincidencia entre ellos.
_]


== Concordancia entre las bases lingüísticas

*Grambank vs WALS.* La mayor parte de las corridas de $X_G$ vs $X_W$ da valores más altos que cualquier comparación con $X_"BPE"$, aunque su máximo real no (@grambank-wals-ari-plot). Este experimento auxiliar sitúa la magnitud de los tres resultados anteriores en una escala interpretable.

#underline[_Ximena: ¿A qué te refieres con "sitúa la magnitud de los tres resultados anteriores en una escala interpretable"_]

// Bandas anidadas: experimento auxiliar de una sola serie (sin referencia).
#figure(
  nested-band(
    "datos/percentiles/grambank-wals-percentiles.json",
    label: [$X_G$ vs $X_W$],
  ),
  caption: [ARI entre $X_G$ y $X_W$ por número de características de Grambank. Halo
    exterior: mín--máx; banda media: P1--P99; banda interior: rango intercuartil.]
)<grambank-wals-ari-plot>

El tercer cuartil de $X_G$ vs $X_W$ se sitúa por encima del de las comparaciones de $X_"BPE"$ contra $X_G$ y contra $X_(W+G)$ en todo el barrido, y por encima del de $X_"BPE"$ vs $X_W$ salvo en los primeros cuatro puntos. Su rango intercuartil se mantiene en valores positivos, salvo dos puntos del barrido en que el primer cuartil roza el cero por debajo. Ese cuartil no pasa de $0.020$ y el tercero va entre $0.059$ y $0.124$. Su mediana va de $0.025$ a $0.066$, un rango que se solapa con el valor único de $X_"BPE"$ vs $X_W$ ($0.048$). El techo, medido por el percentil 99, va de $0.18$ a $0.29$, sin que el percentil 1 baje de $-0.075$, y el máximo real sube todavía más, entre $0.32$ y $0.53$, con su pico en $d_G = 35$. Ese techo, a diferencia del resto, no se despega del de las comparaciones con $X_"BPE"$, que lo alcanzan alrededor de $d_G = 75$.

*Grambank vs lang2vec.* Las medianas de ARI más altas del estudio aparecen al comparar $X_G$ con $X_"l2v"$ (@grambank-lang2vec-ari-plot). Este experimento auxiliar amplía la calibración anterior.

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

$X_G$ vs $X_"l2v"$ alcanza las medianas más altas de las cinco comparaciones entre espacios. Su mediana va de $0.13$ a $0.19$, con el máximo alrededor de $d_G = 38$. Su rango intercuartil, entre $0.08$ y $0.25$, queda muy por encima de cero. El techo es también el más alto, con el percentil 99 en $0.45$ cerca de $d_G = 39$ y el máximo real todavía mayor, hasta $0.75$ cerca de $d_G = 42$, el más alto de esas cinco comparaciones. A diferencia de los demás experimentos, su percentil 1 apenas roza valores negativos, entre $-0.03$ y $0.01$.

_#underline[Ximena: Aquí, una vez más, parece el resultado de un prompt que describe las gráficas y falta un poco de hilo narrativo. Conviene recordar al lector por qué nos interesaba comparar las bases de datos, pues es fácil perderse entre tantas configuraciones y, al final, estas son importantes, pero no son el punto central. Por ejemplo, podrías recordar que, aunque Lan2Vec no es de relevancia directa para nuestro estudio, al enfocarse exclusivamente en características sintácticas, queríamos compararla con Grambank para explorar si esta base tiende a codificar características que se acercan más a la sintaxis.]_

== Resumen de los experimentos

_#underline[Ximena: Es bueno tener una subsección de resumen.Sin embargo,nuestro objetivo no era comparar la similitud entre bases de datos, sino evaluar qué tanto se acerca la conceptualización de BPE a las bases de datos lingüísticas. Por ello, el resumen debería partir de ese foco: en todos los casos, la similitud de BPE con las bases supera lo esperado por azar; las combinaciones WALS+Grambank alcanzan máximos de 0.55, lo que sugiere una coincidencia entre la información lingüística codificada y los agrupamientos inducidos por BPE. Así, se confirman las observaciones de Gutiérrez y se extienden a otras bases lingüísticas y configuraciones.
Comentar sobre la comparación entre las bases de datos es algo secundario, pero puedes mencionar que pareciera haber cierto sesgo de Grambank hacia lo sintáctico. También señalar que, aunque hay coincidencia en todos los casos, pareciera que cada conceptualización está codificando información tanto similar como distinta.]_

Las tres primeras comparaciones con $X_"BPE"$ superan su línea de referencia, pero las comparaciones entre bases lingüísticas concentran más corridas en valores altos, con un tercer cuartil que supera al de las comparaciones con $X_"BPE"$ en casi todo el barrido y, contra lang2vec, medianas varias veces mayores (@resumen-experimentos).

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
    [BPE vs Grambank],      [$-0.002$–$0.026$], [$0.28$], [$0.24$–$0.49$],
    [BPE vs WALS+Grambank], [$0.003$–$0.026$], [$0.28$], [$0.24$–$0.55$],
    [Grambank vs WALS],     [$0.025$–$0.066$], [$0.29$], [$0.32$–$0.53$],
    [Grambank vs lang2vec], [$0.13$–$0.19$],   [$0.45$], [$0.56$–$0.75$],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Resumen de las cinco comparaciones entre espacios. La mediana se reporta como
    el rango que recorre a lo largo del barrido de $d_G$; para BPE vs WALS, que no barre
    ($d_W = 15$ fijo), es un valor único. P99 es el máximo del percentil 99 sobre el
    barrido, el techo de coincidencia alcanzado. Máximo es el mayor ARI real observado en
    el barrido, más alto pero también más sensible a una sola pareja de semillas. El
    experimento por característica individual no aparece porque no produce una
    distribución comparable (@ranking-ari-grambank-bar).],
)<resumen-experimentos>

== ARI por característica de Grambank

#underline[_Ximena: Aquí otra vez inicias directamente describiendo los resultados, sin explicarle antes al lector qué está viendo en la tabla ni recordar brevemente en qué consiste este método. Aunque ya se haya explicado en la metodología, es un buen recurso divulgativo recordar qué estamos haciendo en este experimento, que además constituye una valoración cualitativa para interpretar los resultados, pues alguien tuvo que etiquetar, con base en su criterio, si cada característica corresponde a morfología, sintaxis, etc. Esto de cualitativo quizá se puede enfatizar en el título o en el texto. También habría que justificar por qué nos centramos en la configuración Grambank vs. BPE. Quizá se puede argumentar que es la nueva base de datos que incorporamos al estudio y, por ello, nos interesa saber qué características de esta base juegan un papel determinante en su similitud con BPE._]

De las 15 características con mayor ARI promedio, 9 son morfológicas, 4 sintácticas y 2 morfosintácticas (@ranking-ari-grambank-bar).

Fijamos este análisis en $d_G = 39$ porque en los experimentos anteriores ese punto del barrido reúne los valores altos de ARI sin arrastrar las características con valores incompletos que aparecen más adelante (como visto en @grambank-valores-vacios) y son suficientes características. En la gráfica, el color indica la categoría gramatical, una anotación cualitativa nuestra.

#figure(
  bar-ari-grambank(),
  caption: [ARI promedio al agrupar las lenguas con cada característica de Grambank por separado ($d_G = 39$), en orden descendente. El asterisco (\*) marca las preguntas(características) que hablan de un patrón morfológico productivo. Los nombres están en @tabla-ari-grambank.],
)<ranking-ari-grambank-bar>

Las 39 características se reparten casi por igual entre las tres categorías: 13 morfológicas, 14 morfosintácticas y 12 sintácticas. Con ese reparto, la morfología aporta 9 de las 15 primeras, muchas más de las que le tocarían por su tamaño. Abajo pasa lo contrario, pues de las 14 morfosintácticas solo 2 llegan a las 15 primeras.

Entre esas primeras posiciones pesa la productividad morfológica. De las 39 características, 6 preguntan por un patrón morfológico productivo, y 5 de ellas están entre las 14 primeras; la sexta cae en la posición 35. Las cinco son morfológicas, así que más de la mitad de las 9 morfológicas del top 15 preguntan por productividad. @tabla-ari-grambank da el ARI promedio de las 39 características con su nombre, su descripción y su categoría, y sombrea las seis filas de productividad.

#[
  #show figure: set block(breakable: true)
  #figure(
    tabla-ari-grambank(),
    caption: [ARI promedio de las 39 características de Grambank ($d_G = 39$), en orden descendente.],
  )<tabla-ari-grambank>
]

#pagebreak()
