= Discusión
// BORRADOR AUN SIN TERMINAR
// Referencias para escribir la discusión:
//  - https://pmc.ncbi.nlm.nih.gov/articles/PMC10676253/

El espacio que induce BPE ($X_"BPE"$) conserva algo de la organización tipológica de las lenguas, pero lo hace de manera intermitente. En los tres experimentos que comparan a $X_"BPE"$ con bases de datos lingüísticas, la coincidencia supera a la de la referencia aleatoria. No obstante, la mayoría de toda esa brecha vive en el extremo alto de la distribución, pues, salvo con $X_W$, la mediana apenas se despega de cero y son las mejores corridas las que separan a $X_"BPE"$ del azar. Notemos que estos valores altos de ARI no son un accidente, pues los grupos que los producen ocupan regiones reconocibles en $X_"BPE"$ y no aparecen tan dispersos como aparecen en la referencia. Aun así, $X_G$ y $X_W$ coinciden más seguido entre sí que $X_"BPE"$ con cualquiera de las dos, por lo que la huella lingüística de BPE existe y es medible, pero es más delgada que la que comparten dos bases de datos construidas por lingüistas.

== La coincidencia con BPE

La coincidencia entre $X_"BPE"$ y $X_W$ que reportaron #cite(<ximena-bpe-2023>, form: "prose") se mantuvo cuando dejamos de depender de una sola configuración de agrupamiento y cuando medimos con otra métrica, el ARI, que toma en consideración cómo están organizados los grupos. Notemos que los grupos en $X_0$ no mostraron un indicio a reproducir la organización de $X_W$, mientras que los grupos generados en $X_"BPE"$ obtuvieron resultados hasta el tripe respecto a esos valores de referencia. Esto es importante, porque nos da un indicio de una relación en como el espacio inducido por BPE organiza las lenguas respecto a un espacio definido por características morfológicas.

Además, esta coincidencia no solo está en una sola base de datos. Con Grambank, la coincidencia también superó a su referencia, y lo realizó en todos los puntos del barrido. Esto da más evidencia sobre la morfología que codifica $X_"BPE"$, pues Grambank codifica sus características de manera diferente a WALS y por su diseño Grambank expresa mejor las características de las lenguas. Incluso el techo de los resultados de ARI en Grambank es más alto que el de WALS, pero hay que hacer un pequeño paréntesis que se realizó con menos lenguas estos experimentos, y por ende no podemos comparar directamente sus referencias.

Por otro lado, combinar ambas bases en un solo espacio tampoco cambió el panorama de la concordancia. El percentil 99 de $X_(W+G)$ arranca donde arrancaba el de Grambank y el máximo real sube poco, de $0.493$ a $0.545$. Si la coincidencia creciera con la cantidad de información lingüística disponible, lo hubiéramos notado con este experimento. Esto sugiere que la información que codifica el espacio inducido por BPE parece estar contenido ya en cualquiera de las dos bases por separado. Lo que que hay que observar aquí son los picos locales de la primera mitad del barrido, que aunque no son los más altos se obtienen con la mitad de las características y por ende con menos valores vacíos. Esto pueden indicar que las características que más aportan a la coincidencia estarían entonces entre las de mejor cobertura.

Queda entonces descartar que esos picos no sean resultado de grupos muy grandes. Un ARI alto puede salir de un agrupamiento arbitrario que coincida por casualidad debido al tamaño de los grupos, por ejemplo al medir particiones con grupos de uno o dos elementos. Por lo tanto, fuimos a ver los grupos que lo producen en configuraciones en el techo de los resultados (no necesariamente el valor máximo). Las figuras @ejemplo-espacios-clusters-wals-bpe, @ejemplo-espacios-clusters-grambank-bpe y @ejemplo-espacios-clusters-grambankANDwals-bpe muestran, para cada comparación, una configuración de ARI alto sobre $X_"BPE"$ junto a una configuración de ARI alto sobre $X_0$, de modo que el contraste es entre los mejores casos de cada espacio y no entre uno bueno y uno cualquiera.

En los tres pares ocurre lo mismo: sobre $X_0$ los grupos de la base lingüística quedan dispersos y mezclados entre sí, mientras que sobre $X_"BPE"$ se ven más juntos y ocupan zonas reconocibles. Hay que reconocer que no llegan a estar separados como lo estarían dos agrupamientos iguales, si hay un contraste diferenciado con los de la referencia.

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

== El parecido entre las bases lingüísticas

