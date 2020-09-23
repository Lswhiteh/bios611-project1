library(tidyverse)
library(janitor)
library(data.table)

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

