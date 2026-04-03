/*
  En general, queremos hacer una relación entre los LLMs y la lingüística. Esto lo vamos a lograr mediante la caracterización de las lenguas mediante BPE (u otro tokenizador).
*/
== La liga entre la lingüística y los métodos computacionales actuales

// TODO: Aquí citar a los que no están de acuerdo
// TODO: Podemos poner que no sólo juega en papel de comprimir información nomás
Históricamente, la tokenización ha sido considerada un proceso sin relevancia lingüística. Sin embargo, al ser la etapa encargada de segmentar el texto en unidades que el modelo procesa directamente, puede tener una influencia considerable en el desempeño de los LLMs.

// TODO: Recuerdo que hay más papers que hacen una conclusión sobre el impacto de la tokenización en las lenguas. Por lo que valdría la pena agregarlos aquí si aplican para apoyar esta información
En particular, el rendimiento del algoritmo BPE puede variar según las características lingüísticas de la lengua que se procesa @parra2024morphologicaltypologybpesubword. Entre estas, dos rasgos de la tipología lingüística resultan especialmente relevantes: la tipología sintáctica, que organiza las palabras dentro de una oración, y la tipología morfológica, que determina cómo se construyen las palabras internamente.

=== Clasificación de las lenguas

// Esta sección de definiciones no sé donde las saqué, así que asumiré Claude + Wikipedia
En un extremo de esa clasificación morfológica están las lenguas aislantes, donde las palabras no cambian de forma. Esa invariabilidad no significa que la lengua sea simple: el trabajo que en otras lenguas hacen las terminaciones o los prefijos, aquí lo hacen el orden de las palabras y el contexto. El chino mandarín es el ejemplo más conocido de este principio.

Un principio opuesto rige a las lenguas aglutinantes. En estas, las palabras crecen al incorporar fragmentos uno tras otro, cada uno con un significado propio y reconocible. Esos fragmentos se apilan de forma ordenada, casi como bloques ensamblados, lo que permite comprimir en una sola palabra lo que el español expresaría en varias. El turco funciona así.

Algo similar ocurre en las lenguas flexivas, aunque con una diferencia importante. Las palabras también se modifican, pero los fragmentos que se añaden no son tan fáciles de separar: una sola terminación puede expresar varias cosas al mismo tiempo. La -amos de "cantamos", por ejemplo, indica a la vez quién habla, cuántos son, en qué momento ocurre y con qué intención. El español, junto con el latín y el ruso, pertenecen a este grupo.
// Fin de la sección de definiciones

=== Relación entre tokenizadores y las lenguas

// TODO: Conectar mejor esto con el párrafo anterior. Quiero mencionar cómo los tokenizadores influyen en cada tipo de lengua y qué medidas también se pueden obtener. Así, podemos llegar a las métricas de productividad, idiosincrasia, etc
De manera similar, el tokenizador utilizado puede influir en el rendimiento de ciertas tareas de traducción dependiendo de las lenguas involucradas @domingo2019doestokenizationaffectneural. Asimismo, los tokenizadores cuyas subpalabras se alinean mejor con las unidades lingüísticas de una lengua tienden a mejorar el rendimiento de los modelos @bayram2025tokenizationstandardslinguisticintegrity. Esto sugiere que existe una relación entre los métodos de tokenización y las características de la lengua que se procesan.

Una de estas relaciones fue observada por #cite(<ximena-bpe-2023>, form: "prose"). Ellos definieron medidas para caracterizar a las lenguas de acuerdo a las propiedades de sus subpalabras generadas por BPE.  Estas medidas se definen en base a un modelo entrenado de BPE, con el objetivo de ver si de alguna manera, las subpalabras codifican información lingüística relevantes para los modelos de lenguaje. Estas medidas, influenciadas por la tipología morfológica, son la _productividad_ de una subpalabra, la _idiosincrasia_ y la _frecuencia acumulada_. Tales medidas son calculadas a partir de las subpalabras que generó un modelo BPE, así como del corpus usado para obtener este modelo.

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
