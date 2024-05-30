source("dataProcessing.R") 
source("createGraphs.R")


df_EnginePower <- read_csv("C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_ProjectShared/modificated-data/PT-all.csv")
df_MaxMin <- createData("C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_ProjectShared/modificated-data/PT-all.csv")
df_consumptionFossil <- read_csv("C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_ProjectShared/modificated-data/consumption-fossilfuels.csv")
df_consumptionFossil <- create_class_consumptionFuel()
df_consumptionEletrico <- create_class_consumptionEletric()
df_consumptionHybrid <- create_class_consumptionHybrid()
df_consumption_maxMin_Fossil <- createData_Fossil()
df_consumption_maxMin_Hybrid <- createData_Hybrid()
df_consumption_maxMin_Eletric <- createData_Eletric()



# Funcionalidade 1 - Potência do Motor vs Níveis de CO2 
fuelTypes <- c("G","D","H")
colors <- list(c(245,191,76), c(245,140,76), c(12,124,250))
Gs = list()
for (index in 1:length(colors))
{
  df_G <- df_EnginePower[df_EnginePower$`Fuel Type` == fuelTypes[index],]
  data <-  aes(x = `Engine Power (kW)`, y = `Test Emission CO2 (g/km)`)
  titles <-  c("Potência do Motor (kW)", "Emissão de CO2 (g/km)","Potência do Motor x Emissão de CO2", paste('Tipo de Combustível: ', fuelTypes[index], sep=''))
  color <-  colors[index]
  G = createDotPlot(df_G, data, titles, color, paste('graph2_EnginePower_CO2_', fuelTypes[index],'.JPG', sep=''))
  Gs <- c(Gs,list(G)); print(G)
}


# Funcionalidade 2 - Consumo Médio por classe de veículo
# Consumo por Classe - Fósseis
grafico_media_consumo_por_classe <-ggplot(data = df_consumptionFossil, aes(x = `Vehicle class`, y = `Combined (F) (L/100 km)`)) +
  geom_bar(stat = "identity", fill = rgb(245, 191, 76, maxColorValue = 255), width = 0.7) +
  labs(x = "Classe do Veículo", y = "Consumo Médio (L/100 km)",
       title = "Consumo Médio por Classe de Veículo", 
       subtitle = "Combustíveis Fósseis") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 20, lineheight = 1.2, margin = margin(t = 15)),
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 14, lineheight = 1.2, margin = margin(t = 10)))
print(grafico_media_consumo_por_classe)
ggsave("consumoClassFossil.JPEG", plot = grafico_media_consumo_por_classe, width = 1600, height = 900, dpi=150, units = "px")


# Consumo por classe - Híbridos
grafico_media_consumo_por_classeH <- ggplot(data = df_consumptionHybrid, aes(x = `Vehicle class`, y = `Combined (E) (Le/100 km)`)) +
  geom_bar(stat = "identity", fill = rgb(12, 124, 250, maxColorValue = 255), width = 0.7) +
  labs(x = "Classe do Veículo", y = "Consumo Médio (Le/100 km)",
       title = "Consumo Médio por Classe de Veículo", 
       subtitle = "Combustíveis Híbridos") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 20, lineheight = 1.2, margin = margin(t = 15)),
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 14, lineheight = 1.2, margin = margin(t = 10)))
print(grafico_media_consumo_por_classeH)
ggsave("consumoClassHybrid.JPEG", plot = grafico_media_consumo_por_classeH, width = 1600, height = 900, dpi=150, units = "px")


# Consumo por classe - Elétricos
grafico_media_consumo_por_classeE <-ggplot(data = df_consumptionEletrico, aes(x = `Vehicle class`, y = `Combined (E) (kWh/100 km)`)) +
  geom_bar(stat = "identity", fill = rgb(120,200,250, maxColorValue = 255), width = 0.7) +
  labs(x = "Classe do Veículo", y = "Consumo Médio (kWh/100 km)",
       title = "Consumo Médio por Classe de Veículo", 
       subtitle = "Combustíveis Elétricos") +
  theme_minimal() +
  theme(axis.text.x = element_text(angle = 45, hjust = 1),
        plot.title = element_text(hjust = 0.5, face = "bold", size = 20, lineheight = 1.2, margin = margin(t = 15)),
        plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 14, lineheight = 1.2, margin = margin(t = 10)))
print(grafico_media_consumo_por_classeE)
ggsave("consumoClassEletric.JPEG", plot = grafico_media_consumo_por_classeE, width = 1600, height = 900, dpi=150, units = "px")


# Funcionalidade 3 - Consumo por Marcas/Modelos
# Consumo de combustível fóssil por marcas
header <- names(df_consumption_maxMin_Fossil)
colors <- list(c(12, 124, 250), c(245, 191, 76))
angle <- 0
for (index in 1:length(colors))
{
  data <-  aes(x = `Marca`, y = .data[[header[3+(index-1)*2]]])
  label <- header[2*index]
  titles <-  c("Marcas", "Consumo Combinado (F) (L/100 km)", "Consumo de Combustível Fóssil vs Marcas", paste(label, '', sep=''))
  color <-  colors[index]
  G = createBarPlot(df_consumption_maxMin_Fossil, data, label, titles, color, paste('Consumo Fóssil', index,'.JPEG', sep=''), TRUE, angle)
  Gs <- c(Gs, list(G)); print(G)
}


# Consumo de combustível híbrido por marcas
header <- names(df_consumption_maxMin_Hybrid)
colors <- list(c(12, 124, 250), c(245, 191, 76))
angle <- 0
for (index in 1:length(colors))
{
  data <-  aes(x = `Marca`, y = .data[[header[3+(index-1)*2]]])
  label <- header[2*index]
  titles <-  c("Marcas", "Consumo Combinado (F) (L/100 km)", "Consumo de Combustível Híbrido vs Marcas", paste(label, '', sep=''))
  color <-  colors[index]
  G = createBarPlot2(df_consumption_maxMin_Hybrid, data, label, titles, color, paste('Consumo Hibrido', index,'.JPEG', sep=''), TRUE, angle)
  Gs <- c(Gs, list(G)); print(G)
}


# Consumo de combustível elétrico por marcas
header <- names(df_consumption_maxMin_Eletric)
colors <- list(c(12, 124, 250), c(245, 191, 76))
angle <- 0
for (index in 1:length(colors))
{
  data <-  aes(x = `Marca`, y = .data[[header[3+(index-1)*2]]])
  label <- header[2*index]
  titles <-  c("Marcas", "Consumo Combinado (E) (Le/100 km)", "Consumo de Combustível Elétrico vs Marcas", paste(label, '', sep=''))
  color <-  colors[index]
  G = createBarPlot2(df_consumption_maxMin_Eletric, data, label, titles, color, paste('Consumo Eletrico', index,'.JPEG', sep=''), TRUE, angle)
  Gs <- c(Gs, list(G)); print(G)
}

