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