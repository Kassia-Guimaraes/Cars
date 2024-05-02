library(readr)
library(ggplot2)

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
more_polution_2018 <- PT_2018[which.max(PT_2018$'Test Emission CO2 (g/km)'),]
more_polution_2019 <- PT_2019[which.max(PT_2019$'Test Emission CO2 (g/km)'),]
more_polution_2020 <- PT_2020[which.max(PT_2020$'Test Emission CO2 (g/km)'),]
more_polution_2021 <- PT_2021[which.max(PT_2021$'Test Emission CO2 (g/km)'),]
more_polution_2022 <- PT_2022[which.max(PT_2022$'Test Emission CO2 (g/km)'),]
more_polution <- rbind(more_polution_2018, more_polution_2019, more_polution_2020, more_polution_2021, more_polution_2022)

#Carros que emitem menos CO2 por ano
PT_2018_without_E <- PT_2018[PT_2018$"Fuel type" != "E",]
PT_2019_without_E <- PT_2019[PT_2019$"Fuel type" != "E",]
PT_2020_without_E <- PT_2020[PT_2020$"Fuel type" != "E",]
PT_2021_without_E <- PT_2021[PT_2021$"Fuel type" != "E",]
PT_2022_without_E <- PT_2022[PT_2022$"Fuel type" != "E",]

less_polution_2018 <- PT_2018_without_E[which.min(PT_2018_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2019 <- PT_2019_without_E[which.min(PT_2019_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2020 <- PT_2020_without_E[which.min(PT_2020_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2021 <- PT_2021_without_E[which.min(PT_2021_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2022 <- PT_2022_without_E[which.min(PT_2022_without_E$'Test Emission CO2 (g/km)'),]
less_polution <- rbind(less_polution_2018, less_polution_2019, less_polution_2020, less_polution_2021, less_polution_2022)

############################################################
#Marcas que emitem mais CO2 (HIBRIDOS, GASOLEO E GASOLINA)

PT_all_without_E <- PT_all[PT_all$"Fuel type" != "E",]
make_mean_CO2 <- tapply(PT_all_without_E$"Test Emission CO2 (g/km)", PT_all_without_E$Make, mean)

make_mean_CO2 <- sort(make_mean_CO2, decreasing = TRUE)
Make <- names(make_mean_CO2)[1:10]
make_more_polution <- data.frame(Make, mean_CO2 = make_mean_CO2[1:10])

max_make <- names(make_mean_CO2)[which.max(make_mean_CO2)]

make_more_polution$Is_Max <- ifelse(make_more_polution$Make == max_make, "Max", "Not Max")

color1 <- rgb(245,140,76,maxColorValue = 255)
color2 <- rgb(245,191,76,maxColorValue = 255)
make_more_polution$Color <- ifelse(make_more_polution$Is_Max == "Max", color1, color2)

ggplot(make_more_polution, aes(x = Make, y = mean_CO2, fill = Is_Max)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Max" = color1, "Not Max" = color2)) +
  labs(title = "10 Marcas com maior Média de Emissão de CO2",
       x = "Marcas",
       y = "Média de CO2 (g/km)")
       
#Marcas que emitem menos CO2 (HIBRIDOS, GASOLEO E GASOLINA)

PT_all_without_E <- PT_all[PT_all$"Fuel type" != "E",]
make_mean_CO2 <- tapply(PT_all_without_E$"Test Emission CO2 (g/km)", PT_all_without_E$Make, mean)

make_mean_CO2 <- sort(make_mean_CO2, decreasing = FALSE)
Make <- names(make_mean_CO2)[1:10]
make_less_polution <- data.frame(Make, mean_CO2 = make_mean_CO2[1:10])

less_make <- names(make_mean_CO2)[which.min(make_mean_CO2)]

make_less_polution$Is_Min <- ifelse(make_less_polution$Make == less_make, "Min", "Not Min")

color1 <- rgb(12,124,250,maxColorValue = 255)
color2 <- rgb(120,200,250, maxColorValue = 255)
make_less_polution$Color <- ifelse(make_less_polution$Is_Min == "Min", color1, color2)

ggplot(make_less_polution, aes(x = Make, y = mean_CO2, fill = Is_Min)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Min" = color1, "Not Min" = color2)) +
  labs(title = "10 Marcas com maior Média de Emissão de CO2",
       x = "Marcas",
       y = "Média de CO2 (g/km)")


