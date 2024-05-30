library(readr)
library(ggplot2)
library(tidyverse)
library(hrbrthemes)
library(viridis)
library(dplyr)

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

consumption_eletrics <- read_csv("modificated-data/consumption-eletrics.csv")
consumption_fossilfuels <- read_csv("modificated-data/consumption-fossilfuels.csv")
consumption_hybrids <- read_csv("modificated-data/consumption-hybrids.csv")

consumption_fossilfuels <- consumption_fossilfuels[consumption_fossilfuels$`Fuel Type`!='ET',]

fuels_price <- read_csv('modificated-data/fuels-price.csv')


###### Medidas Estatísticas ######

summary(PT_2018)
summary(PT_2019)
summary(PT_2020)
summary(PT_2021)
summary(PT_2022)


round(sd(PT_2019$`Test Weight (kg)`, na.rm=TRUE),2)
round(sd(PT_2019$`Test Emission CO2 (g/km)`, na.rm=TRUE),2)
round(sd(PT_2019$`Wheel Base (mm)`, na.rm=TRUE),2)
round(sd(PT_2019$`Engine Capacity (cm3)`, na.rm=TRUE),2)
round(sd(PT_2019$`Engine Power (kW)`, na.rm=TRUE),2)


table(PT_2018$Make)
table(PT_2019$Make)
table(PT_2020$Make)
table(PT_2021$Make)
table(PT_2022$Make)

table(PT_2018$"Fuel Type")
table(PT_2019$"Fuel Type")
table(PT_2020$"Fuel Type")
table(PT_2021$"Fuel Type")
table(PT_2022$`Fuel Type`)
table(PT_all$"Fuel Type")


summary(consumption_eletrics)

###### Carros que entraram em circulação ######

PT_year <- c(2018,2019,2020,2021,2022)
PT_data <- c('PT_2018','PT_2019','PT_2020','PT_2021','PT_2022')

for (df_name in PT_data){
  df <- get(df_name)
  
  max_brand <- max(table(df$Make))
  min_brand <- min(table(df$Make))
  
  name_max <- names(table(df$Make))[table(df$Make) == max_brand] #carros que mais entraram em circulação
  name_min <- names(table(df$Make))[table(df$Make) == min_brand] #carros que menos entraram em circulação
  
  cat(df_name,'\nMAX:', name_max,max_brand,'\nMIN: ',name_min,min_brand,'\n\n')
}

for (df_name in PT_data){
  df <- get(df_name)
  
  max_model <- max(table(df$Model))
  
  name_max <- names(table(df$Model))[table(df$Model) == max_model]
  
  cat(df_name,'\nMAX:', name_max,max_model,'\n\n\n')
}




###### TOP carros que mais/menos emitem ######

more_polution_2018 <- PT_2018[which.max(PT_2018$'Test Emission CO2 (g/km)'),]
more_polution_2019 <- PT_2019[which.max(PT_2019$'Test Emission CO2 (g/km)'),]
more_polution_2020 <- PT_2020[which.max(PT_2020$'Test Emission CO2 (g/km)'),]
more_polution_2021 <- PT_2021[which.max(PT_2021$'Test Emission CO2 (g/km)'),]
more_polution_2022 <- PT_2022[which.max(PT_2022$'Test Emission CO2 (g/km)'),]
more_polution <- rbind(more_polution_2018, more_polution_2019, more_polution_2020, more_polution_2021, more_polution_2022)



PT_2018_without_E <- PT_2018[PT_2018$"Fuel Type" != "E",]
PT_2019_without_E <- PT_2019[PT_2019$"Fuel Type" != "E",]
PT_2020_without_E <- PT_2020[PT_2020$"Fuel Type" != "E",]
PT_2021_without_E <- PT_2021[PT_2021$"Fuel Type" != "E",]
PT_2022_without_E <- PT_2022[PT_2022$"Fuel Type" != "E",]
PT_all_without_E <- PT_all[PT_all$`Fuel Type` != 'E',]


