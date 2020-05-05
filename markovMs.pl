#!/usr/bin/perl

# This script counts the number of observed octameric palindromes (like GCGAGCGC) in
# a set of genomes located in a directory named: ../GenomasGbk/.
# This script also estimate the number of observed octameric palindromes by using 
# markov models.

# Script: markovM.pl
# use: 
# perl markovM.pl 
# out: markov-outfile.txt

# Luis Jose Delaye Arredondo
# luis.delaye@cinvestav.mx
# http://www.ira.cinvestav.mx/evolutionary.genomics
# Copy left
# : - )

# The file palindromes.csv must contain the following line:
# "AAAATTTT","AAACGTTT","AAAGCTTT","AAATATTT","AACATGTT","AACCGGTT","AACGCGTT","AACTAGTT","AAGATCTT","AAGCGCTT","AAGGCCTT","AAGTACTT","AATATATT","AATCGATT","AATGCATT","AATTAATT","ACAATTGT","ACACGTGT","ACAGCTGT","ACATATGT","ACCATGGT","ACCCGGGT","ACCGCGGT","ACCTAGGT","ACGATCGT","ACGCGCGT","ACGGCCGT","ACGTACGT","ACTATAGT","ACTCGAGT","ACTGCAGT","ACTTAAGT","AGAATTCT","AGACGTCT","AGAGCTCT","AGATATCT","AGCATGCT","AGCCGGCT","AGCGCGCT","AGCTAGCT","AGGATCCT","AGGCGCCT","AGGGCCCT","AGGTACCT","AGTATACT","AGTCGACT","AGTGCACT","AGTTAACT","ATAATTAT","ATACGTAT","ATAGCTAT","ATATATAT","ATCATGAT","ATCCGGAT","ATCGCGAT","ATCTAGAT","ATGATCAT","ATGCGCAT","ATGGCCAT","ATGTACAT","ATTATAAT","ATTCGAAT","ATTGCAAT","ATTTAAAT","CAAATTTG","CAACGTTG","CAAGCTTG","CAATATTG","CACATGTG","CACCGGTG","CACGCGTG","CACTAGTG","CAGATCTG","CAGCGCTG","CAGGCCTG","CAGTACTG","CATATATG","CATCGATG","CATGCATG","CATTAATG","CCAATTGG","CCACGTGG","CCAGCTGG","CCATATGG","CCCATGGG","CCCCGGGG","CCCGCGGG","CCCTAGGG","CCGATCGG","CCGCGCGG","CCGGCCGG","CCGTACGG","CCTATAGG","CCTCGAGG","CCTGCAGG","CCTTAAGG","CGAATTCG","CGACGTCG","CGAGCTCG","CGATATCG","CGCATGCG","CGCCGGCG","CGCGCGCG","CGCTAGCG","CGGATCCG","CGGCGCCG","CGGGCCCG","CGGTACCG","CGTATACG","CGTCGACG","CGTGCACG","CGTTAACG","CTAATTAG","CTACGTAG","CTAGCTAG","CTATATAG","CTCATGAG","CTCCGGAG","CTCGCGAG","CTCTAGAG","CTGATCAG","CTGCGCAG","CTGGCCAG","CTGTACAG","CTTATAAG","CTTCGAAG","CTTGCAAG","CTTTAAAG","GAAATTTC","GAACGTTC","GAAGCTTC","GAATATTC","GACATGTC","GACCGGTC","GACGCGTC","GACTAGTC","GAGATCTC","GAGCGCTC","GAGGCCTC","GAGTACTC","GATATATC","GATCGATC","GATGCATC","GATTAATC","GCAATTGC","GCACGTGC","GCAGCTGC","GCATATGC","GCCATGGC","GCCCGGGC","GCCGCGGC","GCCTAGGC","GCGATCGC","GCGCGCGC","GCGGCCGC","GCGTACGC","GCTATAGC","GCTCGAGC","GCTGCAGC","GCTTAAGC","GGAATTCC","GGACGTCC","GGAGCTCC","GGATATCC","GGCATGCC","GGCCGGCC","GGCGCGCC","GGCTAGCC","GGGATCCC","GGGCGCCC","GGGGCCCC","GGGTACCC","GGTATACC","GGTCGACC","GGTGCACC","GGTTAACC","GTAATTAC","GTACGTAC","GTAGCTAC","GTATATAC","GTCATGAC","GTCCGGAC","GTCGCGAC","GTCTAGAC","GTGATCAC","GTGCGCAC","GTGGCCAC","GTGTACAC","GTTATAAC","GTTCGAAC","GTTGCAAC","GTTTAAAC","TAAATTTA","TAACGTTA","TAAGCTTA","TAATATTA","TACATGTA","TACCGGTA","TACGCGTA","TACTAGTA","TAGATCTA","TAGCGCTA","TAGGCCTA","TAGTACTA","TATATATA","TATCGATA","TATGCATA","TATTAATA","TCAATTGA","TCACGTGA","TCAGCTGA","TCATATGA","TCCATGGA","TCCCGGGA","TCCGCGGA","TCCTAGGA","TCGATCGA","TCGCGCGA","TCGGCCGA","TCGTACGA","TCTATAGA","TCTCGAGA","TCTGCAGA","TCTTAAGA","TGAATTCA","TGACGTCA","TGAGCTCA","TGATATCA","TGCATGCA","TGCCGGCA","TGCGCGCA","TGCTAGCA","TGGATCCA","TGGCGCCA","TGGGCCCA","TGGTACCA","TGTATACA","TGTCGACA","TGTGCACA","TGTTAACA","TTAATTAA","TTACGTAA","TTAGCTAA","TTATATAA","TTCATGAA","TTCCGGAA","TTCGCGAA","TTCTAGAA","TTGATCAA","TTGCGCAA","TTGGCCAA","TTGTACAA","TTTATAAA","TTTCGAAA","TTTGCAAA","TTTTAAAA"

