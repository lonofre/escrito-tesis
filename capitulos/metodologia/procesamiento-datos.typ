#import "@preview/lilaq:0.5.0" as lq
#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

== Procesamiento computacional de las bases de datos lingüísticas

Con el objetivo de identificar similitudes entre la caracterización de las lenguas por BPE y las bases de datos lingüísticas, procesamos los datos del corpus y de las bases de datos para generar representaciones vectoriales que facilitaran la comparación. Para la caracterización mediante BPE, tuvimos que realizar el procesamiento del PBC; mientras que para las bases de datos de Grambank, WALS y lang2vec realizamos la extracción de sus datos y usamos solo las características que nos fueron útiles. De este procesamiento resultó un espacio por cada fuente (BPE, WALS, Grambank y lang2vec), además de una base de referencia aleatoria.

Todos los espacios comparten la misma estructura, donde las filas corresponden a lenguas y las columnas a características. En adelante, $L$ denota el conjunto de las 47 lenguas del estudio, $L_G subset L$ el subconjunto de las 38 cubiertas por Grambank, y $d_e$ la dimensión (número de características) del espacio $e$. Así, por ejemplo, el espacio de WALS es $X_W in RR^(|L| times d_W)$ y el de Grambank es $X_G in RR^(|L_G| times d_G)$. La @notacion-espacios, al final de esta sección, resume todos los símbolos.

=== Espacio BPE

Para obtener los vectores de las lenguas del espacio de BPE, usamos la metodología propuesta por #cite(<ximena-bpe-2023>, form: "prose"), la cual toma un texto en una lengua (en este caso su correspondiente corpus en el PBC) y lo transforma en un vector que caracteriza la productividad, idiosincrasia y frecuencia acumulada de dicha lengua. De esta manera, obtuvimos un vector por cada una de las 47 lenguas definidas en @tabla-de-lenguas.

#let footnote_repo_bpe = [El repositorio se encuentra disponible en #link("https://github.com/ximenina/BPEProductivity")]

Para el procesamiento, utilizamos la implementación del proceso que estuvo disponible en GitHub #footnote(footnote_repo_bpe). Realizamos este proceso para cada lengua, el cual comprendió cinco etapas (véase @fig-etapas).


#let caja = (
  fill: gray.lighten(100%),
  stroke: black + 0.6pt,
  corner-radius: 4pt,
  inset: 6pt,
  width: 3.1cm,
  height: 1.7cm,
)

#figure(
  align(center, scale(80%, reflow: true, block[
    #set text(size: 9pt)
    #diagram(
      spacing: (6mm, 0pt),
      edge-stroke: 0.6pt,

      node((0,0), align(center)[*Tokenización* \ a nivel de palabra], ..caja, name: <e1>),
      node((1,0), align(center)[*Preprocesamiento* \ del corpus], ..caja, name: <e2>),
      node((2,0), align(center)[*Modelo BPE*], ..caja, name: <e3>),
      node((3,0), align(center)[*Métricas* \ por subpalabra], ..caja, name: <e4>),
      node((4,0), align(center)[*Métricas* \ por lengua y \ *caracterización*], ..caja, name: <e5>),

      edge(<e1>, <e2>, "->"),
      edge(<e2>, <e3>, "->"),
      edge(<e3>, <e4>, "->"),
      edge(<e4>, <e5>, "->"),
    )
  ])),
  caption: [Etapas del procesamiento para obtener el espacio BPE.],
) <fig-etapas>

La primera etapa consistió en la _tokenización a nivel de palabra_, en la cual dividimos el corpus en palabras separadas por espacios. Esta separación crea límites entre palabras y por lo tanto ayuda a BPE en la tokenización. Aunque no es de mucha utilidad en lenguas donde las palabras siempre están separadas por espacios, sí es útil en lenguas como el birmano donde no existe esta separación. 

Posteriormente, realizamos el _preprocesamiento del corpus_ con el objetivo de obtener un mejor modelo de BPE. Este preprocesamiento implicó dos operaciones sobre el texto. En primer lugar, transformamos todos los caracteres a minúsculas para no depender de las variaciones de minúsculas y mayúsculas en el texto (como _Esto_ y _esto_). En segundo lugar, eliminamos del texto los signos de puntuación `_.,"()?¿?¡!»«"،/\]_` para quitarlos de la tokenización. Un ejemplo del preprocesamiento es el siguiente:

