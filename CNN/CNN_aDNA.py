# -*- coding: utf-8 -*-
"""
Guillaume laval: 11/01/2024
A Deep learning alforithm to jointly estimate 
    - SELECTION COEFFICIENT
    - AGE of SELECTION
from aDNA genotypes
"""


#Import libraries
import os
import sys
import numpy as np
import tensorflow as tf
import matplotlib.pyplot as plt


from array import array

#############   LOADING SCRIPT PARAMETERS       ###############################
#
jobfolder=sys.argv[1];
snp_name=sys.argv[2];
Ngenot=int( sys.argv[3] );
###############################################################################

#Initialize some variables
file_location=jobfolder
output_location=jobfolder
file_sim_image=''
file_sim_param=''
file_cross_image=''
file_cross_param=''
snp_file=''
name_model=''


#############   LOADING MAIN SETTINGS       ###################################
#
settings_main   ='SETTINGS_MAIN.txt'
myfile = open(settings_main, "r")
header = myfile.readline();
##### Reading the number of epochs for training
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; temp = myline.split("\t")
My_analyse=temp[1];
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; temp = myline.split("\t")
My_usage=temp[1];
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; temp = myline.split("\t")
My_file_sim_image=temp[1];
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; temp = myline.split("\t")
My_file_sim_param=temp[1];
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; temp = myline.split("\t")
My_file_cross_image=temp[1];
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; temp = myline.split("\t")
My_file_cross_param=temp[1];
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; temp = myline.split("\t")
My_snp_file=temp[1];
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; temp = myline.split("\t")
My_name_model=temp[1];
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; temp = myline.split("\t")
My_verbose=temp[1];
myfile.close()

analyse = My_analyse;
usage=My_usage;
verbose=My_verbose;
###############################################################################


#############   LOADING SETTINGS FOR CNN    ###################################
#
settings_cnn   ='SETTINGS_CNN_architecture_simplified.txt'
myfile = open(settings_cnn, "r")
##### Reading the number of epochs for training
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; x = myline.split("\t")
My_epochs=int( x[1] );
print("\nNumber of epochs for training :",My_epochs)

print("\nReading the CNN architecture : ")
##### Reading the CNN architecture
iline=0;
myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', '') ; x = myline.split("\t")
#print(myline); print(x)

layer =[ x[0] ] ; param1=[ x[1] ] ; param2=[ x[2] ] ; name  =[ x[3] ]
print("\tLayer ",iline," ", layer[iline] ,";", param1[iline] ,";", param2[iline] ,";", name[iline], "")


iline=1; num_line=1
while myline:
	myline = myfile.readline(); myline = myline.replace('\n', ''); myline = myline.replace('\r', ''); x = myline.split("\t")
	#print(myline);	print(x)
	if myline == "":
		break	
	
	layer.append(x[0]); param1.append(x[1]); param2.append(x[2]); name.append(x[3]);
	print("\tLayer ",iline," ", layer[iline] ,";", param1[iline] ,";", param2[iline] ,";", name[iline], "")
	
	
	iline=iline+1 ; num_line=num_line+1

myfile.close()
print("\n\tNumber of layers in CNNs : ",num_line)
###############################################################################


#############   PREPARING SOME STUFF     ######################################
#
if analyse == 'CUSTOM':
	#Nsim="476800" ; Ntraining=476700 ; Nvalid=100 ; Ncross=200; Nsim_crossval=Nsim    
	#for quick debugg
	Nsim="20000" ; Ntraining=10000 ; Nvalid=100 ; Ncross=200; Nsim_crossval=Nsim
	
	#loading the simulated data for training and for cross validations
	file_sim_image   =file_location + '/A_trainingset_' + Nsim + '_1D_grayscale_images_POSSEL_SNP_' + snp_name + '.READY.txt'    
	file_sim_param   =file_location + '/A_trainingset_' + Nsim + '_params_POSSEL_SNP_' + snp_name + '.READY.txt'  
	
	file_cross_image =file_location + '/A_crossvalset_' + Nsim_crossval + '_' + str(Ncross) + '_1D_grayscale_images_POSSEL_SNP_' + snp_name + '.READY.txt'
	file_cross_param =file_location + '/A_crossvalset_' + Nsim_crossval + '_' + str(Ncross) + '_params_POSSEL_SNP_' + snp_name + '.READY.txt'
	
	#loading the empirical data
	snp_file         =file_location + '/empirical_1D_image_' + snp_name + '.txt'
	
	#loading the name of the CNN architecture
	name_model= 'CNN1'
	
