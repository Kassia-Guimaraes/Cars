library(readr)
library(zoo)
df_all <- read_csv("C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_ProjectShared/modificated-data/PT-all.csv")
View(df_all)
colnames(df_all)
PT_2022 <- df_all[df_all$Year == 2022, ]
# Colunas de v.a's quantitativas
col_numericas <- PT_2022[,c("Test weight (kg)", "Test Emission CO2 (g/km)", "Whell Base (mm)", "Engine Capacity (cm3)", "Engine Power (kW)")]

# Summary: Estatística Descritiva das v.a's quantitativas
summary_stats <- summary(col_numericas)

# Desvio Padrão das v.a's quantitativas
desvio_padrao <- round(sapply(col_numericas, sd, na.rm = TRUE), 2)

# Summary + sd das v.a's quantitativas
summary_stats_with_sd <- rbind(summary_stats, "Desvio Padrão" = desvio_padrao)
View(summary_stats_with_sd)
dados_2022 <- data.frame(summary_stats_with_sd)
write.csv(dados_2022, "dados_2022_sd_resumoEstat.csv")

# Colunas de v.a's qualitativas
col_categoricas <- PT_2022[,c("ID", "Version", "Make", "Model", "Fuel type")]
View(col_categoricas)

# Número de cada Versão, Marca, Modelo e Combustível
table(PT_2022$'Version')
table(PT_2022$'Make')
table(PT_2022$'Model')
table(PT_2022$`Fuel type`)
