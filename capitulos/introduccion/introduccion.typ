= Introducción
== Planteamiento del problema
Los modelos de procesamiento del lenguaje natural funcionan sin necesidad de saber lingüística. Sus arquitecturas no contienen reglas gramaticales explícitas, no consultan paradigmas verbales ni categorías morfológicas; aprenden a producir, traducir y entender texto a partir de procesos estadísticos que, en principio, son ciegos a información gramatical de la lengua. Y sin embargo, su desempeño sugiere que algo del orden lingüístico queda registrado en su interior @hewitt-manning-2019-structural @tenney-etal-2019-bert @rogers-etal-2020-primer.

Si ese rastro lingüístico existe, hay un lugar donde no se le suele buscar: el tokenizador. Ese tokenizador es un algoritmo independiente de la red neuronal: antes de que esta procese una oración, la convierte en una secuencia de unidades llamadas subpalabras. En los modelos de lenguaje más usados del momento, ese algoritmo es la codificación de pares de bytes (_Byte Pair Encoding_, BPE), originalmente concebido como un método de compresión de datos @Gage1994ANA. BPE no consulta gramáticas, no parte de un lexicón ni recibe información alguna sobre la lengua que procesa: su única operación es contar pares de símbolos contiguos en un corpus y fusionar los más frecuentes hasta agotar un presupuesto fijo. Por construcción, vive sobre la forma superficial del texto.

Y sin embargo, esa misma elección de subpalabras moldea lo que el modelo puede aprender: distintos tokenizadores producen modelos con desempeños distintos, y ese desempeño cambia según la lengua que se procesa @domingo2019doestokenizationaffectneural @parra2024morphologicaltypologybpesubword. Si BPE fuera realmente ciego a la estructura lingüística, esas asimetrías serían difíciles de explicar.

#cite(<ximena-bpe-2023>, form: "prose") exploraron esa intuición. En su trabajo definieron tres medidas estadísticas sobre las subpalabras que BPE produce, estas medidas están inspiradas en la morfología (el estudio lingüístico de la estructura interna de las palabras), de tal manera que para cada subpalabra calculan su productividad, frecuencia acumulada e idiosincrasia. Una vez teniendo esta caracterización, la utilizan para construir una representación vectorial de toda la lengua, y aplican este procedimiento a 47 lenguas diversas en el mundo. Cuando agruparon las lenguas en ese espacio y lo contrastaron con los grupos de lenguas que se formarían usando una representación basada en WALS, una base de datos tipológica lingüístca clásica, encontraron que las lenguas que BPE percibe como similares también lo son desde el punto de vista lingüístico (morfológico). El espacio inducido por un algoritmo de compresión parecía recoger algo del paisaje tipológico de las lenguas que comprimía: un primer indicio concreto de la huella que esta tesis se propone caracterizar.

Ese trabajo previo, aunque propone una metodología exhaustiva de evaluación cualitativa para comparar las caracterizaciones obtenidas mediante BPE con aquellas derivadas de información lingüística explícita, deja abiertas preguntas acerca de la robustez de la metodología en términos computacionales. 

La comparación se realizó contra una sola base de datos, bajo una sola configuración de agrupamiento y con una sola semilla aleatoria. Si la coincidencia depende de esas decisiones puntuales, el efecto es más una curiosidad metodológica que un hallazgo sobre BPE. Si, por el contrario, sobrevive al cambio de base, al barrido de hiperparámetros y a la comparación contra una línea base aleatoria, el argumento de que BPE codifica información lingüística gana evidencia cuantitativa.

Esta tesis parte precisamente de estas interrogantes: ¿qué ocurre cuando la comparación incorpora otros criterios y fuentes de información lingüística? ¿Se mantienen los resultados al utilizar distintas bases de datos lingüísticas? ¿Es posible emplear métodos más robustos para comparar agrupamientos y realizar análisis de agrupamiento?

//La pregunta concreta que esta tesis se propone responder es, entonces: ¿el agrupamiento que induce el espacio de BPE coincide con el que induce cada base lingüística por encima de lo que cabría esperar al azar, y se mantiene esa coincidencia al variar la base, la dimensionalidad y la semilla?  <<-- Esto queda bien para hipótesis más abajo


== Objetivos

General:

- Investigar hasta qué punto los modelos actuales de procesamiento del lenguaje natural codifican conocimiento lingüístico, aunque sus procesos basados en redes neuronales no lo representen de forma explícita. Particularmente, este trabajo se centrará en la segmentación de cadenas de texto a nivel subpalabra (subword tokenization), un componente de preprocesamiento esencial para cualquier modelo de inteligencia artificial actual.

