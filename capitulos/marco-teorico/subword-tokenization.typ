/*
  Esta sección trata sobre la tokenización y su importancia en los sistemas de NLP. En particular, por qué es utilizado en los LLMs.
  También queremos introducir algunos algoritmos de tokenización.
*/
#import "diagramas/tokenizacion-ejemplo.typ": ejemplo-tokenizacion
#import "diagramas/bpe-ejemplo.typ": bpe-ejemplo-diagrama

== Tokenización a nivel subpalabra

Esa segmentación previa al modelo recibe el nombre de tokenización, el proceso de dividir el texto en unidades discretas denominadas tokens. Estos tokens son las unidades manejadas por los modelos de lenguaje y algoritmos de PLN. Estas unidades pueden corresponder a palabras, subpalabras, morfemas u otros tipos de segmentos, como ilustra el @fig-tokenizacion.

#figure(
  align(center, block[
    #set align(left)
    Texto original: "En un lugar lejano" \
    Tokenización a nivel palabra: `[En, un, lugar, lejano]` \
    Tokenización a nivel carácter: `[E, n, u, n, l, u, g, a, r, l, e, j, a, n, o]`
    ]),
  caption: [Algunas formas de tokenización.]
)<fig-tokenizacion>

La más intuitiva de esas formas es la tokenización por palabras, pero tiene limitaciones importantes @jm3. Las lenguas tienden a producir una gran variedad de palabras ortográficas distintas, especialmente aquellas con morfología rica. Muchas de estas palabras tienen una frecuencia de aparición de 1 o muy baja. En general, esto no es favorable para los modelos estadísticos o neuronales, ya que una palabra con baja frecuencia no puede modelarse adecuadamente. Además, esto ocasiona el problema de las Out-of-Vocabulary (OOV), es decir, palabras que no fueron observadas durante el entrenamiento del modelo, pero que pueden aparecer en el momento de la inferencia. Esto es evidente en tareas como la traducción automática y el modelado del lenguaje en general, donde los mecanismos a nivel de palabra resultan insuficientes en lenguas con procesos productivos de formación de nuevas palabras @sennrich-etal-2016-neural.


#underline[_ Ximena: Cambié un poco la redacción, asegúrate de que tengas claros los conceptos de tokenización y por qué es importante. Te recomendaría aquí poner un ejemplito sencillo ya sea en una tabla o figura. Por ejemplo fr(created)=10 ; fr(creat)= 40 (aparece en creation, creature, creates, etc)  fr(ed)=100 (aparece al final de un montón de palabras)_]

Para abordar estas limitaciones, una alternativa al uso de palabras como tokens es emplear subpalabras, que son unidades de longitud igual o menor que una palabra, que pueden corresponder a cadenas arbitrarias, morfemas o, en algunos casos, a la palabra completa.

Esta propiedad del tamaño de una subpalabra resulta fundamental cuando un modelo se enfrenta a palabras desconocidas. Si una palabra aparece muy pocas veces, el modelo tiene dificultades para aprender su significado, lo que limita su capacidad de generalización. En cambio, cuando el modelo utiliza subpalabras, dispone de más evidencia distribuida a lo largo del corpus, ya que estas unidades, al ser más pequeñas, tienden a repetirse con mayor frecuencia que las palabras completas. Como resultado, los modelos basados en subpalabras logran un mejor manejo de palabras OOV @sennrich-etal-2016-neural @jm3.


Debido a estas ventajas, las subpalabras son las unidades predominantes en los modelos de lenguaje actuales. El algoritmo más extendido para producirlas es la codificación de pares de bytes.

=== Codificación de Pares de Bytes

#underline[_Ximena: Aquí recomendaría integrar el algoritmo extendido del libro de Víctor Mijangos y citarlo (complementando el que ya pones aquí), también puedes revisar es elibro o mis notas de clase para comentar en unas líneas breves en qué consiste el  tiempo de entrenamiento, y cuaĺ el de inferencia en BPE. Yo sugeriría que agregues un ejemplo de juguete donde se vean algunos merges, las tablas de frecuencias de símbolos o algo del estilo muy sencillo para que se vea el proceso iterativo _ ✅] 

_- Una vez más, verificar las citas, quien estableció BPE para NLP fue Sennrich no Jurafsky, puedes citar a sennrich, además de Jurafsky. _

La codificación de pares de bytes (_Byte Pair Encoding_, BPE) fue propuesta por #cite(<Gage1994ANA>, form: "prose") como un algoritmo de compresión de datos, cuya única operación consiste en sustituir, repetidamente, el par de bytes contiguos más frecuente de un archivo por un nuevo byte que no aparece en él. #cite(<sennrich-etal-2016-neural>, form: "prose") adaptaron esta idea para generar subpalabras, reemplazando la compresión de bytes por la fusión de caracteres dentro de las palabras de un corpus; los símbolos resultantes de esas fusiones forman el vocabulario de subpalabras.

El entrenamiento de un modelo BPE parte de un corpus $cal(C)$, con las palabras representadas como secuencias de caracteres separadas por espacios, y de un vocabulario inicial equivalente al alfabeto $Sigma$ de esos caracteres. Sobre esa base, el algoritmo construye un diccionario de reglas $R$, inicialmente vacío, repitiendo el siguiente proceso hasta alcanzar un número máximo $T$ de reglas @sennrich-etal-2016-neural @mijangos2026fundamentos:

1. Se cuenta la frecuencia $f(a_i, b_j)$ de cada par de símbolos contiguos $(a_i, b_j)$, con $a_i, b_j in Sigma$, que aparece dentro de $cal(C)$.
2. Se selecciona el par más frecuente:
$ (a^*, b^*) = op("argmáx", limits: #true)_((a_i, b_j)) f(a_i, b_j) $
3. Se crea una regla de fusión, $r: (x, y) arrow x y$, a partir de ese par, y se aplica sobre todo el corpus, sustituyendo cada ocurrencia de $(a^*, b^*)$ por el símbolo fusionado $a^* b^*$.
4. La regla se agrega a $R$.

Cada repetición de estos pasos se denomina fusión (_merge_). El proceso termina al alcanzar las $T$ reglas, que da como resultado un diccionario $R$, que es la secuencia ordenada de las reglas de fusión aprendidas. El vocabulario final del modelo está formado por los caracteres de $Sigma$ más los símbolos creados por cada regla de $R$.

Para ilustrar este proceso, tomamos la oración "tres tristes tigres trituraban trigo en un trigal", y le aplicamos las primeras cinco fusiones del algoritmo. El @fig-bpe-ejemplo muestra cómo queda la oración después de cada una: en la primera, todas las _t_ y _r_ se combinan en _tr_; en la segunda, ese símbolo se junta con el espacio que lo precede; y así sucesivamente. En _tigres_, en cambio, la _t_ y la _r_ nunca quedan juntas, así que esa palabra se queda fuera de las fusiones que sí transforman a sus vecinas.

#figure(
  bpe-ejemplo-diagrama(width: 85%),
  caption: [Primeras cinco fusiones de BPE sobre un ejemplo breve.]
) <fig-bpe-ejemplo>

Con el diccionario $R$ ya construido, tokenizar una palabra nueva $w$ mediante el algoritmo de inferencia de BPE consiste en reproducir lo aprendido durante el entrenamiento @mijangos2026fundamentos. Partiendo de $w$ ya segmentada a nivel de caracteres, se repiten los siguientes pasos:

1. Para cada regla $r in R$, en el mismo orden en que fue aprendida, se verifica si su patrón aparece en $w$ y, de ser así, se aplica, sustituyendo esa ocurrencia por el símbolo fusionado correspondiente.
2. Al recorrer así todas las reglas de $R$, la secuencia resultante de símbolos es la representación de $w$ en subpalabras.

#let tokenization_example_footnote = footnote[Biblioteca de tokenización de OpenAI: #link("https://github.com/openai/tiktoken").]

Como ejemplo del proceso de tokenización, considérese el texto "Las supernovas estallan en galaxias lejanas.". Al aplicar un tokenizador ya entrenado, en este caso `tiktoken`#tokenization_example_footnote, el texto se convierte en la serie de tokens que muestra la @fig-ejemplo-tokenizacion.

#figure(
  ejemplo-tokenizacion,
  caption: [Tokenización de una oración con `tiktoken`.]
) <fig-ejemplo-tokenizacion>

En el ejemplo conviven los dos tipos de subpalabras que produce un modelo de BPE entrenado. Unas son palabras completas y muy frecuentes, como _Las_ o _en_, que el modelo conserva enteras. Otras son fragmentos que reaparecen dentro de muchas palabras, como _as_ en _bananas_, _sábanas_ o _personas_, o _ción_ en _terminación_ y _disminución_.

Vistos los algoritmos de entramiento e inferencia, BPE tiene tres rasgos que conviene tener presentes. Es voraz, ya que en cada paso fusiona el par más frecuente del momento, sin reconsiderar las fusiones ya hechas, por lo que su vocabulario no es un óptimo global sino el resultado de decisiones locales. Es determinista, pues sobre el mismo corpus y con el mismo número de fusiones produce siempre el mismo vocabulario. Y es no supervisado, ya que se aplica a cualquier texto y en cualquier lengua, sin anotaciones, gramáticas ni reglas externas, y con la frecuencia de los pares como único criterio. Así, al no incorporar ningún conocimiento lingüístico externo, el algoritmo se limita a capturar los patrones de combinación de caracteres que ya existen en el texto, y como esa estructura cambia de una lengua a otra, cada una termina produciendo un conjunto distinto de subpalabras.

No obstante, BPE no es el único algoritmo estadístico de tokenización a subpalabra. WordPiece @schuster2012japanese@bert, por ejemplo, sigue un esquema iterativo similar, voraz y no supervisado, pero elige las fusiones por verosimilitud en lugar de por frecuencia.

Pese a esas diferencias, todos estos algoritmos comparten un rasgo decisivo: son no supervisados y de naturaleza puramente estadística. BPE, además, fue originalmente concebido como un método de compresión de datos. Esa indiferencia formal hacia la lingüística plantea una pregunta inmediata: si el algoritmo nunca recibe reglas gramaticales, morfemas ni anotaciones de ningún tipo, ¿qué información sobre una lengua puede llegar a capturar a partir de la sola frecuencia de sus caracteres?