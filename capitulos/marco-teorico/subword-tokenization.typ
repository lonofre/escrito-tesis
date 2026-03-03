== Tokenización a nivel subpalabra

Muchos algoritmos de PLN no operan directamente sobre la cadena de caracteres de un texto entero, sino que requieren una etapa previa de preprocesamiento. Este primer proceso es la tokenización, la cual consiste en segmentar el texto en unidades discretas denominadas tokens. Estos tokens son las unidades manejadas por los algoritmos de PLN. Sin embargo, cada algoritmo se beneficia diferentemente en cómo se representan los tokens. Estas unidades pueden corresponder a palabras, subpalabras, morfemas u otros tipos de segmentos.

#figure(
  align(center, block[
    #set align(left)
    Texto original: "En un lugar lejano" \
    Tokenización a nivel palabra: `[En, un, lugar, lejano]` \
    Tokenización a nivel carácter: `[E, n, u, n, l, u, g, a, r, l, e, j, a, n, o]`
    ]),
  caption: [Algunas formas de tokenización.]
)

Un primer enfoque de cómo se pueden representar los tokens es la tokenización por palabras, aunque tiene limitaciones @jm3 importantes. Por un lado, lenguas como el chino y el japonés no tienen espacios entre palabras, lo que dificulta la tokenización cuando se asume que cada palabra está separada por espacios. Por otro lado, no hay forma de procesar palabras desconocidas (_Out of Vocabulary_, OVV), sin expandir constantemente el vocabulario. Esto es evidente en tareas como la traducción @sennrich-etal-2016-neural de palabras raras y desconocidas, donde los mecanismos al nivel de palabra no son suficientes para lenguas que tienen procesos productivos para formar nuevas palabras con el paso del tiempo, lo cual es una fuerte limitante.

Para abordar estas limitaciones, una alternativa al uso de palabras como tokens es emplear subpalabras. Las subpalabras corresponden a palabras completas, cadenas arbitrarias o incluso morfemas, lo cual da entender que son unidades que tienen una longitud igual o más pequeña que una palabra.

Esta propiedad del tamaño de una subpalabra resulta fundamental cuando un modelo se enfrenta a palabras desconocidas. Si una palabra aparece en muy pocas instancias, un modelo presenta dificultades en aprender el significado de esta, lo que limita su capacidad de generalización. En cambio, cuando el modelo utiliza subpalabras, dispone de más evidencia distribuida a lo largo del corpus, pues es más probable que aparezcan estas unidades. Como resultado, los modelos basados en subpalabras logran un mejor manejo de palabras OOV @sennrich-etal-2016-neural @jm3.

// TODO: Aquí podemos explorar el uso de subpalabras en LLMs? Quizá para añadir algo más. Podemos empezar a explorar más cosas aquí, como una pequeña introducción al siguiente párrafo de BytePair Encoding
Debido a estas ventajas, el uso de subpalabras como tokens ha sido predominante en los modelos de lenguaje actuales.

Las subpalabras son los tokens que los LLMs usan para las tareas de NLP. La principal ventaja de estos es que lidian con las palabras OOV.

// The end :)
/*
La tokenización ayuda a . Esta representación discreta del texto garantiza la reproducibilidad @jm3 en los algoritmos de NPL, porque los algoritmos trabajan sobre un alfabeto o conjunto de datos en común. 

Asimismo, la tokenización puede abordar el problema de las palabras desconocidas o los neologismos; sin embargo, esta capacidad depende fundamentalmente de la definición del vocabulario subyacente de tokens. A estas palabras desconocidas se le suelen llamar fuera del vocabulario (_Out of Vocabulary_, OOV).
*/

=== Codificación de Pares de Bytes

// Aquí queremos explorar:
// Introducción qué es BPE
// y qué problemas resuelve con la tokenización a nivel subpalabra
// Quizá mostrar porqué es muy utilizado para esto.

