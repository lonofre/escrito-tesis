/*
  Esta sección trata sobre la tokenización y su importancia en los sistemas de NLP. En particular, por qué es utilizado en los LLMs.
  También queremos introducir algunos algoritmos de tokenización.
*/
== Tokenización a nivel subpalabra

Esa segmentación previa al modelo recibe el nombre de tokenización: el proceso de dividir el texto en unidades discretas denominadas tokens. Estos tokens son las unidades manejadas por los modelos de lenguaje y algoritmos de PLN. Estas unidades pueden corresponder a palabras, subpalabras, morfemas u otros tipos de segmentos.

#figure(
  align(center, block[
    #set align(left)
    Texto original: "En un lugar lejano" \
    Tokenización a nivel palabra: `[En, un, lugar, lejano]` \
    Tokenización a nivel carácter: `[E, n, u, n, l, u, g, a, r, l, e, j, a, n, o]`
    ]),
  caption: [Algunas formas de tokenización.]
)

Un primer enfoque de cómo se pueden representar los tokens es la tokenización por palabras, aunque tiene limitaciones @jm3 importantes. Por un lado, lenguas como el chino y el japonés no tienen espacios entre palabras, lo que dificulta la tokenización cuando se asume que cada palabra está separada por espacios. Por otro lado, no hay forma de procesar palabras desconocidas (_Out of Vocabulary_, OOV), sin expandir constantemente el vocabulario. Esto es evidente en tareas como la traducción @sennrich-etal-2016-neural de palabras raras y OOV, donde los mecanismos al nivel de palabra no son suficientes para lenguas que tienen procesos productivos para formar nuevas palabras con el paso del tiempo, lo cual es una fuerte limitante.

Para abordar estas limitaciones, una alternativa al uso de palabras como tokens es emplear subpalabras. Las subpalabras corresponden a palabras completas, cadenas arbitrarias o incluso morfemas, lo cual da entender que son unidades que tienen una longitud igual o más pequeña que una palabra.

Esta propiedad del tamaño de una subpalabra resulta fundamental cuando un modelo se enfrenta a palabras desconocidas. Si una palabra aparece en muy pocas instancias, un modelo presenta dificultades en aprender el significado de esta, lo que limita su capacidad de generalización. En cambio, cuando el modelo utiliza subpalabras, dispone de más evidencia distribuida a lo largo del corpus, pues es más probable que aparezcan estas unidades. Como resultado, los modelos basados en subpalabras logran un mejor manejo de palabras OOV @sennrich-etal-2016-neural @jm3.

Debido a estas ventajas, las subpalabras son las unidades predominantes en los modelos de lenguaje actuales.

=== Codificación de Pares de Bytes

La codificación de pares de bytes (_Byte-Pair Encoding_, BPE) fue propuesta por #cite(<Gage1994ANA>, form: "prose") como un algoritmo de compresión de datos: su única operación consiste en sustituir, repetidamente, el par de bytes contiguos más frecuente de un archivo por un nuevo byte que no aparece en él. #cite(<sennrich-etal-2016-neural>, form: "prose") adaptaron esta idea para generar subpalabras: en lugar de comprimir bytes, el algoritmo fusiona caracteres dentro de las palabras de un corpus, y los símbolos que resultan de esas fusiones forman el vocabulario de subpalabras.

El entrenamiento de un modelo BPE parte de un alfabeto inicial $Sigma$, compuesto por los caracteres del corpus, y de las palabras representadas como secuencias de esos caracteres. Sobre esa base se repite el siguiente proceso:

