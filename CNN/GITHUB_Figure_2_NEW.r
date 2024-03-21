

rm( list=ls() )
	
	#### Some colors
	temp        =col2rgb("royalblue4", alpha = FALSE);
	
	alpha       =255
	myblue      =rgb(temp[1], temp[2], temp[3], alpha, names = NULL, maxColorValue = 255 )
	alpha       =155
	myblue_liht =rgb(temp[1], temp[2], temp[3], alpha, names = NULL, maxColorValue = 255 )
	
	temp        =col2rgb("black"  , alpha = FALSE);
	alpha       =255
	myred      =rgb(temp[1], temp[2], temp[3], alpha, names = NULL, maxColorValue = 255 )
	alpha       =100
	myred_liht =rgb(temp[1], temp[2], temp[3], alpha, names = NULL, maxColorValue = 255 )
		
	temp        =col2rgb("darkgrey"  , alpha = FALSE);
	alpha       =255
	mygrey      =rgb(temp[1], temp[2], temp[3], alpha, names = NULL, maxColorValue = 255 )
	alpha       =155
	mygrey_liht =rgb(temp[1], temp[2], temp[3], alpha, names = NULL, maxColorValue = 255 )
	
	temp        =col2rgb("palegreen4"  , alpha = FALSE);
	alpha       =255
	mygreen      =rgb(temp[1], temp[2], temp[3], alpha, names = NULL, maxColorValue = 255 )
	alpha       =155
	mygreen_liht =rgb(temp[1], temp[2], temp[3], alpha, names = NULL, maxColorValue = 255 )
	
	
	#### CASE
	studiedSNPs="GITHUB"	
	
	#### CNN
	CNNtopology="CNN1"	
	
	if(studiedSNPs == "GITHUB"){
		selmodel= "POSSEL"
		#simulated_images_folder="../SIMULATED_IMAGES_GITHUB"
		simulated_images_folder="."
			
		#### 89 selected variants in Kerner
		#variant_list_kerner="../SIMULATED_IMAGES_GITHUB/mmc3_modified.txt"
		variant_list_kerner=c( paste0(simulated_images_folder,"/mmc3_modified.txt") )
			
		#### 89 selected variants
		genomewide_res_file=c( paste0(simulated_images_folder,"/Crossval_results_POSSEL_ALL_AlexNet_1.updated.txt") )	
		
		#### Details for 1 variant (rs4988235, LCT/MCM6)
		Njob=1	
				
		#### Output file  (pdf)	
		rootname=paste0(  simulated_images_folder,"/GITHUB_Figure_2_NEW_",CNNtopology  )
		pdf( paste0(rootname,".pdf") , height=9 , width=12 )		
		par ( mfrow=c(3,2) )	
			
	}else{
		stop("Unknow selection model")
	}
		
	### CNN topologies
	if(CNNtopology == "CNN1"){		
		#Nsim="476800";
		#my_num_filter=28;
		##my_kernel_size=100 (original)
		#my_kernel_size=20	
		##THREE LAYERS
		#nb_dense=128;
		#nb_dense1=256;
		#nb_dense2=512;		
		#My_epochs=3;		
		
		#name_model        = paste0("AlexNet_nodropout_",Nsim,"_Filtr_",my_num_filter,"_Kernel_",my_kernel_size,"_dense_",nb_dense,"_",nb_dense1,"_",nb_dense2,"_epochs_",My_epochs,"_cnn") 
		
		name_model        = paste0("CNN1")
		
	}else{
		stop("Unknow CNN topology")
	}
	
	##Reading somme data
	variant_definition=read.table( paste0( variant_list_kerner ), sep="\t", header=TRUE, quote = "", comment.char = "")			
	variant_definition$Gene.name[1]="LCT-MCM6"
	
	all_res=read.table( genomewide_res_file, sep="\t", header=TRUE, quote = "", comment.char = "")
	abc_young= round( nrow( all_res[ all_res$abc_t <= 4500 & !is.na(all_res$abc_t) , ] ) / nrow( all_res[ !is.na(all_res$abc_t) , ] ) * 100 , 1 )
	abc_old  = round( nrow( all_res[ all_res$abc_t >  4500 & !is.na(all_res$abc_t) , ] ) / nrow( all_res[ !is.na(all_res$abc_t) , ] ) * 100 , 1 )	
	cnn_young= round( nrow( all_res[ all_res$cnn_t <= 4500 & !is.na(all_res$cnn_t) , ] ) / nrow( all_res[ !is.na(all_res$abc_t) , ] ) * 100 , 1 )
	cnn_old  = round( nrow( all_res[ all_res$cnn_t >  4500 & !is.na(all_res$cnn_t) , ] ) / nrow( all_res[ !is.na(all_res$abc_t) , ] ) * 100 , 1 )
	
	cat( paste0( abc_young , "\t", abc_old , "\t" , cnn_young , "\t" , cnn_old , "\n" ) )
	#################################################################################################


	
	my_cex_main=1.8
	my_cex_lab=1.8
	my_cex_axis=1
	my_cex_legend=1.2
	
	mypoints=20
	
	myround=3
	
	##############################################
	### CROSS VALIDATION FOR THE 89 VARIANTS
	##############################################	
	
	### INTENSITY OF SELECTION
	#########################	
	
	par(mar=c(5.1,12,4.1,12)) 
	
	nameCNN			=paste0("Cross validations of the selection coefficient (s)")
	myxlab=""
	myylab="relative differences"		
		
	plot  (  c(1,2),  c(0,0), col="white"      , main=nameCNN, xlab = myxlab , ylab = myylab, bty="n" , xlim=c(0,3), ylim=c(-0.5,0.5), xaxt="no", cex.main=my_cex_main, cex.lab=my_cex_lab, cex.axis=my_cex_axis )
	axis(1, labels=c("r","RMSE") , at=c(1,2) , las=0 , pos=-0.5 , lty=1 , lwd=1 , cex.axis=1.8, col="white", col.ticks="white" )
	text( -1, 0 , labels = "CNN vs ABC", pos = 1, xpd = TRUE, cex=1.8, srt = 90)
		
	
	y1=all_res$s_CORREL_CNN	;   y2=all_res$s_CORREL_ABC	
	y=( y1 - y2 ) / y2
	x=rep(1,length(y))	
	points(    jitter(x,10),    y, col="black"  	 , pch=21, bg=mygreen_liht, cex=2)
	points( x[1], y[1], col="black"         , bg="red", pch=21, cex=2)
	
	average=paste0("(",round( mean(y),myround),")")	
	text( x[1], -0.625 , labels = average, pos = 1, xpd = TRUE, cex=1.4)
	
	y1=all_res$s_RMSE_CNN	; y2=all_res$s_RMSE_ABC	
	y=( y1 - y2 ) / y2
	x=rep(2,length(y))
	points(    jitter(x,10),    y, col="black"  	 , pch=21, bg=mygreen_liht, cex=2)
	points( x[1], y[1], col="black"         , bg="red", pch=21, cex=2)
	
	average=paste0("(",round( mean(y),myround),")")	
	text( x[1], -0.625 , labels = average, pos = 1, xpd = TRUE, cex=1.4)
	
	abline(h=0, col="black"    , lty=2 )

	legend( "topright", legend=c("rs4988235","candidate rs"), col=c("black","black"), pch=c(21,21), pt.bg=c("red",mygreen_liht), pt.cex=c(my_cex_legend,my_cex_legend) , box.lty=0 , cex=my_cex_legend)
	
	
	### AGE OF SELECTION
	#########################
	
	par(mar=c(5.1,12,4.1,12)) 
	
	nameCNN			=paste0("Cross validations of the age of selection (T)")
	myxlab=""
	myylab="relative differences"
	
	plot  (   c(1,2),  c(0,0), col="white"      , main=nameCNN, xlab = myxlab , ylab = myylab, bty="n" , xlim=c(0,3), ylim=c(-0.5,0.5), xaxt="no", cex.main=my_cex_main, cex.lab=my_cex_lab, cex.axis=my_cex_axis  )
	axis(1, labels=c("r","RMSE") , at=c(1,2) , las=0 , pos=-0.5 , lty=1 , lwd=1 , cex.axis=1.6, col="white", col.ticks="white" )
	text( -1, 0 , labels = "CNN vs ABC", pos = 1, xpd = TRUE, cex=1.8, srt = 90)
	
	y1=all_res$t_CORREL_CNN	;   y2=all_res$t_CORREL_ABC	
	y=( y1 - y2 ) / y2
	x=rep(1,length(y))	
	points(    jitter(x,10),    y, col="black"  	 , pch=21, bg=mygreen_liht, cex=2)
	points( x[1], y[1], col="black"         , bg="red", pch=21, cex=2)
	
	average=paste0("(",round( mean(y),myround),")")	
	text( x[1], -0.625 , labels = average, pos = 1, xpd = TRUE, cex=1.4)
	
	y1=all_res$t_RMSE_CNN	; y2=all_res$t_RMSE_ABC	
	y=( y1 - y2 ) / y2
	x=rep(2,length(y))
	points(    jitter(x,10),    y, col="black"  	 , pch=21, bg=mygreen_liht, cex=2)
	points( x[1], y[1], col="black"         , bg="red", pch=21, cex=2)
	
	average=paste0("(",round( mean(y),myround),")")	
	text( x[1], -0.625 , labels = average, pos = 1, xpd = TRUE, cex=1.4)
	
	abline(h=0, col="black"    , lty=2 )
	
	legend( "topright", legend=c("rs4988235","candidate rs"), col=c("black","black"), pch=c(21,21), pt.bg=c("red",mygreen_liht), pt.cex=c(my_cex_legend,my_cex_legend) , box.lty=0 , cex=my_cex_legend)
	
	
	#########################
	### HISTOGRAM FOR AGES OF SELECTION
	#########################	
	
	par(mar=c(5.1,12,4.1,12)) 
	
	young = c(abc_young,cnn_young)
	old = c(abc_old,cnn_old)	
	combined=cbind( young, old )
	#colnames(combined) = c("<4,500ya",">4,500ya")
	colnames(combined) = c("","")
	
	barplot(combined,	, main="Excess of selection postdating the Bronze Age", xlab = "", ylab = "percentage (%)",
						border = c(myred , myblue ),
						col = c(myred_liht, myblue_liht), beside = TRUE , space = c(0.2, 2.5), ylim=c(0,80) , cex.main=my_cex_main, cex.lab=my_cex_lab, cex.axis=my_cex_axis ) #space = c(0.2, 1) width=c(1,1)
	legend( "topright", legend = c("predicted T (ABC)","predicted T (CNN)") , col = c(myred_liht, myblue_liht) , pch=15,           cex=my_cex_legend , box.lty=0 )
	
	
	text( 3.65 , -5 , labels = "<4,500ya", pos = 1, xpd = TRUE, cex=1.8)
	text( 8.3  , -4 , labels = ">4,500ya", pos = 1, xpd = TRUE, cex=1.8)
	
	
	#########################
	### CONFIDENCE INTERVAL COMPARIONS (CIs) 
	#########################	
	
	nameCNN			=paste0("Confidence interval comparisons")
	myxlab=""
	myylab="relative differences"
	
	mypoints=20
	plot  (  c(1,2),  c(0,0), col="white"      , main=nameCNN, xlab = myxlab , ylab = myylab, bty="n" , xlim=c(0,3), ylim=c(-1.1,1.1), xaxt="no", cex.main=my_cex_main, cex.lab=my_cex_lab, cex.axis=my_cex_axis )
	axis(1, labels=c("s","T") , at=c(1,2) , las=0 , pos=-1.2 , lty=1 , lwd=1 , cex.axis=1.8, col="white", col.ticks="white" )
	text( -1, 0 , labels = "CNN vs ABC", pos = 1, xpd = TRUE, cex=1.8, srt = 90)
	
	
	y1=all_res$CNN_s_CIextent	;   y2=all_res$ABC_s_CIextent	
	y=( y1 - y2 ) / y2
	x=rep(1,length(y))	
	points(    jitter(x,5),    y, col="black"  	 , pch=21, bg=mygreen_liht, cex=2)
	points(         x[1],  y[1], col="black"         , bg="red", pch=21, cex=2)
	
	average=paste0("(",round( mean(y),myround),")")	
	text( x[1], -1.5 , labels = average, pos = 1, xpd = TRUE, cex=1.4)
	
	y1=all_res$CNN_t_CIextent	; y2=all_res$ABC_t_CIextent	
	y=( y1 - y2 ) / y2
	x=rep(2,length(y))
	points(    jitter(x,5),    y, col="black"  	 , pch=21, bg=mygreen_liht, cex=2)
	points(         x[1],  y[1], col="black"         , bg="red", pch=21, cex=2)
	
	average=paste0("(",round( mean(y),myround),")")	
	text( x[1], -1.5 , labels = average, pos = 1, xpd = TRUE, cex=1.4)
	
	abline(h=0, col="black"    , lty=2 )
	
	legend( "topright", legend=c("rs4988235","candidate rs"), col=c("black","black"), pch=c(21,21), pt.bg=c("red",mygreen_liht), pt.cex=c(my_cex_legend,my_cex_legend) , box.lty=0 , cex=my_cex_legend)
	
	points(         x[1],  y[1], col="black"         , bg="red", pch=21, cex=2)
	

	listjob=numeric(Njob)
	listjob[1]=1