else:
	### BY DEFAULT : file names and the nme of the CNN architectureused must be specified by user 
	file_sim_image   =file_location + My_file_sim_image
	file_sim_param   =file_location + My_file_sim_param
	
	file_cross_image =file_location + My_file_cross_image
	file_cross_param =file_location + My_file_cross_param
	
	snp_file         =file_location + My_snp_file
	
	#loading the CNN architecture
	name_model= My_name_model

  

if verbose == 'VERBOSE':
	print ();
	print ('Entering', sys.argv[0] ,'(', (len(sys.argv)-1) , 'arguments ) stored in', os.getcwd() );
	print ('\tTraining data stored in', jobfolder);
	print ('\tsnp', snp_name);
	print ('\tNumber of ancient and modern genotypes', Ngenot);
	
	#print(f);
	#print("num_line",num_line);
	#print("num_col",num_col);
	
	print('\tUsage ', usage, '( ', Ntraining , ' simulated data loaded for training )');
	print('\tCNN name', name_model);
###############################################################################


#############   LOADING DATA    ####################################################
#files names
file_sim_image   =file_sim_image    
file_sim_param   =file_sim_param 
    
file_cross_image =file_cross_image
file_cross_param =file_cross_param

##### load simulated 1D images 
x_tot   = np.loadtxt(file_sim_image)
x_train = x_tot[0:Ntraining];
x_test  = x_tot[Ntraining:(Ntraining+Nvalid)];
x_cross = np.loadtxt(file_cross_image)

##### load simulated parameters (labels = selection coefficietn and age of selection)
y_tot   = np.loadtxt(file_sim_param)
y_cross = np.loadtxt(file_cross_param)

##### Convert labels into nb_classes classes (0, 1, ... , nb_classes)
nb_classes = 100; mydecimals=0
#label 0 (selection coefficient)
min_selcoeff=0; max_selcoeff=0.1 ; diff_selcoeff=(max_selcoeff - min_selcoeff)
y_tot[:,0]   = np.around( ( (  y_tot[:,0]-min_selcoeff)/diff_selcoeff )*nb_classes , decimals=mydecimals)
y_cross[:,0] = np.around( ( (y_cross[:,0]-min_selcoeff)/diff_selcoeff )*nb_classes , decimals=mydecimals)

#label 1 (onset of selection)
min_onset=360; max_onset=395; diff_onset=(max_onset - min_onset)
y_tot[:,1]   = np.around(  ((    y_tot[:,1]-min_onset)/diff_onset)*nb_classes , decimals=mydecimals  )
y_cross[:,1] = np.around(  ((  y_cross[:,1]-min_onset)/diff_onset)*nb_classes , decimals=mydecimals  )

y_tot[y_tot==nb_classes]=(nb_classes-1)


##### create training and cross validations variables
y_train = y_tot[0:Ntraining]
y_test = y_tot[Ntraining:(Ntraining+Nvalid)]

sel_train   = y_train[:,0]
onset_train = y_train[:,1]

sel_test   = y_test[:,0]
onset_test = y_test[:,1]

sel_cross   = y_cross[:,0]
onset_cross = y_cross[:,1]