1. Se cuenta la frecuencia $f(a, b)$ de cada par de símbolos contiguos $(a, b)$ que aparece dentro de las palabras del corpus.
2. Se selecciona el par más frecuente:
$ (a^*, b^*) = op("argmáx", limits: #true)_((a, b)) f(a, b) $
3. Se fusionan ambos símbolos en uno nuevo, $a^* b^*$, que reemplaza todas las ocurrencias del par y se agrega a $Sigma$.

Cada repetición de estos pasos se denomina fusión (_merge_). El proceso termina al alcanzar un número predeterminado de fusiones —el hiperparámetro principal del algoritmo—, y el alfabeto final $Sigma$, formado por los caracteres iniciales más los símbolos creados, es el conjunto de subpalabras del modelo.

Este procedimiento es no supervisado: se aplica a cualquier texto, en cualquier lengua, sin anotaciones ni reglas externas. En consecuencia, cada lengua produce un conjunto diferente de subpalabras, propiedad sobre la que descansa el resto de esta tesis.

Una vez entrenado el modelo, tokenizar un texto nuevo consiste en reproducir lo aprendido: el texto se segmenta a nivel de caracteres y las fusiones se aplican de forma iterativa, en el mismo orden en que fueron aprendidas, hasta que ninguna pueda aplicarse más. La secuencia de símbolos resultante es la representación del texto en subpalabras.

// Aquí podemos empezar a explicar el tokenizador de ChatGPT
Como ejemplo del proceso de tokenización, considérese este texto:

// Esto es sacado de chatgpt, pero podría ser bueno hacerlo por cuenta propria con un corpus en español y usando alguna biblioteca de BPE.
// Otro TODO es mejorar la presentación de esto

#align(center, box[
  #set align(left)
  Las supernovas estallan en galaxias lejanas.
])

// Citar tiktoken porque es de OpenAI
Al aplicar un tokenizador ya entrenado, en este caso `tiktoken`, el texto se convierte en una serie de tokens:
#align(center, box[
  #set align(left)

  #highlight(fill: rgb("#cdc4ff"))[Las]
  #highlight(fill: rgb("#8bd4b2"))[ super]#highlight(fill: rgb("#4aa3c7"))[nov]#highlight(fill: rgb("#cdc4ff"))[as ]
  #highlight(fill: rgb("#4aa3c7"))[ est]#highlight(fill: rgb("#8bd4b2"))[allan ]
  #highlight(fill: rgb("#4aa3c7"))[ en ]
  #highlight(fill: rgb("#c9a24d"))[ galax]#highlight(fill: rgb("#cdc4ff"))[ias ]
  #highlight(fill: rgb("#c9a24d"))[ lej]#highlight(fill: rgb("#8bd4b2"))[anas]#highlight(fill: rgb("#c9a24d"))[. ]
])
/*
E incluso obtenemos los identificadores de los tokens:

#align(center, box[
  #set align(left)

  `[23040, 2539, 13802, 288, 893, 180529, 469, 100558, 2682, 105104, 14457, 13]`
])
*/

// TODO: Podemos explicar algunas propiedades de como la forma de que BPE es greedy y cosas así.
// También expandir esto cuando tengamos mejores resultados
En un modelo de BPE entrenado se observan subpalabras frecuentes dentro de las palabras, como "ción" en terminación, disminución, adjunción; y subpalabras que no son frecuentes dentro de otras palabras pero sí por sí solas, como "un", "los", entre otras.

Retomando el ejemplo anterior, la tokenización dio subpalabras como _Las_, _en_, que son palabras muy comunes en español. A su vez, otras subpalabras que forman parte como _as_, se pueden encontrar en otras palabras como _bananas_, _sábanas_, _personas_. 

BPE no es el único algoritmo estadístico de tokenización a subpalabra. Otros métodos como WordPiece siguen esquemas iterativos similares —voraces y no supervisados— pero eligen las fusiones por verosimilitud en lugar de por frecuencia.

Pese a esas diferencias, todos estos algoritmos comparten un rasgo decisivo para esta tesis: son no supervisados y de naturaleza puramente estadística. BPE, además, fue originalmente concebido como un método de compresión de datos. Esa indiferencia formal hacia la lingüística plantea una pregunta inmediata: si el algoritmo nunca recibe reglas gramaticales, morfemas ni anotaciones de ningún tipo, ¿qué información sobre una lengua puede llegar a capturar a partir de la sola frecuencia de sus caracteres?