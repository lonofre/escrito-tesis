== Base de referencia

Por último, creamos una linea de referencia en base a los vectores de BPE. Esta base de referencia nos sirvió como principal comparación sobre BPE con respecto a las características de WALS y Grambank.

Así, para crear esta línea de referencia obtuvimos los vectores de BPE y obtuvimos rangos en donde varían las features. Ya con los rangos, usamos una distribución uniforme para crear los vectores de cada lengua pero con valores aleatorios. A este espacio lo llamamos $X_"BPE Random"$