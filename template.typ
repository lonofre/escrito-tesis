// Template para configurar toda la tesis (a excepción de la portada). Aquí se configuran cómo se ven las páginas, el tamaño de texto, etc.
// Tamaño de página y márgenes compartidos entre la portada y el resto de la tesis.
#let pagina-config = (
    paper: "us-letter",
    // Margen interior de 2.5cm + 1cm extra para dejar espacio a la encuadernación
    margin: (inside: 2.5cm, outside: 2.5cm, y: 2.5cm),
)

#let tesis(body) = {
    set page(
        ..pagina-config,
        binding: left,
        numbering: "1"
    )

    set par(justify: true)

    set math.equation(numbering: "(1)")

    set text(size: 12pt)
    set heading(numbering: "1.1")

    show heading.where(level: 1): it => block[
        #if it.numbering != none [
            #text[Capítulo #counter(heading).display(it.numbering)] \
        ]
        #text(size: 22pt)[#it.body]
    ]

    body
}
