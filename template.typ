// Template para configurar toda la tesis (a excepción de la portada). Aquí se configuran cómo se ven las páginas, el tamaño de texto, etc.
#let tesis(body) = {
    set page(
        numbering: "1"
    )

    set par(justify: true)

    set math.equation(numbering: "(1)")

    set text(size: 12pt)
    set heading(numbering: "1.1")

    // TODO: No sirvió y ver por qué
    show cite.where(form: "prose"): it => {
        show "&": "y"
        it
    }

    show heading.where(level: 1): it => block[
        #if it.numbering != none [
            #text[Capítulo #counter(heading).display(it.numbering)] \
        ]
        #text(size: 22pt)[#it.body]
    ]

    body
}
