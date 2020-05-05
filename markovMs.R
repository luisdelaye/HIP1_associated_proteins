setwd('/Users/somebody/somewhere/')

rm(list = ls())

# Note
# Before using this script, use the following Perl script (preparetable.pl):

##!/usr/bin/perl
#use strict;
#my $file = $ARGV[0];
#my $l = 0;
#open (MIA, "$file") or die ("No puedo abrir $file\n");
#while (my $linea = <MIA>){
#	chomp ($linea);
#	if ($l == 0){
#		print ("$linea\n");
#	} else {
#		if ($linea !~ /genomesize/){
#			print ("$linea\n");
#		} else {
#			#print ("$linea\n");
#		}
#	}
#	$l++;
#}
#close (MIA);

# like that:
# perl preparetalbe.pl markov-esperados.txt > markov-esperados.e1.txt

# Read the table from markovMs.pl (after using the above Perl script)
tabla = read.table(file="markov-esperados.e1.txt", header=TRUE, sep="\t")

# Calculate p-values and fdrs
tabla$pval = pbinom((tabla$obs-1),(tabla$genomesize -8+1),(tabla$markov3/(tabla$genomesize-8+1)),lower.tail = FALSE) 
tabla$fdrs <- p.adjust(tabla$pval, method="fdr")

# Calculate observed frequencies
tabla$frecObs <- (1000*tabla$obs/tabla$genomesize)

# Write the table with p-values and fdrs
# write.table(tabla, file="markov-esperados.e1.fdrs.txt", sep="\t")
