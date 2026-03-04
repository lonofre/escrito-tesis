#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

/*
   Esta sección es sobre cómo vamos a generar el espacio de BPE.
*/
// Lo cambiaría a generación del espacio de BPE????
== Datos/Corpus de entrenamiento multilingües

// TODO: Aquí queremos transmitir cómo se generó el espacio de BPE. Comunica eso de acorde
// También (a futuro) especifica si usaste todas las lenguas o no, esto es importante.

Para obtener los vectores del espacio de BPE, usamos la metodología propuesta por #cite(<ximena-bpe-2023>, form: "prose"), la cual toma un texto en una lengua y lo transforma en un vector que caracteriza la productividad, idiosincrasia y frecuencia acumulada de dicha lengua mediante las subpalabras generadas por un modelo de BPE. Así, obtuvimos un vector por cada una de las $x$ lenguas definidas en _placeholder_.

Como datos de entrada en este proceso, utilizamos el Corpus Paralelo de la Biblia (_Parallel Bible Corpus_, PBC) @mayer-cysouw-2014-creating. Usando un corpus paralelo, trabajamos con un texto similar a través de las lenguas.

Para el procesamiento, utilizamos la implementación del proceso que estuvo disponible en GitHub. El programa usó Python y utilidades de UNIX. Sin embargo, modificamos ligeramente algunas partes del código debido a que usamos macOS para obtener los vectores. Realizamos este proceso por cada lengua y fue organizado en las siguientes etapas:
/*
#align(center, diagram(
  debug: true,
  (
    node((0, 0), [#text("Tokenización a nivel palabra", size: 10pt)], stroke: 1pt),
    node((0, 1), [#text("Preprocesamiento", size: 10pt)], stroke: 1pt),
    node((0, 2), [#text("Generación del modelo BPE", size: 10pt)], stroke: 1pt),
    node((0, 3), [#text("Obtención de las métricas", size: 10pt)], stroke: 1pt),
  ).intersperse(edge("-|>")).join())
)
*/
1. _Tokenización a nivel de palabra._

   // Quizá valga la pena checar este paso con lenguas como el japonés, que no tienen bien definido la
   // palabra ortográfica
   En esta etapa, el corpus se dividió en palabras ortográficas para establecer la base del procesamiento posterior. Así, las palabras son diferenciables mediante espacios. Esta distinción es útil para lenguas como el japonés.

2. _Preprocesamiento del corpus._

   Realizamos otro preprocesamiento del texto para obtener un mejor modelo de BPE. Esto incluyó: 
   - Transformar todos los caracteres del texto en minúsculas. Estuvimos consientes que en algunas lenguas la relación mayúscula-minúscula no es igual a como está definida en la versión `lower()` de Python, pero por temas de reproducibilidad decidimos dejarlo así. 
   - El segundo paso fue remover del texto los signos de puntuación `_.,"()?¿?¡!»«“”،/\]_`.

   Un ejemplo del preprocesamiento es el siguiente:

   #align(center)[_Hola, ¿cómo estás?_ $->$ _hola como estás_ ]

3. _Generación del modelo BPE._

   // Hablar mejor del número de merges
   Lo siguiente fue generar un modelo BPE a partir del texto. El programa que usamos fue `subword-nmt`, configurado con 200 merges. Este número es sugerido como un punto de inflexión donde la entropía de las lenguas es menos dispersa @ximena-bpe-2021.

4. _Obtención de las métricas por subpalabra._

  // Citar otra vez a Ximena (poner la cita adecuado)
   Usamos el modelo entrenado de BPE para calcular las medidas de productividad, idiosincrasia y frecuencia acumulada de cada subpalabra:
   1. Primero debemos que usar el archivo del corpus preprocesado para aplicarle nuestro modelo BPE con `subword-nmt`.
   2. Una vez esto, podemos calcular las medidas de productividad, frecuencia acumulada e idiosincrasia.

5. _Obtención de las métrica por lengua._

   Finalmente, promediamos las métricas obtenidas de cada subpalabra para obtener la representación vectorial de cada lengua.

// Como nota a futuro: Con Ximena, estamos viendo si el StandardScaler que le hacemos al espacio a BPE hace algun efecto en los resultados de los algoritmos. Entonces, como esta sección es para generar el espacio de BPE, debemos incluir eso también si se logra a aplicar.

El resultado final fue una matriz $X in RR^(n times 3)$, el cual llamamos espacio BPE. Normalizamos este espacio para la aplicación de los otros métodos:

$ Z_(i j) = (X_(i j) - mu_j) / sigma_j $