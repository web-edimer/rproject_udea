library(tidyverse)
library(janitor)
library(stringi)

suelos <-
  read_csv("data/Resultados_de_An_lisis_de_Laboratorio_Suelos_en_Colombia.csv") %>%
  clean_names() %>%
  filter(cultivo == "Cacao") %>%
  mutate(across(where(is.character), str_to_sentence)) %>%
  filter(estado == "Establecido") %>%
  filter(!topografia %in% c("Plano y ondulado", "Ondulado y pendiente")) %>%
  mutate(
    topografia = str_replace_all(topografia, "Error: #n/a", "No indica"),
    topografia = if_else(
      topografia %in% c("Ligeramente ondulado",
                        "Moderadamente ondulado"),
      true = "Ondulado",
      false = topografia
    ),
    topografia = if_else(
      topografia %in% c("Pendiente fuerte",
                        "Pendiente leve",
                        "Pendiente moderada"),
      true = "Pendiente",
      false = topografia
    ),
    drenaje = str_replace_all(drenaje, "Error: #n/a", "No indica"),
    drenaje = if_else(
      drenaje %in% c("Buen drenaje"),
      true = "Bueno",
      false = drenaje
    ),
    drenaje = if_else(
      drenaje %in% c("Regular drenaje"),
      true = "Regular",
      false = drenaje
    ),
    drenaje = if_else(
      drenaje %in% c("Mal drenaje"),
      true = "Malo",
      false = drenaje
    ),
    riego = if_else(
      !riego %in% c("No cuenta con riego"),
      true = "Cuenta con riego",
      false = riego
    ),
    fertilizantes_aplicados = if_else(
      !fertilizantes_aplicados %in% c("No ha aplicado fertilizantes",
                                      "No indica"),
      true = "Aplica fertilizantes",
      false = fertilizantes_aplicados
    )
  ) %>%
  select(
    -c(
      numfila,
      cultivo,
      estado,
      fecha_analisis,
      hierro_fe_disponible_doble_cido_mg_kg,
      cobre_cu_disponible_doble_acido_mg_kg:secuencial
      
    )
  ) %>%
  rename(
    fertilizacion = fertilizantes_aplicados,
    pH = p_h_agua_suelo_2_5_1_0,
    materia_organica = materia_organica_mo_percent,
    fosforo = fosforo_p_bray_ii_mg_kg,
    azufre = azufre_s_fosfato_monocalcico_mg_kg,
    acidez = acidez_al_h_kcl_cmol_kg,
    aluminio = aluminio_al_intercambiable_cmol_kg,
    calcio = calcio_ca_intercambiable_cmol_kg,
    magnesio = magnesio_mg_intercambiable_cmol_kg,
    potasio = potasio_k_intercambiable_cmol_kg,
    sodio = sodio_na_intercambiable_cmol_kg,
    CICE = capacidad_de_intercambio_cationico_cice_suma_de_bases_cmol_kg,
    conductividad = conductividad_el_ctrica_ce_relacion_2_5_1_0_d_s_m,
    hierro = hierro_fe_disponible_olsen_mg_kg,
    cobre = cobre_cu_disponible_mg_kg,
    manganeso = manganeso_mn_disponible_olsen_mg_kg,
    zinc = zinc_zn_disponible_olsen_mg_kg,
    boro = boro_b_disponible_mg_kg
  ) %>%
  mutate(
    across(
      c(
        fosforo,
        acidez,
        aluminio,
        calcio,
        magnesio,
        potasio,
        sodio,
        conductividad,
        hierro,
        cobre,
        manganeso,
        zinc,
        boro
      ),
      ~ str_replace_all(.x, ",", ".")
    ),
    across(
      c(
        fosforo,
        acidez,
        aluminio,
        calcio,
        magnesio,
        potasio,
        sodio,
        conductividad,
        hierro,
        cobre,
        manganeso,
        zinc,
        boro
      ),
      ~ str_remove(.x, ">")
    ),
    across(
      c(
        fosforo,
        acidez,
        aluminio,
        calcio,
        magnesio,
        potasio,
        sodio,
        conductividad,
        hierro,
        cobre,
        manganeso,
        zinc,
        boro
      ),
      ~ str_remove(.x, "<")
    ),
    across(
      c(
        fosforo,
        acidez,
        aluminio,
        calcio,
        magnesio,
        potasio,
        sodio,
        conductividad,
        hierro,
        cobre,
        manganeso,
        zinc,
        boro
      ),
      ~ as.numeric(str_trim(.x))
    )
  ) %>%
  na.omit()

write_csv(x = suelos, file = "Suelos-Depurada.csv")