#import "@preview/fletcher:0.5.8" as fletcher: diagram, node, edge

/*
  En esta sección, vamos a describir los datos que usamos en 
*/
== Corpus y bases de datos

=== Lenguas

#figure(
   image("img/lenguas-mapa.pdf", width: 80%),
   caption: [Distribución de las 47 lenguas en el mundo. Cada color representa una familia de lenguas distinta.]
)<mapa-lenguas>

#underline[_Ximena: Falta agregar en el mapa un cuadro con la leyenda de cada famili lingüística. _]

Para la experimentación partimos de un conjunto de 47 lenguas (véase @tabla-de-lenguas) que destaca por su diversidad tipológica, genealógica y geográfica @ximena-bpe-2023. Esto permitió que los resultados no estuvieran sesgados por pocas regiones o pocas familias lingüísticas (véase @mapa-lenguas). Para identificar a las lenguas, usamos el conjunto de códigos ISO 639-3 @iso6393.


Sin embargo, a pesar de que las 47 lenguas están disponibles en el Corpus Paralelo de la Biblia (PBC), no necesariamente están presentes en todas las bases de datos que planeamos explorar en esta tesis. Por ejemplo, en la base de datos tipológica Grambank sólo están disponibles 40 de estas lenguas. Debido a esto y a otras decisiones metodológicas que se explicarán más adelante, trabajamos con un subconjunto de estas lenguas, procurando conservar la diversidad lingüística de la muestra.



//Estas lenguas faltantes se encuentran en diferentes regiones, lo cual no representa un sesgo sobre las 40 lenguas que quedaron. 

//Las 47 lenguas están disponibles en el Corpus Paralelo de la Biblia (PBC), y en las bases de datos WALS y lang2vec; mientras que en Grambank sólo están disponibles 40 de estas lenguas. Estas lenguas faltantes se encuentran en diferentes regiones, lo cual no representa un sesgo sobre las 40 lenguas que quedaron. 

// TODO: Mejorar redacción y mejorar la justificación de esto
//No obstante, cuando trabajamos con Grambank sólo usamos 38 lenguas. Quisimos también experimentar qué pasaría si quitamos las lenguas de coreano y birmano. Por tal motivo, los experimentos que llevaron Grambank se usaron un total de 38 lenguas (40 menos el coreano y birmano).


=== Corpus

Para obtener una caracterización de las 47 lenguas mediante PBE, usamos el Corpus Paralelo de la Biblia (_Parallel Bible Corpus_, PBC) @mayer-cysouw-2014-creating. Este corpus sirvió como entrada a BPE y así generar los modelos que permiten caracterizar a las lenguas.

El PBC reúne 994 traducciones de la Biblia distribuidas en 837 lenguas distintas según el estándar ISO 639-3, cobertura que incluye las 47 lenguas analizadas. Cada traducción está alineada a nivel de versículo mediante identificadores estandarizados, normalizada en Unicode y tokenizada a nivel de palabra, propiedades que lo hacen adecuado para el procesamiento computacional (véase @ejemplo-PBC). Al tratarse de un corpus paralelo, todas las lenguas comparten esencialmente el mismo contenido textual; esto hace comparables los modelos BPE entre lenguas, pues las diferencias que el algoritmo capture son atribuibles a la estructura de cada lengua y no a diferencias de dominio o tema.

Del PBC utilizamos las mismas traducciones, una por lengua, empleadas en el experimento original de #cite(<ximena-bpe-2023>, form: "prose"), lo que hace los resultados directamente comparables con los de aquel estudio.

#figure(
  table(
    columns: (1fr, 1fr),
    stroke: none,
    inset: (x: 8pt, y: 6pt),
    align: (left, left),
    table.hline(stroke: 0.5pt),
    [*EN*], [*ES*],
    table.hline(stroke: 0.3pt),
    [And straightway coming up out of the water , he saw the heavens opened , and the Spirit like a dove descending upon him :],
    [En cuanto Jesús salió del agua , vio que los cielos se abrían y que el Espíritu descendía sobre él como una paloma .],
    table.hline(stroke: 0.5pt),
  ),
  caption: [PBC Inglés-Español],
) <ejemplo-PBC>

#underline[_Ximena: Aquí podría convenir que pongas una tabla con alguna distribución que refleje el tamaño del corpus, por ejemplo promedio de tokens por lengua, o algo así. _]



Es importante subrayar que se usó únicamente el PBC porque es el corpus paralelo que abarca la mayor cantidad de lenguas. #cite(<ximena-bpe-2023>, form: "prose") usaron otros corpus de apoyo como _La Declaración Universal de los Derechos Humanos_ (DUDH) y el JW300 @agic-vulic-2019-jw300. Sin embargo, la DUDH cubre sólo 25 lenguas de las 47, mientras que el JW300 cubre 31 usando el umbral que establecieron de 68 artículos paralelos por lengua.