##### Reshaping arrays
x_tot = x_tot.reshape(x_tot.shape[0], Ngenot, 1)
x_train = x_train.reshape(x_train.shape[0], Ngenot, 1)
x_test = x_test.reshape(x_test.shape[0], Ngenot, 1)
x_cross = x_cross.reshape(x_cross.shape[0], Ngenot, 1)
##### Making sure that the values are float
x_tot = x_tot.astype('float32')
x_train = x_train.astype('float32')
x_test = x_test.astype('float32')
x_cross = x_cross.astype('float32')

print( np.shape(x_train) )
print( np.shape(y_train) )
###############################################################################



#############   SETTING CNN    ################################################
#
from tensorflow.keras.models import Sequential
from tensorflow.keras.layers import Dense, Conv2D, Conv1D, Dropout, Flatten, MaxPooling2D, MaxPooling1D


if usage == 'PREDICTION': #Loading a trained model
	model = tf.keras.models.load_model(output_location + '/saved_model/' + name_model )
	print('\tTraining mode:', usage, ' = previously trained model loaded');
	print('\t-----------------------------------');
	print('\t');
	model.summary()
	
else:	
	print('\tTraining mode', usage, '( ', Ntraining , ' simulated data used for training )');
	print('\t-----------------------------------');
	print('\t');
		
	input_shape = (Ngenot, 1); 
	##### Input layer: 1D image (vector of pixel values [0-1]) 
	input_freqTraj = tf.keras.Input(shape=input_shape, name="img_trajectory")
	
	
	##### CNN architecture read from settings files, e.g., 'SETTINGS_CNN_architecture_simplified.txt'
	for i in range(num_line):
		#if f[i,0] == 1:
		if layer[i] == "Conv1D":
			numfilter=int(param1[i])
			kernelsize=int(param2[i])
			if i == 0:
				#tmpname='conv' + str(i)
				x=tf.keras.layers.Conv1D( numfilter , kernel_size=kernelsize, input_shape=input_shape, name=name[i])(input_freqTraj)
			else:
				#tmpname='conv' + str(i)
				x=tf.keras.layers.Conv1D( numfilter , kernel_size=kernelsize, input_shape=input_shape, name=name[i])(x)
			
		elif layer[i] == "Pool1D":
			poolsize=int(param1[i])
			x=tf.keras.layers.MaxPooling1D(pool_size=poolsize)(x)
			
		elif layer[i] == "Flatten":
			x=tf.keras.layers.Flatten()(x)
			
		elif layer[i] == "Dense":
			nbdense=int(param1[i])
			x=tf.keras.layers.Dense(nbdense, activation=tf.nn.relu)(x)
			
		else:
			print("Unknown layer definition")
	
	##### ouput layer
	sel_pred=tf.keras.layers.Dense(nb_classes,name="selcoeff",activation=tf.nn.softmax)(x)
	onset_pred=tf.keras.layers.Dense(nb_classes,name="onsetsel",activation=tf.nn.softmax)(x)
	
	##### Building the model
	model = tf.keras.Model(inputs=input_freqTraj,outputs=[sel_pred, onset_pred]); #A single ferature
	
	##### Compiling the model
	model.compile(optimizer='adam',loss=['sparse_categorical_crossentropy','sparse_categorical_crossentropy'],loss_weights=[1.0, 1.0], metrics=['accuracy'])
	
	
	model.summary()
	
	print("\n")
	print ('TEMP EXIT FOR SAFETY');
	print ('UNCOMMENT AND RUN AGAIN');
	print("\n")
	exit()


	##### Fitting the model
	fit_metrics=model.fit( x_train, [sel_train, onset_train] , epochs=My_epochs); #A 5 et 10 epoch on un s=0.3, a 20 epoch ca over fit (loss function) !
	#val_metrics=model.evaluate(x_test, [sel_test, onset_test])
	


