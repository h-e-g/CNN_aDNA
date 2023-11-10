#!/bin/bash
## Copyright 2020 GEH Institut Pasteur, Guillaume Laval (glaval@pasteur.fr) and Gaspard Kerner (gakerner@pasteur.fr), see ABC_SLiM.sh for more information

declare -i iJOB=1
declare -i nJOB=1

## CHECK SETTINGS FILE
echo -e "$0 is runing"
if [ -z $1 ]
then
	echo -e "\tmissing arguments [SETTINGS] (specify the name of the settings file)"; exit
else
	if [ -f "$1" ]
	then
		source $1
		echo -e "\treading settings ('$1' file is used)\n"
	else
		echo -e  "\tunknown settings file, abort "'!'"\n"; exit
	fi
fi	
	
	
nJOB_main="$nJOB"
#nJOB_delayed1=1
FINALOUTPUT=$OUTPUT
	
## CREATES ONE FOLDER PER JOB (i.e., PER SIMULATION)
echo -e "\t$FINALOUTPUT"
iJOB=1
while [ $iJOB -le $nJOB ]
do	
	if [ `expr $iJOB % 100` -eq 0 ]
	then
		echo -e "\t\tpreparing $FINALOUTPUT/JOB_$iJOB"
	fi
				
	if [ -d "$FINALOUTPUT/JOB_$iJOB" ]
	then
		rm -R "$FINALOUTPUT/JOB_$iJOB"  ;  mkdir "$FINALOUTPUT/JOB_$iJOB"
	else
		mkdir "$FINALOUTPUT/JOB_$iJOB"
	fi
				
	cat "$INPUT_SLIM" > $FINALOUTPUT/JOB_$iJOB/$DEMOGRAPHY
	sed -i -e "s/\$LENGTH/$LENGTH/g" $FINALOUTPUT/JOB_$iJOB/$DEMOGRAPHY
		
	iJOB=$iJOB+1
done
			
			
## RUN MAIN MODEL, TO EVENTUALLY RUN SLIM FILE ON SIMULATED PARAMETERS (see 'draw_parameter.pl')
submit_mainscript="submit_ESTIMATION.sh"
{
	echo "#!/bin/bash";				
	echo "#$ -cwd" ;  echo "#$ -N SLIM3" ;  echo "#$ -j y" ; echo "#$ -S /bin/bash"
	echo " "				
	if [ "$MACHINE" == "SLURM" ]
	then
		echo " "
		echo "cp slim  $FINALOUTPUT/JOB_$TASK_ID"
		echo " "				
							
		echo "cp draw_parameter.pl  $FINALOUTPUT/JOB_$TASK_ID"
									
		echo "cp run_slim3.pl  $FINALOUTPUT/JOB_$TASK_ID"
					
					
		echo " "
		echo "cd  $FINALOUTPUT/JOB_$TASK_ID"
		echo "module load R/4.1.0"
		echo "R_LIBS_USER=/pasteur/zeus/projets/p02/IGSR/GASPARD/Rlibraries/4.1.0/; export R_LIBS_USER"
					
		echo " "
		echo "perl run_slim3.pl ${NSIM} ${DEMOGRAPHY} ${thresQuality} ${GenerationTimeSpan} ${StartPulse1} ${StopPulse1} ${StartPulse2} ${StopPulse2} ${SlidingWindow} ${WindowLength} ${FullFileName} ${NameSource1} ${NameSource2} ${NameAge} ${NameSNP_hits} ${NameSubjectID}"
		echo " "	
	fi       				
	echo " "
} > "$submit_mainscript"
chmod +x "$submit_mainscript"

## JOBS ARE SPLITTED ACROSS THE CLUSTER		
echo "1\tsbatch --qos=$QOS --array=1-$nJOB_main%1000 --mem-per-cpu=$CPU -o ${DIR_LOG}/slurm-%A_%a.out -e ${DIR_LOG}/slurm-%A_%a.err $submit_mainscript"
message=`sbatch --qos=$QOS --array=1-$nJOB_main%1000 --mem-per-cpu=$CPU -o ${DIR_LOG}/slurm-%A_%a.out -e ${DIR_LOG}/slurm-%A_%a.err "$submit_mainscript"`				
echo "CLUSTER said: $message"		
job=`echo "$message" | sed -e 's/.*Submitted batch job*//'`
job=`echo "$job" | sed -e 's/ //g' | cut -d"." -f1 `
	
		
	