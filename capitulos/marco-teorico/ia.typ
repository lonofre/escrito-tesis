#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

/*
  Al menos el primer enfoque que quiero darle a esta sección es relación IA-NLP, con un enfoque en los modelos de lenguaje (esta sería la relación y posiblemente uno de los personajes principales). Quiero hacer énfasis en los tokens y cómo son usados en estos modelos de lenguajes.
*/
== La inteligencia artificial y el procesamiento de lenguaje natural

Los modelos de lenguaje han sido uno de los puntos de interacción entre la inteligencia artificial (IA) y el procesamiento del lenguaje natural (PLN). Esta intersección impulsó décadas de investigación y la confluencia de varias disciplinas. En el centro de todo ello, las palabras han sido el elemento fundamental sobre el que se construyó toda representación y generación del lenguaje. Para comprender el alcance de esta evolución, es necesario partir desde la propia naturaleza de los modelos de lenguaje.

Por tanto, los modelos de lenguaje son el resultado del PLN para representar y comprender el lenguaje humano. Así mismo, las formas de modelar el lenguaje natural han ido cambiando a lo largo del tiempo, teniendo influencia en los resultados de las tareas y sistemas de PLN.

En los primeros sistemas de PLN, el modelado del lenguaje natural se abordó mediante reglas gramaticales explícitas —denotables con gramáticas libres de contexto— con una fuerte influencia lingüística. Esto puede observarse desde una de las primeras demostraciones de traducción automática, el experimento Georgetown-IBM @hutchins-2004-georgetown, que empleó apenas 6 reglas gramaticales, hasta arquitecturas más elaboradas como EUROTRA#footnote[EUROTRA fue un proyecto de traducción automática establecido y financiado por la Comisión Europea desde 1978 hasta 1992.], cuyo modelo de transferencia @johnson-etal-1985-eurotra @varile-lau-1988-eurotra realizaba un análisis sintáctico y semántico de la lengua de origen para luego transferir dicha representación a la lengua destino. En ambos casos, estos enfoques requerían un intenso trabajo lingüístico para definir las reglas y construir un modelo de lenguaje funcional.

No obstante, los modelos de lenguaje estadísticos (_Statistical Language Model_, SLM) reemplazaron a los modelos basados en reglas al demostrar mejores resultados en tareas de NLP @brown-etal-1990-statistical. En lugar de partir de un conjunto predefinido de reglas lingüísticas, los SLM infieren los patrones más probables del lenguaje mediante el entrenamiento sobre grandes corpus de texto. Esto representó un cambio de paradigma en el desarrollo de los sistemas de PLN: el objetivo dejó de centrarse en el análisis explícito de características lingüísticas y pasó a formularse como un problema probabilístico. Así, dada una ventana de contexto, el modelo estima el resultado más probable a partir de lo observado durante el entrenamiento.

De esta manera, un modelo de lenguaje define una distribución conjunta sobre sobre una secuencia de palabras $w_(1:T) = (w_1, w_2, dots, w_t)$ @bengio2003

$ P(w_(1:T)) = product_(t=1)^(T) P(w_t | w_(1:t-1))) $

donde cada $w_i$ pertenece a un vocabulario $V$.

En consecuencia, el desafío se convirtió en obtener esa distribución de probabilidad para un modelo de lenguaje. Es por esto en los SML predominó el uso de n-gramas, que son subsecuencias de $N$ elementos o palabras. Los n-gramas usan la suposición de Markov @Markov_2006, donde la suposición que cada probabilidad condicional sólo depende de los previos $N$ términos. A partir de esta suposición se construye el modelo de n-gramas.

Sin embargo, estos modelos enfrentan un problema fundamental: la maldición de la dimensionalidad @zhao2025surveylargelanguagemodels. Estimar con precisión modelos de lenguaje de alto orden resulta difícil, porque utilizan contextos largos y, en consecuencia, requieren calcular un número exponencial de probabilidades de transición, lo cual aumenta su costo computacional.

// TODO: Desde aquí seguiría mejorar y empezar a introducir a los modelos de lenguaje neuronales y los LLMs. Tengo que explicar la relación con las palabras, la vectorización y otras relaciones para comprender de una manera en cómo funcionan. Tal vez no sería en detalle, pero si haciendo énfasis en palabras o tokens para introducir la siguiente sección de tokenización.

