#import "@preview/lilaq:0.5.0" as lq

/*
  Esta es la introducción, debemos definir qué hicimos con las bases de datos lingüísticas. Más o menos como un TLDR para dar una idea.
*/
== Procesamiento computacional de las bases de datos lingüísticas

Con el objetivo de identificar similitudes y correlaciones con el espacio de BPE, se procesaron las bases de datos lingüísticas descritas en la @bases-datos-linguisticas. Dado que ninguna presenta una correspondencia uno a uno entre las lenguas que contienen y que no todos las características cuentan con un valor asignado, fue necesario aplicar una serie de procesamientos previos antes de integrarlas al análisis junto con el espacio de BPE.

Dicho procesamiento fue posible dado que tanto Grambank como WALS están estructurados según los _Cross-Linguistic Data Formats_ (CLDF) @cldf, un conjunto de estándares para compartir y reutilizar datos lingüísticos. Bajo este formato, la información se organiza en tres componentes: las *lenguas* (los objetos de investigación), los *parámetros* (los conceptos comparativos medidos entre lenguas, que en este estudio se denominan características) y los *valores* (las mediciones concretas de una característica para una lengua específica). Esta estructura común permitió aplicar un mismo procedimiento de extracción a ambas bases, obteniendo el espacio de WALS $X_"WALS" in RR^(L times d_"WALS")$ y el espacio de Grambank $X_"Grambank" in RR^(L_G times d_"Grambank")$. En todos los espacios, las filas corresponden a lenguas y las columnas a características, siguiendo la convención `(n_samples, n_features)`: $L$ denota el número de lenguas ($L = 47$ en el conjunto completo y $L_G = 38$ en el subconjunto cubierto por Grambank) y $d_e$ la dimensión ---número de características--- del espacio $e$.

Cada espacio se construye sobre la cobertura máxima de su fuente. Cuando dos espacios se comparan, la comparación se realiza sobre la intersección de las lenguas que ambos cubren; en particular, todo experimento que involucre Grambank opera sobre el subconjunto $L_G = 38$, incluso cuando los demás espacios se hayan construido sobre las $L = 47$ lenguas.

=== Espacio BPE

Para obtener los vectores del espacio de BPE, se usó la metodología propuesta por #cite(<ximena-bpe-2023>, form: "prose"), la cual toma un texto en una lengua y lo transforma en un vector que caracteriza la productividad, idiosincrasia y frecuencia acumulada de dicha lengua mediante las subpalabras generadas por un modelo de BPE. Así, se obtuvo un vector por cada una de las $L$ lenguas definidas en [placeholder].

Para el procesamiento, utilizamos la implementación del proceso que estuvo disponible en GitHub. El programa usó Python y utilidades de UNIX. Sin embargo, se utilizó ligeramente algunas partes del código debido a que se usó macOS para obtener los vectores. Este proceso fue realizado para cada lengua y comprendió cinco etapas.

La primera etapa consistió en la _tokenización a nivel de palabra_, en la cual el corpus se dividió en palabras ortográficas para establecer la base del procesamiento posterior. De esta manera, las palabras son diferenciables mediante espacios, distinción que resulta útil para lenguas como el japonés.

// Quizá valga la pena checar este paso con lenguas como el japonés, que no tienen bien definido la palabra ortográfica.
Posteriormente, se realizó el _preprocesamiento del corpus_ con el objetivo de obtener un mejor modelo de BPE. Este preprocesamiento implicó dos operaciones sobre el texto. En primer lugar, todos los caracteres fueron transformados a minúsculas. Si bien se tuvo consciencia de que en algunas lenguas la relación mayúscula-minúscula no está definida de la misma manera que en la función `lower()` de Python, por razones de reproducibilidad se decidió mantener este criterio. En segundo lugar, se removieron del texto los signos de puntuación `_.,"()?¿?¡!»«""،/\]_`. Un ejemplo del preprocesamiento es el siguiente:

#align(center)[_Hola, ¿cómo estás?_ $->$ _hola como estás_]

// TODO: Quizá explicar un poco mejor sobre los merges
A continuación, se procedió a la _generación del modelo BPE_ a partir del texto preprocesado. El programa utilizado fue `subword-nmt`, configurado con 200 merges. Este número es sugerido como un punto de inflexión donde la entropía de las lenguas es menos dispersa @ximena-bpe-2021.

// TODO: Si se puede, citar subword-nmt
La cuarta etapa correspondió a la _obtención de las métricas por subpalabra_. Para ello, se aplicó el modelo BPE entrenado al archivo del corpus preprocesado utilizando `subword-nmt`, tras lo cual se calcularon las medidas de productividad, frecuencia acumulada e idiosincrasia de cada subpalabra.

