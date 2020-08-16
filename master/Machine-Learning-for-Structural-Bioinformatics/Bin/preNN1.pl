###################################2014-12-6###################################################
###################################ZHANG LABS##################################################
####################################BAOJI HE###################################################
#!/usr/perl

#$dir="/nfs/amino-home/baojihe";
@lists=qw(
!pdbname!
);
foreach $line (@lists)
{
	chomp($line);
	print "$line";
#$rcddir="!currentdir!/record/$line";
$rcddir="!RECORDDIR!";
#############################################################################


$note=10;
#open(WER,"!currentdir!/record/$line/seq.txt");
open(WER,"$rcddir/seq.txt");
while($tyu=<WER>)
{
        chomp($tyu);
        $opo=length($tyu);
        if($opo>$note){$note=$opo;}

}
close(WER);
print " $note\n";
###############################################################################
#
#
@pred=();
for($k=0;$k<7;$k++)
{
        for($i=0;$i<=$note;$i++)
        {
                  for($j=0;$j<=$note;$j++)
                 {
                         $pred[$k][$i][$j]=0.0;
                }
        }
}
        for($i=0;$i<=$note;$i++)
        {
                  for($j=0;$j<=$note;$j++)
                 {
                         $pred[6][$i][$j]="-1";
                }
        }




############################spCON###################################################
$pdbname="mediumbayes$line";
if(! -e "$rcddir/$pdbname"){print "WARNING!!!!!!!!!!!!!!medium\n";}
 open(GGG,"$rcddir/$pdbname");

      $numbspconini=0;
      while($para1=<GGG>){
              chomp($para1);
              $para1=~s/^\s+|\s+$//g;
              @temp=();
              @temp=split(/\t+/,$para1);
			if($temp[1]-$temp[0]<=24)
			{
				
                        $pred[5][$temp[0]][$temp[1]]=$temp[2];
                        $pred[5][$temp[1]][$temp[0]]=$temp[2];
			}
                         }
close(GGG);


$pdbname="shortbayes$line";
if(! -e "$rcddir/$pdbname"){print "WARNING!!!!!!!!!!!!!!medium\n";}
 open(GGG,"$rcddir/$pdbname");

      $numbspconini=0;
      while($para1=<GGG>){
              chomp($para1);
              $para1=~s/^\s+|\s+$//g;
              @temp=();
              @temp=split(/\t+/,$para1);
                        if($temp[1]-$temp[0]<=11)
                        {
                                
                        $pred[5][$temp[0]][$temp[1]]=$temp[2];
                        $pred[5][$temp[1]][$temp[0]]=$temp[2];
                        }
                         }
close(GGG);

##########################################################################################
#


#############################psicov#########E#################################################
######################################STAGE1###############################################################
#
  
if(! -e "$rcddir/longbayes$line"){print "$line        WARNING!!!!!!!!!!!!!!!!!!!!!!!!STAGE1\n";}
 open(GGG,"$rcddir/longbayes$line");

      $numbpsicovini=0;
      while($para1=<GGG>){
              chomp($para1);
              $para1=~s/^\s+|\s+$//g;
              @temp=();
              @temp=split(/\t+/,$para1);
                        $trleng=@temp;
                if($trleng>1)
                {
                        $pred[5][$temp[0]][$temp[1]]=$temp[2];
                        $pred[5][$temp[1]][$temp[0]]=$temp[2];
                }
                         }
close(GGG);


################################################################################################
########################################################big matrix####################################
#betacon:0;;svmseq:1;svmcon:2;spcon:3

for($k=0;$k<$conn;$k++)
{
                $pred[6][$native1[$k]][$native2[$k]]="+1";
}
################################secondary structure##########################################################################33
@ss=();
for($l=0;$l<=$note;$l++)
{
	for($k=0;$k<4;$k++)
	{
		$ss[$l][$k]=0;
	}
}
open(GGG,"$rcddir/$line.ss2");
<GGG>;
<GGG>;
while($tr=<GGG>)
{
	chomp($tr);
	@temp=();
	@temp=split(/\s+/,$tr);
	$ss[$temp[1]][1]=$temp[4];
	$ss[$temp[1]][2]=$temp[5];
	$ss[$temp[1]][3]=$temp[6];
}
close(GGG);



@solve=();
open(GGG,"$rcddir/$line.solv");
while($tr=<GGG>)
{
	chomp($tr);
	$tr=~s/^\s+|\s+$//g;
	@temp=();
	@temp=split(/\s+/,$tr);
	$solve[$temp[0]]=$temp[2];	
}
close(GGG);





@entropy=();
@composion=();
for($l=0;$l<=$note;$l++)
{
	for($m=0;$m<=20;$m++)
	{
		$composion[$l][$m]=0;
	}
}
open(GGG,"$rcddir/$line.colstats");
<GGG>;
<GGG>;
<GGG>;
<GGG>;
$sum=1;
while($tr=<GGG>)
{
        chomp($tr);
        $tr=~s/^\s+|\s+$//g;
        @temp=();
        @temp=split(/\s+/,$tr);
	for($l=0;$l<=20;$l++)
	{
		$composion[$sum][$l]=$temp[$l];
	}
	$entropy[$sum]=$temp[21];
	$sum++;
		
}
close(GGG);



#                `sed -n '/^gi|/'p /nfs/amino-home/baojihe/I-TASSER/version_2014_09_25/record/$line/blast.out|awk '{print \$1}' >rrr`;
 #               `sort -n rrr |uniq > rrr1`;
  #              $rrt=`wc -l rrr1|awk '{print \$1}'`;
#print "$rrt\n";
                #$rrt=log($rrt)/log(100);


$loglength=log($note)/log(10);





#for($l=1;$l<=$note;$l++)
#{
#	print "$solve[$l]\n";
#}
#for($l=1;$l<=$note;$l++)
#{
#	print "$ss[$l][1] $ss[$l][2] $ss[$l][3]\n";
#}
#############################################################################################
##############################solvent acces###############################################################
###########################################iTRAIN#######################################################e
@yui=qw(
short
medium
long
);



foreach $opop (@yui)
{
chomp($opop);
if($opop eq "short")
{
	$uplimit=11;
	$downlimit=6;
}
elsif($opop eq "medium")
{
	$uplimit=24;
	$downlimit=12;
}
else
{
	$uplimit=230000;
	$downlimit=25;
}


open(WWW,">$rcddir/$opop-$line");
open(GGG,">$rcddir/label$line-$opop");
for($k=1;$k<$note-1;$k++)
{
	for($j=$k+1;$j<=$note;$j++)
	{
		if(($j-$k)>=$downlimit and ($j-$k)<=$uplimit)
		{
			print GGG "$k	$j	\n";
			print  WWW "$pred[6][$k][$j] ";
			$yui=0;
###############################whether the residue excide the boundary=22############
			for($l=$k-5;$l<=$k+5;$l++)
                        {
				if($l<=0 or $l>$note)
				{
					$yui++;
					print WWW "$yui:1 ";
				}
				else
				{
					$yui++;
					print WWW "$yui:0 ";
				}

			}

			for($m=$j-5;$m<=$j+5;$m++)
                        {
                                if($m>$note or $m<=0)
                                {
                                        $yui++;
                                        print WWW "$yui:1 ";
                                }
                                else
                                {
                                        $yui++;
                                        print WWW "$yui:0 ";
                                }
			}

###################################################################################



############################BAYES result=121######################################################

			for($l=$k-5;$l<=$k+5;$l++)
			{
				for($m=$j-5;$m<=$j+5;$m++)
				{
					if($l<=0 or $m>$note)
					{
						$yui++;
						print WWW "$yui:0 ";
					}
					else{
						$yui++;
						print WWW "$yui:$pred[5][$l][$m] ";
						}
				}
			}
####################################################################################
#
###########################secondary structure=66#################################
			for($l=$k-5;$l<=$k+5;$l++)
			{
				if($l>0 and $l<=$note)
				{
					$yui++;
					print WWW "$yui:$ss[$l][1] ";
					$yui++;
					print WWW "$yui:$ss[$l][2] ";
					$yui++;
					print WWW "$yui:$ss[$l][3] ";
				}
				else
				{
					$yui++;
                                        print WWW "$yui:-1 ";
                                        $yui++;
                                        print WWW "$yui:-1 ";
                                        $yui++;
                                        print WWW "$yui:-1 ";
				}
			}
                        for($l=$j-5;$l<=$j+5;$l++)
                        {
                                if($l<=$note)
                                {
                                        $yui++;
                                        print WWW "$yui:$ss[$l][1] ";
                                        $yui++;
                                        print WWW "$yui:$ss[$l][2] ";
                                        $yui++;
                                        print WWW "$yui:$ss[$l][3] ";
                                }
                                else
                                {
                                        $yui++;
                                        print WWW "$yui:-1 ";
                                        $yui++;
                                        print WWW "$yui:-1 ";
                                        $yui++;
                                        print WWW "$yui:-1 ";
                                }
                        }
##############################################################################
#
#########################solvent access=22######################################
			for($l=$k-5;$l<=$k+5;$l++)
			{
				if($l>0 )
				{
					$yui++;
					print WWW "$yui:$solve[$l] ";
				}
				else
				{
					$yui++;
                                        print WWW "$yui:-1 ";
				}
			}
                        for($l=$j-5;$l<=$j+5;$l++)
                        {
                                if($l<=$note)
                                {
                                        $yui++;
                                        print WWW "$yui:$solve[$l] ";
                                }
                                else
                                {
                                        $yui++;
                                        print WWW "$yui:-1 ";
                                }
                        }
####################################################################
#
################################distance=1################################
if($opop ne "medium")
{
		if(($j-$k)<=29)
		{
			$yui++;
			print WWW "$yui:0.1 ";
		}
		elsif(($j-$k)>29 and ($j-$k)<=34)
		{
			$yui++;
			print WWW "$yui:0.3 ";
		}
		 elsif(($j-$k)>34 and ($j-$k)<=39)
                {       
                        $yui++;
                        print WWW "$yui:0.5 ";
                }
		 elsif(($j-$k)>39 and ($j-$k)<=44)
                {       
                        $yui++;
                        print WWW "$yui:0.7 ";
                }
		 elsif(($j-$k)>44 and ($j-$k)<=49)
                {       
                        $yui++;
                        print WWW "$yui:0.9 ";
                }
		elsif(($j-$k)>49)
		{
			$yui++;
			print WWW "$yui:1.1 ";
		}
}
else{
	if(($j-$k)<=25 and ($j-$k)>=18)
	{
		$yui++;
		print WWW "$yui:1.0 ";
	}
	else{$yui++;print WWW "$yui:0.0 ";}
}
####################################################################
#
#
#####################################entropy=22#########################33

                       for($l=$k-5;$l<=$k+5;$l++)
                        {
                                if($l>0)
                                {
                                        $yui++;
                                        print WWW "$yui:$entropy[$l] ";
                                }
                                else
                                {
                                        $yui++;
                                        print WWW "$yui:-1 ";
                                }
                        }
                       for($l=$j-5;$l<=$j+5;$l++)
                        {
                                if($l<=$note)
                                {
					$yui++;
                                        print WWW "$yui:$entropy[$l] ";
                                }
                                else
                                {
                                        $yui++;
                                        print WWW "$yui:-1 ";
                                }
                        }


##########################################################################
#
#
#########################################composition=462#########################
                       for($l=$k-5;$l<=$k+5;$l++)
                        {
                                if($l>0)
                                {
					for($m=0;$m<=20;$m++)
					{
                                       	 $yui++;
                                       	 print WWW "$yui:$composion[$l][$m] ";
					}
                                }
                                else
                                {
					for($m=0;$m<=20;$m++)
					{
                                       	 $yui++;
                                       	 print WWW "$yui:-1 ";
					}
                                }
                        }
                       for($l=$j-5;$l<=$j+5;$l++)
                        {
                                if($l<=$note)
                                {
					for($m=0;$m<=20;$m++)
					{
                                        	$yui++;
                                       	 	print WWW "$yui:$composion[$l][$m] ";
					}
                                }
                                else
                                {
					for($m=0;$m<=20;$m++)
					{
                                        	$yui++;
                                        	print WWW "$yui:-1 ";
					}
                                }
                        }

##################################aligned number###########################################################
#
#	$yui++;	
#		print WWW "$yui:$rrt ";





##########################length=1######################################################
                        $yui++;

                print WWW "$yui:$loglength\n";
##################################################################################



	
		}		
	}
}
close(WWW);
close(GGG);






}###########for the repet
#
#
#
############################################

}
exit();
