#!/usr/bin/perl
use strict;
use warnings;
my $version="1.0 version";
use Getopt::Long;
my %opts;
GetOptions(\%opts,"s:s","o:s","i:s");
print "*************\n*$version*\n*************\n";
if ( !defined $opts{o}|| !defined $opts{s} || !defined $opts{i} ) {
	die "************************************************************************
	Usage: selecte_SOM_orthologs.pl
		-s: SOM gene list 
		-i: orthologs for all seven species
		-o: output of SOM genes with all information
************************************************************************\n";
}

########################################################################################
my $out=$opts{o};
my $evolution_rate=$opts{i};
my $gene_list=$opts{s};
my %hash;
open GL,"$gene_list" or die $!;
while (<GL>){
	chomp;
	my @array=split/\t/,$_;
	$hash{$array[0]}++;
}
close GL;

open OL,"$evolution_rate" or die $!;
open OUT,">$out" or die $!;
while (<OL>){
	chomp;
	my @circle=split/\t/,$_;
	print OUT "$circle[0]\t$circle[1]\n" if (exists $hash{$circle[0]} || exists $hash{$circle[1]});
}
close OUT;
close OL;