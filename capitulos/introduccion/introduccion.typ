= Introducción

Los modelos de procesamiento del lenguaje natural funcionan sin necesidad de saber lingüística. Sus arquitecturas no contienen reglas gramaticales explícitas, no consultan paradigmas verbales ni categorías morfológicas; aprenden a producir, traducir y entender texto a partir de procesos estadísticos que, en principio, son ciegos a la estructura de la lengua. Y sin embargo, su desempeño sugiere que algo del orden lingüístico queda registrado en su interior. La hipótesis que esta tesis explora es que esos procesos no son tan ciegos como parecen, y que dejan en el modelo una huella lingüística que no fue puesta ahí a propósito.

El lugar donde esa huella es más sorprendente, y donde menos se la suele buscar, es el tokenizador. Antes de que cualquier red neuronal procese una oración, un algoritmo aparte la convierte en una secuencia de unidades llamadas subpalabras. En los modelos de lenguaje más usados del momento, ese algoritmo es BPE (_Byte Pair Encoding_), originalmente concebido como un método de compresión de datos @Gage1994ANA. BPE no consulta gramáticas, no parte de un lexicón ni recibe información alguna sobre la lengua que procesa: su única operación es contar pares de símbolos contiguos en un corpus y fusionar los más frecuentes hasta agotar un presupuesto fijo. Por construcción, vive sobre la forma superficial del texto.

Y sin embargo, esa misma elección de subpalabras moldea lo que el modelo puede aprender: distintos tokenizadores producen modelos con desempeños distintos, y ese desempeño cambia según la lengua que se procesa @domingo2019doestokenizationaffectneural @parra2024morphologicaltypologybpesubword. Si BPE fuera realmente ciego a la estructura lingüística, esas asimetrías serían difíciles de explicar.

#cite(<ximena-bpe-2023>, form: "prose") llevaron esa intuición un paso más allá. Definieron tres medidas estadísticas sobre las subpalabras que BPE produce —productividad, frecuencia acumulada e idiosincrasia— y las usaron para construir una representación vectorial de 47 lenguas. Cuando agruparon ese espacio y lo contrastaron contra WALS, una base de datos tipológica clásica, encontraron que las lenguas que BPE percibe como similares también lo son desde el punto de vista lingüístico. El espacio inducido por un algoritmo de compresión parecía recoger algo del paisaje tipológico de las lenguas que comprimía: un primer indicio concreto de la huella que esta tesis se propone caracterizar.

Ese resultado, sin embargo, deja abierta una pregunta de robustez. La comparación se realizó contra una sola base de datos, bajo una sola configuración de agrupamiento y con una sola semilla aleatoria. Si la coincidencia depende de esas decisiones puntuales, el efecto es más una curiosidad metodológica que un hallazgo sobre BPE. Si, por el contrario, sobrevive al cambio de base, al barrido de hiperparámetros y a la comparación contra una línea base aleatoria, el argumento de que BPE codifica información lingüística gana fuerza considerable.

Esta tesis se ocupa precisamente de esa prueba. El experimento de #cite(<ximena-bpe-2023>, form: "prose") se extiende en tres frentes. Primero, se incorpora una base lingüística adicional: Grambank, desarrollada por la Sociedad Max Planck con una cobertura gramatical distinta a la de WALS; como apoyo se utiliza lang2vec, que sintetiza varias fuentes tipológicas en un único espacio vectorial, no para contrastarla con BPE sino para medir cuánto concuerdan las bases lingüísticas entre sí y situar en esa escala las comparaciones con BPE. Segundo, en lugar de fijar una sola configuración de agrupamiento, se barre sobre el número de características usadas y sobre miles de pares de semillas aleatorias, lo que permite caracterizar la distribución de similitudes en vez de un solo valor puntual. Tercero, se construye una línea base de referencia mediante agrupamientos aleatorios, contra la cual se contrasta la señal de BPE para distinguirla del ruido.

== Objetivos

El objetivo general de esta tesis es investigar si la tokenización a nivel subpalabra —componente de preprocesamiento esencial de los modelos de lenguaje actuales— codifica información lingüística de las lenguas que procesa, a pesar de operar con métodos puramente estadísticos. El trabajo se centra en el algoritmo de Codificación de Pares de Bytes (_Byte Pair Encoding_, BPE).

De este objetivo general se desprenden tres objetivos específicos:

- Analizar el algoritmo BPE como método no supervisado de segmentación, para evaluar si los patrones que explota son relevantes desde un punto de vista lingüístico.

- Ampliar la comparación de estudios previos incorporando bases de datos de tipología lingüística recientes, como Grambank, y usando lang2vec para situar la concordancia entre las propias bases.

- Robustecer la metodología de comparación entre el espacio inducido por BPE y las descripciones tipológicas: caracterizar distribuciones de similitud mediante barridos sobre el número de características y las semillas de agrupamiento, y contrastar la señal observada contra una línea base aleatoria.

La pregunta concreta que se contesta es entonces: ¿el agrupamiento que induce el espacio de BPE coincide con el que induce cada base lingüística por encima de lo que cabría esperar al azar, y se mantiene esa coincidencia al variar la base, la dimensionalidad y la semilla? Anticipando el resultado para orientar la lectura: la respuesta es afirmativa contra ambas bases. Lo que ese hallazgo dice sobre la huella lingüística que los modelos actuales codifican sin habérsela enseñado nadie es lo que el resto de la tesis desarrolla.


#pagebreak()