#############   LAUNCHING PREDICTIONS     ###########################################
#
##### Predictions on simulated data for cross validations
prediction_cross=np.zeros((Ncross,14))
print("Simulated data in '",Ncross,"' simulated 1D images")
for i in range(Ncross):
	temp_pred=model.predict(x_cross[i].reshape(1, Ngenot, 1))
	####temp_pred=model.predict(x_cross[i].reshape(1, Ngenot, 1), batch_size=1)
	
	temp_sel=temp_pred[0]
	true=y_cross[i,0]; predicted=temp_sel.argmax() ; norm_likelihood=temp_sel[0,predicted]        
	#compute the weigthed average (bin*normlikelihood)    
	arr = np.arange(0, nb_classes, dtype=float); arr = arr.reshape(1,nb_classes); #array dim(1,10) of the bin values
	weighted_mean=np.sum(temp_sel*arr)
	#fill the array
	prediction_cross[i,0]=true;
	prediction_cross[i,1]=predicted; prediction_cross[i,2]=norm_likelihood; #prediction using armax (with corresponding likelihood value)
	
	temp_onset=temp_pred[1]
	true=y_cross[i,1]; predicted=temp_onset.argmax() ; norm_likelihood=temp_onset[0,predicted]        
	#compute the weigthed average (bin*normlikelihood)    
	arr = np.arange(0, nb_classes, dtype=float); arr = arr.reshape(1,nb_classes); #array dim(1,10) of the bin values
	weighted_mean=np.sum(temp_onset*arr)
	#fill the array
	prediction_cross[i,4]=true;
	prediction_cross[i,5]=predicted; prediction_cross[i,6]=norm_likelihood; #prediction using armax (with corresponding likelihood value)
	
	
	#to derive the posterior distibution  (source Imagene:: function  plot_scores, file on GIthub ImaGene/ImaGene.py)
	classes=np.arange(nb_classes)
	samples_distr = np.random.choice(classes, size = 100000, replace = True, p = temp_sel.reshape(100))
	prediction_cross[i,3]=np.average(samples_distr);         #posterior mean sel_coeff
	prediction_cross[i,8]=np.average(samples_distr);         #posterior mean sel_coeff (twice)
	prediction_cross[i,9]=np.quantile(samples_distr,0.025);  #posterior ICmin sel_coeff
	prediction_cross[i,10]=np.quantile(samples_distr,0.975);  #posterior ICmax sel_coeff
	
	classes=np.arange(nb_classes)
	samples_distr = np.random.choice(classes, size = 100000, replace = True, p = temp_onset.reshape(100))
	prediction_cross[i,7]=np.average(samples_distr);         #posterior mean onset 
	prediction_cross[i,11]=np.average(samples_distr);         #posterior mean onset  (twice)
	prediction_cross[i,12]=np.quantile(samples_distr,0.025); #posterior ICmin onset
	prediction_cross[i,13]=np.quantile(samples_distr,0.975); #posterior ICmax onset


file_name=output_location + '/crossval/crossvalidation_prediction_' + name_model + '.txt'
temp_file = open(file_name, "w")
np.savetxt(file_name, prediction_cross, fmt='%.4f',delimiter='\t') #integer (note: fmt='%.2f' for floating, fmt='%.2e' for floating in decimal power)
temp_file.close()


