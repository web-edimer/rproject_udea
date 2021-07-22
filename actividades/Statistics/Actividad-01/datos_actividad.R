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


# ---------- EVA 2007 a 2019 -----
df_eva <- read_excel("EVA.xlsx", skip = 1) %>% 
  clean_names() %>% 
  mutate(across(c(is.character), str_to_title)) %>% 
  select(-x18) %>% 
  rename(year = ano,
         sistema_productivo = desagregacion_regional_y_o_sistema_productivo)

write_rds(df_eva, file = "EVA.rds", compress = "xz")

# --------- Alimentro ----------
library(lubridate)
df_alimentos <- read_csv("Alimentos_del_tr_pico_para_alimentaci_n_animal_-_AlimenTro.csv") %>% 
  clean_names() %>% 
  mutate(across(c(extracto_etereo, lignina:enl_rumiantes),
                as.numeric),
         fecha = as_date(fecha_recoleccion, format = "%m/%d/%Y"),
         mes = month(fecha, label = TRUE, abbr = FALSE),
         year = year(fecha)) %>% 
  select(-c(id, fecha_recoleccion)) %>% 
  relocate(fecha, year, mes, everything())

write_csv(df_alimentos, file = "alimentro.csv")

# ------------- Niveles del mar ------------
df_mar <- read_csv("Nivel_del_Mar.csv") %>% 
  clean_names() %>% 
  mutate(fecha = mdy_hms(fecha_observacion),
         year = year(fecha),
         mes = month(fecha),
         dia = day(fecha),
         hora = hour(fecha),
         tipo = pm(fecha),
         tipo = if_else(tipo == TRUE, true = "PM", false = "AM")) %>% 
  select(-fecha_observacion) %>% 
  relocate(fecha, year, mes, dia, hora, tipo, everything()) %>% 
  mutate(across(is.character, str_to_title),
         tipo = str_to_upper(tipo),
         unidad_medida = str_to_lower(unidad_medida))

write_rds(df_mar, file = "nivel_mar.rds", compress = "xz")

# -------------- Calidad de agua -----------
df_agua <- read_csv("Reporte_Calidad_Del_Agua_2015_-_2018_en_la_ciudad_de_Santiago_de_Cali.csv") %>% 
  clean_names() %>% 
  mutate(ica_ideam = as.numeric(ica_ideam),
         od_percent = as.numeric(parse_number(od_percent)),
         p_h = as.numeric(p_h),
         dqo_mg_l = as.numeric(dqo_mg_l),
         ce_m_s_cm = as.numeric(ce_m_s_cm),
         sst_mg_l = as.numeric(sst_mg_l)) %>% 
  rename(year = ano) %>% 
  select(-c(fecha, muestreo_no, cordenadas))

write_csv(df_agua, file = "calidad_agua.csv")
