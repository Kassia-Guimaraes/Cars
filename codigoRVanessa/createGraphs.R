library(readr)
library(dplyr)
library(ggplot2)
library(gridExtra)

# 3) Potência e níveis de CO2 (Engine Power) - gráfico de dispersão com reta de regressão linear. Vanessa
# importar o arquivo

df <- read_csv("C:/Users/vanes/OneDrive/Desktop/LE/aulas.py/CO2_ProjectShared/modificated-data/PT-all.csv")

createDotPlot <- function(df, data, titles, color, fileName)
{
  color= unlist(color)
  G <- ggplot(data = df, data) +
    geom_point(color= rgb(color[1], color[2], color[3], maxColorValue = 255), size = 1) + geom_smooth(method = "lm", se = FALSE, color = "seagreen3") +
    labs(x = titles[1], y = titles[2],
         title = titles[3], 
         subtitle = titles[4]) +
    theme_minimal() + theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 20, lineheight = 1.2, margin = margin(t = 15)), 
                            plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 14, lineheight = 1.2, margin = margin(t = 10)))
  
  ggsave(fileName, plot = G, width = 8, height = 4, units = "in")
  return(G)
}

createBarPlot <- function(df, data, label, titles, color, fileName, flip, angle)
{
  color= unlist(color)
  
  G <- ggplot(data = df, data) +
    geom_bar(fill= rgb(color[1], color[2], color[3], maxColorValue = 255), stat = "identity")+ #+ geom_smooth(method = "lm", se = FALSE, color = "seagreen3") +
    scale_x_discrete(guide = guide_axis(angle = angle)) +
    labs(x = titles[1], y = titles[2],
         title = titles[3],
         subtitle = titles[4]) +
    geom_text(aes(label= .data[[label]]), size = 3, fontface= "bold", position= position_dodge(width = 0.9), hjust = 0)+
    theme_minimal() + theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 20, lineheight = 1.2, margin = margin(t = 15)), 
                            plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 14, lineheight = 1.2, margin = margin(t = 10)))

  if (flip == TRUE){
   G <- G + coord_flip()
  }
  
  ggsave(fileName, plot = G, width = 1850, height = 900, dpi= 150, units = "px")
  return(G)
}

createBarPlot2 <- function(df, data, label, titles, color, fileName, flip, angle)
{
  color= unlist(color)
  
  G <- ggplot(data = df, data) +
    geom_bar(fill= rgb(color[1], color[2], color[3], maxColorValue = 255), stat = "identity", width= 0.8)+ #+ geom_smooth(method = "lm", se = FALSE, color = "seagreen3") +
    scale_x_discrete(guide = guide_axis(angle = angle)) +
    labs(x = titles[1], y = titles[2],
         title = titles[3],
         subtitle = titles[4]) +
    geom_text(aes(label= .data[[label]]), size = 3, fontface= "bold", position= position_dodge(width = 0.9), hjust = 0)+
    theme_minimal() + theme(plot.title = element_text(hjust = 0.5, face = "bold", size = 20, lineheight = 1.2, margin = margin(t = 15)), 
                            plot.subtitle = element_text(hjust = 0.5, face = "italic", size = 14, lineheight = 1.2, margin = margin(t = 10))) +
  scale_y_continuous(limits= c(0, 6), breaks= seq(0, 7, by = 2.5))
  if (flip == TRUE){
    G <- G + coord_flip()
  }
   
  ggsave(fileName, plot = G, width = 1850, height = 900, dpi= 150, units = "px")
  return(G)
}

