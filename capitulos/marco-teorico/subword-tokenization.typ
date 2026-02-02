== Tokenización a nivel subpalabra

Muchos algoritmos de procesamiento del lenguaje natural no operan directamente sobre el texto en su forma original, sino que requieren una etapa previa de preprocesamiento sobre el texto a trabajar. El primer paso fundamental en este proceso es la tokenización, que consiste en segmentar el texto en unidades discretas denominadas tokens. Estas unidades pueden corresponder a palabras, subpalabras, morfemas, caracteres u otros tipos de segmentos, según el enfoque adoptado. Para ejemplificar, considérese el siguiente fragmento de texto:

#align(center, block[
  #set align(left)
  Texto original: "En un lugar lejano" \
  Tokenización a nivel palabra: `[En, un, lugar, lejano]` \
  Tokenización a nivel carácter: `[E, n, u, n, l, u, g, a, r, l, e, j, a, n, o]`
  ])

El uso de la tokenización tiene sus ventajas. Esta representación discreta del texto garantiza la reproducibilidad @jm3 en los algoritmos de NPL, porque los algoritmos trabajan sobre un alfabeto o conjunto de datos en común. Asimismo, la tokenización puede abordar el problema de las palabras desconocidas o los neologismos; sin embargo, esta capacidad depende fundamentalmente de la definición del vocabulario subyacente de tokens. A estas palabras desconocidas se le suelen llamar fuera del vocabulario (_Out of Vocabulary_, OOV).

Un primer enfoque de cómo se pueden generar los tokens es la tokenización por palabras, aunque tiene limitaciones @jm3 importantes. Por un lado, lenguas como el chino y el japonés no tienen espacios entre palabras, lo que dificulta la tokenización cuando se asume que cada palabra está separada por espacios. Por otro lado, no hay forma de procesar términos OOV, como los neologismos, sin expandir constantemente el vocabulario, que crece con el paso del tiempo. Esto es evidente en tareas como la traducción @sennrich-etal-2016-neural de palabras raras y desconocidas, donde los mecanismos al nivel de palabra no son suficientes para lenguas que tienen procesos productivos para formar palabras.

Para abordar estas limitaciones, una alternativa al uso de palabras es emplear subpalabras como conjunto de tokens. Las subpalabras son unidades que pueden ser más pequeñas que una palabra y pueden corresponder a palabras completas, cadenas arbitrarias o incluso morfemas.

La ventaja de las subpalabras se vuelve evidente cuando un modelo se enfrenta a palabras desconocidas. Si un modelo intenta aprender el significado de una palabra que aparece en muy pocas instancias, lo que limita su capacidad de generalización. En cambio, cuando el modelo utiliza unidades más pequeñas, como las subpalabras, dispone de más evidencia distribuida a lo largo del corpus. Como resultado, los modelos basados en subpalabras logran un mejor manejo de palabras desconocidas @sennrich-etal-2016-neural.

=== Codificación de Pares de Bytes

La codificación de pares de bytes (_Byte-Pair Encoding_, BPE) @Gage1994ANA fue uno de los primeros algoritmos en demostrar que las subpalabras funcionan mejor que palabras completas @sennrich-etal-2016-neural en los modelos de lenguaje. Originalmente BPE fue ideado como un algoritmo de compresión de datos, pero posteriormente se le dió el uso para generar subpalabras a partir de una cadena de texto.

// Basado en el algoritmo original, pero sería buena idea encontrar algo similar
El algoritmo BPE identifica y remplaza iterativamente los pares de caracteres más frecuentes por un nuevo símbolo, generando así subpalabras. Por su naturaleza, BPE es un algoritmo voraz. La descripción del algoritmo para obtener las subpalabras es la siguiente:

// Mejorar la descripción del algoritmo
1. Se obtienen los pares de símbolos $[a_i, j_i]$ y sus frecuencias $f([a_i, b_j])$
2. Se obtiene:
$ [a, b] = op("argmáx", limits: #true)_(a_i b_i) {f[a_i, b_j] : a_i, b_j in Sigma} $
3. Se hace el remplazo por el símbolo $a b$en cada palabra del vocabulario:
$ [a,b] -> a b $ 
4. Se agrega e símbolo $a b$ al alfabeto $Sigma$ y se repite el proceso hasta alcanzar un número predeterminado de operaciones.

//Ejemplificando, podemos tomar el siguiente ejemplo:

//#align(center)[
//  _El perro camina por el parque cada mañana y sigue el mismo camino. Huele el pasto, mira a la gente pasar y se sienta un momento bajo el árbol. El parque cambia con el día, pero el perro disfruta siempre del mismo paseo._
//]


// TODO: Poner otro algoritmo aquí también
Con un modelo BPE ya entrenado, la tokenización a nivel de subpalabra de un texto nuevo se obtiene a partir de un procedimiento bien definido. En primer lugar, el modelo segmenta el texto nuevo a nivel de caracteres. A continuación, el modelo aplica de forma iterativa las reglas de reemplazo que BPE aprendió durante el entrenamiento. Este proceso combina secuencias de caracteres según las reglas aprendidas y produce finalmente la representación del texto en subpalabras. 

Por ejemplo, al procesar la oración:

// Esto es sacado de chatgpt, pero podría ser bueno hacerlo por cuenta propria con un corpus en español y usando alguna biblioteca de BPE.
// Otro TODO es mejorar la presentación de esto

#align(center, box[
  #set align(left)
  Las supernovas estallan en galaxias lejanas.
])

El resultado sería el siguiente, usando el tokenizador que usa GPT-5.x:
#align(center, box[
  #set align(left)

  #highlight(fill: rgb("#9a8ce7"))[Las]
  #highlight(fill: rgb("#8bd4b2"))[ super]#highlight(fill: rgb("#4aa3c7"))[nov]#highlight(fill: rgb("#9a8ce7"))[as ]
  #highlight(fill: rgb("#4aa3c7"))[ est]#highlight(fill: rgb("#8bd4b2"))[allan ]
  #highlight(fill: rgb("#4aa3c7"))[ en ]
  #highlight(fill: rgb("#c9a24d"))[ galax]#highlight(fill: rgb("#9a8ce7"))[ias ]
  #highlight(fill: rgb("#c9a24d"))[ lej]#highlight(fill: rgb("#8bd4b2"))[anas]#highlight(fill: rgb("#c9a24d"))[. ]
])

E incluso obtenemos los identificadores de los tokens:

#align(center, box[
  #set align(left)

  `[23040, 2539, 13802, 288, 893, 180529, 469, 100558, 2682, 105104, 14457, 13]`
])

// También expandir esto cuando tengamos mejores resultados
Cuando tenemos un modelo de BPE entrenado, podemos observar subpalabras que son frecuentes en las palabras, como "ción" en terminación, disminución, adjunción; y subpalabras que no son frecuentes en las palabras pero si por sí solas, como "un", "los", entre otros.

=== Métodos estadísticos de tokenización

// Obtenido de chatGPT, hay que hacer una investigación sobre esto
// sobretodo porque no hay muchas fuentes que mencionen cómo funciona wordpiece
// https://aclanthology.org/2021.emnlp-main.160.pdf?utm_source=chatgpt.com
// También el paper de BERT
WordPiece es un algoritmo de tokenización por subpalabras utilizado en muchos modelos de lenguaje basados en transformadores, especialmente en BERT (Bidirectional Encoder Representations from Transformers). En lugar de tratar cada palabra como un solo token, WordPiece segmenta el texto en unidades más pequeñas llamadas subpalabras, extraídas de un vocabulario fijo aprendido a partir de datos. Esto permite representar palabras raras o no vistas previamente como combinaciones de subpalabras, reduciendo el problema de palabras fuera de vocabulario y manteniendo un tamaño de vocabulario manejable. WordPiece utiliza una estrategia voraz de "coincidencia más larga primero" (greedy longest-match) para dividir las palabras en los tokens de subpalabra más largos del vocabulario que coinciden con el texto de entrada.

En el modelo BERT original, la tokenización con WordPiece produce un vocabulario de aproximadamente 30 000 subpalabras, y los tokens que no están en el vocabulario se dividen en piezas más pequeñas o se asignan a un token especial [UNK].

Para entrenar su vocabulario, WordPiece comienza con caracteres individuales y construye iterativamente unidades más grandes basándose en criterios estadísticos para maximizar la verosimilitud en el corpus de entrenamiento. Una vez que el vocabulario está fijado, el tokenizador procesa nuevo texto dividiendo las palabras en estas subpalabras aprendidas.