##### Predictions on real data (a single image is handled) 
real_snp = 'DO';
#real_snp = 'DONTDO';  #### estimate parameter on true data  
if real_snp == 'DO':
	print("Real data in '",snp_file,"'")
	snp = np.loadtxt(snp_file);#WARNING current genotypes are missing
	snp = snp.astype('float32')
	
	nreplicat=1
	prediction_snp=np.zeros((nreplicat,14))
	
	#first replicat fot the current model fit
	temp_pred = model.predict(snp.reshape(1, Ngenot, 1))
	temp_sel=temp_pred[0]
	true=-1; predicted=temp_sel.argmax() ; norm_likelihood=temp_sel[0,predicted]        
	print(snp_name, " prediction (selection coefficient):", predicted, " norm_likelihood=", norm_likelihood )
	#fill the array
	prediction_snp[0,0]=true;
	prediction_snp[0,1]=predicted; prediction_snp[0,2]=norm_likelihood; #prediction using armax (with corresponding likelihood value)
	
	temp_onset=temp_pred[1]
	true=-1; predicted=temp_onset.argmax() ; norm_likelihood=temp_onset[0,predicted]        
	print(snp_name, " prediction (onset of selection):", predicted, " norm_likelihood=", norm_likelihood )
	#fill the array
	prediction_snp[0,4]=true;
	prediction_snp[0,5]=predicted; prediction_snp[0,6]=norm_likelihood; #prediction using armax (with corresponding likelihood value)
	
	#to derive the posterior distibution  (source Imagene:: function  plot_scores, file on GIthub ImaGene/ImaGene.py)
	classes=np.arange(nb_classes)
	samples_distr = np.random.choice(classes, size = 100000, replace = True, p = temp_sel.reshape(100))
	file_name=output_location + '/crossval/empirical_posterior_selcoeff_' + snp_name + '_' + name_model + '.txt'
	temp_file = open(file_name, "w")
	np.savetxt(file_name, samples_distr, fmt='%.2f',delimiter='\t') #integer (note: fmt='%.2f' for floating, fmt='%.2e' for floating in decimal power)
	temp_file.close()
	
	prediction_snp[0,3]=np.average(samples_distr); #posterior mean 
	prediction_snp[0,8]=np.average(samples_distr);         #posterior mean sel_coeff (twice)
	prediction_snp[0,9]=np.quantile(samples_distr,0.025);  #posterior ICmin sel_coeff
	prediction_snp[0,10]=np.quantile(samples_distr,0.975);  #posterior ICmax sel_coeff
	
	classes=np.arange(nb_classes)
	samples_distr = np.random.choice(classes, size = 100000, replace = True, p = temp_onset.reshape(100))
	file_name=output_location + '/crossval/empirical_posterior_onsetsel_' + snp_name + '_' + name_model + '.txt'
	temp_file = open(file_name, "w")
	np.savetxt(file_name, samples_distr, fmt='%.2f',delimiter='\t') #integer (note: fmt='%.2f' for floating, fmt='%.2e' for floating in decimal power)
	temp_file.close()
	
	prediction_snp[0,7]=np.average(samples_distr); #posterior mean 
	prediction_snp[0,11]=np.average(samples_distr);         #posterior mean onset  (twice)
	prediction_snp[0,12]=np.quantile(samples_distr,0.025); #posterior ICmin onset
	prediction_snp[0,13]=np.quantile(samples_distr,0.975); #posterior ICmax onset
	
	file_name=output_location + '/crossval/empirical_prediction_' + snp_name + '_' + name_model + '.txt'
	temp_file = open(file_name, "w")
	np.savetxt(file_name, prediction_snp, fmt='%.4f',delimiter='\t') #integer (note: fmt='%.2f' for floating, fmt='%.2e' for floating in decimal power)
	temp_file.close()    
else:
	print("skip analyze real data")
###############################################################################



#############   SAVING THE TRAINED MODEL ######################################
#
if usage == 'PREDICTION': #prediction based on a loaded trained model
	print("\n")

else:
	#### save the trained model
	if os.path.exists(output_location + '/saved_model/' + name_model):
		print("saving model in:\t")
		print(output_location + '/saved_model/' + name_model + "")
		
	else:
		print("creating folder and saving model in:\t")
		print(output_location + '/saved_model/' + name_model + "")
		os.mkdir(output_location + '/saved_model/' + name_model )
	
	model.save(output_location + '/saved_model/' + name_model )
###############################################################################

print("\n")
print ('Ending CNN-aDNA');
print("\n")

