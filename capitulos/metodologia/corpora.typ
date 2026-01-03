== Datos/Corpus de entrenamiento multilingües

// Citar al Corpus dela biblia
El método para obtener los vectores de BPE que codifican la productividad, idiosincrasia y frecuencia acumulada se basó en la metodología de #cite(<ximena-bpe-2023>, form: "prose"), aunque hubieron modificaciones debido al cambio de versión de bibliotecas utilizadas, como un sistema operativo diferente. Este enfoque lo logramos encontrar públicamente en GitHub. De igual manera, hicimos uso del Corpus Paralelo de la Biblia (_Parallel Bible Corpus_, PBC), el cual contiene texto en 100 lenguas diferentes.

Este proceso consistió en transformar el corpus, que puede ser independiente al PBC, a una representación vectorial de cada lengua y que logramos almacenar en un archivo, todo esto usando el lenguaje de Python y programas de consola por defecto en sistemas UNIX/POSIX. El proceso consistió de x etapas:
- Tokenización a nivel palabra
- Preprocesamiento del corpus
- Generación del modelo de BPE
- Obtención de las métricas

En primer, necesitamos tokenizar el corpus a nivel palabra. La razón fue para diferenciar las palabras posteriormente mediante espacios. Logramos esto con el uso de _polyglot_, una biblioteca escrita en Python que tiene un soporte de 165 lenguas. Así que, una vez obtenidas las palabras, volvimos a reconstruir el corpus original, pero ahora con palabras.

Una vez realizado el paso anterior, lo que siguió fue hacer otro preprocesamiento del texto con la intención de obtener un mejor modelo de BPE. Este preprocesamiento incluyó convertir todo el texto en minúsculas. Estuvimos consientes que en algunas lenguas la relación mayúscula-minúscula no es igual a como está definida en la versión `lower()` de Python, pero por temas de reproducibilidad decidimos dejarlo así. El segundo paso fue remover del texto los signos de puntuación _.,"()?¿?¡!»«“”،/\]_, de igual manera para tener un mejor modelo de BPE y su posterior uso en el mismo corpus preprocesado:

#align(center)[_Hola, ¿cómo estás?_ $->$ _hola como estás_ ]

// Citar otra vez a Ximena (poner la cita adecuado)
Una vez preprocesados los corpus por cada idioma, lo siguiente fue correr un programa que genera un modelo BPE a partir de un texto. En nuestro caso, fue `subword-nmt` con 200 merges en la configuración, que es el máximo de operaciones merge que hace el programa. Esto debido a como Ximena et. Al. sugirieron como buen punto de referencia.

Con el modelo de BPE, podemos calcular las medidas. Primero debemos que usar el archivo del corpus preprocesado (no el original) para aplicarle nuestro modelo BPE con `subword-nmt`. Una vez esto, podemos calcular las medidas de productividad, idiosincrasia y el otro.