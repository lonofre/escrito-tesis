= Conjunto de características utilizadas en WALS

#{
  set text(size: 11pt)

  show figure: set block(breakable: true)

  let features = (
    ("20A", [Fusión de formativos flexivos seleccionados]),
    ("22A", [Síntesis flexiva]),
    ("26A", [Prefijación vs. sufijación en la morfología flexiva]),
    ("28A", [Sincretismo de caso]),
    ("29A", [Sincretismo en la marcación de persona/número verbal]),
    ("49A", [Número de casos]),
    ("59A", [Clasificación posesiva]),
    ("65A", [Aspecto perfectivo/imperfectivo]),
    ("66A", [El tiempo pasado]),
    ("67A", [El tiempo futuro]),
    ("69A", [Posición de los afijos de tiempo/aspecto]),
    ("70A", [El imperativo morfológico]),
    ("78A", [Codificación de la evidencialidad]),
    ("102A", [Marcación de persona verbal]),
    ("112A", [Morfemas negativos]),
  )

  [
    #figure(
      table(
        columns: (auto, 1fr),
        align: (center, left),
        stroke: none,
        inset: (x: 7pt, y: 5pt),
        table.hline(stroke: 0.5pt),
        table.header(
          [*Característica*], [*Nombre*],
        ),
        table.hline(stroke: 0.5pt),
        ..features.map(((code, name)) => (code, name)).flatten(),
        table.hline(stroke: 0.5pt),
      ),
      caption: [Características de WALS usadas para describir tipología morfológica. Tomado de @ximena-bpe-2023.],
    )<wals-features>
  ]
}
