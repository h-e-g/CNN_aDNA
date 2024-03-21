#### Simulations of ancient individuals

Code for simulating ancient DNA-related data as proposed by Kerner et al., Cell Genomics 2023.

------

Simulations:

- Code for simulating ancient DNA samples as described in Kerner et al., Cell Genomics 2023
	
- Code was written in SLiM and uses a well-established European demography for the past 10,000 years.


On performing simulations (hierarchical file structure):
Read 'ABC_SLIM.sh' for details on running simulations

Simulation parameters are defined in SETTINGS.sh (e.g., number of jobs and number of simulations per job). Check SETTINGS.sh file for full list of pre-defined parameters.
! Directories need to be changed to local directories when running. Check all scripts have updated directories


To run:
./ABC_SLIM.sh SETTINGS.sh

Ancient DNA metadata to run simulations can be found in METADATA/

Expected output: We provide an expected output when running ./ABC_SLIM.sh SETTINGS.sh for the pre-defined parameters in the shared files and the metadata provided in METADATA
The ouptut is for 405 simulations each run on two separate jobs
Software requirements: SLiM v3, R (+ dplyr package), perl

