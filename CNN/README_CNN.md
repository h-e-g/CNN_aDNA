
Files for the CNN estimations 

##### Setting files

1 - SETTINGS_MAIN.txt
Tabulated text file to set various options for computations. 

	analyse:		NORMAL / CUSTOM ( to handle the files given in example, see below )
	usage:			PREDICTION (for performing predictions from a trained model )/ TRAINING (for training a model performing predictions )
	name_model:		For giving a name of the CNN model
	verbose:		To print some variables


2 - Settings for the CNN architectures
File that can be used to set the CNN architecture. Example of files to set the simplified CNN architecture, SETTINGS_CNN_architecture_simplified.txt

	Settings for convolution layers: Conv1D	28	10	my1Dconvolution_2. The sring "Conv1D" calls for	keras.layers.Conv1D( 28 , kernel_size=10, input_shape=input_shape, name=name[i])
	Settings for  Pooling layers: Pool1D	2	NA	myMaxPool_2. The string "Pool1D" calls for	keras.layers.MaxPooling1D(pool_size=poolsize)
	Settings for  Flaten layers: Flatten	NA	NA	myFlatten_1. The string "Flatten" calls for	layers.Flatten()(x)
	Settings for  dense layers: Dense	128	NA	myDense_1. The string "Dense" calls for	keras.layers.Dense(nbdense, activation=tf.nn.relu)(x)


###### Data files 
We provide simulated and empirical files necessary for estimating the selection parameters for the lactase persistence variant (rs4988235, LCT-MCM6). These example files can be found in the folder LCT.

1 - Training files.
Files storing simulated data used to train the model

	a - Simulated 1D images : ex., "A_trainingset_476800_1D_grayscale_images_POSSEL_SNP_rs4988235.READY.txt". List of simulated 1D images with 1 image per raw. A 1D image is the list of 0 and 1, 0 being the ancestral allele, 1 being the derived allele. Here ancient individuals are sorted by age and are pseudo-haploids (1 allele er genotype) and modern individuals are diploids. 
	b - Simulated parameters : ex., "A_trainingset_476800_params_POSSEL_SNP_rs4988235.READY.txt". List of the corresponding simulated parameters (the labels of the simulated images). The column 1 is the selection coefficient. The column 2 is the the age of selection (the rank, ascending order, of the simulated generations in SLiM).

Note: the simulated files provided were simulated according the number and the age of the ancient individuals with genotypes for the lactase persistence allele.

2 - Cross validations files
Files storing simulated data used to assess the accuracy of the CNN predictions. These simulated data are used as being empirical data for which the value of the parameters are known.
For each of these simulated data, the CNN_aDNA.py script estimates the s and T values using the model trained from the simulated data shown above.
	a - Simulated 1D images : ex., "A_crossvalset_476800_200_1D_grayscale_images_POSSEL_SNP_rs4988235.READY.txt". List of simulated 1D images with 1 image per raw, see above.
	b - Simulated parameters : ex., "A_crossvalset_476800_200_params_POSSEL_SNP_rs4988235.READY.txt". List of the simulated parameters corresponding to the simulated images used for cross validations, see above.

3 - Empirical files
1D image for the lactase persistence allele (same shape as for the simulated 1D image shown above). 
"empirical_1D_image_rs4988235.txt"

4 - Files for ABC estimations
We also provide the alle frequencies trajectories to perform the ABC estimations of s and T
	"A_abc_trainingset_476800_freqTraj_POSSEL_SNP_rs4988235.READY.txt":		simulated trajectories corresponding to the simulated data used to train the CNN (see above).
	"A_abc_crossvalset_476800_200_freqTraj_POSSEL_SNP_rs4988235.READY.txt:	simulated trajectories corresponding to the simulated data used for cross validations (see above).
Note: the simulated values of parameters are stored in the "A_trainingset_476800_params_POSSEL_SNP_rs4988235.READY.txt" and "A_crossvalset_476800_200_params_POSSEL_SNP_rs4988235.READY.txt" files (see above).

	"A_abc_real_data_freqTraj_rs4988235.txt":		empirical trajectories for the lactase persistence variant (rs4988235, LCT-MCM6).






