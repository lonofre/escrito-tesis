= Discusión
// BORRADOR AUN SIN TERMINAR
// Referencias para escribir la discusión:
//  - https://pmc.ncbi.nlm.nih.gov/articles/PMC10676253/

El espacio que induce BPE ($X_"BPE"$) conserva algo de la organización tipológica de las lenguas, pero lo hace de manera intermitente. En los tres experimentos que comparan a $X_"BPE"$ con bases de datos lingüísticas, la coincidencia supera a la de la referencia aleatoria, y lo hace en todos los puntos del barrido de características, sobre las diez mil parejas de semillas que probamos en cada uno. Sin embargo, casi toda esa brecha vive en el extremo alto de la distribución, pues, salvo con $X_W$, la mediana apenas se despega de cero y son las mejores corridas las que separan a $X_"BPE"$ del azar. Estos valores altos de ARI no son un accidente, ya que los grupos que los producen ocupan regiones reconocibles en $X_"BPE"$ y no aparecen tan dispersos como en la referencia. Aun así, $X_G$ y $X_W$ coinciden más seguido entre sí que $X_"BPE"$ con cualquiera de las dos, por lo que la huella lingüística de BPE existe y es medible, pero es más delgada que la que comparten dos bases de datos construidas por lingüistas.

// Pregunta 1
*BPE vs WALS.* La coincidencia entre $X_"BPE"$ y $X_W$ que reportaron #cite(<ximena-bpe-2023>, form: "prose") se mantiene cuando dejamos de depender de una sola configuración de agrupamiento y medimos con otra métrica. La referencia $X_0$ resultó casi nula bajo ARI, con el 99% de sus valores por debajo de $0.065$ y un máximo de $0.104$, de modo que un agrupamiento aleatorio sobre las mismas 47 lenguas no alcanza a reproducir la organización de $X_W$. Frente a esos valores, $X_"BPE"$ llega a un percentil 99 de $0.20$ y a un máximo de $0.294$, cerca del triple en ambos casos. Es relevante que la separación tampoco se limita al extremo alto, ya que en este experimento los rangos intercuartiles ni siquiera se solapan, algo que no vuelve a ocurrir en los demás experimentos. El hallazgo original no dependía entonces de la semilla ni de la métrica con la que se midió.

Ese hallazgo se sostiene además en la forma de los grupos, porque los valores altos corresponden a grupos con una organización visible en $X_"BPE"$, cosa que no ocurre en $X_0$. Un ARI alto puede salir de un agrupamiento arbitrario que coincida por accidente, por ejemplo, al medir grupos con solo uno o dos elementos. Así que fuimos a ver los grupos que lo producen. La @ejemplo-espacios-clusters-wals-bpe muestra los grupos obtenidos en $X_W$ pintados sobre cada espacio, tomando en cada uno una configuración con valor alto, con un ARI de $0.2717$ en $X_"BPE"$ y de $0.1043$ en $X_0$. En $X_0$ los grupos de $X_W$ quedan dispersos y mezclados entre sí. En $X_"BPE"$ se ven más juntos, y aunque no llegan a estar separados como lo estarían dos agrupamientos iguales, sí ocupan zonas reconocibles. Esa continuidad es lo que mide un ARI de $0.2717$.

// cluster 1 : 50 de wals, ari de 0.271739 en seed2 15
// cluster 2: 5 de wals, ari de 0.104387 en seed2 44
#figure(
  image("img/wals-bpe-comparison-s50-&-s5.svg", width: 105%),
  caption: [Los grupos de $X_W$ vistos sobre $X_"BPE"$ (izquierda, ARI de $0.2717$)
    y sobre la referencia $X_0$ (derecha, ARI de $0.1043$). El color de cada lengua
    es su grupo en WALS, no el del espacio donde está dibujada.]
)<ejemplo-espacios-clusters-wals-bpe>

// Pregunta 2
*BPE vs Grambank.* Esa coincidencia se mantiene pese al cambio de base de datos, aunque en el caso de Grambank se concentra más en la parte alta de la distribución. El percentil 99 de $X_"BPE"$ vs $X_G$ recorre valores entre $0.14$ y $0.28$ a lo largo del barrido, mientras el de la referencia se queda plano cerca de $0.09$, y el máximo real llega a $0.49$ frente a $0.24$. Ese techo es más alto que el de WALS, aunque sobre menos lenguas y con más configuraciones. Por tal motivo leemos cada experimento contra su propia referencia, y bajo ese criterio Grambank confirma lo que ya mostraba WALS. Lo que no se repite es la separación en el centro de la distribución, pues la mediana apenas se despega de cero y el primer cuartil es negativo, muy cerca del de la referencia. La coincidencia con Grambank existe en algunas configuraciones y no en la mayoría.

