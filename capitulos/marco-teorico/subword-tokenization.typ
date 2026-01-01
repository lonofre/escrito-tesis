== Tokenización a nivel subpalabra

Los algoritmos de PLN no operan directamente sobre texto en su forma original. La tokenización constituye este primer paso fundamental: la segmentación del texto en unidades discretas denominadas tokens. Estos tokens pueden corresponder a palabras, subpalabras, morfemas, caracteres o cualquier otra unidad según el enfoque adoptado.

Considérese el siguiente fragmento de texto:

#align(center)[En un lugar muy muy lejano]

La tokenización resultante, en caso de elegir palabras como tokens, es:

#align(center)[`[En, un, lugar, muy, muy, lejano]`]

Mientras que al usar caracteres, sin contar al espacio como uno, es:

#align(center)[`[E, n, u, n, l, u, g, a, r, m, u, y, m, u, y, l, e, j, a, n, o]`]

Esta representación discreta del texto garantiza la reproducibilidad @jm3 en los algoritmos de NPL. Asimismo, la tokenización puede abordar el problema de palabras desconocidas o neologismos, aunque esta capacidad depende fundamentalmente de cómo se defina el vocabulario de tokens subyacente.

La tokenización por palabras tiene limitaciones @jm3 importantes. Por un lado, lenguas como el chino y el japonés no tienen espacios entre palabras, lo que complica tokenizar cuando se asume que cada palabra está separada por espacios. Por otro, no hay forma de procesar términos desconocidos, como los neologismos, sin expandir constantemente el vocabulario, que crece de manera exponencial. Esto es evidente en tareas como la traducción @sennrich-etal-2016-neural de palabras raras y desconocidas, donde los mecanismos al nivel de palabra no son suficientes para lenguas que tienen procesos productivos para formar palabras.

Para lidiar con palabras desconocidas, otro enfoque para el conjunto de tokens es usar subpalabras. Las subpalabras son unidades que pueden ser más pequeñas que una palabra. Pueden ser la misma palabra, una cadena arbitraria o incluso morfemas. 

La ventaja es evidente cuando un modelo de lenguaje trata con palabras raras. Si un modelo trata de aprender el significado de una palabra rara, va encontrar pocas instancias de esta. Mientras usando unidades más pequeñas como las subpalabras, los modelos pueden obtener mejores resultados @sennrich-etal-2016-neural para palabras raras y desconocidas.

=== Codificación de Pares de Bytes

La codificación de pares de bytes (Byte-Pair Encoding, BPE) @Gage1994ANA fue uno de los primeros algoritmos en demostrar que las subpalabras funcionan mejor que las palabras completas @sennrich-etal-2016-neural en modelos de lenguaje. Originalmente BPE fue ideado como un algoritmo de compresión de datos. Pero posteriormente se le dió el uso para generar subpalabras a partir de una cadena de texto.

// Basado en el algoritmo original, pero sería buena idea encontrar algo similar
El algoritmo BPE identifica y remplaza iterativamente los pares de caracteres más frecuentes por un nuevo símbolo, generando así subpalabras. La descripción del algoritmo es la siguiente:

1. Se obtienen los pares de símbolos $[a_i, j_i]$ y sus frecuencias $f([a_i, b_j])$
2. Se obtiene:
$ [a, b] = op("argmáx", limits: #true)_(a_i b_i) {f[a_i, b_j] : a_i, b_j in Sigma} $
3. Se hace el remplazo por el símbolo $a b$en cada palabra del vocabulario:
$ [a,b] -> a b $ 
4. Se agrega e símbolo $a b$ al alfabeto $Sigma$ y se repite el proceso hasta alcanzar un número predeterminado de operaciones.

// Aquí incluso valdría la pena usar BPE para procesar un corpus en español y ser más demostrativos, al fin no tenemos tanta restricción de espacio
Una vez teniendo un modelo BPE entrenado, teniendo el conjunto de reglas, la tokenización de un texto se obtiene al aplicar iterativamente las reglas aprendidas por BPE. Por ejemplo, 

Con un modelo BPE entrenado, la tokenización a nivel subpalabra de un texto nuevo se obtiene segmentando el texto nuevo a nivel de caracteres y aplicando iterativamente las reglas de reemplazo previamente aprendidas por BPE. Por ejemplo, al procesar la oración:

// Esto es sacado de chatgpt, pero podría ser bueno hacerlo por cuenta propria con un corpus en español y usando alguna biblioteca de BPE
#align(center)[
  Durante el fin de semana, los mercados locales suelen llenarse de colores y aromas. 
]

El resultado sería el siguiente:

#align(center)[
  "Durante" "el" "fin" "de" "semana", "los" "mercados" "locales" "suelen" "llen" "arse" "de" "colores" "y" "aromas" "."
]

Cuando tenemos un modelo de BPE entrenado, podemos observar subpalabras que son frecuentes en las palabras, como "ción" en terminación, disminución, adjunción; y subpalabras que no son frecuentes en las palabras pero si por sí solas, como "un", "los", entre otros.

=== Métodos estadísticos de tokenización