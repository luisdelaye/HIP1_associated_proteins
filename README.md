# Data and Scripts for Manuscript

Data and scripts associated with the manuscript:  
**"Phylogenetic correlation between the Type IV Secretion System and HIP1 suggests an adaptation for horizontal gene transfer conserved at the phylum level"** by Ulises Rodriguez-Cruz, Gabriel Moreno-Hagelsieb, Cei Abreu, Christian E. Martinez-Guerrero, and Luis Delaye.

---

## 📋 Genome Datasets & Taxonomy

* **`assembly_summary_refseq.txt`**: The original NCBI RefSeq database summary file metadata corresponding to the retrieval on September 5, 2025.
* **`CyanoGenomes.txt`**: Complete curated list of the 389 completed cyanobacterial genomes used in this study, including their respective NCBI accession numbers.
* **`gtdbtk_bac120_markers_summary.tsv`**: Summary of the conserved bacterial phylogenetic protein markers identified by GTDB-Tk v1.7.0 used for downstream phylogenetic concatenation.

## 🌳 Phylogenetic Trees (Newick Format)

* **`cyanobacterial-tree-389.nwk`**: Maximum-Likelihood (ML) phylogenetic tree inferred with IQ-TREE v3.0.1 encompassing all 389 initial cyanobacterial genomes.
* **`cyanobacterial-tree-166.nwk`**: Rooted non-redundant ML phylogenetic tree of the 166 selected representative cyanobacterial genomes inferred with IQ-TREE v2.3.6 (without bootstrap support values, used for downstream comparative and evolutionary modeling).

## 📊 Palindrome & Evolutionary Analysis Data

* **`frequency-HIPs-389.txt`**: Genomic frequency matrix and observed-to-expected ($O/E$) ratios calculated for all 256 possible palindromic octamers across the 389 cyanobacterial genomes.
* **`vector_m2_1e-308.txt`**: Binarized vector ('1' or '0') representing the statistical overabundance status of the HIP1 palindrome ($\text{FDR} < 1 \times 10^{-308}$) across genomes, utilized as a phenotypic input for the BayesTraits v4.1.2 Discrete analysis.

## 💻 Computational Scripts

### Palindrome Counting & Markov Modeling (Perl)
* **`markovM.pl`**: Core Perl script designed to calculate the observed absolute counts of octameric palindromes and compute their theoretical expected frequencies $E(W)$ using a second-order Markov model.
* **`Parallel_markov.pl`**: Wrapper script to parallelize the execution of `markovM.pl` across multiple genomic FASTA/FNA files, leveraging multi-core CPU architectures.

### Statistical Assessment (R)
* **`markovMs.R`**: R script utilized to model palindrome occurrences via a binomial distribution, computing upper-tail probabilities ($P[X \ge \text{observed}]$) and executing the Benjamini-Hochberg False Discovery Rate (FDR) adjustments via `p.adjust`.
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