Para juzgar el alcance que tiene BPE hay que notar que $X_G$ y $X_W$ tampoco coinciden tanto entre sí. El tercer cuartil de $X_G$ vs $X_W$ está por encima del de cualquier comparación con $X_"BPE"$ en casi todo el barrido, salvo en los primeros cuatro puntos frente a $X_"BPE"$ vs $X_W$, o sea que WALS y Grambank se parecen de manera más constante. En el extremo alto, en cambio, se emparejan, porque las comparaciones con BPE llegan a ese techo alrededor de las 75 características, aunque recordemos que en este punto la imputación de valores ya es más fuerte que dentro de las primeras configuraciones del barrido. Esta coincidencia no tan alta puede sugerir al tipo de características que obtenemos de WALS con las de Grambank, que tiene características morfológicas, sintácticas y morfosintácticas; a la vez de la diferencia de cómo codifican las características Grambank y WALS.

Para contrastar estos resultados, $X_G$ y $X_"l2v"$ resultaron el par de espacios más parecidos de todo el estudio, con un tercer cuartil por encima del de cualquier otro experimento y un techo que pasa de $0.7$. Ninguna comparación con $X_"BPE"$ se acerca a esa distribución. Esto indica que las características que tiene Grambank tienen más en común con las características sintácticas del conjunto que usamos con lang2vec.

Sin embargo, esa cercanía puede leerse de otra manera, al igual que con WALS. Grambank y lang2vec representan sus características en forma binaria, y parte del parecido podría venir de esa codificación compartida. Por otra parte, esta binariedad hace más expresivas a estas dos bases de datos (pues como vimos, WALS deja de lado algunos ragos por codificar la más predominante).

== La influencia de las características


/*
== Nuestra hipótesis se cumple en dos de sus tres condiciones

Planteamos la hipótesis pidiendo tres cosas: que la coincidencia estuviera por encima del azar, que se mantuviera al cambiar de base de datos y que se mantuviera al cambiar la inicialización del agrupamiento. Las dos primeras se cumplen. La coincidencia supera a la referencia aleatoria en los tres experimentos y en todos los puntos del barrido, y sobrevive al pasar de WALS a Grambank y al espacio combinado.

La tercera no se cumple como la escribimos. Usamos cien semillas por espacio precisamente para no depender de una, y lo que encontramos es que la coincidencia sí depende de ella, pues aparece en una minoría de las corridas y se mantiene débil en el resto. En este caso, la hipótesis no se sostiene. No obstante, la forma en que el espacio inducido por BPE organiza las lenguas parece sugiere que favorece la formación de esos grupos donde hay coincidencia.

Por ende, los resultados muestran evidencia que el espacio inducido por BPE codifica información que coincide parcialmente con las descripciones tipológicas. Lo que no podemos afirmar es que exista una correspondencia fuerte entre ambas descripciones.
*/
== Limitaciones y trabajo futuro

La primera limitación viene del número de lenguas. De las 47 lenguas del estudio, Grambank solo cubre 40, y de esas descartamos el coreano y el birmano, así que los experimentos con Grambank se hicieron con 38. Trabajar con menos lenguas puede que afecte la interpretación de los resultados de dos maneras. Los agrupamientos se forman con menos puntos, así que pequeños cambios en ellos pueden mover los valores de ARI. Además, esos resultados ya no se pueden comparar directamente con los de $X_"BPE"$ vs $X_W$, que sí usa las 47 lenguas para retomar la configuración de #cite(<ximena-bpe-2023>, form: "prose"). En @grambank-40-lenguas repetimos la comparación con las 40 lenguas para acotar el primer punto, y la separación respecto a la referencia se mantiene. Sugerimos poder realizar esa comparación con aproximaciones de las características de las lenguas faltantes en Grambank, o en su dado caso, esperar a que Grambank vaya dando soporte a estas lenguas en otras versiones.

Asimismo, la misma diferencia de lenguas entre bases de datos también afecta a la base de referencia. Generamos $X_0$ con los rangos de $X_"BPE"$ sobre las lenguas de cada experimento, y no una sola vez para después quitarle los puntos que sobran. Por eso, aunque usemos la misma semilla, la referencia de 38 lenguas no es un recorte de la de 47, porque los rangos pueden cambiar y los valores se reparten en otro orden. Comparar $X_"BPE"$ contra $X_0$ dentro de un mismo experimento sigue siendo válido, pero no lo es comparar la referencia de un experimento con la de otro cuando parten de conjuntos de lenguas distintos.

La segunda limitación es que generamos la base de referencia con una sola semilla aleatoria. Los agrupamientos recorren 100 semillas y dan $10,000$ valores de ARI por configuración, pero el espacio $X_0$ contra el que los comparamos salió de un solo sorteo. Esto fue en medida por el costo de cómputo: un experimento con WALS da $10,000$ valores de ARI, y uno con Grambank da 56 veces esa cantidad, uno por cada punto del barrido. Aunque bajamos el cálculo de unos 30 minutos a cerca de 2 por experimento, repetirlo con varias semillas y volverlo a repetir cada vez que cambiábamos algo de la metodología, no fue viable en los recursos donde corrimos los experimentos. En @referencia-semillas repetimos la comparación con Grambank bajo cuatro sorteos más para acotar este punto. 


#pagebreak()