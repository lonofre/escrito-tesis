#import "@preview/lilaq:0.6.0" as lq

// Genera un diagrama con dos boxplots comparativos. Los colores por entidad son los
// mismos que en las bandas anidadas (naranja = BPE, azul = X_0), para que una entidad
// conserve su color en todo el capítulo. `stroke` fija el color de la caja.
#let paired-boxplot(
  file-a, file-b, label1: [], label2: [],
  color1: rgb("#c05a17"), color2: rgb("#3a63b3"),
) = {
  // Cada archivo trae un único objeto de percentiles (sin barrido). Armamos la caja
  // en IQR (q1-q3) y los bigotes en P1-P99, igual que la convención de las bandas.
  // Mín y máx se marcan como "outliers": círculos tenues, igual que el halo de las
  // bandas anidadas marca dónde vive el máximo.
  let box(f) = {
    let o = json(f).at(0)
    (median: o.median, q1: o.q1, q3: o.q3,
     whisker-low: o.p1, whisker-high: o.p99, outliers: (o.min, o.max))
  }

  lq.diagram(
    width: 8cm,
    height: 8cm,
    margin: (x: 50%),
    ylabel: text(size: 11pt)[ARI],
    lq.boxplot(
      x: 1, label: label1, stroke: color1, box(file-a),
      outlier-fill: none, outlier-stroke: color1.transparentize(45%), outlier-size: 4pt,
    ),
    lq.boxplot(
      x: 2, label: label2, stroke: color2, box(file-b),
      outlier-fill: none, outlier-stroke: color2.transparentize(45%), outlier-size: 4pt,
    ),
    xaxis: (format-ticks: none)
  )
}

// Bandas anidadas (fan chart) para comparar dos series (p. ej. BPE vs referencia X_0).
// Por serie se dibujan dos rellenos anidados: una banda exterior mín->máx (su borde
// superior es el "techo" alcanzado) y una banda interior IQR (q1-q3) más marcada.
// Todo son rellenos: el color codifica la serie y la leyenda cuelga de la banda IQR.
//
// Entrada: dos JSON, cada uno un arreglo de objetos {max, min, q1, q3, ...}, uno por
// d_G. El barrido que generó estos JSON arrancó en d_G = 5, así que el índice 0 del
// arreglo es d_G = 5 (índice i -> d_G = i + 5). `start`/`end` expresan d_G directamente
// y se corrigen con ese desfase antes de recortar; por defecto cubren d_G in [30, 85]
// (56 puntos).
#let n-offset = 5
#let nested-overlay(
  file-a, file-b,
  label-a: [BPE], label-b: [$X_0$],
  start: 30, end: 85 + 1,
) = {
  let xs = range(start, end)
  let load(f) = json(f).slice(start - n-offset, end - n-offset)
  let a = load(file-a)
  let b = load(file-b)
  let col(rows, key) = rows.map(r => r.at(key))

  // Serie A (BPE): naranja. Serie B (X_0): azul. Par validado (ΔE ~23, CVD ok).
  let a-halo = rgb(192, 90, 23, 18)
  let a-out  = rgb(192, 90, 23, 85)
  let a-in   = rgb(192, 90, 23, 170)
  let b-halo = rgb(58, 99, 179, 18)
  let b-out  = rgb(58, 99, 179, 85)
  let b-in   = rgb(58, 99, 179, 170)

  lq.diagram(
    width: 14cm,
    height: 6cm,
    xlabel: [$d_G$],
    ylabel: [ARI],

    // Halo más exterior (mín -> máx): dónde vive el máximo, muy tenue.
    lq.fill-between(xs, col(a, "max"), y2: col(a, "min"), fill: a-halo),
    lq.fill-between(xs, col(b, "max"), y2: col(b, "min"), fill: b-halo),

    // Bandas exteriores (P1 -> P99): la extensión completa.
    lq.fill-between(xs, col(a, "p99"), y2: col(a, "p1"), fill: a-out),
    lq.fill-between(xs, col(b, "p99"), y2: col(b, "p1"), fill: b-out),

    // Bandas interiores (IQR): dónde vive el grueso de las corridas. Llevan la leyenda.
    lq.fill-between(xs, col(a, "q3"), y2: col(a, "q1"), fill: a-in, label: label-a),
    lq.fill-between(xs, col(b, "q3"), y2: col(b, "q1"), fill: b-in, label: label-b),
  )
}

