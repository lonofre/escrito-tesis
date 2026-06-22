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

// Genera un diagrama con dos boxplots comparativos
#let paired-boxplot(file, label1: [], label2: [], color2: rgb("#284987")) = {
  let data = json(file)

  lq.diagram(
    width: 8cm,
    height: 8cm,
    margin: (x: 50%),
    ylabel: text(size: 11pt)[ARI],
    lq.boxplot(x:1, label: label1, outliers: "x", data.at(0)),
    lq.boxplot(x: 2, label: label2, outliers: "x", stroke: color2, data.at(1)),
    xaxis: (format-ticks: none)
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