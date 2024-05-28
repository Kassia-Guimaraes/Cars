library(readr)
library(zoo)
library(dplyr)



# 1) Modelo de cada marca que mais e menos emite CO2.
createData <- function(path)
{
  selected_models <- c('Bmw', 'Citroen', 'Fiat', 'Honda', 'Mercedes-Benz', 'Opel', 'Peugeot', 'Renault', 'Toyota', 'Volkswagen')
 
  df_all <- read_csv(path)
  df_sem_E <- df_all[df_all$'Fuel Type' != "E" & df_all$'Make' == selected_models,]
  # Agrupar os dados por 'Marca' e ordenar por 'Test Emission CO2 (g/km)' em ordem decrescente
  data_grouped <- arrange(group_by(df_sem_E, Make), df_sem_E$"Test Emission CO2 (g/km)")
    
  # Obter os modelos de maior e menor emissão de cada grupo
  economic_model <- select(slice(data_grouped, 1), Make, Model, "Test Emission CO2 (g/km)")
  guzzler_model <- select(slice(data_grouped, n()), Make, Model, "Test Emission CO2 (g/km)")
  
  # Combinar as informações em um único dataframe.
  model_extremes <- cbind(economic_model, guzzler_model$Model, guzzler_model$'Test Emission CO2 (g/km)')
  
  df <- data.frame(model_extremes)
  colnames(df) <- c("Marca", "Modelo (menor emissão)", "Emissão (< CO2)", "Modelo (maior emissão)", "Emissão (> CO2)")
  return(df)
}


## 2) Consumo médio por classe dos carros a combustível fóssil, híbrido e elétrico
## Criar funções que serão chamadas no main.

path_1 <- "C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_ProjectShared/modificated-data/consumption-fossilfuels.csv"
path_2 <- "C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_ProjectShared/modificated-data/consumption-hybrids.csv"
path_3 <- "C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_ProjectShared/modificated-data/consumption-eletrics.csv"

create_class_consumptionFuel <- function() { 
  df_consumptionFossil <- read_csv(path_1)
  names(df_consumptionFossil)
  vehicle_class <- df_consumptionFossil$`Vehicle class`

  # Calcular a média do consumo para cada classe
  media_consumo_por_classe <- aggregate(`Combined (F) (L/100 km)` ~ `Vehicle class`, data = df_consumptionFossil, FUN = function(x) round(mean(x), 2))
  df_consumo_classe <- data.frame(media_consumo_por_classe)
  names(df_consumo_classe) <- c("Vehicle class" , "Combined (F) (L/100 km)")
  return (df_consumo_classe)
}

create_class_consumptionHybrid<- function() {
  df_consumptionHybrid <- read_csv(path_2)
  names(df_consumptionHybrid)
  vehicle_class <- df_consumptionHybrid$`Vehicle class` 
  
  media_consumo_por_classe <- aggregate(`Combined (E) (Le/100 km)` ~ `Vehicle class`, data = df_consumptionHybrid, FUN = function(x) round(mean(x), 2))
  df_consumo_classe <- data.frame(media_consumo_por_classe)
  names(df_consumo_classe) <- c("Vehicle class" , "Combined (E) (Le/100 km)")
  return (df_consumo_classe)
}

create_class_consumptionEletric<- function() { 
  df_consumptionEletric <- read_csv(path_3)
  names(df_consumptionEletric)
  vehicle_class <- df_consumptionEletric$`Vehicle class`
  
  media_consumo_por_classe <- aggregate(`Combined (E) (kWh/100 km)` ~ `Vehicle class`, data = df_consumptionEletric, FUN = function(x) round(mean(x), 2))
  df_consumo_classe <- data.frame(media_consumo_por_classe)
  names(df_consumo_classe) <- c("Vehicle class" , "Combined (E) (kWh/100 km)")
  return (df_consumo_classe)
}

## 3) Consumo de combustível por marcas que gastam mais e menos.
createData_Fossil <- function() { 
  selected_models <- c('Bmw', 'Fiat', 'Honda', 'Mercedes-Benz', 'Toyota', 'Volkswagen') 
  df <- read_csv(path_1)
  names(df)
  df <- df[df$Make == selected_models,]
  data_grouped <- arrange(group_by(df, Make), df$`Combined (F) (L/100 km)`)
  
  economic_model <- select(slice(data_grouped, 1), Make, Model, "Combined (F) (L/100 km)")
  guzzler_model <- select(slice(data_grouped, n()), Make, Model, "Combined (F) (L/100 km)")
  model_extremes <- cbind(economic_model, guzzler_model$Model, guzzler_model$`Combined (F) (L/100 km)`)
  df <- data.frame(model_extremes)
  colnames(df) <- c("Marca", "Modelo (menor consumo)", "Menor Consumo Combinado (F) (L/100 km)", "Modelo (maior consumo)", "Maior Consumo Combinado (F) (L/100 km)")
  return(df)
}

createData_Hybrid <- function() { 
  selected_models <- c('Bmw', 'Volvo', 'Honda', 'Mercedes-Benz', 'Toyota', 'Kia') 
  df <- read_csv(path_2)
  names(df)
  df <- df[df$Make == selected_models,] 
  data_grouped <- arrange(group_by(df, Make), df$`Combined (F) (L/100 km)`)
  
  economic_model <- select(slice(data_grouped, 1), Make, Model, "Combined (F) (L/100 km)")
  guzzler_model <- select(slice(data_grouped, n()), Make, Model, "Combined (F) (L/100 km)")
  model_extremes <- cbind(economic_model, guzzler_model$Model, guzzler_model$`Combined (F) (L/100 km)`)
  df <- data.frame(model_extremes)
  colnames(df) <- c("Marca", "Modelo (menor consumo)", "Menor Consumo Combinado (F) (L/100 km)", "Modelo (maior consumo)", "Maior Consumo Combinado (F) (L/100 km)")
  return(df)
}

createData_Eletric <- function() { 
  selected_models <- c('Bmw', 'Ford', 'Tesla', 'Mercedes-Benz', 'Volkswagen', 'Kia') 
  df <- read_csv(path_3)
  names(df)
  df <- df[df$Make == selected_models,] 
  data_grouped <- arrange(group_by(df, Make), df$`Combined (E) (Le/100 km)`)
  
  economic_model <- select(slice(data_grouped, 1), Make, Model, "Combined (E) (Le/100 km)")
  guzzler_model <- select(slice(data_grouped, n()), Make, Model, "Combined (E) (Le/100 km)")
  model_extremes <- cbind(economic_model, guzzler_model$Model, guzzler_model$`Combined (E) (Le/100 km)`)
  df <- data.frame(model_extremes)
  colnames(df) <- c("Marca", "Modelo (menor consumo)", "Menor Consumo Combinado (E) (Le/100 km)", "Modelo (maior consumo)", "Maior Consumo Combinado (E) (Le/100 km)")
  return(df)
}

