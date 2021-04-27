#load data and libs
library(tidyverse)

First.Base.clean <- read.csv("derived_data/1B.Balanced.csv")
Second.Base.clean <- read.csv("derived_data/2B.Balanced.csv")
Third.Base.clean <- read.csv("derived_data/3B.Balanced.csv")
Short.Stop.clean <- read.csv("derived_data/SS.Balanced.csv")
Out.Field.clean <- read.csv("derived_data/OF.Balanced.csv")
Catchers.clean <- read.csv("derived_data/Catch.Balanced.csv")
Pitchers.clean <- read.csv("derived_data/Pitch.Balanced.csv")


#make ERA plot for Pitchers
#get means
mu <- data.frame(
  Allstar = c(1, 0), 
  grp.mean = c(mean(Pitchers.clean$ERA[which(Pitchers.clean$AllStar == 1)]), 
               mean(na.omit(Pitchers.clean$ERA[which(Pitchers.clean$AllStar == 0)])))
)


p1 <- Pitchers.clean %>% 
  mutate(Allstar = as.factor(AllStar)) %>% 
  filter(ERA <= 10) %>% 
  ggplot(aes(x = ERA)) +
  geom_density(aes(fill = Allstar), alpha = .5) +
  geom_vline(data = mu, aes(xintercept=grp.mean, color = as.factor(Allstar)),
             linetype="dashed") +
  guides(color = FALSE) +
  labs(y = "Density", 
       title = "All-Star vs. Non-All-Star ERA") +
  theme_minimal()

ggsave("README_graphics/Pitcher.plot.png", plot = p1)

#make HR plot for Everyone else

#ok that looks perfect, now we want something similar for every other position, I think I'll do boxplots for these though so it will look all nice together

DF <- rbind(
  Catchers.clean %>% select(POS, HR, AllStar), 
  First.Base.clean %>% select(POS, HR, AllStar), 
  Second.Base.clean %>% select(POS, HR, AllStar), 
  Third.Base.clean %>% select(POS, HR, AllStar), 
  Short.Stop.clean %>% select(POS, HR, AllStar), 
  Out.Field.clean %>% select(POS, HR, AllStar)
)

p2 <- DF %>% 
  mutate(Allstar = as.factor(AllStar)) %>% 
  ggplot(aes(x = POS, y = HR)) +
  geom_boxplot(aes(color = Allstar)) +
  labs(x = "Position",
       y = "Homeruns", 
       title = "All-Star vs. Non-All-Star Homeruns Hit") +
  theme_minimal()

ggsave("README_graphics/HR.plot.png")