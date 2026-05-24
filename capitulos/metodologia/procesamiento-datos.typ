#import "@preview/lilaq:0.5.0" as lq

/*
  Esta es la introducción, debemos definir qué hicimos con las bases de datos lingüísticas. Más o menos como un TLDR para dar una idea.
*/
== Procesamiento computacional de las bases de datos lingüísticas

Con el objetivo de identificar similitudes y correlaciones con el espacio de BPE, se procesaron las bases de datos lingüísticas descritas en la @bases-datos-linguisticas. Dado que ninguna presenta una correspondencia uno a uno entre las lenguas que contienen y que no todas las características cuentan con un valor asignado, fue necesario aplicar una serie de procesamientos previos antes de integrarlas al análisis junto con el espacio de BPE.

Dicho procesamiento fue posible dado que tanto Grambank como WALS siguen los _Cross-Linguistic Data Formats_ (CLDF) @cldf. A partir de estas, se extrajeron las características lingüísticas de cada lengua, obteniendo una matriz $X_("Grambank") in RR^(n times m)$ y una matriz $X_("WALS") in RR^(n times m)$, denominadas espacio de Grambank y espacio de WALS, respectivamente.

=== Espacio BPE

// TODO: Aquí queremos transmitir cómo se generó el espacio de BPE. Comunica eso de acorde
// También (a futuro) especifica si usaste todas las lenguas o no, esto es importante.
Para obtener los vectores del espacio de BPE, usamos la metodología propuesta por #cite(<ximena-bpe-2023>, form: "prose"), la cual toma un texto en una lengua y lo transforma en un vector que caracteriza la productividad, idiosincrasia y frecuencia acumulada de dicha lengua mediante las subpalabras generadas por un modelo de BPE. Así, obtuvimos un vector por cada una de las $x$ lenguas definidas en [placeholder].

Para el procesamiento, utilizamos la implementación del proceso que estuvo disponible en GitHub. El programa usó Python y utilidades de UNIX. Sin embargo, modificamos ligeramente algunas partes del código debido a que usamos macOS para obtener los vectores. Este proceso fue realizado para cada lengua y comprendió cinco etapas.

La primera etapa consistió en la _tokenización a nivel de palabra_, en la cual el corpus se dividió en palabras ortográficas para establecer la base del procesamiento posterior. De esta manera, las palabras son diferenciables mediante espacios, distinción que resulta útil para lenguas como el japonés.

// Quizá valga la pena checar este paso con lenguas como el japonés, que no tienen bien definido la palabra ortográfica.
Posteriormente, se realizó el _preprocesamiento del corpus_ con el objetivo de obtener un mejor modelo de BPE. Este preprocesamiento implicó dos operaciones sobre el texto. En primer lugar, todos los caracteres fueron transformados a minúsculas. Si bien se tuvo consciencia de que en algunas lenguas la relación mayúscula-minúscula no está definida de la misma manera que en la función `lower()` de Python, por razones de reproducibilidad se decidió mantener este criterio. En segundo lugar, se removieron del texto los signos de puntuación `_.,"()?¿?¡!»«""،/\]_`. Un ejemplo del preprocesamiento es el siguiente:

#align(center)[_Hola, ¿cómo estás?_ $->$ _hola como estás_]

// TODO: Quizá explicar un poco mejor sobre los merges
A continuación, se procedió a la _generación del modelo BPE_ a partir del texto preprocesado. El programa utilizado fue `subword-nmt`, configurado con 200 merges. Este número es sugerido como un punto de inflexión donde la entropía de las lenguas es menos dispersa @ximena-bpe-2021.

// TODO: Si se puede, citar subword-nmt
La cuarta etapa correspondió a la _obtención de las métricas por subpalabra_. Para ello, se aplicó el modelo BPE entrenado al archivo del corpus preprocesado utilizando `subword-nmt`, tras lo cual se calcularon las medidas de productividad, frecuencia acumulada e idiosincrasia de cada subpalabra.

Finalmente, se llevó a cabo la _obtención de las métricas por lengua_, promediando las métricas obtenidas de cada subpalabra para obtener la representación vectorial de cada lengua.

