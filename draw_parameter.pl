#!/usr/bin/perl

## Copyright 2020 GEH Institut Pasteur, Guillaume Laval (glaval@pasteur.fr) and Gaspard Kerner (gakerner@pasteur.fr), see ABC_SLiM.sh for more information

#use strict; #WARNING mandatory to publish the code !!!
use warnings;
use strict;
#use 5.010;
 
#use List::Util qw(sum);
use List::Util qw[min max];
my $paramfile;
my $isim;
my $thresQuality;
my $GenerationTimeSpan;
my $StartPulse1;
my $StopPulse1;
my $StartPulse2;
my $StopPulse2;
my $SlidingWindow;
my $WindowLength;
my $FullFileName;
my $NameSource1;
my $NameSource2;
my $NameAge;
my $NameSNP;
my $NameSubjectID;
my $outfile;
my $line;
my $outparam;
my $file;
my $model;



$paramfile="$ARGV[0]"; # DEMOGRAPHY file (INPUT_SLIM)
$isim="$ARGV[1]"; # number of simulations per job (NSIM)
$thresQuality="$ARGV[2]"; #Quality threshold regarding SNP_hits of aDNA samples used to filter individuals for pulse intensity estimation
$GenerationTimeSpan="$ARGV[3]"; #Time span to extract aDNA samples (min is 250 years)
$StartPulse1="$ARGV[4]"; #Start time point used to estimate pulse intensity
$StopPulse1="$ARGV[5]"; #Stop time point used to estimate pulse intensity
$StartPulse2="$ARGV[6]"; #Start time point used to estimate pulse intensity
$StopPulse2="$ARGV[7]"; #Stop time point used to estimate pulse intensity
$SlidingWindow="$ARGV[8]"; #Sliding Window used to estimate pulse intensity
$WindowLength="$ARGV[9]"; #Window Length used to estimate pulse intensity
$FullFileName="$ARGV[10]"; #Directory + name metadata file
$NameSource1="$ARGV[11]"; #Directory + name metadata file
$NameSource2="$ARGV[12]"; #Directory + name metadata file
$NameAge="$ARGV[13]"; #Directory + name metadata file
$NameSNP="$ARGV[14]"; #Directory + name metadata file
$NameSubjectID="$ARGV[15]"; #Directory + name metadata file


## RANDOM PARAMETERS SLIM
my $drawn_splitANAT;
my $drawn_splitSTEPPE;
my $drawn_splitMIN;
my $drawn_splitMAX;
my $drawn_splitANAT5708;
my $drawn_splitSTEPPE5708;
my $drawn_ageAFR;
my $drawn_ageEURASIA;
my $drawn_agePULSE1;
my $drawn_agePULSE11;
my $drawn_agePULSE2;
my $drawn_agePULSE22;
my $drawn_NEEURASIA;
my $drawn_NEEURORASI;
my $drawn_coin;		
my $drawn_useafs;
my $drawn_age;
my $drawn_AFS;
my $drawn_S;
my $drawn_ONSETSEL;
my $drawn_MIGRATEANAT;
my $drawn_MIGRATESTEPPE;
my $drawn_pop;
my $drawn_COVERAGE; 
my $drawn_SAMPLING;			


# Range for age of the mutation (250 years per generation - rescaled model with lambda = 10)
my $min_age=1;  ### until 100,000 ya
my $max_age=399;
my $range=$max_age-$min_age;

# Range for divergence time between Europeans, Middle Easterners and Central Asians
my $min_ageANAT=300;
my $max_ageANAT=340;
my $rangeANAT=$max_ageANAT-$min_ageANAT;

# Range for divergence time between Africans and Non-Africans
my $min_ageAFR=80;
my $max_ageAFR=160;
my $rangeAFR=$max_ageAFR-$min_ageAFR;

# Range for divergence time between West-East Eurasians
my $min_ageEURASIA=220;
my $max_ageEURASIA=260;
my $rangeEURASIA=$max_ageEURASIA-$min_ageEURASIA;

