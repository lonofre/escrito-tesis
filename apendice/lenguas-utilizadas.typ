== Conjunto de lenguas utilizadas

#set text(size: 11pt)

#let language_table(contents) = {

  let language_data = ()
  for (iso639_3, grambank_id, wals_id) in contents {
    language_data += ((iso639_3, grambank_id, wals_id))
  }


  table(
    columns: 3,
    table.header(
      [*Lengua (Código ISO)*], [*ID en Grambank*], [*ID en WALS*]
    ),
    ..language_data
  )
}

#language_table(
  yaml("languages-complete.yaml")
)


