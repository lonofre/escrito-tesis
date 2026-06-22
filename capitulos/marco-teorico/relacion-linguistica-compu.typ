/*
  En general, queremos hacer una relación entre los LLMs y la lingüística. Esto lo vamos a lograr mediante la caracterización de las lenguas mediante BPE (u otro tokenizador).
*/
== La huella lingüística de la tokenización

Esa pregunta no es nueva. Durante años, la tokenización fue tratada como un paso de ingeniería sin contenido lingüístico propio: una aproximación manejada de forma independiente del aprendizaje del modelo, cuyo único fin era preparar el texto para que este lo consuma como una simple secuencia de enteros @mielke2021wordscharactersbriefhistory.

Esa posición tenía fundamentos. BPE no recibe información lingüística como gramáticas lexicón o reglas morfológicas. Su único criterio es la frecuencia con que dos símbolos aparecen juntos, una propiedad de la forma superficial del texto y no de su estructura subyacente. Por construcción, entonces, BPE es ciego a la lengua que procesa. Sin embargo, esa ceguera ha empezado a cuestionarse.

// TODO: La siguiente revisión de literatura es preliminar; conviene ampliarla con más trabajos que muestren la dependencia de BPE (o de la tokenización en general) con la lengua. Mantener el patrón "una oración por trabajo + síntesis al final".
Distintos estudios apuntan en la misma dirección. #cite(<domingo2019doestokenizationaffectneural>, form: "prose") mostraron que el tokenizador cambia el rendimiento de la traducción automática, y que ese cambio depende de las lenguas involucradas. #cite(<parra2024morphologicaltypologybpesubword>, form: "prose") encontró que la segmentación que produce BPE varía según la morfología de la lengua. #cite(<bayram2025tokenizationstandardslinguisticintegrity>, form: "prose") observaron que los tokenizadores cuyas subpalabras se parecen a las unidades lingüísticas de una lengua producen mejores modelos. La observación común es que la lengua sí importa para BPE, si el algoritmo fuera ciego a su estructura, estos efectos no se repetirían entre lenguas distintas.

Si la lengua importa para BPE, la siguiente pregunta es cuál parte de la lengua importa más. Entre los rasgos que distinguen a unas lenguas de otras, hay uno que trabaja sobre el mismo material que BPE: la morfología, que estudia la estructura interna de las palabras @haspelmath2010understanding.

/*
  TODO: Aquí falta información sobre tipología morfológica.
*/


=== Caracterización de las lenguas mediante BPE

Esa medición la propusieron #cite(<ximena-bpe-2023>, form: "prose"). Sobre un modelo BPE entrenado en un corpus, definieron tres medidas para cada subpalabra: la productividad, la frecuencia acumulada y la idiosincrasia. Las tres se inspiran en nociones de la tipología morfológica y buscan responder si las subpalabras codifican información lingüística relevante.

// TODO: Quizá cambiar las fórmulas.
La primera medida, la *productividad*, está basada en la productividad lingüística: cuán activamente se usa una regla gramatical para crear nuevas palabras o estructuras. Por ejemplo:

- El sufijo "-ble" en español es muy productivo: puede crear palabras como "comible", "bebible", "hackeable", "googleable".
- El sufijo "-idad" también es productivo: "amabilidad", "nacionalidad".

// TODO: Checar la cita que tienen en el paper, página 18, cita 22.
Se define entonces la productividad de una subpalabra $s$ como el número de palabras ortográficas (las palabras tal como aparecen separadas por espacios en el corpus) que contienen a $s$ en el corpus $W$:

$ "productividad"(s) = |W_s| $

La segunda medida, la *frecuencia acumulada*, no parte de una noción lingüística previa sino de una intuición de medición: no todas las palabras pesan lo mismo. Una subpalabra que aparece en pocas palabras pero muy frecuentes contribuye más al uso real de la lengua que una que aparece en muchas palabras raras. Se define la frecuencia acumulada de una subpalabra $s$ como la suma de las frecuencias de las palabras ortográficas que la contienen:

$ "c.freq(s)" = sum_(w in W_s) "freq"(w) $

La tercera medida, la *idiosincrasia*, está basada en la idiosincrasia lingüística: las características particulares, irregulares o impredecibles de una lengua que no siguen patrones sistemáticos y deben aprenderse de manera individual. Por ejemplo:

- Plurales irregulares: "pie" → "pies" (regular), pero "menú" → "menús/menúes".
- Verbos irregulares: "ir" (voy, fui, iré) no sigue el patrón regular de los verbos.

La medida de idiosincrasia para una subpalabra $s$ se define como un cociente entre las dos medidas anteriores: la frecuencia acumulada dividida entre la productividad.

$ "idiosincrasia"(s) = "c.freq"(s)/"productividad"(s) $

Un valor alto indica que la subpalabra se concentra en pocas palabras muy frecuentes (comportamiento típico de las formas idiosincráticas); un valor bajo indica que se distribuye entre muchas palabras (comportamiento típico de las formas productivas).

Con estas tres medidas, #cite(<ximena-bpe-2023>, form: "prose") caracterizaron a 47 lenguas y construyeron una representación vectorial para cada una (@og-bpe-space).

#figure(
  image("img/bpe-space.png", width: 80%),
  caption: [Espacio de BPE definido por #cite(<ximena-bpe-2023>, form: "prose").],
) <og-bpe-space>

// TODO: revisar este PERO — es el aporte de la tesis y conviene afinar el alcance exacto.
Que ese espacio agrupe a lenguas tipológicamente afines sugiere que las subpalabras de BPE podrían estar capturando algo más que frecuencia. Pero la metodología de ese experimento original es acotada: la comparación se realizó únicamente contra una base de datos lingüística, WALS, y bajo una sola configuración de agrupamiento. Extender ese contraste a otras bases tipológicas, y a distintas configuraciones de agrupamiento, es precisamente el aporte de esta tesis. Para hacerlo, sin embargo, hacen falta dos piezas que las secciones siguientes introducen: las bases lingüísticas contra las cuales contrastar el espacio de BPE, y el instrumento formal para comparar los agrupamientos que cada espacio induce.
