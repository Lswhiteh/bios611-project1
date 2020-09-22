library(tidyverse)

get_raw_mushroom_data <- function(){
  raw_data <- read_csv("source_data/mushrooms.csv",
                       quote="`",
                       col_types = cols(.default = "f"))

  }

get_cleaned_mushroom_data <- function(){
  raw_data <- read_csv("source_data/mushrooms.csv",
           quote="`",
           col_types = cols(.default = "f"))
  
  mushrooms <- data_raw %>% clean_names() %>% drop_na() %>% data.table()
  
}