Específicos:


- Analizar en profundidad los algoritmos de segmentación a nivel de subpalabra, basados en métodos no supervisados, para evaluar si los patrones que estos explotan son relevantes desde un punto de vista lingüístico. La tesis hará énfasis en el estudio del algoritmo de segmentación Codificación de Pares de Bytes (Byte Pair Encoding, BPE).


- Ampliar la metodología de estudios previos, incorporando una comparación más exhaustiva que utilice bases de datos de tipología lingüística recientes, por ejemplo, Grambank.


- Mejorar las técnicas de análisis de datos, particularmente en los procesos de vectorización y agrupamiento (clustering), con el fin de optimizar la comparación entre el conocimiento inducido por los métodos de segmentación a nivel de subpalabra y las descripciones de la lingüística tradicional.



== Preguntas de investigación

+ Dado que trabajos previos han encontrado similitudes entre las caracterizaciones de las lenguas obtenidas mediante BPE y aquellas basadas en información lingüística explícita (base de datos WALS), ¿qué tan robustas son estas observaciones al considerar múltiples configuraciones de agrupamiento e incorporar métricas adicionales para evaluar la similitud entre agrupamientos de lenguas?

+ ¿Qué ocurre al incorporar información lingüística adicional mediante una nueva base de datos (Grambank) que cubre un gran número de lenguas y características tipológicas de la morfología y la sintaxis? Con esta información ampliada, ¿se mantiene la consistencia entre las representaciones de las lenguas obtenidas a partir de las características de las subpalabras de BPE y aquellas derivadas de la información lingüística enriquecida?

+ ¿Qué características lingüísticas, presentes en las bases de datos, contribuyen en mayor medida a reproducir los agrupamientos de lenguas obtenidos mediante BPE? Asimismo, ¿qué revelan estas características acerca del tipo de información lingüística que capturan las representaciones basadas en subpalabras, ya sea morfológica, sintáctica o de otra naturaleza?


Para responder estas preguntas, se extiende el experimento de  #cite(<ximena-bpe-2023>, form: "prose"). Primero, se reproduce el estudio original pero con modificaciones para evaluar si la similitud observada se mantiene bajo distintas combinaciones de inicializaciones del proceso de agrupamiento particional (semillas aleatorias). Además, como criterio para comparar agrupamientos entre diferentes espacios o caracterizaciones, se incorpora una métrica que ajusta/descuenta el acierto por pura casualidad, proporcionando así una evaluación más robusta de la similitud entre las representaciones.

Posteriormente, con el fin de distinguir si la coincidencia depende específicamente de WALS o se fortalece frente a otra base tipológica, se incorpora Grambank, con una cobertura de características gramaticales distinta;  para situar esa coincidencia se barre sobre el número de características disponibles en Grambank y sobre miles de pares de semillas aleatorias.  En todos los casos, para distinguir la señal de BPE del ruido, se construye una línea base de referencia mediante agrupamientos aleatorios y se contrasta contra ella.

Asimismo, todo esta metodología se ve complementada con una mirada cualitativa que evalúa qué tipo de características lingüísticas parecen estar jugando un rol en la similitud/disimilitud entre la información que codifica BPE y la codificada por las bases de datos hechas por especialistas.

Nuestra *hipótesis* es que, si el agrupamiento inducido por el espacio de BPE coincide con el inducido por cada base de datos lingüística por encima de lo que cabría esperar por azar, y dicha coincidencia se mantiene al variar tanto la base de datos como la inicialización del agrupamiento, entonces existe evidencia de que la información codificada por un algoritmo de tokenización como BPE captura patrones que coinciden, al menos parcialmente, con las estructuras morfológicas descritas por los lingüistas.



//Para responderla, se extiende el experimento de #cite(<ximena-bpe-2023>, form: "prose") en tres frentes. Primero, para distinguir si la coincidencia depende específicamente de WALS o aparece también frente a otra base tipológica, se incorpora Grambank, con una cobertura gramatical distinta; y para situar esa coincidencia en una escala interpretable, se mide cuánto concuerdan entre sí las propias bases lingüísticas, incluida lang2vec, que sintetiza varias fuentes tipológicas en un único espacio vectorial. Segundo, para caracterizar la distribución de similitudes en lugar de un solo valor puntual, se barre sobre el número de características usadas y sobre miles de pares de semillas aleatorias. Tercero, para distinguir la señal de BPE del ruido, se construye una línea base de referencia mediante agrupamientos aleatorios y se contrasta contra ella.

#pagebreak()
