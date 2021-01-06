#!/usr/bin/perl -w
#***************************************
#program: function_annotation gene family
#Description: this script is to functionally annotate the gene family based on the 
#Author: Wang Xin <wang.xin@kuast.edu.sa>
#Date:   2015/6/17
#***************************************
use strict;
use Getopt::Long;

my $version="V1.00";
my %opts;
GetOptions(\%opts,"f:s","o:s","h");
if (!defined$opts{f}||!defined$opts{o}|| defined $opts{h})
 {
   print "
Program : $0
Version : $version
Contact : Wang xin <wang.xin\@kaust.edu.sa>
Usage :$0   <-f fasta file> <-o phylip file> [option]
options:
	-f fasta format
	-o phylip format
	-h help
";
	exit(1);

}
my $input=$opts{f};
my $output=$opts{o};
my %string;my %length;my $id;
open IN,"$input" or die $!;
while (<IN>){
	chomp;
	if (/>(\S+)/){
		$id= $1;
	}else{
		$string{$id}=$_;
		$length{$id}=length $_;
	}
}

close IN;

open OUT,">$output"  or die $!;
print OUT "6 $length{adi}\n";
foreach my $id (keys %string){
	print OUT ">$id\t$string{$id}\n";
}
close OUT;
