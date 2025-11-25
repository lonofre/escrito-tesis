== Datos/Corpus de entrenamiento multilingües

Para el análisis se usó bases de datos lingüísticas, que contienen información que podemos procesar para corroborar la hipótesis. La principal base de datos que usamos es Grambank @grambank. Esta base de datos contiene información de 2,467 lenguas y dialectos en el mundo, y registra un máximo de 195 características por lengua.

Otra base de datos que usamos para validar es World Atlas of Language Structures (WALS) @wals. Esta base de datos contiene información de las propiedades fonológicas, gramaticales y léxicas de las lenguas. WALS contiene información de 2,662 lenguas y dialectos y registra hasta 192 características por lengua.

// Citar con Grambank Wiki?
Hay que considerar que si bien Grambank y WALS pueden ser similares, no hay una relación uno a uno entre ellas. En primer lugar, Grambank está basada en diversos cuestionarios, entre ellos incluido WALS. Además, pudimos corroborar que hay lenguas, como el español, que están presentes en WALS pero no en Grambank.

// Citar con Grambank Wiki?
Sin embargo, de acuerdo a los autores de Grambank, esta base de datos está más enfocado al análisis computacional que WALS.

Estas dos bases de datos siguen el estándar de Cross-Linguistic Data Formats (CLDF) @cldf. El modelo de datos que este estándar ofrece es:
- Lenguas que son los objetos de investigación.
- Parámetros, que son los conceptos comparativos medidos y comparados entre lenguas. Para nuestro estudio, nos referiremos a estos como las características.
- Valores, que son las mediciones concretas de un parámetro sobre una lengua.
- Fuentes, ya que cada valor puede venir de diferentes fuentes.

Para nuestro fin, queremos obtener el valor de las características para cada lengua en cada una de estas bases de datos.