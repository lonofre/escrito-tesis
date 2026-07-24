#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge
#import "diagramas/transformer.typ": transformer-diagrama2

== La inteligencia artificial y el procesamiento de lenguaje natural

Uno de los principales puntos de encuentro entre la inteligencia artificial (IA) y el procesamiento del lenguaje natural (PLN), la disciplina que busca que las computadoras entiendan y generen lenguaje humano, son los modelos de lenguaje. La historia de estos modelos puede leerse como un abandono progresivo de sus orígenes, en la que cada generación de modelos usó menos reglas escritas por lingüistas y más estadística, hasta que el conocimiento lingüístico explícito desapareció del diseño.

Pero no siempre fue así. Los primeros sistemas de PLN modelaron la lengua mediante reglas gramaticales explícitas, escritas por lingüistas. Estos sistemas iban desde el experimento Georgetown-IBM @hutchins-2004-georgetown, una de las primeras demostraciones de traducción automática, que empleó apenas 6 reglas, hasta arquitecturas más elaboradas como EUROTRA @johnson-etal-1985-eurotra @varile-lau-1988-eurotra, que analizaba sintáctica y semánticamente la lengua de origen para transferir esa representación a la lengua destino. En ambos casos, construir un modelo funcional exigía un intenso trabajo lingüístico, que a la larga fue la razón de su abandono.

El primer cambio respecto a las reglas gramaticales llegó con los modelos de lenguaje estadísticos (_Statistical Language Model_, SLM), que reemplazaron ese enfoque al demostrar mejores resultados @brown-etal-1990-statistical. 

En lugar de partir de reglas predefinidas, los SLM infieren los patrones más probables del lenguaje mediante conteos sobre grandes corpus. Formalmente, un SLM define una probabilidad sobre una secuencia de palabras $w_(1:T) = (w_1, w_2, dots, w_T)$ @bengio2003.

$ P(w_(1:T)) = product_(t=1)^(T) P(w_t | w_(1:t-1)) $

donde cada $w_i$ pertenece a un vocabulario $V$. Sin embargo, estimar estas probabilidades condicionales se vuelve inviable conforme crece la secuencia, por lo que los SLM recurrieron a los n-gramas. Siguiendo a la suposición de Markov @Markov_2006, los n-gramas asumen que cada palabra depende solo de las $N$ anteriores y no de la secuencia entera. Para lograr esta suposición, es necesario un conteo de los n-gramas que aparecen en un corpus.

No obstante, usar vocabularios grandes o capturar contextos largos con n-gramas exige estimar un número exponencial de probabilidades de transición, un problema conocido como la maldición de la dimensionalidad @bengio2003 @zhao2025surveylargelanguagemodels. Este fue uno de los principales problemas que ocasionó la transición hacia los modelos neuronales.

=== Grandes Modelos de Lenguaje

Los modelos de lenguaje basados en redes neuronales (Neural Network Language Models, NNLM) sustituyeron el conteo de n-gramas por una función continua sobre representaciones vectoriales de las palabras @bengio2003. En este espacio vectorial, palabras que aparecen en contextos similares quedan representadas por vectores cercanos, y como la función que predice la siguiente palabra es continua, el modelo puede generalizar entre esos vectores vecinos. Así, es posible asignar una probabilidad razonable a una combinación de palabras que nunca se vio en el corpus de entrenamiento, si es similar a otras que sí fueron observadas, lo cual mitiga la maldición de la dimensionalidad.

Estas representaciones vectoriales son la base de la mayoría de los modelos de lenguaje actuales, como BERT @bert y GPT @gpt2. Estos modelos se basan en una arquitectura de red neuronal particular, llamada _Transformer_ @attention-is-all. La @diagrama-transformers muestra cómo está conformado un Transformer.

#figure(
  transformer-diagrama2,
  caption: [Modelo de la arquitectura de Transformers, tomado de #cite(<attention-is-all>, form: "prose").]  
)<diagrama-transformers>

Como se observa en @diagrama-transformers, un Transformer recibe como entrada una secuencia de tokens (unidades en la que se divide el texto), sigue una serie de operaciones matriciales dentro de los bloques, y da como salida una distribución de probabilidad sobre el siguiente token. La estructura de estas operaciones está definida por el diseño de la arquitectura, mientras que sus parámetros, es decir, los valores concretos que usan, se aprenden a partir de los tokens observados durante el entrenamiento.

Por ende, cabe preguntarse qué influencia tienen los tokens sobre estos modelos. Sin embargo, los tokens no son algo que el modelo descubre por sí mismo, sino el producto de un proceso previo de segmentación de textos. De cómo se realice esa segmentación, y en particular de qué unidades produzca, depende la representación inicial que el modelo recibe como entrada, y con ella, el punto de partida sobre el que se construye todo lo demás.