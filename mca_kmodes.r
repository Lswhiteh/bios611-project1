library(klaR)
library(FactoMineR)
library(factoextra)
source('utils.r')
setwd("~/bios611-project1")
mushrooms <- get_cleaned_mushroom_data()

#Initial all-samples MCA + plot
mush_mca <- MCA(mushrooms[,2:ncol(mushrooms)])
ggsave('all_samples_mca.png')





cluster_results <- kmodes(mushrooms[,2:ncol(mushrooms)], i)
