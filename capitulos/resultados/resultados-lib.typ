#import "@preview/lilaq:0.6.0" as lq

// Este método genera un plot con múltiples box plots.
#let boxplot-from-csv(file, start: 30, end: 86) = {
  let rows = json(file).slice(start, end + 1)

  lq.diagram(
    width: 14cm,
    height: 6cm,
    xlabel: [$d_G$],
    ylabel: [ARI],
    lq.boxplot(
      outliers: "x",
      x: range(start, end + 1),
      outlier-size: 3pt,
      ..rows
    )
  )
}

// Genera un diagrama con dos boxplots comparativos. Los colores por entidad son los
// mismos que en las bandas anidadas (naranja = BPE, azul = X_0), para que una entidad
// conserve su color en todo el capítulo. `stroke` fija el color de la caja.
#let paired-boxplot(
  file-a, file-b, label1: [], label2: [],
  color1: rgb("#c05a17"), color2: rgb("#3a63b3"),
) = {
  // Cada archivo trae un único objeto de percentiles (sin barrido). Armamos la caja
  // en IQR (q1-q3) y los bigotes en P1-P99, igual que la convención de las bandas.
  let box(f) = {
    let o = json(f).at(0)
    (median: o.median, q1: o.q1, q3: o.q3,
     whisker-low: o.p1, whisker-high: o.p99, outliers: ())
  }

  lq.diagram(
    width: 8cm,
    height: 8cm,
    margin: (x: 50%),
    ylabel: text(size: 11pt)[ARI],
    lq.boxplot(x: 1, label: label1, stroke: color1, box(file-a)),
    lq.boxplot(x: 2, label: label2, stroke: color2, box(file-b)),
    xaxis: (format-ticks: none)
  )
}

// Bandas anidadas (fan chart) para comparar dos series (p. ej. BPE vs referencia X_0).
// Por serie se dibujan dos rellenos anidados: una banda exterior mín->máx (su borde
// superior es el "techo" alcanzado) y una banda interior IQR (q1-q3) más marcada.
// Todo son rellenos: el color codifica la serie y la leyenda cuelga de la banda IQR.
//
// Entrada: dos JSON, cada uno un arreglo de objetos {max, min, q1, q3, ...}, uno por
// d_G, donde el índice del arreglo ES d_G (índice 30 -> d_G = 30). `start`/`end` recortan
// con slice semiabierto [start, end); por defecto cubren d_G in [30, 80] (51 puntos).
#let nested-overlay(
  file-a, file-b,
  label-a: [BPE], label-b: [$X_0$],
  start: 30, end: 81,
) = {
  let xs = range(start, end)
  let load(f) = json(f).slice(start, end)
  let a = load(file-a)
  let b = load(file-b)
  let col(rows, key) = rows.map(r => r.at(key))

  // Serie A (BPE): naranja. Serie B (X_0): azul. Par validado (ΔE ~23, CVD ok).
  let a-out  = rgb(192, 90, 23, 50)
  let a-in   = rgb(192, 90, 23, 110)
  let b-out  = rgb(58, 99, 179, 50)
  let b-in   = rgb(58, 99, 179, 110)

  lq.diagram(
    width: 14cm,
    height: 6cm,
    xlabel: [$d_G$],
    ylabel: [ARI],

    // Bandas exteriores (mín -> máx): la extensión completa.
    lq.fill-between(xs, col(a, "p99"), y2: col(a, "p1"), fill: a-out),
    lq.fill-between(xs, col(b, "p99"), y2: col(b, "p1"), fill: b-out),

    // Bandas interiores (IQR): dónde vive el grueso de las corridas. Llevan la leyenda.
    lq.fill-between(xs, col(a, "q3"), y2: col(a, "q1"), fill: a-in, label: label-a),
    lq.fill-between(xs, col(b, "q3"), y2: col(b, "q1"), fill: b-in, label: label-b),
  )
}

// Bandas anidadas de UNA sola serie (experimentos auxiliares sin referencia X_0):
// banda exterior mín->máx y banda interior IQR de un mismo experimento.
#let nested-band(file, label: [], hue: rgb("#2f7d78"), start: 30, end: 81) = {
  let xs = range(start, end)
  let rows = json(file).slice(start, end)
  let col(key) = rows.map(r => r.at(key))

  let c-out = hue.transparentize(80%)
  let c-in  = hue.transparentize(55%)

  lq.diagram(
    width: 14cm,
    height: 6cm,
    xlabel: [$d_G$],
    ylabel: [ARI],

    lq.fill-between(xs, col("p99"), y2: col("p1"), fill: c-out),
    lq.fill-between(xs, col("q3"),  y2: col("q1"),  fill: c-in, label: label),
  )
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