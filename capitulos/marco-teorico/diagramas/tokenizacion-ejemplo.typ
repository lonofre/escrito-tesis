#import "@preview/cetz:0.5.2"

// Diagrama de ejemplo de tokenización a subpalabra: una caja con el texto
// original y, debajo, una fila de cajas con los tokens resultantes.
//
// Diagrama exportado. Envuélvelo en tu propia figura, por ejemplo:
//   #import "diagramas/tokenizacion-ejemplo.typ": ejemplo-tokenizacion
//   #figure(ejemplo-tokenizacion, caption: [...]) <fig-ejemplo>

#let ejemplo-tokenizacion = context {
  let input-text = "Las supernovas estallan en galaxias lejanas."
  // "␣" representa un espacio, para que sea visible dentro de la caja.
  let tokens = ("Las", "␣super", "nov", "as", "␣est", "allan", "␣en", "␣galax", "ias", "␣lej", "anas", ".")

  let fb = 9pt // tamaño de texto de la caja superior
  let ft = 9pt // tamaño de texto de las cajas de tokens
  let pad-x = 9pt // relleno horizontal de la caja superior
  let tok-pad-x = 5pt // relleno horizontal de las cajas de tokens
  let pad-y = 7pt // relleno vertical de las cajas
  let gap = 4.5pt // espacio entre cajas de tokens
  let arrow-gap = 26pt // espacio vertical para la flecha
  let arrow-tip-gap = 6pt // espacio entre la punta de la flecha y la fila de tokens
  let S = 1pt // grosor de trazo

  let tok-sizes = tokens.map(t => measure(text(size: ft, t)))
  let tok-widths = tok-sizes.map(s => s.width + 2 * tok-pad-x)
  let tok-h = calc.max(..tok-sizes.map(s => s.height)) + 2 * pad-y

  let total-w = tok-widths.fold(0pt, (a, b) => a + b) + (tok-widths.len() - 1) * gap

  let input-size = measure(text(size: fb, input-text))
  let input-w = input-size.width + 2 * pad-x
  let input-h = input-size.height + 2 * pad-y

  let row-b = 0pt // borde inferior de la fila de tokens
  let row-t = row-b + tok-h // borde superior de la fila de tokens
  let in-b = row-t + arrow-gap // borde inferior de la caja de entrada
  let in-t = in-b + input-h // borde superior de la caja de entrada

  cetz.canvas(length: 1pt, {
    import cetz.draw: *

    // caja superior: texto original
    rect((-input-w / 2, in-b), (input-w / 2, in-t), stroke: S, radius: 3)
    content((0pt, (in-b + in-t) / 2), text(size: fb, input-text))

    // flecha hacia la fila de tokens
    line((0pt, in-b), (0pt, row-t + arrow-tip-gap), mark: (end: ">", scale: 0.6), stroke: S )

    // fila de cajas de tokens, centrada bajo la flecha
    let cx = -total-w / 2
    for (w, t) in tok-widths.zip(tokens) {
      rect((cx, row-b), (cx + w, row-t), stroke: S, radius: 3)
      content((cx + w / 2, (row-b + row-t) / 2), text(size: ft, t))
      cx += w + gap
    }
  })
}
