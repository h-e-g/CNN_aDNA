
#.libPaths( "C:/Users/geh/Documents/R/win-library/3.2" )
library("abc")

rm( list=ls() )

#function to estiamte the mode of a distribution
estimate_mode <- function(x) {
  if(any(is.na(x))){
    NA
  }else{
    d <- density(x)
    d$x[which.max(d$y)]
  }
}


variable <- commandArgs(trailingOnly=TRUE)

JOBFOLDER	=  variable[1] ;
OBSDATATYPE	=  variable[2] ;
variant		=  variable[3] ;

####################################
#  Modified R abc library Gaspard used in Kerner et al., Cell Genomics 2023, and in Laval et al., BioRxiv 2023. 
source("modified_abc_function.r");
####################################


      if( OBSDATATYPE == "EMPIRICAL" ){
	input_folder=JOBFOLDER;
	
	numsim="476800"

	tmpstat=read.table(  paste0(input_folder,"/A_abc_trainingset_",numsim,"_freqTraj_POSSEL_SNP_",variant,".READY.txt")   )
	tmppar =read.table(  paste0(input_folder,"/A_trainingset_",numsim,"_params_POSSEL_SNP_",variant,".READY.txt")  )
	
	
}else{
	input_folder=JOBFOLDER;
	
	numsim="476800"
	
	tmpstat=read.table(  paste0(input_folder,"/A_abc_trainingset_",numsim,"_freqTraj_POSSEL_SNP_",variant,".READY.txt")   )
	tmppar =read.table(  paste0(input_folder,"/A_trainingset_",numsim,"_params_POSSEL_SNP_",variant,".READY.txt")  )

	numcrossval="200"
}

Npseudoempricial=200

      if( OBSDATATYPE == "EMPIRICAL" ){
	derived		=read.table(  paste0(input_folder,"/Derived_statu_",variant,".txt")    )
	derived_statu=derived$V1
	  
	obs			=read.table(  paste0(input_folder,"/A_abc_real_data_freqTraj_",variant,".txt")    )
	true		=read.table(  paste0(input_folder,"/A_abc_real_data_freqTraj_",variant,".txt")    )
		
	if( derived_statu == 0 ){
		obs[1:7]=1-obs[1:7]
	}
	
	
	myweights	=read.table(  paste0(input_folder,"/gaspard_weights_",variant,".txt")  )
	
	stat	=tmpstat
	par		=tmppar
	
	output   =c( paste0(input_folder,"/crossval/abc_estimations_477k_mode_noAncestry_",variant,"_avecEPOCH6_gaspardABC.txt") )	
	posterior=c( paste0(input_folder,"/crossval/abc_posteriors_477k_mode_noAncestry_",variant,"_avecEPOCH6_gaspardABC.txt") )
	
	
}else{ 									
	#Pseudo empirical data external files (excluding Nul trajectories, SIMILAR to Gaspard results )
	obs		=read.table(  paste0(input_folder,"/A_abc_crossvalset_",numsim,"_",numcrossval,"_freqTraj_POSSEL_SNP_",variant,".READY.txt")   )
	true	=read.table(  paste0(input_folder,"/A_crossvalset_",numsim,"_",numcrossval,"_params_POSSEL_SNP_",variant,".READY.txt")   )
	
	myweights	=read.table(  paste0(input_folder,"/weights_",variant,".txt")  )
	
	stat	=tmpstat
	par		=tmppar
		
	output   =c( paste0(input_folder,"/crossval/abc_estimations_477k_mode_noAncestry_crossvalidation_avecEPOCH6_gaspardABC.txt") )
}


      if( OBSDATATYPE == "EMPIRICAL" ){
	obs  =  obs[,c(-1,-8,-9,-10,-11,-12,-13)]
	stat = stat[,c(-1,-8,-9,-10,-11,-12,-13)]	
	myweights = myweights[-1]
	
}else{
	##keep the first ancestry, col 8, to avoid zero variance for somme null trajectories
	obs  =  obs[,c(-1,-9,-10,-11,-12,-13)]
	stat = stat[,c(-1,-9,-10,-11,-12,-13)]	
	myweights = myweights[-1]
	myweights = c(myweights,1)
}

