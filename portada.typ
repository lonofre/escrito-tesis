#import "@preview/cetz:0.4.2"

#let cover_content = block(
    width: 11cm
)[
    #set align(center)
    #show text: it => smallcaps(it)
    #set text(
        size: 14pt
    )

    Explorando la huella lingüística oculta en los modelos de procesamiento del lenguaje natural

    #v(1cm)

    #text(
        weight: "bold",
        size: 24pt
    )[T E S I S]

    #v(1cm)

    Que para obtener el título de:

    #v(0.5cm)

    Licenciado en Ciencias de la Computación

    #v(1.5cm)

    P R E S E N T A:

    #v(0.5cm)

    José Luis Onofre Franco

    #v(1.5cm)

    T U T O R

    #v(0.5cm)

    María Ximena Gutiérrez Vasques

    #v(1.5cm)
    2025
]

#let cover = cetz.canvas({
    import cetz.draw: *

    // Escudos
    content((0,20), [
        #image("escudos/unam.svg", width: 3cm)
    ], name: "unam_logo")
    content((0, 0), [
        #image("escudos/fciencias.svg", width: 3cm)
    ], name: "fciencias_logo")

    // Lineas verticales
    let start_y = 2
    let end_y = 18
    line((-0.2, start_y), (-0.2, end_y))
    line((0, start_y), (0, end_y), stroke: (thickness: 2pt))
    line((0.2, start_y), (0.2, end_y))
    
    // Lineas horizontales
    let start_x = 2
    let end_x = 15
    line((start_x, 20), (end_x, 20), name: "fciencias")
    line((start_x, 20.2), (end_x, 20.2), stroke: (thickness: 2pt), name: "unam")

    // Información que va en la parte de arriba
    content(
        ("unam.start", 50%, "unam.end"),
        padding: (
            bottom: 0.5
        ),
        anchor: "south",
        text(
            size: 1.3em,
            smallcaps[Universidad Nacional Autónoma de México]
        )
    )
    content(
        ("fciencias.start", 50%, "fciencias.end"),
        padding: (
            top: 0.5
        ),
        anchor: "north", 
        smallcaps[Facultad de Ciencias]
    )
    
    // Contenido dentro de la portada
    content(
        ("fciencias.start", 50%, "fciencias.end"),
        padding: (
            top: 3,
        ),
        anchor: "north",
        cover_content
    )
})

#place(top + left,
cover)

#v(10cm)


#pagebreak()