# This script requieres a directory named: ../GenomasGbk/ containing all the genomes
# in fasta format, example: Acaryochloris_marina_MBIC11017.fasta


use strict;

my $n = 0;

my $string;
open (MIA, "palindromes.csv") or die ("No puedo abrir palindromes.csv\n");
while (my $linea = <MIA>){
	chomp ($linea);
	$string = $linea;
}
close (MIA);
my @palindromes = split (/,/, $string);
for (my $i = 0; $i <= $#palindromes; $i++){
	$palindromes[$i] =~ s/"//g;
	$n++;
	#print ("($palindromes[$i])\t$n\n");
}

my @files = glob("../GenomesGbk/*.fasta");

open (ROB, ">markov-outfile.txt") or die ("No puedo abrir markov-outfile.txt\n");
print ROB ("spp\tacc\tpalindrom\tobs\tmarkov0\tmarkov1\tmarkov2\tmarkov3\tgenomesize\tA\tT\tC\tG\tN\n");
for (my $i = 0; $i <= $#files; $i++){
	my $spp = $files[$i];
	$spp =~ s/\.\.\/\.\.\/GenomasGbk_1\///; 
	$spp =~ s/.fasta//;
	#print ("$spp\n");
	my $freturn = ();
	for (my $j = 0; $j <= $#palindromes; $j++){
		$freturn = markov($files[$i], $palindromes[$j]);
		#$spp,$acc,$palindrom,$obs,$markov0,$markov1,$markov2,$markov3,$GS,$A,$T,$C,$G,$N
		print ("@{$freturn}\n");
		for (my $j = 0; $j <= $#{$freturn}; $j++){
			if ($j < $#{$freturn}){
				print ROB ("${$freturn}[$j]\t");
			} else {
				print ROB ("${$freturn}[$j]\n");
			}
		}
		#my $pausa = <STDIN>;
	}
}
close (ROB);

