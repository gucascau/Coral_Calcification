#!/usr/bin/perl
#Author:Xin Wang <wang.xin@kaust.edus.sa>
#date:2015/5/21
#Description:the program combine different trimal file into one file based on different species
use strict;
use warnings;
use Getopt::Long;
my $ver="1.0";
my %opts;
GetOptions(\%opts,"i:s","o:s","h");
my $usage=<<"USAGE";
Program:$0
Contact:Wang Xin <wang.xin\@kaust.edu.sa>
Usage: $0 -i all the trimal files dir -o output of trimAl 
-h display usage
USAGE
die $usage if (!defined $opts{i}|| !defined $opts{o} || defined $opts{h});
my $Time_Start =scalar (localtime(time())); 
#print "Start time is $Time_Start\n";
#print "*********************************
#Running.....\n*********************************\n";
my $dir=$opts{i};
my $output=$opts{o};
my @files;
opendir DIR,"$dir" || die "$!";
	@files=readdir(DIR);
closedir(DIR);
my $number=0;my %seq;
for my $file(@files){
	next if($file=~m/\.$/ || $file =~m/\.\.$/);
	if ($file =~ /(output\.\S+)/){
		my $gene=$1;
		#print "$trimal\n";
		system "/Users/xinwang/Downloads/muscle3.8.31_i86darwin64 -in $gene -out $gene.msl";
		#system "/home/xinw/software/trimal-trimAl/source/trimal -in $gene.msl -out $gene.msl.trimal -automated1"
		$number++;
		open IN,"$dir/$gene.msl" or die ($!);
		my $id;my %hash;
		while (<IN>){
			chomp;$_=~s/\r//g;
			if(/^>(\S+)/){
				$id=$1;
				#$id=(split/\|/,$1)[0];
				$hash{$id}++;
			}else{
				$seq{$id}->{$number}.=$_;
			}
			#print "$id\t$number\n";
			last if ($hash{$id}>1);
		}
		close IN;
	}
		
}

open OUT,">$output" or die $!;
foreach my $id1(keys %seq){
	my $string;
	foreach my $number(sort keys %{$seq{$id1}}){
		$string.=$seq{$id1}->{$number};
	}
	print OUT ">$id1\n$string\n"
}
#foreach my $id1 (keys %seq){
#W	my $name=(split /\|/,$id1)[0];
#	if ($name eq 'jgi'){
	#	$seq2{$name}.=$seq{$id1};
	#}	
	#if ($name eq 'aip'){
	#	$seq2{$name}.=$seq{$id1};
#	}
#	if ($name eq 'dis'){
#		$seq2{$name}.=$seq{$id1};
#	}
#	if ($name eq 'acr'){
#		$seq2{$name}.=$seq{$id1};
#	}
#	if ($name eq 'spi'){
#		$seq2{$name}.=$seq{$id1};
#	}
#	if ($name eq 'amp'){
#		$seq2{$name}.=$seq{$id1};
#	}
#	
#}
#foreach my $id (keys %seq2){
#	print OUT ">$id\n$seq2{$id}\n";
#}
close OUT;
my $Time_Stop =scalar (localtime(time())); 
print "Stop time is $Time_Stop\n";
print "*********************************
Jobs Done!\n*********************************\n";