#align(center)[_Hola, ¿cómo estás?_ $->$ _hola como estás_]

#let footnote_subwordnmt = [`subword-nmt` es un #link("https://github.com/rsennrich/subword-nmt")[programa] para tokenizar texto, basado en BPE.]

A continuación, procedimos a la _generación del modelo BPE_ a partir del texto preprocesado con el fin de obtener las subpalabras. Para esto, usamos el programa de `subword-nmt`#footnote(footnote_subwordnmt), configurado a detenerse a las 200 fusiones (_merges_). Este número es sugerido por trabajos previos, pues es una especie de punto de inflexión donde suceden varias cosas: las subpalabras capturadas en estas primeras fusiones o merges son las que logran el mayor nivel de compresión del texto. Esto se puede medir en términos de entropía y redundancia de las distribuciones de frecuencia del texto en cada segmentación. Es decir, son estas primeras subpalabras las que nos dan características más distintivas para caracterizar a las lenguas: algunas lenguas son comprimidas capturando patrones productivos, mientras que en otras se capturan patrones más idiosincráticos en los primeros merges @ximena-bpe-2021@ximena-bpe-2023.

La cuarta etapa correspondió a la _obtención de las métricas por subpalabra_ basado en el modelo BPE que se generó en el paso anterior. Para ello, aplicamos el modelo al archivo del corpus preprocesado utilizando `subword-nmt`, tras lo cual calculamos las medidas de productividad, frecuencia acumulada e idiosincrasia de cada subpalabra.

Finalmente, realizamos la _obtención de las métricas por lengua_, promediando las métricas obtenidas de cada subpalabra para obtener la representación vectorial de cada lengua.

El resultado final fue el espacio BPE $X_"BPE" in RR^(|L| times d_"BPE")$, con $d_"BPE" = 3$ (productividad, idiosincrasia y frecuencia acumulada). Como paso final, normalizamos este espacio mediante `StandardScaler`#footnote[Usamos `StandardScaler` de #link("https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html")[scikit-learn.]], que centra cada columna en su media y la escala a varianza unitaria:

$ Z_(i j) = (X_(i j) - mu_j) / sigma_j $

donde $mu_j$ y $sigma_j$ son la media y la desviación estándar de la columna $j$. Esta estandarización resulta indispensable porque las tres características de BPE viven en magnitudes distintas y los métodos posteriores son sensibles a la escala.

=== WALS

Del procesamiento de WALS buscamos obtener una representación de las lenguas según sus características de tipología morfológica, donde cada lengua se representa como un vector cuyas entradas son los valores de las características de @wals-features.

Tanto WALS como Grambank están estructurados según los formatos de datos translingüísticos (_Cross-Linguistic Data Formats_, CLDF) @cldf, un conjunto de estándares para compartir y reutilizar datos lingüísticos. Bajo este formato, la información está organizada en tres principales componentes: las _lenguas_ (los objetos de investigación), los _parámetros_ (los conceptos comparativos medidos entre lenguas, que en este estudio se denominan características) y los _valores_ (las mediciones concretas de una característica para una lengua específica). Esta estructura común permitió aplicar un mismo procedimiento de extracción a ambas bases.

#let processing_footnote = [A partir del repositorio de WALS, construimos una base de datos relacional mediante `pycldf` @cldf. El uso de bases de datos relacionales, frente a otras modalidades disponibles como archivos `.csv` o llamadas a bibliotecas, proporcionó la flexibilidad necesaria para realizar consultas mediante SQL.]

Para construir los vectores, procesamos `ValueTable` de la base de datos de WALS#footnote(processing_footnote), la tabla que contiene los valores de las características para cada lengua, y convertimos cada lengua en un vector a partir de dichos valores. Por ejemplo, el inglés produce el vector $(1, 2, 2, 2, 2, 2, 1, 2, 1, 2, 2, 5, 1, 2, 2)$. Finalmente, agrupamos los vectores resultantes en la matriz $X_W in RR^(|L| times d_W)$, con $d_W = 15$.

Durante este procesamiento, identificamos que algunas lenguas carecen de valores para ciertas características. Siguiendo el procedimiento del experimento original @ximena-bpe-2023, imputamos dichos valores con $0$ en la matriz.

Como paso final, aplicamos a $X_W$ la misma estandarización descrita para $X_"BPE"$.

=== Grambank

