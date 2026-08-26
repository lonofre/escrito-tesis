#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

== La inteligencia artificial y el procesamiento de lenguaje natural

Uno de los principales puntos de encuentro entre la inteligencia artificial (IA) y el procesamiento del lenguaje natural (PLN), la disciplina que busca que las computadoras entiendan y generen lenguaje humano, son los modelos de lenguaje. La historia de estos modelos puede leerse como un abandono progresivo de sus orígenes, en la que cada generación de modelos usó menos reglas escritas por lingüistas y más estadística, hasta que el conocimiento lingüístico explícito desapareció del diseño.

Pero no siempre fue así. Los primeros sistemas de PLN modelaron la lengua mediante reglas gramaticales explícitas, escritas por lingüistas. Entre estos sistemas están el experimento Georgetown-IBM de 1954, una de las primeras demostraciones de traducción automática, que empleó apenas 6 reglas @hutchins-2004-georgetown, y sistemas de conversación como ELIZA @eliza1966. En ambos casos, construir un modelo funcional exigía un intenso trabajo lingüístico, que a la larga fue la razón de su abandono.

El primer cambio respecto a las reglas gramaticales llegó con los modelos de lenguaje estadísticos (_Statistical Language Model_, SLM), que reemplazaron ese enfoque al demostrar mejores resultados @brown-etal-1990-statistical. 

En lugar de partir de reglas predefinidas, los SLM infieren los patrones más probables del lenguaje mediante conteos sobre grandes corpus. Para ello, un modelo de lenguaje necesita dos elementos: un vocabulario $V$, el conjunto de unidades con las que se forman las cadenas, y una función que asigne una probabilidad a cada combinación posible de esas unidades @Mijangos-Ximena-2024. La dificultad está en cómo estimar esa función.

Una de las primeras soluciones la dio Claude Shannon @shannon1948, quien planteó lo que llamó una aproximación de orden n: en lugar de calcular la probabilidad de toda la cadena de una vez, la divide en probabilidades condicionales, es decir, la probabilidad de que aparezca una palabra dado que ya vimos las $t-1$ palabras anteriores @Mijangos-Ximena-2024. Así, para una secuencia de palabras $w_(1:T) = (w_1, w_2, dots, w_T)$, con cada $w_i in V$, la probabilidad de la cadena completa se estima como:

$ P(w_(1:T)) = product_(t=1)^(T) P(w_t | w_(1:t-1)) $

Sin embargo, estimar estas probabilidades condicionales se vuelve inviable conforme crece la secuencia, por lo que los SLM recurrieron a los n-gramas. Siguiendo a la suposición de Markov @markov1913, los n-gramas asumen que cada palabra depende solo de las $N$ anteriores y no de la secuencia entera. Para lograr esta suposición, es necesario un conteo de los n-gramas que aparecen en un corpus.

No obstante, usar vocabularios grandes o capturar contextos largos con n-gramas exige estimar un número exponencial de probabilidades de transición, un problema conocido como la maldición de la dimensionalidad @bengio2003 @zhao2025surveylargelanguagemodels. Este fue uno de los principales problemas que impulsó la transición hacia los modelos neuronales: la necesidad de realizar mejores estimaciones de las probabilidades mediante redes neuronales artificiales y, al mismo tiempo, obtener representaciones vectoriales semánticas de los tokens del vocabulario como parte del mismo proceso.

=== Grandes Modelos de Lenguaje

Los modelos de lenguaje basados en redes neuronales (_Neural Network Language Models_, NNLM) sustituyeron el conteo de n-gramas por una función continua sobre representaciones vectoriales de las palabras @bengio2003, conocidos como incrustaciones (_embeddings_). En este espacio vectorial, palabras que aparecen en contextos similares quedan representadas por vectores cercanos, y como la función que predice la siguiente palabra es continua, el modelo puede generalizar entre esos vectores vecinos. Así, es posible asignar una probabilidad razonable a una combinación de palabras que nunca se vio en el corpus de entrenamiento, si es similar a otras que sí fueron observadas, lo cual mitiga la maldición de la dimensionalidad.

Estas representaciones vectoriales son la base de la mayoría de los modelos de lenguaje actuales, conocidos como los grandes modelos de lenguaje (_Large Language Models_, LLMs), que incluyen a BERT @bert y GPT @gpt2. Estos modelos se basan en una arquitectura de red neuronal particular, llamada _Transformer_ @attention-is-all. La @diagrama-transformers muestra cómo está conformado un Transformer.

#figure(
  image("img/transformer-con-tokenizacion.svg", width: 70%),
  caption: [Modelo simplificado de la arquitectura de Transformers, adaptado de #cite(<attention-is-all>, form: "prose") para incluir el rol del tokenizador en la entrada del modelo.]
)<diagrama-transformers>

La tokenización puede verse como el proceso de segmentar las cadenas de texto en unidades más fundamentales, estas unidades son convertidas después a representaciones numéricas (vectores/embeddings) que sirven para entrenar una red neuronal artificial. Un modelo del lenguaje no aprende cuáles son las unidades más apropiadas en qué se debe segmentar una cadena en lenguaje natural, más bien, la tokenización es un proceso a parte que tiene mucho impacto en el desempeño del sistema final.

Como se observa en @diagrama-transformers, un Transformer recibe como entrada una secuencia de tokens (unidades en la que se divide el texto), sigue una serie de operaciones matriciales dentro de los bloques, y da como salida una distribución de probabilidad sobre el siguiente token. La estructura de estas operaciones está definida por el diseño de la arquitectura, mientras que sus parámetros, es decir, los valores concretos que usan, se aprenden a partir de los tokens observados durante el entrenamiento. El objetivo no cambió respecto a los n-gramas, porque el modelo sigue estimando la probabilidad del siguiente elemento dado el contexto previo y con esa estimación genera la secuencia un elemento a la vez @Mijangos-Ximena-2024. Lo que cambió es la unidad sobre la que se estima, que ya no es la palabra sino el token.

Por ende, cabe preguntarse qué influencia tienen los tokens sobre estos modelos. Sin embargo, recordemos que los tokens no son algo que el modelo descubre por sí mismo, sino el producto de un proceso previo de segmentación de textos. De cómo se realice esa segmentación, y en particular de qué unidades produzca, depende la representación inicial que el modelo recibe como entrada, y con ella, el punto de partida sobre el que se construye todo lo demás.