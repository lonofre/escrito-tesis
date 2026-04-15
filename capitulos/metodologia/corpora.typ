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