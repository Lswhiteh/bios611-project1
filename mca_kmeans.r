library(klaR)
library(FactoMineR)
library(factoextra)
source('utils.r')
set.seed(42)

mushrooms <- get_cleaned_mushroom_data()

#Initial all-samples MCA + plot
mush_mca <- MCA(mushrooms[,2:ncol(mushrooms)])

fviz_screeplot(mush_mca, 
               addlabels=TRUE, 
               title="Edible + Poisonous Explained Variance by Dimension")
ggsave("figures/all_samps_mca_scree.png")

fviz_mca_ind(mush_mca, 
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),  
             ggtheme = theme_minimal(),
             labels=FALSE,
             title="Edible + Poisonous Representation Quality (Cos2)")
ggsave("figures/all_samps_mca_cos2.png")

fviz_mca_ind(mush_mca, 
             habillage=mushrooms$class,
             ggtheme = theme_minimal(),
             labels=FALSE, 
             title="All Samples Mapped to MCA Dim2 vs Dim1")
ggsave("figures/all_samps_mca_class.png")

mush_kmeans <- kmeans(mush_mca$ind$coord, 2)

fviz_cluster(mush_kmeans, 
             mush_mca$ind$coord,
             title="All Samples Kmeans Clustered with 2 Clusters",
             geom="point",
             label=mushrooms$class)
ggsave("figures/all_samps_kmeans.png")

#MCA for poisonous only
poisonous_mca <- MCA(mushrooms[class=="p",2:ncol(mushrooms)])

fviz_screeplot(poisonous_mca, 
               addlabels=TRUE, 
               title="Poisonous Explained Variance by Dimension")
ggsave("figures/poisonous_mca_scree.png")

fviz_mca_ind(poisonous_mca, 
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),  
             ggtheme = theme_minimal(),
             labels=FALSE, 
             title="Poisonous Samples Mapped to MCA Dim2 vs Dim1")
ggsave("figures/poisonous_mca_inds.png")

poisonous_kmeans <- kmeans(poisonous_mca$ind$coord, 3)

fviz_cluster(poisonous_kmeans, 
             poisonous_mca$ind$coord,
             title="Poisonous Samples Kmeans Clustered with 3 Clusters",
             geom="point")
ggsave("figures/poisonous_kmeans_3clust.png")

#MCA for edible only
edibles_mca <- MCA(mushrooms[class=="e",2:ncol(mushrooms)])

fviz_screeplot(edibles_mca, 
               addlabels=TRUE, 
               title="Edible Explained Variance by Dimension")
ggsave("figures/edible_mca_scree.png")

fviz_mca_ind(edibles_mca, 
             col.ind = "cos2", 
             gradient.cols = c("#00AFBB", "#E7B800", "#FC4E07"),  
             ggtheme = theme_minimal(),
             labels=FALSE, 
             title="Edible Samples Mapped to MCA Dim2 vs Dim1")
ggsave("figures/edible_mca_inds.png")

edibles_kmeans <- kmeans(edibles_mca$ind$coord, 4)

fviz_cluster(edibles_kmeans, 
             edibles_mca$ind$coord, 
             title="Edible Samples Kmeans Clustered with 4 Clusters")
ggsave("figures/edible_kmeans.png")
