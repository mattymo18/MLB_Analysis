.PHONY: clean

# Cleans Repo
clean:
	rm derived_data/*.csv
	rm derived_graphics/*.png
	rm README_graphics/*.png
	
# Builds final report	
Analysis.pdf:\
 Analysis.Rmd
	R -e "rmarkdown::render('Analysis.Rmd')"
	
# Builds Proposal
Proposal.pdf:\
 Proposal.Rmd
	R -e "rmarkdown::render('Proposal.Rmd')"
	
# Clean data and data glimpse table
README_graphics/Data.Glimpse.png\
derived_data/Clean.Pitchers.csv\
derived_data/Clean.Catchers.csv\
derived_data/Clean.Fielders.csv:\
 tidy_data.R
	Rscript tidy_data.R
	
#balanced clean tidy_data
derived_data/Catch.Balanced.csv\
derived_data/Pitch.Balanced.csv\
derived_data/OF.Balanced.csv\
derived_data/SS.Balanced.csv\
derived_data/3B.Balanced.csv\
derived_data/2B.Balanced.csv\
derived_data/1B.Balanced.csv:\
 derived_data/Clean.Pitchers.csv\
 derived_data/Clean.Catchers.csv\
 derived_data/Clean.Fielders.csv\
 tidy_balanced_data.R
	Rscript tidy_balanced_data.R
	
	
#readme plots
README_graphics/HR.plot.png\
README_graphics/Pitcher.plot.png:\
 derived_data/Catch.Balanced.csv\
 derived_data/Pitch.Balanced.csv\
 derived_data/OF.Balanced.csv\
 derived_data/SS.Balanced.csv\
 derived_data/3B.Balanced.csv\
 derived_data/2B.Balanced.csv\
 derived_data/1B.Balanced.csv\
 tidy_README_plots.R
	Rscript tidy_README_plots.R

#k-means plots
derived_graphics/Pitchers.Cluster.png\
derived_graphics/Pitchers.Optim.Cluster.png\
derived_graphics/Catchers.Cluster.png\
derived_graphics/Out.Field.Cluster.png\
derived_graphics/Short.Stop.Cluster.png\
derived_graphics/Third.Base.Cluster.png\
derived_graphics/Second.Base.Cluster.png\
derived_graphics/First.Base.Cluster.png\
derived_graphics/Catchers.Optim.Cluster.png\
derived_graphics/Out.Field.Optim.Cluster.png\
derived_graphics/Short.Stop.Optim.Cluster.png\
derived_graphics/Third.Base.Optim.Cluster.png\
derived_graphics/Second.Base.Optim.Cluster.png\
derived_graphics/First.Base.Optim.Cluster.png:\
 derived_data/Catch.Balanced.csv\
 derived_data/Pitch.Balanced.csv\
 derived_data/OF.Balanced.csv\
 derived_data/SS.Balanced.csv\
 derived_data/3B.Balanced.csv\
 derived_data/2B.Balanced.csv\
 derived_data/1B.Balanced.csv\
 K-Means_Cluster.R
	Rscript K-Means_Cluster.R
	
#knn models
derived_models/knn.catcher.rds\
derived_models/knn.fielder.rds\
derived_models/knn.pitcher.rds: \
 derived_data/Clean.Pitchers.csv\
 derived_data/Clean.Fielders.csv\
 derived_data/Clean.Catchers.csv\
 KNN_Classify.R
	Rscript KNN_Classify.R