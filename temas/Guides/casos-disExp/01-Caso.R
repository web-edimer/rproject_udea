library(tidyverse)
library(janitor)
library(stringi)

# Eva 2007 a 2018
eva_2018 <-
  read_csv("data/Evaluaciones_Agropecuarias_Municipales_EVA.csv") %>%
  clean_names() %>%
  select(
    -c(
      cod_dep,
      cod_mun,
      desagregacion_regional_y_o_sistema_productivo,
      nombre_cientifico
    )
  ) %>%
  mutate(across(where(is.character), str_to_sentence))

eva_2018_depurada <-
  eva_2018 %>%
  filter(grupo_de_cultivo == "Frutales") %>%
  filter(subgrupo_de_cultivo == "Citricos") %>%
  filter(!cultivo %in% c("Citricos", "Toronja", "Pomelo")) %>%
  select(
    -c(
      grupo_de_cultivo,
      subgrupo_de_cultivo,
      estado_fisico_produccion,
      ciclo_de_cultivo,
      ano
    )
  ) %>%
  na.omit() %>%
  mutate(periodo = as.numeric(periodo))

# Datos 2019-2020
eva_2020 <-
  read_csv("data/Evaluaciones_Agropecuarias_Municipales___EVA._2019_-_2020.csv") %>%
  clean_names() %>%
  select(
    -c(
      codigo_del_departamento,
      codigo_del_municipio,
      nombre_cientifico
    )
  ) %>%
  mutate(across(where(is.character), str_to_sentence))

eva_2020_depurada <-
  eva_2020 %>%
  filter(grupo_cultivo_segun_especie == "Frutales") %>%
  filter(subgrupo_cultivo_segun_especie == "Cítricos") %>%
  filter(!cultivo %in% c("Citricos", "Cítricos","Toronja", "Pomelo")) %>%
  select(
    -c(
      grupo_cultivo_segun_especie,
      subgrupo_cultivo_segun_especie,
      estado_fisico_de_la_produccion,
      ciclo_del_cultivo,
      ano
    )
  ) %>%
  na.omit() %>%
  mutate(periodo = as.numeric(periodo))


# Eva total: 2007 a 2020
eva_total <- bind_rows(eva_2018_depurada, eva_2020_depurada) %>% 
  mutate(across(where(is.character), stri_trans_general, id = "Latin-ASCII"))

write_csv(x = eva_total, file = "EVA-Depurada.csv")