#underline[_ Ximena: Aquí finaliza haciendo énfasis que a partir de estos textos aplicas BPE para cada lengua , un método no supervisado, independiente d ela lengua, que se puede aplciar a cualquier texto (aunque abordes más adelante la vectorizcación_]) 

=== Bases de datos lingüísticas <bases-datos-linguisticas>

Además del PBC para aplicar BPE, empleamos bases de datos lingüísticas que contienen información lingüística explícita anotada por expertos, es decir, características tipológicas (morfológicas, sintácticas y fonológicas) de las lenguas analizadas. Estas características permiten corroborar posibles similitudes con la información morfológica presente en el espacio de BPE. Para ello, utilizamos el _World Atlas of Language Structures_ (WALS) y Grambank como las bases de datos principales; y lang2vec como soporte o experimento adicional.

==== WALS

#let database_footnote = [Los datos de WALS están disponibles en #link("https://github.com/cldf-datasets/wals").]

Utilizamos WALS #footnote(database_footnote) para tener una base con el experimento de #cite(<ximena-bpe-2023>, form: "prose"), lo cual permitió tener una comparación con los experimentos que involucraron WALS (con características de tipología morfológica) con los de otras bases que contienen otros tipos de características.

WALS @wals es una base de datos que contiene información sobre las propiedades fonológicas, gramaticales y léxicas de hasta 2,662 lenguas y variantes dialectales. WALS está organizado en 144 capítulos donde cada uno representa una característica lingüística. No obstante, de WALS solo utilizamos un subconjunto de 15 características porque codifican información principalmente relacionadas con la morfología @ximena-bpe-2023. WALS clasifica cada característica dentro de un área lingüística (fonología, morfología, sintaxis nominal, entre otras), lo que ofrece un punto de referencia para agrupar y seleccionar características. A su vez, este subconjunto presenta una cantidad reducida de valores vacíos para las lenguas analizadas. Estas características se listan por completo en @wals-features. Esta selección está basada en el trabajo previo. En esta tesis nos apegamos a esa decisión metodológica con el fin de mantener, en la medida de lo posible, la comparabilidad de los hallazgos.


Las características de WALS toman un valor entero positivo y no tienen la misma distribución, o sea el mismo rango de valores, entre todas estas características. Esto implica que cada valor contiene un significado diferente que varía de acuerdo a cada característica. Por ejemplo, la característica 20A puede tomar 7 valores (véase @ejemplo-feature-wals), 28A puede tomar hasta 4 y 49A hasta 9 valores diferentes.

#figure(
  table(
    columns: 2,
    align: (left, center),
    table.header(
      [*Nombre*], [*Valor*],
    ),
    [Exclusivamente concatenativo], [1],
    [Exclusivamente aislante], [2],
    [Exclusivamente tonal], [3],
    [Tonal/aislante], [4],
    [Tonal/concatenativo], [5],
    [Ablaut/concatenativo], [6],
    [Aislante/concatenativo], [7],
  ),
  caption: [Valores de la característica 20A en WALS.],
)<ejemplo-feature-wals>

Además del ISO 639-3, usamos el código WALS para identificar las lenguas, ya que varios códigos WALS pueden compartir un mismo código ISO 639-3 (como ocurre con algunos dialectos del alemán). Por eso, para cada código ISO 639-3, elegimos un solo código WALS y así trabajamos con una sola lengua por código.

Para identificar las lenguas sin ambigüedad, combinamos el código ISO 639-3 con el código WALS, ya que varios códigos WALS pueden compartir un mismo código ISO 639-3 (como ocurre con algunos dialectos del alemán). Por eso, para cada código ISO 639-3 elegimos un solo código WALS, y así trabajamos con una sola lengua por código.

==== Grambank

#let grambank_footnote = [Los datos de Grambank están disponibles en #link("https://github.com/grambank/grambank").]

Grambank#footnote(grambank_footnote) @grambank es otra base de datos lingüística que registra hasta 195 características de 2,467 lenguas y variantes dialectales en el mundo. Grambank es más reciente que WALS (publicado en línea en 2008) y, en promedio, codifica cada lengua con más características que WALS @haynie-etal-2023-grambanks (145 en comparación con 30). Esto hace de Grambank una base atractiva para analizar diversas combinaciones de características. 

Además, al ser una base de datos lingüística de creación relativamente reciente, en esta tesis consideramos importante integrarla con el objetivo de evaluar si la información capturada por BPE coincide con la información lingüística que contiene, ya que esta base de datos no pudo ser incluida en el trabajo previo citado en las secciones anteriores.

Las características de Grambank en su mayoría son binarias. Así, toman los valores de 0 y 1 (0/no, 1/sí), algo que contrasta con el rango de valores que toman las características de WALS. De acuerdo a #cite(<haynie-etal-2023-grambanks>, form: "prose"), el uso de características binarias permitió evitar ambigüedades en la categorización de las características y permitió registrar los rasgos en términos de presencia o ausencia, en vez de categorizar sólo la más dominante. Sin embargo, no todas las características tienen asignado un valor en algunas lenguas, por lo cual toman un valor de desconocido (?/desconocido). Por ejemplo, veamos cómo Grambank caracteriza una lengua con la característica GB020:

