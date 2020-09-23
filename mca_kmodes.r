library(klaR)
library(FactoMineR)
library(factoextra)
source('utils.r')
setwd("~/bios611-project1")
mushrooms <- get_cleaned_mushroom_data()

#http://www.sthda.com/english/articles/31-principal-component-methods-in-r-practical-guide/114-mca-multiple-correspondence-analysis-in-r-essentials/

#Initial all-samples MCA + plot
mush_mca <- MCA(mushrooms[,2:ncol(mushrooms)])

fviz_screeplot(mush_mca, 
               addlabels=TRUE, 
               title="Edible + Poisonous Explained Variance by Dimension")

fviz_mca_ind(mush_mca, 
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),  
             ggtheme = theme_minimal(),
             labels=FALSE)

fviz_mca_ind(mush_mca, 
             habillage=mushrooms$class,
             ggtheme = theme_minimal(),
             labels=FALSE)

fviz_cos2(mush_mca,
          choice="var",
          axes=1,
          top=30)

fviz_cos2(mush_mca,
          choice="var",
          axes=2,
          top=30)

#MCA for poisonous only
poisonous_mca <- MCA(mushrooms[class=="p",2:ncol(mushrooms)])

fviz_screeplot(poisonous_mca, 
               addlabels=TRUE, 
               title="Poisonous Explained Variance by Dimension")

fviz_mca_ind(poisonous_mca, 
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),  
             ggtheme = theme_minimal(),
             labels=FALSE)

#MCA for edible only
edibles_mca <- MCA(mushrooms[class=="e",2:ncol(mushrooms)])

fviz_screeplot(edibles_mca, 
               addlabels=TRUE, 
               title="Edible Explained Variance by Dimension")

fviz_mca_ind(edibles_mca, 
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),  
             ggtheme = theme_minimal(),
             labels=FALSE)

cluster_results <- kmodes(mushrooms[,2:ncol(mushrooms)], i)
