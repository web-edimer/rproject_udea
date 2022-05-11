diagramas_venn <-
  function(tipo,
           A,
           B,
           C,
           AB,
           AC,
           BC,
           ABC,
           nombreA,
           nombreB,
           nombreC,
           colorA,
           colorB,
           colorC) {
    grid.newpage()
    
    if (tipo == "doble") {
      diagrama = draw.pairwise.venn(
        area1 = A,
        area2 = B,
        cross.area = AB,
        category = c(nombreA, nombreB),
        fill = c(colorA, colorB)
      )
      
    } else if (tipo == "triple") {
      diagrama = draw.triple.venn(
        area1 = A,
        area2 = B,
        area3 = C,
        n12 = AB,
        n13 = AC,
        n23 = BC,
        n123 = ABC,
        category = c(nombreA, nombreB, nombreC),
        fill = c(colorA, colorB, colorC)
      )
    }
    
    grid.draw(diagrama)
  }