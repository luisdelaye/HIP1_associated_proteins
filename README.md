# HIP1_associated_proteins
Data from the manuscript: "Guilt by association: Genes related to the abundance of Highly Iterated Palindromes in Cyanobacteria" by  Ulises Rodriguez-Cruz, Gabriel Moreno-Hagelsieb, Cei Abreu and Luis Delaye.

The following files are available:

- cyanobacterial-tree.nwk.
Maximum-likelihood cyanobacterial tree inferred from 32 concatenated protein sequences in newick format. 

- vector-HIPs.csv.
Vector used for Discrete analysis. 1: Cyanobacteria classified as having HIPs; 0) Cyanobacteria classified as not having HIPs.

- ObsExp-palindromic-octamers.csv.
Frequency of all 256 palindromic octamers in 126 cyanobacterial genomes; expected frequency of all 256 palindromic octamers according to Markov model; enrichment p-value and FDR. 

- CyanoGenomes.txt
Genome versions used in this study.

- markovMs.pl
A Perl script to count the number of observed octameric palindromes and to estimate the number of expected octameric palindromes by using markov models.

- markovMs.R
A R script to estimate p-values and FDRs of observed versus expected octameric palindromes.
