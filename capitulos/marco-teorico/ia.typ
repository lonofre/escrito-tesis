#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

== IA y procesamiento de lenguaje natural

La inteligencia artificial (IA) tiene entre sus objetivos crear sistemas computacionales capaces de realizar tareas que requieren inteligencia humana. Entre estas tareas se encuentran el razonamiento, el aprendizaje, la percepción, la toma de decisiones y el procesamiento del lenguaje natural (PLN).

El procesamiento del lenguaje natural estudia cómo las computadoras procesan el lenguaje humano. Dentro de este marco, el PLN forma parte de las ciencias de la computación y mantiene una relación estrecha con la IA.

Está relación entre el PLN y la IA ha dado lugar a soluciones para problemas de reconocimiento de voz, la traducción automática y la generación de texto. En la vida cotidiana, estas aplicaciones aparecen en herramientas como el autocorrector, los filtros de spam y los asistentes de voz. Más recientemente, el avance del PLN ha permitido el desarrollo de sistemas más complejos, como la IA generativa, que es capaz de generar texto, imágenes y videos a partir de mensajes expresados mediante el lenguaje natural.

=== Modelos de lenguaje

// Quizá citar algo aquí? para darle más fuerza.
Así, uno de los objetivos del PLN es modelar el lenguaje humano. La manera en cómo se ha modelado ha ido cambiando a lo largo del tiempo, a su vez que cada enfoque tiene influencia en los resultados que puede dar una tarea o sistema de PLN.

// Citar a Chomsky??? Al menos para dar una idea de las gramáticas libres de contexto
En los primeros sistemas de PLN, el modelado del lenguaje natural se abordó mediante el uso de reglas gramaticales explícitas. Estas reglas se pueden denotar con gramáticas libres de contexto. Se puede observar esta aplicación en una de las primeras demostraciones de traducción automática, que fue el experimento Georgetown-IBM @hutchins-2004-georgetown, el cual hizo uso de 6 reglas gramáticales.

Estos enfoques basados en reglas presentaron una fuerte influencia lingüística. Podemos ver esto en la arquitectura de sistemas como EUROTRA#footnote[EUROTRA fue un proyecto de traducción automática establecido y financiado por la Comisión Europea desde 1978 hasta 1992.]. Su arquitectura se basaba en un modelo de transferencia @johnson-etal-1985-eurotra @varile-lau-1988-eurotra, que realizaba un análisis sintáctico y semántico de la lengua de origen para posteriormente transferir dicha representación a la lengua de destino y generar la traducción final. Por lo cual, requería un fuerte trabajo lingüístico para generar las reglas y conseguir un buen modelo de lenguaje.

// Quizá podemos introducir esto? https://aclanthology.org/J96-1002.pdf
// También podemos introducir el enfoque de probabilida
No obstante, los modelos de lenguaje estadísticos (_Statistical Language Model_, SLM) remplazaron los modelos basados en reglas, pues los SLM demostraron tener mejores resultados en tareas de NLP @brown-etal-1990-statistical. Para tareas de traducción automática, los SLM no tienen la limitante de el reducido número de reglas de cada idioma, sino se contruyen en cuál es la traducción más probable, esto gracias a partir del entrenamiento sobre grandes corpus bilingües.

Esto representó un cambio de paradigma en el desarrollo de los sistemas de PLN. El objetivo de los modelos de lenguaje dejó de centrarse en el análisis explícito de características lingüísticas del texto y pasó a formularse como un problema probabilístico y de aprendizaje automático: dado un contexto, estimar el resultado más probable a partir de lo observado en los corpus de entrenamiento. Por lo tanto, un modelo de lenguaje empezó a definir una distribución conjunta sobre una secuencia palabras $w_(1:T) = (w_1, w_2, dots, w_t)$, donde cada $w_t$ pertenece a un vocabulario $V$:

$ P(w_(1:T)) = product_(t=1)^(T) P(w_t | w_(1:t-1))) $

