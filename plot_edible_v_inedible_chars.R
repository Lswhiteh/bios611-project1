library(tidyverse)
library(ggplot2)
library(janitor)
library(mltools)
library(data.table)


data_raw <- read_csv("source_data/mushrooms.csv", 
                      quote = '`',
                      col_types = cols(.default = 'f'))

mushrooms <- data_raw %>% clean_names() %>% drop_na() %>% data.table()

mushrooms %>% summary()

ggplot(mushrooms, aes(x=class)) + 
  geom_bar(aes(fill=class)) +
  scale_fill_discrete(name=NULL, 
                      labels=c("Poisonous", "Edible")) +
  labs(y="Count", x=NULL) +
  ggtitle("Proportion of Poisonous vs Edible Mushrooms")
ggsave('figures/class_props.png')


unique_vals <- mushrooms %>% lapply(., nlevels) %>% melt() %>% data.frame()

ggplot(unique_vals, aes(x=L1, y=value, fill=L1)) + 
  geom_bar(stat="identity") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank()) +
  scale_fill_discrete(name="Features") +
  labs(y="Possible Categories", x=NULL) +
  scale_y_continuous(breaks=0:15) +
  ggtitle("Number of Options for Categorical Features")
ggsave('figures/category_options.png')


shrooms_ohe <- one_hot(mushrooms)
write.csv(shrooms_ohe, 'derived_data/shrooms_ohe.csv', row.names = FALSE)

