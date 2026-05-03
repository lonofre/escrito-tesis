#import "@preview/lilaq:0.6.0" as lq

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
== Grambank vs Lang2Vec 


#pagebreak()