// Como nota a futuro: Con Ximena, estamos viendo si el StandardScaler que le hacemos al espacio a BPE hace algun efecto en los resultados de los algoritmos. Entonces, como esta sección es para generar el espacio de BPE, debemos incluir eso también si se logra a aplicar.
El resultado final fue una matriz $X in RR^(n times 3)$, el cual llamamos espacio BPE. Normalizamos este espacio para la aplicación de los otros métodos:

$ Z_(i j) = (X_(i j) - mu_j) / sigma_j $

=== WALS

#let processing_footnote = [A partir del repositorio de WALS, se construyó una base de datos relacional mediante `pycldf` @cldf. El uso de bases de datos relacionales, frente a otras modalidades disponibles como archivos `.csv` o llamadas a bibliotecas, proporcionó la flexibilidad necesaria para realizar consultas mediante SQL.]

A partir de la base de datos de WALS#footnote(processing_footnote), se procesó `ValueTable`, que contiene los valores de las características para cada lengua, para construir las representaciones vectoriales de las lenguas, convirtiendo cada una en un vector a partir de dichos valores. Por ejemplo, el inglés con las características de @wals-features produce el vector $v = (1, 2, 2, 2, 2, 2, 1, 2, 1, 2, 2, 5, 1, 2, 2)$.

// Además, podemos agregar que en el experimento original el imputer fue 0
Los vectores de las lenguas se agruparon en una matriz $X_("WALS") in RR^(n times m)$, donde $n$ es el número de lenguas y $m$ el número de características. Durante este procesamiento, se identificó que algunas lenguas carecen de valores para ciertas características. Dichos valores se dejaron como $0$ en la matriz. 

// TODO: Representar el espacio WALS usando PCA o algo parecido

// TODO: Agregar lo del StandarScaler también aquí.

=== Grambank


Como se describió en la @bases-datos-linguisticas, las lenguas de Grambank y WALS no presentan una correspondencia uno a uno. Por consiguiente, para relacionarlas, se establecieron tres criterios de selección, priorizando siempre las lenguas con más características disponibles en Grambank.

El primer criterio fue la coincidencia exacta de nombre, relacionando directamente las lenguas que compartían el mismo nombre en ambas bases de datos, como _Modern Greek_ para el griego. El segundo criterio aplicó cuando solo existía una lengua con nombre similar, considerándola como equivalente; por ejemplo, _Lango (Uganda)_ en Grambank correspondió a _Lango_ en WALS. Finalmente, si existían múltiples lenguas con nombre similar, se eligió la que contara con más características disponibles; por ejemplo, _Hausa States Fulfulde_ se seleccionó sobre _Hausa_ por contar con más características en Grambank.

La matriz $X_"Grambank"$ se construyó mediante el mismo método que $X_"WALS"$, leyendo los datos a través de CLDF. Cabe resaltar que, a diferencia de WALS, se utilizó el identificador propio de Grambank para identificar las lenguas.

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

La decisión fue imputar con 0 los valores vacíos en $X_"Grambank"$, para intepretarlo como la ausencia de esta feature. Esta interpretación concuerda en la mayoría de las features de Grambank, que son binarias. 

// Pon que también se uso StandarScaler
Otra paso del procesamiento fue estandarizar y centrar los puntos que obtuvimos después de construir la matriz. Esto se logra con:

=== lang2vec

Los valores faltantes en `syntax_wals`, representados como `--`, se imputaron con `0` para denotar la ausencia de un valor, de manera consistente con el criterio adoptado para Grambank. Esta decisión resulta apropiada dado que las características de `lang2vec` son binarias @littell2017uriel.

// TODO: Agrega lo del StandarScaler también

=== Base de referencia
En adición a los anteriores conjuntos de vectores, creamos un espacio aleatorio basado en el espacio BPE que sirvió como una base de referencia. Con esta base, podemos establecer si hay una mayor relación entre el espacio de BPE y Grambank o WALS más allá del carácter aleatorio.

Por tal motivo, para crear la base de referencia, obtuvimos los rangos donde varías las características de BPE. Con esta información, generamos una distribución uniforme por cada característica para crear los vectores para cada lengua en este nuevo espacio. A este espacio lo denominamos $X_"BPE Random"$.