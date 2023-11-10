#!/bin/bash

## This file is used to set the parameters required for the following scripts

## 1	- 	ABC_SLiM.sh : the (main) script prepares (check files and path) and launches simulations (call of RUN_SLiM.sh)
## 2	- 	RUN_SLiM.sh : creates folders at the indicated location according to the number of jobs (argument TASK_ID) and a script for submission on the cluster "submit_mainscript"
## 3	- 	"submit_mainscript" file : copies softwares and files to be used in the simulation process to the folders (see above) and run parameter selection (call of draw_parameter.pl), which randomly selects parameters according to the defined ranges and includes them in the demographic model, which is run by SLiM v3, and frequency estimation (call of run_slim3.pl) file, which runs the demographic model (call of slim) and extracts frequencies at the different epochs.
## 3	-   Parameters chosen with draw_parameter.pl are saved in parameters.txt (one simulation by row) and frequencies (one simulation by row) extracted with run_slim3.pl to FreqaDNA_tmp.txt

WORK_DIR="/pasteur/zeus/projets/p02/IGSR/GASPARD/GUILLAUME_CNN/GITHUB/Files_For_Slim/"
DIR_LOG="/pasteur/zeus/projets/p02/IGSR/GASPARD/GUILLAUME_CNN/GITHUB/Files_For_Slim/logs"
mkdir -p ${DIR_LOG}
## FILES TO BE USED FOR PERFORMING SIMULATIONS
MASTER_FILE="ABC_SLIM_submissionEurPop.sh"
FUNCTION_CALLER_FILE="RUN_SLiM_submissionEurPop.sh"
RUN_FILE="run_slim3_submission.pl"
PARAMETER_FILE="draw_parameter_submission_NoBurninEurPop.pl"
SLIM_EXECUTABLE="slim"

# METADATA (v44.3_1240K)
FullFileName="${WORK_DIR}/v44.3_1240K_public.anno.Extracted.Ancestries.txt.Extracted.Ancestries.txt";
NameAge="Date mean in BP [OxCal mu for a direct radiocarbon date, and average of range for a contextual date]"
NameGroupID="GroupID"
NameSubjectID="Master ID"
NameSubjectID2="Version ID"
NameLat="Lat."
NameLong="Long."
NameCountry="Country"
NameSNP_hits="SNPs hit on autosomal targets"

## 3 source populations used to account for ancestry changes across time in Europe over the past 10 000 years
NameSource1="Anatolian"
NameSource2="Yamnaya"
NameSource3="Mesolithic_HG"

## PARAMETERS FOR SIMULATION
OUTPUTDIRECTORY="OUTPUT"
SLIMNAME="SLiM.slim"
OUTPUTNAME="TEST"
SLIM_MODE="SIMULATE"; # DEFAULT OR SLIM_MODE="MAKEBURNIN"
INPUT_SLIM="${WORK_DIR}/${SLIMNAME}"
IFS='/' read -a array <<< "${INPUT_SLIM}"
DEMOGRAPHY=${array[ ${#array[@]} - 1 ]}; ## name of the input file for SliM (v3)
OUTPUT="${OUTPUTDIRECTORY}/SIMULATIONS/RESULTS/${DEMOGRAPHY}/${OUTPUTNAME}"				; ## to store the simulation files
NSIM="2000" ; nJOB="2" ; ### simulations per job (NSIM) and number of jobs (nJOB)

## PARAMETERS FOR ESTIMATING PULSE INTENSITIES (input values for Rscript 'ParametersToSimulateSLIM.R')
thresQuality=50; # Get the XX% percentile of best covered samples
GenerationTimeSpan=250; # length of a time transect in the model (generation time is 25y; because of rescaling in the simulation process Tsim = 10 x T)
StartPulse1=6000; # Time in Before Present (BP) units as the lower limit to estimate intensity of pulse 1
StopPulse1=9000; # Time in Before Present (BP) units as the upper limit to estimate intensity of pulse 1
StartPulse2=1000; # Time in Before Present (BP) units as the lower limit to estimate intensity of pulse 2
StopPulse2=3500; #  Time in Before Present (BP) units as the upper limit to estimate intensity of pulse 2
SlidingWindow=500; # Sliding window for pulse intensity estimation
WindowLength=1000; # Window length for pulse intensity estimation

## PARAMETERS FOR CLUSTER MACHINE
MACHINE="SLURM"; ## System
TASK_ID="\$SLURM_ARRAY_TASK_ID"		
##Users submitting on nodes belonging to research units or projects must replace the dedicated partition by the name of the qos/account as in:
QOS="fast -p common,dedicated"
CPU="4000"

## RUNNING EXAMPLE
#./ABC_SLIM.sh SETTINGS.sh