sub markov {
	#-----------------------------------------------------------------------------------------
	# Cargo el genoma
	my $file = $_[0];
	my $octa = $_[1];
	print ("$file\t$octa\n");
	
	my $obs = 0;
	my $G;
	my $acc;
	
	#-----------------------------------------------------------------------------------------
	# Cargo el genoma
	open (MIA, "$file") or die ("No puedo abrir $file\n");
	while (my $linea = <MIA>){
		chomp ($linea);
		if ($linea !~ />/){
			$G = $G.$linea;	
		} else {
			$acc = $linea;
		}
	}
	close (MIA);
	$acc =~ s/>//;
	my @G = split (//, $G);
	my @p = split (//, $octa);
	
	#-----------------------------------------------------------------------------------------
	# Cuento las frecuencias
	
	my $A = 0;
	my $T = 0;
	my $C = 0;
	my $G = 0;
	my $N = 0;
	
	my %Counts2;
	my %Counts3;
	my %Counts4;
	my %hash2;
	my %hash3;
	my %hash4;
	
	for (my $i = 0; $i <= $#G; $i++){
		my $octamero = ();
		for (my $j = $i; $j < ($i+8); $j++){
			$octamero = $octamero.$G[$j];
		}
		if ($octamero eq $octa){
			$obs++;
		}
		if ($G[$i] eq 'A'){
			$A++;
		} elsif ($G[$i] eq 'T'){
			$T++;
		} elsif ($G[$i] eq 'C'){
			$C++;
		} elsif ($G[$i] eq 'G'){
			$G++
		} else {
			$N++;
		}
		# dinucleotidos para Markov 1
		for (my $j = 0; $j < $#p; $j++){
			if ($G[$i].$G[$i+1] eq $p[$j].$p[$j+1]){
				if (!exists $hash2{$i}){
					$Counts2{$p[$j].$p[$j+1]}++;
					#print ("($i : $j)\t$G[$i].$G[$i+1] eq $p[$j].$p[$j+1]\t=\t$Counts2{$p[$j].$p[$j+1]}\n");
					$hash2{$i} = 1;
				}
			}	
		}
		# trinucleotidos para Markov 2
		for (my $j = 0; $j < ($#p -1); $j++){
			if ($G[$i].$G[$i+1].$G[$i+2] eq $p[$j].$p[$j+1].$p[$j+2]){
				if (!exists $hash3{$i}){
					$Counts3{$p[$j].$p[$j+1].$p[$j+2]}++;
					$hash3{$i} = 1;
				}
			}	
		}
		# tetranucleotidos para Markov 3
		for (my $j = 0; $j < ($#p -2); $j++){
			if ($G[$i].$G[$i+1].$G[$i+2].$G[$i+3] eq $p[$j].$p[$j+1].$p[$j+2].$p[$j+3]){
				if (!exists $hash4{$i}){
					$Counts4{$p[$j].$p[$j+1].$p[$j+2].$p[$j+3]}++;
					$hash4{$i} = 1;
				}
			}	
		}
	}
	
	# Genome size
	my $GS = $A + $T + $C + $G;
	print ("\nGenome size: $GS\n");
	
	# Imprimo las frecuencias
	print ("\nFrecuencias\n");
	print ("A\t$A\n");
	print ("T\t$T\n");
	print ("C\t$C\n");
	print ("G\t$G\n");
	print ("-----\n");
	my @kCounts2 = sort keys (%Counts2);
	for (my $i = 0; $i <= $#kCounts2; $i++){
		print ("$kCounts2[$i]\t$Counts2{$kCounts2[$i]}\n");
	}
	print ("-----\n");
	my @kCounts3 = sort keys (%Counts3);
	for (my $i = 0; $i <= $#kCounts3; $i++){
		print ("$kCounts3[$i]\t$Counts3{$kCounts3[$i]}\n");
	}
	print ("-----\n");
	my @kCounts4 = sort keys (%Counts4);
	for (my $i = 0; $i <= $#kCounts4; $i++){
		print ("$kCounts4[$i]\t$Counts4{$kCounts4[$i]}\n");
	}
	
	#-----------------------------------------------------------------------------------------
	# Calculo las frecuencias esperadas (Markov)
	
	# Frecuencia de las bases
	my $fA = $A/$GS;
	my $fT = $T/$GS;
	my $fC = $C/$GS;
	my $fG = $G/$GS;
	
	# Numero esperado de motivos a partir de las frecuencias de mononucleotidos
	# Markov 0
	my $markov0 = 1;
	for (my $i = 0; $i <= $#p; $i++){
		if ($p[$i] eq 'A'){
			$markov0 = $markov0 * $A/$GS;
		} elsif ($p[$i] eq 'C'){
			$markov0 = $markov0 * $C/$GS;
		} elsif ($p[$i] eq 'G'){
			$markov0 = $markov0 * $G/$GS;
		} elsif ($p[$i] eq 'T'){
			$markov0 = $markov0 * $T/$GS;
		} else {
			# print ("$p[$i]\n");
		}
	}
	$markov0 = $markov0 * ($GS -8 +1);
	
	#-----
	# Numero esperado de motivos a partir de las frecuencias de dinucleotidos
	# Markov 1
	
	print ("\n-----\nMarkov 1\n");
	print ("Numerador\n");
	my $markov1_n = 1;
	my $sino_n  = 0;
	for (my $i = 0; $i < $#p; $i++){
		if (exists $Counts2{$p[$i].$p[$i+1]}){
			$markov1_n = $markov1_n * $Counts2{$p[$i].$p[$i+1]}/$GS;
			my $frec = $Counts2{$p[$i].$p[$i+1]}/$GS;
			print ("$p[$i].$p[$i+1]\t$Counts2{$p[$i].$p[$i+1]}\t$frec\t$markov1_n\n");
			$sino_n = 1;
		} else {
			print ("no existe: $p[$i].$p[$i+1]\n");
		}
	}
	print ("-----\n");
	print ("Denominador\n");
	my $markov1_d = 1;
	for (my $i = 1; $i < $#p; $i++){
		if ($p[$i] eq 'A'){
			$markov1_d = $markov1_d * $A/$GS;
			my $frec = $A/$GS;
			print ("$p[$i]\t$A\t$frec\t$markov1_d\n");
		} elsif ($p[$i] eq 'C'){
			$markov1_d = $markov1_d * $C/$GS;
			my $frec = $C/$GS;
			print ("$p[$i]\t$C\t$frec\t$markov1_d\n");
		} elsif ($p[$i] eq 'G'){
			$markov1_d = $markov1_d * $G/$GS;
			my $frec = $G/$GS;
			print ("$p[$i]\t$G\t$frec\t$markov1_d\n");
		} elsif ($p[$i] eq 'T'){
			$markov1_d = $markov1_d * $T/$GS;
			my $frec = $T/$GS;
			print ("$p[$i]\t$T\t$frec\t$markov1_d\n");
		} else {
			# print ("$p[$i]\n");
		}
	}
	my $markov1 = 0;
	if ($sino_n == 1){
		print ("\nnumerador: $markov1_n\ndenominador: $markov1_d\n");
		$markov1 = ($markov1_n/$markov1_d)*($GS -8 +1);
	}
	
	#-----
	# Numero esperado de motivos a partir de las frecuencias de trinucleotidos
	# Markov 2
	
	print ("\n-----\nMarkov 2\n");
	print ("Numerador\n");
	my $markov2_n = 1;
	$sino_n  = 0;
	for (my $i = 0; $i < ($#p -1); $i++){
		if (exists $Counts3{$p[$i].$p[$i+1].$p[$i+2]}){
			$markov2_n = $markov2_n * $Counts3{$p[$i].$p[$i+1].$p[$i+2]}/$GS;
			my $frec = $Counts3{$p[$i].$p[$i+1].$p[$i+2]}/$GS;
			print ("$p[$i].$p[$i+1].$p[$i+2]\t$Counts3{$p[$i].$p[$i+1].$p[$i+2]}\t$frec\t$markov2_n\n");
			$sino_n = 1;
		} else {
			print ("no existe: $p[$i].$p[$i+1].$p[$i+2]\n");
		}
	}
	print ("-----\n");
	print ("Denominador\n");
	my $markov2_d = 1;
	for (my $i = 1; $i < ($#p -1); $i++){
		if (exists $Counts2{$p[$i].$p[$i+1]}){
			$markov2_d = $markov2_d * $Counts2{$p[$i].$p[$i+1]}/$GS;
			my $frec = $Counts2{$p[$i].$p[$i+1]}/$GS;
			print ("$p[$i].$p[$i+1]\t$Counts2{$p[$i].$p[$i+1]}\t$frec\t$markov2_d\n");
			$sino_n = 1;
		} else {
			print ("no existe: $p[$i].$p[$i+1]\n");
		}
	}
	my $markov2 = 0;
	if ($sino_n == 1){
		print ("-----\nnumerador: $markov2_n\ndenominador: $markov2_d\n");
		$markov2 = ($markov2_n/$markov2_d)*($GS -8 +1);
	}
	
	#-----
	# Numero esperado de motivos a partir de las frecuencias de tetranucleotidos
	# Markov 3
	
	print ("\n-----\nMarkov 3\n");
	print ("Numerador\n");
	my $markov3_n = 1;
	$sino_n  = 0;
	for (my $i = 0; $i < ($#p -2); $i++){
		if (exists $Counts4{$p[$i].$p[$i+1].$p[$i+2].$p[$i+3]}){
			$markov3_n = $markov3_n * $Counts4{$p[$i].$p[$i+1].$p[$i+2].$p[$i+3]}/$GS;
			my $frec = $Counts4{$p[$i].$p[$i+1].$p[$i+2].$p[$i+3]}/$GS;
			print ("$p[$i].$p[$i+1].$p[$i+2].$p[$i+3]\t$Counts4{$p[$i].$p[$i+1].$p[$i+2].$p[$i+3]}\t$frec\t$markov3_n\n");
			$sino_n = 1;
		} else {
			print ("no existe: $p[$i].$p[$i+1].$p[$i+2].$p[$i+3]\n");
		}
	}
	print ("-----\n");
	print ("Denominador\n");
	my $markov3_d = 1;
	for (my $i = 1; $i < ($#p -2); $i++){
		if (exists $Counts3{$p[$i].$p[$i+1].$p[$i+2]}){
			$markov3_d = $markov3_d * $Counts3{$p[$i].$p[$i+1].$p[$i+2]}/$GS;
			my $frec = $Counts3{$p[$i].$p[$i+1].$p[$i+2]}/$GS;
			print ("$p[$i].$p[$i+1].$p[$i+2]\t$Counts3{$p[$i].$p[$i+1].$p[$i+2]}\t$frec\t$markov3_d\n");
			$sino_n = 1;
		} else {
			print ("no existe: $p[$i].$p[$i+1].$p[$i+2]\n");
		}
	}
	my $markov3 = 0;
	if ($sino_n == 1){
		print ("-----\nnumerador: $markov3_n\ndenominador: $markov3_d\n");
		$markov3 = ($markov3_n/$markov3_d)*($GS -8 +1);
	}
	
	#-----------------------------------------------------------------------------------------
	# Imprimiendo los resultados
	
	print ("-----\n");
	print ("Obs\tA\tT\tC\tG\tN\tmarkov0\tmarkov1\tmarkov2\tmarkov3\n");
	printf ("$obs\t%1.2f\t%1.2f\t%1.2f\t%1.2f\t$N\t%1.2f\t%1.2f\t%1.2f\t%1.2f\n",$fA,$fT,$fC,$fG,$markov0,$markov1,$markov2,$markov3);
	print ("\$markov0: $markov0\n");
	print ("\$markov1: $markov1\n");
	print ("\$markov2: $markov2\n");
	print ("\$markov3: $markov3\n");
	
	my $spp = $file;
	$spp =~ s/\.\.\/\.\.\/GenomasGbk_1\///; 
	$spp =~ s/.fasta//;
	#open (ROB, ">outfile.txt") or die ("No puedo arbir outfile.txt\n");
	#print ROB ("spp\tobs\tmarkov0\tmarkov1\tmarkov2\tmarkov3\tgenomesize\tA\tT\tC\tG\tN\n");
	#print ROB ("$spp\t$obs\t$markov0\t$markov1\t$markov2\t$markov3\t$GS\t$A\t$T\t$C\t$G\t$N\n");
	#close (ROB)
	my @return = ($spp,$acc,$octa,$obs,$markov0,$markov1,$markov2,$markov3,$GS,$A,$T,$C,$G,$N);
	return (\@return);
}
