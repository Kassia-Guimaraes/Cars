library(readr)
library(ggplot2)
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(dplyr)
library(gridExtra)

###### Importando dados ######
PT_all <- read_csv("modificated-data/PT-all.csv")

#Filtrar pelo ano de 2018
PT_2018 <- PT_all[PT_all$Year == "2018",]

#Filtrar pelo ano de 2019
PT_2019 <- PT_all[PT_all$Year == "2019",]

#Filtrar pelo ano de 2020
PT_2020 <- PT_all[PT_all$Year == "2020",]

#Filtrar pelo ano de 2021
PT_2021 <- PT_all[PT_all$Year == "2021",]

#Filtrar pelo ano de 2022
PT_2022 <- PT_all[PT_all$Year == "2022",]


PT_2018_without_E <- PT_2018[PT_2018$"Fuel Type" != "E",]
PT_2019_without_E <- PT_2019[PT_2019$"Fuel Type" != "E",]
PT_2020_without_E <- PT_2020[PT_2020$"Fuel Type" != "E",]
PT_2021_without_E <- PT_2021[PT_2021$"Fuel Type" != "E",]
PT_2022_without_E <- PT_2022[PT_2022$"Fuel Type" != "E",]
PT_all_without_E <- PT_all[PT_all$`Fuel Type` != 'E',]

PT_year <- c(2018,2019,2020,2021,2022)
PT_data <- c('PT_2018','PT_2019','PT_2020','PT_2021','PT_2022')


consumption_eletrics <- read_csv("modificated-data/consumption-eletrics.csv")
consumption_fossilfuels <- read_csv("modificated-data/consumption-fossilfuels.csv")
consumption_hybrids <- read_csv("modificated-data/consumption-hybrids.csv")

consumption_fossilfuels <- consumption_fossilfuels[consumption_fossilfuels$`Fuel Type`!='ET',]

fuels_price <- read_csv('modificated-data/fuels-price.csv')

#################################################################################
########### Consumo vs Combustível #################

e_color <- rgb(120,200,250, maxColorValue = 255) #eletrico
gas_color <- rgb(245,191,76,maxColorValue = 255) #gasolina 95
diesel_color <- rgb(245,140,76,maxColorValue = 255) #diesel
ehybrid_color <- rgb(12,124,250,maxColorValue = 255) #hibrido parte elétrica
fhybrid_color <- '#F5AA4C' #híbrido combistível fossil
pgas_color <- '#F5D44C' #Gasolina 98



# Criando dataframe apenas com os consumos dos combustíveis
consum_e <- data.frame('Fuel'=consumption_eletrics$`Fuel Type`,
                       'Combined'=consumption_eletrics$`Combined (E) (kWh/100 km)`)

consum_fossil <- data.frame('Fuel'=consumption_fossilfuels$`Fuel Type`,
                            'Combined'=consumption_fossilfuels$`Combined (F) (L/100 km)`)

consum_hy_ele <- data.frame('Fuel'=rep('H_E',length(consumption_hybrids$`Combined (E) (kWh/100 km)`)),
                            'Combined'=consumption_hybrids$`Combined (E) (kWh/100 km)`)

consum_hy_fos <- data.frame('Fuel'=rep('H_F', length(consumption_hybrids$`Combined (F) (L/100 km)`)),
                            'Combined'=consumption_hybrids$`Combined (F) (L/100 km)`)


fossil <- rbind(consum_fossil, consum_hy_fos)
electric <- rbind(consum_hy_ele, consum_e)

summary(fossil[fossil$Fuel=='G',]$Combined)


box_fossil <- ggplot(fossil, aes(x =Fuel, y =Combined)) +
  geom_boxplot(aes(fill =Fuel), alpha = 0.3) +
  geom_jitter(aes(color =Fuel), size = 0.3, alpha = 0.9) +
  scale_fill_viridis(discrete = TRUE, alpha = 0.6) +
  scale_color_manual(values = c("G" = gas_color, "D" = diesel_color, 
                                'PG'=pgas_color,'H_F'= fhybrid_color)) + 
  scale_fill_manual(values = c('G' = gas_color, "D" = diesel_color,
                               'PG'=pgas_color,'H_F'= fhybrid_color)) +
  scale_x_discrete(labels = c("G" = "Gasolina 95", "D" = "Diesel", 
                              'H_F'='Híbrido parte Combustível Fóssil',
                              'PG'='Gasolina 98')) + 
  labs(x = "Tipo de Combustível", y = "Consumo Combinado a Litros/100 km",
       title = "Consumo Combinado do Combustível Fóssil vs Tipo de Combustível") +
  theme_minimal() +
  theme(
    legend.position = 'none',
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, hjust = 0.5),
    axis.title.y = element_text(size = 12, hjust = 0.5),
    legend.title = element_text(size = 11, face = "bold")
  ) 



box_electric <- ggplot(electric, aes(x =Fuel, y =Combined)) +
  geom_boxplot(aes(fill =Fuel), alpha=0.3) +
  geom_jitter(aes(color =Fuel), size = 0.3, alpha = 1) +
  scale_fill_viridis(discrete = TRUE, alpha = 1) +
  scale_color_manual(values = c("H_E" = ehybrid_color,'E'=e_color)) + 
  scale_fill_manual(values = c("H_E" = ehybrid_color,'E'=e_color)) + 
  scale_x_discrete(labels = c("H_E" = "Híbrido parte Elétrico", 'E'='Elétrico')) + 
  labs(x = "Tipo de Combustível", y = "Consumo Combinado a kWh/100 km",
       title = "Consumo Combinado dos Carros Elétricos vs Tipo de Combustível") +
  theme_minimal() +
  theme(
    legend.position = 'none',
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, hjust = 0.5),
    axis.title.y = element_text(size = 12, hjust = 0.5),
    legend.title = element_text(size = 11, face = "bold")
  )

library(patchwork)
box_fossil + box_electric









