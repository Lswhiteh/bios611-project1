library(tidyverse)
library(janitor)
library(data.table)
library(klaR)
library(FactoMineR)
library(factoextra)

get_raw_mushroom_data <- function(){
  raw_data <- read_csv("source_data/mushrooms.csv",
                       quote="`",
                       col_types = cols(.default = "f"))

}

get_cleaned_mushroom_data <- function(){
  raw_data <- read_csv("source_data/mushrooms.csv",
           quote="`",
           col_types = cols(.default = "f"))
  
  mushrooms <- raw_data %>% clean_names() %>% drop_na() %>% data.table()
  
}

split_train_test <- function(df){
  #Returns a list of training, testing data in that order
  shuffled_data <- df[sample(1:nrow(df)), ]
  head(shuffled_data)
  
  train_inds <- 1:round(nrow(shuffled_data)*.8)
  test_inds <- (round(nrow(shuffled_data)*.8)+1):nrow(shuffled_data)
  
  train_data <- shuffled_data[train_inds, ]
  test_data <- shuffled_data[test_inds, ]
  
  split_data <- list(train_data, test_data)
}

plot_conf_mat <- function(df, plottitle, savepath){
  #Plots a confusion matrix using ggplot
  head(df)
  ggplot(data =  df, mapping = aes(x = True_Class, y = Predicted_Class)) +
    geom_tile(aes(fill = Freq), colour = "white") +
    geom_text(aes(label = sprintf("%1.0f", Freq)), vjust = 1, size=20) +
    scale_fill_gradient2(low = "red",
                         mid = "white",
                         high = "blue") +
    theme_bw() + theme(legend.position = "none") +
    ggtitle(plottitle)
  
  ggsave(savepath)
  
}