== IA y procesamiento de lenguaje natural

La inteligencia artificial (IA) busca crear sistemas computacionales capaces de realizar tareas que requieren inteligencia humana. Entre estas tareas se incluyen el razonamiento, el aprendizaje, la percepción, la toma de decisiones y el procesamiento del lenguaje natural (PLN).

El procesamiento del lenguaje natural estudia cómo las computadoras procesan el lenguaje humano. Dentro de este marco, el PLN forma parte de las ciencias de la computación y mantiene una relación estrecha con la inteligencia artificial. A partir de esta base, el PLN da lugar a aplicaciones como el reconocimiento de voz, la traducción automática y la generación de texto. En la vida cotidiana, estas aplicaciones aparecen en herramientas como el autocorrector, los filtros de spam y los asistentes de voz. Más recientemente, el avance del PLN ha permitido el desarrollo de sistemas más complejos, como los chatbots capaces de generar texto, imágenes y videos a partir de mensajes expresados en lenguaje natural.

En este sentido, uno de los objetivos del procesamiento del lenguaje natural (NLP) es modelar el lenguaje natural. En sus primeras etapas, este objetivo se abordó mediante el uso de reglas gramaticales explícitas. De hecho, este enfoque se utilizó en una de las primeras demostraciones de traducción automática, en la que una máquina operacional tradujo texto del ruso al inglés @hutchins-2004-georgetown.

// Quizá podemos introducir esto? https://aclanthology.org/J96-1002.pdf
// También podemos introducir el enfoque de probabilida
Sin embargo, modelos de lenguaje estadísticos (_Statistical Language Model_, SLM) @brown-etal-1990-statistical demostraron tener mejores resultados en tareas de NLP. Para tareas de traducción, esto se modelaba de la siguiente manera:

$ P("Texto traducido" | "Texto en la lengua original") $

// Quizá podemos expandir un poco más a los n-gramas
// Definiciones cortas al menos, para contextualizar un poco y dar enfásis al siguiente punto
Estos SML se implementaron usando $n$-gramas, que son subsecuencias de $n$ elementos.

No obstante, estos modelos suelen sufrir la maldición de la dimensionalidad @zhao2025surveylargelanguagemodels. En este escenario, estimar con precisión modelos de lenguaje de alto orden resulta difícil, porque estos modelos utilizan contextos largos y, en consecuencia, requieren calcular un número exponencial de probabilidades de transición.

Para mitigar esta problemática, la investigación comenzó a orientarse hacia los modelos de lenguaje neuronales (_Neural Language Models_, NLM). El trabajo de #cite(<bengio2003>, form: "prose") propuso reemplazar el conteo discreto por representaciones distribuidas, donde las palabras se representan como vectores en un espacio continuo. Esto permite que el modelo pueda generalizar mejor, ya que es capaz de identificar similitudes entre palabras con significados relacionados, incluso cuando no aparecen juntas con frecuencia en el corpus de entrenamiento.

Más adelante, este enfoque se consolidó con el modelo Word2Vec @mikolov2013efficientestimationwordrepresentations. A diferencia de los modelos neuronales anteriores, Word2Vec utilizó una arquitectura más simple, eliminando capas ocultas no lineales, lo que permitió entrenar el modelo de forma más rápida y con grandes cantidades de datos. Gracias a esto, los modelos de lenguaje pudieron representar las palabras mediante vectores densos y capturar relaciones entre ellas, reduciendo además el costo computacional en comparación con los métodos estadísticos tradicionales.