# Range for time for the Anatolian pulse to Europe (10,000 to 8,500 ya)
my $min_agePULSE1=360;
my $max_agePULSE1=366;
my $rangePULSE1=$max_agePULSE1-$min_agePULSE1;

# Range for time for the Steppe pulse to Europe (fixed to 5,000 ya)
my $min_agePULSE2=380;
my $max_agePULSE2=380;
my $rangePULSE2=$max_agePULSE2-$min_agePULSE2;

# Range for onset of selection
my $min_sel=360;
my $max_sel=396;
my $rangeSEL=$max_sel-$min_sel;

# Range for Ne Eurasians
my $min_NEEURASIA=200;
my $max_NEEURASIA=300;
my $rangeNEEURASIA=$max_NEEURASIA-$min_NEEURASIA;

# Range for Ne East Eurasians
my $min_NEEURORASI=300;
my $max_NEEURORASI=400;
my $rangeNEEURORASI=$max_NEEURORASI-$min_NEEURORASI;

# Run Rscript to get extra parameters, particularly vector for the number of aDNA data, Anatolian proportions and intensity for pulses from normal distributions estimated from the data
my $base = "/pasteur/zeus/projets/p02/IGSR/GASPARD/GUILLAUME_CNN/GITHUB/Files_For_Slim";
chomp $base;
my $r_script= "ParametersToSimulateSLIM.R";
my $path="$base/$r_script";


my $pulse1;
my $pulse2;
save_R_env();

