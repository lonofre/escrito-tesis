/* Explicación sobre el ARI
*/

== Similitud entre espacios

Para extender ese contraste conviene entender cómo #cite(<ximena-bpe-2023>, form: "prose") relacionaron dos espacios que contienen las mismas lenguas pero las organizan con criterios distintos. Su estrategia fue agrupar las lenguas y comprobar qué tanto se conserva esa estructura al pasar de un espacio al otro, ya que dos espacios que capturan información similar deberían agruparlas de forma parecida. Para esto se necesitan dos elementos: un algoritmo de agrupamiento y una medida para comparar sus resultados. Analizar cada uno de ellos permite identificar qué aspectos se pueden mejorar.

=== Agrupamiento

El agrupamiento (_clustering_) es una técnica de aprendizaje de máquina no supervisado. Consiste en dividir un conjunto de instancias en grupos (clusters), de modo que las instancias dentro de cada grupo sean más parecidas entre sí que con los de otros grupos. Para determinar esta similitud se toman en cuenta los atributos de los datos, comúnmente a través de medidas de distancia @han2012data.

Los algoritmos de agrupamiento pueden clasificarse en distintos enfoques @han2012data. Los métodos jerárquicos construyen una descomposición en varios niveles, fusionando o dividiendo grupos sucesivamente, sin poder corregir después las decisiones tomadas. Los métodos basados en densidad definen los grupos como regiones densas separadas por zonas de baja densidad, lo que permite detectar formas arbitrarias y filtrar valores atípicos (_outliers_). Por último, los métodos de particionamiento dividen los datos en $k$ grupos excluyentes según la distancia, siendo eficaces en conjuntos pequeños o medianos y tendiendo a formar grupos esféricos. Uno de sus algoritmos más representativos, y el que utilizamos en este trabajo, es k-medias.

K-medias (_K-means_) @k-means-lloyd agrupa los datos en $k$ grupos asignando cada dato al centroide (el punto promedio del grupo) más cercano, usando la distancia euclidiana, e iterando hasta que los grupos se estabilicen. La asignación depende de los centroides iniciales, lo que ha motivado estrategias de inicialización como k-medias++ @kmeans-plusplus, que distribuye las semillas iniciales de forma probabilística para acelerar la convergencia y reducir la sensibilidad a la inicialización.

#cite(<ximena-bpe-2023>, form: "prose") usaron k-medias para generar agrupamientos en los experimentos que hicieron con la caracterización de BPE y la base de datos lingüística WALS. Primero agruparon las lenguas en el espacio de WALS, construido a partir de las características de tipología morfológica que seleccionaron, bajo la premisa de que lenguas tipológicamente similares deberían quedar cerca unas de otras en ese espacio.

Después, agruparon las lenguas en el espacio inducido por BPE utilizando la asignación de grupos obtenida en el espacio WALS, y calcularon el coeficiente de Silhouette, una medida intrínseca que evalúa la calidad del clustering al medir qué tan separados están los grupos entre sí y qué tan compactos son internamente. La lógica era que, si las lenguas que forman un mismo grupo en el espacio WALS no aparecieran también cercanas en el espacio inducido por BPE, entonces el coeficiente de Silhouette sería bajo, ya que los grupos no corresponderían a clusters bien definidos, sino a conjuntos de puntos dispersos en el espacio y sin una estructura coherente.


//Después, compararon esos agrupamientos pero usando los vectores de las lenguas de BPE, para ver qué tanto coincidían esos agrupamientos en ese espacio. La forma de encontrar esta coincidencia fue usar el Silhouette, un método de validación para el análisis de grupos.

=== Coeficiente de Silhouette

El coeficiente de Silhouette @ROUSSEEUW198753 mide qué tan bien queda asignado cada elemento a su grupo, comparando su cercanía con los elementos de su propio grupo frente a su cercanía con los del grupo vecino más próximo. Para un elemento $i$, sea $a(i)$ la distancia promedio entre $i$ y los demás elementos de su mismo grupo, y sea $b(i)$ la menor distancia promedio entre $i$ y los elementos de cualquier otro grupo:

$
a(i) = frac(1, abs(C_i) - 1) sum_(j in C_i, j eq.not i) d(i, j)
quad quad
b(i) = min_(k eq.not i) frac(1, abs(C_k)) sum_(j in C_k) d(i, j)
$

donde $C_i$ es el grupo al que pertenece $i$, $abs(C_i)$ su cantidad de elementos y $d(i, j)$ la distancia entre los elementos $i$ y $j$. A partir de estos valores, el coeficiente del elemento $i$ se define como:

$
s(i) = frac(b(i) - a(i), max(a(i), b(i)))
$

El coeficiente toma valores entre $-1$ y $1$. Un valor cercano a $1$ indica que el elemento está bien agrupado (mucho más cerca de su propio grupo que del vecino), un valor cercano a $0$ indica que se encuentra en la frontera entre dos grupos, y un valor negativo sugiere que estaría mejor asignado al grupo vecino. El Silhouette global se obtiene promediando $s(i)$ sobre todos los elementos, y suele emplearse para evaluar la calidad de un agrupamiento.

