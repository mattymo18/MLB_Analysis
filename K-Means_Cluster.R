#load data and libs

library(tidyverse)
library(cluster)
library(factoextra)
library(gridExtra)

#set a seed also
set.seed(321)

Catchers <- read.csv("derived_data/Catch.Balanced.csv")
Pitchers <- read.csv("derived_data/Pitch.Balanced.csv")
OF <- read.csv("derived_data/OF.Balanced.csv")
SS <- read.csv("derived_data/SS.Balanced.csv")
B3 <- read.csv("derived_data/3B.Balanced.csv")
B2 <- read.csv("derived_data/2B.Balanced.csv")
B1 <- read.csv("derived_data/1B.Balanced.csv")

#make functions for everyone but pitchers

#first function for checking optimal number of clusters

km.optim.clust <- function(DF) {
  #center and scale
  
  cent.temp = data.frame(
    Allstar = as.factor(DF$AllStar)
  )
  
  DF.cent = na.omit(cbind(cent.temp, 
                          scale(DF %>% 
                                  select(-c(AllStar, playerID, yearID, 
                                            stint, teamID, lgID, POS)), scale = T, center = T)))
  #check number of clusters
  
  fviz_nbclust(DF.cent[, -1], kmeans, method = "wss") +
    labs(title = paste("Optimal Number of Clusters:", DF$POS))
}



km.clust <- function(DF) {
  #center and scale
  
  cent.temp = data.frame(
    Allstar = as.factor(DF$AllStar)
  )
  
  DF.cent = na.omit(cbind(cent.temp, 
                          scale(DF %>% 
                                  select(-c(AllStar, playerID, yearID, 
                                            stint, teamID, lgID, POS)), scale = T, center = T)))

  k = kmeans(DF.cent[, -1], centers = 2, nstart = 10)
  
  fviz_cluster(k, data = DF.cent[, -1], geom = "point", 
                    show.clust.cent = F) +
    geom_point(aes(col = DF.cent$Allstar), alpha = .7) +
    scale_color_brewer('Cluster', palette='Set1') + 
    scale_fill_brewer('Cluster', palette='Set1') +
    scale_shape_manual('Cluster', values=c(1, 0)) +
    guides(fill = F) +
    guides(shape = F) +
    guides(col = F) +
    theme_minimal() +
    geom_label(aes(x = 4, y = 6, label = "Not All-Stars"), col = "red") +
    geom_label(aes(x = 4, y = 5, label = "All-Stars"), col = "blue") +
    labs(title = paste("K-Means Clustering:", DF$POS))
}

#we can check them all for the right number of clusters (hopefully 2)

p1 <- km.optim.clust(B1)
p2 <- km.optim.clust(B2)
p3 <- km.optim.clust(B3)
p4 <- km.optim.clust(SS)
p5 <- km.optim.clust(OF)
p6 <- km.optim.clust(Catchers)

#now we can save all of these, we might not 
#use them all but they are all good to save anyway

ggsave("derived_graphics/First.Base.Optim.Cluster.png", plot = p1)
ggsave("derived_graphics/Second.Base.Optim.Cluster.png", plot= p2)
ggsave("derived_graphics/Third.Base.Optim.Cluster.png", plot= p3)
ggsave("derived_graphics/Short.Stop.Optim.Cluster.png", plot= p4)
ggsave("derived_graphics/Out.Field.Optim.Cluster.png", plot= p5)
ggsave("derived_graphics/Catchers.Optim.Cluster.png", plot= p6)


#now actually make the plots

p7 <- km.clust(B1)
p8 <- km.clust(B2)
p9 <- km.clust(B3)
p10 <- km.clust(SS)
p11 <- km.clust(OF)
p12 <- km.clust(Catchers)

#and save the plots
ggsave("derived_graphics/First.Base.Cluster.png", plot = p7)
ggsave("derived_graphics/Second.Base.Cluster.png", plot= p8)
ggsave("derived_graphics/Third.Base.Cluster.png", plot= p9)
ggsave("derived_graphics/Short.Stop.Cluster.png", plot= p10)
ggsave("derived_graphics/Out.Field.Cluster.png", plot= p11)
ggsave("derived_graphics/Catchers.Cluster.png", plot= p12)


#now we need to do pitchers separately 

#center and scale

Pitch.cent.temp <- data.frame(
  Allstar = as.factor(Pitchers$AllStar)
)

Pitch.cent <- na.omit(cbind(Pitch.cent.temp, 
                            scale(Pitchers %>% 
                                    select(-c(AllStar, playerID, yearID, 
                                              stint, teamID, lgID)), scale = T, center = T)))


#ok so we're hoping for two clusters, lets check to see

p13 <- fviz_nbclust(Pitch.cent[, -1], kmeans, method = "wss")

#that is great we get a nice kink at 2

# Proceed with kmeans 2 clusters

k.pitch <- kmeans(Pitch.cent[, -1], centers = 2, nstart = 10)

p14 <- fviz_cluster(k.pitch, data = Pitch.cent[, -1], geom = "point", 
             show.clust.cent = F) +
  geom_point(aes(col = Pitch.cent$Allstar), alpha = .7) +
  scale_color_brewer('Cluster', palette='Set1') + 
  scale_fill_brewer('Cluster', palette='Set1') +
  scale_shape_manual('Cluster', values=c(1, 0)) +
  guides(fill = F) +
  guides(shape = F) +
  guides(col = F) +
  theme_minimal() +
  geom_label(aes(x = 4.5, y = 6, label = "Not All-Stars"), col = "red") +
  geom_label(aes(x = 4.5, y = 5, label = "All-Stars"), col = "blue") +
  labs(title = "K-Means Clustering with Pitchers")

ggsave("derived_graphics/Pitchers.Optim.Cluster.png", plot= p13)
ggsave("derived_graphics/Pitchers.Cluster.png", plot= p14)