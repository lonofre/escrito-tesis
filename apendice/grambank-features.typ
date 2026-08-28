= Conjunto de características utilizadas en Grambank <grambank-features>

#{
  set text(size: 11pt)

  let features = csv("datos/grambank-features.csv")

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
  )
}