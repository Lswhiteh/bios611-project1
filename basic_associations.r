library(readr)
library(arules)
library(rpart)
library(rpart.plot)
library(ggplot2)
source("utils.r")
set.seed(42)

data_raw <- get_raw_mushroom_data()

#Simple association test for most common sets
rules <- apriori(data_raw, parameter=list(supp=0.9, conf=0.9, target="rules"))
inspect(head(rules, by = "lift"))

# Prep data and try first decision tree
ttd <- split_train_test(data_raw)
train_data <- ttd[[1]]
test_data <- ttd[[2]]

dec_tree_fit_odor <- rpart(class~., data=train_data, method='class')

rpart.plot(dec_tree_fit_odor, main="Initial Decision Tree")

#I have had so much trouble getting this to consistently save, I have no idea why.
# It's the same with the other tree too. Any help?
dev.new()
png("figures/odor_importance_tree.png")


#Same model with odor feature removed
no_odor_train <- subset(train_data, select=-odor)

dec_tree_fit_no_odor <- rpart(class~., data=no_odor_train, method='class')

rpart.plot(dec_tree_fit_no_odor, main="No Odor Decision Tree")

dev.new()
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

colnames(test_results) <- c("true_class", 
                            "odor_prob_poison", 
                            "odor_prob_edible", 
                            "odor_class_pred",
                            "no_odor_prob_poison", 
                            "no_odor_prob_edible", 
                            "no_odor_class_pred")
head(test_results)

confmat_odor <- table(test_results$true_class, test_results$odor_class_pred)
print("Confusion Matrix including odor:")
print(confmat_odor)

confmat_odor_df <- data.frame(confmat_odor)
colnames(confmat_odor_df) <- c("True_Class", "Predicted_Class", "Freq")

plot_conf_mat(confmat_odor_df, 'Prediction Accuracies with Odor', "figures/conf_mat_odor.png")


confmat_no_odor <- table(test_results$true_class, test_results$no_odor_class_pred)
print("Confusion Matrix excluding odor:")
print(confmat_no_odor)

confmat_no_odor_df <- data.frame(confmat_no_odor)
colnames(confmat_no_odor_df) <- c("True_Class", "Predicted_Class", "Freq")

plot_conf_mat(confmat_no_odor_df, 'Prediction Accuracies without Odor', "figures/conf_mat_no_odor.png")