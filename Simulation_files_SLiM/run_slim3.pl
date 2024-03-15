#!/usr/bin/perl

## Copyright 2020 GEH Institut Pasteur, Guillaume Laval (glaval@pasteur.fr) and Gaspard Kerner (gakerner@pasteur.fr), see ABC_SLiM.sh for more information

#use strict; #WARNING mandatory to publish the code !!!
use warnings;

use Cwd;
use File::Copy;
   
## INPUT PARAMETERS
my $nsim="$ARGV[0]"; #number of simulations per job (NSIM)
my $model="$ARGV[1]"; #DEMOGRAPHY file (INPUT_SLIM)
my $thresQuality="$ARGV[2]"; #Quality threshold regarding SNP_hits of aDNA samples used to filter individuals for pulse intensity estimation
my $GenerationTimeSpan="$ARGV[3]"; #Time span to extract aDNA samples (min is 250 years)
my $StartPulse1="$ARGV[4]"; #Start time point used to estimate pulse intensity
my $StopPulse1="$ARGV[5]"; #Stop time point used to estimate pulse intensity
my $StartPulse2="$ARGV[6]"; #Start time point used to estimate pulse intensity
my $StopPulse2="$ARGV[7]"; #Stop time point used to estimate pulse intensity
my $SlidingWindow="$ARGV[8]"; #Sliding Window used to estimate pulse intensity
my $WindowLength="$ARGV[9]"; #Window Length used to estimate pulse intensity
my $FullFileName="$ARGV[10]"; #Directory + name metadata file
my $NameSource1="$ARGV[11]"; #Directory + name metadata file
my $NameSource2="$ARGV[12]"; #Directory + name metadata file
my $NameAge="$ARGV[13]"; #Directory + name metadata file
my $NameSNP="$ARGV[14]"; #Directory + name metadata file
my $NameSubjectID="$ARGV[15]"; #Directory + name metadata file


## OUTPUT FILES
$outFreq="FreqaDNA_tmp.txt";
$outAncestryAnat="AncestryAnataDNA_tmp.txt";
$outAncestrySteppe="AncestrySteppeaDNA_tmp.txt";


my $line="";  my $sim=0;
for ( $isim=0 ; $isim<$nsim ; ) {
	
		if( $isim eq 0 ){
            $command = "rm $outFreq $outAncestryAnat $outAncestrySteppe parameters.txt parameters_tmp.txt";
            system($command);
        }
		
		## draw random parameters using 'draw_parameter.pl' file
		$command = "perl draw_parameter.pl "."$model"." "."$isim"." "."$thresQuality"." "."$GenerationTimeSpan"." "."$StartPulse1"." "."$StopPulse1"." "."$StartPulse2"." "."$StopPulse2"." "."$SlidingWindow"." "."$WindowLength"." "."$FullFileName"." "."$NameSource1"." "."$NameSource2"." "."$NameAge"." "."$NameSNP"." "."$NameSubjectID";
		system($command);
		$curr_model="$model".".$isim";	
		$command = "./slim $curr_model  > tmp_screen.txt";
		system($command);	
		
		$screenfilename="tmp_screen.txt";
		$sim_OK_mut="YES";
		open($screenfile, "<", "$screenfilename") or die "cannot open < $screenfilename: $!";
		while ( $line2=<$screenfile> ) {
			if( $line2=~m/Absent/ ){ 
				$sim_OK_mut="NO";	
			}
		}
		
		$command = "mv tmp_screen.txt screen_$isim.txt";
		system($command);
			
		$command = "awk -F\"\\t\" '{if(\$1~/Generation/) {if(out==\"\") {out=\$5} else {out=out\"\\t\"\$5}} if(\$1~/p2Pres/) {out=out\"\\t\"\$2} }END{print out}' < screen_".$isim.".txt > tmp.txt";
		system($command);
		
		## USE SCREEN FILE FROM THE OUTPUT OF SLIM (HAS 0's AND 1's ACCORDING TO THE CARRIER STATUS OF EACH ANCIENT SAMPLE; ONE LINE PER GENERATION) AND PUT VALUES IN ONE LINE (SO ONE LINE PER SIMULATION)
		$command = "ID=\$(awk -F\"\\t\" '{count=0;for(i=1;i<=NF;i++) {if(\$i==0) {}else{count++}} if(count>0) {print \"YES\";exit} else {print \"NO\";exit} }' < tmp.txt) \
		if [[ \"\$ID\" = \"YES\" && ".$sim_OK_mut." = \"YES\" ]] \
		then \
		awk -F\"\\t\" '{if(\$1~/Generation/) {if(out==\"\") {out=\$9} else {out=out\" \"\$9}} if(\$1==\"CarrierStatus\") {out=out\" \"\$2} }END{print out}' < screen_".$isim.".txt >> $outFreq \
		awk -F\"\\t\" '{if(\$1~/Generation/) {if(out==\"\") {out=\$13} else {out=out\" \"\$13}} if(\$1==\"CarrierStatusAnat\") {out=out\" \"\$2} }END{print out}' < screen_".$isim.".txt >> $outAncestryAnat \
		awk -F\"\\t\" '{if(\$1~/Generation/) {if(out==\"\") {out=\$17} else {out=out\" \"\$17}} if(\$1==\"CarrierStatusSteppe\") {out=out\" \"\$2} }END{print out}' < screen_".$isim.".txt >> $outAncestrySteppe \
		awk -F\"\\t\" -v i=".$isim." '{if(FNR==(i+1)) {print \$0;exit}}' < parameters_tmp.txt >> parameters.txt \
		fi"; 
		system($command);
	
	
		## remove screen files to save space
		$command = "rm screen_".$isim.".txt tmp.txt ".$model.".".$isim;
		system($command);				
			
		$isim++;							
}

