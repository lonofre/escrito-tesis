== Conjunto de características utilizadas en Grambank

#let features = csv("datos/grambank-features.csv").slice(0, 40)

#table(
  columns: (auto, auto),
  align: left,
  stroke: none,
  table.header(
    [*Rasgo*], [*Nombre*],
    table.hline(stroke: 1pt + black)
  ),
  ..features.flatten()
)