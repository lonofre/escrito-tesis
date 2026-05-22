== Conjunto de características utilizadas en Grambank

#{
  set text(size: 10pt)

  let features = csv("datos/grambank-features.csv")

  table(
    columns: (auto, 1fr),
    align: (center, left),
    stroke: none,
    inset: (x: 7pt, y: 5pt),
    fill: (x, y) => if y == 0 { none } else if calc.odd(y) { luma(245) } else { white },
    table.hline(stroke: 1pt),
    table.header(
      [*Rasgo*], [*Descripción*],
    ),
    table.hline(stroke: 0.5pt),
    ..features.flatten(),
    table.hline(stroke: 1pt),
  )
}