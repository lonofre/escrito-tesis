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

Candidatas a limitaciones
- Baja disponibilidad de lenguas en Grambank respecto a WALS.
- Al usar menos lenguas en Grambank, también queda un poco diferente el baseline
- Agregar que solo se probó con una semilla aleatoria para el baseline. La limitante es el poder de computo, pues cada espacio se agrega, añade muchos valores que computar y analizar.
- Dimensiones muy gandes? Quiza a discutir.

#pagebreak()