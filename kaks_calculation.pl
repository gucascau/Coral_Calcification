#!/usr/bin/perl

use strict;
use warnings;
use Getopt::Long;

#########################


my $version="1.0 verwsion";
my %opts;
GetOptions(\%opts,"i:s","o:s","h:s");
if (!defined ($opts{i})|| !defined$opts{o}||defined $opts{h}) {
	die "*****************************************
	Usage: perl $0 -i input paml dir
					   	-o ouput information
*******************************************";
}
###################################
my $input=$opts{i};
my $output=$opts{o};
my @files=();
opendir IN,"$input"  or die $!;
 @files=readdir (IN);
 #print "@files";
my $num;
foreach my $f (@files) {
	#print "$f\n";
	next if($f=~m/\.$/ || $f =~m/\.\.$/);
	if ($f =~/(\S+)\.paml$/){
		print "$f\n";
	}
}
foreach my $f (@files) {
	#print "$f\n";
	next if($f=~m/\.$/ || $f =~m/\.\.$/);
	if ($f =~/(\S+)\.paml$/){
		$num++;
		print "$f\n";
		system ("cp $f $input/PAML/temp.paml");
		chdir "$input/PAML";
		system ("/home/xinw/software/paml4.8/bin/codeml /home/xinw/project/evolution_seven/DNA_data/fasta/amp_dis/output/PAML/codeml.ctl");
		system ("cat 2ML.dN >>ALLML.dN");
		system ("cat 2ML.dS >>ALLML.dS");
		system ("cat 2ML.t >>ALLML.t");
		system ("cat 2NG.dN >>ALLNG.dN");
		system ("cat 2NG.dS >>ALLNG.dS");
		system ("cat 2NG.t >>ALLNG.t");
		system ("cat 4fold.nuc >>ALL4fold.nuc");
		system ("cat mlc >>ALLmlc");
		system ("cat rst >>ALLrst");
		system ("cat rst1 >>ALLrst1");
		system ("cat rub >>ALLrub");
		system ("rm -rf temp.paml 2* r* mlc 4fold.nuc");	
		chdir "../";
		#open OUT,">>$output/number" or die $!;
 		#print OUT "$num have been processed!\n";
	}
}
closedir IN;

