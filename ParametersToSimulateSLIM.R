#!/usr/bin/env Rscript
args = commandArgs(trailingOnly=TRUE)

# R LIBRARIES TO LOAD
shhh <- suppressPackageStartupMessages
shhh(library(dplyr))

################################################
## PARAMETERS
################################################

thresQuality=as.numeric(args[1])
GenerationTimeSpan=as.numeric(args[2])
StartPulse1=as.numeric(args[3])
StopPulse1=as.numeric(args[4])
StartPulse2=as.numeric(args[5])
StopPulse2=as.numeric(args[6])
SlidingWindow=as.numeric(args[7])
WindowLength=as.numeric(args[8])
FullFileName=as.character(args[9])
NameSource1=as.character(args[10])
NameSource2=as.character(args[11])
NameAge=as.character(args[12])
NameSNP=as.character(args[13])
NameSubject=as.character(args[14])

NameAge="Date.mean.in.BP..OxCal.mu.for.a.direct.radiocarbon.date..and.average.of.range.for.a.contextual.date."
NameSNP="SNPs.hit.on.autosomal.targets"
NameSubject="Version.ID"

################################################
## READ METADATA
################################################

WORK_DIR="/pasteur/zeus/projets/p02/IGSR/GASPARD/GUILLAUME_CNN/GITHUB/Files_For_Slim"
FullFileName=sprintf('%s/v44.3_1240K_public.anno.Extracted.Ancestries.txt.Extracted.Ancestries.txt',WORK_DIR)
data = read.csv(FullFileName,header=T,sep="\t")
data=data.frame(data)
# rename columns
colnames(data)[which(colnames(data)==NameSource1)]="Anatolian"
colnames(data)[which(colnames(data)==NameSource2)]="Yamnaya"
colnames(data)[which(colnames(data)==NameAge)]="Age"
colnames(data)[which(colnames(data)==NameSNP)]="SNP"
colnames(data)[which(colnames(data)==NameSubject)]="Subject"

## prepare ancestry vectors
SortedAnatProps=as.numeric(as.vector(data$Anatolian))
SortedSteppeProps=as.numeric(as.vector(data$Yamnaya))

## RETRIEVE COLUMNS OF INTEREST FROM THE METADATA FILE
SortedInds=as.character(as.vector(data$Subject))
SortedAges=as.numeric(as.vector(data$Age))

## GET ONLY HIGH QUAL DATA TO ESTIMATE PULSES IN THE TIME RANGE OF PULSES (the 50% best covered)
data$SNP = as.numeric(as.vector(data$SNP))
SortedSNPhits=data$SNP/max(data$SNP)

################################################
## ANALYSIS
################################################

## OBTAIN THE VECTOR OF NUMBER OF INDIVIDUALS BY SLIM GENERATIONS (250 YEARS or GenerationTimeSpan). GET THE NUMBER OF INDIVIDUALS TO THE CLOSEST SLIM GENERATION.
## USE THIS VECTOR AS INPUT IN SLIM TO SIMULATE aDNA

