#!/usr/bin/perl
# Author:Xin Wang
# Description: This program do muscle alignment from hcluster result and raw protein fasta
use strict;
use warnings;
use Getopt::Long;
my $ver="1.0"; #version
my %opts;
GetOptions(\%opts,"i:s","o:s","e:s","q:s","s:s","h!");
my $usage=<<"USAGE";
       Program : $0
       Version : $ver
       Contact : Liu Kan <liukan\@big.ac.cn>
       Usage : $0 -i raw protein fasta -e hcluster default result -o output dir 
                  -i raw protein fasta -e hcluster default result -o output dir 
                  -h Display this usage information
USAGE
die $usage if (!defined $opts{i} || !defined $opts{e} || !defined $opts{o} || $opts{h});
my $Time_Start =scalar (localtime(time())); 
print "Start time is $Time_Start\n";
print "*********************************
Running.....\n*********************************\n";
my $input=$opts{i};
my $input2=$opts{e};
my $output=$opts{o};
my ($number,$number2,$key,%hash);
open (IN,"$input")||die "$!";
while (<IN>)
{
	chomp;$_=~s/\r//g;
	if ($_ eq "")
	{
		next;
	}
	if (/^>(\S+)/)
	{
		$key=$1;
	}
	else
	{
		$hash{$key}.=$_;
	}
}
close (IN);
if (-d $output)
{
}
else
{
	system ("mkdir $output");
}
open (OUT,">$output/sep.out")||die "$!";
print OUT "********************************\n";
close (OUT);
open (IN,"$input2")||die "$!";
while (<IN>)
{
	$number+=1;
}
close (IN);
open (IN,"$input2")||die "$!";
while (<IN>)
{
	chomp;$_=~s/\r//g;
	if ($_ eq "")
	{
		next;
	}
	my @array=split (/\s+/,$_);
	#my @array2=split (/\,+/,$array[6]);
	#if ($array2[-1] eq "")
	#{
	#	pop @array2;
	#}
	#print "$array[1]\n";
	open (OUT,">$output/temp.fa")||die "$!";
	for (my $c=1;$c<=$#array;$c+=1)
	{
		print OUT ">$array[$c]\n$hash{$array[$c]}\n"
	}
	close (OUT);
	$number2+=1;
	system ("/home/xinw/software/muscle3.8.31_i86linux64 -in $output/temp.fa -out $output/temp.out");
	system ("cat $output/temp.out >>$output/total.out");
	system ("cat $output/sep.out >>$output/total.out");
	system ("rm $output/temp.fa");
	system ("rm $output/temp.out");
	open (OUT,">>$output/number")||die "$!";
	print OUT "$number2 of $number clusters have been processed!\n";
	close (OUT);
}
close (IN);
system ("rm $output/sep.out");
my $Time_Stop =scalar (localtime(time())); 
print "Stop time is $Time_Stop\n";
print "*********************************
Jobs Done!\n*********************************\n";
