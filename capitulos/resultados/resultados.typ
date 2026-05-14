#import "@preview/lilaq:0.6.0" as lq

#let min_features = 0
#let max_features = 195


// Este método crea un band plot dado el directorio.
// Esta es la opción A para representar los datos.
#let bands-diagram(dir) = {

  // Este es el inicio de donde obtener los datos.
  // Como los datos no empiezan desde n = 0, por el momento el inicio está en n = 5
  let start = 25 + 5
  let end = (80 + 1) + 5 
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

// Este método genera un plot con múltiples box plots
#let boxplot-from-csv(file) = {
  // Este es el inicio de donde obtener los datos.
  // Como los datos no empiezan desde n = 0, por el momento el inicio está en n = 5
  let start = 25 + 5
  let end = (80 + 1) + 5 

  let rows = json(file).slice(start, end + 1)

  lq.diagram(
    width: 14cm,
    height: 6cm,
    lq.boxplot(
      outliers: "x",
      x: range(start, end + 1),
      outlier-size: 3pt,
      ..rows
    )
  )
}

= Resultados

== BPE vs WALS+Grambank

La @bpe-grambankwals-ari-plot representa cómo están distribuidos los valores de ARI de $X_"BPE"$ y $X_"Grambank"$ en base al criterio de selección de características. El número de características se encuentra entre #min_features y #max_features. La @bpe-random-grambank-ari-plot representa de manera similar lo que la figura anterior pero sustituyendo $X_"BPE"$ por $X_"BPE-r"$. Por lo que @bpe-random-grambankwals-ari-plot representa la base de referencia.

#figure(
  boxplot-from-csv("datos/grambankANDwals-bpe.json"),
  caption: [Resultados de los valores de ARI usando `syntax_wals`.]
)<bpe-grambankwals-ari-plot>

Como se observa en @bpe-grambankwals-ari-plot, el valor de las medianas de ARI está encima del 0. Se observa además que el rango de la mayoría de las configuraciones es entre -0.1 y 0.2. Además, se tienen valores outliers que superan el umbral de 0.5. Esto se puede observar en $n = 55, n = 56, n = 57, 58, 61, 62, 67$.

#figure(
  boxplot-from-csv("datos/grambankANDwals-bpe-random.json"),
  caption: [Resultados de los valores de ARI usando `syntax_knn`.]
)<bpe-random-grambankwals-ari-plot>

En contraste, @bpe-random-grambankwals-ari-plot, se observa que a partir de $n = 43$, el valor de la medianas se encuentran abajo del 0. En contraste con @bpe-grambankwals-ari-plot, sólo hay un outlier que supera el umbral de 0.3, y es cuando $n = 31$, mientras que en $n$ más grandes, esto no se vuelve a repetir. Si bien hasta $n = 48$ algunos de los valores (o pestaña) superan el umbra del 0.1, a partir de ahí los valores varían entre 0.1 y 0.5.

== BPE vs WALS

#let x = lq.load-txt(read("datos/wals-bpe-ari.csv"))
#let x2 = lq.load-txt(read("datos/wals-bpe-random-ari.csv"))

// TODO: Hacer más detallado esto
La @wals-bpe-plot representa cómo están distribuidos los valores de ARI calculados para $X_"BPE"$ y $X_"WALS"$ (izquierda), como para $X_"BPE-r"$ y $X_"WALS"$ (derecha) que representa la base de referencia.

#figure(
  lq.diagram(
    width: 8cm,
    height: 8cm,
    margin: (x: 50%),
    lq.boxplot(
      x: 1,
      x.at(0),
      label: [$X_"BPE"$ vs $X_"WALS"$],
      outliers: ","
    ),
    lq.boxplot(
      x: 2,
      x2.at(0),
      stroke: rgb("#284987"),
      label: [$X_"BPE-r"$ vs $X_"WALS"$],
      outliers: ","
    )
  ),
  caption: [Resultados de los valores de ARI.]
)<wals-bpe-plot>

// Los detalles de los resultados se pueden leer mejor en los notebooks, por lo que si es necesario editar, chécalos ahí
// TODO: Checar traducción de box plot por normativas de ciencias
Como se observa los datos ARI de $X_"BPE"$ y $X_"WALS"$, el 50% de los valores ARI se encuentran entre los rangos 0.0175 y 0.0837. El rango donde varían estos valores es entre -0.0631 y 0.1826. Hay que notar que @wals-bpe-plot tiene varios outliers, donde varios superan en valor de $0.20$. La media tiene un valor 0.0478. El máximo valor que alcanzó es 0.2939 y el mínimo -0.0631.

