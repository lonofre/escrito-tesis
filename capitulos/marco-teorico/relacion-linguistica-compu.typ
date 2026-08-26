/*
  En general, queremos hacer una relación entre los LLMs y la lingüística. Esto lo vamos a lograr mediante la caracterización de las lenguas mediante BPE (u otro tokenizador).
*/
== La huella lingüística de la tokenización

Esa pregunta no es nueva. Debido a la simplicidad concptual de los algoritmos, la tokenización comúnmente es concebida como un paso de ingeniería del modelo sin contenido lingüístico explícito, en contraste a lo que podrían ser otros procesos como la segmentación morfológica o el análisis morfológico automático. @mielke2021wordscharactersbriefhistory @galle-2019-investigating @bostrom-durrett-2020-byte @clark-et-al-2022 @saleva-lignos-2021-effectiveness @oncevay-etal-2022-quantifying.

Esa posición tenía fundamentos, pues BPE no recibe información lingüística como gramáticas, lexicón o reglas morfológicas. Su único criterio es la frecuencia con que dos símbolos aparecen en posición adyacente, una propiedad de la forma superficial del texto y no de su estructura subyacente; un procedimiento separado del aprendizaje del modelo cuyo único fin era preparar el texto para que este lo consuma como una simple secuencia de enteros. Por construcción, BPE es ciego a la lengua que procesa. Sin embargo, esa ceguera ha empezado a cuestionarse.

Distintos estudios apuntan en la misma dirección. #cite(<domingo2019doestokenizationaffectneural>, form: "prose") mostraron que el tokenizador cambia el rendimiento de la traducción automática, y que ese cambio depende de las lenguas involucradas. #cite(<parra2024morphologicaltypologybpesubword>, form: "prose") encontró que la segmentación que produce BPE varía según la morfología de la lengua. #cite(<bayram2025tokenizationstandardslinguisticintegrity>, form: "prose") observaron que los tokenizadores cuyas subpalabras se parecen a las unidades lingüísticas de una lengua producen mejores modelos. La observación común es que la lengua sí importa para BPE, pues si el algoritmo fuera ciego a su estructura, estos efectos no se repetirían entre lenguas distintas.

Si la lengua importa para BPE, la siguiente pregunta es cuál parte de la lengua importa más. Entre los rasgos que distinguen a unas lenguas de otras, hay uno que trabaja sobre el mismo material que BPE, que estudia la estructura interna de las palabras. Ese rasgo es la morfología @haspelmath2010understanding.

=== Tipología morfológica

La tipología lingüística estudia las semejanzas y diferencias estructurales que existen entre las distintas lenguas del mudo @velupillai2012. La tipología morfológica realiza este estudio a nivel de las diferencias de los procesos y estructuras que intervienen en la formación de palabras en una lengua. Por ejemplo, si pensamos en términos de morfemas, las unidades más pequeñas de una palabra que poseen algún tipo de significado, ya sea gramatical o léxico (tri-sílaba, come-mos, niñ-a-s), podría ser de interés conocer cómo funcionan estos mecanismos en las diferentes lenguas que se hablan en el mundo para poder clasificarlas. 

Hay lenguas que suelen tener una gran cantidad de morfemas por palabra, mientras que en otras los procesos morfológicos son más limitados y hay pocos morfemas por palabra o, incluso, las palabras carecen de procesos morfológicos internos. En esta escala de clasificación tipológica podemos encontrar lenguas analíticas, con pocos morfemas formando una palabra; aquí encontraríamos lenguas como el chino o incluso el inglés, con una morfología relativamente reducida. En un punto intermedio se encuentran las lenguas sintéticas, que suelen sintetizar o codificar en una sola palabra gran cantidad de información mediante el uso de diferentes morfemas (como ocurre en el alemán o el turco). Finalmente, encontramos las lenguas polisintéticas, donde el uso extensivo de morfemas dentro de una palabra les permite codificar en una sola palabra lo que en otras lenguas más analíticas requiere varias palabras (aquí estarían lenguas como el kalaallisut, el náhuatl o el quechua, entre otras) @sapir1921language.

