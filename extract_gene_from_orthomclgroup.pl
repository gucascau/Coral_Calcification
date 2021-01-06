#!/usr/bin/perl
# Description: This program extract genes from othomcl group
use strict;
use warnings;
use Getopt::Long;
my $ver="1.0"; #version
my %opts;
GetOptions(\%opts,"i:s","o:s","e:s","p:s","h!");
my $usage=<<"USAGE";
       Program : $0
       Version : $ver
       Contact : wangxin <wangxin\@big.ac.cn>
       Usage : $0 -i raw protein fasta -e orthomcl all group stat -p orthomcl all group -o extracted gene fasta dir 
                  -h Display this usage information
USAGE
die $usage if (!defined $opts{i} || !defined $opts{e} || !defined $opts{o} || !defined $opts{p} || $opts{h});
my $Time_Start =scalar (localtime(time()));
print "Start time is $Time_Start\n";
print "*********************************
Running.....\n*********************************\n";
my $input=$opts{i};
my $input2=$opts{e};
my $input3=$opts{p};
my $output=$opts{o};
my ($number,$number2,$key,%hash,%hash2);
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

open (IN2,"$input2") or die $!;
while (<IN2>){
	chomp;$_=~s/\r//g;
	my @array=split;
	$hash2{$array[0]}++;
}
close IN2;
if (-d $output)
{
}
else
{
	system ("mkdir $output");
}
open IN3, "$input3" or die $!;
while (<IN3>) {
	chomp;$_=~s/\r//g;
	my @gene=split /\s+/,$_;
	if (exists $hash2{$gene[0]}){
		open (OUT, ">$output/$gene[0].fa") or die $!;
		foreach my $num(1..$#gene){
			print OUT ">$gene[$num]\n$hash{$gene[$num]}\n";		
		}
		close OUT;
		
	}
}


close IN3;
my $Time_Stop =scalar (localtime(time()));
print "Stop time is $Time_Stop\n";
print "*********************************
Jobs Done!\n*********************************\n";