Sin embargo, para $X_"BPE-r"$ y $X_"WALS"$, el 50% de los datos se encuentran contenidos en un rango menor al anterior, pues está entre -0.0131 y 0.0175. A la vez, el rango de datos se encuentra entre -0.0591 y 0.0634. Por otro lado, los outliers, pero no superaron 0.15. La media es 0.0007. El máximo valor que alcanzó es 0.1386 y el mínimo -0.0753.

== BPE vs Grambank

// Este es el original. Quizá tengamos que repetir esto mismo en todos los que usen Grambank.
La @bpe-grambank-ari-plot representa cómo están distribuidos los valores de ARI de $X_"BPE"$ y $X_"Grambank"$ en base al criterio de selección de características. El número de características se encuentra entre #min_features y #max_features. La @bpe-random-grambank-ari-plot representa de manera similar lo que la figura anterior pero sustituyendo $X_"BPE"$ por $X_"BPE-r"$. Por lo que @bpe-random-grambank-ari-plot representa la base de referencia.

#figure(
  boxplot-from-csv("datos/grambank-bpe.json"),
  caption: [Resultados de los valores de ARI de BPE vs Grambank.]
)<bpe-grambank-ari-plot>

Se observa en @bpe-grambank-ari-plot que la mayoría de los valores independientemente del número de características se distribuyen entre los rangos de -0.1 y 0.2, con algunas excepciones después de $n =. 65$. Se observa además que la mediana no aumenta drásticamente al incrementar el número de características. Podemos observar varios outliers que superan el umbra de 0.4, como en $n = 56$, así como $n = 73, 74, 75, 76$. El valor de las medias se mantiene positivo. El bigote inferior pueden superar el umbral de -0.1, lo cual indica que hay más variabilidad de datos en esos $n$.


#figure(
  boxplot-from-csv("datos/grambank-bpe-random.json"),
  caption: [Resultados de los valores de ARI de BPE Aleatorio vs Grambank.]
)<bpe-random-grambank-ari-plot>

Por otra parte, se observa en @bpe-random-grambank-ari-plot que son pocos los outliers que cruzan el umbral de 0.25, que se encuentran antes de $n = 50$. De la misma manera, la mediana de ARI en muchos casos es negativa. Se observan que el bigote superior de la mayoría de las $n$ no superan el umbral de 0.1.

== Grambank vs WALS

La @grambank-wals-ari-plot representa cómo están distribuidos los valores de ARI de $X_"Grambank"$ y $X_"WALS"$ en base al criterio de selección de características. El número de características se encuentra entre #min_features y #max_features.

#figure(
  boxplot-from-csv("datos/grambank-wals.json"),
  caption: [Resultados de los valores de ARI.]
)<grambank-wals-ari-plot>

Se observa en @grambank-wals-ari-plot varios outliers entre 0.4 y 0.5. Se puede observar que las medianas son positivas, variando a un valor cercano a 0.05. Por otro lado, se obsevar que a partir de $n=45$, el bigote superior se encuentra encima del umbral de 0.2. Sin embargo, también hay una constante en los bigotes inferiores que suelen superar el valor de -0.1. 


== Grambank vs Lang2Vec
La @grambank-lang2vec-syntaxwals-ari-plot representa cómo están distribuidos los valores de ARI de $X_"Grambank"$ y $X_"lang2vec"$ con `syntax_wals`, en base al criterio de selección de características. El número de características se encuentra entre #min_features y #max_features. Mientras que @grambank-lang2vec-syntaxknn-ari-plot representa lo mismo pero usando el conjunto `syntax_knn`.

#figure(
  boxplot-from-csv("datos/grambank-lang2vec-syntax-wals.json"),
  caption: [Resultados de los valores de ARI usando `syntax_wals`.]
)<grambank-lang2vec-syntaxwals-ari-plot>

Se observa en @grambank-lang2vec-syntaxwals-ari-plot que las medias superan el umbral del 0.1. A su vez, los bigotes inferiores son menores que 0.1. Hay varios bigotes superiores que se encuentran cerca a 0.4. Referente a los outliers, hay varios que superan el umbral de 0.6, como en $n = 54, 55$, $n = 61, 62, 65, 66, 84$.

#figure(
  boxplot-from-csv("datos/grambank-lang2vec-syntax-knn.json"), 
  caption: [Resultados de los valores de ARI usando `syntax_knn`.]
)<grambank-lang2vec-syntaxknn-ari-plot>

Se observa en @grambank-lang2vec-syntaxknn-ari-plot, hay outliers que toman el valor de 0.7 o más. Se puede observar esto en $n = 55, 56, 57,57, 58, 61, 62$. También hay mucha variabilidad de los datos, como siendo los bigotes inferiores cercanos a -0.1, mientras que los superiores están por encima de 0.4 a partir de $n = 50$. Las medianas están por encima de 0.1.

#pagebreak()