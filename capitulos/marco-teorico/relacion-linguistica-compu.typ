/*
  En general, queremos hacer una relación entre los LLMs y la lingüística. Esto lo vamos a lograr mediante la caracterización de las lenguas mediante BPE (u otro tokenizador).
*/
== La huella lingüística de la tokenización

Esa pregunta no es nueva. Durante años, la tokenización fue tratada como un paso de ingeniería sin contenido lingüístico propio, un procedimiento separado del aprendizaje del modelo cuyo único fin era preparar el texto para que este lo consuma como una simple secuencia de enteros @mielke2021wordscharactersbriefhistory.

Esa posición tenía fundamentos, pues BPE no recibe información lingüística como gramáticas, lexicón o reglas morfológicas. Su único criterio es la frecuencia con que dos símbolos aparecen juntos, una propiedad de la forma superficial del texto y no de su estructura subyacente. Por construcción, BPE es ciego a la lengua que procesa. Sin embargo, esa ceguera ha empezado a cuestionarse.

// TODO: La siguiente revisión de literatura es preliminar; conviene ampliarla co más trabajos que muestren la dependencia de BPE (o de la tokenización en general) con la lengua
Distintos estudios apuntan en la misma dirección. #cite(<domingo2019doestokenizationaffectneural>, form: "prose") mostraron que el tokenizador cambia el rendimiento de la traducción automática, y que ese cambio depende de las lenguas involucradas. #cite(<parra2024morphologicaltypologybpesubword>, form: "prose") encontró que la segmentación que produce BPE varía según la morfología de la lengua. #cite(<bayram2025tokenizationstandardslinguisticintegrity>, form: "prose") observaron que los tokenizadores cuyas subpalabras se parecen a las unidades lingüísticas de una lengua producen mejores modelos. La observación común es que la lengua sí importa para BPE, pues si el algoritmo fuera ciego a su estructura, estos efectos no se repetirían entre lenguas distintas.

Si la lengua importa para BPE, la siguiente pregunta es cuál parte de la lengua importa más. Entre los rasgos que distinguen a unas lenguas de otras, hay uno que trabaja sobre el mismo material que BPE, que estudia la estructura interna de las palabras. Ese rasgo es la morfología @haspelmath2010understanding.

=== Tipología morfológica

La tipología lingüística estudia las semejanzas y diferencias estructurales que existen entre las distintas lenguas @velupillai2012. La tipología morfológica realiza este estudio a través de los morfemas. Estos son las piezas más pequeñas de una palabra que poseen algún tipo de significado. Por ejemplo, en la palabra _trisílaba_, _tri-_ es el morfema que indica que se trata de tres elementos (en este caso, tres sílabas). Este mismo morfema aparece también en palabras como _tridimensional_, _tricolor_ o _triángulo_, donde siempre conserva el significado de "tres".

Una de las dimensiones de la morfología de interés para la tokenización es el número de morfemas por palabra @jm3. Cuando en promedio cada palabra corresponde a un morfema en una lengua, como el cantonés, se las denomina lenguas _analíticas_. En cambio, cuando en promedio las palabras tienen varios morfemas, como el groenlandés, las lenguas se ubican en una escala que va de _sintéticas_ a _polisintéticas_, según cuántos morfemas acumulen por palabra. A esto se le denomina el grado de síntesis @sapir1921language.

Además de la síntesis, otra dimensión de interés es la segmentabilidad de los morfemas, es decir, qué tan fácil resulta separarlos unos de otros dentro de la palabra @jm3. En un extremo hay lenguas donde los morfemas suelen ser como palabras sueltas e independientes, lo que se conoce como morfemas _aislantes_ (_isolating_), como el chino mandarín. En el otro extremo hay lenguas donde los morfemas no se pueden separar como un segmento de la palabra, sino que modifican directamente la raíz, lo que se conoce como morfemas _no concatenativos_ , como ocurre en árabe. En un punto intermedio hay lenguas como el turco, donde los morfemas van pegados unos a otros pero aun así se distinguen con claridad, lo que se conoce como morfemas _concatenativos_ (del inglés _concatenative_). Mientras más se acerque una lengua a alguno de los extremos, mayor es su grado de fusión @Bickel-and-Nichols-2007.

Por último, otra dimensión de interés es qué tan estable es la forma de un morfema entre distintos grupos de palabras. En algunas lenguas, un mismo morfema no siempre tiene la misma forma, sino que cambia según el grupo al que pertenece la palabra. Las terminaciones verbales del español son un buen ejemplo de esto, ya que sus verbos se reparten en grupos según terminen en -ar, en -er o en -ir, y la terminación que usamos para "nosotros" es distinta en cada uno, pues decimos amamos, pero tememos y vivimos. El inglés, en cambio, funciona al revés, ya que por lo general la forma del verbo para "we" es la misma sin importar de qué verbo se trate (_we love, we fear, we live_). Cuanto más cambia la forma de estos morfemas según el grupo de la palabra, más flexiva es una lengua, lo que #cite(<Bickel-and-Nichols-2007>, form: "prose") denomina el grado de _flexividad_.

