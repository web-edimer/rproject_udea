# Bibliotecas
library(tidyverse)
library(readxl)
library(janitor)

# ------ Minería Colombia: Oro y plata 2012 a 2020 -----
df_mineria <- read_csv(
  "ANM_Producci_n_Nacional_de_Minerales_y_Contraprestaciones_Econ_micas_Trimestral.csv"
) %>% 
  clean_names() %>% 
  rename(year = ano_produccion) %>% 
  mutate(across(c(recurso_natural, nombre_del_proyecto,
                  unidad_medida, tipo_contraprestacion), str_to_title)) %>% 
  filter(recurso_natural %in% c("Oro", "Plata"))

write_csv(df_mineria, file = "oro_plata.csv")


# ---------- 