less_polution_2018 <- PT_2018_without_E[which.min(PT_2018_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2019 <- PT_2019_without_E[which.min(PT_2019_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2020 <- PT_2020_without_E[which.min(PT_2020_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2021 <- PT_2021_without_E[which.min(PT_2021_without_E$'Test Emission CO2 (g/km)'),]
less_polution_2022 <- PT_2022_without_E[which.min(PT_2022_without_E$'Test Emission CO2 (g/km)'),]
less_polution <- rbind(less_polution_2018, less_polution_2019, less_polution_2020, less_polution_2021, less_polution_2022)



############################################
################## Cores ##################

e_color <- rgb(120,200,250, maxColorValue = 255) #eletrico
gas_color <- rgb(245,191,76,maxColorValue = 255) #gasolina 95
diesel_color <- rgb(245,140,76,maxColorValue = 255) #diesel
ehybrid_color <- rgb(12,124,250,maxColorValue = 255) #hibrido parte elétrica
fhybrid_color <- '#F5AA4C' #híbrido combistível fossil
pgas_color <- '#F5D44C' #Gasolina 98



############################################
#### Frequência de combustíveis por ano ####

PT_data <- c('PT_2018','PT_2019','PT_2020','PT_2021','PT_2022')
lista_dfs <- list() #lista para guardar dataframes

tapply(PT_all$ID, PT_all$Year, length)

for (df_name in PT_data) {
  get_df <- get(df_name)
  
  fuels_type <- names(table(get_df$"Fuel Type"))
  cores <- c(rgb(245,140,76,maxColorValue = 255), #diesel 
             rgb(120,200,250, maxColorValue = 255), #eletrico
             rgb(245,191,76,maxColorValue = 255), #gasolina
             rgb(12,124,250,maxColorValue = 255)) #hibrido
  
  df <- as.data.frame(table(get_df$`Fuel Type`))
  
  # Adiciona uma coluna com o ano de acontecimento
  df$Ano <- as.numeric(substring(df_name, 4, 7))  # Extrai o ano do nome do dataframe
  
  # Adiciona o dataframe à lista
  lista_dfs[[df_name]] <- df
}

# Concatena os dataframes da lista
df_concatenado <- do.call(rbind, lista_dfs); df_concatenado


ggplot(df_concatenado, aes(x = factor(Ano), y = Freq, fill = Var1)) +
  geom_bar(stat = "identity", position = "dodge") +
  labs(title = "Frequência de Carros pelo Combustível por Ano",
       x = "Ano", y = "Frequência de Carros em Circulação") +
  theme_ipsum() +
  theme(
    legend.position = "right",
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, hjust = 0.5),
    axis.title.y = element_text(size = 12, hjust = 0.5),
    legend.title = element_text(size = 11, face = "bold")
  ) +
  scale_fill_manual(values = c(D=cores[1], E=cores[2], G=cores[3], H=cores[4]),
                    labels = c(D='Diesel', E='Elétrico', G='Gasolina', H='Híbrido'),
                    name = "Combustível")


############################################
########### Cilindradas vs CO2 #############

gas <- PT_all[PT_all$'Fuel Type'=='G',]
diesel <- PT_all[PT_all$'Fuel Type'=='D',]
hybrids <- PT_all[PT_all$'Fuel Type'=='H',]

round(cor(gas$`Engine Capacity (cm3)`,gas$`Test Emission CO2 (g/km)`),3)
round(cor(diesel$`Engine Capacity (cm3)`,diesel$`Test Emission CO2 (g/km)`),3)
round(cor(hybrids$`Engine Capacity (cm3)`,hybrids$`Test Emission CO2 (g/km)`),3)

gasoline_co2 <- ggplot(gas, aes(x=`Engine Capacity (cm3)`,
                y=`Test Emission CO2 (g/km)`))+
  geom_point(color=cores[3]) +
  geom_smooth(method=lm, se=FALSE) +
  labs(title = 'Cilindradas de Carros a Gasolina vs Emissão CO2',
       x = 'Cilindradas', y = 'Emissão de CO2') +
  theme_ipsum() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, hjust = 0.5),
    axis.title.y = element_text(size = 12, hjust = 0.5)
  )
  


diesel_co2 <- ggplot(diesel, aes(x=`Engine Capacity (cm3)`,
                   y=`Test Emission CO2 (g/km)`))+
  geom_point(color=cores[1])+
  geom_smooth(method=lm, se=FALSE)+
  labs(title = 'Cilindradas de Carros a Diesel vs Emissão CO2',
       x = 'Cilindradas', y = 'Emissão de CO2') +
  theme_ipsum() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, hjust = 0.5),
    axis.title.y = element_text(size = 12, hjust = 0.5)
  )


hybrid_co2 <- ggplot(hybrids, aes(x=`Engine Capacity (cm3)`,
                    y=`Test Emission CO2 (g/km)`))+
  geom_point(color=cores[4])+
  geom_smooth(method=lm, se=FALSE)+
  labs(title = 'Cilindradas dos Híbridos vs Emissão CO2',
       x = 'Cilindradas', y = 'Emissão de CO2') +
  theme_ipsum() +
  theme(
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, hjust = 0.5),
    axis.title.y = element_text(size = 12, hjust = 0.5)
  )