Además del grado de _síntesis_, otra dimensión clásica para clasificar la morfología de las lenguas es el grado de fusión de los morfemas. Podemos encontrar lenguas fusionales (como el latín o el español), donde un solo morfema fusiona diferentes funciones gramaticales. Por ejemplo, en español, el morfema -mos en la terminación de un verbo es una flexión que codifica simultáneamente información sobre la persona, el tiempo, el aspecto y el modo. También hay lenguas aglutinantes, que van concatenando morfemas, donde cada uno codifica una función gramatical distinta (como el turco o el náhuatl). Finalmente, encontramos las lenguas aislantes, en las que cada morfema que codifica una función gramatical o información léxica constituye una palabra independiente; es decir, los procesos morfológicos son mínimos, ya que prácticamente no existen flexiones ni derivaciones dentro de las palabras.

Otra dimensión de interés es qué tan estable es la forma de un morfema entre distintos grupos de palabras. En algunas lenguas, un mismo morfema no siempre tiene la misma forma, sino que cambia según el grupo al que pertenece la palabra. Las terminaciones verbales del español son un buen ejemplo de esto, ya que sus verbos se reparten en grupos según terminen en -ar, en -er o en -ir, y la terminación que usamos para "nosotros" es distinta en cada uno, pues decimos amamos, pero tememos y vivimos. El inglés, en cambio, funciona al revés, ya que por lo general la forma del verbo para "we" es la misma sin importar de qué verbo se trate (_we love, we fear, we live_). Cuanto más cambia la forma de estos morfemas según el grupo de la palabra, más flexiva es una lengua, lo que #cite(<Bickel-and-Nichols-2007>, form: "prose") denomina el grado de _flexividad_.

Existen muchas otras categorías de análisis dentro de la tipología morfológica que no abordaremos aquí. Lo importante es resaltar que conocer la estructura de las lenguas permite clasificarlas, una tarea que requiere un profundo conocimiento lingüístico y un análisis detallado de los morfemas y otros fenómenos gramaticales, los cuales deben ser identificados e interpretados por un lingüista. BPE no dispone de ese análisis, ya que segmenta las palabras guiándose de un algoritmo de compresión y frecuencias. Aun así, trabaja sobre el mismo material que la morfología, es decir, los fragmentos internos de la palabra. Cabe preguntarse entonces si las propiedades de las subpalabras que produce BPE, sin conocimiento morfológico alguno, reflejan algunas de las distinciones tipológicas que acabamos de describir.

_#underline[Ximena: Trata de verificar que las referencias bibliográficas que yo utilicé en mi artículo para estas descripciones tipológicas también estén aquí arriba ]_

=== Caracterización de las lenguas mediante BPE

Para responder a esta pregunta, #cite(<ximena-bpe-2023>, form: "prose") partieron de dos nociones lingüísticas y las convirtieron en cantidades medibles sobre las subpalabras de BPE. La primera es la productividad, la probabilidad de que un patrón o regla de una lengua se repita en palabras nuevas. Cuanto más productivo es un patrón, con más facilidad lo usan los hablantes para formar palabras. Por ejemplo, en inglés los morfemas -ed (marca de pasado) y -ing (marca de aspecto progresivo) son morfemas altamente productivos, ya que se utilizan para formar las flexiones de un gran número de verbos regulares. Es decir, pueden combinarse con una amplia variedad de bases o stems, lo que permite generar nuevas formas verbales de manera sistemática.

La segunda es el nivel de idiosincrasia, que, a diferencia de los patrones productivos y regulares, se refiere a formas irregulares que no están compuestas por morfemas que puedan combinarse fácilmente con otros o aparecer en otros lexemas. Más bien, estas formas se almacenan como palabras completas, en lugar de generarse mediante una regla morfológica @Bybee2007. Este es el caso, por ejemplo, de formas como _soy_ o _fui_ en español, que constituyen unidades fosilizadas de alta frecuencia. Estas formas se aprenden de memoria y no siguen un patrón morfológico predecible. 

De estas nociones surgen tres medidas que se calculan directamente sobre el corpus a partir de las unidades subpalabra (tokens) que va encontrando el algortimo BPE iterativamente. 

La *productividad* de una subpalabra $s$ se define como el número de palabras ortográficas (las palabras tal como aparecen separadas por espacios) que la contienen en el corpus $W$. Una subpalabra es más productiva cuantas más palabras distintas la contienen. Por ejemplo, en español el sufijo de plural _-s_ es muy productivo, pues se añade a casi cualquier palabra nueva para formar su plural, incluso a préstamos recientes como _selfie_ (_selfies_), _reel_ (_reels_) o _meme_ (_memes_).

$ "productividad"(s) = |W_s| $

La *frecuencia acumulada* de una subpalabra $s$ es la frecuencia de $s$ en el corpus $W$. Esta medida es independiente si esta subpalabra aparece contenida en una palabra como si aparece de manera independiente.