A pesar de que el coeficiente de Silhouette presenta buenos resultados en la tarea de validación de grupos @ARBELAITZ2013243, este coeficiente también tiene limitaciones @Rautenstrauch2026. Una de ellas es que posee un sesgo relacionado con la estructura geométrica de los grupos, ya que favorece a los grupos con forma convexa o esférica. Esto contrasta con la forma que pueden presentar los clusters/grupos de diferentes tipos de fenómenos, por ejemplo, los grupos de lenguas caracterizados mediante BPE (véase @og-bpe-space) que tienden a tener una estructura más irregular. 

Debido a estas limitaciones, existen otras medidas de validación que no dependen del cálculo de distancias ni de la forma geométrica de los grupos. Una de ellas es el Índice Rand.

=== Índice Rand

El Índice Rand (_Rand Index_, RI) @rand mide la similitud entre dos particiones/agrupamientos distintos sobre un mismo conjunto de instancias. Para esto, revisa cada par de instancias y determina si ambas particiones los colocan de forma consistente, es decir, si los ubican en el mismo grupo en las dos particiones o en grupos distintos en las dos particiones. La proporción de pares en los que existe esta coincidencia define el valor del índice, que toma valores entre 0 (ningún acuerdo) y 1 (acuerdo completo).

Sin embargo, el RI presenta una limitación importante: no corrige el grado de acuerdo esperado por azar. Como consecuencia, dos particiones generadas aleatoriamente pueden obtener valores relativamente altos, lo que dificulta la interpretación de valores intermedios y motivó la formulación de una versión corregida, conocida como el Índice Rand Ajustado (_Adjusted Rand Index_, ARI) @Hubert1985.

El ARI corrige esta limitación al descontar la coincidencia esperada por azar entre dos particiones. De esta forma, mide qué tan parecidos son los grupos generados en un espacio frente a los generados en otro, controlando por el componente aleatorio.

Por ejemplo, si un espacio $A$ agrupa cuatro lenguas como $[0, 0, 3, 5]$ y un espacio $B$ las agrupa como $[0, 0, 3, 3]$, el ARI captura ese parecido parcial (@fig-ejemplo-ari). Esto ocurre porque ambos espacios coinciden en las dos primeras lenguas, pero mientras $A$ separa la tercera y la cuarta lengua en grupos distintos, $B$ las mantiene juntas en el mismo grupo.

#figure(
  $ "ARI"(A, B) = "ARI"([0, 0, 3, 5], [0, 0, 3, 3]) = 0.57 $,
  caption: [Ejemplo del cálculo de ARI entre dos particiones parcialmente coincidentes.]
) <fig-ejemplo-ari>

Un valor de ARI igual a 1 indica agrupamientos idénticos, un valor cercano a 0 indica un agrupamiento aleatorio, y un valor negativo indica una concordancia menor a la esperada por azar. El ARI @Hubert1985 se define mediante la siguiente fórmula:

$
"ARI" =
frac(
  sum_(i j) binom(n_(i j), 2) - frac(lr([ sum_i binom(a_i, 2) sum_j binom(b_j, 2) ]), binom(n, 2), style: "horizontal"),
  frac(1, 2) lr([ sum_i binom(a_i, 2) + sum_j binom(b_j, 2) ]) - frac(lr([ sum_i binom(a_i, 2) sum_j binom(b_j, 2) ]), binom(n, 2), style: "horizontal")
)
$

donde:
- $n_(i j)$: elementos comunes entre el grupo $i$ y el grupo $j$.
- $a_i = sum_j n_(i j)$: tamaño del grupo $i$ en la partición $A$.
- $b_j = sum_i n_(i j)$: tamaño del grupo $j$ en la partición $B$.
- $n$: número total de elementos.

Adicionalmente, el ARI es una medida simétrica, lo que elimina la necesidad de considerar el orden de los agrupamientos al calcular el índice. Tampoco depende del orden en que se enumeren las lenguas, ya que lo único que cuenta es cómo se reparten en grupos: si reordenamos los elementos dentro de cada partición, el valor se mantiene igual (@fig-ari-orden).

#figure(
  $ "ARI"([0, 0, 3, 5], [0, 0, 3, 3]) = "ARI"([3, 5, 0, 0], [3, 3, 0, 0]) = 0.57 $,
  caption: [El ARI no cambia al reordenar las lenguas dentro de cada partición: solo depende de cómo se reparten en grupos.]
) <fig-ari-orden>


A pesar de que existen otras técnicas para comparar agrupamientos (clusterings), en este trabajo de tesis proponemos incorporar este índice ajustado para comparar el grado de concordancia entre los agrupamientos obtenidos a partir de distintas caracterizaciones de las lenguas, ya que corrige el acuerdo esperado por azar y permite robustecer las conclusiones de los trabajos previos.

