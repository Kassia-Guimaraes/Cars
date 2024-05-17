library(readr)
library(ggplot2)
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(dplyr)
library(gridExtra)

################################EMISSÕES CO2####################################
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

round(sd(PT_2020$"Test Weight (kg)", na.rm = TRUE),2)
round(sd(PT_2020$"Test Emission CO2 (g/km)", na.rm = TRUE),2)
round(sd(PT_2020$"Wheel Base (mm)", na.rm = TRUE),2)
round(sd(PT_2020$"Engine Capacity (cm3)", na.rm = TRUE),2)
round(sd(PT_2020$"Engine Power (kW)", na.rm = TRUE),2)

summary(PT_2021)

round(sd(PT_2021$"Test Weight (kg)", na.rm = TRUE),2)
round(sd(PT_2021$"Test Emission CO2 (g/km)", na.rm = TRUE),2)
round(sd(PT_2021$"Wheel Base (mm)", na.rm = TRUE),2)
round(sd(PT_2021$"Engine Capacity (cm3)", na.rm = TRUE),2)
round(sd(PT_2021$"Engine Power (kW)", na.rm = TRUE),2)


table(PT_2020$Make)
table(PT_2021$Make)

table(PT_2020$"Fuel Type")
table(PT_2021$"Fuel Type")
table(PT_all$"Fuel Type")

#Carros que emitem mais CO2 por ano
more_polution_2018 <- PT_2018[which.max(PT_2018$'Test Emission CO2 (g/km)'),]
more_polution_2019 <- PT_2019[which.max(PT_2019$'Test Emission CO2 (g/km)'),]
more_polution_2020 <- PT_2020[which.max(PT_2020$'Test Emission CO2 (g/km)'),]
more_polution_2021 <- PT_2021[which.max(PT_2021$'Test Emission CO2 (g/km)'),]
more_polution_2022 <- PT_2022[which.max(PT_2022$'Test Emission CO2 (g/km)'),]
more_polution <- rbind(more_polution_2018, more_polution_2019, more_polution_2020, more_polution_2021, more_polution_2022)

#Carros que emitem menos CO2 por ano
PT_2018_without_E <- PT_2018[PT_2018$"Fuel Type" != "E",]
PT_2019_without_E <- PT_2019[PT_2019$"Fuel Type" != "E",]
PT_2020_without_E <- PT_2020[PT_2020$"Fuel Type" != "E",]
PT_2021_without_E <- PT_2021[PT_2021$"Fuel Type" != "E",]
PT_2022_without_E <- PT_2022[PT_2022$"Fuel Type" != "E",]

