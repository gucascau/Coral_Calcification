#!/usr/bin/perl
## this script is mainly for the statistic of different species. 
### this script is mainly for the pfam annotation
my($input,$output)=@ARGV;

my %hash;
open IN,"$input" or die $!;
while (<IN>){
	chomp;
	#you could choose different depending on different annotation information;
	### this is mainly for pfam and panthen annotation 
	my ($id,$source,$length,$pan,$name,$start,$end,$score,$direction,$date)=split /\t/, $_; 
	
	##this is mainly for blast annotation
	#my($id,$source,$hit_accession,$hit_discription,$query_length,$hit_length,$query,$hit,$frame,$max_bit_score,$total_bit_score,$identity,$per_identity,$coverage,$evalue,$GO_term)=split /\t/,$_;
	#my $name=(split/\|/,$hit_accession)[1];
	my $species=(split/\|/,$id)[0];
	next unless ($pan eq "Pfam");
	## this is mainly in order to avoid the duplication stat:
	$avoid_redundent{$name}->{$id}++;
	next if ($avoid_redudent{$name}->{$id}>2);
	$hash{$name}->{$species}++;
	print "$species\n";
}

close IN;
my @species=("adi","jgi","aip","spis","dis","amp","gnl");

open OUT, ">$output" or die $!;
print OUT "ID\t";
foreach my $id (sort @species){
	print OUT "$id\t";
}
print OUT "\n";
foreach my $name (sort keys %hash){
	print  OUT "$name\t";
	foreach my $sp (sort @species){
		if (!exists $hash{$name}->{$sp}){
			$hash{$name}->{$sp}=0;
		}
		print OUT "$hash{$name}->{$sp}\t";
	}
	print OUT "\n";
	
}
close OUT;