Finalmente, se llevó a cabo la _obtención de las métricas por lengua_, promediando las métricas obtenidas de cada subpalabra para obtener la representación vectorial de cada lengua.

El resultado final fue el espacio BPE $X_"BPE" in RR^(L times d_"BPE")$, con $d_"BPE" = 3$ (productividad, idiosincrasia y frecuencia acumulada). Como paso final, se normalizó este espacio mediante `StandardScaler`#footnote[Se usó `StandardScaler` de #link("https://scikit-learn.org/stable/modules/generated/sklearn.preprocessing.StandardScaler.html")[scikit-learn.]], que centra cada columna en su media y la escala a varianza unitaria:

$ Z_(i j) = (X_(i j) - mu_j) / sigma_j $

donde $mu_j$ y $sigma_j$ son la media y la desviación estándar de la columna $j$. Esta estandarización resulta indispensable porque las tres características de BPE viven en magnitudes distintas y los métodos posteriores son sensibles a la escala.

=== WALS

#let processing_footnote = [A partir del repositorio de WALS, se construyó una base de datos relacional mediante `pycldf` @cldf. El uso de bases de datos relacionales, frente a otras modalidades disponibles como archivos `.csv` o llamadas a bibliotecas, proporcionó la flexibilidad necesaria para realizar consultas mediante SQL.]

A partir de la base de datos de WALS#footnote(processing_footnote), se procesó `ValueTable`, que contiene los valores de las características para cada lengua, para construir las representaciones vectoriales de las lenguas, convirtiendo cada una en un vector a partir de dichos valores. Por ejemplo, el inglés con las características de @wals-features produce el vector $v = (1, 2, 2, 2, 2, 2, 1, 2, 1, 2, 2, 5, 1, 2, 2)$.

// Además, podemos agregar que en el experimento original el imputer fue 0
Los vectores de las lenguas se agruparon en la matriz $X_"WALS" in RR^(L times d_"WALS")$, con $d_"WALS" = 15$ (las características de @wals-features). Durante este procesamiento, se identificó que algunas lenguas carecen de valores para ciertas características. Siguiendo el procedimiento del experimento original @ximena-bpe-2023, dichos valores se imputaron con $0$ en la matriz. Esta elección no introduce ambigüedad, ya que ninguna característica de WALS utiliza $0$ como categoría, por lo que el $0$ no colisiona con ningún valor real y se interpreta inequívocamente como ausencia.

// TODO: Representar el espacio WALS usando PCA o algo parecido

Como paso final, aplicamos `StandardScaler` sobre $X_"WALS"$ siguiendo el mismo esquema descrito para el espacio BPE, de modo que cada característica quedara centrada en su media y escalado a varianza unitaria antes de los análisis posteriores.

=== Grambank


Como se describió en la @bases-datos-linguisticas, las lenguas de Grambank y WALS no presentan una correspondencia directa: WALS opera con _WALS codes_ y Grambank con Glottocodes. Para emparejarlas se utilizó el ISO 639-3 como identificador puente, aprovechando que WALS registra el ISO de cada lengua y que los metadatos de Glottolog mapean cada Glottocode a su ISO correspondiente. De esta manera, cada lengua en WALS se vinculó con la entrada de Grambank cuyo Glottocode comparte el mismo ISO.

En dos casos, la entrada de Grambank emparejada por ISO contaba con muy pocas características disponibles, por lo que se sustituyó manualmente por una variedad cercana con mejor cobertura: _West Kewa_ se reemplazó por _East Kewa_, y _Paraguayan Guaraní_ por _Mbya Guaraní_.

La matriz $X_"Grambank"$ se construyó mediante el mismo método que $X_"WALS"$, leyendo los datos a través de CLDF. Cabe resaltar que, a diferencia de WALS, se utilizó el Glottocode como identificador interno de Grambank. Las características, por su parte, se identifican con códigos del tipo `GB` seguido de tres dígitos, como `GB107` o `GB401`.

Sin embargo, la selección de características de Grambank requirió una exploración previa, ya que no todas las lenguas cuentan con el mismo conjunto de características disponibles. Por ello, se priorizó la combinación de características que minimizara los valores vacíos, ordenándolas de mayor a menor según el número de lenguas que cubrían. Por ejemplo, GB107 cubre todas las lenguas y tendría alta prioridad, mientras que GB401 cubre pocas lenguas y se seleccionaría en los últimos lugares.

