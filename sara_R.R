library(readr)

#Importar dados
PT_all <- read_csv("modificated-data/PT-all.csv")

#Filtrar pelo ano de 2018
regra2018 <- PT_all$Year == "2018"
PT_2018 <- PT_all[regra2018,]

#Filtrar pelo ano de 2019
regra2019 <- PT_all$Year == "2019"
PT_2019 <- PT_all[regra2019,]

#Filtrar pelo ano de 2020
regra2020 <- PT_all$Year == "2020"
PT_2020 <- PT_all[regra2020,]

#Filtrar pelo ano de 2021
regra2021 <- PT_all$Year == "2021"
PT_2021 <- PT_all[regra2021,]

#Filtrar pelo ano de 2022
regra2022 <- PT_all$Year == "2022"
PT_2022 <- PT_all[regra2022,]

#Principais Estatísticas
summary(PT_2020)

round(sd(PT_2020$"Test weight (kg)", na.rm = TRUE),2)
round(sd(PT_2020$"Test Emission CO2 (g/km)", na.rm = TRUE),2)
round(sd(PT_2020$"Whell Base (mm)", na.rm = TRUE),2)
round(sd(PT_2020$"Engine Capacity (cm3)", na.rm = TRUE),2)
round(sd(PT_2020$"Engine Power (kW)", na.rm = TRUE),2)

summary(PT_2021)

round(sd(PT_2021$"Test weight (kg)", na.rm = TRUE),2)
round(sd(PT_2021$"Test Emission CO2 (g/km)", na.rm = TRUE),2)
round(sd(PT_2021$"Whell Base (mm)", na.rm = TRUE),2)
round(sd(PT_2021$"Engine Capacity (cm3)", na.rm = TRUE),2)
round(sd(PT_2021$"Engine Power (kW)", na.rm = TRUE),2)


table(PT_2020$Make)
table(PT_2021$Make)

table(PT_2020$"Fuel type")
table(PT_2021$"Fuel type")
table(PT_all$"Fuel type")

#Carros que emitem mais CO2 por ano
more_polution_2018 = PT_2018[which.max(PT_2018$'Test Emission CO2 (g/km)'),]
more_polution_2019 = PT_2019[which.max(PT_2019$'Test Emission CO2 (g/km)'),]
more_polution_2020 = PT_2020[which.max(PT_2020$'Test Emission CO2 (g/km)'),]
more_polution_2021 = PT_2021[which.max(PT_2021$'Test Emission CO2 (g/km)'),]
more_polution_2022 = PT_2022[which.max(PT_2022$'Test Emission CO2 (g/km)'),]
more_polution <- rbind(more_polution_2018, more_polution_2019, more_polution_2020, more_polution_2021, more_polution_2022)

#Carros que emitem menos CO2 por ano
PT_2018_without_E = PT_2018[PT_2018$"Fuel type" != "E",]
PT_2019_without_E = PT_2019[PT_2019$"Fuel type" != "E",]
PT_2020_without_E = PT_2020[PT_2020$"Fuel type" != "E",]
PT_2021_without_E = PT_2021[PT_2021$"Fuel type" != "E",]
PT_2022_without_E = PT_2022[PT_2022$"Fuel type" != "E",]

less_polution_2018 = PT_2018_without_E[which.min(PT_2018_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2019 = PT_2019_without_E[which.min(PT_2019_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2020 = PT_2020_without_E[which.min(PT_2020_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2021 = PT_2021_without_E[which.min(PT_2021_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2022 = PT_2022_without_E[which.min(PT_2022_without_E$'Test Emission CO2 (g/km)'),]
less_polution <- rbind(less_polution_2018, less_polution_2019, less_polution_2020, less_polution_2021, less_polution_2022)