library(patchwork)
gasoline_co2 + diesel_co2 + hybrid_co2



############################################
######## Emissões pelos anos ###############

year_mean_CO2 <- tapply(PT_all$`Test Emission CO2 (g/km)`, 
                        PT_all$Year, mean); year_mean_CO2

years <- names(year_mean_CO2); years

dados <- data.frame(ano = years, media_CO2 = year_mean_CO2); dados


df1 <- df_concatenado[df_concatenado$Var1=='E',]; df1 #pegando a quantidade dos carros elétricos de cada ano
df1 <- mutate(df1, Freq = Freq/100); df1 #dividindo por 100 para conseguir fazer a correlação carros e co2

eletric_CO2 <- data.frame(Freq = numeric(nrow(dados)+nrow(df1)), 
                          Var1 = numeric(nrow(dados)+nrow(df1)),
                          Ano = numeric(nrow(dados)+nrow(df1))); eletric_CO2

eletric_CO2$Freq <- c((df1$Freq),round(dados$media_CO2, 2)); eletric_CO2
eletric_CO2$Var1 <- c(rep('E',5),rep('Media_CO2',5)); eletric_CO2
eletric_CO2$Ano <- df1$Ano; eletric_CO2



ggplot(eletric_CO2, aes(x = factor(Ano), y = Freq, group=Var1, label=Freq)) +
  geom_line(aes(color=Var1)) +
  geom_point(aes(color=Var1)) +
  labs(title = "Frequência de Carros Elétricos vs Média Emissão CO2 por Ano",
       x = "Ano", 
       y = "")+
  theme_ipsum() +
  theme(
    legend.position = "right",
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, hjust = 0.5),
    axis.title.y = element_text(size = 12, hjust = 0.5),
    legend.title = element_text(size = 11, face = "bold")
  ) +
  scale_fill_manual(values = c(E=e_color, Media_CO2='red'),
                    labels = c(E='Elétrico', Media_CO2='Média CO2')) +
  geom_text(nudge_y = 8) + 
  guides(color = guide_legend(title = "Dados"))




###################################################################
######### Frequencia carros vs Emissão CO2 #######################

lista_dfs <- list() #lista para guardar dataframes
PT_year <- c(2018,2019,2020,2021,2022)
PT_data <- c('PT_2018','PT_2019','PT_2020','PT_2021','PT_2022')

cores <- c(rgb(245,140,76,maxColorValue = 255), #diesel 
           rgb(120,200,250, maxColorValue = 255), #eletrico
           rgb(245,191,76,maxColorValue = 255), #gasolina
           rgb(12,124,250,maxColorValue = 255)) #hibrido


for (df_name in PT_data) {
  get_df <- get(df_name) #puxa o dataframe
  
  fuels_type <- names(table(get_df$"Fuel Type")); #pega os tipos de combustíveis
  
  dados_ano <- as.data.frame(table(get_df$`Fuel Type`)); #pega a quantidade de carros com aquele combustível no ano
  
  # Adiciona uma coluna com o ano de acontecimento
  dados_ano$Ano <- as.numeric(substring(df_name, 4, 7))  # Extrai o ano do nome do dataframe
  
  # Adiciona o dataframe à lista
  lista_dfs[[df_name]] <- dados_ano
}


