= Conjunto de lenguas utilizadas

#{
  set text(size: 10pt)

  let data = yaml("datos/languages-complete.yaml")
  let or_dash(v) = if v == "" { "—" } else { v }

  // Esto hace que la combinación de figura + tabla larga de vea bien.
  show figure: set block(breakable: true)

  [
    #figure(table(
      columns: (1fr, auto, auto, auto),
      align: (left, center, center, center),
      stroke: none,
      inset: (x: 7pt, y: 5pt),
      table.hline(stroke: 0.5pt),
      table.header(
        [*Lengua*], [*ISO 639-3*], [*Grambank ID*], [*WALS ID*],
      ),
      table.hline(stroke: 0.5pt),
      ..data.map(lang => (
        lang.name,
        lang.iso639_3,
        or_dash(lang.grambank_id),
        or_dash(lang.wals_id),
      )).flatten(),
      table.hline(stroke: 0.5pt),
    ),
    caption: [Lenguas usadas en los experimentos.],
    )<tabla-de-lenguas>
  ]
}