/*
Esto puede observarse en tareas de como el autocompletado o generación de texto. En @autocompletado podemos observar de acuerdo a un contexto, podemos predecir la siguiente palabra de acuerdo a cuál es lo más probable.

#figure( 
  diagram(
    node((-0.5, 0.5), [El cielo es ?], radius: 3em),
    node((1.5, 0), [$P("azul" | "El cielo es")$], radius: 2em),
    node((1.5, 0.5), [$P("rojo" | "El cielo es")$], radius: 2em),
    node((1.5, 1), [...], radius: 2em),

    edge((-0.5, 0.5), (0.6, 0), bend: 10deg),
    edge((-0.5, 0.5), (0.6, 0.5)),
    edge((-0.5, 0.5), (0.6, 1), bend: -10deg),
  ),
  caption: [Posibles probabilidades para completar la frase _el cielo es._]
) <autocompletado>

*/

// Quizá podemos expandir un poco más a los n-gramas
// Definiciones cortas al menos, para contextualizar un poco y dar enfásis al siguiente punto
Ahora, el desafío se convirtió en obtener esa distribución de probabilidad para un modelo de lenguaje. Es por esto en los SML predominó el uso de n-gramas, que son subsecuencias de $N$ elementos o palabras. Los n-gramas usan la suposición de Markov @Markov_2006, donde la suposición que cada probabilidad condicional sólo depende de los previos $N$ términos. Esto fue llevado para crear un modelo de n-gramas:

$ P(w_(1:T)) = product_(t=1)^(T) P(w_t | w_(1:t-1))) approx product_(t=1)^(T) P(w_t | w_(t-N+1:t-1)) $

Debido a su carácter estadístico, las nociones lingüísticas de estos SML resultan difusas, ya que las palabras se relacionan principalmente por su coaparición en contextos similares.

#figure(
  block[
    // Workaround: https://forum.typst.app/t/how-can-i-highlight-math-including-numbers/5031/8
    #show highlight: it => [
      #box(
        fill: it.fill,
        stroke: it.stroke,
        radius: it.radius,
        outset: 2pt,
        inset: 0.2em,
      )[#it.body]
    ]
    $ dots $
    $ P("oscuro" | "el cielo es") = 0.3 $
    #highlight(fill: rgb("#b7ffab"))[$ P("azul" | "el cielo es") = 0.15 $]
    $ P("rojo" | "el cielo es") = 0.05 $
    $ dots $
  ],
  caption: [Un SLM va a elegir la opción con mayor probabilidad.]
)

// Agregar lo que criticaba Chomsky también aquí
// Quizá agregar a Bengio sobre la maldidición dela dimensionalidad ¿?
No obstante, los SML no suelen ser la mejor opción, pues suelen sufrir la maldición de la dimensionalidad @zhao2025surveylargelanguagemodels. En este escenario, estimar con precisión modelos de lenguaje de alto orden resulta difícil, porque estos modelos utilizan contextos largos y, en consecuencia, requieren calcular un número exponencial de probabilidades de transición, lo cual aumenta su costo computacional.

// Algo que quiero agregar aquí es mostrar una relación entre datos obtenidos como Zipf, etc, que han ayudado a describir linguisticamente a las cosas.
Para mitigar esta problemática, la investigación comenzó a orientarse hacia los modelos de lenguaje neuronales (_Neural Language Models_, NLM). El trabajo de #cite(<bengio2003>, form: "prose") propuso reemplazar el conteo discreto por representaciones distribuidas, donde las palabras se representan como vectores en un espacio continuo. Esto permite que el modelo pueda generalizar mejor, ya que es capaz de identificar similitudes entre palabras con significados relacionados, incluso cuando no aparecen juntas con frecuencia en el corpus de entrenamiento.

// Quizá agregar nociones de semántica aquí?
Más adelante, este enfoque se consolidó con el modelo Word2Vec @mikolov2013efficientestimationwordrepresentations. A diferencia de los modelos neuronales anteriores, Word2Vec utilizó una arquitectura más simple, eliminando capas ocultas no lineales, lo que permitió entrenar el modelo de forma más rápida y con grandes cantidades de datos. Gracias a esto, los modelos de lenguaje pudieron representar las palabras mediante vectores densos y capturar relaciones entre ellas, reduciendo además el costo computacional en comparación con los métodos estadísticos tradicionales.

// Concluir al menos algo aquí

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