less_polution_2018 <- PT_2018_without_E[which.min(PT_2018_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2019 <- PT_2019_without_E[which.min(PT_2019_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2020 <- PT_2020_without_E[which.min(PT_2020_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2021 <- PT_2021_without_E[which.min(PT_2021_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2022 <- PT_2022_without_E[which.min(PT_2022_without_E$'Test Emission CO2 (g/km)'),]
less_polution <- rbind(less_polution_2018, less_polution_2019, less_polution_2020, less_polution_2021, less_polution_2022)

############################################################
#Marcas que emitem mais CO2 (HIBRIDOS, GASOLEO E GASOLINA)

PT_all_without_E <- PT_all[PT_all$"Fuel Type" != "E",]
make_mean_CO2 <- tapply(PT_all_without_E$"Test Emission CO2 (g/km)", PT_all_without_E$Make, mean)

make_mean_CO2 <- sort(make_mean_CO2, decreasing = TRUE)
Make <- names(make_mean_CO2)[1:10]
make_more_polution <- data.frame(Make, mean_CO2 = make_mean_CO2[1:10])

max_make <- names(make_mean_CO2)[which.max(make_mean_CO2)]

make_more_polution$Is_Max <- ifelse(make_more_polution$Make == max_make, "Max", "Not Max")

color1 <- rgb(245,140,76,maxColorValue = 255)
color2 <- rgb(245,191,76,maxColorValue = 255)
make_more_polution$Color <- ifelse(make_more_polution$Is_Max == "Max", color1, color2)

make_more_CO2<-ggplot(make_more_polution, aes(x = Make, y = mean_CO2, fill = Is_Max)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Max" = color1, "Not Max" = color2)) +
  theme_minimal() +
  labs(title = "10 Marcas com maior Média de Emissão de CO2",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  guides(fill=FALSE) +
  scale_y_continuous(limits = c(0, 600), breaks = seq(0, 600, by = 50)) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2, margin = margin(b = 20)))
ggsave("make_more_CO2.jpg", plot = make_more_CO2, width = 14, height = 6, units = "in"); make_more_CO2
       
#Marcas que emitem menos CO2 (HIBRIDOS, GASOLEO E GASOLINA)

PT_all_without_E <- PT_all[PT_all$"Fuel Type" != "E",]
make_mean_CO2 <- tapply(PT_all_without_E$"Test Emission CO2 (g/km)", PT_all_without_E$Make, mean);

make_mean_CO2 <- sort(make_mean_CO2, decreasing = FALSE)
Make <- names(make_mean_CO2)[1:10]
make_less_polution <- data.frame(Make, mean_CO2 = make_mean_CO2[1:10])

less_make <- names(make_mean_CO2)[which.min(make_mean_CO2)]

make_less_polution$Is_Min <- ifelse(make_less_polution$Make == less_make, "Min", "Not Min")

color1 <- rgb(12,124,250,maxColorValue = 255)
color2 <- rgb(120,200,250, maxColorValue = 255)
make_less_polution$Color <- ifelse(make_less_polution$Is_Min == "Min", color1, color2);

make_less_CO2<-ggplot(make_less_polution, aes(x = Make, y = mean_CO2, fill = Is_Min)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Min" = color1, "Not Min" = color2)) +
  theme_ipsum() +
  labs(title = "10 Marcas com menor Média de Emissão de CO2",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  guides(fill=FALSE) +
  scale_y_continuous(limits = c(0, 600), breaks = seq(0, 600, by = 50)) +
  theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2, margin = margin(b = 20)))
ggsave("make_less_CO2.jpg", plot = make_less_CO2, width = 14, height = 6, units = "in"); make_less_CO2

#Marcas que emitem mais e menos  CO2 (GASOLINA)
PT_all_G = PT_all[PT_all$"Fuel Type" == "G",]
make_mean_G <- tapply(PT_all_G$"Test Emission CO2 (g/km)", PT_all_G$Make, mean)

make_mean_CO2_G <- sort(make_mean_G, decreasing = FALSE)
make_G <- names(make_mean_CO2_G)[1:10]
make_less_polution_G <- data.frame(make_G, mean_CO2_G = make_mean_CO2_G[1:10])

less_make_G <- names(make_mean_CO2_G)[which.min(make_mean_CO2_G)]

make_less_polution_G$Is_Min <- ifelse(make_less_polution_G$make_G == less_make_G, "Min", "Not Min")

color1 <- rgb(12,124,250,maxColorValue = 255)
color2 <- rgb(120,200,250, maxColorValue = 255)
make_less_polution_G$Color <- ifelse(make_less_polution_G$Is_Min == "Min", color1, color2)
make_less_polution_G$make_G <- ifelse(make_less_polution_G$make_G == "Mitsubishi Motors (Thailand)", "Mitsubishi Motors", make_less_polution_G$make_G)

gasolina_less <- ggplot(make_less_polution_G, aes(x = make_G, y = mean_CO2_G, fill = Is_Min)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Min" = color1, "Not Min" = color2)) +
  labs(title = "Marcas com menor Média de Emissão de CO2",
       subtitle = "Gasolina",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  guides(fill=FALSE) +
  scale_y_continuous(limits = c(0, 500), breaks = seq(0, 500, by = 50)) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2),
    plot.subtitle = element_text(size = 12, hjust = 0.5, margin = margin(t = 2)))
ggsave("gasolina_less.jpg", plot = gasolina_less, width = 14, height = 6, units = "in"); 
gasolina_less

make_mean_more_CO2_G <- sort(make_mean_G, decreasing = TRUE)
make_more_G <- names(make_mean_more_CO2_G)[1:10]
make_more_polution_G <- data.frame(make_more_G, mean_more_CO2_G = make_mean_more_CO2_G[1:10])

max_make_G <- names(make_mean_more_CO2_G)[which.max(make_mean_more_CO2_G)]

make_more_polution_G$Is_Max <- ifelse(make_more_polution_G$make_more_G == max_make_G, "Max", "Not Max")

color3 <- rgb(245,140,76,maxColorValue = 255)
color4 <- rgb(245,191,76,maxColorValue = 255)
make_more_polution_G$Color <- ifelse(make_more_polution_G$Is_Max == "Max", color3, color4)

gasolina_more<-ggplot(make_more_polution_G, aes(x = make_more_G, y = mean_more_CO2_G, fill = Is_Max)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Max" = color3, "Not Max" = color4)) +
  labs(title = "Marcas com maior Média de Emissão de CO2",
       subtitle = "Gasolina",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  guides(fill=FALSE) +
  scale_y_continuous(limits = c(0, 500), breaks = seq(0, 500, by = 50)) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2),
    plot.subtitle = element_text(size = 12, hjust = 0.5, margin = margin(t = 2)))
ggsave("gasolina_more.jpg", plot = gasolina_more, width = 14, height = 6, units = "in"); gasolina_more

#Marcas que emitem mais e menos  CO2 (GASOLEO)
PT_all_D = PT_all[PT_all$"Fuel Type" == "D",]
make_mean_D <- tapply(PT_all_D$"Test Emission CO2 (g/km)", PT_all_D$Make, mean)

make_mean_CO2_D <- sort(make_mean_D, decreasing = FALSE)
make_D <- names(make_mean_CO2_D)[1:10]
make_less_polution_D <- data.frame(make_D, mean_CO2_D = make_mean_CO2_D[1:10])

less_make_D <- names(make_mean_CO2_D)[which.min(make_mean_CO2_D)]

make_less_polution_D$Is_Min <- ifelse(make_less_polution_D$make_D == less_make_D, "Min", "Not Min")

color1 <- rgb(12,124,250,maxColorValue = 255)
color2 <- rgb(120,200,250, maxColorValue = 255)
make_less_polution_D$Color <- ifelse(make_less_polution_D$Is_Min == "Min", color1, color2);

gasoleo_less<-ggplot(make_less_polution_D, aes(x = make_D, y = mean_CO2_D, fill = Is_Min)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Min" = color1, "Not Min" = color2)) +
  labs(title = "Marcas com menor Média de Emissão de CO2",
       subtitle = "Diesel",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  guides(fill=FALSE) +
  scale_y_continuous(limits = c(0, 500), breaks = seq(0, 500, by = 50)) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2),
    plot.subtitle = element_text(size = 12, hjust = 0.5, margin = margin(t = 2)))
ggsave("gasoleo_less.jpg", plot = gasoleo_less, width = 14, height = 6, units = "in"); gasoleo_less


make_mean_more_CO2_D <- sort(make_mean_D, decreasing = TRUE)
make_more_D <- names(make_mean_more_CO2_D)[1:10]
make_more_polution_D <- data.frame(make_more_D, mean_more_CO2_D = make_mean_more_CO2_D[1:10])

max_make_D <- names(make_mean_more_CO2_D)[which.max(make_mean_more_CO2_D)]

make_more_polution_D$Is_Max <- ifelse(make_more_polution_D$make_more_D == max_make_D, "Max", "Not Max")

color3 <- rgb(245,140,76,maxColorValue = 255)
color4 <- rgb(245,191,76,maxColorValue = 255)
make_more_polution_D$Color <- ifelse(make_more_polution_D$Is_Max == "Max", color3, color4)

gasoleo_more<-ggplot(make_more_polution_D, aes(x = make_more_D, y = mean_more_CO2_D, fill = Is_Max)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Max" = color3, "Not Max" = color4)) +
  labs(title = "Marcas com maior Média de Emissão de CO2",
       subtitle = "Diesel",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  guides(fill=FALSE) +
  scale_y_continuous(limits = c(0, 500), breaks = seq(0, 500, by = 50)) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2),
    plot.subtitle = element_text(size = 12, hjust = 0.5, margin = margin(t = 2)))
ggsave("gasoleo_more.jpg", plot = gasoleo_more, width = 14, height = 6, units = "in"); gasoleo_more

#Marcas que emitem mais e menos  CO2 (HIBRIDOS)
PT_all_H = PT_all[PT_all$"Fuel Type" == "H",]
make_mean_H <- tapply(PT_all_H$"Test Emission CO2 (g/km)", PT_all_H$Make, mean)

make_mean_CO2_H <- sort(make_mean_H, decreasing = FALSE)
make_H <- names(make_mean_CO2_H)[1:10]
make_less_polution_H <- data.frame(make_H, mean_CO2_H = make_mean_CO2_H[1:10])

less_make_H <- names(make_mean_CO2_H)[which.min(make_mean_CO2_H)]

make_less_polution_H$Is_Min <- ifelse(make_less_polution_H$make_H == less_make_H, "Min", "Not Min")

color1 <- rgb(12,124,250,maxColorValue = 255)
color2 <- rgb(120,200,250, maxColorValue = 255)
make_less_polution_H$Color <- ifelse(make_less_polution_H$Is_Min == "Min", color1, color2)


hibrido_less<-ggplot(make_less_polution_H, aes(x = make_H, y = mean_CO2_H, fill = Is_Min)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Min" = color1, "Not Min" = color2)) +
  labs(title = "Marcas com menor Média de Emissão de CO2",
       subtitle = "Híbridos",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  guides(fill=FALSE) +
  scale_y_continuous(limits = c(0, 500), breaks = seq(0, 500, by = 50)) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2),
    plot.subtitle = element_text(size = 12, hjust = 0.5, margin = margin(t = 2)))
ggsave("hibrido_less.jpg", plot = hibrido_less, width = 14, height = 6, units = "in"); hibrido_less

make_mean_more_CO2_H <- sort(make_mean_H, decreasing = TRUE)
make_more_H <- names(make_mean_more_CO2_H)[1:10]
make_more_polution_H <- data.frame(make_more_H, mean_more_CO2_H = make_mean_more_CO2_H[1:10])

max_make_H <- names(make_mean_more_CO2_H)[which.max(make_mean_more_CO2_H)]

make_more_polution_H$Is_Max <- ifelse(make_more_polution_H$make_more_H == max_make_H, "Max", "Not Max")

color3 <- rgb(245,140,76,maxColorValue = 255)
color4 <- rgb(245,191,76,maxColorValue = 255)
make_more_polution_H$Color <- ifelse(make_more_polution_H$Is_Max == "Max", color3, color4)

hibrido_more<-ggplot(make_more_polution_H, aes(x = make_more_H, y = mean_more_CO2_H, fill = Is_Max)) +
  geom_bar(stat = "identity", width = 0.5) +
  scale_fill_manual(values = c("Max" = color3, "Not Max" = color4)) +
  labs(title = "Marcas com maior Média de Emissão de CO2",
       subtitle = "Híbridos",
       x = "Marcas",
       y = "Média de CO2 (g/km)") +
  theme_minimal() +
  guides(fill=FALSE) +
  scale_y_continuous(limits = c(0, 500), breaks = seq(0, 500, by = 50)) +
  theme(
    plot.title = element_text(hjust = 0.5, face = "bold", size = 16, lineheight = 1.2),
    plot.subtitle = element_text(size = 12, hjust = 0.5, margin = margin(t = 2)))
ggsave("hibrido_more.jpg", plot = hibrido_more, width = 14, height = 6, units = "in"); hibrido_more

grid.arrange(gasolina_less, gasoleo_less, hibrido_less, nrow = 3)
grid.arrange(gasolina_more, gasoleo_more, hibrido_more, nrow = 3)

#Boxplot com variavel categórica (fuel type) e variaveis quantitativa (emissão de CO2)

PT_all_without_E$`Fuel Type` = with(PT_all_without_E, reorder(`Fuel Type`, `Test Emission CO2 (g/km)`, median))

color1 <- rgb(245,140,76,maxColorValue = 255)
color2 <- rgb(245,191,76,maxColorValue = 255)
color3 <- rgb(12,124,250,maxColorValue = 255)

boxpot <- ggplot(PT_all_without_E, aes(x =`Fuel Type`, y =`Test Emission CO2 (g/km)`)) +
  geom_boxplot(aes(fill =`Fuel Type`)) +
  geom_jitter(aes(color =`Fuel Type`), size = 0.3, alpha = 0.9) +
  scale_fill_viridis(discrete = TRUE, alpha = 0.6) +
  scale_color_manual(values = c("G" = color2, "D" = color1, "H" = color3)) + # Definir as cores para cada tipo de combustível
  scale_x_discrete(labels = c("G" = "Gasolina", "D" = "Diesel", "H" = "Híbrido")) + # Alterar o nome das categorias
  labs(x = "Tipo de Combustível", y = "Emissões de CO2 (g/km)") +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 11, face = "bold", hjust = 0.5)) +
  ggtitle("Emissões de CO2 (g/km) por tipo de Combustível")
ggsave("boxplot.jpg", plot = boxpot, width = 8, height = 6, units = "in")

#Gráfico circular com o número das marcas

################################CONSUMO####################################

fossilfuels <- read_csv("modificated-data/consumption-fossilfuels.csv")

hybrids <- read_csv("modificated-data/consumption-hybrids.csv")

eletrics <- read_csv("modificated-data/consumption-eletrics.csv")


#Gráfico de dispersão 

#Cilindradas (cm3) vs Consumo (L/100km), em carros a Combustivel Fossil

cor(fossilfuels$`Engine Capacity (cm3)`, fossilfuels$`Combined (F) (L/100 km)`) #0.8308465
cilind_fossilfuel<-ggplot(fossilfuels, aes(x= `Engine Capacity (cm3)`, y= `Combined (F) (L/100 km)`)) +
  geom_point(color = rgb(245,191,76,maxColorValue = 255)) +
  theme_minimal() +
  geom_smooth(method=lm , color="seagreen3", se=FALSE) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5)) +
  ggtitle("Cilindradas (cm3) vs Consumo (L/100km), em carros a Combustível Fóssil") +
  labs(x = "Cilindradas (cm3)", y = "Consumo (L/100km)"); cilind_fossilfuel
ggsave("cilind_fossilfuel.jpg", plot = cilind_fossilfuel, width = 10, height = 6, units = "in")


#Cilindradas (cm3) vs Consumo (Le/100km), em carros Híbridos

cor(hybrids$`Engine Capacity (cm3)`, hybrids$`Combined (E) (Le/100 km)`) #0.6961299
cilind_hybrids<-ggplot(hybrids, aes(x= `Engine Capacity (cm3)`, y= `Combined (E) (Le/100 km)`)) +
  geom_point(color = rgb(12,124,250,maxColorValue = 255)) +
  theme_minimal() +
  geom_smooth(method=lm , color="seagreen3", se=FALSE) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5)) +
  ggtitle("Cilindradas (cm3) vs Consumo (Le/100km), em carros Híbridos")+
  labs(x = "Cilindradas (cm3)", y = "Consumo (Le/100km)"); cilind_hybrids
ggsave("cilind_hybrids.jpg", plot = cilind_hybrids, width = 10, height = 6, units = "in")


#Potência (cm3) vs Consumo (Le/100km), em carros Elétricos

cor(eletrics$`Engine Power (kW)`, eletrics$`Combined (E) (Le/100 km)`) #0.3932756
cilind_eletrics<-ggplot(eletrics, aes(x= `Engine Power (kW)`, y= `Combined (E) (Le/100 km)`)) +
  geom_point(color = rgb(120,200,250, maxColorValue = 255)) +
  theme_minimal() +
  geom_smooth(method=lm , color="seagreen3", se=FALSE) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5)) +
  ggtitle("Potência (kw) vs Consumo (Le/100km), em carros Elétricos") +
  labs(x = "Potência (kW)", y = "Consumo (Le/100km)"); cilind_eletrics
ggsave("cilind_eletrics.jpg", plot = cilind_eletrics, width = 10, height = 6, units = "in")


#Potência (cm3) vs Consumo (kwh/100km), em carros Elétricos

cor(eletrics$`Engine Power (kW)`, eletrics$`Combined (E) (kWh/100 km)`) #0.4006072
cilind_eletrics1<-ggplot(eletrics, aes(x= `Engine Power (kW)`, y= `Combined (E) (kWh/100 km)`)) +
  geom_point(color = rgb(120,200,250, maxColorValue = 255)) +
  theme_minimal() +
  geom_smooth(method=lm , color="seagreen3", se=FALSE) +
  theme_minimal() +
  theme(
    legend.position = "none",
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5)) +
  ggtitle("Potência (kw) vs Consumo (kwh/100km), em carros Elétricos") +
  labs(x = "Potência (kW)", y = "Consumo (kWh/100 km)"); cilind_eletrics1
ggsave("cilind_eletrics1.jpg", plot = cilind_eletrics1, width = 10, height = 6, units = "in")
