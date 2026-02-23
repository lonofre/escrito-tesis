#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

// Lo cambiaría a generación del espacio de BPE????
== Datos/Corpus de entrenamiento multilingües

// Como nota a futuro: Con Ximena, estamos viendo si el StandardScaler que le hacemos al espacio a BPE hace algun efecto en los resultados de los algoritmos. Entonces, como esta sección es para generar el espacio de BPE, debemos incluir eso también si se logra a aplicar.

// TODO: Aquí queremos transmitir cómo se generó el espacio de BPE. Comunica eso de acorde

Para obtener los vectores del espacio de BPE que codifican la productividad, idiosincrasia y frecuencia acumulada, nos basamos en metodología propuesta por #cite(<ximena-bpe-2023>, form: "prose"). Entrenamos modelos de BPE .

Sin embargo, fue necesario realizar modificaciones debido al uso de versiones distintas de bibliotecas y a un sistema operativo diferente al del experimento original. El código para generar los vectores lo encontramos disponible públicamente en GitHub. Además, utilizamos el Corpus Paralelo de la Biblia (_Parallel Bible Corpus_, PBC), el cual contiene textos en aproximadamente 100 lenguas diferentes @mayer-cysouw-2014-creating.

Este proceso tomó el PBC y creó una representación vectorial para cada lengua. Para llevar a cabo esta transformación, utilizamos Python y herramientas de consola disponibles en sistemas UNIX/POSIX. El procedimiento se organizó en las siguientes etapas:

#align(center, diagram(
  debug: true,
  (
    node((0, 0), [#text("Tokenización a nivel palabra", size: 10pt)], stroke: 1pt),
    node((0, 1), [#text("Preprocesamiento", size: 10pt)], stroke: 1pt),
    node((0, 2), [#text("Generación del modelo BPE", size: 10pt)], stroke: 1pt),
    node((0, 3), [#text("Obtención de las métricas", size: 10pt)], stroke: 1pt),
  ).intersperse(edge("-|>")).join())
)
1. _Tokenización a nivel de palabra._  

   // Quizá valga la pena checar este paso con lenguas como el japonés, que no tienen bien definido la
   // palabra ortográfica
   En esta etapa, el corpus se dividió en palabras para establecer la base del procesamiento posterior. La razón fue para diferenciar las palabras posteriormente mediante espacios. Logramos esto con el uso de _polyglot_, una biblioteca escrita en Python que tiene un soporte de 165 lenguas. Esto tiene más utilidad para lenguas como el japonés.
   
   Una vez obtenidas las palabras, volvimos a reconstruir el corpus original, pero ahora con palabras.

2. _Preprocesamiento del corpus._
   Lo que siguió fue hacer otro preprocesamiento del texto con la intención de obtener un mejor modelo de BPE. Este preprocesamiento incluyó: 
   - Convertir todo el texto en minúsculas. Estuvimos consientes que en algunas lenguas la relación mayúscula-minúscula no es igual a como está definida en la versión `lower()` de Python, pero por temas de reproducibilidad decidimos dejarlo así. 
   - El segundo paso fue remover del texto los signos de puntuación _.,"()?¿?¡!»«“”،/\]_, de igual manera para tener un mejor modelo de BPE y su posterior uso en el mismo corpus preprocesado:

   #align(center)[_Hola, ¿cómo estás?_ $->$ _hola como estás_ ]

3. _Generación del modelo BPE._  
   Después del preprocesamiento de los corpus por cada idioma, lo siguiente fue correr un programa que genera un modelo BPE a partir de un texto. En nuestro caso, fue `subword-nmt` con 200 merges en la configuración, que es el máximo de operaciones merge que hace el programa. Esto debido a como #cite(<ximena-bpe-2021>, form: "prose") #cite(<ximena-bpe-2023>, form: "prose") sugirieron como buen punto de referencia.

4. _Obtención de las métricas._
  // Citar otra vez a Ximena (poner la cita adecuado)
   Con el modelo de BPE, logramos calcular las medidas. 
   1. Primero debemos que usar el archivo del corpus preprocesado para aplicarle nuestro modelo BPE con `subword-nmt`.
   2. Una vez esto, podemos calcular las medidas de productividad, frecuencia acumulada e idiosincrasia.