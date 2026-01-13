== Tokenización a nivel subpalabra

Muchos algoritmos de procesamiento del lenguaje natural no operan directamente sobre el texto en su forma original, sino que requieren una etapa previa de transformación. El primer paso fundamental en este proceso es la tokenización, que consiste en segmentar el texto en unidades discretas denominadas tokens. Estas unidades pueden corresponder a palabras, subpalabras, morfemas, caracteres u otros tipos de segmentos, según el enfoque adoptado.

Para ejemplificar, considérese el siguiente fragmento de texto:

#align(center)[En un lugar muy muy lejano]

La tokenización con palabras es:

#align(center)[`[En, un, lugar, muy, muy, lejano]`]

Mientras que al usar caracteres es:

#align(center)[`[E, n, u, n, l, u, g, a, r, m, u, y, m, u, y, l, e, j, a, n, o]`]

La tokenización tiene ventajas. Esta representación discreta del texto garantiza la reproducibilidad @jm3 en los algoritmos de NPL. Asimismo, la tokenización puede abordar el problema de las palabras desconocidas o los neologismos; sin embargo, esta capacidad depende fundamentalmente de la definición del vocabulario subyacente de tokens.

Un primer enfoque de cómo se pueden generar los tokens es la tokenización por palabras, aunque tiene limitaciones @jm3 importantes. Por un lado, lenguas como el chino y el japonés no tienen espacios entre palabras, lo que dificulta la tokenización cuando se asume que cada palabra está separada por espacios. Por otro lado, no hay forma de procesar términos desconocidos, como los neologismos, sin expandir constantemente el vocabulario, que crece de manera exponencial. Esto es evidente en tareas como la traducción @sennrich-etal-2016-neural de palabras raras y desconocidas, donde los mecanismos al nivel de palabra no son suficientes para lenguas que tienen procesos productivos para formar palabras.

Para abordar estas limitaciones, una alternativa al uso de palabras como unidades básicas consiste en emplear subpalabras como conjunto de tokens. Las subpalabras son unidades que pueden ser más pequeñas que una palabra y pueden corresponder a palabras completas, cadenas arbitrarias o incluso morfemas.

La ventaja de las subpalabras se vuelve evidente cuando un modelo se enfrenta a palabras raras. Si un modelo intenta aprender el significado de una palabra que aparece en muy pocas instancias, lo que limita su capacidad de generalización. En cambio, cuando el modelo utiliza unidades más pequeñas, como las subpalabras, dispone de más evidencia distribuida a lo largo del corpus. Como resultado, los modelos basados en subpalabras logran un mejor manejo de palabras raras y desconocidas @sennrich-etal-2016-neural.

=== Codificación de Pares de Bytes

La codificación de pares de bytes (_Byte-Pair Encoding_, BPE) @Gage1994ANA fue uno de los primeros algoritmos en demostrar que las subpalabras funcionan mejor que palabras completas @sennrich-etal-2016-neural en modelos de lenguaje. Originalmente BPE fue ideado como un algoritmo de compresión de datos. Pero posteriormente se le dió el uso para generar subpalabras a partir de una cadena de texto.

// Basado en el algoritmo original, pero sería buena idea encontrar algo similar
El algoritmo BPE identifica y remplaza iterativamente los pares de caracteres más frecuentes por un nuevo símbolo, generando así subpalabras. La descripción del algoritmo para obtener las subpalabras es la siguiente:

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

Con un modelo BPE ya entrenado, la tokenización a nivel de subpalabra de un texto nuevo se obtiene a partir de un procedimiento bien definido. En primer lugar, el modelo segmenta el texto nuevo a nivel de caracteres. A continuación, el modelo aplica de forma iterativa las reglas de reemplazo que BPE aprendió durante el entrenamiento. Este proceso combina secuencias de caracteres según las reglas aprendidas y produce finalmente la representación del texto en subpalabras. Por ejemplo, al procesar la oración:

// Esto es sacado de chatgpt, pero podría ser bueno hacerlo por cuenta propria con un corpus en español y usando alguna biblioteca de BPE.
// Otro TODO es mejorar la presentación de esto
#align(center)[
  Durante el fin de semana, los mercados locales suelen llenarse de colores y aromas. 
]

El resultado sería el siguiente:

#align(center)[
  "Durante" "el" "fin" "de" "semana", "los" "mercados" "locales" "suelen" "llen" "arse" "de" "colores" "y" "aromas" "."
]

// También expandir esto cuando tengamos mejores resultados
Cuando tenemos un modelo de BPE entrenado, podemos observar subpalabras que son frecuentes en las palabras, como "ción" en terminación, disminución, adjunción; y subpalabras que no son frecuentes en las palabras pero si por sí solas, como "un", "los", entre otros.

=== Métodos estadísticos de tokenización