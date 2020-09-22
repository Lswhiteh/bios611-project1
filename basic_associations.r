library(readr)
library(arules)
library(rpart)
library(rpart.plot)
library(ggplot2)
source("utils.r")
set.seed(42)
setwd("~/bios611-project1")

data_raw <- get_raw_mushroom_data()

#Simple association test for most common sets
rules <- apriori(data_raw, parameter=list(supp=0.5, conf=0.9, target="rules"))
#inspect(head(rules, by = "lift"))

#Decision tree, different representation of same concept
shuffled_data <- data_raw[sample(1:nrow(data_raw)), ]
head(shuffled_data)

train_inds <- 1:round(nrow(shuffled_data)*.8)
test_inds <- (round(nrow(shuffled_data)*.8)+1):nrow(shuffled_data)

train_data <- shuffled_data[train_inds, ]
test_data <- shuffled_data[test_inds, ]

dec_tree_fit_odor <- rpart(class~., data=train_data, method='class')
odor_plot <- rpart.plot(dec_tree_fit_odor, main="Initial Decision Tree")
png("figures/odor_importance_tree.png")

no_odor_train <- subset(train_data, select=-odor)

dec_tree_fit_no_odor <- rpart(class~., data=no_odor_train, method='class')
rpart.plot(dec_tree_fit_no_odor, main="No Odor Decision Tree")
png("figures/no_odor_importance_tree.png")


#How well does it do with odor vs without?
test_data$prob_odor <- predict(dec_tree_fit_odor, newdata=test_data, type="prob")
test_data$class_odor <- predict(dec_tree_fit_odor, newdata=test_data, type="class")
test_data$prob_no_odor <- predict(dec_tree_fit_no_odor, newdata=test_data, type="prob")
test_data$class_no_odor <- predict(dec_tree_fit_no_odor, newdata=test_data, type="class")

test_results <- data.frame(test_data$class, 
                             test_data$prob_odor, 
                             test_data$class_odor, 
                             test_data$prob_no_odor, 
                             test_data$class_no_odor)
colnames(test_results) <- c("true_class", "odor_prob_poison", "odor_prob_edible", "odor_class_pred",
                            "no_odor_prob_poison", "no_odor_prob_edible", "no_odor_class_pred")
head(test_results)

confmat_odor <- table(test_results$true_class, test_results$odor_class_pred)
print("Confusion Matrix including odor:")
print(confmat_odor)

confmat_odor_df <- data.frame(confmat_odor)
colnames(confmat_odor_df) <- c("True_Class", "Predicted_Class", "Freq")
ggplot(data =  confmat_odor_df, mapping = aes(x = True_Class, y = Predicted_Class)) +
  geom_tile(aes(fill = Freq), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Freq)), vjust = 1) +
  scale_fill_gradient() +
  theme_bw() + theme(legend.position = "none") +
  ggtitle("Confusion Matrix for Decision Tree with Odor")

ggsave("figures/conf_mat_odor.png")



confmat_no_odor <- table(test_results$true_class, test_results$no_odor_class_pred)
print("Confusion Matrix excluding odor:")
print(confmat_no_odor)

confmat_no_odor_df <- data.frame(confmat_no_odor)
colnames(confmat_no_odor_df) <- c("True_Class", "Predicted_Class", "Freq")
ggplot(data =  confmat_no_odor_df, mapping = aes(x = True_Class, y = Predicted_Class)) +
  geom_tile(aes(fill = Freq), colour = "white") +
  geom_text(aes(label = sprintf("%1.0f", Freq)), vjust = 1) +
  scale_fill_gradient() +
  theme_bw() + theme(legend.position = "none") +
  ggtitle("Confusion Matrix for Decision Tree without Odor")

ggsave("figures/conf_mat_no_odor.png")
