= Conclusiones
/*
- Breve resumen de lo que se propuso
- Hallazgos o lecciones aprendidas
- Tu recomendación/visión como experto 

(trabajo futuro)

En esto en el futuro abrir paso para...métodos más eficientes, adaptados a la tipología, estudios d eling..


 Puede haber una subsección de limitaciones donde te adelantas a los problemas, lso reconcoes, y das alguna posible solución en el futuro 
 */

Los modelos de lenguaje actuales no reciben reglas gramaticales y, aun así, su desempeño cambia según la lengua que procesan. Esta tesis buscó ese rastro lingüístico en el tokenizador, en particular en BPE, un algoritmo de compresión cuya única operación es contar y fusionar los pares de símbolos más frecuentes. Comparamos el espacio inducido por BPE con las características de las bases lingüísticas WALS y Grambank, a partir de los grupos formados en cada espacio, con una métrica que descuenta el acierto por azar y contra un espacio de referencia generado al azar.

Nuestros resultados indican que existe una relación perceptible entre ambos espacios, y que dicha relación no se debe al azar. Incluso logramos corroborar visualmente una correspondencia parcial al sobreponer los grupos de un espacio sobre el otro. Esa relación, sin embargo, no aparece en todas las corridas, pues está influenciada por la inicialización de los agrupamientos.

La coincidencia tampoco depende de una sola fuente de información lingüística, ya que se mantuvo al pasar de WALS a Grambank. Descubrimos, eso sí, que la relación entre las bases lingüísticas es mayor que la de cualquiera de ellas con el espacio de BPE. Es más, el conjunto de características de Grambank que utilizamos tiene mayor relación con un conjunto de características sintéticas que con las obtenidas de las subpalabras de BPE.

Asimismo, tomamos como referencia la base de datos más reciente, Grambank, y consideramos sus primeras 39 características para compararlas con el espacio de BPE. Entre las características con mayor peso en la formación de estos grupos, parte de las primeras son de carácter morfológico, con enfoque en la productividad lingüística. Las medidas con las que se construye el espacio de BPE se inspiran precisamente en la morfología, así que la coincidencia aparece donde cabría esperarla.

Esto refuerza que BPE, un algoritmo de compresión y sin conocimiento lingüístico, puede capturar en cierta medida algunas características morfológicas de las lenguas. De esta manera, el análisis de las subpalabras que produce BPE puede servir como una fuente de evidencia sobre la morfología de las lenguas, obtenida sin anotación lingüística previa. Del otro lado, sugiere que los modelos de lenguaje actuales se pueden beneficiar de la información que BPE ya comprime en sus subpalabras.

#pagebreak()