# Concatena os dataframes da lista
df1 <- do.call(rbind, lista_dfs) #junta todas as linhas feitas pelo 'for'

year_mean_CO2 <- tapply(PT_all$`Test Emission CO2 (g/km)`, 
                        PT_all$Year, mean) #faz a média da emissão co2 por ano
years <- names(year_mean_CO2)
df2 <- data.frame(Ano = years,Media_CO2 = year_mean_CO2) #cria um dataframe com as colunas ano e media_co2


df_completo <- merge(df1, df2, by = "Ano", fill = NA); head(df_completo) #junta os dataframes por coluna agrupando por ano

ggplot(df_completo) +
  geom_bar(aes(x = Ano, y = Freq/1000, fill = Var1),
           stat = 'identity', position = 'dodge') +
  geom_line(aes(x = Ano, y = Media_CO2, colour = 'Média Emissão de CO2'),  # Change color to cyan
            stat = "identity", size = 0.5) +
  geom_point(aes(x = Ano, y = Media_CO2), color='red',size=2) +
  geom_text(aes(x = Ano, y = Media_CO2, label = round(Media_CO2,2)),
            nudge_y = 5) +
  labs(title = 'Frequência de Carros por Combustível vs Emissão de CO2 por Ano',
       x = 'Ano', y = 'Frequência de Carros em Circulação a Cada Mil Carros') +
  theme_ipsum() +
  theme(
    legend.position = "right",
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    axis.title.x = element_text(size = 12, hjust = 0.5),
    axis.title.y = element_text(size = 12, hjust = 0.5),
    legend.title = element_text(size = 11, face = "bold")
  ) +
  scale_fill_manual(values = c(D=cores[1], E=cores[2], G=cores[3], H=cores[4]),
                    labels = c(D='Diesel', E='Elétrico', G='Gasolina', H='Híbrido'),
                    name = "Combustível") +
  guides(color = guide_legend(title = "CO2"))  # Add legend for the line




####################################################
########### Consumo vs Combustível #################

# Criando dataframe apenas com os consumos dos combustíveis
consum_e <- data.frame('Fuel'=consumption_eletrics$`Fuel Type`,
                       'Combined'=consumption_eletrics$`Combined (E) (Le/100 km)`)

consum_fossil <- data.frame('Fuel'=consumption_fossilfuels$`Fuel Type`,
                            'Combined'=consumption_fossilfuels$`Combined (F) (L/100 km)`)

consum_hy_ele <- data.frame('Fuel'=rep('H_E',length(consumption_hybrids$`Combined (E) (Le/100 km)`)),
                            'Combined'=consumption_hybrids$`Combined (E) (Le/100 km)`)

consum_hy_fos <- data.frame('Fuel'=rep('H_F', length(consumption_hybrids$`Combined (F) (L/100 km)`)),
                            'Combined'=consumption_hybrids$`Combined (F) (L/100 km)`)


fossil <- rbind(consum_fossil, consum_hy_fos)
electric <- rbind(consum_hy_ele, consum_e)

summary(electric[electric$Fuel=='H_E',]$Combined)
summary(fossil[fossil$Fuel=='H_F',])

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
  labs(x = "Tipo de Combustível", y = "Consumo Combinado de Combustível (Litros/100 km)",
       title = "Consumo Combinado pelo Tipo de Combustível",
       subtitle = 'Combustíveis Fósseis') +
  theme_minimal() +
  theme(
    legend.position = 'none',
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 12, hjust = 0.5),
    axis.title.x = element_text(size = 11, hjust = 0.5),
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
  labs(x = "Tipo de Combustível", y = "Consumo Combinado de Combustível (Le/100 km)",
       title = "Consumo Combinado por Tipo de Combustível",
       subtitle = 'Parte Elétrica') +
  theme_minimal() +
  theme(
    legend.position = 'none',
    plot.title = element_text(size = 14, face = "bold", hjust = 0.5),
    plot.subtitle = element_text(size = 11, hjust = 0.5),
    axis.title.x = element_text(size = 12, hjust = 0.5),
    axis.title.y = element_text(size = 12, hjust = 0.5),
    legend.title = element_text(size = 11, face = "bold")
  )

library(patchwork)
box_fossil + box_electric