/*
La codificación de pares de bytes (_Byte-Pair Encoding_, BPE) @Gage1994ANA fue uno de los primeros algoritmos en demostrar que las subpalabras funcionan mejor que palabras completas @sennrich-etal-2016-neural en los modelos de lenguaje. Originalmente BPE fue ideado como un algoritmo de compresión de datos, pero posteriormente se le dió el uso para generar subpalabras a partir de una cadena de texto.
*/

// TODO: Hacer una más fuerte introducción
La codificación de pares de bytes (_Byte-Pair Encoding_, BPE) @Gage1994ANA es un algoritmo usado para generar subpalabras @sennrich-etal-2016-neural. Estas subpalabras son el resultado de la compresión que realiza BPE sobre los caracteres de textos de entrenamiento. BPE identifica y fusiona iterativamente los pares de caracteres más frecuentes para generar nuevos símbolos. Cada nuevo símbolo es generado en cada iteración, a la cual llamamos fusión. El resultado de la última fusión nos da el conjunto subpalabras resultantes.

La descripción de BPE es la siguiente:

// Mejorar la descripción del algoritmo
1. Se obtienen los pares de símbolos $[a_i, j_i]$ y sus frecuencias $f([a_i, b_j])$
2. Se obtiene:
$ [a, b] = op("argmáx", limits: #true)_(a_i b_i) {f[a_i, b_j] : a_i, b_j in Sigma} $
3. Se hace el remplazo por el símbolo $a b$en cada palabra del vocabulario:
$ [a,b] -> a b $ 
4. Se agrega e símbolo $a b$ al alfabeto $Sigma$ y se repite el proceso hasta alcanzar un número predeterminado de operaciones.

El algoritmo revela un punto importante sobre BPE, que es que funciona de manera no supervisada. Una de las ventajas de este enfoque es que es posible aplicar este algoritmo sobre diferentes textos así como diferentes lenguas. Por lo tanto, cada lengua puede dar un conjunto diferente de subpalabras.

// TODO: Definir otro algoritmo aquí también
De este modo, una vez que BPE generó el conjunto de subpalabras, la tokenización sobre un texto sigue un procedimiento similar al algoritmo anterior. Este algoritmo convierte un texto en una secuencia de tokens.

1. En primer lugar, el modelo segmenta el texto a nivel de caracteres. 
2. A continuación, el modelo aplica de forma iterativa las reglas de reemplazo que BPE aprendió durante el entrenamiento.
3. Este proceso combina secuencias de caracteres según las reglas aprendidas y produce finalmente la representación del texto en subpalabras.

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
Cuando tenemos un modelo de BPE entrenado, podemos observar subpalabras que son frecuentes en las palabras, como "ción" en terminación, disminución, adjunción; y subpalabras que no son frecuentes en las palabras pero si por sí solas, como "un", "los", entre otros.

Retomando el ejemplo anterior, la tokenización dio subpalabras como _Las_, _en_, que son palabras muy comunes en español. A su vez, otras subpalabras que forman parte como _as_, se pueden encontrar en otras palabras como _bananas_, _sábanas_, _personas_. 

=== Otros métodos estadísticos de tokenización

// TODO: Agregar después
// WordPiece fue originalmente formulado por Google en un paper sobre el japonés y demás
Existen otros métodos estadísticos para generar subpalabras con enfoques similares a BPE. Uno de ellos es WordPiece, caracterizado por crear las fusiones entre símbolos mediante una función de verosimilitud.

// TODO: Sustentar esto
WordPiece busca maximizar la verosimilitud entre los símbolos de entrenamiento. Sean $s_1, s_2$ símbolos usados en el entrenamiento de un modelo de WordPiece, entonces se fusionan los símbolos de si:

$ op("arg max", limits: #true)_(s_1, s_2)  P(s_1, s_2) / (P(s_1)P(s_2)) $

// TODO: Tengo que sustentar esto
Este enfoque es diferente a BPE que sólo busca la máxima frecuencia. Sin embargo, WordPiece es considerado también un algoritmo voraz y no supervisado. Aunque esta similitud entre WordPiece y BPE no implica que sus subpalabras resultantes sean las mismas. 