Estas tres dimensiones se definen sobre los morfemas, y los morfemas no se leen directamente del texto, sino que un lingüista debe identificarlos mediante análisis. BPE no dispone de ese análisis, ya que segmenta las palabras guiándose únicamente por la frecuencia. Aun así, trabaja sobre el mismo material que la morfología, es decir, los fragmentos internos de la palabra. Cabe preguntarse entonces si las propiedades de las subpalabras que produce BPE, sin conocimiento morfológico alguno, reflejan algunas de las distinciones tipológicas que acabamos de describir.

=== Caracterización de las lenguas mediante BPE

Para responder a esta pregunta, #cite(<ximena-bpe-2023>, form: "prose") partieron de dos nociones lingüísticas y las convirtieron en cantidades medibles sobre las subpalabras de BPE. La primera es la productividad, la probabilidad de que un patrón o regla de una lengua se repita en palabras nuevas. Cuanto más productivo es un patrón, con más facilidad lo usan los hablantes para formar palabras. La segunda es la idiosincrasia, que reúne las partes de la lengua que no siguen un patrón fijo. Cuando estas formas irregulares son muy frecuentes, se almacenan como palabras completas en lugar de generarse mediante una regla @Bybee2007. De estas nociones surgen tres medidas. La productividad y la frecuencia acumulada se calculan directamente sobre el corpus, y la idiosincrasia se obtiene a partir de las dos anteriores.

La *productividad* de una subpalabra $s$ se define como el número de palabras ortográficas (las palabras tal como aparecen separadas por espacios) que la contienen en el corpus $W$. Una subpalabra es más productiva cuantas más palabras distintas la contienen. Por ejemplo, en español el sufijo _-ble_ es muy productivo, pues forma palabras como _comible_, _bebible_ o _hackeable_, y lo mismo ocurre con _-idad_ en _amabilidad_ o _nacionalidad_.

$ "productividad"(s) = |W_s| $

La *frecuencia acumulada* no proviene de una noción lingüística sino de una intuición de medición. No todas las palabras pesan lo mismo, ya que una subpalabra que aparece en pocas palabras pero muy frecuentes contribuye más al uso real de la lengua que otra repartida en muchas palabras raras. Se define como la suma de las frecuencias de las palabras ortográficas que contienen a $s$:

$ "c.freq"(s) = sum_(w in W_s) "freq"(w) $

La *idiosincrasia* recupera esa noción a partir de las dos medidas anteriores. Capta las formas que no se generan con una regla sino que se aprenden por separado, como el plural _menús_ o _menúes_ de _menú_, o las formas del verbo irregular _ir_ (_voy_, _fui_, _iré_). Se define como el cociente entre la frecuencia acumulada y la productividad de una subpalabra:

$ "idiosincrasia"(s) = "c.freq"(s)/"productividad"(s) $

Un valor alto indica que la subpalabra se concentra en pocas palabras muy frecuentes, el comportamiento típico de las formas idiosincráticas. Un valor bajo indica que se distribuye entre muchas palabras, propio de las formas productivas.

Con estas tres medidas, #cite(<ximena-bpe-2023>, form: "prose") caracterizaron a 47 lenguas y construyeron una representación vectorial para cada una (@og-bpe-space).

#figure(
  image("img/bpe-space.png", width: 80%),
  caption: [Espacio de BPE definido por #cite(<ximena-bpe-2023>, form: "prose").],
) <og-bpe-space>

De estas medidas, #cite(<ximena-bpe-2023>, form: "prose") destacaron la productividad, cuyos valores acompañan al grado de síntesis y de fusión de cada lengua. En su análisis cualitativo, las lenguas con baja productividad resultaron ser analíticas y aislantes, como el inglés y el vietnamita. En el extremo opuesto, lenguas polisintéticas y concatenativas como el quechua mostraron una productividad alta. 

Que el espacio agrupe a lenguas tipológicamente afines sugiere que las subpalabras de BPE capturan algo más que frecuencia. Pero esa conclusión aún descansa en una validación cuantitativa frágil, ya que comparó el espacio de BPE contra una sola base de datos, WALS, bajo una única configuración de agrupamiento y con una sola semilla aleatoria. Con esa única prueba no se puede saber si la coincidencia refleja una señal lingüística real o un artefacto de esas decisiones. Para comprobarlo, extendemos el contraste a otras bases tipológicas y a distintas configuraciones de agrupamiento, y medimos qué tanto coinciden los agrupamientos que induce cada espacio, cualquiera que sea su fuente.
