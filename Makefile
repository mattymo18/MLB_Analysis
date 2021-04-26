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
	
# Clean data
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