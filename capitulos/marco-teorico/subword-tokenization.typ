/*
  Esta sección trata sobre la tokenización y su importancia en los sistemas de NLP. En particular, por qué es utilizado en los LLMs.
  También queremos introducir algunos algoritmos de tokenización.
*/
#import "diagramas/tokenizacion-ejemplo.typ": ejemplo-tokenizacion

== Tokenización a nivel subpalabra

Esa segmentación previa al modelo recibe el nombre de tokenización: el proceso de dividir el texto en unidades discretas denominadas tokens. Estos tokens son las unidades manejadas por los modelos de lenguaje y algoritmos de PLN. Estas unidades pueden corresponder a palabras, subpalabras, morfemas u otros tipos de segmentos, como ilustra la @fig-tokenizacion.

Esa segmentación previa recibe el nombre de tokenización, que es el proceso de dividir el texto en unidades discretas llamadas tokens. Estas unidades, que pueden corresponder a palabras, subpalabras, morfemas u otros tipos de segmentos (véase @fig-tokenizacion); son las que finalmente manejan los modelos de lenguaje y otros algoritmos de PLN.

#figure(
  align(center, block[
    #set align(left)
    Texto original: "En un lugar lejano" \
    Tokenización a nivel palabra: `[En, un, lugar, lejano]` \
    Tokenización a nivel carácter: `[E, n, u, n, l, u, g, a, r, l, e, j, a, n, o]`
    ]),
  caption: [Algunas formas de tokenización.]
)<fig-tokenizacion>

La más intuitiva de esas formas es la tokenización por palabras, pero tiene limitaciones importantes @jm3. Por un lado, lenguas como el chino y el japonés no separan las palabras con espacios, lo que complica este tipo de tokenización. Por otro lado, las palabras desconocidas (_Out of Vocabulary_, OOV) no pueden procesarse sin expandir constantemente el vocabulario. Esto es evidente en tareas como la traducción de palabras raras y OOV @sennrich-etal-2016-neural, donde los mecanismos a nivel de palabra resultan insuficientes en lenguas con procesos productivos de formación de nuevas palabras.

Para abordar estas limitaciones, una alternativa al uso de palabras como tokens es emplear subpalabras: unidades de longitud igual o menor que una palabra, que pueden corresponder a cadenas arbitrarias, morfemas o, en algunos casos, a la palabra completa.

Esta propiedad del tamaño de una subpalabra resulta fundamental cuando un modelo se enfrenta a palabras desconocidas. Si una palabra aparece muy pocas veces, el modelo tiene dificultades para aprender su significado, lo que limita su capacidad de generalización. En cambio, cuando el modelo utiliza subpalabras, dispone de más evidencia distribuida a lo largo del corpus, ya que estas unidades, al ser más pequeñas, tienden a repetirse con mayor frecuencia que las palabras completas. Como resultado, los modelos basados en subpalabras logran un mejor manejo de palabras OOV @sennrich-etal-2016-neural @jm3.

Debido a estas ventajas, las subpalabras son las unidades predominantes en los modelos de lenguaje actuales. El algoritmo más extendido para producirlas es la codificación de pares de bytes.

Debido a estas ventajas, las subpalabras son las unidades predominantes en los modelos de lenguaje actuales. El algoritmo más extendido para generarlas es la codificación de pares de bytes.

=== Codificación de Pares de Bytes

La codificación de pares de bytes (_Byte Pair Encoding_, BPE) fue propuesta por #cite(<Gage1994ANA>, form: "prose") como un algoritmo de compresión de datos, cuya única operación consiste en sustituir, repetidamente, el par de bytes contiguos más frecuente de un archivo por un nuevo byte que no aparece en él. #cite(<sennrich-etal-2016-neural>, form: "prose") adaptaron esta idea para generar subpalabras, reemplazando la compresión de bytes por la fusión de caracteres dentro de las palabras de un corpus; los símbolos resultantes de esas fusiones forman el vocabulario de subpalabras.