Del procesamiento de Grambank buscamos obtener una representación de las lenguas según sus características, donde cada lengua se representa como un vector cuyas entradas son los valores de dichas características. A diferencia de WALS, Grambank no cubre todas las lenguas del estudio ni contamos con un conjunto fijo de características, por lo que el procesamiento requirió obtener las lenguas cubiertas por Grambank y seleccionar sus características.

A partir de la conexión entre Glottocodes e ISO 639-3 descrita en la @iso-puente, obtuvimos las lenguas correspondientes en Grambank, que resultaron ser 40 de las 47 del estudio. En dos casos, la entrada obtenida contaba con muy pocas características disponibles, por lo que la reemplazamos manualmente por una variedad cercana con mejor cobertura: _kewa occidental_ por _kewa oriental_, y _guaraní paraguayo_ por _guaraní mbya_. De esas 40 excluimos el coreano (`kor`) y el birmano (`mya`), cuya escritura agrupa varias letras en un solo bloque silábico que se codifica como un único carácter Unicode, de modo que BPE opera sobre unidades más grandes y variadas y produce subpalabras menos productivas @ximena-bpe-2023. El conjunto de trabajo quedó entonces en 38 lenguas, que denominamos $L_G$.

No obstante, ante la falta de un conjunto definido de características, tuvimos que seleccionarlas (identificadas con códigos del tipo `GB` seguido de tres dígitos, como `GB107` o `GB401`) según su cobertura, ordenándolas de mayor a menor según el número de lenguas que cubrían. Por ejemplo, `GB107` cubre todas las lenguas, por lo que ocupa uno de los primeros lugares; `GB401`, en cambio, cubre pocas y queda en los últimos. Esta manera de ordenar las características nos permitió la exploración de los valores faltantes y decidir cuántas usamos para el estudio.

// Nota: Datos obtenidos del notebook seleccion_por_disponibilidad.ipynb
#figure(
  {
    show lq.selector(lq.tick-label): set text(0.8em)
    let accumlative_missing_values = csv("datos/cumulative_missing_values.csv").map(x => x.at(0)).map(x => int(x))
    
    lq.diagram(
      ylabel: [Valores faltantes],
      xlabel: [Número de características],
      yaxis: (
        exponent: 0,
        tick-args: (
          density: 116%,
        ),
      ),
      xaxis: (
        tick-distance: 10,
        subticks: 1,
        ticks: range(0, 200, step: 10)
      ),
      lq.plot(
        range(195),
        x => accumlative_missing_values.at(x),
        mark: none,
        stroke: 1pt
      ),
      lq.rect(
        30, 
        0, 
        width: 55, 
        height: -100%, 
        fill: rgb("#b4d5fb7b"),
        label: [Rango de operación de $d_G$]
      ),
      width: 90%,
    )
  },
  caption: [Número de valores faltantes al ir agregando más características.]
)<grambank-valores-vacios>

Como se observa en @grambank-valores-vacios, la cantidad de valores vacíos varía notablemente según el número de características consideradas, por lo que, en lugar de fijar un único número, generamos un espacio de Grambank por cada $d_G$ en el rango de 30 a 85. Este rango se definió a partir de dos observaciones: alrededor de las 30 características se tiene una cobertura considerable, con pocos valores vacíos; mientras que a partir de las 80 la tendencia comienza a incrementar notablemente, en parte debido a que algunas lenguas, como el barasano y el oromo, presentan una gran cantidad de valores vacíos en Grambank. En total, esto produjo 56 espacios de Grambank. No obstante, dado que la mayoría de las lenguas cuentan con un promedio aceptable de valores vacíos, no descartamos ninguna, con el fin de abarcar la mayor cantidad posible.

Una vez definidas las lenguas y las características, construimos cada matriz $X_G in RR^(|L_G| times d_G)$ con el mismo método empleado para obtener $X_W$ de WALS, leyendo los datos a través de CLDF.

No obstante, estos valores vacíos tuvimos que imputarlos, al igual que en WALS, ya que los algoritmos requieren que la matriz no contenga valores nulos. Para ello, consideramos cuatro estrategias de imputación: reemplazar los valores nulos con $0$, asumiendo su ausencia; reemplazarlos con $-1$, modelando la ausencia como un valor desconocido; imputar la media del conjunto, basándose en los valores de las demás lenguas de la matriz; o imputar valores de lenguas cercanas, lo que proporcionaría una aproximación más informada, aunque descartamos esta opción por requerir conocimiento lingüístico especializado para justificar que esos valores calculados son correctos.

