#!/bin/bash


#shopt -s expand_aliases
#source ~/.bashrc
#R="/cygdrive/c/Program\ Files/R/R-3.2.3/bin/x64/R.exe"


declare -i i=0

if [ -z $1 ]
then
	echo "Arguments expected";
else
	JOBFOLDER="$1";
fi
	
	
	#module load R/3.6.2
	module load R/4.1.0
	
	
	#Read the name of the analyzed variant stored in "0-Variant_analyzed.txt"
	while read line  
	do   
		temp=( `echo $line | tr -d '\r\n' | cut -d' ' -f1` )
		if [ ! -z $temp ]
		then		
			variant=$temp
		fi
	done < $JOBFOLDER"/0-Variant_analyzed.txt"
	
	#Run the ABC predictions on real data
	OBSDATATYPE="EMPIRICAL"
	echo "Rscript ABC_freqTraj.r $JOBFOLDER $OBSDATATYPE $variant";
	Rscript ABC_freqTraj.r "$JOBFOLDER" "$OBSDATATYPE" "$variant";
	
	#Run the ABC predictions on simulated data for cross validations
	OBSDATATYPE="CROSSVALIDATION"
	echo "Rscript ABC_freqTraj.r $JOBFOLDER $OBSDATATYPE $variant";
	Rscript ABC_freqTraj.r "$JOBFOLDER" "$OBSDATATYPE" "$variant";
	
	
	
	
	