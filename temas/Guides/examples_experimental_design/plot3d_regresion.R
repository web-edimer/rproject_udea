plot3d_regresion <-
  function(var_x1,
           var_x2,
           var_rta,
           tipo = "interactivo",
           datos,
           modelo) {
    val_x = seq(
      from = datos %>% pull(var_x1) %>% min(na.rm = TRUE),
      to = datos %>% pull(var_x1) %>% max(na.rm = TRUE),
      len = 50
    )
    
    
    val_y = seq(
      from = datos %>% pull(var_x2) %>% min(na.rm = TRUE),
      to = datos %>% pull(var_x2) %>% max(na.rm = TRUE),
      len = 50
    )
    
    data_predict = expand.grid(val_x, val_y) %>%
      set_names(c(var_x1, var_x2))
    
    
    predichos = matrix(predict(modelo, data_predict),
                       nrow = 50,
                       ncol = 50)
    
    if (tipo == "interactivo") {
      plot_ly(x = val_x, y = val_y, z = predichos) %>%
        add_surface() %>%
        layout(scene = list(
          xaxis = list(title = var_x1),
          yaxis = list(title = var_x2),
          zaxis = list(title = var_rta)
        ))
    } else{
      scatter3D(
        x = datos %>% pull(var_x1),
        y = datos %>% pull(var_x2),
        z = datos %>% pull(var_rta),
        ticktype = "detailed",
        pch = 20,
        bty = "f",
        colkey = FALSE,
        phi = 30,
        theta = 45,
        type = "h",
        xlab = var_x1,
        ylab = var_x2,
        zlab = var_rta,
        surf = list(
          x = val_x,
          y = val_y,
          z = predichos,
          NAcol = "black",
          shade = 0.1
        )
      )
    }
    
    
  }