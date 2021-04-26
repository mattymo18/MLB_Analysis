#load data and libs
library(tidyverse)

Pitchers <- read.csv("derived_data/Clean.Pitchers.csv")
Catchers <- read.csv("derived_data/Clean.Catchers.csv")
Fielders <- read.csv("derived_data/Clean.Fielders.csv")

#set seed for random sampling

set.seed(321)

# After consideration we have decided to make some new datasets 
#that are more balanced per position

# Lets start by just splitting these three sets into positions

# Then I can take out all the Allstars, find the right numbers,
#and randomly sample the non-Allstars to fill in the dataframe


#Start with fielders and get all Allstars
Allstar.1B <- Fielders %>% 
  filter(POS == "1B" & AllStar == 1)
Allstar.2B <- Fielders %>% 
  filter(POS == "2B" & AllStar == 1)
Allstar.3B <- Fielders %>% 
  filter(POS == "3B" & AllStar == 1)
Allstar.SS <- Fielders %>% 
  filter(POS == "SS" & AllStar == 1)
Allstar.OF <- Fielders %>% 
  filter(POS == "OF" & AllStar == 1)

# And non-allstars

No.Allstar.1B <- Fielders %>% 
  filter(POS == "1B" & AllStar == 0)
No.Allstar.2B <- Fielders %>% 
  filter(POS == "2B" & AllStar == 0)
No.Allstar.3B <- Fielders %>% 
  filter(POS == "3B" & AllStar == 0)
No.Allstar.SS <- Fielders %>% 
  filter(POS == "SS" & AllStar == 0)
No.Allstar.OF <- Fielders %>% 
  filter(POS == "OF" & AllStar == 0)

#then rbind and get correct class distribution of 1/3 All stars

First.Base.clean <- rbind(Allstar.1B, sample_n(No.Allstar.1B, 2*nrow(Allstar.1B)))
Second.Base.clean <- rbind(Allstar.2B, sample_n(No.Allstar.2B, 2*nrow(Allstar.2B)))
Third.Base.clean <- rbind(Allstar.3B, sample_n(No.Allstar.3B, 2*nrow(Allstar.3B)))
Short.Stop.clean <- rbind(Allstar.SS, sample_n(No.Allstar.SS, 2*nrow(Allstar.SS)))
Out.Field.clean <- rbind(Allstar.OF, sample_n(No.Allstar.OF, 2*nrow(Allstar.OF)))

#now do they same for pitchers and catchers

Allstar.P <- Pitchers %>% 
  filter(AllStar == 1)

No.Allstar.P <- Pitchers %>% 
  filter(AllStar == 0)

Pitchers.clean <- rbind(Allstar.P, sample_n(No.Allstar.P, 2*nrow(Allstar.P)))

Allstar.C <- Catchers %>% 
  filter(AllStar == 1)

No.Allstar.C <- Catchers %>% 
  filter(AllStar == 0)

Catchers.clean <- rbind(Allstar.C, sample_n(No.Allstar.C, 2*nrow(Allstar.C)))

#Now save everything to derived_data

write.csv(First.Base.clean, "derived_data/1B.Balanced.csv")
write.csv(Second.Base.clean, "derived_data/2B.Balanced.csv")
write.csv(Third.Base.clean, "derived_data/3B.Balanced.csv")
write.csv(Short.Stop.clean, "derived_data/SS.Balanced.csv")
write.csv(Out.Field.clean, "derived_data/OF.Balanced.csv")
write.csv(Pitchers.clean, "derived_data/Pitch.Balanced.csv")
write.csv(Catchers.clean, "derived_data/Catch.Balanced.csv")
