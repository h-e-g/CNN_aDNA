#!/bin/bash
## Copyright 2020 GEH Institut Pasteur, Guillaume Laval (glaval@pasteur.fr) and Gaspard Kerner (gakerner@pasteur.fr) 
## SLiM v3

## 1	- 	ABC_SLiM.sh : the (main) script prepares (check files and path) and launches simulations (call of RUN_SLiM.sh)
## 2	- 	RUN_SLiM.sh : creates folders at the indicated location according to the number of jobs (argument TASK_ID) and a script for submission on the cluster "submit_mainscript"
## 3	- 	"submit_mainscript" file : copies softwares and files to be used in the simulation process to the folders (see above) and run parameter selection (call of draw_parameter.pl), which randomly selects parameters according to the defined ranges and includes them in the demographic model, which is run by SLiM v3, and frequency estimation (call of run_slim3.pl) file, which runs the demographic model (call of slim) and extracts frequencies at the different epochs.
## 3	-   Parameters chosen with draw_parameter.pl are saved in parameters.txt (one simulation by row) and frequencies (one simulation by row) extracted with run_slim3.pl to FreqaDNA_tmp.txt

declare -i i=1
declare -i h=1

echo -e "$0 is runing"

## CHECK SETTINGS FILE
if [ -z $1 ]
then
	echo -e "\tmissing arguments [SETTINGS] (specify the name of the settings file)"; exit
else
	if [ -f "$1" ]
	then
		source $1
		echo -e "\treading settings ('$1' file is used)\n"
	else
		echo -e  "\tUnknown settings file, abort "'!'"\n"; exit
	fi
fi


echo -e "\tstarting SLiM simulations. BURNIN files are assumed to exist or to not be needed."

## CHECK SLiM FILE
if [ ! -f "$INPUT_SLIM" ]
then
	echo -e "\tUnknown SLiM parameter file '$INPUT_SLIM', abort "'!'"\n"; exit
else
	echo -e "\tSLiM parameter file '$INPUT_SLIM' OK "'!'
fi

	
## CHECK AND CREATE OR CLEAN (IN CASE IT ALREADY EXISTS) OUTPUT FOLDER
echo -e ""
if [ -d "$OUTPUT" ]
then
	echo -e "\tcleaning output folder '$OUTPUT'"
	rm -R "$OUTPUT"  ;  mkdir "$OUTPUT"
else
	echo -e "\tcreating output folder '$OUTPUT'"
	IFS='/' read -a array <<< "$OUTPUT"
	i=0;fold="";created="0"
	while [ ${array[$i]} ]
	do 
		fold=$fold"${array[ $i ]}/"
		if [ ! -d "$fold" ]
		then
			mkdir "$fold"
	fi
		i=$i+1
	done
fi
echo -e "\tsimulations will be stored in '$OUTPUT'"

./RUN_SLiM.sh "$1"