tolValadj=1000/nrow(stat)


if( OBSDATATYPE == "EMPIRICAL" ){
	par ( mfrow=c(1,1) )
}else{
	par ( mfrow=c(4,1) )
}


cat( "sim\ttrue_sel\ttrue_age"  , file=output, append=F)
cat( "\tabc_sel\tIC_95\tIC_95"  , file=output, append=T)
cat( "\tabc_age\tIC_95\tIC_95"  , file=output, append=T)
cat( "\n"                       , file=output, append=T)

		
if( OBSDATATYPE == "EMPIRICAL" ){
	numPseudoData=1
	max_retained= 1
}else{
	numPseudoData=Npseudoempricial
	max_retained= Npseudoempricial
}
s=1
for ( sim in 1: numPseudoData ) {
	
	if( s <= max_retained ){
		obs.stat=obs[sim,];
		
		if( OBSDATATYPE == "EMPIRICAL" ){
			lin <-    abc(target=obs.stat, param=par, sumstat=stat, tol=tolValadj, hcorr = FALSE, method = "loclinear", transf=c("none"))
			
			##Modified R abc library Gaspard used in Kerner et al., Cell Genomics 2023, and in Laval et al., BioRxiv 2023. 
			#lin <- my_abc(target=obs.stat, param=par, sumstat=stat, tol=tolValadj, hcorr = FALSE, method = "loclinear", transf=c("none"), myweights=myweights)
		}else{
			lin <-    abc(target=obs.stat, param=par, sumstat=stat, tol=tolValadj, hcorr = FALSE, method = "loclinear", transf=c("none"))
			
			#Modified R abc library Gaspard used in Kerner et al., Cell Genomics 2023, and in Laval et al., BioRxiv 2023. 
			##lin <- my_abc(target=obs.stat, param=par, sumstat=stat, tol=tolValadj, hcorr = FALSE, method = "loclinear", transf=c("none"), myweights=myweights)
		}
		
			
		if( OBSDATATYPE == "EMPIRICAL" ){
			cat( paste0( s ,"\t--\t--" ) , file=output, append=T);
		}else{
			cat( paste0( s ,"\t", true[sim,1] , "\t" , true[sim,2] ) , file=output, append=T);
		}
		
		## est=mean(lin$adj.values[,1]);
		est=estimate_mode(lin$adj.values[,1]) ;
		IC_min=quantile( (lin$adj.values[,1]) , 0.025 ) ; IC_max=quantile( (lin$adj.values[,1]) , 0.975 ) ;
		cat( paste0( "\t",  est ,"\t", IC_min , "\t", IC_max ) , file=output , append=T);
					
				
		## est=mean(lin$adj.values[,2]);
		est=estimate_mode(lin$adj.values[,2]) ;
		IC_min=quantile( (lin$adj.values[,2]) , 0.025 ) ; IC_max=quantile( (lin$adj.values[,2]) , 0.975 ) ;
		cat( paste0( "\t",  est ,"\t", IC_min , "\t", IC_max ) , file=output , append=T);
				
				
		cat( paste0( "\n" ) , file=output , append=T);
		
		
		if( OBSDATATYPE == "EMPIRICAL" ){
			#output posteriors
			abcpost=data.frame( lin$adj.values)
			names( abcpost )=c("abc_sel","abc_age")
			write.table(abcpost, file = posterior, append = FALSE, quote = FALSE, sep = "\t", row.names = FALSE, col.names = TRUE)
		}		
		
		s=s+1
	}else{
		cat( paste0( s ,"\t\t" ) , file=output, append=T);
		cat( paste0( "\t\t\t"   ) , file=output , append=T);
		cat( paste0( "\t\t\t\n" ) , file=output , append=T);	
	}	
	
	
}

cat( paste0( "END\n" ) ); 