En esas pocas configuraciones, los grupos de $X_G$ ocupan regiones reconocibles del espacio de BPE. La @ejemplo-espacios-clusters-grambank-bpe toma en cada panel una de ellas, con $d_G = 36$ y un ARI de $0.3800$ en $X_"BPE"$, y $d_G = 84$ con $0.2433$ en $X_0$, siguiendo el mismo criterio de la figura anterior. Los grupos quedan mejor distribuidos sobre $X_"BPE"$ que sobre la referencia, donde otra vez aparecen mezclados. La excepción está en el kalaallisut (kal), el sanumá (xsu) y el alamblak (amp), que caen en un mismo grupo aunque en el espacio de BPE quedan muy lejos entre sí.

// TODO: Probablamente podríamos agregarlo después, pero con un ejemplo y un puente sobre el efecto de los máximos valores
// TODO: Agregar esto también al párrafo anterior o siguiente, pero con el mismo contexto de grambank:
//  Obtenemos valores altos con Grambank al final, pero posiblemente es por el peso que tienen los valores vacíos debido a la imputación
//El punto del barrido donde cae ese ejemplo también importa. Las características que Grambank va agregando hacia el final del barrido traen cada vez más valores imputados, de modo que un ARI alto en esa zona puede estar describiendo el patrón de datos faltantes en lugar de la gramática de las lenguas. Con treinta y tantas características el techo ya es alto y los espacios todavía descansan sobre información observada, así que es ahí donde la coincidencia resulta más creíble.


// cluster 1 de Grambank (n36 y s44): ari de 0.3800 en seed2 77
// cluster 2 de Grambank (n84 y s88):, ari de 0.2433 en seed2 34
#figure(
  image("img/grambank-bpe-n36-s44-&-n84-s88.svg", width: 105%),
  caption: [Los grupos de $X_G$ vistos sobre $X_"BPE"$ (izquierda, $d_G = 36$, ARI
    de $0.3800$) y sobre la referencia $X_0$ (derecha, $d_G = 84$, ARI de $0.2433$).
    El color de cada lengua es su grupo en Grambank, no el del espacio donde está
    dibujada.]
)<ejemplo-espacios-clusters-grambank-bpe>
// TODO: Agregar el experimento bien en el caption

*BPE vs WALS+Grambank.* Combinar $X_W$ con $X_G$ no sube el techo respecto a lo que ya daba Grambank sola. El percentil 99 arranca en el mismo $0.17$ y llega a un valor equivalente al final del barrido, y lo único que sube es el máximo real, hasta $0.545$ en $d_G = 75$ frente a $0.493$ de Grambank sola. Así que lo que vale la pena mirar en este experimento son los picos, en especial los picos locales de la primera mitad del barrido. Antes de $d_G=45$ aparecen estos valores que no llegan a $0.5$, que son más bajos que el techo del barrido, pero se obtienen con la mitad de las características y con muchos menos valores imputados. La @ejemplo-espacios-clusters-grambankANDwals-bpe muestra uno de esos picos, con 38 características y un ARI de $0.4743$ en $X_"BPE"$. Aunque aquí reaparece el problema del ejemplo anterior (un grupo pequeño formado por el yaqui (yaq), el vietnamita (vie) y el sanumá (xsu)), los grupos se ven más definidos.

// X_BPE: n38 y s51, ari de 0.4743
// X_0: n85 y s67, ari de 0.2049
#figure(
  image("img/grambank&wals-bpe-n38-s51-&-n85-s67.svg", width: 105%),
  caption: [Los grupos de $X_(W+G)$ vistos sobre $X_"BPE"$ (izquierda, $d_G = 38$,
    ARI de $0.4743$) y sobre la referencia $X_0$ (derecha, $d_G = 85$, ARI de
    $0.2049$). El color de cada lengua es su grupo en el espacio combinado, no el
    del espacio donde está dibujada.]
)<ejemplo-espacios-clusters-grambankANDwals-bpe>


*Grambank vs WALS.* Para juzgar lo que alcanza BPE, hay que notar que $X_G$ y $X_W$ tampoco coinciden tanto entre sí. El tercer cuartil de $X_G$ vs $X_W$ está por encima del de cualquier comparación con $X_"BPE"$ en casi todo el barrido, salvo en los primeros cuatro puntos frente a $X_"BPE"$ vs $X_W$, o sea que WALS y Grambank se parecen de manera más constante. En el extremo alto, en cambio, se emparejan, porque las comparaciones con BPE llegan a ese techo alrededor de las 75 características. BPE coincide menos seguido, pero cuando coincide llega igual de alto.

Los grupos de $X_G$ se distinguen claramente al visualizarlos sobre $X_W$, aunque persisten grupos de tres lenguas y se obtiene un ARI de $0.4692$ en este ejemplo (@ejemplo-espacios-clusters-grambank-wals). Para lograr esta visualización, dado que $X_W$ no es tridimensional de origen, usamos el análisis de componentes principales (_Principal Component Analysis_, PCA) para obtener una representación en tres dimensiones. Sin embargo, esta reducción pierde información tanto de los agrupamientos como de los puntos.

