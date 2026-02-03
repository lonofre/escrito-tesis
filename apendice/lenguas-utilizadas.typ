== Conjunto de lenguas utilizadas

#let language_table(contents) = {

  let language_data = ()
  for (iso639_3, grambank_id, wals_id) in contents {
    language_data += ((iso639_3, grambank_id, wals_id))
  }


  table(
    columns: 3,
    stroke: 0pt,
    row-gutter: 0pt,
    table.header(
      [*Lengua (Código ISO)*], [*Grambank ID*], [* WALS ID*],
      table.hline(stroke: 1pt + black)
    ),
    ..language_data
  )
}

#align(left)[
 #language_table(
    yaml("languages-complete.yaml")
  ) 
]



