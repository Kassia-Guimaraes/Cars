library(readr)

### Importando dados
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


table(PT_2018$Make)
table(PT_2019$Make)
table(PT_2020$Make)
table(PT_2021$Make)
table(PT_2022$Make)

table(PT_2018$"Fuel type")
table(PT_2019$"Fuel type")
table(PT_2020$"Fuel type")
table(PT_2021$"Fuel type")
table(PT_2022$`Fuel type`)
table(PT_all$"Fuel type")



#Carros que mais entraram em circulação
PT_year <- c(2018,2019,2020,2021,2022)
PT_data <- c('PT_2018','PT_2019','PT_2020','PT_2021','PT_2022')

for (df_name in PT_data){
  df <- get(df_name)
  
  max_brand <- max(table(df$Make))
  min_brand <- min(table(df$Make))
  
  name_max <- names(table(df$Make))[table(df$Make) == max_brand]
  name_min <- names(table(df$Make))[table(df$Make) == min_brand]
  
  cat(df_name,'\nMAX:', name_max,max_brand,'\nMIN: ',name_min,min_brand,'\n\n\n')
}

for (df_name in PT_data){
  df <- get(df_name)
  
  max_model <- max(table(df$Model))
  
  name_max <- names(table(df$Model))[table(df$Model) == max_model]
  
  cat(df_name,'\nMAX:', name_max,max_model,'\n\n\n')
}



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




### Gráficos

#Combustíveis por carro
par(mfrow = c(2, 3))
for (df_name in PT_data){
  get_df <- get(df_name)
  
  fuels_type <- names(table(get_df$"Fuel type"))
  cores <- c("blue", "red", "green", "orange")
  
  df <- as.data.frame(table(get_df$`Fuel type`))
  
  df_cores <- data.frame(Fuel_type = fuels_type, Cor = cores)
  df <- merge(df, df_cores, by.x = "Var1", by.y = "Fuel_type", all.x = TRUE)
  
  barplot(df$Freq, names.arg = df$Var1, beside = TRUE,
          main=c('Combustíveis em',df_name), xlab = 'Fuel type', ylab = 'Frequency', col = df$Cor)
}


