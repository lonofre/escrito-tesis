#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// Diagrama que ilustra por qué las subpalabras ayudan con las palabras OOV.
// Arriba: una palabra del vocabulario se divide en dos piezas que son más
// frecuentes que la palabra completa. Abajo: una palabra nunca observada se
// segmenta con esas mismas piezas más un prefijo.
//
// Diagrama exportado. Envuélvelo en tu propia figura, por ejemplo:
//   #import "diagramas/subpalabras-oov.typ": subpalabras-oov-diagrama
//   #figure(subpalabras-oov-diagrama, caption: [...]) <fig-subpalabras-oov>

// Colores pensados para fondo blanco: relleno claro y borde del mismo tono.
#let gris = (fill: rgb("#ededed"), stroke: 0.6pt + rgb("#8f8f8f"))
#let verde = (fill: rgb("#cfe8d6"), stroke: 0.6pt + rgb("#4c8c5e"))
#let morado = (fill: rgb("#ddd6f0"), stroke: 0.6pt + rgb("#6f5aa8"))
#let naranja = (fill: rgb("#f8dfc2"), stroke: 0.6pt + rgb("#c07f33"))

#let ancho-palabra = 3.9cm // caja de la palabra completa
#let ancho-pieza = 2.6cm // cajas de las subpalabras
#let ancho-nota = 3cm // texto suelto debajo de las cajas

// Contenido de una caja: la cadena y, debajo, su frecuencia o una aclaración.
#let caja(pieza, detalle: none) = align(center, {
  text(size: 10pt, pieza)
  if detalle != none {
    linebreak()
    text(size: 8pt, detalle)
  }
})

#let titulo(t) = text(size: 9pt, weight: "bold", t)
#let nota(t, ancho: ancho-nota) = box(width: ancho, align(center, text(size: 8pt, t)))
// Aviso de que los números del diagrama no vienen de ningún corpus.
#let aviso(t) = box(width: 7.5cm, align(center, text(size: 8pt, style: "italic", fill: rgb("#6b6b6b"), t)))

#let subpalabras-oov-diagrama = diagram(
  spacing: (5mm, 5mm),
  node-inset: 7pt,
  node-corner-radius: 3pt,
  node-shape: "rect",
  edge-stroke: 0.6pt + rgb("#555555"),

  // --- Palabra que sí está en el vocabulario ---
  node((1, 0), titulo[Palabra dentro del vocabulario]),
  node((1, 1), caja("created", detalle: [fr = 10]), width: ancho-palabra, ..gris),

  node((0.5, 3), caja("creat", detalle: [fr = 40]), width: ancho-pieza, ..verde),
  node((1.5, 3), caja("ed", detalle: [fr = 100]), width: ancho-pieza, ..morado),

  edge((1, 1), (1, 2), (0.5, 2), (0.5, 3), "->"),
  edge((1, 1), (1, 2), (1.5, 2), (1.5, 3), "->"),

  node((0.5, 4), nota[también en _creation_, _creature_, _create_...]),
  node((1.5, 4), nota[también en _walked_, _played_, _jumped_...]),

  // --- Separador entre los dos casos ---
  edge((-0.2, 5), (2.2, 5), stroke: 0.5pt + rgb("#bbbbbb"), dash: "dashed", snap-to: (none, none)),

  // --- Palabra fuera del vocabulario ---
  node((1, 6), titulo[Palabra fuera del vocabulario (OOV)]),
  node((1, 7), caja("recreated", detalle: [nunca observada completa]), width: ancho-palabra, ..gris),

  node((0, 9), caja("re"), width: 1.8cm, ..naranja),
  node((1, 9), caja("creat"), width: ancho-pieza, ..verde),
  node((2, 9), caja("ed"), width: 1.8cm, ..morado),

  edge((1, 7), (1, 8), (0, 8), (0, 9), "->"),
  edge((1, 7), (1, 8), (1, 9), "->"),
  edge((1, 7), (1, 8), (2, 8), (2, 9), "->"),

  node((1, 10), nota(ancho: 7.5cm)[el modelo nunca vio _recreated_, pero sí sus piezas, así que puede representarla sin salirse del vocabulario]),
)
