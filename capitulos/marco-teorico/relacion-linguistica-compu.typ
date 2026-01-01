== La liga entre la lingüística y los métodos computacionales actuales

// Citar al libro de NPL?
En la actualidad, la inteligencia artificial tiene su enfoque en los grandes modelos de lenguaje (Large Language Models, LLMs). Estos modelos son redes neuronales que toman como entrada un contexto y su salida es una distribución de las posibles siguientes palabras. Eventualmente, se puede modificar estos modelos para ser autoregresivos, que es el fundamento para la inteligencia artificial generativa.

Las arquitecturas más comunes para los LLMs son el _codificador_, _decodificador_ y _codificador-decodificador_.

// Citar al libro de NPL. Posiblemente expandir un poco y entender bien cómo funciona esta parte. Por lo mientras, voy poniendo la idea general.
La arquitectura de decodificador recibe una serie de tokens e iterativamente genera un token a la vez. Esto podemos observalo en modelos como GPT, Llama, Gemini, etc.

Mientras que la arquitectura de codificador, toma tokens como entrada y produce una representación vectorial de cada token como salida.

// Será buena idea hablar del transformer, que es un encoder-decoder?

Notemos que lo común entre estas arquitecturas es el uso de tokens como entrada, y en algunos casos como salida. También observemos que los algoritmos de tokenización no participan en alguna de estas arquitecturas, pues se da por hecho los tokens que se reciben en los modelos.

// El experimento de BPE, citas el artículo de 2023 de Ximena
Esto anterior fue observado por Ximena y compañía. Ellos definieron definieron medidas en base a los resultados obtenidos por un modelo entrenado de BPE, con el objetivo de comprar si de alguna manera, las subpalabras codifican información lingüística relevantes para los modelos de lenguaje. Estas medidas son la _productividad_ de una subpalabra, la _idiosincrasia_ y la _frecuencia acumulada_.

La productividad de una subpalabra $s$ es el número de palabras ortográficas que contienen a una subpalabra: // TODO Checar aquí la cita que tienen en el paper, página 18, cita 22
$ "productividad"(s) = |W_s| $

La frecuencia acumulativa de una subpalabra $s$ es la suma de las frecuencias de las palabras ortográficas que contienen a la subpalabra.
$ "c.freq(s)"(s) = sum_(w in W_s) "freq"(w) $

Mientras que la idiosincrasia, se define así:
$ "idiosincrasia"(s) = "c.freq"(s)/"productividad"(s) $