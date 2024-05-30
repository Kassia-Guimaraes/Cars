library(readr)
library(zoo)
library(magrittr)
library(dplyr)
library(ggplot2)

# importar o arquivo
df_all <- read_csv("C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_ProjectShared/modificated-data/PT-all.csv")
View(df_all)
colnames(df_all)

############# 1ª PARTE: summary e sd v.a.'s numéricas #############

# summary e sd - ALL
# Colunas de v.a's quantitativas
col_numericas_all <- df_all[,c("Test Weight (kg)", "Test Emission CO2 (g/km)", "Wheel Base (mm)", "Engine Capacity (cm3)", "Engine Power (kW)")]

# Summary: Estatística Descritiva das v.a's quantitativas
summary_stats_all <- summary(col_numericas_all)

# Desvio Padrão das v.a's quantitativas
desvio_padrao_all <- round(sapply(col_numericas_all, sd, na.rm = TRUE), 2)

# Summary + sd das v.a's quantitativas
summary_stats_with_sd_all <- rbind(summary_stats_all, "Desvio Padrão" = desvio_padrao_all)
View(summary_stats_with_sd_all)
dados_all <- data.frame(summary_stats_with_sd_all)
write.csv(dados_all, "dados_all_sd_resumoEstat.csv")

# summary e sd - 2022
PT_2022 <- df_all[df_all$Year == 2022, ]
# Colunas de v.a's quantitativas
col_numericas <- PT_2022[,c("Test Weight (kg)", "Test Emission CO2 (g/km)", "Wheel Base (mm)", "Engine Capacity (cm3)", "Engine Power (kW)")]

# Summary: Estatística Descritiva das v.a's quantitativas
summary_stats <- summary(col_numericas)

# Desvio Padrão das v.a's quantitativas
desvio_padrao <- round(sapply(col_numericas, sd, na.rm = TRUE), 2)

# Summary + sd das v.a's quantitativas
summary_stats_with_sd <- rbind(summary_stats, "Desvio Padrão" = desvio_padrao)
View(summary_stats_with_sd)
dados_2022 <- data.frame(summary_stats_with_sd)
write.csv(dados_2022, "dados_2022_sd_resumoEstat.csv")


############# 2ª PARTE: TABLE DAS VARIÁVEIS QUALITATIVAS #############

# Colunas de v.a's qualitativas - ALL
col_categoricas_all <- df_all[,c("ID", "Make", "Model", "Fuel Type")]
View(col_categoricas_all)

# Colunas de v.a's qualitativas - 2022
col_categoricas_2022 <- PT_2022[,c("ID", "Make", "Model", "Fuel Type")]
View(col_categoricas_2022)

# Número de cada Versão, Marca, Modelo e Combustível - ALL
table(df_all$'Version')
table(df_all$'Make')
table(df_all$'Model')
table(df_all$'Fuel Type')

# Número de cada Versão, Marca, Modelo e Combustível - 2022
table(PT_2022$'Version')
table(PT_2022$'Make')
table(PT_2022$'Model')
table(PT_2022$'Fuel Type')



