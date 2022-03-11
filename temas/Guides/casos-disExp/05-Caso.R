library(tidyverse)
library(janitor)
library(stringi)

papa <-
  read_csv("data/paper-machinelarning.csv") %>%
  select(
    -c(
      DOYplantation,
      DateRecolte,
      DOYrecolte,
      Long_SC,
      pHactifMethode,
      MOouCtot,
      ExtractifMethode,
      AlSolTabi,
      RendRejet,
      SerieSol,
      SableCentroid,
      SableCentroid,
      SerieSol,
      m.3a,
      m.3b,
      m.3c,
      ArgileCentroid,
      Bsol,
      RendGros,
      RendMoy,
      RendPetit,
      PoidsSpec,
      NoEssai
    )
  ) %>%
  rename(Yield = RendVendable)

write_csv(x = papa, file = "PapaCanadá-Depurada.csv")