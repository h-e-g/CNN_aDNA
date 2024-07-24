# CNN_aDNA


------

ABC estimation of the intensity and timing of selection from ancient genomes (Kerner et al., Cell Genomics 2023; https://www.sciencedirect.com/science/article/pii/S2666979X22002117).

Deep estimation based on convolutional neural networks (CNNs) (Laval et al., BioRxiv 2023; https://doi.org/10.1101/2023.07.27.550703)

----



------

 Software requirements:

- Simulations: SLiM v3, R (+ dplyr package), perl

- Estimations: Python (+ Keras, TensorFlow), R (+ abc package), perl

-------




The intensity of selection	=	selection strength or selection coefficient (s)

The timing of selection		=	time of the onset of selection (T)



Computer simulations of ABC and CNN training datasets:

- Code for simulating ancient DNA samples as described in Kerner et al., Cell Genomics 2023.
	
- Code was written in SLiM and uses a well-established European demography for the past 10,000 years.

- Code source for performing the simulations stored in the Simulation_files_SLiM folder.

Estimations of s and T :

- ABC estimations are conducted using R (R code for estimating selection parameters using ABC can be alo found at https://github.com/h-e-g/SLiM_aDNA_selection/).

- CNN estimations are conducted using python/keras/TensorFlow.

- Code source for performing ABC and CNN predictions are stored in the CNN folder.

