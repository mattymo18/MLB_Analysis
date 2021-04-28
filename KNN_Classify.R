#load data and libs
library(caret)
library(tidyverse)

#set a seed also
set.seed(321)

Pitchers <- read.csv("derived_data/Clean.Pitchers.csv")
Fielders <- read.csv("derived_data/Clean.Fielders.csv")
Catchers <- read.csv("derived_data/Clean.Catchers.csv")

############### unbalanced pitchers first ###############

#split the data
trainIndex <- createDataPartition(y = Pitchers$AllStar, p = .7, list = F)
train <- Pitchers[trainIndex, ] %>% 
  select(-c(playerID, yearID, teamID, lgID))
test <- Pitchers[-trainIndex, ] %>% 
  select(-c(playerID, yearID, teamID, lgID))
train <- na.omit(train)
test <- na.omit(test)

# prop.table(table(test$AllStar)) * 100
#about 4 percent are Allstars

#now we don't know what k should be, so we can use CV on the training set to figure out what an optimal k should be

#lets do 10 fold cv and we will try 20 different values of k
trCtrl <- trainControl(method = "cv", number = 10)

knn.pitch <- train(
  data = train, 
  as.factor(AllStar) ~., 
  method = "knn", 
  trControl = trCtrl, 
  preProcess = c("center", "scale"), 
  tuneLength = 20
)

knn.pitch
# plot(knn.pitch)
#17 is optimal

knn.preds <- predict(knn.pitch, newdata = test)
pitcher.confusion <- confusionMatrix(knn.preds, as.factor(test$AllStar))

saveRDS(pitcher.confusion, "derived_models/knn.pitcher.rds")

############################## fielders ############################## 

#split the data
trainIndex <- createDataPartition(y = Fielders$AllStar, p = .7, list = F)
train <- Fielders[trainIndex, ] %>% 
  select(-c(playerID, yearID, teamID, lgID, POS))
test <- Fielders[-trainIndex, ] %>% 
  select(-c(playerID, yearID, teamID, lgID, POS))
train <- na.omit(train)
test <- na.omit(test)

#now we don't know what k should be, so we can use CV on the training set to figure out what an optimal k should be

#lets do 10 fold cv and we will try 20 different values of k
trCtrl <- trainControl(method = "cv", number = 10)

knn.field <- train(
  data = train, 
  as.factor(AllStar) ~., 
  method = "knn", 
  trControl = trCtrl, 
  preProcess = c("center", "scale"), 
  tuneLength = 20
)

knn.field
# plot(knn.field)
#9 is optimal

knn.preds <- predict(knn.field, newdata = test)
fielder.confusion <- confusionMatrix(knn.preds, as.factor(test$AllStar))

saveRDS(fielder.confusion, "derived_models/knn.fielder.rds")

############################## catchers ############################## 

#split the data
trainIndex <- createDataPartition(y = Catchers$AllStar, p = .7, list = F)
train <- Catchers[trainIndex, ] %>% 
  select(-c(playerID, yearID, teamID, lgID, POS))
test <- Catchers[-trainIndex, ] %>% 
  select(-c(playerID, yearID, teamID, lgID, POS))
train <- na.omit(train)
test <- na.omit(test)

#now we don't know what k should be, 
#so we can use CV on the training set to figure out what an optimal k should be

#lets do 10 fold cv and we will try 20 different values of k
trCtrl <- trainControl(method = "cv", number = 10)

knn.catch <- train(
  data = train, 
  as.factor(AllStar) ~., 
  method = "knn", 
  trControl = trCtrl, 
  preProcess = c("center", "scale"), 
  tuneLength = 20
)

knn.catch
# plot(knn.catch)
#7 is optimal

knn.preds <- predict(knn.catch, newdata = test)
catcher.confusion <- confusionMatrix(knn.preds, as.factor(test$AllStar))

saveRDS(catcher.confusion, "derived_models/knn.catcher.rds")