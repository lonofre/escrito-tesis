#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

== La inteligencia artificial y el procesamiento de lenguaje natural

Los modelos de lenguaje son uno de los principales puntos de encuentro entre la inteligencia artificial (IA) y el procesamiento del lenguaje natural (PLN), la disciplina que se ocupa de que las computadoras entiendan y generen lenguaje humano. Su historia puede leerse como un retiro gradual: cada generación de modelos usó menos reglas escritas por lingüistas y más estadística, hasta que el conocimiento lingüístico explícito desapareció del diseño.

No siempre fue así. Los primeros sistemas de PLN modelaron la lengua mediante reglas gramaticales explícitas, escritas por lingüistas. Estos sistemas iban desde el experimento Georgetown-IBM @hutchins-2004-georgetown, una de las primeras demostraciones de traducción automática, que empleó apenas 6 reglas, hasta arquitecturas más elaboradas como EUROTRA @johnson-etal-1985-eurotra @varile-lau-1988-eurotra, que analizaba sintáctica y semánticamente la lengua de origen para transferir esa representación a la lengua destino. En ambos casos, construir un modelo funcional exigía un intenso trabajo lingüístico; ese costo fue, a la larga, la razón de su abandono.

El primer cambio llegó con los modelos de lenguaje estadísticos (_Statistical Language Model_, SLM), que reemplazaron ese enfoque al demostrar mejores resultados @brown-etal-1990-statistical: en lugar de partir de reglas predefinidas, infieren los patrones más probables del lenguaje mediante conteos sobre grandes corpus. Las reglas dejaron de escribirse a mano: si quedaba algo de lingüística, estaba en los datos. Formalmente, un modelo de lenguaje define una probabilidad sobre una secuencia de palabras $w_(1:T) = (w_1, w_2, dots, w_T)$ @bengio2003

$ P(w_(1:T)) = product_(t=1)^(T) P(w_t | w_(1:t-1)) $

donde cada $w_i$ pertenece a un vocabulario $V$. Estimar estas probabilidades condicionales se vuelve impracticable conforme crece la secuencia, por lo que los SLM recurrieron a los n-gramas: bajo la suposición de Markov @Markov_2006, cada palabra depende sólo de las $N$ anteriores y no de la secuencia entera.

=== Grandes Modelos de Lenguaje

No obstante, los n-gramas enfrentan la maldición de la dimensionalidad @bengio2003 @zhao2025surveylargelanguagemodels: capturar contextos largos exige estimar un número exponencial de probabilidades de transición. Los modelos de lenguaje basados en redes neuronales (_Neural Network Language Models_, NNLM) abandonaron el conteo y representaron las palabras como vectores en un espacio continuo @bengio2003 @mikolov2013efficientestimationwordrepresentations, lo que permite generalizar entre palabras de significado relacionado aun cuando no aparezcan juntas en el corpus.

Esta representación vectorial es la base de la arquitectura _Transformer_ @attention-is-all, que introdujo el mecanismo de atención para relacionar tokens del contexto sin importar su distancia en la secuencia, y sobre la cual se construyeron modelos como BERT @bert y GPT @gpt2. En ninguna parte de esta arquitectura hay una regla gramatical: todo lo que el modelo sabe de la lengua lo aprende de los datos. O casi todo.

En el centro de toda esta arquitectura está el token: la unidad mínima sobre la que el modelo construye sus representaciones. El token, sin embargo, no es algo que el modelo descubra por sí mismo, sino el producto de un proceso previo de segmentación del texto. De cómo se realice esa segmentación, y en particular de qué unidades produzca, depende la representación inicial del texto que el modelo recibe como entrada, y con ella, la materia prima sobre la que se construye todo lo demás.