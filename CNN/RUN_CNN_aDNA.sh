#!/bin/bash


if [ -z $1 ]
then
	echo "CNN predictions";
else
	echo "No arguments expected, quit";
	exit;
	#JOBFOLDER="$1";
	#SELSCENARIO="$2";
	#LOCATION="$3";
	
	#CNN="$4"
fi
	
	#Python from apptainer 
	module load apptainer
	container="/pasteur/zeus/projets/p02/ABCsel/DEEPLEARNING/Singularity/IA_v5.sif"
	mount_path="/pasteur/zeus/projets/p02/ABCsel/DEEPLEARNING"
	DL_script_path="/mnt/ADNA_TRAJECTORY/1DCONVOLUTION/SIMULATIONS_ADDITIVE/SIMULATED_IMAGES_GITHUB"	
	DL_script="CNN_aDNA.py"
	
	
	#Folder where files are stored
	JOBFOLDER="./JOB_1"
	#JOBFOLDER="./LCT"
	
	#Read the name of the analyzed variant stored in "0-Variant_analyzed.txt"
	while read line  
	do   
		temp=( `echo $line | tr -d '\r\n' | cut -d' ' -f1` )
		if [ ! -z $temp ]
		then		
			variant=$temp
		fi
	done < $JOBFOLDER"/0-Variant_analyzed.txt"
	
	#Compute the size of the emprical inputdata
	tmp=( `cat $JOBFOLDER/empirical_1D_image_$variant.txt | wc ` \ )
	shape=${tmp[1]}
	
	
	#Create a folder in order to store results (cross validations + predictions on real data)
	#Mandatory : update CNN_aDNA.py to change the folder name and/or the outputfiles location
	CROSSVALFOLDER=$JOBFOLDER"/crossval"
	if [ -d $CROSSVALFOLDER  ]
	then
		echo -e "keeping '$CROSSVALFOLDER'"
	else
		echo -e "creating '$CROSSVALFOLDER'"			
		mkdir "$CROSSVALFOLDER"		
	fi
	
	#Create a folder in order to save the CNN trained model 
	#Mandatory : update CNN_aDNA.py to change the folder name and/or the outputfiles location
	SAVEDMODELFOLDER=$JOBFOLDER"/saved_model"
	if [ -d $SAVEDMODELFOLDER  ]
	then
		echo -e "keeping '$SAVEDMODELFOLDER'"
	else
		echo -e "creating '$SAVEDMODELFOLDER'"			
		mkdir "$SAVEDMODELFOLDER"		
	fi
	
	#Run the CNN predictions
	apptainer run --bind $HOME,$mount_path:/mnt "$container" "$DL_script_path" "$DL_script" "$JOBFOLDER" "$variant" "$shape" 