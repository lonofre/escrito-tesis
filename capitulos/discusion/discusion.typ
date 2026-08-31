= Discusión
// BORRADOR AUN SIN TERMINAR
// Referencias para escribir la discusión:
//  - https://pmc.ncbi.nlm.nih.gov/articles/PMC10676253/

El espacio que induce BPE ($X_"BPE"$) conserva algo de la organización tipológica de las lenguas, pero lo hace de manera intermitente. En los tres experimentos que comparan a $X_"BPE"$ con bases de datos lingüísticas, la coincidencia supera a la de la referencia aleatoria, y lo hace en todos los puntos del barrido de características, sobre las diez mil parejas de semillas que probamos en cada uno. Sin embargo, casi toda esa brecha vive en el extremo alto de la distribución, pues, salvo con $X_W$, la mediana apenas se despega de cero y son las mejores corridas las que separan a $X_"BPE"$ del azar. Estos valores altos de ARI no son un accidente, ya que los grupos que los producen ocupan regiones reconocibles en $X_"BPE"$ y no aparecen tan dispersos como en la referencia. Aun así, $X_G$ y $X_W$ coinciden más seguido entre sí que $X_"BPE"$ con cualquiera de las dos, por lo que la huella lingüística de BPE existe y es medible, pero es más delgada que la que comparten dos bases de datos construidas por lingüistas.

== La coincidencia sobrevive al cambio de base de datos

La coincidencia entre $X_"BPE"$ y $X_W$ que reportaron #cite(<ximena-bpe-2023>, form: "prose") se mantuvo cuando dejamos de depender de una sola configuración de agrupamiento y cuando medimos con otra métrica. Sobre las mismas 47 lenguas, un agrupamiento aleatorio no alcanza a reproducir la organización de $X_W$, mientras que $X_"BPE"$ llega cerca del triple, tanto en el percentil 99 como en el máximo. Incluso, esa separación tampoco se limita al extremo alto, ya que en este experimento los rangos intercuartiles ni siquiera se solapan, algo que no vuelve a ocurrir en los demás. Lo cual el hallazgo original no dependía entonces de la semilla ni de la métrica con la que se midió.

Tampoco esta coincidencia dependía del solo comparar con WALS. Con Grambank, la coincidencia vuelve a superar a su referencia, y lo hace en todos los puntos del barrido de características, no solo en pocas dimensiones. Además, el techo de Grambank es más alto que el de WALS, pero se obtuvo sobre menos lenguas y con más configuraciones, y por eso leemos cada experimento contra su propia referencia y no unos contra otros.

Por otro lado, combinar ambas bases en un solo espacio tampoco cambia el panorama. El percentil 99 de $X_(W+G)$ arranca donde arrancaba el de Grambank y el máximo real sube poco, de $0.493$ a $0.545$. Si la coincidencia creciera con la cantidad de información lingüística disponible, lo hubiéramos notado en este experimento. Esto sugiere que BPE parece estar contenido ya en cualquiera de las dos bases por separado. Lo que que hay que observar aquí son los picos locales de la primera mitad del barrido, donde aparecen valores que no alcanzan el techo, pero que se obtienen con la mitad de las características y con muchos menos valores imputados. Esto puede indicar que las características que más aportan a la coincidencia estarían entonces entre las de mejor cobertura.

== Grupos reconocibles en el agrupamiento

Queda por descartar que esos picos sean un accidente aritmético. Un ARI alto puede salir de un agrupamiento arbitrario que coincida por casualidad por el tamaño de los grupos, por ejemplo al medir particiones con grupos de uno o dos elementos, así que fuimos a ver los grupos que lo producen. Las figuras @ejemplo-espacios-clusters-wals-bpe, @ejemplo-espacios-clusters-grambank-bpe y @ejemplo-espacios-clusters-grambankANDwals-bpe muestran, para cada comparación, una configuración de ARI alto sobre $X_"BPE"$ junto a una configuración de ARI alto sobre $X_0$, de modo que el contraste es entre los mejores casos de cada espacio y no entre uno bueno y uno cualquiera.

