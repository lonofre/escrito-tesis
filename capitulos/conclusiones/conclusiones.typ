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

Nuestros resultados indican que existe una relación perceptible entre ambos espacios, y que dicha relación no se debe al azar. Incluso logramos corroborar visualmente una correspondencia parcial al sobreponer los grupos de un espacio sobre el otro. Para no depender de una sola inicialización, agrupamos cada espacio con cien semillas distintas y las comparamos todas contra todas, lo que nos dio diez mil mediciones por experimento. Ese barrido mostró que la coincidencia no aparece en todas las corridas, sino en la parte alta de la distribución.

La coincidencia tampoco depende de una sola fuente de información lingüística, ya que se mantuvo al pasar de WALS a Grambank. Al comparar Grambank con las características morfológicas de WALS y con las sintácticas de lang2vec, encontramos que se parece más a estas últimas. Aunque Grambank recoge fenómenos morfológicos, sintácticos y morfosintácticos, lo que codifica en conjunto parece inclinarse hacia la sintaxis, el nivel al que BPE no llega porque nunca cruza la frontera de la palabra.

Hasta donde sabemos, este es uno de los primeros trabajos en comparar las características codificadas en Grambank con representaciones obtenidas a partir de BPE. Al analizar más a fondo las características de Grambank y su relación con las representaciones basadas en BPE, observamos que las características de Grambank que parecen tener más peso (primeros lugares del ranking) para formar clusters que coincidan con BPE son de carácter morfológico, con enfoque en la productividad lingüística. Las medidas con las que se construye el espacio de BPE se inspiran precisamente en la morfología, así que la coincidencia aparece donde cabría esperarla.


/*Asimismo, tomamos como referencia la base de datos más reciente, Grambank, y consideramos sus primeras 39 características para compararlas con el espacio de BPE. Entre las características con mayor peso en la formación de estos grupos, parte de las primeras son de carácter morfológico, con enfoque en la productividad lingüística. Las medidas con las que se construye el espacio de BPE se inspiran precisamente en la morfología, así que la coincidencia aparece donde cabría esperarla.*/

Esto refuerza que BPE, un algoritmo de compresión y sin conocimiento lingüístico, puede capturar en cierta medida algunas características morfológicas de las lenguas. De esta manera, el análisis de las subpalabras que produce BPE puede servir como una fuente de evidencia sobre la morfología de las lenguas, obtenida sin anotación lingüística previa. Del otro lado, sugiere que los modelos de lenguaje actuales se pueden beneficiar de la información que BPE ya comprime en sus subpalabras.


Si bien encontramos evidencia de similitud, es importante destacar que cada base de datos, así como BPE, parece estar caracterizando información que no es exactamente la misma, por lo que los espacios resultantes no son equivalentes. En este sentido, nos pareció más adecuado recurrir a medidas que permitan comparar los agrupamientos, en lugar de centrarnos en qué tan similares son la topología o la geometría de los dos espacios. En particular, aunque BPE no parece codificar exactamente todas las características morfológicas representadas en las bases de datos, sí muestra una tendencia a codificar distintos tipos de información morfológica, especialmente aquella relacionada con lo que los lingüistas han descrito como productividad.


== Limitaciones y trabajo futuro

La primera limitación viene del número de lenguas. De las 47 lenguas del estudio, Grambank solo cubre 40, y de esas descartamos el coreano y el birmano, así que los experimentos con Grambank se hicieron con 38. Trabajar con menos lenguas puede que afecte la interpretación de los resultados de dos maneras. Los agrupamientos se forman con menos puntos, así que pequeños cambios en ellos pueden mover los valores de ARI. Además, esos resultados ya no se pueden comparar directamente con los de $X_"BPE"$ vs $X_W$, que sí usa las 47 lenguas para retomar la configuración de #cite(<ximena-bpe-2023>, form: "prose"). En @grambank-40-lenguas repetimos la comparación con las 40 lenguas para acotar el primer punto, y la separación respecto a la referencia se mantiene. Sugerimos poder realizar esa comparación con aproximaciones de las características de las lenguas faltantes en Grambank, o en su dado caso, esperar a que Grambank vaya dando soporte a estas lenguas en otras versiones.

Asimismo, la misma diferencia de lenguas entre bases de datos también afecta a la base de referencia. Generamos $X_0$ con los rangos de $X_"BPE"$ sobre las lenguas de cada experimento, y no una sola vez para después quitarle los puntos que sobran. Por eso, aunque usemos la misma semilla, la referencia de 38 lenguas no es un recorte de la de 47, porque los rangos pueden cambiar y los valores se reparten en otro orden. Comparar $X_"BPE"$ contra $X_0$ dentro de un mismo experimento sigue siendo válido, pero no lo es comparar la referencia de un experimento con la de otro cuando parten de conjuntos de lenguas distintos.

La segunda limitación es que generamos la base de referencia con una sola semilla aleatoria. Los agrupamientos recorren 100 semillas y dan $10,000$ valores de ARI por configuración, pero el espacio $X_0$ contra el que los comparamos salió de un solo sorteo. Esto fue en medida por el costo de cómputo: un experimento con WALS da $10,000$ valores de ARI, y uno con Grambank da 56 veces esa cantidad, uno por cada punto del barrido. Aunque bajamos el cálculo de unos 30 minutos a cerca de 2 por experimento, repetirlo con varias semillas y volverlo a repetir cada vez que cambiábamos algo de la metodología, no fue viable en los recursos donde corrimos los experimentos. En @referencia-semillas repetimos la comparación con Grambank bajo cuatro sorteos más para acotar este punto. 



Posibilidades a futuro a desarrollar:

- Si hay evidencia de que métodos no supervisados son capaces de inducir conocimiento morfológico a través de la estructura del texto, puede ser una forma para enriquecer las bases de datos lingüísticas, sin necesidad de anotación y conocimiento de experto para muchas lenguas, solo se necesita corpus y un algoritmo de compresión.

- Nuestro trabajo construye en la evidencia de que aunque hoy en día los modelos de nlp, LLs, etc. no necesitan de algún conocimiento lingüístico explícito, eso no quiere decir que no descansen sobre propiedades estructurales de la lengua y que induzcan representaciones que no son tan lejanas a las características tipológicas que los lingüistas han caracterizado.
- Probar con otros métodos de tokenizaicón populares usados en los LLMs hoy en día, etc. 

#pagebreak()