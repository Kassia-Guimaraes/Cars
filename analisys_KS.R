library(readr)

### Importando dados

consumption_eletrics <- read_csv("modificated-data/consumption-eletrics.csv")
consumption_fossilfuels <- read_csv("modificated-data/consumption-fossilfuels.csv")
consumption_hybrids <- read_csv("modificated-data/consumption-hybrids.csv")
PT_2018 <- read_csv("modificated-data/PT-2018.csv")
PT_2019 <- read_csv("modificated-data/PT-2019.csv")
PT_2020 <- read_csv("modificated-data/PT-2020.csv")
PT_2021 <- read_csv("modificated-data/PT-2021.csv")
PT_2022 <- read_csv("modificated-data/PT-2022.csv")

## Medidas Estatísticas

summary(PT_2018)
summary(PT_2019)
summary(PT_2020)
summary(PT_2021)
summary(PT_2022)


round(sd(PT_2019$`Test weight (kg)`, na.rm=TRUE),2)
round(sd(PT_2019$`Test Emission CO2 (g/km)`, na.rm=TRUE),2)
round(sd(PT_2019$`Whell Base (mm)`, na.rm=TRUE),2)
round(sd(PT_2019$`Engine Capacity (cm3)`, na.rm=TRUE),2)
round(sd(PT_2019$`Engine Power (kW)`, na.rm=TRUE),2)

?plot
table(PT_2018$Make)
table(PT_2019$Make)
table(PT_2020$Make)
table(PT_2021$Make)
table(PT_2022$Make)