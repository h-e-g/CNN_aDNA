# CNN_aDNA
Deep estimation of the intensity and timing of selection from ancient genomes (Laval et al., BioRxiv 2023; https://doi.org/10.1101/2023.07.27.550703)



Code for simulating ancient DNA-related data and estimating selection parameters as proposed by Laval et al., BioRxiv 2023

Simulations:

Code for simulating ancient DNA samples as described in Laval et al., BioRxiv 2023 and previously described in Kerner et al., Cell Genomics 2023. 
Code was written in SLiM and uses a well-established European demography for the past 10,000 years. 

Estimation:

ABC and CNN estimation of selection strength (s) and time of onset of selection (T) are conducted using R

R code for estimating selection parameters using ABC are provided in https://github.com/h-e-g/SLiM_aDNA_selection/





Performing simulations (hierarchical file structure):
Read 'ABC_SLIM.sh' for details on running simulations

Simulation parameters are defined in SETTINGS.sh (e.g., number of jobs and number of simulations per job). Check SETTINGS.sh file for full list of pre-defined parameters.
! Directories need to be changed to local directories when running. Check all scripts have updated directories
To run:
./ABC_SLIM.sh SETTINGS.sh

Ancient DNA metadata to define demography and run simulations can be found in METADATA/

Expected output: We provide an expected output when running ./ABC_SLIM.sh SETTINGS.sh for the pre-defined parameters in the shared files and the metadata provided in METADATA
The ouptut is for 405 simulations each run on two separate jobs
Software requirements: SLiM v3, R (+ dplyr package), perl

