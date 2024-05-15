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


#################################################################################








