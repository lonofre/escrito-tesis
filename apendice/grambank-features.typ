= Conjunto de características utilizadas en Grambank <grambank-features>

La @grambank-features-tabla muestra las características de Grambank usadas en los experimentos, ordenadas de mayor a menor según el número de lenguas (@tabla-de-lenguas) para las que Grambank reporta un valor.

#{
  set text(size: 11pt)

  show figure: set block(breakable: true)

  let features = csv("datos/grambank-features.csv")

  [
    #figure(
      table(
        columns: (auto, 1fr),
        align: (center, left),
        stroke: none,
        inset: (x: 7pt, y: 5pt),
        table.hline(stroke: 0.5pt),
        table.header(
          [*Rasgo*], [*Descripción*],
        ),
        table.hline(stroke: 0.5pt),
        ..features.flatten(),
        table.hline(stroke: 0.5pt),
      ),
      caption: [Características de Grambank usadas en los experimentos.],
    ) <grambank-features-tabla>
  ]
}