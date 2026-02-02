== La liga entre la lingüística y los métodos computacionales actuales

// En general, queremos hacer una relación entre los tokenizadores y la lingüística. Queremos ver qué algo de la relación entre la comprensión, lingüística. 


// Será buena idea hablar del transformer, que es un encoder-decoder?
Como se observó en @llms, un rasgo compartido por las arquitecturas de los LLMs es que operan sobre una colección de tokens. Cabe destacar que los procesos de tokenización no están integrados en dichas arquitecturas, puesto que se presupone que los tokens han sido previamente generados antes de ser suministrados al modelo.

// Citar
Se ha evidenciado que el algoritmo utilizado para generar estos tokens tiene influencia en el rendimiento de un LLM sobre tareas de NLP. Sin embargo, existe un debate sobre si parte de esta influencia es debido a información lingüística codificada en estos tokens. Algunas investigaciones sugieren que algoritmos como BPE no codifican información lingüística. 

// Aquí empezar a citar más cosas, la idea que queremos dar es un contraste de las diferentes posiciones de los tokenizadores.
Sin embargo, hay trabajos como que sugieren que esto si es real.

A pesar de que algoritmos como BPE se consideran voraces y no tienen una noción lingüística definida en su algoritmo, pueden capturar subpalabras que son cercanos a morfemas.

// TODO: Mejorar como introducir este párrafo porque no me acuerdo el porqué lo puse así en primer lugar
Esto anterior fue observado por #cite(<ximena-bpe-2023>, form: "prose"). Ellos definieron medidas para caracterizar a las lenguas de acuerdo a las propiedades de sus subpalabras generadas por BPE.  Estas medidas se definen en base a un modelo entrenado de BPE, con el objetivo de ver si de alguna manera, las subpalabras codifican información lingüística relevantes para los modelos de lenguaje. Estas medidas, influenciadas por la tipología morfológica, son la _productividad_ de una subpalabra, la _idiosincrasia_ y la _frecuencia acumulada_. Tales medidas son calculadas a partir de las subpalabras que generó un modelo BPE, así como del corpus usado para obtener este modelo.

// Quizá cambiar las fórmulas   
La medida de productividad está basada en la productividad lingüística. La productividad lingüística se refiere a cuán activamente se usa una regla gramatical para crear nuevas palabras o estructuras. Por ejemplo:

- El sufijo "-ble" en español es muy productivo: puede crear palabras como "comible", "bebible", "hackeable", "googleable".
- El sufijo "-idad" también es productivo: "amabilidad", "nacionalidad".

Se define la productividad de una subpalabra $s$ como el número de palabras ortográficas que contienen a dicha subpalabra $s$ en el corpus $W$: // TODO Checar aquí la cita que tienen en el paper, página 18, cita 22
$ "productividad"(s) = |W_s| $

La frecuencia acumulada de una subpalabra $s$ es la suma de las frecuencias de las palabras ortográficas que contienen a la subpalabra.
$ "c.freq(s)" = sum_(w in W_s) "freq"(w) $

Mientras que la idiosincrasia está basada en la idiosincrasia lingüística. Esta última se refiere a las características particulares, irregulares o impredecibles de una lengua que no siguen patrones sistemáticos y deben aprenderse de manera individual. Por ejemplo:

- Plurales irregulares: "pie" → "pies" (regular), pero "menú" → "menús/menúes".
- Verbos irregulares: "ir" (voy, fui, iré) no sigue el patrón regular de los verbos.

La medida de idiosincrasia para una subpalabra $s$ se define de la siguiente manera:
$ "idiosincrasia"(s) = "c.freq"(s)/"productividad"(s) $

#cite(<ximena-bpe-2023>, form: "prose") usaron estas medidas para caracterizar a 47 lenguas, con el cual crearon una representación vectorial para cada idioma. Podemos observar esto en @og-bpe-space.

#figure(
  image("img/bpe-space.png", width: 80%),
  caption: [Espacio de BPE definido por #cite(<ximena-bpe-2023>, form: "prose").],
) <og-bpe-space>
