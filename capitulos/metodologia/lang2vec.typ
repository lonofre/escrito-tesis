/*
  Nos interesa introducir a lang2vec en esta historia.
*/
== lang2vec

// TODO: Citar las demás base de datos
Utilizamos además la base de datos lingüística URIEL @littell2017uriel en su biblioteca `lang2vec` para obtener de otras fuentes características de las lenguas. Esta base de datos es una recopilación de otras bases de datos como WALS, Glottolog, etc.

// TODO: Citar también a las bases (si es necesario)
// Voy a incluir por lo mientras a las demás bases si queremos hacer un análisis a futuro. El cómo lo utilizaron está en el paper de URIEL
Las características que usamos sintácticas. Esto lo obtuvimos del conjunto `syntax wals.` Estos valores son adaptados de WALS, de SSWL y de Ethnologue.

Las características que proporciona `lang2vec` son binarias, debido a que siguieron la filosofía de one hot encoding, como Grambank. Sin embargo, para no todos las lenguas existía un valor.

Por ello, llenamos los valores faltantes con 0. Así, los representamos que no tienen ningún valor. Estos valores en `lang2vec` aparecen como `--`.