#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

== IA y procesamiento de lenguaje natural

Uno de los objetivos de la la inteligencia artificial (IA) es crear sistemas computacionales capaces de realizar tareas que requieren inteligencia humana. Entre estas tareas se incluyen el razonamiento, el aprendizaje, la percepción, la toma de decisiones y el procesamiento del lenguaje natural (PLN).

El procesamiento del lenguaje natural estudia cómo las computadoras procesan el lenguaje humano. Dentro de este marco, el PLN forma parte de las ciencias de la computación y mantiene una relación estrecha con la inteligencia artificial. A partir de esta base, el PLN da lugar a aplicaciones como el reconocimiento de voz, la traducción automática y la generación de texto. En la vida cotidiana, estas aplicaciones aparecen en herramientas como el autocorrector, los filtros de spam y los asistentes de voz. Más recientemente, el avance del PLN ha permitido el desarrollo de sistemas más complejos, como la IA generativa, que es capaz de generar texto, imágenes y videos a partir de mensajes expresados en lenguaje natural.

=== Modelos de lenguaje

En este sentido, uno de los objetivos del PLN es modelar el lenguaje humano. En las primeras etapas del PLN, este objetivo se abordó mediante el uso de reglas gramaticales explícitas. De hecho, este enfoque se utilizó en una de las primeras demostraciones de traducción automática, en la que una máquina operacional tradujo texto del ruso al inglés @hutchins-2004-georgetown.

Estos enfoques basados en reglas tenían una fuerte influencia lingüística. Se observa esto en sistemas como EUROTRA, que fue hecho para la traducción automática. La arquitectura de este sistema estaba basada en transferencia @johnson-etal-1985-eurotra @varile-lau-1988-eurotra, donde se hacía un análisis sintáctico y semántico de la lengua original, para después transferir esa representación a la de la lengua de destino y finalmente obtener una traducción.

// Quizá podemos introducir esto? https://aclanthology.org/J96-1002.pdf
// También podemos introducir el enfoque de probabilida
Sin embargo, modelos de lenguaje estadísticos (_Statistical Language Model_, SLM)  demostraron tener mejores resultados en tareas de NLP @brown-etal-1990-statistical. Por ejemplo, para la traducción automática, estos models no tenían la limitante de el reducido número de reglas de cada idioma, sino se construían en cuál es la traducción más probable a partir de grandes corpus bilingües.

Esto fue un giro en el enfoque se se le dió a los sistemas de PLN. El objetivo de los modelos de lenguaje ya no era hacer un análisis de características lingüísticas sobre el texto trabajado. Ahora, el objetivo cambió de dado un contexto, calcular cuál es el resultado más probable en base a lo observado en los corpus de entrenamiento. Esto se puede modelar de la siguiente manera:

$ P("Opción" | "Contexto") $

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

// Quizá podemos expandir un poco más a los n-gramas
// Definiciones cortas al menos, para contextualizar un poco y dar enfásis al siguiente punto
El desafío se convirtió en calcular esas probabilidades dado el contexto. Es por esto en los SML predominó el uso de n-gramas, que son subsecuencias de $N$ elementos. Los n-gramas usan la suposición de Markov. #cite(<Markov_2006>, form: "prose") hizo la suposición que cada probabilidad condicional sólo depende de los previos $N$ términos. Esto fue llevado para crear un modelo de n-gramas:

$ P(w_(1:T)) = product_(t=1)^(T) P(w_t | w_(1:t-1))) approx product_(t=1)^(T) P(w_t | w_(t-N+1:t-1)) $

// Agregar lo que criticaba Chomsky también aquí
// Quizá agregar a Bengio sobre la maldidición dela dimensionalidad ¿?
No obstante, estos modelos suelen sufrir la maldición de la dimensionalidad @zhao2025surveylargelanguagemodels. En este escenario, estimar con precisión modelos de lenguaje de alto orden resulta difícil, porque estos modelos utilizan contextos largos y, en consecuencia, requieren calcular un número exponencial de probabilidades de transición.

Para mitigar esta problemática, la investigación comenzó a orientarse hacia los modelos de lenguaje neuronales (_Neural Language Models_, NLM). El trabajo de #cite(<bengio2003>, form: "prose") propuso reemplazar el conteo discreto por representaciones distribuidas, donde las palabras se representan como vectores en un espacio continuo. Esto permite que el modelo pueda generalizar mejor, ya que es capaz de identificar similitudes entre palabras con significados relacionados, incluso cuando no aparecen juntas con frecuencia en el corpus de entrenamiento.

Más adelante, este enfoque se consolidó con el modelo Word2Vec @mikolov2013efficientestimationwordrepresentations. A diferencia de los modelos neuronales anteriores, Word2Vec utilizó una arquitectura más simple, eliminando capas ocultas no lineales, lo que permitió entrenar el modelo de forma más rápida y con grandes cantidades de datos. Gracias a esto, los modelos de lenguaje pudieron representar las palabras mediante vectores densos y capturar relaciones entre ellas, reduciendo además el costo computacional en comparación con los métodos estadísticos tradicionales.

=== Grandes modelos de lenguaje <llms>

// Citar al libro de NPL?
// Citar lo de volúmenes de texto??
// Citar lo de contexto también
Los Grandes Modelos de Lenguaje (Large Language Models, LLMs), basados en la arquitectura Transformer @attention-is-all, han mostrado un desempeño significativamente superior en múltiples tareas de procesamiento del lenguaje natural en comparación con los SLM tradicionales. Al igual que estos últimos, los LLMs modelan la distribución de probabilidad de una secuencia y estiman la probabilidad del siguiente token dado un contexto previo. Sin embargo, se diferencian en la forma en que representan dicho contexto, en su capacidad de generalización y en la escala de los datos y parámetros utilizados durante el entrenamiento.

Mientras que los modelos estadísticos clásicos suelen operar con ventanas de contexto cortas y representaciones discretas basadas en conteos, los LLMs emplean representaciones distribuidas en espacios vectoriales continuos y mecanismos de atención que les permiten modelar dependencias de largo alcance dentro de una secuencia. Esto posibilita capturar regularidades sintácticas y semánticas más complejas, así como una mayor capacidad de generalización ante combinaciones no observadas explícitamente durante el entrenamiento.

// Citar al libro de NPL. Posiblemente expandir un poco y entender bien cómo funciona esta parte. Por lo mientras, voy poniendo la idea general.
Muchos LLMs adoptan un esquema autoregresivo, en el cual el modelo genera iterativamente un token a la vez a partir del contexto previamente generado, lo que constituye la base de los sistemas de generación automática de texto. Las arquitecturas más comunes incluyen modelos de tipo codificador, decodificador y codificador–decodificador. En particular, las arquitecturas de decodificador, como las empleadas en modelos de la familia GPT, LLaMA o Gemini, reciben una secuencia de tokens y producen secuencialmente nuevos tokens, mientras que las arquitecturas de codificador generan representaciones vectoriales contextualizadas de cada token, utilizadas principalmente en tareas de análisis, clasificación o etiquetado lingüístico.

// Expandir esto también
Como se logró observar, los tokens son la unidad sobre el cual estas arquitecturas trabajan. 
