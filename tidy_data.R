#### Load data and libs
library(tidyverse)
library(Lahman)

data("Pitching")
data("Batting")
data("AllstarFull")
data("Fielding")

# this won't do anything right now but lets just stay consistent and always set a seed
set.seed(321)

#start with standard players, we want to join fielding and batting for players that aren't pitchers
#we want to join on year and player id so we have players per season
#we can alos remove a few columns where we don't have consistent complete cases

DF <- inner_join(Batting, Fielding %>% select(-c(teamID, lgID, stint)), by = c("playerID" = "playerID", "yearID" = "yearID")) %>% 
  filter(yearID >= 2010) %>% 
  rename(Games_Batted = G.x, 
         Games_Fielded = G.y) %>% 
  #just knock out the pitchers
  filter(POS != "P") %>% 
  #fix wp and ZR issue found above
  select(-c(WP, ZR))

# Catchers hve some extra columns that normal players do not, lets make a new DF for them

Catchers <- DF %>% 
  filter(POS == "C") %>% 
  #fix some of the same column name issues
  rename(SB_As_Runner = SB.x, 
         CS_As_Runner = CS.x, 
         SB_As_Catch = SB.y, 
         CS_As_Catch = CS.y)

#ok now we can separate the normal players, 1B, 2B, 3B, SS, OF

Standard.players <- DF %>% 
  filter(POS != "C") %>% 
  #now we can knock out the catcher only fielding stats
  select(-c(PB, SB.y, CS.y)) %>% 
  #rename the SB and CS
  rename(SB_As_Runner = SB.x, 
         CS_AS_Runner = CS.x)


# now lets look at the pitchers, we don't care about the pitchers batting stats since
#NL and AL have different rules for this

#pitching data is very clean, all we need to do is make sure we look at 2010 on
Pitchers <- Pitching %>% 
  filter(yearID >= 2010)

#ok great, next thing is to add binaries for players when they made the allstar game for a given season


#start by using Allstar data to make a list of 2010 on allstars with an indicator column
Allstars <- AllstarFull %>% 
  filter(yearID >= 2010) %>% 
  select(playerID, yearID) %>% 
  mutate(AllStar = 1)

#ok now join this with the standard players
Allstar.standard.DF <- left_join(Standard.players, Allstars, by = c("playerID", "yearID"))

#then every NA in the Allstar column needs to be a 0
Allstar.standard.DF[which(is.na(Allstar.standard.DF$AllStar)), 31] <- 0

#quick check to see what priors we have
# nrow(Allstar.standard.DF %>% filter(AllStar == 1)) / nrow(Allstar.standard.DF %>% filter(AllStar == 0))

#next join with catchers
Allstar.catcher.DF <- left_join(Catchers, Allstars, by = c("playerID", "yearID"))
Allstar.catcher.DF[which(is.na(Allstar.catcher.DF)), 34] <- 0

# nrow(Allstar.catcher.DF %>% filter(AllStar == 1)) / nrow(Allstar.catcher.DF %>% filter(AllStar == 0))

#finally with pitchers
Allstar.pitcher.DF <- left_join(Pitchers, Allstars, by = c("playerID", "yearID"))
Allstar.pitcher.DF[which(is.na(Allstar.pitcher.DF$AllStar)), 31] <- 0

# nrow(Allstar.pitcher.DF %>% filter(AllStar == 1)) / nrow(Allstar.pitcher.DF %>% filter(AllStar == 0))

#ok, accross these three position types we have about 4-5% of players 
#making the Allstar game...

#lets write all these to our derived_data directory

write.csv(Allstar.standard.DF, "derived_data/Clean.Fielders.csv", row.names = F)
write.csv(Allstar.catcher.DF, "derived_data/Clean.Catchers.csv", row.names = F)
write.csv(Allstar.pitcher.DF, "derived_data/Clean.Pitchers.csv", row.names = F)