// TODO: Justificar por qué se eligió el 0 sobre el $-1$ y la media
// Follow up TODO: En un notebook que tengo por ahí hace la comparativa de cuántos valores 0 se agregan de más al imputar, con diferentes rangos. No sé si valga la pena agregar la gráfica, pero si ayudaría a mencionar esto para al menos justificar que no se realiza tanto sesgo con eso. En contraste, ya a valores más altos de 0 quizá si se pueda ver ese sesgo.
Nuestra decisión fue imputar con 0 los valores vacíos en $X_G$, para interpretarlo como la ausencia de esta característica. Esta interpretación nos ayudó a mantener la estructura de características binarias en Grambank.

Como paso final, aplicamos a $X_G$ la misma estandarización descrita para $X_"BPE"$.



=== lang2vec

Para construir $X_"l2v" in RR^(|L| times d_"l2v")$, obtuvimos de la biblioteca lang2vec las características del conjunto `syntax_knn` correspondientes a cada una de las 47 lenguas, con $d_"l2v" = 103$. Como `syntax_knn` no tiene valores vacíos, $X_"l2v"$ no requirió imputación, a diferencia de WALS y Grambank. Como paso final, aplicamos la misma estandarización descrita para $X_"BPE"$.

=== Base de referencia (espacio aleatorio)

Aunque la medida elegida para comparación de agrupamientos entre espacios (índice Rand) ya considera un ajuste por la similitud entre agrupamientos que podría darse por mero azar, establecemos además otra prueba para asegurarnos de que la similitud observada va más allá de lo esperable por azar.


Para establecer un punto de referencia de similitud debida al azar, creamos $X_0$, un espacio aleatorio que sustituye a $X_"BPE"$ conservando su forma y sus rangos. Esto es necesario porque, como BPE es la representación que queremos poner a prueba, buscamos evidencia de que los vectores que induce codifican información lingüística, y para sostener que la similitud entre $X_"BPE"$ y una base tipológica es real (y no un efecto del azar), necesitamos ese punto de referencia con el cual contrastarla.

Para construirlo, obtuvimos los rangos en los que varían las características de $X_"BPE"$ y, sobre cada rango, generamos una distribución uniforme, que reparte los valores sin ninguna estructura interna. Con ella asignamos un vector a cada lengua en este nuevo espacio. Y como paso final, aplicamos a $X_0$ la misma estandarización descrita para $X_"BPE"$.

La idea de crear este espacio de referencia es contar con un punto de comparación que nos permita evaluar si la similitud entre espacios, medida a través del clustering, realmente refleja una relación entre la información codificada en las bases de datos tipológicas y la segmentación BPE. Si esta similitud responde a una relación real, debería ser mayor al comparar el espacio construido a partir de una base de datos lingüística con el espacio BPE que al compararlo con un espacio de referencia donde la distribución de los puntos sea aleatoria y, por tanto, no contenga la información inducida por BPE.


=== Resumen de notación

La @notacion-espacios consolida los espacios construidos en este capítulo.

#figure(
  table(
    columns: (auto, 1fr, auto),
    align: (left, left, left),
    stroke: none,
    table.hline(stroke: 0.5pt),
    table.header(
      [*Símbolo*], [*Descripción*], [*Dimensión*],
    ),
    table.hline(stroke: 0.3pt),
    [$L$], [Conjunto de lenguas analizadas.], [$|L| = 47$],
    [$L_G$], [Subconjunto de lenguas cubiertas por Grambank, donde $L_G subset L$.], [$|L_G| = 38$],
    [$X_"BPE"$], [Espacio derivado de BPE sobre el PBC: productividad, idiosincrasia y frecuencia acumulada.], [$|L| times 3$],
    [$X_0$], [Base de referencia aleatoria, generada a partir de los rangos de $X_"BPE"$.], [$|L| times 3$],
    [$X_W$], [Características morfológicas de WALS (@wals-features).], [$|L| times 15$],
    [$X_G$], [Características seleccionadas de Grambank ($d_G$ variable).], [$|L_G| times d_G$],
    [$X_(W+G)$], [Concatenación de las características de WALS y Grambank sobre $L_G$.], [$|L_G| times (15 + d_G)$],
    [$X_"l2v"$], [Características sintácticas de lang2vec (`syntax_knn`).], [$|L| times 103$],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Resumen de notación de los espacios construidos en el capítulo.],
)<notacion-espacios>