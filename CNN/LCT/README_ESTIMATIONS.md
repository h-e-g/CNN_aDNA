Toy example : CNN predictions for the Lactase persistence allele (rs4988235, LCT-MCM6)  

1 - Empirical data file

  "empirical_1D_image_rs4988235.txt": 1D image for the lactase persistence allele with 1640 ancient pseudo-haploid genotypes sorted by radiocarbon ages, the rest being current diploid genotypes (500 Europeans individuals from 1000 Genomes data)). 

2 - CNN Training files.
"A_trainingset_476800_1D_grayscale_images_POSSEL_SNP_rs4988235.READY.txt": list of simulated 1D images (1 image per raw) of age-sorted genotypes, 0 being the ancestral allele, 1 being the derived allele. Simulations are matched by the number and the age of ancient pseudo-haploid genotypes observed in empirical data. 
"A_trainingset_476800_params_POSSEL_SNP_rs4988235.READY.txt": ist of the corresponding simulated parameters (the labels of the simulated images), the column 1 and 2 being is the selection coefficient and the age of selection (the rank, ascending order, of the simulated generations in SLiM) respectively.

3 - CNN Cross validations files
"A_crossvalset_476800_200_1D_grayscale_images_POSSEL_SNP_rs4988235.READY.txt": list of simulated 1D images as being empirical data for which the value of the parameters are known.
"A_crossvalset_476800_200_params_POSSEL_SNP_rs4988235.READY.txt": list of the corresponding simulated parameters, see above.


4 - ABC estimation files
"A_abc_real_data_freqTraj_rs4988235.txt":		empirical trajectories for the lactase persistence variant (rs4988235, LCT-MCM6).
"A_abc_trainingset_476800_freqTraj_POSSEL_SNP_rs4988235.READY.txt":		simulated trajectories corresponding to the simulated data used to train the CNN (see above).
"A_abc_crossvalset_476800_200_freqTraj_POSSEL_SNP_rs4988235.READY.txt:	simulated trajectories corresponding to the simulated data used for cross validations (see above).
Note: the simulated values of parameters are stored in the "A_trainingset_476800_params_POSSEL_SNP_rs4988235.READY.txt" and "A_crossvalset_476800_200_params_POSSEL_SNP_rs4988235.READY.txt" files (see above).
"weights_rs4988235.txt": weight of the summary statistics (modified version of ABC, Kerner et al., Cell Genomics 2023)  
"Derived_statu_rs4988235.txt": if 1 the empirical frequency trajectory is the derived frequency trajectory, if 0 the empirical frequency trajectory is the ancestral frequency trajectory, 