sub save_R_env {
    my $execute = `Rscript $path $thresQuality $GenerationTimeSpan $StartPulse1 $StopPulse1 $StartPulse2 $StopPulse2 $SlidingWindow $WindowLength $FullFileName $NameSource1 $NameSource2 $NameAge $NameSNP $NameSubjectID`;
    $pulse1  = substr $execute, 5, 4;
    $pulse2  = substr $execute, 12, 4;
}
		
		
			open($outparam, ">>", "parameters_tmp.txt") or die "cannot open < $file: $!";
		
			#for ( $isim=0 ; $isim<$nsim ; $isim++ ) {
			
			open($model, "<", "$paramfile") or die "cannot open < $paramfile: $!";
			$file="$paramfile".".$isim";
			open($outfile, ">", "$file") or die "cannot open < $file: $!";
			
			
			########### Draw Ne and divergence time parameters
			
			$drawn_splitANAT=$min_ageANAT + int(rand($rangeANAT));
			$drawn_splitSTEPPE=$min_ageANAT + int(rand($rangeANAT));
			if($drawn_splitSTEPPE == $drawn_splitANAT){
				$drawn_splitSTEPPE=$drawn_splitANAT + int(1);
			}
			$drawn_splitMIN=min($drawn_splitANAT,$drawn_splitSTEPPE);
			$drawn_splitMAX=max($drawn_splitANAT,$drawn_splitSTEPPE);
			$drawn_splitANAT5708=max(308,$drawn_splitANAT) + int(1);
			$drawn_splitSTEPPE5708=max(308,$drawn_splitSTEPPE) + int(1);
			$drawn_ageAFR=$min_ageAFR + int(rand($rangeAFR));
			$drawn_ageEURASIA=$min_ageEURASIA + int(rand($rangeEURASIA));
			$drawn_agePULSE1=$min_agePULSE1 + int(rand($rangePULSE1));
			$drawn_agePULSE11=$drawn_agePULSE1 + 1;
			#$drawn_agePULSE2=$min_agePULSE2 + int(rand($rangePULSE2));
			$drawn_agePULSE2=380;
			$drawn_agePULSE22=$drawn_agePULSE2 + 1;
			$drawn_NEEURASIA=$min_NEEURASIA + int(rand($rangeNEEURASIA));
			$drawn_NEEURORASI=$min_NEEURORASI + int(rand($rangeNEEURORASI));
			
			
			########### Age of the mutation
			
			# Flip a coin with p=XX to decide whether a mutation is generated before 100,000 years ago with a frequency>0 or after 100,000 ya with whatever frequency.
			# With 10,000,000 simulations of mutations older than 100,000 ya we observed that in 0.42% of the cases we had a freq>0 at 100,000 years ago.
			# Given that 9/10 times we obtain an age>100,000 years (until 1,000,000) from a uniform distribution then we would draw a mutation older than 100,000 years ago with f>0 100,000 years ago with p=0.9*0.0042=0.0038
			# That means that either one draws a mutation younger than 100,000 ya with p=0.1 or one draws a mutation older than 100,000 ya with f>0 with p=0.0038
			# --> p(younger than 100,000 ya)=0.9634 and p(older but f>0)=0.0366 
			$drawn_coin=1+int(rand(10000));		
			if($drawn_coin > 9634){
				$drawn_useafs=int(1);
				$drawn_age=int(1);
			}else{
				$drawn_useafs=int(0);
				$drawn_age=$min_age + int(rand($range));
			}
			$drawn_AFS=1+int(rand(41814));
	
			
			########### Onset and strength of selection
			## Until 0.05 for negative selection
			#$drawn_S=rand(0.05);
			## Until 0.1 for positive selection
			$drawn_S=rand(0.1);					
			$drawn_S = sprintf ("%0.4f", $drawn_S);	
			$drawn_ONSETSEL=$min_sel + int(rand($rangeSEL));
            
            ########### We define the intensity of the pulses from a random sampling from a normal distribution with parameters estimated from the data (see Rscript above)
	    	$drawn_MIGRATEANAT = $pulse1;
	    	$drawn_MIGRATESTEPPE = $pulse2;
								
			########### Draw origin of the mutation (in which population it appears)
			if( $drawn_age>=1 && $drawn_age<=$drawn_ageAFR){
 				$drawn_pop=1;
 			}
 			elsif( $drawn_age>$drawn_ageAFR && $drawn_age<=$drawn_ageEURASIA){
 				$drawn_pop=int(rand(2))+1;
 			}	
 			elsif( $drawn_age>$drawn_ageEURASIA && $drawn_age<=min($drawn_splitANAT,$drawn_splitSTEPPE)){
 				$drawn_pop=int(rand(3))+1;
 			}
 			elsif( $drawn_age>min($drawn_splitANAT,$drawn_splitSTEPPE) && $drawn_age<=max($drawn_splitANAT,$drawn_splitSTEPPE)){
  				if(min($drawn_splitANAT,$drawn_splitSTEPPE) == $drawn_splitANAT ){
 					$drawn_pop=int(rand(4))+1;                               		
 				}else{
 					$drawn_pop=int(rand(4))+1;
                     if(  $drawn_pop == 4 ){
                         $drawn_pop=5;
                     }
 				}	
 			}
 			else{
 				$drawn_pop=int(rand(5))+1;
 				
 			}	
			
			$drawn_COVERAGE=0;

			########### Replace in SLIM file the simulated parameters
			while ( $line=<$model> ) {
		       	if( $line=~m/\$SELMUT_age/){			       		
										$line=~s/\$SELMUT_age/$drawn_age/g;					
										print $outfile "$line";						
				}elsif( $line=~m/\$SEL_coef/){			
										$line=~s/\$SEL_coef/$drawn_S/g;				
										print $outfile "$line";					
				}elsif( $line=~m/\$SELPOP/){
										$line=~s/\$SELPOP/$drawn_pop/g;					
										print $outfile "$line";								
				}elsif($line=~m/\$SPLITMIN/){
										$line=~s/\$SPLITMIN/$drawn_splitMIN/g;
                                        print $outfile "$line";
				}elsif($line=~m/\$SPLITMAX/){
                                        $line=~s/\$SPLITMAX/$drawn_splitMAX/g;
                                        print $outfile "$line";
				}elsif($line=~m/\$SPLITANAT5708/){
                                        $line=~s/\$SPLITANAT5708/$drawn_splitANAT5708/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$SPLITSTEPPE5708/){
                                        $line=~s/\$SPLITSTEPPE5708/$drawn_splitSTEPPE5708/g;
                                        print $outfile "$line";
				}elsif($line=~m/\$SPLITANAT/ && $line=~m/\$SPLITSTEPPE/){
                                        $line=~s/\$SPLITANAT/$drawn_splitANAT/g;
										$line=~s/\$SPLITSTEPPE/$drawn_splitSTEPPE/g;
                                        print $outfile "$line";
				}elsif($line=~m/\$SPLITANAT/){
                                        $line=~s/\$SPLITANAT/$drawn_splitANAT/g;
                                        print $outfile "$line";
				}elsif($line=~m/\$SPLITSTEPPE/){
                                        $line=~s/\$SPLITSTEPPE/$drawn_splitSTEPPE/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$SPLITAFR/){
                                        $line=~s/\$SPLITAFR/$drawn_ageAFR/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$SPLITEAS/){
                                        $line=~s/\$SPLITEAS/$drawn_ageEURASIA/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$PULSE1/){
                                        $line=~s/\$PULSE1/$drawn_agePULSE1/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$PULSES1/){
                                        $line=~s/\$PULSES1/$drawn_agePULSE11/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$PULSE2/){
                                        $line=~s/\$PULSE2/$drawn_agePULSE2/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$PULSES2/){
                                        $line=~s/\$PULSES2/$drawn_agePULSE22/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$ONSETSEL/){
                                        $line=~s/\$ONSETSEL/$drawn_ONSETSEL/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$MIGRATEANAT/){
                                        $line=~s/\$MIGRATEANAT/$drawn_MIGRATEANAT/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$MIGRATESTEPPE/){
                                        $line=~s/\$MIGRATESTEPPE/$drawn_MIGRATESTEPPE/g;
                                        print $outfile "$line";
				}elsif($line=~m/\$SAMPLINGTOCHANGE/){
										$line=~s/\$SAMPLINGTOCHANGE/$drawn_SAMPLING/g;
										print $outfile "$line";
                }elsif($line=~m/\$NEEURASIA/){
                                        $line=~s/\$NEEURASIA/$drawn_NEEURASIA/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$NEEURORASI/){
                                        $line=~s/\$NEEURORASI/$drawn_NEEURORASI/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$AFSTOCHANGE/){
                                        $line=~s/\$AFSTOCHANGE/$drawn_AFS/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$GENERATIONLENGTH/){
                                        $line=~s/\$GENERATIONLENGTH/$GenerationTimeSpan/g;
                                        print $outfile "$line";
                }elsif($line=~m/\$USEAFS/){
                                        $line=~s/\$USEAFS/$drawn_useafs/g;
                                        print $outfile "$line";
                }else{
					print $outfile "$line";
				}				
		    }
		    
		    ########### Output simulated parameters to the parameters file
		    print $outparam "$drawn_age\t";
		    print $outparam "$drawn_S\t";
		    print $outparam "$drawn_pop\t";
			print $outparam "$drawn_splitANAT\t";
			print $outparam "$drawn_splitSTEPPE\t";
			print $outparam "$drawn_ageAFR\t";
			print $outparam "$drawn_ageEURASIA\t";
			print $outparam "$drawn_agePULSE1\t";
			print $outparam "$drawn_agePULSE2\t";
			print $outparam "$drawn_ONSETSEL\t";
			print $outparam "$drawn_MIGRATEANAT\t";
            print $outparam "$drawn_MIGRATESTEPPE\t";
            print $outparam "$drawn_COVERAGE\t";
            print $outparam "$drawn_useafs\t";
            print $outparam "$drawn_AFS\t";
			
			close $file;
			close $model;			
			
			print $outparam "\n";
			
		#}
		close $outparam;
