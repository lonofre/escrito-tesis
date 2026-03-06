== Comparación
// El objetivo fue buscar una relación entre los diferentes espacios.

Uno de los enfoque que utilizamos para comparar ambos espacios fue Rand Index @rand.

$ "RI" = ("TP" + "TN")/("TP" + "TN" + "FP" + "FN") $

- a: número de pares de elementos que están en el mismo cluster en ambas particiones.
- b: número de pares de elementos que están en clusters diferentes en ambas particiones.
- c: número de pares que están en el mismo cluster en la primera partición pero en diferentes clusters en la segunda.
- d: número de pares que están en diferentes clusters en la primera partición pero en el mismo cluster en la segunda.

Pero no utilizamos sólo RI, sino utilizamos el _Adjusted Rand Index_ (ARI) @Hubert1985.

// Aquí Wikipedia da referencia a una tabla. Sería mejor revisar el paper original