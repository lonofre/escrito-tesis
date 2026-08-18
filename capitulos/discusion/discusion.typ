= Discusión
// BORRADOR AUN SIN TERMINAR

// Pregunta 1
Vimos que usando otra métrica para encontrar similitud entre el espacio inducido por BPE y el de WALS, encontramos una coincidencia mayor respecto a la base de referencia. La mayoría de los valores ARI del experimentos de $X_"BPE"$ vs $X_W$ son mayores que con los que usan $X_0$, lo cual da un fuerte argumento sobre nuestra hipótesis de que BPE tiene una relación con las características morfológicas de WALS.

Siendo más precisos, los resultados con la base de referencia son demasiados nulos. Esto podemos observar al tener los 99% de resultados bajo $0.07$ y el máximo valor obtenido en un $.104$, que implica que no hay poca relación entre los grupos, lo que implica que lenguas cercanas entre este espacio $X_0$ no son de igual manera con las de $X_W$.

No obstante, como obtenemos valores altos con los experimentos con $X_"BPE"$ tenemos que verificar la calidad de los grupos formados para obtener estos resultados altos de ARI. Nos queremos enforcar en las configuraciones que obtuvieron un valor alto de ARI. La @ejemplo-espacios-clusters-wals-bpe muestra un ejemplo con configuraciones donde se obtuvieron valores altos de ARI en sus respectivos experimentos, poniendo los grupos obtenidos en WALS sobre cada espacio. En uno, obtuvimos un ARI de $0.2717$ y en otro $0.1043$ (no estamos los grupos obtenidos en cada espacio), no son los mismos grupos de WALS en ambos casos, son diferentes configuraciones.

// cluster 1 : 50 de wals, ari de 0.2717 en seed2 15
// cluster 2: 5 de wals, ari de 0.1043 en seed2 44
#figure(
  image("img/wals-bpe-comparison-s50-&-s5.svg", width: 105%),
  caption: [A la izquierda, $X_"BPE"$, a la derecha, $X_0$]
)<ejemplo-espacios-clusters-wals-bpe>

Observamos que los grupos de WALS en $X_0$ están muy dispersos o mezclados entre si. En cambio, en $X_"BPE"$, visualmente se aprecia a los grupos más juntos, aunque si hay que considerar no están separados como esperamos, aunque eso hay que considerar cuando tenemos un ARI de alrededor de $0.2717$.

// Pregunta 2

También verificamos esta coincidencia con otra base de datos más actual que es Grambank. Encontramos una similitud más fuerte basándonos sólo en los resultados de ARI que con BPE y WALS. Esto puede sugerir que las características de Grambank tienen mayor relación con la caracterización de BPE.

// cluster 1 de Grambank (n36 y s44): ari de 0.3800 en seed2 77
// cluster 2 de Grambank (n84 y s88):, ari de 0.2433 en seed2 34
#figure(
  image("img/grambank-bpe-n36-s44-&-n84-s88.svg", width: 105%),
  caption: [hello there]
)


- Grambank tiene más similitud con lang2vec que con las otras, al menos con las características sintácticas
- Encontramos algunos valores con ARI alto en Grambank + WALS, pero en general no obtenemos resultados grambank (graficar aqui como dice Ximena)
- Grambank y WALS se parecen de la misma manera que Grambank y BPE (al menos se encuentran valores más altos), pero es más consistente
- Obtenemos valores altos con Grambank al final, pero posiblemente es por el peso que tienen los valores vacíos debido a la imputación


== Limitaciones y trabajo futuro

// Candidatas a limitaciones
// - Dimensiones muy gandes? Quiza a discutir.

La primera limitación viene del número de lenguas. De las 47 lenguas del estudio, Grambank sólo cubre 40, y de esas descartamos el coreano y el birmano, así que los experimentos con Grambank se hicieron con 38. Trabajar con menos lenguas puede que afecte la interpretación de los resultados de dos maneras. Los agrupamientos se forman con menos puntos, lo cual pequeños cambios en estos pueden impactar a los valores de ARI. Además, esos resultados ya no se pueden comparar directamente con los de $X_"BPE"$ vs $X_W$, que sí usa las 47 lenguas para retomar la configuración de #cite(<ximena-bpe-2023>, form: "prose").

La misma diferencia de lenguas entre base de datos también afecta a la base de referencia. Generamos $X_0$ con los rangos de $X_"BPE"$ sobre las lenguas de cada experimento, y no una sola vez para después quitarle los puntos que sobran. Por eso, aunque usemos la misma semilla, la referencia de 38 lenguas no es un recorte de la de 47, porque los rangos pueden cambiar y los valores se reparten en otro orden. Comparar $X_"BPE"$ contra $X_0$ dentro de un mismo experimento sigue siendo válido, pero no lo es comparar la referencia de un experimento con la de otro cuando parten de conjuntos de lenguas distintos.

La segunda limitación es que generamos la base de referencia con una sola semilla aleatoria. Los agrupamientos recorren 100 semillas y dan $10,000$ valores de ARI por configuración, pero el espacio $X_0$ contra el que los comparamos salió de un solo sorteo. Esto fue por el costo de cómputo: un experimento con WALS da $10,000$ valores de ARI, y uno con Grambank da 56 veces esa cantidad, uno por cada punto del barrido. Aunque bajamos el cálculo de unos 30 minutos a cerca de 2 por experimento, repetirlo con varias semillas, y volverlo a repetir cada vez que cambiábamos algo de la metodología, no era viable en la computadora donde corrimos los experimentos. Por eso no descartamos que la referencia cambie con otra semilla.

// TODO: Agregar trabajo a futuro.

#pagebreak()