#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

/*
  Al menos el primer enfoque que quiero darle a esta sección es relación IA-NLP, con un enfoque en los modelos de lenguaje (esta sería la relación y posiblemente uno de los personajes principales). Quiero hacer énfasis en los tokens y cómo son usados en estos modelos de lenguajes.
*/
== La inteligencia artificial y el procesamiento de lenguaje natural

// TODO: Leyendo esto de nuevo, debemos mejorar cómo introducir esta sección que va a hablar principalmente de modelos de lenguaje
Los modelos de lenguaje han sido uno de los puntos de interacción entre la inteligencia artificial (IA) y el procesamiento del lenguaje natural (PLN). Esta intersección impulsó décadas de investigación y la confluencia de varias disciplinas. En el centro de todo ello, las palabras han sido el elemento fundamental sobre el que se construyó toda representación y generación del lenguaje. Para comprender el alcance de esta evolución, es necesario partir desde la propia naturaleza de los modelos de lenguaje.

Por tanto, los modelos de lenguaje son el resultado del PLN para representar y comprender el lenguaje humano. Así mismo, las formas de modelar el lenguaje natural han ido cambiando a lo largo del tiempo, teniendo influencia en los resultados de las tareas y sistemas de PLN.

En los primeros sistemas de PLN, el modelado del lenguaje natural se abordó mediante reglas gramaticales explícitas —denotables con gramáticas libres de contexto— con una fuerte influencia lingüística. Esto puede observarse desde una de las primeras demostraciones de traducción automática, el experimento Georgetown-IBM @hutchins-2004-georgetown, que empleó solo 6 reglas gramaticales, hasta arquitecturas más elaboradas como EUROTRA#footnote[EUROTRA fue un proyecto de traducción automática establecido y financiado por la Comisión Europea desde 1978 hasta 1992.], cuyo modelo de transferencia @johnson-etal-1985-eurotra @varile-lau-1988-eurotra realizaba un análisis sintáctico y semántico de la lengua de origen para luego transferir dicha representación a la lengua destino. En ambos casos, estos enfoques requerían un intenso trabajo lingüístico para definir las reglas y construir un modelo de lenguaje funcional.

No obstante, los modelos de lenguaje estadísticos (_Statistical Language Model_, SLM) reemplazaron a los modelos basados en reglas al demostrar mejores resultados en tareas de NLP @brown-etal-1990-statistical. En lugar de partir de un conjunto predefinido de reglas lingüísticas, los SLM infieren los patrones más probables del lenguaje mediante el conteo sobre grandes corpus de texto. Esto representó un cambio de paradigma en el desarrollo de los sistemas de PNL a formularse como problemas estadísticos.

De esta manera, un modelo de lenguaje define una probabilidad sobre una secuencia de palabras $w_(1:T) = (w_1, w_2, dots, w_T)$ @bengio2003

$ P(w_(1:T)) = product_(t=1)^(T) P(w_t | w_(1:t-1))) $

donde cada $w_i$ pertenece a un vocabulario $V$. De esta manera, la probabilidad de $w_(1:T)$ se puede descomponer en probabilidades condicionales, lo cual define los parámetros que el modelo tiene que aprender. Sin embargo, a medida que la secuencia de palabras incrementa, así los parámetros también.

En consecuencia, el problema se centró en aproximar el calculo de estas probabilidades para los modelos de lenguaje. Es por esto en los SML predominó el uso de n-gramas, que son subsecuencias de $N$ elementos o palabras. Los n-gramas usan la suposición de Markov @Markov_2006, donde la suposición que cada probabilidad condicional sólo depende de los previos $N$ términos y no de la secuencia entera. A partir de esta suposición se construye el modelo de n-gramas.

=== Grandes Modelos de Lenguaje

No obstante, los modelos de n-gramas enfrentan un problema fundamental: la maldición de la dimensionalidad @bengio2003 @zhao2025surveylargelanguagemodels al querer usar contextos –valores de $n$– largos. Estimar con precisión modelos de lenguaje de alto orden resulta difícil y en consecuencia, requieren calcular un número exponencial de probabilidades de transición, lo cual aumenta su costo computacional.

Para resolver este problema, la investigación recurrió a los modelos de lenguaje basados en redes neuronales (_Neural Network Language Models_, NNLM). Este enfoque abandonó el conteo de palabras y, en su lugar, las representó como vectores en un espacio continuo @bengio2003 @mikolov2013efficientestimationwordrepresentations. Gracias a esto, el modelo logra generalizar mejor, pues puede identificar similitudes entre palabras con significados relacionados, incluso cuando estas no aparecen juntas con frecuencia en el corpus de entrenamiento.

Esta representación vectorial es fundamental en la arquitectura _Transformer_ @attention-is-all, la cual introdujo el mecanismo de atención para relacionar tokens del contexto sin importar su distancia en la secuencia, además de permitir el procesamiento en paralelo. Sobre esta base se desarrollaron modelos como BERT @bert y GPT @gpt2, entre otros.

Los Transformers generan estas representaciones vectoriales en el codificador (_encoder_). Aquí, cada token de la entrada se transforma en un vector a partir de lo aprendido durante el entrenamiento. Este vector se refina mediante el mecanismo de autoatención (_self-attention_) @attention-is-all, que permite al modelo relacionar cada token con los demás tokens de la secuencia.

// TODO: Por último, hacer aquí la conexión con la tokenización