$ "c.freq"(s) = sum_(w in W_s) "freq"(w) $

La *idiosincrasia* hace referencia a esas subpalabras que son muy frecuentes pero pocas palabras la contienen. Por ello, se calcula dividiendo la frecuencia acumulada de una subpalabra $s$ en un corpus $W$, $"c.freq"(s)$, entre el número de palabras en las que aparece, $"productividad"(s)$:

$ "idiosincrasia"(s) = "c.freq"(s)/"productividad"(s) $

Un valor alto indica que la subpalabra se concentra en pocas palabras muy frecuentes, el comportamiento típico de las formas idiosincráticas. Un valor bajo indica que se distribuye entre muchas palabras, propio de los patrones productivos (véase @tabla-ejemplo-medidas-bpe).

#figure(
  table(
    columns: 4,
    align: (left, center, center, center),
    table.header(
      [*Subpalabra*], [*productividad*], [*c.freq*], [*idiosincrasia*],
    ),
    [#raw("ed</w>")], [271], [917], [3.38],
    [#raw("had</w>")], [1], [104], [104],
    [#raw("and</w>")], [11], [2,197], [199.72],
  ),
  caption: [Subpalabras en inglés generadas por las fusiones de BPE sobre el corpus PBC, con los valores que toman en productividad, frecuencia acumulada e idiosincrasia, tomado de #cite(<ximena-bpe-2023>, form: "prose").],
) <tabla-ejemplo-medidas-bpe>

Con estas tres medidas, #cite(<ximena-bpe-2023>, form: "prose") caracterizaron a 47 lenguas y construyeron una representación vectorial para cada una (véase @og-bpe-space). Para construirla, calcularon las tres medidas sobre cada subpalabra que surge a lo largo de las sucesivas fusiones de BPE, promediaron esos valores por lengua para obtener un solo vector, y normalizaron el espacio resultante centrando y escalando cada dimensión para que las tres medidas quedaran en una escala comparable.

#figure(
  image("img/bpe-space.svg", width: 100%),
  caption: [Espacio de BPE definido por #cite(<ximena-bpe-2023>, form: "prose").],
) <og-bpe-space>

A partir de estas caracterizaciones de las lenguas mediante BPE, los autores observaron que existía una correspondencia con las nociones lingüísticas de la tipología morfológica. Por ejemplo, el eje de productividad parece estar relacionado con el grado de síntesis de una lengua. Las lenguas con tendencia analítica o aislante se ubican en la región de baja productividad, como el inglés (eng), el vietnamita (vie) o el sango (sag). En el extremo opuesto, las lenguas con tendencia aglutinante o polisintética, como el quechua (qvi) o el kalaallisut (kal), mostraron una alta productividad en el espacio inducido por BPE. Asimismo, puede observarse que las lenguas con una morfología menos productiva tienden a presentar patrones más idiosincráticos. #cite(<ximena-bpe-2023>).

El hecho de que las lenguas se distribuyan en el espacio inducido por BPE de una manera que también resulta coherente desde una perspectiva tipológica implica que las propiedades de los patrones que captura BPE reflejan, al menos parcialmente, la naturaleza estructural de las lenguas. Los autores concluyen que, para comprimir lenguas altamente aglutinantes o polisintéticas, BPE aprovecha patrones morfológicos altamente productivos en las primeras operaciones de merge. En cambio, para comprimir lenguas menos sintéticas y más aislantes, con una morfología más limitada, BPE realiza sus primeras operaciones de merge utilizando patrones altamente idiosincráticos.

Para complementar estas observaciones, este trabajo previo realiza una comparación entre el espacio inducido por BPE y los vectores obtenidos para cada lengua a partir de características extraídas de una base de datos lingüística (WALS). Si bien no se trata de los mismos espacios ni caracterizan exactamente los mismos aspectos de las lenguas, por lo que no comparten la misma topología, es posible evaluar si las lenguas que tienden a agruparse en un espacio también tienden a agruparse en el otro.

Pero esa conclusión aún descansa en una validación cuantitativa frágil, ya que comparó el espacio de BPE contra una sola base de datos, WALS, bajo una única configuración de agrupamiento y con una sola semilla aleatoria. Para fortalecer la comprobación y extender la exploración, en este trabajo incluimos el contraste a otras bases de datos tipológicas y a distintas configuraciones de agrupamiento, y medimos qué tanto coinciden los agrupamientos basados en diferentes caracterizaciones. 
