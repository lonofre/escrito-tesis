#pagebreak(weak: true)

#counter(heading).update(0)
#set heading(numbering: "A.1")

#show heading.where(level: 1): it => block[
  #if it.numbering != none [
    #text[Apéndice #counter(heading).display(it.numbering)] \
  ]
  #text(size: 18pt)[#it.body]
]

#include "lenguas-utilizadas.typ"
#pagebreak()
#include "wals-features.typ"
#pagebreak()
#include "grambank-features.typ"
#pagebreak()
#include "experimentos-complementarios.typ"