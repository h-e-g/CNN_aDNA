#!/bin/bash


	
	module load R/4.1.0
	R_LIBS_USER=/pasteur/appa/homes/glaval/Rlibraries/4.1.0; export R_LIBS_USER
	
	#########################################
	# REPLICATE FIGURE 2 of the manuscrit
	Rscript GITHUB_Figure_2_NEW.r
	
	
	