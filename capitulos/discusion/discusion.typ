= Discusión


// Pregunta 1
Vimos que usando otra métrica para encontrar similitud entre el espacio inducido por BPE y el de WALS, encontramos una coincidencia mayor respecto a la base de referencia. La mayoría de los valores ARI del experimentos de $X_"BPE"$ vs $X_W$ son mayores que con los que usan $X_0$, lo cual sugiere que la hipótesis de que BPE tiene una relación con estas características morfológicas. No obstante, tenemos que verificar la calidad de los grupos formados para obtener estos resultados altos de ARI.

// cluster 1 : 50 de wals, ari de 0.2717 en seed2 15
// cluster 2: 5 de wals, ari de 0.1043 en seed2 44
#figure(
  image("img/wals-bpe-comparison-s50-&-s5.svg", width: 105%),
  caption: [hello there]
)

 
- Encontramos que se mantiene esta coincidencia en WALS - BPE
- Encontramos valores altos donde se mantiene esto (graficamos)
- Encontramos valores medinamente altos, aunque consideramos que tampoco son tan altos, pero estan por encima de la base

// Pregunta 2
La coincidencia se apoyaba además en una sola base de datos. Las quince características de WALS no son una selección cualquiera, pues se eligieron por ser morfológicas, y un resultado que depende de quince columnas escogidas a mano puede hablar más de esa elección que de BPE. Grambank permite repetir la prueba con otra cobertura gramatical. Como no trae un conjunto fijo de características, además obliga a decidir cuántas usar, y esa decisión convierte la pregunta por la base de datos en otra más exigente: si la coincidencia sobrevive a cambiar cuántas características describen a cada lengua.

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
- Agregar que solo se probó con una semilla aleatoria para el baseline.
- Dimensiones muy gandes? Quiza a discutir


#pagebreak()