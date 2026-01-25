== La liga entre la lingüística y los métodos computacionales actuales

// Será buena idea hablar del transformer, que es un encoder-decoder?

Como se observó en @llms, un rasgo compartido por las arquitecturas de los LLMs es que operan sobre tokens como unidades de entrada y, en ciertos casos, de salida. Cabe destacar que los procesos de tokenización no están integrados en dichas arquitecturas, puesto que se presupone que los tokens han sido previamente generados antes de ser suministrados al modelo.

// Citar
Se ha evidenciado que el algoritmo utilizado para generar estos tokens tiene influencia en el rendimiento de un LLM sobre tareas de NLP. Sin embargo, existe un debate sobre si parte de esta influencia es debido a información lingüística codificada en estos tokens. Algunas investigaciones sugieren que algoritmos como BPE no codifican información lingüística. 

// Aquí empezar a citar más cosas
Sin embargo, hay trabajos como... que sugieren que esto si es real

// El experimento de BPE, citas el artículo de 2023 de Ximena
Esto anterior fue observado por #cite(<ximena-bpe-2023>, form: "prose"). Ellos definieron definieron medidas en base a  un modelo entrenado de BPE, con el objetivo de ver si de alguna manera, las subpalabras codifican información lingüística relevantes para los modelos de lenguaje. Estas medidas son la _productividad_ de una subpalabra, la _idiosincrasia_ y la _frecuencia acumulada_. Tales medidas son calculadas a partir de las subpalabras que generó un modelo BPE, así como del corpus usado para obtener este modelo.

// Quizá cambiar las fórmulas   
La productividad, que está basada en la productividad lingüística. En sí la productividad lingüística se refiere a cuán activamente se usa una regla gramatical para crear nuevas palabras o estructuras. Por ejemplo:

- El sufijo "-ble" en español es muy productivo: puedes crear palabras como "comible", "bebible", "hackeable", "googlear" → "googleable"
- El sufijo "-idad" también es productivo: "amable" → "amabilidad", "nacional" → "nacionalidad"

Definimos la productividad de una subpalabra $s$ es el número de palabras ortográficas que contienen a dicha subpalabra $s$ en el corpus $W$ : // TODO Checar aquí la cita que tienen en el paper, página 18, cita 22
$ "productividad"(s) = |W_s| $

La frecuencia acumulativa de una subpalabra $s$ es la suma de las frecuencias de las palabras ortográficas que contienen a la subpalabra.
$ "c.freq(s)"(s) = sum_(w in W_s) "freq"(w) $

Mientras que la idiosincrasia, que está basada en la idiosincrasia lingüística. Esta se refiere a e refiere a las características particulares, irregulares o impredecibles de una lengua que no siguen patrones sistemáticos y deben aprenderse de manera individual. Por ejemplo:

- Plurales irregulares: "pie" → "pies" (regular), pero "menú" → "menús/menúes" (variación idiosincrásica)
- Verbos irregulares: "ir" (voy, fui, iré) no sigue el patrón regular

La medida de idiosincrasia se define así:
$ "idiosincrasia"(s) = "c.freq"(s)/"productividad"(s) $

Estas medidas ayudaron a crear una representación vectorial para cada idioma.