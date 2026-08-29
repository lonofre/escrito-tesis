= Experimentos complementarios <experimentos-complementarios>

== BPE frente a WALS sobre las lenguas de Grambank

El experimento de $X_"BPE"$ vs $X_W$ del capítulo de resultados usa las 47 lenguas del estudio, mientras que los experimentos con Grambank se limitaron a 38. Para descartar que esa diferencia explique el contraste entre unos y otros, repetimos la comparación restringida a esas 38 lenguas, sin cambiar nada más.

Con 38 lenguas, $X_"BPE"$ vs $X_W$ sigue por encima de su referencia, pero por un margen más estrecho (@wals-bpe-38-tabla). Baja tanto la mediana como el techo, y los rangos intercuartiles, que con 47 lenguas no se solapan, aquí sí lo hacen. La coincidencia se reduce, pero no desaparece, así que la conclusión del capítulo no depende de haber usado las 47 lenguas.

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

El experimento de $X_"BPE"$ vs $X_G$ del capítulo de resultados usa 38 lenguas, pues descartamos el coreano y el birmano por la forma en que su escritura agrupa letras en bloques silábicos. Para descartar que la coincidencia con $X_G$ dependa de esa exclusión, repetimos la comparación volviendo a incluir esas dos lenguas, con las 40 que Grambank cubre y sin cambiar nada más.

Con 40 lenguas, $X_"BPE"$ vs $X_G$ sigue por encima de su referencia (@grambank-bpe-40-tabla). Los valores bajan en ambas series, con el percentil 99 de $X_"BPE"$ pasando de $0.281$ a $0.232$ y el de la referencia de $0.112$ a $0.092$, así que la distancia entre las dos se mantiene. Agregar el coreano y el birmano reduce la magnitud, pero no la separación respecto a la referencia.

Cada referencia $X_0$ se generó sobre las lenguas de su propio experimento, así que las dos corridas aparecen juntas solo para leerlas en la misma escala.

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