En los tres pares ocurre lo mismo. Sobre $X_0$ los grupos de la base lingüística quedan dispersos y mezclados entre sí, mientras que sobre $X_"BPE"$ se ven más juntos y ocupan zonas reconocibles. No llegan a estar separados como lo estarían dos agrupamientos iguales, pero esa continuidad es justamente lo que mide el ARI.

// cluster 1 : 50 de wals, ari de 0.271739 en seed2 15
// cluster 2: 5 de wals, ari de 0.104387 en seed2 44
#figure(
  image("img/wals-bpe-comparison-s50-&-s5.svg", width: 105%),
  caption: [Los grupos de $X_W$ vistos sobre $X_"BPE"$ (izquierda, ARI de $0.2717$)
    y sobre la referencia $X_0$ (derecha, ARI de $0.1043$). El color de cada lengua
    es su grupo en la base de datos, no el del espacio donde está dibujada.]
)<ejemplo-espacios-clusters-wals-bpe>

// cluster 1 de Grambank (n36 y s44): ari de 0.3800 en seed2 77
// cluster 2 de Grambank (n84 y s88):, ari de 0.2433 en seed2 34
#figure(
  image("img/grambank-bpe-n36-s44-&-n84-s88.svg", width: 105%),
  caption: [Los grupos de $X_G$ vistos sobre $X_"BPE"$ (izquierda, $d_G = 36$, ARI
    de $0.3800$) y sobre la referencia $X_0$ (derecha, $d_G = 84$, ARI de $0.2433$).]
)<ejemplo-espacios-clusters-grambank-bpe>

// X_BPE: n38 y s51, ari de 0.4743
// X_0: n85 y s67, ari de 0.2049
#figure(
  image("img/grambank&wals-bpe-n38-s51-&-n85-s67.svg", width: 105%),
  caption: [Los grupos de $X_(W+G)$ vistos sobre $X_"BPE"$ (izquierda, $d_G = 38$,
    ARI de $0.4743$) y sobre la referencia $X_0$ (derecha, $d_G = 85$, ARI de
    $0.2049$).]
)<ejemplo-espacios-clusters-grambankANDwals-bpe>

== Mayor coincidencia entre bases lingüísticas que BPE

Para juzgar el alcance que tiene BPE hay que notar que $X_G$ y $X_W$ tampoco coinciden tanto entre sí. El tercer cuartil de $X_G$ vs $X_W$ está por encima del de cualquier comparación con $X_"BPE"$ en casi todo el barrido, salvo en los primeros cuatro puntos frente a $X_"BPE"$ vs $X_W$, o sea que WALS y Grambank se parecen de manera más constante. En el extremo alto, en cambio, se emparejan, porque las comparaciones con BPE llegan a ese techo alrededor de las 75 características, aunque recordemos que en este punto la imputación de valores ya es más fuerte que dentro de las primeras configuraciones del barrido. Esta coincidencia no tan alta puede sugerir al tipo de características que obtenemos de WALS con las de Grambank, que tiene características morfológicas, sintácticas y morfosintácticas.

Para contrastar, $X_G$ y $X_"l2v"$ resultaron el par de espacios más parecidos de todo el estudio, con un tercer cuartil por encima del de cualquier otro experimento y un techo que pasa de $0.7$. Ninguna comparación con $X_"BPE"$ se acerca a esa distribución, ni en el centro ni en el techo. Esto indica que las características que tiene Grambank tienen más en común con las características sintácticas del conjunto que usamos con lang2vec.

Sin embargo, esa cercanía puede leerse de otra manera. Grambank y lang2vec representan sus características en forma binaria, y parte del parecido podría venir de esa codificación compartida. Con lo que medimos no podemos separar las dos explicaciones, porque haría falta comparar bases con el mismo contenido y distinta codificación.

