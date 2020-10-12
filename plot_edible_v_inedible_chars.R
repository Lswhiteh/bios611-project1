library(tidyverse)
library(ggplot2)
library(janitor)
library(mltools)
library(data.table)
library(reshape)
source("utils.r")
set.seed(42)

mushrooms <- get_cleaned_mushroom_data()

mushrooms %>% summary()

unique_vals <- mushrooms %>% lapply(., nlevels) %>% reshape::melt()

ggplot(unique_vals, aes(x=L1, y=value, fill=L1)) + 
  geom_bar(stat="identity") +
  theme(axis.title.x=element_blank(),
        axis.text.x=element_blank(),
        axis.ticks.x=element_blank(),
        legend.position="bottom") +
  scale_fill_discrete(name="Features") +
  labs(y="Possible Categories", x=NULL) +
  scale_y_continuous(breaks=0:15) +
  guides(fill = guide_legend(label.position = "bottom")) +
  ggtitle("Number of Options for Categorical Features")
ggsave('figures/category_options.png')