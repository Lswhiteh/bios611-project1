library(tidyverse)
library(caret)
library(yardstick)

model.predictions <- read_csv("derived_data/Mushrooms/model_predictions.csv", 
  cols(
    "TrueLab" = col_factor(),
    "PredLab" = col_factor()),
  col_names=c("TrueLab", "PredLab"))

levels(model.predictions$PredLab) <- levels(model.predictions$TrueLab)
  
conf.mat <- conf_mat(model.predictions, TrueLab, PredLab)

autoplot(conf.mat, type="heatmap", main="Confusion Matrix for CNN")
ggsave("derived_data/heatmap_confmat.png")
