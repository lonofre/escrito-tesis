# Tesis: Explorando la huella lingüística oculta en los modelos de PLN

## De qué trata
Tesis de licenciatura (Facultad de Ciencias, UNAM), escrita en Typst y en español.
Extiende el trabajo de Ximena et al. (2023), quienes caracterizaron 47 lenguas con
medidas estadísticas de las subpalabras que produce BPE (productividad, frecuencia
acumulada, idiosincrasia) y vieron que las lenguas que BPE agrupa se parecen a las
que agrupa WALS. Aquí preguntamos si esa coincidencia es robusta: comparamos el
espacio de BPE contra espacios construidos con bases tipológicas (WALS, Grambank,
lang2vec), con varias semillas y configuraciones de agrupamiento, usando el Adjusted
Rand Index (ARI) y una línea base aleatoria. También analizamos qué características
lingüísticas explican la coincidencia.

## Organización
main.typ incluye, en orden: portada, agradecimientos, declaración de IA, contenidos,
capitulos/ (introducción, marco teórico, metodología, resultados, discusión,
conclusiones), bibliografía y apéndice. template.typ define el formato global. Cada
capítulo vive en capitulos/<nombre>/ y su archivo principal incluye subarchivos por
sección.

## Qué hay en cada parte
- capitulos/introduccion: planteamiento, objetivos y preguntas de investigación.
- capitulos/marco-teorico: IA y PLN (ia.typ), tokenización a nivel subpalabra y BPE,
  huella lingüística de la tokenización, similitud entre espacios (agrupamiento, ARI).
  diagramas/ guarda diagramas como valores `#let X-diagrama`; img/ las figuras.
- capitulos/metodologia: corpora.typ (corpus paralelo y bases de datos),
  procesamiento-datos.typ (cómo se vuelve cada fuente un espacio), comparacion.typ
  (medición y experimentos). datos/ y img/ de apoyo.
- capitulos/resultados: resultados.typ y resultados-lib.typ (funciones de gráficas con
  lilaq). datos/percentiles/ trae los JSON precalculados de ARI que alimentan las
  figuras.
- capitulos/discusion y conclusiones: interpretación, limitaciones y trabajo futuro.
- apendice/: listas de lenguas y características (WALS, Grambank), experimentos
  complementarios y datos crudos (CSV/JSON/YAML).
- bibliografia.bib / bibliografia.typ: referencias.
- main.pdf: salida compilada; no leerlo, trabajar sobre los .typ.
- Código y datos de los experimentos: repositorio externo
  github.com/lonofre/bpe-comparacion.

## Convenciones
Las preferencias de estilo y proceso están en la memoria del usuario (MEMORY.md). Lo
esencial: proponer antes de editar, preservar el texto original, primera persona del
plural, español sobre anglicismos, y no borrar comentarios de revisión.