El entrenamiento de un modelo BPE parte de un vocabulario inicial $V$, formado por los caracteres del corpus (su alfabeto $Sigma$), y de las palabras representadas como secuencias de esos caracteres. Sobre esa base se repite el siguiente proceso @jm3:

El entrenamiento de un modelo BPE parte de un vocabulario inicial $V$, formado por los caracteres del corpus (su alfabeto $Sigma$), y de las palabras del corpus representadas como secuencias de esos caracteres. Sobre esa base se repite el siguiente proceso @jm3:

1. Se cuenta la frecuencia $f(a, b)$ de cada par de símbolos contiguos $(a, b)$ que aparece dentro de las palabras del corpus.
2. Se selecciona el par más frecuente:
$ (a^*, b^*) = op("argmáx", limits: #true)_((a, b)) f(a, b) $
3. Se fusionan ambos símbolos en uno nuevo, $a^* b^*$, que reemplaza todas las ocurrencias del par y se agrega a $V$.

Cada repetición de estos pasos se denomina fusión (_merge_). El proceso termina al alcanzar un número predeterminado de fusiones, el hiperparámetro principal del algoritmo. El vocabulario final $V$, formado por los caracteres iniciales más los símbolos creados, es el conjunto de subpalabras del modelo.

Este procedimiento tiene tres rasgos que conviene tener presentes. Es voraz: en cada paso fusiona el par más frecuente del momento, sin reconsiderar las fusiones ya hechas, por lo que su vocabulario no es un óptimo global sino el resultado de decisiones locales. Es determinista: sobre el mismo corpus y con el mismo número de fusiones, produce siempre el mismo vocabulario. Y es no supervisado: se aplica a cualquier texto y en cualquier lengua, sin anotaciones, gramáticas ni reglas externas, y con la frecuencia de los pares como único criterio. Así, al no incorporar ningún conocimiento lingüístico externo, el algoritmo se limita a capturar los patrones de combinación de caracteres que ya existen en el texto, y como esa estructura cambia de una lengua a otra, cada una termina produciendo un conjunto distinto de subpalabras.

Con ese vocabulario ya construido, tokenizar un texto nuevo consiste en reproducir lo aprendido. El texto se segmenta a nivel de caracteres y las fusiones se aplican de forma iterativa, en el mismo orden en que fueron aprendidas, hasta que ninguna pueda aplicarse más. La secuencia de símbolos resultante es la representación del texto en subpalabras.

Como ejemplo del proceso de tokenización, considérese este texto. Al aplicar un tokenizador ya entrenado, en este caso `tiktoken`#footnote[Biblioteca de tokenización de OpenAI: #link("https://github.com/openai/tiktoken").], el texto se convierte en la serie de tokens que muestra la @fig-ejemplo-tokenizacion, donde el símbolo ␣ representa un espacio.

#figure(
  ejemplo-tokenizacion,
  caption: [Tokenización de una oración con `tiktoken`.]
) <fig-ejemplo-tokenizacion>

En el ejemplo conviven los dos tipos de subpalabras que produce un modelo de BPE entrenado. Unas son palabras completas y muy frecuentes, como _Las_ o _en_, que el modelo conserva enteras. Otras son fragmentos que reaparecen dentro de muchas palabras, como _as_ en _bananas_, _sábanas_ o _personas_, o _ción_ en _terminación_ y _disminución_.

BPE no es el único algoritmo estadístico de tokenización a subpalabra. WordPiece @schuster2012japanese@bert, por ejemplo, sigue un esquema iterativo similar, voraz y no supervisado, pero elige las fusiones por verosimilitud en lugar de por frecuencia.

Pese a esas diferencias, todos estos algoritmos comparten un rasgo decisivo: son no supervisados y de naturaleza puramente estadística. BPE, además, fue originalmente concebido como un método de compresión de datos. Esa indiferencia formal hacia la lingüística plantea una pregunta inmediata: si el algoritmo nunca recibe reglas gramaticales, morfemas ni anotaciones de ningún tipo, ¿qué información sobre una lengua puede llegar a capturar a partir de la sola frecuencia de sus caracteres?