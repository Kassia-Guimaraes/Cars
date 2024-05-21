library(readr)
library(ggplot2)
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(dplyr)

#Importar dados
PT_all <- read_csv("modificated-data/PT-all.csv")


#Marcas que emitem menos  CO2 (GASOLINA)
PT_all_G = PT_all[PT_all$"Fuel Type" == "G",]
make_mean_G <- tapply(PT_all_G$"Test Emission CO2 (g/km)", PT_all_G$Make, mean)

make_mean_CO2_G <- sort(make_mean_G, decreasing = FALSE)
make <- names(make_mean_CO2_G)[1:5]
make_less_polution_G <- data.frame(make, mean_CO2 = make_mean_CO2_G[1:5])

less_make_G <- names(make_mean_CO2_G)[which.min(make_mean_CO2_G)]

make_less_polution_G$Is_Min <- ifelse(make_less_polution_G$make == less_make_G, "Min", "Not Min")

color1 <- rgb(12,124,250,maxColorValue = 255)
color2 <- rgb(120,200,250, maxColorValue = 255)
make_less_polution_G$Color <- ifelse(make_less_polution_G$Is_Min == "Min", color1, color2)
make_less_polution_G$"Fuel_type" <- c(rep('G', 5)); make_less_polution_G


#Marcas que emitem menos  CO2 (GASOLEO)
PT_all_D = PT_all[PT_all$"Fuel Type" == "D",]
make_mean_D <- tapply(PT_all_D$"Test Emission CO2 (g/km)", PT_all_D$Make, mean)

make_mean_CO2_D <- sort(make_mean_D, decreasing = FALSE)
make <- names(make_mean_CO2_D)[1:5]
make_less_polution_D <- data.frame(make, mean_CO2 = make_mean_CO2_D[1:5])

less_make_D <- names(make_mean_CO2_D)[which.min(make_mean_CO2_D)]

make_less_polution_D$Is_Min <- ifelse(make_less_polution_D$make == less_make_D, "Min", "Not Min")

color1 <- rgb(12,124,250,maxColorValue = 255)
color2 <- rgb(120,200,250, maxColorValue = 255)
make_less_polution_D$Color <- ifelse(make_less_polution_D$Is_Min == "Min", color1, color2);
make_less_polution_D$"Fuel_type" <- c(rep('D', 5)); make_less_polution_D


#Marcas que emitem mais e menos  CO2 (HIBRIDOS)
PT_all_H = PT_all[PT_all$"Fuel Type" == "H",]
make_mean_H <- tapply(PT_all_H$"Test Emission CO2 (g/km)", PT_all_H$Make, mean)

make_mean_CO2_H <- sort(make_mean_H, decreasing = FALSE)
make <- names(make_mean_CO2_H)[1:5]
make_less_polution_H <- data.frame(make, mean_CO2 = make_mean_CO2_H[1:5])

less_make_H <- names(make_mean_CO2_H)[which.min(make_mean_CO2_H)]

make_less_polution_H$Is_Min <- ifelse(make_less_polution_H$make == less_make_H, "Min", "Not Min")

color1 <- rgb(12,124,250,maxColorValue = 255)
color2 <- rgb(120,200,250, maxColorValue = 255)
make_less_polution_H$Color <- ifelse(make_less_polution_H$Is_Min == "Min", color1, color2)
make_less_polution_H$"Fuel_type" <- c(rep('H', 5)); make_less_polution_H


df_concatenado <- rbind(make_less_polution_G,make_less_polution_H, make_less_polution_D); df_concatenado



ggplot(df_concatenado, aes(x = factor(Fuel_type), y = mean_CO2, fill = make)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.5) +
  scale_fill_manual(values = c("Min" = color1, "Not Min" = color2)) +
  labs(title = "10 Marcas Híbrido com menor Média de Emissão de CO2",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2, margin = margin(b = 20)))


ggplot(df_concatenado, aes(x = factor(Fuel_type), y = mean_CO2, fill = make)) +
  geom_bar(stat = "identity", position = "dodge", width = 0.5) +
  scale_fill_manual(values = df_concatenado$Color) +
  labs(title = "10 Marcas Híbrido com menor Média de Emissão de CO2",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2, margin = margin(b = 20))) +
  geom_text(aes(label = make),
            position = position_dodge(width = 0.5),
            vjust = -0.5,                                
            angle = 90,
            hjust = -0.5,
            size = 3) 