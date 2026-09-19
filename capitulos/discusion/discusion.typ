= Discusión

== La coincidencia con BPE

La coincidencia entre $X_"BPE"$ y $X_W$ que reportaron #cite(<ximena-bpe-2023>, form: "prose") se mantuvo cuando dejamos de depender de una sola configuración de agrupamiento y cuando medimos con otra métrica, el ARI. Notemos que los grupos en $X_0$ no mostraron indicios de reproducir la organización de $X_W$, mientras que los grupos generados en $X_"BPE"$ obtuvieron resultados hasta el triple de esos valores de referencia. Esto es importante, porque nos da un indicio de una relación sobre cómo el espacio inducido por BPE organiza las lenguas respecto a un espacio definido por características morfológicas.

Además, esta coincidencia no solo está en una sola base de datos. Con Grambank, la coincidencia también superó a su referencia, y lo hizo en todos los puntos del barrido de características. Esto da más evidencia sobre la morfología que codifica $X_"BPE"$, pues Grambank codifica sus características de manera diferente a WALS. Incluso el techo de los resultados de ARI en Grambank es más alto que el de WALS, pero hay que hacer énfasis en un pequeño paréntesis: que estos experimentos se realizaron con menos lenguas, lo cual afecta la comparabilidad de los resultados.

Por otro lado, combinar ambas bases en un solo espacio tampoco cambió el panorama de la concordancia. El percentil 99 de $X_(W+G)$ arranca donde arrancaba el de Grambank y el máximo real sube poco, de $0.493$ a $0.545$. Si la coincidencia creciera con la cantidad de información lingüística disponible, lo hubiéramos notado con este experimento. Esto sugiere que la información que codifica el espacio inducido por BPE parece estar contenida ya en cualquiera de las dos bases por separado. Lo que hay que observar aquí son los picos locales de la primera mitad del barrido, que aunque no son los más altos se obtienen con la mitad de las características y por ende con menos valores vacíos. Esto puede indicar que las características que más aportan a la coincidencia estarían entonces entre las de mejor cobertura.

Queda entonces descartar que esos picos sean resultado de grupos muy grandes. Un ARI alto puede salir de un agrupamiento arbitrario que coincida por casualidad debido al tamaño de los grupos, por ejemplo al medir particiones con grupos de uno o dos elementos. Por lo tanto, analizamos las agrupaciones que lo producen en configuraciones del techo de los resultados (no necesariamente el valor máximo). Las figuras @ejemplo-espacios-clusters-wals-bpe, @ejemplo-espacios-clusters-grambank-bpe y @ejemplo-espacios-clusters-grambankANDwals-bpe muestran, para cada comparación, una configuración de ARI alto sobre $X_"BPE"$ junto a una configuración de ARI alto sobre $X_0$, de modo que el contraste es entre los mejores casos de cada espacio y no entre uno bueno y uno cualquiera.

En los tres pares ocurre lo mismo: sobre $X_0$ los grupos de la base lingüística quedan dispersos y mezclados entre sí, mientras que sobre $X_"BPE"$ se ven más juntos y ocupan zonas reconocibles. Hay que reconocer que no llegan a estar separados como lo estarían dos agrupamientos iguales; pero sí hay un contraste diferenciado con los de la referencia.

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

En las tres figuras podemos observar que las lenguas que tienden a agruparse en las bases de datos lingüísticas también tienden a formar regiones cercanas en el espacio de BPE. Por ejemplo, el finlandés (fin) y el turco (tur) tienden a agruparse cuando usamos las representaciones obtenidas de las diferentes bases de datos, pero también aparecen en el mismo grupo cuando utilizamos los vectores de BPE. Si esto no fuera así, observaríamos puntos del mismo color en regiones no contiguas y dispersas por todo el espacio, como ocurre en las visualizaciones del espacio aleatorio (línea base $X_0$).

En síntesis, la mayor parte de la brecha frente a la referencia vive en el extremo alto de la distribución, pues, salvo con $X_W$, la mediana apenas se despega de cero y son las mejores corridas las que separan a $X_"BPE"$ del azar.

== El parecido entre las bases lingüísticas

Para juzgar el alcance que tiene BPE hay que notar que $X_G$ y $X_W$ tampoco coinciden tanto entre sí. El tercer cuartil de $X_G$ vs $X_W$ está por encima del de cualquier comparación con $X_"BPE"$ en casi todo el barrido, salvo en los primeros cuatro puntos frente a $X_"BPE"$ vs $X_W$, o sea que WALS y Grambank se parecen de manera más constante. En el extremo alto, en cambio, se emparejan, porque las comparaciones con BPE llegan a ese techo alrededor de las 75 características, aunque recordemos que en este punto la imputación de valores ya es más fuerte que dentro de las primeras configuraciones del barrido. Esta coincidencia no tan alta puede deberse al tipo de características que aporta cada base: las 15 que tomamos de WALS son de tipología morfológica, mientras que las que seleccionamos de Grambank se reparten entre morfológicas, sintácticas y morfosintácticas, sin concentrarse en una sola categoría. A esta diferencia se suma la de cómo codifica cada base sus características.

