#import "@preview/cetz:0.5.2"

// Diagrama de la arquitectura Transformer de Vaswani et al. (2017),
// "Attention is all you need", dibujado con cetz.

#let c-attn = rgb("#f6b26b") // Atención multi-cabeza (naranja)
#let c-norm = rgb("#f9e08a") // Suma y normalización (amarillo)
#let c-ff = rgb("#a4c2e8") // Red prealimentada (azul)
#let c-emb = rgb("#f4a3b0") // Embedding (rosa)
#let c-lin = rgb("#c8b6e6") // Lineal (morado)
#let c-soft = rgb("#9fd8a8") // Softmax (verde)
#let c-grey = rgb("#efefef") // Bloque N× (gris)

// Diagrama exportado. Envuélvelo en tu propia figura, por ejemplo:
//   #import "diagramas/transformer.typ": transformer-diagrama2
//   #figure(transformer-diagrama2, caption: [...]) <transformer>
//
// Se dibuja con cetz para acercarse a la figura original del paper: bloques
// grises N×, barras "Suma y norm." apiladas sobre cada subcapa y conexiones
// residuales que las rodean.
#let transformer-diagrama2 = {
  let k = 0.72 // factor de escala global (≈ mitad del área; geometría, tipografía y trazos)
  cetz.canvas(length: k * 1cm, {
  import cetz.draw: *

  let ex = 0 // centro del codificador
  let dx = 7 // centro del decodificador
  let bw = 3.2 // ancho de caja
  let gw = 2.25 // media anchura de las cajas grises N×
  let S = 1.5pt * k // grosor principal (cajas y flechas)
  let Sg = 1.1pt * k // grosor de las cajas grises
  let fb = 8pt * k // texto de las cajas
  let fn = 9pt * k // etiqueta N×
  let fp = 7.5pt * k // "Codificación posicional"
  let fo = 10pt * k // símbolo +

  // ----- parámetros de disposición vertical -----
  let hA = 1.0 // altura de una subcapa (atención / red prealimentada)
  let hN = 0.5 // altura de una barra "Suma y norm."
  let gs = 0.32 // hueco entre una subcapa y su "Suma y norm."
  let gu = 0.55 // hueco entre unidades (Suma y norm. -> siguiente subcapa)
  let gp = 0.4 // hueco de las cajas finales (Lineal, Softmax)
  let pad = 0.28 // margen interno de las cajas grises
  let ro = 2.1 // alcance horizontal de los residuales (línea vertical alejada de la caja
  //           para que la punta de flecha no choque con ella)

  // posiciones (borde inferior) de cada bloque, apiladas con los huecos
  let e_mha_b = 2.7
  let e_an1_b = e_mha_b + hA + gs
  let e_ff_b = e_an1_b + hN + gu
  let e_an2_b = e_ff_b + hA + gs
  let e_top = e_an2_b + hN

  let d_mmha_b = 2.7
  let d_an1_b = d_mmha_b + hA + gs
  let d_cmha_b = d_an1_b + hN + gu
  let d_an2_b = d_cmha_b + hA + gs
  let d_ff_b = d_an2_b + hN + gu
  let d_an3_b = d_ff_b + hA + gs
  let d_top = d_an3_b + hN
  let d_lin_b = d_top + pad + gp
  let d_soft_b = d_lin_b + 0.8 + gp

  // caja centrada por su borde inferior
  let box-b(cx, b, h, fillc, body, name) = {
    rect((cx - bw / 2, b), (cx + bw / 2, b + h),
      fill: fillc, stroke: S, radius: 0.12, name: name)
    content((cx, b + h / 2), align(center, text(size: fb, body)))
  }

  let arr(..pts) = line(..pts, mark: (end: ">", scale: 0.5), stroke: S)
  let conn(cx, y0, y1) = arr((cx, y0), (cx, y1)) // conector recto entre cajas

  let oplus(cx, cy, name) = {
    circle((cx, cy), radius: 0.3, fill: white, stroke: S, name: name)
    content((cx, cy), text(size: fo)[$+$])
  }

  // abanico de 3 flechas (Q, K, V) desde el punto inferior hacia la caja
  let fan-qkv(cx, y1) = {
    let y0 = y1 - 0.35
    line((cx, y0 - 0.15), (cx, y0), stroke: S)
    bezier((cx, y0), (cx - 0.55, y1), (cx - 0.55, y0), mark: (end: ">", scale: 0.5), stroke: S)
    bezier((cx, y0), (cx, y1), (cx, (y0 + y1) / 2), mark: (end: ">", scale: 0.5), stroke: S)
    bezier((cx, y0), (cx + 0.55, y1), (cx + 0.55, y0), mark: (end: ">", scale: 0.5), stroke: S)
  }

  // residual: rodea una subcapa desde su entrada (ya) hasta la barra "Suma y norm." (yb)
  let residual(cx, ya, yb, dir) = arr(
    (cx, ya), (cx + dir * ro, ya),
    (cx + dir * ro, yb), (cx + dir * (bw / 2), yb),
  )

  // ----- Bloques grises N× -----
  rect((ex - gw, e_mha_b - pad), (ex + gw, e_top + pad), fill: c-grey, stroke: (paint: gray, thickness: Sg), radius: 0.15)
  rect((dx - gw, d_mmha_b - pad), (dx + gw, d_top + pad), fill: c-grey, stroke: (paint: gray, thickness: Sg), radius: 0.15)
  content((ex - gw - 0.3, (e_mha_b + e_top) / 2), text(size: fn, weight: "bold")[N$times$])
  content((dx + gw + 0.3, (d_mmha_b + d_top) / 2), text(size: fn, weight: "bold")[N$times$])

  // ----- Codificador -----
  content((ex, -0.55), text(size: fb, style: "italic")[Entradas])
  box-b(ex, 0.05, 0.9, c-emb, [Embedding\ de entrada], "e-emb")
  oplus(ex, 1.9, "e-pe")
  box-b(ex, e_mha_b, hA, c-attn, [Atención\ multi-cabeza], "e-mha")
  box-b(ex, e_an1_b, hN, c-norm, [Suma y norm.], "e-an1")
  box-b(ex, e_ff_b, hA, c-ff, [Red\ prealimentada], "e-ff")
  box-b(ex, e_an2_b, hN, c-norm, [Suma y norm.], "e-an2")

  content((ex - gw - 0.9, 1.9), align(center, text(size: fp)[Codificación\ posicional]))
  arr((ex - 1.9, 1.9), (ex - 0.32, 1.9))

  arr((ex, -0.35), (ex, 0.03))
  arr((ex, 0.95), (ex, 1.58))
  fan-qkv(ex, e_mha_b) // Q, K, V hacia la autoatención
  conn(ex, e_mha_b + hA, e_an1_b) // atención -> suma y norm.
  conn(ex, e_an1_b + hN, e_ff_b) // suma y norm. -> red prealimentada
  conn(ex, e_ff_b + hA, e_an2_b) // red prealimentada -> suma y norm.

  residual(ex, e_mha_b - 0.4, e_an1_b + hN / 2, -1)
  residual(ex, e_an1_b + hN + gu / 2, e_an2_b + hN / 2, -1)

  // ----- Decodificador -----
  content((dx, -0.85), align(center, text(size: fb, style: "italic")[Salidas\ (desplazadas)]))
  box-b(dx, 0.05, 0.9, c-emb, [Embedding\ de salida], "d-emb")
  oplus(dx, 1.9, "d-pe")
  box-b(dx, d_mmha_b, hA, c-attn, [Atención multi-cabeza\ enmascarada], "d-mmha")
  box-b(dx, d_an1_b, hN, c-norm, [Suma y norm.], "d-an1")
  box-b(dx, d_cmha_b, hA, c-attn, [Atención\ multi-cabeza], "d-cmha")
  box-b(dx, d_an2_b, hN, c-norm, [Suma y norm.], "d-an2")
  box-b(dx, d_ff_b, hA, c-ff, [Red\ prealimentada], "d-ff")
  box-b(dx, d_an3_b, hN, c-norm, [Suma y norm.], "d-an3")
  box-b(dx, d_lin_b, 0.8, c-lin, [Lineal], "d-lin")
  box-b(dx, d_soft_b, 0.8, c-soft, [Softmax], "d-soft")
  content((dx, d_soft_b + 0.8 + 0.7), align(center, text(size: fb)[Probabilidades\ de salida]))

  content((dx + gw + 0.9, 1.9), align(center, text(size: fp)[Codificación\ posicional]))
  arr((dx + 1.9, 1.9), (dx + 0.32, 1.9))

  arr((dx, -0.35), (dx, 0.03))
  arr((dx, 0.95), (dx, 1.58))
  fan-qkv(dx, d_mmha_b) // Q, K, V hacia la autoatención enmascarada
  conn(dx, d_mmha_b + hA, d_an1_b) // atención enmascarada -> suma y norm.
  conn(dx, d_cmha_b + hA, d_an2_b) // atención cruzada -> suma y norm.
  conn(dx, d_an2_b + hN, d_ff_b) // suma y norm. -> red prealimentada
  conn(dx, d_ff_b + hA, d_an3_b) // red prealimentada -> suma y norm.
  conn(dx, d_an3_b + hN, d_lin_b) // suma y norm. -> lineal
  conn(dx, d_lin_b + 0.8, d_soft_b) // lineal -> softmax
  conn(dx, d_soft_b + 0.8, d_soft_b + 0.8 + 0.28) // softmax -> probabilidades

  residual(dx, d_mmha_b - 0.4, d_an1_b + hN / 2, 1)
  residual(dx, d_an1_b + hN + gu / 2, d_an2_b + hN / 2, 1)
  residual(dx, d_an2_b + hN + gu / 2, d_an3_b + hN / 2, 1)

  // ----- Codificador -> decodificador: 3 entradas a la atención cruzada -----
  // K y V provienen del codificador; Q sube desde la subcapa anterior.
  let bx = dx - 1.9
  let cy = d_cmha_b - 0.27 // altura del reparto, en el hueco bajo la atención cruzada
  line((ex, e_top), (ex, e_top + pad + 0.2), (bx, e_top + pad + 0.2), (bx, cy), stroke: S)
  bezier((bx, cy), (dx - 0.55, d_cmha_b), (dx - 0.55, cy), mark: (end: ">", scale: 0.5), stroke: S) // K
  bezier((bx, cy), (dx, d_cmha_b), (dx, cy), mark: (end: ">", scale: 0.5), stroke: S) // V
  line((dx, d_an1_b + hN), (dx, cy), stroke: S)
  bezier((dx, cy), (dx + 0.55, d_cmha_b), (dx + 0.55, cy), mark: (end: ">", scale: 0.5), stroke: S) // Q
  })
}