// Datos obtenidos del notebook seleccion_por_disponibilidad.ipynb
#figure(
  {
    let features_availability = csv("datos/availability.csv", row-type: array).map(x => x.at(2)).slice(1).map(x => int(x))
    let languages = 38
    
    let accumulated = ()
    accumulated.push(languages  - features_availability.at(0))
    for n in range(1, features_availability.len()) {
      let sum = accumulated.at(n - 1) + languages - features_availability.at(n)
      accumulated.push(sum)
    }
    
    lq.diagram(
      ylabel: text(size: 11pt)[Valores faltantes],
      xlabel: text(size: 11pt)[Número de características],
      lq.plot(
        range(features_availability.len()),
        x => accumulated.at(x)
      ),
      width: 80%
    )
  },
  caption: [Número de valores faltantes al ir agregando más características.]
)<grambank-valores-vacios>

// Aquí continua explicando por qué se eligió cierto número de features
// También agrega qué lenguas tienen valores muy vacíos como limitaciones
//  Toma el top 5 (porque tampoco tenemos tantas lenguas) y haz el plot, también toma un promedio y haz el plot para graficar
Como se observa en @grambank-valores-vacios, a partir de las 80 características la tendencia de valores vacíos incrementa. Un análisis más detallado por lengua revela que algunas, como el barasano y el oromo, presentan una gran cantidad de valores vacíos, lo cual contribuye a este incremento.

// TODO: Agregar quizá una tabla de acuerdo al top 10 final.

No obstante, dado que la mayoría de las lenguas cuentan con un promedio aceptable de valores vacíos, no se descartó ninguna, con el fin de abarcar la mayor cantidad de lenguas posible.

// [TODO : Diagrama de media de valores perdidos y haciendo una comparación con los top 5 al menos]

Al igual que con WALS, los algoritmos requieren que la matriz de Grambank no contenga valores nulos, por lo que fue necesario imputar los valores faltantes. Para ello, se consideraron cuatro estrategias de imputación: reemplazar los valores nulos con $0$, asumiendo su ausencia; reemplazarlos con $-1$, modelando la ausencia como un valor desconocido; imputar la media del conjunto, basándose en los valores de las demás lenguas de la matriz; o imputar valores de lenguas cercanas, lo que proporcionaría una aproximación más informada, aunque esta opción se descartó por requerir conocimiento lingüístico especializado.

La decisión fue imputar con 0 los valores vacíos en $X_"Grambank"$, para interpretarlo como la ausencia de esta característica. Esta interpretación concuerda en la mayoría de las características de Grambank, que son binarias.

Como paso final, aplicamos `StandardScaler` sobre $X_"Grambank"$ para centrar y escalar cada característica, manteniendo coherencia con el procedimiento aplicado al espacio BPE y a WALS.

=== lang2vec

Los valores faltantes en `syntax_wals`, representados como `--`, se imputaron con `0` para denotar la ausencia de un valor, de manera consistente con el criterio adoptado para Grambank. Esta decisión resulta apropiada dado que las características de `lang2vec` son binarias @littell2017uriel.

Como paso final, aplicamos `StandardScaler` sobre $X_"lang2vec"$ de la misma manera que en los demás espacios.

=== Base de referencia
En adición a los anteriores conjuntos de vectores, creamos un espacio aleatorio basado en el espacio BPE que sirvió como una base de referencia. Con esta base, podemos establecer si hay una mayor relación entre el espacio de BPE y Grambank o WALS más allá del carácter aleatorio.

// TODO: Analizar mejor esto
Por tal motivo, para crear la base de referencia, se obtuvieron los rangos donde varían las características de BPE. Con esta información, generamos una distribución uniforme por cada característica para crear los vectores para cada lengua en este nuevo espacio. A este espacio lo denominamos $X_"BPE-r"$.

Como paso final, aplicamos `StandardScaler` sobre $X_"BPE-r"$ de la misma manera que en los demás espacios.

=== Resumen de notación

La @notacion-espacios consolida los espacios construidos en este capítulo. En todos ellos las filas corresponden a lenguas y las columnas a características, siguiendo la convención `(n_samples, n_features)`.

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
    [$L$], [Número total de lenguas analizadas.], [$47$],
    [$L_G$], [Subconjunto de lenguas cubiertas por Grambank.], [$38$],
    [$X_"BPE"$], [Espacio derivado de BPE sobre el PBC: productividad, idiosincrasia y frecuencia acumulada.], [$L times 3$],
    [$X_"BPE-r"$], [Base de referencia aleatoria, generada a partir de los rangos de $X_"BPE"$.], [$L times 3$],
    [$X_"WALS"$], [Características morfológicas de WALS (@wals-features).], [$L times 15$],
    [$X_"Grambank"$], [Características seleccionadas de Grambank ($d_"Grambank"$ variable).], [$L_G times d_"Grambank"$],
    [$X_"lang2vec"$], [Características sintácticas de lang2vec (`syntax_wals` o `syntax_knn`).], [$L times d_"lang2vec"$],
    table.hline(stroke: 0.5pt),
  ),
  caption: [Resumen de notación de los espacios construidos en el capítulo.],
)<notacion-espacios>