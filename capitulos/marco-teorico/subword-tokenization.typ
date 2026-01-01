== Tokenización a nivel subpalabra

// Agregar fuentes de los modelos de lenguaje (Libro de NLP)
La tokenización es la primera fase en el procesamiento del lenguaje natural. Consiste en segmentar el texto sobre el cual estamos trabajando en _tokens_. Los tokens, que pueden ser tanto palabras, morfemas, caracteres, entre otros, cuya elección puede afectar el rendimiento de nuestro programa de PLN.

La tokenización nos ayuda a crear un conjunto discreto en el que diversos algoritmos puedan basarse, permitiendo reproducibilidad. También nos ayuda con lidiar con palabras desconocidas.

Es tal su ayuda en Podemos encontrarlo en modelos de n-gramas, Tf-idf, HMMs, bayes naive, LLMs, etc.

Del siguiente texto:
#align(center)[En un lugar muy muy lejano]

Podemos obtener los tokens [En,un,lugar, muy,muy,lejano] si tomamos los tokens como palabras, mientras si usamos caracteres sería [E,n,u,n,l,u,g,a,r,m,u,y,m,u,y,m,u,y,l,e,j,a,n,o].

Sin embargo, como anteriormente mencionado, la elección de los tokens va a ayudar en el desempeño de nuestro programa de PLN. A su vez, la tarea de PLN que estemos haciendo influye en la decisión de los tokens a usar.

// Citar otra vez al libro de NLP
Usar palabras como tokens tienen sus problemas. En primer lugar, muchas lenguas no tienen palabras ortográficas. Segundo, el número de palabras crece constantemente, por la evolución de las lenguas a lo largo del tiempo.

// Citar otra vez al libro de NLP
Usar morfemas también tienen sus desafíos. Son difíciles de definir y muchas lenguas tienen morfemas complejos que son difíciles de segmentar para usarlo en nuestras aplicaciones de PLN. Mientras los caracteres son muy pequeños para usar.

Debido a esto, han surgido diferentes métodos para tokenizar texto.


=== Codificación de Pares de Bytes

// Citar aquí A New Algorithm for Data Compression
La Codificación de Pares de Bytes (Byte-Pair Encoding, BPE) es un algoritmo de compresión de datos. Uno de los usos de este algoritmo es el de generar subpalabras a partir de una cadena de texto, para que los modelos de lenguaje puedan procesarlos.
// Quizá mencionar GPT aquí?
// También mencionar que es un token

//Citar al libro de NLP
Las subpalabras son unidades más pequeñas que una palabra. Pueden ser cadenas arbitrarias o incluso morfemas.

// Basado en el algoritmo original, pero sería buena idea encontrar algo similar
El algoritmo BPE identifica y remplaza iterativamente los pares de caracteres más frecuentes por un nuevo símbolo, generando así unidades denominadas subpalabras:

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