Aunque Grambank codifica características tipológicas variadas (de origen morfológico, sintáctico y morfosintáctico), la comparación que hicimos entre esta base y lang2vec (una base meramente sintáctica) sugiere que Grambank tiene una tendencia a codificar información más cercana a la sintaxis. Por esta razón, no se podría esperar una coincidencia absoluta con BPE, que parte de representaciones y unidades de subpalabra relacionadas con la estructura interna de la palabra (morfología), y no con su interacción con otras palabras (sintaxis).

Sin embargo, esa cercanía puede leerse de otra manera, al igual que con WALS. Grambank y lang2vec representan sus características en forma binaria, y parte del parecido podría venir de esa codificación compartida. Por otra parte, esta binariedad hace más expresivas a estas dos bases de datos (pues como vimos, WALS deja de lado algunos rasgos por codificar el más predominante).

== La influencia de las características

El experimento de calcular el ARI promedio para cada característica por separado nos permitió tener una visión más detallada de qué tipo de características de Grambank parecen estar jugando un papel relevante para que el agrupamiento sea similar al obtenido con BPE. Resulta interesante observar en la @tabla-ari-grambank (de la @seccion-resultados-analisis-caracteristicas) que parece haber una predominancia de características relacionadas con la morfología en los primeros lugares de la clasificación por ARI promedio, mientras que las características tipológicas más relacionadas con la sintaxis y la morfosintaxis ocupan lugares menos prominentes en la clasificación.

Si bien esto no constituye un _continuum_ perfecto, en el que las características morfológicas aparecen primero, seguidas de las morfosintácticas y finalmente de las sintácticas, sí parece haber evidencia de que las características de Grambank que hacen que el agrupamiento sea más parecido al obtenido con BPE muestran una tendencia hacia fenómenos morfológicos. Lo anterior tiene sentido, pues esperaríamos que los agrupamientos obtenidos con BPE tengan mayor coincidencia con aquellos obtenidos a partir de características meramente morfológicas de Grambank. Recordemos que el algoritmo BPE no cruza el nivel de la palabra ortográfica, por lo que no captura directamente fenómenos sintácticos, sino patrones de símbolos adyacentes dentro de la palabra, relacionados con la estructura interna de esta, es decir, con fenómenos morfológicos.  

#let footnote_gb048 = footnote[GB048 sin traducir es: "Is there a productive morphological pattern for deriving an agent noun from a verb?"]

Aún más interesante resulta observar que, entre las características morfológicas mejor posicionadas, varias se relacionan con procesos productivos, es decir, patrones utilizados para codificar información gramatical, como el plural, así como otros procesos flexivos y derivativos. Por ejemplo, la característica GB048#footnote_gb048: "¿Existe un patrón morfológico productivo para derivar un sustantivo agente a partir de un verbo?"", pregunta si una lengua utiliza un patrón morfológico productivo mediante un morfema o afijo que pueda aplicarse a verbos para crear sustantivos agentivos. En náhuatl, por ejemplo, el verbo _tlahtoa_ ('hablar') puede formar _tlahtoa-ni_ ('el que habla') mediante el morfema agentivo _-ni_. Desde la perspectiva de BPE, _-ni_ puede aparecer como una subunidad recurrente al final de distintos sustantivos agentivos. Por lo tanto, un patrón morfológico productivo de este tipo puede generar regularidades formales (que se observan en la forma de las palabras) que un tokenizador BPE tiene la posibilidad de capturar a través de sus subpalabras.

Si bien existen fenómenos morfológicos de diversa naturaleza, los resultados sugieren que la representación de las lenguas obtenida a partir de BPE presenta una mayor compatibilidad con características morfológicas relacionadas con la productividad. Esto puede deberse al tipo de métricas que aplicamos a las subpalabras de BPE (productividad, frecuencia acumulada e idiosincrasia). En particular, la medida de productividad captura regularidades o patrones recurrentes, pues cuantifica cuántas palabras del corpus contienen una determinada subpalabra y, por tanto, qué tan frecuentemente esta se combina o aparece como parte de distintas palabras. Desde un punto de vista lingüístico, cuando una regla morfológica es productiva genera estas regularidades de manera sistemática en distintas palabras; por eso es posible que dichos patrones sean aprendidos y representados por BPE en sus subpalabras.

A medida que avanzamos en la clasificación, las características se desplazan progresivamente de los procesos productivos de formación de palabras hacia los procesos morfosintácticos y de organización sintáctica, que parecen ser distantes de lo que codifica BPE.

#pagebreak()