### LOOP FOR JOBs
for ( job in 1: Njob ) {
	
	folderABC=paste0(simulated_images_folder,"/JOB_",listjob[job])
	folderCNN=paste0(simulated_images_folder,"/JOB_",listjob[job])

	cat( paste0( folderCNN,"\n" ) ) 

	tempvariant	=read.table( paste0( folderCNN,"/0-Variant_analyzed.txt"))
	variant=tempvariant$V1
		
	test_cnn_resfile=paste0( folderCNN,"/crossval/pred_crossvalidation_",name_model,".txt")
if( file.exists( test_cnn_resfile ) ){
	
	#### ABC results files
	abcres_all			=read.table( paste0( folderABC,"/crossval/abc_estimations_477k_crossvalidation.txt"), sep="\t", header=TRUE, quote = "", comment.char = "")
	
	#### ABC cross validation file to select pseudo emprical data on frequency
	crossval            =read.table( paste0( folderCNN,"/A_abc_crossvalset_476800_200_freqTraj_",selmodel,"_SNP_",variant,".READY.txt"), sep=" ", header=FALSE, quote = "", comment.char = "")		
	abcres			    =abcres_all[ crossval$V2 >= 0.02 | crossval$V3 >= 0.02 | crossval$V4 >= 0.02 | crossval$V5 >= 0.02 , ]
	

	cnnres_all					=read.table( paste0( folderCNN,"/crossval/pred_crossvalidation_",name_model,".txt"), sep="\t", header=FALSE, quote = "", comment.char = "")
	names(cnnres_all)			=c("true_s","cnn_s","l_max_s","cnn_s_post","true_t","cnn_t","l_max_t","cnn_t_post","cnn_s_post_2","cnn_s_ICmin","cnn_s_ICmax","cnn_t_post_2","cnn_t_ICmin","cnn_t_ICmax")
	
	
	#exclude low freq trajectories
	cnnres						=cnnres_all[ crossval$V2 >= 0.02 | crossval$V3 >= 0.02 | crossval$V4 >= 0.02 | crossval$V5 >= 0.02 , ]
	
	mypoints=15

	#########################
	### SELECTION COEFFICIENT
	#########################
	
	
	### compute accuracy indices for ABC 	
	abcest			= abcres_all$abc_sel
	abctrue			= abcres_all$true_sel
	# rounding 3 digits to match with AlexNet
	rond_abcest		= round( abcest, 3) ; rond_abctrue = round( abctrue, 3)
	# replace true values = 0 to compute the relative mse
	rond_abctrue	=replace(rond_abctrue,rond_abctrue==0,0.001)
	#compute regression coefficient and sqrt( relative mse )
	abcreg 			= lm( rond_abcest  ~ rond_abctrue )	
	abcmse			=round(  mean( ( (rond_abcest - rond_abctrue)^2 ) / rond_abctrue ) , 4); abcmse	= sqrt(abcmse)
	# values to store
	abcr_all		=round( coefficients(abcreg)[2], 3)	
	abcmse_all		=round( abcmse , 3)
	
	### compute accuracy indices for ABC 	
	abcest			= abcres$abc_sel
	abctrue			= abcres$true_sel
	# rounding 3 digits to match with AlexNet
	rond_abcest		= round( abcest, 3) ; rond_abctrue = round( abctrue, 3)
	# replace true values = 0 to compute the relative mse
	rond_abctrue	=replace(rond_abctrue,rond_abctrue==0,0.001)
	#compute regression coefficient and sqrt( relative mse )
	abcreg 			= lm( rond_abcest  ~ rond_abctrue )	
	abcmse			=round(  mean( ( (rond_abcest - rond_abctrue)^2 ) / rond_abctrue ) , 4); abcmse	= sqrt(abcmse)
	# values to store
	abcr			=round( coefficients(abcreg)[2], 3)	
	abcmse			=round( abcmse , 3)
		
	abc_ICcov=numeric( nrow(abcres) )
	for ( cpt in 1: nrow(abcres) ) {
		abc_ICcov[cpt]=0
		if( abcres$true_sel[cpt]>=abcres$IC_95[cpt] & abcres$true_sel[cpt]<=abcres$IC_95.1[cpt] ){
			abc_ICcov[cpt]=1
		}
	}
	
	min_selcoeff=0
	max_selcoeff=0.1
	numbin=100	
	
	for ( case in 1: 1 ) {
		
		if( case == 1 ){
			### Crossvalidations using simulated pseudodata with EPOCH frequencies >= 0.02 at least once 
			nameCNN			=paste0("Cross validations (",nrow(cnnres)," simulated datasets)")
			namecrossval	="Estimations"
			est    = min_selcoeff +( cnnres$cnn_s_post * ((max_selcoeff-min_selcoeff)/numbin) )	
			true   = min_selcoeff +( cnnres$true_s * ((max_selcoeff-min_selcoeff)/numbin) )
			
			tmp_abcr=abcr
			tmp_abcmse=abcmse
		}
		true=replace(true,true==0,0.001)
		
		reg = lm( est  ~ true )	; r=round( coefficients(reg)[2], 3)
		mse=round(  mean( ( (est - true)^2 ) / true ) , 4) ; mse=round( sqrt(mse) , 3)
		
		ICcov=numeric( nrow(cnnres) )
		for ( cpt in 1: nrow(cnnres) ) {
			ICcov[cpt]=0
			if( cnnres$true_s[cpt]>=cnnres$cnn_s_ICmin[cpt] & cnnres$true_s[cpt]<=cnnres$cnn_s_ICmax[cpt] ){
				ICcov[cpt]=1
			}
		}		
		myxlab="Simulated selection coefficient"
		#plot  (    true,    est, col="white"      , main=nameCNN, xlab = myxlab , ylab = namecrossval, bty="n", xlim=c(0,0.1), ylim=c(0,0.1) )
		#points(    true,    est, col=myblue_liht  , pch=mypoints)
		#points( abctrue, abcest, col=myred_liht  , pch=mypoints)	
		#abline(reg, col=myblue_liht, lty=2 )
		#abline(abcreg, col=myred_liht, lty=2 )
		#abline(0,1, col="black"    , lty=1 )
		
		leg1=paste0( "CNN r="  ,   r        , " RMSE=", mse       ," ICcov=", round( mean(     ICcov )*100, 0) );
		leg2=paste0( "ABC r="  ,   tmp_abcr , " RMSE=", tmp_abcmse," ICcov=", round( mean( abc_ICcov )*100, 0) );
		mylegend =c(           leg1,         leg2)
		mycol    =c(    myblue_liht,   myred_liht)
		mypch    =c(       mypoints,     mypoints)
		#legend( "topleft", legend=mylegend, col=mycol, pch=mypch,           cex=0.7 , box.lty=0 )
		
		#plot( density( abcest ) , col=myred_liht)
		#lines( density( abctrue ) , col="grey")
		#lines( density( est ) , col=myblue_liht)
		#lines( density( true ) , col="black")
	}
	

	#########################
	### AGE OF SELECTION
	#########################

	
	
	### compute accuracy indices for ABC 	
	abcest			= abcres_all$abc_age
	abctrue			= abcres_all$true_age
	# rounding 3 digits to match with AlexNet
	rond_abcest		= round( abcest, 0) ; rond_abctrue = round( abctrue, 0)
	#compute regression coefficient and sqrt( relative mse )
	abcreg 			= lm( rond_abcest  ~ rond_abctrue )	
	abcmse			=round(  mean( ( (rond_abcest - rond_abctrue)^2 ) / rond_abctrue ) , 4); abcmse	= sqrt(abcmse)
	# values to store
	abcr_all		=round( coefficients(abcreg)[2], 3)	
	abcmse_all		=round( abcmse , 3)
	
	### compute accuracy indices for ABC 	
	abcest			= abcres$abc_age
	abctrue			= abcres$true_age
	# rounding 3 digits to match with AlexNet
	rond_abcest		= round( abcest, 0) ; rond_abctrue = round( abctrue, 0)
	#compute regression coefficient and sqrt( relative mse )
	abcreg 			= lm( rond_abcest  ~ rond_abctrue )	
	abcmse			=round(  mean( ( (rond_abcest - rond_abctrue)^2 ) / rond_abctrue ) , 4); abcmse	= sqrt(abcmse)
	# values to store
	abcr			=round( coefficients(abcreg)[2], 3)	
	abcmse			=round( abcmse , 3)
		
	abc_ICcov=numeric( nrow(abcres) )
	for ( cpt in 1: nrow(abcres) ) {
		abc_ICcov[cpt]=0
		if( abcres$true_age[cpt]>=abcres$IC_95.2[cpt] & abcres$true_age[cpt]<=abcres$IC_95.3[cpt] ){
			abc_ICcov[cpt]=1
		}
	}
	
	min_onset=360
	max_onset=395
	numbin=100

	for ( case in 1: 1 ) {
		
		if( case == 1 ){
			### Crossvalidations using simulated pseudodata with EPOCH frequencies >= 0.02 at least once 
			nameCNN			=paste0("Cross validations (",nrow(cnnres)," simulated datasets)")
			namecrossval	="Estimations"
			est    = min_onset +( cnnres$cnn_t_post * ((max_onset-min_onset)/numbin) )	
			true   = min_onset +( cnnres$true_t * ((max_onset-min_onset)/numbin) )
			
			tmp_abcr=abcr
			tmp_abcmse=abcmse
		}
	
		reg = lm( est  ~ true )	; r=round( coefficients(reg)[2], 3)
		mse=round(  mean( ( (est - true)^2 ) / true ) , 4) ; mse=round( sqrt(mse) , 3)
		
		ICcov=numeric( nrow(cnnres) )
		for ( cpt in 1: nrow(cnnres) ) {
			ICcov[cpt]=0
			if( cnnres$true_t[cpt]>=cnnres$cnn_t_ICmin[cpt] & cnnres$true_t[cpt]<=cnnres$cnn_t_ICmax[cpt] ){
				ICcov[cpt]=1
			}
		}
		
		myxlab="Simulated age of selection (generation)"
		#plot  (    true,    est, col="white"      , main=nameCNN, xlab = myxlab , ylab = namecrossval, bty="n", xlim=c(350,400), ylim=c(350,420) )
		#points(    true,    est, col=myblue_liht  , pch=mypoints)
		#points( abctrue, abcest, col=myred_liht  , pch=mypoints)	
		#abline(reg, col=myblue_liht, lty=2 )
		#abline(abcreg, col=myred_liht, lty=2 )
		#abline(0,1, col="black"    , lty=1 )
		
		#leg1=paste0( "CNN r="  ,   r        , " RMSE=", mse       ," ICcov=", round( mean(     ICcov )*100, 0) );
		leg2=paste0( "ABC r="  ,   tmp_abcr , " RMSE=", tmp_abcmse," ICcov=", round( mean( abc_ICcov )*100, 0) );
		mylegend =c(           leg1,         leg2)
		mycol    =c(    myblue_liht,   myred_liht)
		mypch    =c(       mypoints,     mypoints)
		#legend( "topleft", legend=mylegend, col=mycol, pch=mypch,           cex=0.7 , box.lty=0 )
		
		#plot( density( abcest ) , col=myred_liht)
		#lines( density( abctrue ) , col="grey")
		#lines( density( est ) , col=myblue_liht)
		#lines( density( true ) , col="black")
	}
	
	#########################
	### ESTIMATION FOR LCT
	#########################
	
	#ABC empirical estimations for LCT stored in the 'empirical' folder
	abc_lct				=read.table( paste0( folderABC,"/crossval/abc_estimations_477k_",variant,".txt")	, sep="\t", header=TRUE, quote = "", comment.char = "")
	abcpost_lct			=read.table( paste0( folderABC,"/crossval/abc_posteriors_477k_",variant,".txt")		, sep="\t", header=TRUE, quote = "", comment.char = "")
	
	name_model_used=name_model
	
	#Analyze of the emprical validation of the CNN model based on the LCT variant (stored in the same 'crossval' folder)
	cnn_lct				=read.table( paste0( folderCNN,"/crossval/empirical_validation_pred_",variant,"_"				,name_model_used,".txt"), sep="\t", header=FALSE, quote = "", comment.char = "")
	names(cnn_lct)	=c("true_s","cnn_s","l_max_s","cnn_s_post","true_t","cnn_t","l_max_t","cnn_t_post")
	cnnpost_lct_sel		=read.table( paste0( folderCNN,"/crossval/empirical_validation_posterior_selcoeff_",variant,"_"	,name_model_used,".txt"), sep="\t", header=FALSE, quote = "", comment.char = "")
	cnnpost_lct_onset	=read.table( paste0( folderCNN,"/crossval/empirical_validation_posterior_onsetsel_",variant,"_"	,name_model_used,".txt"), sep="\t", header=FALSE, quote = "", comment.char = "")
	names(cnnpost_lct_sel)	    =c("cnnpost_s")
	names(cnnpost_lct_onset)	=c("cnnpost_t")
	
	
	chromo=variant_definition[variant_definition$SNP.ID==as.character(variant), ]$CHR
	mutation=variant_definition[variant_definition$SNP.ID==as.character(variant), ]$Consequence.protein
	gene=variant_definition[variant_definition$SNP.ID==as.character(variant), ]$Gene.name
	
	mymain=paste0(variant," (",gene,")")
	
	##### INTENSITY OF SELECTION #############################################
	#### convert cnn point estimates (from bin to param value)
	abc_s_max    =abc_lct$abc_sel	
	abc_s_IC_min =abc_lct$IC_95	
	abc_s_IC_max =abc_lct$IC_95.1	
	cnn_s_max    = min_selcoeff +( cnn_lct$cnn_s      * ((max_selcoeff-min_selcoeff)/numbin) )
	cnn_s_mean_0 = min_selcoeff +( cnn_lct$cnn_s_post * ((max_selcoeff-min_selcoeff)/numbin) )
	
	####read priors
	abcprior=read.table( paste0( folderCNN,"/A_trainingset_476800_params_",selmodel,"_SNP_",variant,".READY.txt") )
	names(abcprior)=c("s","t")
	cnnprior=read.table( paste0( folderCNN,"/A_trainingset_476800_params_",selmodel,"_SNP_",variant,".READY.txt") )
	names(cnnprior)=c("s","t")
	
	### posteriors for the intensity of selection
	tmpabc=abcpost_lct$abc_sel
	tmpcnn= min_selcoeff +( cnnpost_lct_sel$cnnpost_s * ((max_selcoeff-min_selcoeff)/numbin) )	
		cnn_s_mean     =     mean( tmpcnn )
		cnn_s_IC_min   = quantile( tmpcnn , 0.025 )
		cnn_s_IC_max   = quantile( tmpcnn , 0.975 )	
	tmpcnn=tmpcnn[c(1:1000)]; #1000 values to compare with ABC
	
	
	maxdensity_abc=max( density( tmpabc )$y )  
	maxdensity_cnn=max( density( tmpcnn )$y ) 	
	maxy=maxdensity_abc
	if( maxdensity_cnn >= maxdensity_abc){
		maxy=maxdensity_cnn
	}
	
	if(job == 1){
		maxy=100
	}else if(job == 2){	
		maxy=100
	}
	
	plot(  density( tmpcnn ), main=mymain , xlim=c(0, max_selcoeff ) , type="l"  , ylab="density" , xlab="selection coefficient", axes=T, col="white", ylim=c(0, maxy ), bty="n", cex.main=my_cex_main, cex.lab=my_cex_lab, cex.axis=my_cex_axis )		
	polygon( density( tmpabc ),col=myred_liht , border=myred )
	bidon=density ( tmpcnn )
	temp_x=bidon$x[ bidon$x>=min( cnnprior$s ) & bidon$x<=max( cnnprior$s ) ]
	temp_y=bidon$y[ bidon$x>=min( cnnprior$s ) & bidon$x<=max( cnnprior$s ) ]
	polygon( c(temp_x,rev(temp_x)),c(temp_y,rev( rep(0,length(temp_y))  )) ,col=myblue_liht, border=myblue )
	bidon=density ( cnnprior$s )
	bidon$y[ bidon$x<=min( cnnprior$s ) ]=0
	bidon$y[ bidon$x>=max( cnnprior$s ) ]=0
	lines( bidon$x, bidon$y , lty=1,col="black")		
	
	leg1=paste0( "CNN ",round(cnn_s_mean     ,3)," [",round(cnn_s_IC_min ,3),"-",round(cnn_s_IC_max   ,3),"]" );
	leg2=paste0( "ABC ",round(abc_s_max      ,3)," [",round(abc_s_IC_min ,3),"-",round(abc_s_IC_max   ,3),"]" );
	mylegend =c(           leg1,         leg2)
	mycol    =c(    myblue_liht,   myred_liht)
	mypch    =c(       mypoints,     mypoints)
	#legend( "topleft", legend=mylegend, col=mycol, pch=mypch,           cex=my_cex_legend , box.lty=0 )
	if(job == 1){
		legend( 0.035, 100, legend=mylegend, col=mycol, pch=mypch,           cex=my_cex_legend , box.lty=0 )
	}else if(job == 2){	
		legend( 0.035, 100, legend=mylegend, col=mycol, pch=mypch,           cex=my_cex_legend , box.lty=0 )
	}
		
	##### AGE OF SELECTION #############################################
	#### convert cnn point estimates (from bin to param value)
	abc_t_max    =abc_lct$abc_age	
	abc_t_IC_min =abc_lct$IC_95.3	; #Attention c'est inversé en terme de génération
	abc_t_IC_max =abc_lct$IC_95.2	
	cnn_t_max    = min_onset +( cnn_lct$cnn_t      * ((max_onset-min_onset)/numbin) )
	cnn_t_mean_0 = min_onset +( cnn_lct$cnn_t_post * ((max_onset-min_onset)/numbin) )
	
	### posteriors for the age of selection
	#in generations
	tmpabc=abcpost_lct$abc_age	
	tmpcnn= min_onset +( cnnpost_lct_onset$cnnpost_t * ((max_onset-min_onset)/numbin) )
	
	#translated in years ago
	generation_time=25
	
	max_onset_2=400	
	maxage= (max_onset_2 - min_onset) * generation_time * 10
	
	abc_t_max    =(max_onset_2 - abc_t_max   ) * generation_time * 10
	abc_t_IC_min =(max_onset_2 - abc_t_IC_min) * generation_time * 10
	abc_t_IC_max =(max_onset_2 - abc_t_IC_max) * generation_time * 10	
	cnn_t_max    =(max_onset_2 - cnn_t_max   ) * generation_time * 10
	cnn_t_mean_0 =(max_onset_2 - cnn_t_mean_0) * generation_time * 10
	
	tmpabc= (max_onset_2 - tmpabc) * generation_time * 10
	tmpcnn= (max_onset_2 - tmpcnn) * generation_time * 10
		cnn_t_mean     =     mean( tmpcnn )
		cnn_t_IC_min   = quantile( tmpcnn , 0.025 )
		cnn_t_IC_max   = quantile( tmpcnn , 0.975 )		
	tmpcnn=tmpcnn[c(1:1000)]; #1000 values to compare with ABC
	
	maxdensity_abc=max( density( tmpabc )$y )  
	maxdensity_cnn=max( density( tmpcnn )$y ) 	
	maxy=maxdensity_abc
	if( maxdensity_cnn >= maxdensity_abc){
		maxy=maxdensity_cnn
	}
	
	
	if(job == 1){
		maxy=0.0008
	}else if(job == 2){	
		maxy=0.0008
	}
	
	plot(  density( tmpcnn ), main=mymain  , xlim=c(0, maxage ) , type="l"  , ylab="density" , xlab="age of selection (years)", axes=T, col="white", ylim=c(0, maxy ), bty="n", cex.main=my_cex_main, cex.lab=my_cex_lab, cex.axis=my_cex_axis  )		
	polygon( density( tmpabc ),col=myred_liht , border=myred )
	tmpprior=(max_onset_2 - cnnprior$t) * generation_time * 10 
	bidon=density ( tmpcnn )
	temp_x=bidon$x[ bidon$x>=min( tmpprior ) & bidon$x<=max( tmpprior ) ]
	temp_y=bidon$y[ bidon$x>=min( tmpprior ) & bidon$x<=max( tmpprior ) ]
	polygon( c(temp_x,rev(temp_x)),c(temp_y,rev( rep(0,length(temp_y))  )) ,col=myblue_liht, border=myblue )
	bidon=density ( tmpprior )
	bidon$y[ bidon$x<=min( tmpprior ) ]=0
	bidon$y[ bidon$x>=max( tmpprior ) ]=0
	lines( bidon$x, bidon$y , lty=1,col="black")		
	
	
	leg1=paste0( "CNN ",round(cnn_t_mean     ,0)," [",round(cnn_t_IC_min ,0),"-",round(cnn_t_IC_max   ,0),"]" );
	leg2=paste0( "ABC ",round(abc_t_max      ,0)," [",round(abc_t_IC_min ,0),"-",round(abc_t_IC_max   ,0),"]" );
	mylegend =c(           leg1,         leg2)
	mycol    =c(    myblue_liht,   myred_liht)
	mypch    =c(       mypoints,     mypoints)
	if(job == 1){
		legend( 3500, 0.0008, legend=mylegend, col=mycol, pch=mypch,           cex=my_cex_legend , box.lty=0 )
	}else if(job == 2){	
		legend( 3500, 0.0008, legend=mylegend, col=mycol, pch=mypch,           cex=my_cex_legend , box.lty=0 )
	}
	
	
}else{
	
}


}	


	dev.off()
	stop("END")