if(!file.exists("NbrIndsBinsFinal.txt") | !file.exists("SortedAnatPropsGeneration.txt") | !file.exists("SortedSteppePropsGeneration.txt")){
  GenerationVector=rev(seq(0,max(SortedAges,na.rm=T)+GenerationTimeSpan*2,GenerationTimeSpan))
  MaxBin=GenerationVector[which.min(abs(max(SortedAges,na.rm=T)-GenerationVector))]
    
  ## define the vector of generations using as maximum value the oldest sample and as time interval the generation time used in the model (here 250 years)
  vectorOfBins=rev(seq(0,MaxBin,GenerationTimeSpan))
    
  ## Assign individuals to generations of length 'GenerationTimeSpan' by assigning them to the closest generation in terms of absolute time distance
  NbrIndsBins=numeric(length(vectorOfBins))
  for(i in 1:length(SortedAges)){
    NbrIndsBins[i]=vectorOfBins[which.min(abs(SortedAges[i]-vectorOfBins))[1]]
  }
    
  ## get number of individuals by generation of length 'GenerationTimeSpan'
  NbrIndsBinsFinal=numeric(length(vectorOfBins))
  for(i in 1:length(vectorOfBins)){
    if(vectorOfBins[i] %in% NbrIndsBins){
      NbrIndsBinsFinal[i]=(table(NbrIndsBins))[which(names(table(NbrIndsBins))==vectorOfBins[i])]
    }
  }
  
  ## OBTAIN THE SAME VECTOR FOR ANATOLIAN PROPORTIONS.
  ## USE THIS VECTOR AS INPUT IN SLIM TO SIMULATE aDNA MATCHING THE EXPECTED ANCESTRY SPECTRUM
  
  SortedAnatProps=as.numeric(as.vector(data$Anatolian))
  SortedAnatPropsGeneration=numeric(length(NbrIndsBinsFinal))
  count=1
  for(i in 1:length(NbrIndsBinsFinal)){
    if(NbrIndsBinsFinal[i]>0){
      SortedAnatPropsGeneration[i]=sum(SortedAnatProps[count:(count+NbrIndsBinsFinal[i]-1)])/NbrIndsBinsFinal[i]
      count=count+NbrIndsBinsFinal[i]
    }
  }
  
  SortedSteppeProps=as.numeric(as.vector(data$Yamnaya))
  SortedSteppePropsGeneration=numeric(length(NbrIndsBinsFinal))
  count=1
  for(i in 1:length(NbrIndsBinsFinal)){
    if(NbrIndsBinsFinal[i]>0){
      SortedSteppePropsGeneration[i]=sum(SortedSteppeProps[count:(count+NbrIndsBinsFinal[i]-1)])/NbrIndsBinsFinal[i]
      count=count+NbrIndsBinsFinal[i]
    }
  }
  
  write.table(NbrIndsBinsFinal,"NbrIndsBinsFinal.txt",col.names=F,row.names=F,quote=F)
  write.table(SortedAnatPropsGeneration,"SortedAnatPropsGeneration.txt",col.names=F,row.names=F,quote=F)
  write.table(SortedSteppePropsGeneration,"SortedSteppePropsGeneration.txt",col.names=F,row.names=F,quote=F)
}

## NbrIndsBinsFinal is the vector of individuals per SLIM generation (250 years) from the past to the present
## SortedAnatPropsGeneration is the Anatolian proportion per SLIM generation (250 years) from the past to the present

## OBTAIN ESTIMATES FOR THE 2 PULSES OF THE MODEL.

## USE SLIDING WINDOWS BETWEEN EARLY NEOL AND MESOLITHIC TO GET MEAN AND SD OF THE ANATOLIAN PROPORTION AMONG INDIVIDUALS
## FOR RANDOM SAMPLING OF THE PULSE INTENSITY WITH A NORMAL DISTRIBUTION

## (FROM 6,000 ya to 10,000 ya)
Means=NULL
for(i in seq(StartPulse1,StopPulse1,SlidingWindow)){
  PULSE1_min=i+WindowLength
  PULSE1_max=i
  HighQualDataForAnat = data %>% filter(SNP>=(unname(quantile(SortedSNPhits,seq(0,1,0.05))[paste(thresQuality,"%",sep="")]))*max(data$SNP)
                                        & Age<=PULSE1_min
                                        & Age>=PULSE1_max)
  
  Means=c(Means,mean(HighQualDataForAnat$Anatolian))
}
# calculate sd only over the periods of the neolithic as to not be too stringent and lose too many simulations
IntensityPulse1 = rnorm(1,mean=mean(Means,na.rm=T),sd=sd(Means[1:5],na.rm=T))

## REPEAT FOR STEPPE PULSE (FROM 1,000 ya to 4,500 ya)
Means=NULL
for(i in seq(StartPulse2,StopPulse2,SlidingWindow)){
  PULSE1_min=i+WindowLength
  PULSE1_max=i
  HighQualDataForSteppe = data %>% filter(SNP>=(unname(quantile(SortedSNPhits,seq(0,1,0.05))[paste(thresQuality,"%",sep="")]))*max(data$SNP)
                                        & Age<=PULSE1_min
                                        & Age>=PULSE1_max)
  
  Means=c(Means,mean(HighQualDataForSteppe$Yamnaya))
}

IntensityPulse2 = rnorm(1,mean=mean(Means,na.rm=T),sd=sd(Means,na.rm=T))

## FORMAT OUTPUT TO BE CONSERVED FOR PERL READING IN A NEXT SCRIPT
c(format(round(max(0.05,min(IntensityPulse1,0.95)),2),nsmall=2),format(round(max(0.05,min(IntensityPulse2,0.95)),2),nsmall=2))