== Nuestra hipótesis se cumple en dos de sus tres condiciones

Planteamos la hipótesis pidiendo tres cosas: que la coincidencia estuviera por encima del azar, que se mantuviera al cambiar de base de datos y que se mantuviera al cambiar la inicialización del agrupamiento. Las dos primeras se cumplen. La coincidencia supera a la referencia aleatoria en los tres experimentos y en todos los puntos del barrido, y sobrevive al pasar de WALS a Grambank y al espacio combinado.

La tercera no se cumple como la escribimos. Usamos cien semillas por espacio precisamente para no depender de una, y lo que encontramos es que la coincidencia sí depende de ella, pues aparece en una minoría de las corridas y se mantiene débil en el resto. En este caso, la hipótesis no se sostiene. No obstante, la forma en que el espacio inducido de BPE organiza las lenguas parece sugiere que favorece la formación de esos grupos donde hay coincidencia.

Por ende, podemos afirmar que BPE codifica información que coincide parcialmente con las descripciones tipológicas, y que esa información es recuperable de su espacio aunque no lo organice. Lo que no podemos afirmar es que exista una correspondencia fuerte entre ambas descripciones.

== Limitaciones y trabajo futuro

// Candidatas a limitaciones
// - Dimensiones muy gandes? Quiza a discutir.

La primera limitación viene del número de lenguas. De las 47 lenguas del estudio, Grambank solo cubre 40, y de esas descartamos el coreano y el birmano, así que los experimentos con Grambank se hicieron con 38. Trabajar con menos lenguas puede que afecte la interpretación de los resultados de dos maneras. Los agrupamientos se forman con menos puntos, así que pequeños cambios en ellos pueden mover los valores de ARI. Además, esos resultados ya no se pueden comparar directamente con los de $X_"BPE"$ vs $X_W$, que sí usa las 47 lenguas para retomar la configuración de #cite(<ximena-bpe-2023>, form: "prose"). En @grambank-40-lenguas repetimos la comparación con las 40 lenguas para acotar el primer punto, y la separación respecto a la referencia se mantiene.

La misma diferencia de lenguas entre bases de datos también afecta a la base de referencia. Generamos $X_0$ con los rangos de $X_"BPE"$ sobre las lenguas de cada experimento, y no una sola vez para después quitarle los puntos que sobran. Por eso, aunque usemos la misma semilla, la referencia de 38 lenguas no es un recorte de la de 47, porque los rangos pueden cambiar y los valores se reparten en otro orden. Comparar $X_"BPE"$ contra $X_0$ dentro de un mismo experimento sigue siendo válido, pero no lo es comparar la referencia de un experimento con la de otro cuando parten de conjuntos de lenguas distintos.

La segunda limitación es que generamos la base de referencia con una sola semilla aleatoria. Los agrupamientos recorren 100 semillas y dan $10,000$ valores de ARI por configuración, pero el espacio $X_0$ contra el que los comparamos salió de un solo sorteo. Esto fue por el costo de cómputo: un experimento con WALS da $10,000$ valores de ARI, y uno con Grambank da 56 veces esa cantidad, uno por cada punto del barrido. Aunque bajamos el cálculo de unos 30 minutos a cerca de 2 por experimento, repetirlo con varias semillas y volverlo a repetir cada vez que cambiábamos algo de la metodología, no era viable en la computadora donde corrimos los experimentos. En @referencia-semillas repetimos la comparación con Grambank bajo cuatro sorteos más para acotar este punto. La referencia sí cambia, y su techo se duplica entre el sorteo más bajo y el más alto, pero los cinco se quedan por debajo de $X_"BPE"$. Cinco sorteos muestran la dirección, no la frecuencia con que ocurriría.

// TODO: Agregar trabajo a futuro.

#pagebreak()