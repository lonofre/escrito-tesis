= Experimentos complementarios <experimentos-complementarios>

== BPE frente a WALS sobre las lenguas de Grambank

El experimento de $X_"BPE"$ vs $X_W$ del capítulo de resultados usa las 47 lenguas del estudio, mientras que los experimentos con Grambank se limitaron a 38. Para ver si esa diferencia explica el contraste entre unos y otros, repetimos la comparación con esas mismas 38 lenguas, sin cambiar nada más.

Con 38 lenguas, $X_"BPE"$ vs $X_W$ sigue por encima de su referencia, pero por un margen más estrecho (@wals-bpe-38-tabla). Bajan la mediana y el techo, y los rangos intercuartiles se solapan, cosa que no pasaba con 47 lenguas. La coincidencia se reduce, pero no desaparece, así que la conclusión del capítulo no depende de haber usado las 47 lenguas.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center, center),
    stroke: none,
    inset: (x: 7pt, y: 5pt),
    table.hline(stroke: 0.5pt),
    table.header(
      [*Comparación*], [*Lenguas*], [*Mediana*], [*Q1--Q3*], [*P99*], [*Máximo*],
    ),
    table.hline(stroke: 0.3pt),
    [$X_"BPE"$ vs $X_W$], [38], [$0.021$],  [$-0.004$--$0.055$], [$0.156$], [$0.234$],
    [$X_0$ vs $X_W$],     [38], [$-0.005$], [$-0.028$--$0.013$], [$0.084$], [$0.146$],
    table.hline(stroke: 0.3pt),
    [$X_"BPE"$ vs $X_W$], [47], [$0.048$],  [$0.018$--$0.084$],  [$0.196$], [$0.294$],
    [$X_0$ vs $X_W$],     [47], [$0.000$],  [$-0.014$--$0.016$], [$0.065$], [$0.104$],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Distribución de ARI entre $X_"BPE"$ y $X_W$ restringida a las 38 lenguas de
    Grambank, junto con la corrida de 47 lenguas del capítulo de resultados. Cada una se
    acompaña de su referencia $X_0$ vs $X_W$.],
)<wals-bpe-38-tabla>


== BPE frente a Grambank con las 40 lenguas de la base <grambank-40-lenguas>

El experimento de $X_"BPE"$ vs $X_G$ del capítulo de resultados usa 38 lenguas, pues descartamos el coreano y el birmano por la forma en que su escritura agrupa letras en bloques silábicos. Para ver si la coincidencia con $X_G$ depende de esa exclusión, repetimos la comparación con las 40 lenguas que Grambank cubre, sin cambiar nada más. Generamos cada referencia $X_0$ sobre las lenguas de su propio experimento, así que las dos corridas están juntas en la tabla solo para compararlas.

Con 40 lenguas, $X_"BPE"$ vs $X_G$ sigue por encima de su referencia (@grambank-bpe-40-tabla). Los valores bajan en ambas series: el percentil 99 de $X_"BPE"$ pasa de $0.281$ a $0.232$ y el de la referencia, de $0.112$ a $0.092$. Agregar el coreano y el birmano baja el techo, pero no la separación respecto a la referencia.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center, center),
    stroke: none,
    inset: (x: 7pt, y: 5pt),
    table.hline(stroke: 0.5pt),
    table.header(
      [*Comparación*], [*Lenguas*], [*Mediana*], [*Q1--Q3*], [*P99*], [*Máximo*],
    ),
    table.hline(stroke: 0.3pt),
    [$X_"BPE"$ vs $X_G$], [40], [$-0.004$--$0.019$],  [$-0.029$--$0.058$], [$0.232$], [$0.341$],
    [$X_0$ vs $X_G$],     [40], [$-0.018$--$-0.007$], [$-0.033$--$0.016$], [$0.092$], [$0.211$],
    table.hline(stroke: 0.3pt),
    [$X_"BPE"$ vs $X_G$], [38], [$-0.002$--$0.026$],  [$-0.027$--$0.068$], [$0.281$], [$0.493$],
    [$X_0$ vs $X_G$],     [38], [$-0.014$--$-0.001$], [$-0.033$--$0.024$], [$0.112$], [$0.243$],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Distribución de ARI entre $X_"BPE"$ y $X_G$ con las 40 lenguas de Grambank,
    junto con la corrida de 38 lenguas del capítulo de resultados. Cada una se acompaña
    de su referencia $X_0$ vs $X_G$. Como estos experimentos barren $d_G$, la mediana y
    el rango intercuartil se reportan como rangos sobre el barrido: la mediana es el
    recorrido de su valor a lo largo de $d_G$, y Q1--Q3 es la envolvente del rango
    intercuartil, es decir el primer cuartil más bajo y el tercero más alto del barrido.
    P99 y Máximo son el techo alcanzado.],
)<grambank-bpe-40-tabla>


