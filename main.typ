#set text(
    lang: "es"
)

#include "portada.typ"
#include "contenidos.typ"
#{
    // Configuración general para el contenido
    // de la tesis
    set page(
        numbering: "1",
    )
    set text(size: 12pt)
    set heading(numbering: "1.1")
    {
        show heading.where(level: 1) : it => block[
            #text[Capítulo #counter(heading).display(it.numbering)] \
            #text(size: 22pt)[#it.body]
        ]
        include "capitulos/introduccion/introduccion.typ"
        include "capitulos/marco-teorico/marco-teorico.typ"
        include "capitulos/metodologia/metodologia.typ"
        include "capitulos/resultados/resultados.typ"
        include "capitulos/conclusiones/conclusiones.typ"
    }
    include "bibliografia.typ"       


}