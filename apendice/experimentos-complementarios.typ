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