Para mitigar esta problemática, la investigación comenzó a orientarse hacia los modelos de lenguaje neuronales (_Neural Language Models_, NLM). El trabajo de #cite(<bengio2003>, form: "prose") propuso reemplazar el conteo discreto por representaciones distribuidas, donde las palabras se representan como vectores en un espacio continuo. Esto permite que el modelo pueda generalizar mejor, ya que es capaz de identificar similitudes entre palabras con significados relacionados, incluso cuando no aparecen juntas con frecuencia en el corpus de entrenamiento.

// Quizá agregar nociones de semántica aquí?
Más adelante, este enfoque se consolidó con el modelo Word2Vec @mikolov2013efficientestimationwordrepresentations. A diferencia de los modelos neuronales anteriores, Word2Vec utilizó una arquitectura más simple, eliminando capas ocultas no lineales, lo que permitió entrenar el modelo de forma más rápida y con grandes cantidades de datos. Gracias a esto, los modelos de lenguaje pudieron representar las palabras mediante vectores densos y capturar relaciones entre ellas, reduciendo además el costo computacional en comparación con los métodos estadísticos tradicionales.

// Concluir al menos algo aquí

// TODO: Siento que me falta indagar aquí. Este es un tema central en la tesis y debo relacionar los grandes modelos de lenguaje con: o los tokens o la tokenización en sí.
// Entonces, aquí requiero más investigación sobre esto
=== Grandes modelos de lenguaje <llms>

// Citar al libro de NPL?
// Citar lo de volúmenes de texto??
// Citar lo de contexto también
Los Grandes Modelos de Lenguaje (Large Language Models, LLMs), basados en la arquitectura Transformer @attention-is-all, han mostrado un desempeño significativamente superior en múltiples tareas de procesamiento del lenguaje natural en comparación con los SLM tradicionales. Al igual que estos últimos, los LLMs modelan la distribución de probabilidad de una secuencia y estiman la probabilidad del siguiente token dado un contexto previo. Sin embargo, se diferencian en la forma en que representan dicho contexto, en su capacidad de generalización y en la escala de los datos y parámetros utilizados durante el entrenamiento.

Mientras que los modelos estadísticos clásicos suelen operar con ventanas de contexto cortas y representaciones discretas basadas en conteos, los LLMs emplean representaciones distribuidas en espacios vectoriales continuos y mecanismos de atención que les permiten modelar dependencias de largo alcance dentro de una secuencia. Esto posibilita capturar regularidades sintácticas y semánticas más complejas, así como una mayor capacidad de generalización ante combinaciones no observadas explícitamente durante el entrenamiento.

// Citar al libro de NPL. Posiblemente expandir un poco y entender bien cómo funciona esta parte. Por lo mientras, voy poniendo la idea general.
Muchos LLMs adoptan un esquema autoregresivo, en el cual el modelo genera iterativamente un token a la vez a partir del contexto previamente generado, lo que constituye la base de los sistemas de generación automática de texto. Las arquitecturas más comunes incluyen modelos de tipo codificador, decodificador y codificador–decodificador. En particular, las arquitecturas de decodificador, como las empleadas en modelos de la familia GPT, LLaMA o Gemini, reciben una secuencia de tokens y producen secuencialmente nuevos tokens, mientras que las arquitecturas de codificador generan representaciones vectoriales contextualizadas de cada token, utilizadas principalmente en tareas de análisis, clasificación o etiquetado lingüístico.

// TODO: Hacer que haga sentido este párrafo. Quiero hablar y hacer énfasis en los tokens y por qué son importantes en el procesamiento de los LLMs
Para que esa arquitectura pueda operar, cada token debe traducirse a un formato que el modelo sea capaz de procesar. Esa traducción se realiza mediante los embeddings: representaciones numéricas que asignan a cada token un vector de números. Es sobre esos vectores, y no sobre el texto directamente, que la arquitectura realiza sus cálculos.

// Expandir esto también
// También citar quizá el modelo ¿?
Se puede observar que los tokens son las unidades que las arquitecturas de los LLMs utilizan para operar. Algunos modelos como chatGPT usan un vocabulario de un tamaño de hasta 100 mil tokens.