// grambank vs wals: n39 y s46
#figure(
  image("img/grambank-wals-n39-s46.svg", width: 105%),
  caption: [El espacio de WALS, reducido a tres dimensiones mediante análisis de
    componentes principales, con los grupos de $X_G$ de la configuración de
    $d_G = 39$. El color de cada lengua es su grupo en Grambank, no el del espacio
    donde está dibujada.]
)<ejemplo-espacios-clusters-grambank-wals>

// TODO: Buscar si hay un paper que soporte que características one hot encoding hace que se parezcan
*Grambank vs lang2vec.* La otra comparación entre bases de datos lingüísticas, $X_G$ y $X_"l2v"$, sube todavía más ese punto de referencia, pues resultaron el par de espacios más parecidos de todo el estudio, con un tercer cuartil por encima del de cualquier otro experimento y un techo que pasa de $0.7$. Ninguna comparación con $X_"BPE"$ se acerca a esa distribución, ni en el centro ni en el techo.

Ese gran parecido no se queda en los valores de ARI, porque algunos grupos que lo producen se sostienen a la vista. La @ejemplo-espacios-clusters-grambank-lang2vec muestra el espacio de lang2vec, reducido a tres dimensiones mediante PCA, con los grupos que forma Grambank en la configuración de 39 características que alcanzó un ARI de $0.7148$. Los grupos aparecen unidos y ocupando una región propia en su mayoría. En contraste con otros experimentos, el grupo más chico es de 6 lenguas, así que el valor alto no sale de una partición desbalanceada. A diferencia de este caso, lo que vemos en los ejemplos en $X_"BPE"$ es más tenue, con grupos contiguos pero sin regiones tan definidas.

// grambank vs lang2vec: n39 y s38, ari de 0.7148
#figure(
  image("img/grambank-lang2vec-n39-s38.svg", width: 105%),
  caption: [El espacio de lang2vec, reducido a tres dimensiones mediante análisis de
    componentes principales, con los grupos de $X_G$ de la configuración de $d_G = 39$
    que alcanzó un ARI de $0.7148$. El color de cada lengua es su grupo en Grambank,
    no el del espacio donde está dibujada.]
)<ejemplo-espacios-clusters-grambank-lang2vec>

//Esa cercanía, sin embargo, admite más de una lectura. Grambank y lang2vec representan sus características en forma binaria, y parte del parecido podría venir de esa codificación compartida y no del contenido lingüístico que codifican. Con lo que medimos no podemos separar las dos explicaciones, porque haría falta comparar bases con el mismo contenido y distinta codificación.

// Pregunta 3: PENDIENTE. El experimento de Grambank vs lang2vec pasó a la pregunta 2,
// como calibración junto con Grambank vs WALS. Falta el análisis por característica que
// la pregunta 3 pide (qué características contribuyen más y qué tipo de información
// lingüística capturan las representaciones de subpalabras).

// TODO: Agregar ejemplo de Grambank con lang2vec


// TODO: Al final, decir por qué es relevante esto


== Limitaciones y trabajo futuro

// Candidatas a limitaciones
// - Dimensiones muy gandes? Quiza a discutir.

La primera limitación viene del número de lenguas. De las 47 lenguas del estudio, Grambank solo cubre 40, y de esas descartamos el coreano y el birmano, así que los experimentos con Grambank se hicieron con 38. Trabajar con menos lenguas puede que afecte la interpretación de los resultados de dos maneras. Los agrupamientos se forman con menos puntos, así que pequeños cambios en ellos pueden mover los valores de ARI. Además, esos resultados ya no se pueden comparar directamente con los de $X_"BPE"$ vs $X_W$, que sí usa las 47 lenguas para retomar la configuración de #cite(<ximena-bpe-2023>, form: "prose").

La misma diferencia de lenguas entre bases de datos también afecta a la base de referencia. Generamos $X_0$ con los rangos de $X_"BPE"$ sobre las lenguas de cada experimento, y no una sola vez para después quitarle los puntos que sobran. Por eso, aunque usemos la misma semilla, la referencia de 38 lenguas no es un recorte de la de 47, porque los rangos pueden cambiar y los valores se reparten en otro orden. Comparar $X_"BPE"$ contra $X_0$ dentro de un mismo experimento sigue siendo válido, pero no lo es comparar la referencia de un experimento con la de otro cuando parten de conjuntos de lenguas distintos.

La segunda limitación es que generamos la base de referencia con una sola semilla aleatoria. Los agrupamientos recorren 100 semillas y dan $10,000$ valores de ARI por configuración, pero el espacio $X_0$ contra el que los comparamos salió de un solo sorteo. Esto fue por el costo de cómputo: un experimento con WALS da $10,000$ valores de ARI, y uno con Grambank da 56 veces esa cantidad, uno por cada punto del barrido. Aunque bajamos el cálculo de unos 30 minutos a cerca de 2 por experimento, repetirlo con varias semillas y volverlo a repetir cada vez que cambiábamos algo de la metodología, no era viable en la computadora donde corrimos los experimentos. Por eso no descartamos que la referencia cambie con otra semilla.

// TODO: Agregar trabajo a futuro.

#pagebreak()