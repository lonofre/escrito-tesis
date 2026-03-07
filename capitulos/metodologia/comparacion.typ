== Comparación
// El objetivo fue buscar una relación entre los diferentes espacios.

Uno de los enfoque que utilizamos para comparar ambos espacios fue Rand Index (RI) @rand. Este índice mide la similitud entre dos grupos de datos. La idea de utilizar este método es crear una relación entre los clusters formados entre un espacio y los clusters formados en otro.

El RI se define de la siguiente manera:

$ "RI" = ("TP" + "TN")/("TP" + "TN" + "FP" + "FN") $

- a: número de pares de elementos que están en el mismo cluster en ambas particiones.
- b: número de pares de elementos que están en clusters diferentes en ambas particiones.
- c: número de pares que están en el mismo cluster en la primera partición pero en diferentes clusters en la segunda.
- d: número de pares que están en diferentes clusters en la primera partición pero en el mismo cluster en la segunda.

Pero no utilizamos sólo RI, sino utilizamos el _Adjusted Rand Index_ (ARI) @Hubert1985.

// Aquí Wikipedia da referencia a una tabla. Sería mejor revisar el paper original

// Buscar quién público k-means
Para generar los clusters usamos K-medias (K-means). Este es un algoritmo de agrupamiento que agrupa datos en k grupos, asignando cada punto al centroide más cercano e iterando hasta que los grupos se estabilicen.

// Aquí quizá abordar más el setup de scikit learn
Usamos una configuración especial en K-means.

// Y aquí hablar más de la configuración de estas pruebas con las semillas
Además, hicimos la exploración sobre una permutación de semillas para obtener mejores resultados y no depender de una sola configuración.

