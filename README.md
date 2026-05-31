HIP1_associated_proteins
========================

Data from the manuscript: "Phylogenetic correlation between the Type IV Secretion System and HIP1 suggest an adaptation for horizontal gene transfer conserved at the phylum level" by Ulises Rodriguez-Cruz, Gabriel Moreno-Hagelsieb, Cei Abreu, Christian E. Martinez-Guerrero and Luis Delaye.

The following files are available:

- CyanoGenomes.txt List of genomes from cyanobacteria used in this study.

- frequency-HIPs-389.txt. Frequency of all 256 palindromic octamers in 389 cyanobacterial genomes.

- cyanobacterial-tree-389.nwk. Maximum-likelihood tree of 389 cyanobacterial genomes.

- cyanobacterial-tree-166.nwk. Maximum-likelihood rooted tree of 166 cyanobacterial genomes.

- Parallel_markov.pl A Perl script that enables parallel execution of `markovM.pl` across multiple FASTA/FNA files, utilizing all available CPU cores for maximum efficiency.

- markovM.pl A Perl script to count the number of observed octameric palindromes and to estimate the number of expected octameric palindromes by using Markov models.

- markovMs.R A R script to estimate p-values and FDRs of observed versus expected octameric palindromes.

---

## Installation and Usage of Scripts

### Requirements
- Perl >= 5.10
- `markovM.pl` (must be in the same directory as `Parallel_markov.pl`)
- `palindromes.csv` (list of palindromic sequence patterns)
- FASTA/FNA files in the current working directory

#### Perl Modules
- `Getopt::Long` (included with Perl core)
- `Parallel::ForkManager` (must be installed)

---
### Install dependencies

##### Linux (Debian/Ubuntu):
```bash
sudo apt update
sudo apt install perl cpanminus
cpanm Parallel::ForkManager
```

##### MacOS:

- Ensure Perl is available (usually pre-installed)
- Install cpanminus if missing
```bash
curl -L https://cpanmin.us | perl - App::cpanminus
cpanm Parallel::ForkManager
``` 

#### CPAN:
```bash
perl -MCPAN -e 'install Parallel::ForkManager'
```


### Installation

#### Clone the repository
```bash
git clone https://github.com/luisdelaye/HIP1_associated_proteins.git
cd HIP1_associated_proteins
```
### Usage
##### Auto-detect CPUs
```bash
perl Parallel_markov.pl
```

##### Specify number of processes (e.g., 4)
```bash
perl Parallel_markov.pl -p 4
```

##### Show help
```bash
perl Parallel_markov.pl -h
```

### Input requirements

- FASTA/FNA files (.fasta or .fna) in the working directory
- markovM.pl in the same directory
- palindromes.csv file with palindromic sequences

### Output

- Individual analysis results for each input file
- Combined results in allResultsMarkov.txt
- Detailed logs in logs/[filename].markov.log


### Output Columns:

| Column     | Description                        |
| ---------- | ---------------------------------- |
| spp        | Species name                       |
| acc        | Accession ID                       |
| palindrom  | Palindromic sequence               |
| obs        | Observed frequencies               |
| markov0-3  | Markov model estimates (order 0–3) |
| genomesize | Genome size in base pairs          |
| A, T, C, G | Nucleotide composition counts      |
| N          | Number of ambiguous bases          |
