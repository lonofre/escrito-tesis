// Diagrama de ejemplo de entrenamiento de BPE: muestra, paso a paso, cómo
// se van fusionando los caracteres de un corpus de juguete.
// Los merges los saqué al poner la frase aquí: https://bpe-playground.vercel.app/

#let space = "␣" // símbolo que representa un espacio dentro del corpus

// Corpus de juguete: cada palabra se separa en caracteres; a todas menos la
// primera se les antepone el símbolo de espacio, como token propio.
#let word-list = ("tres", "tristes", "tigres", "trituraban", "trigo", "en", "un", "trigal")

#let pretokens-iniciales = word-list.enumerate().map(((i, w)) => {
  let chars = w.clusters()
  if i == 0 { chars } else { (space,) + chars }
})

// Reglas de fusión aprendidas, en orden.
#let merges = (
  ("t", "r"),
  (space, "tr"),
  (space + "tr", "i"),
  ("e", "s"),
  (space + "tr" + "i", "g"),
)

// Aplica una regla de fusión (a, b) -> ab sobre una palabra, de izquierda a
// derecha y sin traslapes. `sources` guarda, por token, el índice de la
// fusión que lo creó (0 si es un carácter original).
#let aplicar-fusion(tokens, sources, a, b, idx) = {
  let out-t = ()
  let out-s = ()
  let i = 0
  while i < tokens.len() {
    if i < tokens.len() - 1 and tokens.at(i) == a and tokens.at(i + 1) == b {
      out-t.push(a + b)
      out-s.push(idx)
      i += 2
    } else {
      out-t.push(tokens.at(i))
      out-s.push(sources.at(i))
      i += 1
    }
  }
  (out-t, out-s)
}

// `pasos` guarda, para cada paso (0 = estado inicial, k = tras la fusión k),
// la lista de palabras representadas como (tokens, sources).
#let pasos = {
  let estado = pretokens-iniciales.map(chars => (chars, chars.map(_ => 0)))
  let out = (estado,)
  for (idx, (a, b)) in merges.enumerate() {
    estado = estado.map(((tokens, sources)) => aplicar-fusion(tokens, sources, a, b, idx + 1))
    out.push(estado)
  }
  out
}

#let merge-colors = (
  rgb("#f6b26b"), // fusión 1
  rgb("#a4c2e8"), // fusión 2
  rgb("#9fd8a8"), // fusión 3
  rgb("#f4a3b0"), // fusión 4
  rgb("#c8b6e6"), // fusión 5
)

#let gris-claro = rgb("#f7f7f7") // relleno de las cajas que no son la fusión actual
#let gris-borde = rgb("#cccccc") // borde de las cajas que no son la fusión actual

#let tok-box(t, src, paso-actual) = {
  let es-actual = src == paso-actual and src != 0
  let fill = if es-actual { merge-colors.at(src - 1) } else { gris-claro }
  let color-borde = if es-actual { black } else { gris-borde }
  let grosor = if es-actual { 0.7pt } else { 0.6pt }
  box(
    inset: (x: 4pt, y: 5pt),
    stroke: grosor + color-borde,
    radius: 0pt,
    fill: fill,
    baseline: 0pt,
    text(size: 9pt, t),
  )
}

#let gap-cajas = 1.5pt // separación entre cajas, para que se distingan como celdas

#let fila(estado, paso-actual) = {
  estado.map(palabra => {
    let (tokens, sources) = palabra
    // Cada palabra se agrupa en una sola caja para que el salto de línea
    // ocurra entre palabras y nunca corte una palabra a la mitad.
    box(tokens.zip(sources).map(((t, s)) => tok-box(t, s, paso-actual)).join(h(gap-cajas)))
  }).join(h(gap-cajas, weak: true))
}

#let etiqueta(idx) = {
  set text(size: 11pt)
  if idx == 0 {
    [*Estado inicial*]
  } else {
    let (a, b) = merges.at(idx - 1)
    [*Fusión #idx:* #raw(a) + #raw(b) #sym.arrow #raw(a + b)]
  }
}

// `width` controla el ancho que ocupa la figura (por defecto, 100% del contenedor).
#let bpe-ejemplo-diagrama(width: 100%) = {
  set text(size: 10pt)
  block(
    width: width,
    stack(
      spacing: 12pt,
      ..pasos.enumerate().map(((idx, estado)) => stack(
        spacing: 3pt,
        etiqueta(idx),
        par(justify: false, fila(estado, idx)),
      ))
    ),
  )
}
