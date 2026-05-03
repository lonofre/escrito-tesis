#import "@preview/lilaq:0.6.0" as lq


// Este método 
#let bands-diagram(dir, xs) = {
  let start = 25 + 5
  let end = (80 + 1) + 5 
  let p5  = lq.load-txt(read(dir + "/p5.csv")).at(0).slice(start, end)
  let p25 = lq.load-txt(read(dir + "/p25.csv")).at(0).slice(start, end)
  let p50 = lq.load-txt(read(dir + "/p50.csv")).at(0).slice(start, end)
  let p75 = lq.load-txt(read(dir + "/p75.csv")).at(0).slice(start, end)
  let p95 = lq.load-txt(read(dir + "/p95.csv")).at(0).slice(start, end)
  let mx  = lq.load-txt(read(dir + "/max.csv")).at(0).slice(start, end)
  let mn  = lq.load-txt(read(dir + "/min.csv")).at(0).slice(start, end)

  lq.diagram(
    width: 15cm,
    height: 8cm,
    lq.fill-between(xs, p95, y2: p5,  label: [P5-95]),
    lq.fill-between(xs, p75, y2: p25, label: [Q1-Q3]),
    lq.plot(xs, p50, label: [Mediana]),
    lq.plot(xs, mn,  label: [Mín]),
    lq.plot(xs, mx,  label: [Max]),
  )
}


#let xs = range(30, 81)


= Resultados

== BPE vs WALS+Grambank
== BPE vs WALS

#let x = lq.load-txt(read("datos/wals-bpe-ari.csv"))
#let x2 = lq.load-txt(read("datos/wals-bpe-random-ari.csv"))

#figure(
  lq.diagram(
    width: 8cm,
    height: 8cm,
    margin: (x: 50%),
    lq.boxplot(
      x: 1,
      x.at(0),
      stroke: blue,
      label: [$X_"BPE"$ vs $X_"WALS"$]
    ),
    lq.boxplot(
      x: 2,
      x2.at(0),
      stroke: red,
      label: [$X_"BPE-r"$ vs $X_"WALS"$]
    )
  ),
  caption: [Resultados de los valores de ARI.]
)<wals-bpe-plot>

// Los detalles de los resultados se pueden leer mejor en los notebooks, por lo que si es necesario editar, chécalos ahí
// TODO: Checar traducción de box plot por normativas de ciencias
La @wals-bpe-plot muestra el box plot.


== BPE vs Grambank

#bands-diagram("datos/grambank-bpe-bands", xs)
#bands-diagram("datos/grambank-bpe-random-bands", xs)

== Grambank vs Lang2Vec 


#pagebreak()