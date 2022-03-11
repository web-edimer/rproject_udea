library(tidyverse)
library(janitor)
library(stringi)

agricola <-
  read_csv("data/Areas_cultivadas_y_produccion_agr_cola_en_Antioquia_desde_1990.csv") %>%
  clean_names() %>%
  filter(rubro == "Café") %>%
  filter(subregion != "Bajo Cauca") %>%
  rename(periodo = ano) %>% 
  select(-c(tipo, rubro))

write_csv(x = agricola, file = "Agricola-Depurada.csv")