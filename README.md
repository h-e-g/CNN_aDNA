# CNN_aDNA


------

ABC estimation of the intensity and timing of selection from ancient genomes (Kerner et al., Cell Genomics 2023; https://www.sciencedirect.com/science/article/pii/S2666979X22002117).

Deep estimation based on convolutional neural networks (CNNs) (Laval et al., BioRxiv 2023; https://doi.org/10.1101/2023.07.27.550703)

----



------

 Software requirements:

- Simulations: SLiM v3, R (+ dplyr package), perl

- Estimations: Python (+ Keras, TenorFlow), R (+ abc package), perl

-------




The intensity of selection	=	selection strength or selection coefficient (s)

The timing of selection		=	time of onset of selection (T)



Simulations:

- Code for simulating ancient DNA samples as described in Kerner et al., Cell Genomics 2023
	
- Code was written in SLiM and uses a well-established European demography for the past 10,000 years.

Estimation:

- ABC estimations of selection strength (s) and time of onset of selection (T) are conducted using R (R code for estimating selection parameters using ABC can be alo found at https://github.com/h-e-g/SLiM_aDNA_selection/)

- CNN estimations of selection strength (s) and time of onset of selection (T) are conducted using python/keras/TensorFlow



Estimation is performed using as input data simulated data and real SNP data. 

- Simulated data is a matrix file where rows represent different simulations and columns carrier status {0,1} of a simulated sample; see OUTPUT/SIMULATIONS/RESULTS/SLiM.slim/TEST/JOB_1/FreqaDNA_tmp.txt. This matrix is generated as explained below.
	
- Real data is genotype data from ancient samples formatted exactly as simulated data. As a test the first row of OUTPUT/SIMULATIONS/RESULTS/SLiM.slim/TEST/JOB_2/FreqaDNA_tmp.txt can be used as a real SNP to estimate selection using simulated data from OUTPUT/SIMULATIONS/RESULTS/SLiM.slim/TEST/JOB_1/FreqaDNA_tmp.txt



On performing simulations (hierarchical file structure):
Read 'ABC_SLIM.sh' for details on running simulations

Simulation parameters are defined in SETTINGS.sh (e.g., number of jobs and number of simulations per job). Check SETTINGS.sh file for full list of pre-defined parameters.
! Directories need to be changed to local directories when running. Check all scripts have updated directories
To run:
./ABC_SLIM.sh SETTINGS.sh

Ancient DNA metadata to define demography and run simulations can be found in METADATA/

Expected output: We provide an expected output when running ./ABC_SLIM.sh SETTINGS.sh for the pre-defined parameters in the shared files and the metadata provided in METADATA
The ouptut is for 405 simulations each run on two separate jobs
Software requirements: SLiM v3, R (+ dplyr package), perl