== La referencia aleatoria bajo distintas semillas <referencia-semillas>

La referencia $X_0$ reparte puntos al azar dentro de los rangos de $X_"BPE"$, así que cada semilla da una configuración distinta del espacio. Los experimentos del capítulo de resultados usan una sola, la 42. Para ver cuánto se mueve la referencia al cambiar esa semilla, repetimos la comparación de $X_"BPE"$ vs $X_G$ con cuatro semillas más.

La referencia se mueve, pero ninguna de las cinco alcanza a $X_"BPE"$ (@referencia-semillas-tabla). Su máximo va de $0.185$ a $0.337$, siempre por debajo del $0.493$ de $X_"BPE"$. La semilla 42, la de los experimentos reportados, cae entre las más bajas de las cinco.

La referencia más favorable, la de la semilla 1234, también se acerca en el centro de la distribución: su tercer cuartil llega a $0.066$ frente al $0.068$ de $X_"BPE"$. Aun así, un reparto desigual de grupos puede elevar el ARI sin que los grupos coincidan (@ejemplo-espacios-clusters-grambank-bpe). Cinco semillas alcanzan para ver la dirección, no para medir cada cuánto pasa.

#figure(
  table(
    columns: (auto, auto, auto, auto, auto, auto),
    align: (left, center, center, center, center, center),
    stroke: none,
    inset: (x: 7pt, y: 5pt),
    table.hline(stroke: 0.5pt),
    table.header(
      [*Serie*], [*Semilla de $X_0$*], [*Mediana*], [*Q1--Q3*], [*P99*], [*Máximo*],
    ),
    table.hline(stroke: 0.3pt),
    [$X_"BPE"$ vs $X_G$], [---],  [$-0.002$--$0.026$],  [$-0.027$--$0.068$], [$0.281$], [$0.493$],
    table.hline(stroke: 0.3pt),
    [$X_0$ vs $X_G$], [123],  [$-0.019$--$0.000$],  [$-0.036$--$0.027$], [$0.110$], [$0.185$],
    [$X_0$ vs $X_G$], [42],   [$-0.014$--$-0.001$], [$-0.033$--$0.023$], [$0.112$], [$0.243$],
    [$X_0$ vs $X_G$], [0],    [$-0.022$--$-0.006$], [$-0.040$--$0.019$], [$0.114$], [$0.220$],
    [$X_0$ vs $X_G$], [1],    [$-0.002$--$0.013$],  [$-0.024$--$0.045$], [$0.184$], [$0.337$],
    [$X_0$ vs $X_G$], [1234], [$-0.007$--$0.023$],  [$-0.028$--$0.066$], [$0.223$], [$0.320$],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Distribución de ARI entre $X_0$ y $X_G$ con las 38 lenguas de Grambank bajo
    cinco semillas de $X_0$, ordenados por techo, junto con $X_"BPE"$ vs $X_G$ del
    capítulo de resultados. La semilla 42 es la de los experimentos reportados. Como
    estos experimentos barren $d_G$, la mediana y el rango intercuartil se reportan como
    rangos sobre el barrido, en el mismo sentido que en @grambank-bpe-40-tabla. P99 y
    Máximo son el techo alcanzado.],
)<referencia-semillas-tabla>
