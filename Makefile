.PHONY: clean

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