// Bandas anidadas de UNA sola serie (experimentos auxiliares sin referencia X_0):
// banda exterior mín->máx y banda interior IQR de un mismo experimento.
#let nested-band(file, label: [], hue: rgb("#2f7d78"), start: 30, end: 85 + 1) = {
  let xs = range(start, end)
  let rows = json(file).slice(start - n-offset, end - n-offset)
  let col(key) = rows.map(r => r.at(key))

  let c-halo = hue.transparentize(93%)
  let c-out  = hue.transparentize(67%)
  let c-in   = hue.transparentize(33%)

  lq.diagram(
    width: 14cm,
    height: 6cm,
    xlabel: [$d_G$],
    ylabel: [ARI],

    // Halo más exterior (mín -> máx): dónde vive el máximo, muy tenue.
    lq.fill-between(xs, col("max"), y2: col("min"), fill: c-halo),

    lq.fill-between(xs, col("p99"), y2: col("p1"), fill: c-out),
    lq.fill-between(xs, col("q3"),  y2: col("q1"),  fill: c-in, label: label),
  )
}

// Gráfica de barras del ranking de características de Grambank por ARI promedio
// (BPE vs X_0), una barra por característica coloreada según su categoría.
// `posiciones`: lista opcional de posiciones a incluir (p. ej. range(1, 11) para el
// top 10).
#let categorias-grambank = (
  // Morfología: azul pleno y saturado, la única serie fría y a opacidad total, para
  // que se identifique de un vistazo. Sintaxis y morfosintaxis: dos tonos cálidos
  // bien separados en matiz (naranja vs. púrpura rojizo) y atenuados con alfa.
  ("morfología", rgb(0, 92, 197), [Morfología]),
  ("sintaxis", rgb(230, 159, 0, 115), [Sintaxis]),
  ("morfosintaxis", rgb(204, 121, 167, 115), [Morfosintaxis]),
)

#let bar-ari-grambank(
  path: "datos/analisis/avg_ari_grambank-bpe_39_100_traducido.csv",
  posiciones: none,
) = {
  let filas = csv(path, row-type: dictionary).filter(fila =>
    posiciones == none or int(fila.position) in posiciones
  )
  let etiquetas = filas.map(fila => fila.feature)

  [
    #show: lq.show_(
      lq.tick-label.with(kind: "x"),
      it => box(width: 0pt, align(center, rotate(-90deg, reflow: true, text(size: 9pt)[#it]))),
    )
    #lq.diagram(
      width: 16cm,
      height: 8cm,
      ylabel: [ARI promedio],
      xaxis: (ticks: etiquetas.enumerate(), subticks: none),
      legend: lq.legend(
        [], text(weight: "bold")[Categoría],
        ..categorias-grambank.map(((cat, color, label)) => (
          box(width: 8pt, height: 8pt, fill: color, stroke: 0.4pt + color.darken(30%)),
          label,
        )).flatten(),
      ),
      ..categorias-grambank.map(((cat, color, label)) => {
        let idx = range(filas.len()).filter(i => filas.at(i).category == cat)
        lq.bar(
          idx,
          idx.map(i => float(filas.at(i).avg_ari)),
          fill: color,
          stroke: 0.4pt + color.darken(30%),
          label: label,
        )
      }),
      // Asterisco sobre las barras con patrón morfológico productivo (comment
      // == "productividad"), como marca ortogonal a la categoría.
      {
        let idx = range(filas.len()).filter(i => filas.at(i).comment == "productividad")
        lq.scatter(
          idx,
          idx.map(i => calc.max(float(filas.at(i).avg_ari), 0) + 0.006),
          mark: "a6",
          color: black,
          size: 8pt,
        )
      },
    )
  ]
}

// Este método crea un band plot dado el directorio.
// Esta es la opción A para representar los datos.
#let bands-diagram(dir, start: 30, end: 86) = {
  let p5  = lq.load-txt(read(dir + "/p5.csv")).at(0).slice(start, end)
  let p25 = lq.load-txt(read(dir + "/p25.csv")).at(0).slice(start, end)
  let p50 = lq.load-txt(read(dir + "/p50.csv")).at(0).slice(start, end)
  let p75 = lq.load-txt(read(dir + "/p75.csv")).at(0).slice(start, end)
  let p95 = lq.load-txt(read(dir + "/p95.csv")).at(0).slice(start, end)
  let mx  = lq.load-txt(read(dir + "/max.csv")).at(0).slice(start, end)
  let mn  = lq.load-txt(read(dir + "/min.csv")).at(0).slice(start, end)


  let xs = range(start, end)

  lq.diagram(
    width: 14cm,
    height: 5cm,
    lq.fill-between(xs, p95, y2: p5,  label: [P5-95], fill: rgb("#c2e0f2")),
    lq.fill-between(xs, p75, y2: p25, label: [Q1-Q3], fill: rgb("#a6c5d8")),
    lq.plot(xs, p50, label: [Mediana], color: rgb(0, 0, 0)),
    lq.plot(xs, mn,  label: [Mín]),
    lq.plot(xs, mx,  label: [Max]),
  )
}