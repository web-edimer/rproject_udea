library(tidyverse)
library(janitor)
library(stringi)

ingredientes <-
  read_csv("data/Alimentos_del_tr_pico_para_alimentaci_n_animal_-_AlimenTro.csv") %>%
  clean_names() %>%
  filter(categoria == "01 Gramineas forrajeras") %>%
  count(ingrediente, sort = T) %>%
  slice(1, 2, 3, 6, 7) %>%
  pull(ingrediente)

alimentro <-
  read_csv("data/Alimentos_del_tr_pico_para_alimentaci_n_animal_-_AlimenTro.csv") %>%
  clean_names() %>%
  filter(categoria == "01 Gramineas forrajeras") %>%
  filter(ingrediente %in% ingredientes) %>%
  select(
    -c(
      id,
      fecha_recoleccion,
      categoria,
      subcategoria,
      nombre_alterno_1,
      nombre_alterno_2,
      nombre_alterno_3,
      metodo_de_conservacion,
      glicerol_g_100_g_1_ms,
      sistema_productivo,
      ndt_g_100_g_1_ms
    )
  ) %>%
  mutate(
    across(
      c(proteina_cruda_g_100_g_1_ms:e_nl_rumiantes_mcal_kg_1_ms),
      as.numeric
    ),
    textura_de_suelo = if_else(
      textura_de_suelo %in% c(
        "Franco arcilloso arenoso",
        "Franco arcilloso limoso",
        "Arcilloso arenoso",
        "Arcilloso limoso"
      ),
      true = "Otro",
      false = textura_de_suelo
    )
  ) %>%
  na.omit() %>% 
  rename(
    proteina = proteina_cruda_g_100_g_1_ms,
    ceniza = ceniza_g_100_g_1_ms,
    extracto_etereo = extracto_etereo_g_100_g_1_ms,
    FDN = fdn_g_100_g_1_ms,
    FDA = fda_g_100_g_1_ms,
    lignina = lignina_g_100_g_1_ms,
    hemicelulosa = hemicelulosa_g_100_g_1_ms,
    almidon = almidon_total_g_100_g_1_ms,
    carbohidratos_noes = carbohidratos_no_estructurales_g_100_g_1_ms,
    carbohidratos_solubles = carbohidratos_solubles_g_100_g_1_ms,
    digestibilidad_ms = digestibilidad_ms_g_100_g_1_ms,
    energia_digestible = ed_rumiantes_mcal_kg_1_ms,
    energia_metabolizable = em_rumiantes_mcal_kg_1_ms,
    energia_neta_manten = e_nm_rumiantes_mcal_kg_1_ms,
    energia_neta_ganancia = e_ng_rumiantes_mcal_kg_1_ms,
    energia_neta_lactancia = e_nl_rumiantes_mcal_kg_1_ms
  )

write_csv(x = alimentro, file = "Alimentro-Depurada.csv")