#align(center, box(width: 80%)[
  #set text(size: 11pt)
  #set align(left)
  1. Codifique con 1 si existe un morfema que pueda marcar definitud o especificidad sin transmitir también un significado deíctico espacial.

  2. Codifique con 0 si la fuente no menciona un artículo definido y no es posible encontrar uno en los ejemplos o textos de una gramática que, por lo demás, es exhaustiva.

  3. Codifique con ? si la gramática no contiene suficiente análisis para determinar si existe o no un artículo definido.

  4. Si ha codificado 1 para GB020 y 0 para GB021 y GB022, por favor escriba un comentario explicando la posición del artículo definido o específico.
])


#underline[_En este tipo de aseveraciones puedes ser mucho más explicativo con tono divulgador pues las explicaciones quedan muy ambiguas y cortas "Por un lado, la cobertura varía de una característica a otra, ya que no todas las lenguas registran el mismo conjunto." Por ejemplo, puedes cambiarlo por algo  mas desarrollado, paso por paso, donde expliques que muchas lenguas pueden tener valores de "?" en diferentes características, por lo que la cobertura de las características no es la misma, etc. Trata de ponerte siempre en el lugar del lector:_]

Por otro lado, decidir cuántas y cuáles características de Grambank utilizar fue una decisión que tuvimos que resolver nosotros mismos, pues no contábamos con un criterio claro para hacerlo. Por un lado, la cobertura varía de una característica a otra, ya que no todas las lenguas registran el mismo conjunto. Por otro, Grambank no agrupa sus características por área lingüística, como sí lo hace WALS, lo cual nos habría dado un criterio de selección sin necesidad de contar con conocimiento lingüístico especializado.


Sumado a esto, otra diferencia con WALS es que las lenguas de ambas bases no presentan una correspondencia directa, por lo que fue necesario un puente entre ellas a través del ISO 639-3 con ayuda de Glottolog @glottolog2026. Esto se debe a que Grambank identifica las lenguas mediante Glottocodes @grambank-paper, asignados por Glottolog a cada lengua, pero no incluye directamente el código ISO 639-3 de cada una. WALS, en cambio, sí registra este código ISO 639-3 para sus lenguas. Por ello, nos apoyamos en los datos de Glottolog (que sí asocian cada Glottocode con su ISO 639-3) para obtener este código y usarlo como identificador puente entre ambas bases (véase @iso-puente).

#figure(
  diagram(
    spacing: (20mm, 10mm),
    node-stroke: 0.5pt,
    node-corner-radius: 3pt,

    node((0,0), [WALS], name: <wals>),
    node((1,0), [ISO 639-3], name: <iso>,
      stroke: 1pt,
      inset: 8pt,
    ),
    node((2,0), [Grambank], name: <gram>),

    edge(<wals>, <iso>, "<->"),
    edge(<iso>, <gram>, "<->"),
  ),
  caption: [ISO 639-3 como identificador puente entre los \ códigos propios de WALS y Grambank.],
)<iso-puente>

==== lang2vec

#let lang2vec_footnote = [El repositorio público se encuentra en #link("https://github.com/antonisa/lang2vec").]

lang2vec @littell2017uriel #footnote(lang2vec_footnote) es una biblioteca que proporciona representaciones vectoriales tipológicas de lenguas, integrando información de varias bases de datos lingüísticas (WALS, PHOIBLE, Ethnologue, Glottolog, entre otras). Principalmente se enfoca en características fonológicas y sintácticas, que no constituyen nuestro principal interés. Sin embargo, incorporamos este recurso para realizar un experimento complementario y contrastar qué tanta información sintáctica contienen las caracterizaciones que estamos utilizando.   

//La usamos por sus conjuntos de características sintácticas, que contrastan con las características de tipología morfológica que seleccionamos de WALS.

De los conjuntos de características sintácticas que ofrece lang2vec, elegimos `syntax_knn`, que imputa los valores faltantes mediante $k$ vecinos más cercanos, ya que es el único que cubre las 47 lenguas del estudio sin valores vacíos y predice esos valores con una exactitud alrededor del 92% en validación cruzada @littell2017uriel. Los demás conjuntos se distinguen por sus fuentes y por cómo tratan los valores faltantes: `syntax_wals`, `syntax_sswl` y `syntax_ethnologue` provienen de una sola base cada uno, y `syntax_avg` las promedia. En estos conjuntos, mientras más lenguas y características abarcan, más valores vacíos tienen. Un ejemplo es `syntax_wals`, que es el más amplio, solo llena el 44% de sus valores, y ni siquiera promediar las fuentes ayuda, pues `syntax_avg` alcanza apenas el 34% de cobertura.

Por último, en contraste a Grambank, lang2vec usa el iSO 639-3 para la identificación de lenguas. Por ende, se usó la misma relación con los Glottocodes para relacionar a lang2vec con Grambank.