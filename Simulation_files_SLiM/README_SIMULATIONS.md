#### Simulations of ancient and modern genotypes

Code for simulating ancient DNA-related data as proposed by Kerner et al., Cell Genomics 2023.

------

Simulations:

- Code for simulating ancient DNA samples as described in Kerner et al., Cell Genomics 2023
	
- Code was written in SLiM and uses a well-established European demography for the past 10,000 years.

- Software requirements: SLiM v3, R (+ dplyr package), perl

-------

On performing simulations (hierarchical file structure):

./ABC_SLIM.sh SETTINGS.sh

Read 'ABC_SLIM.sh' for details on running simulations. Simulations are performed according to the SLiM input file called "SLiM.slim". The simulation parameters are defined in SETTINGS.sh (e.g., number of jobs and number of simulations per job). Check SETTINGS.sh file for full list of pre-defined parameters. Ancient DNA metadata to run simulations can be found in METADATA/

**Important note: Directories need to be changed to local directories when running. Check all scripts have updated directories


-------

Expected output:

We provide an expected output when running ./ABC_SLIM.sh SETTINGS.sh for the pre-defined parameters in the shared files and the metadata provided in METADATA. The ouptut is for 405 simulations each run on two separate jobs. 

- Simulated data is a matrix file where rows represent different simulations and columns carrier status {0,1} of a simulated sample; see OUTPUT/SIMULATIONS/RESULTS/SLiM.slim/TEST/JOB_1/FreqaDNA_tmp.txt. This matrix is generated as explained below.
	
- These simulated data are used as training dataset for performing CNN and ABC estimations. Real data is genotype data from ancient samples formatted exactly as simulated data. See the CNN/LCT/ folder stroring simulated and empirical data files.


