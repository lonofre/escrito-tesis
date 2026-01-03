== Datos/Corpus de entrenamiento multilingües

Usamos la misma metodología que #cite(<ximena-bpe-2023>, form: "prose") para obtener los correspondientes vectores de BPE, aunque hicimos unas ligeras modificaciones debido al sistema y las versiones de las bibliotecas usados. Su enfoque lo podemos encontrar en el repositorio BPEProductivity en GitHub.

El procesamiento se basa en 5 etapas: tokenización a nivel palabra, segmentación del corpus, obtención de las medidas y preparación del archivo TSV.

En primer lugar, necesitamos tokenizar el corpus a nivel palabra porque BPE necesita obtener en primera instancia las frecuencias de cada palabra. Esto lo hacemos gracias a `polyglot`.

Una vez tokenizado el corpus en el idioma seleccionado, lo que sigue es hacer un preprocesamiento de estas para que BPE los pueda procesar. Esto incluyó convertir los caracteres en minúsculas. Probablemente en algunos idiomas haya problema con esto (como lo maneja Microsoft), pero no consideramos esto por el momento. Otro de las cosas que hicimos fue remover signos de puntuación (puntos, comas, signos de exclamación e interrogación), porque sólo nos interesaban los caracteres que forman las palabras.

// Citar otra vez a Ximena
Una vez preparado todo esto, sigue correr un programa que implementa el algoritmo de BPE para generar nuestro modelo BPE. En nuestro caso, fue `subword-nmt` a 200 merges. Ximena en un paper explicó que a este punto se codifico cierta información, entonces es un buen punto de partida.

Con el modelo de BPE, podemos calcular las medidas. Primero debemos que usar el archivo del corpus preprocesado (no el original) para aplicarle nuestro modelo BPE con `subword-nmt`. Una vez esto, podemos calcular las medidas de productividad, idiosincrasia y el otro.

Finalmente guardamos los valores en un archivo. Preferimos usar archivos csv en vez de tsv porque es más simple.