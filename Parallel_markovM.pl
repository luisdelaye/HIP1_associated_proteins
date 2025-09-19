#!/usr/bin/perl
#-------------------------------------------------------------------------------
# Script: Parallel_markov.pl
# Description: Parallel processor for batch analysis of
#              palindromic sequences in genomic DNA using Markov models
# 
# This script enables parallel execution of markovM.pl across multiple
# FASTA/FNA files, utilizing all available CPU cores for maximum efficiency.
#
# Usage: perl fork_markov.pl [-p N] [-h]
#
# Examples:
#   perl Parallel_markov.pl                 # Auto-detect CPUs, console output
#   perl Parallel_markov.pl -p 4            # 4 processes
#   perl Parallel_markov.pl -h              # Show help
#
# Input Requirements:
# - FASTA/FNA files (.fasta or .fna extension) in current directory
# - markovM.pl script in same directory
# - palindromes.csv file with sequence patterns
#
# Output:
# - Individual analysis results for each input file
# - All results concatenated in allResultsMarkov.txt 
# - Detailed logs in logs/[filename].markov.log
#
# Features:
# - Automatic CPU core detection and utilization
# - Cross-platform compatibility (Linux, macOS, Windows)
# - Configurable parallel processing (-p option)
# - Built-in help documentation (-h option)
#
# Dependencies:
# - Perl 5.10+ with Parallel::ForkManager and Getopt::Long
# - markovM.pl script for individual file processing
# - Standard Unix utilities for CPU detection
# 
# Author: Christian Eduardo Martinez Guerrero
# christian.martinez@cinvestav.mx
#
#----------------------------------------------------------------------------------
use strict;
use warnings;
use Getopt::Long;
use Parallel::ForkManager;


# Try to detect available CPUs, default to 4 if detection fails
my $DEFAULT_MAX_PROCESSES = get_available_cpus() || 4;
my $MAX_PROCESSES = $DEFAULT_MAX_PROCESSES;
my $verbose = 0;
my $log_enabled = 0;
my $help = 0;

# Process command line parameters
GetOptions(
    "p=i"   => \$MAX_PROCESSES,    # Maximum number of processes
    "h|help" => \$help             # Show help
) or die "Error in parameters. Use -h for help.\n";

# Show help if requested
if ($help) {
    print_help();
    exit 0;
}

# Validate number of processes
if ($MAX_PROCESSES < 1) {
    warn "Warning: Number of processes must be at least 1. Using default: $DEFAULT_MAX_PROCESSES\n";
    $MAX_PROCESSES = $DEFAULT_MAX_PROCESSES;
}

    print "Available CPUs detected: $DEFAULT_MAX_PROCESSES\n";
    print "Using processes: $MAX_PROCESSES\n";

my $pm = Parallel::ForkManager->new($MAX_PROCESSES);

my @files = glob("*.fasta *.fna");

if (scalar(@files) == 0) {
    die "Error: No .fasta or .fna files found in current directory\n";
}

    print "Files found: " . scalar(@files) . "\n";
    print join("\n", @files) . "\n";
    print "Starting parallel processing with $MAX_PROCESSES processes...\n\n\n";



#-----------------------------------------------------------------------------------------------

DATA_LOOP:
foreach my $line (@files) {
    chomp($line);

    my $outF = $line;
    $outF =~ s/\.fna|\.fasta/\.markov\.log/;
    my $path= "logs/".$outF;
    # Forks and returns the pid for the child:
    my $pid = $pm->start and next DATA_LOOP;
    print "Processing: $line (PID: $$)\n";
    system "perl markovM.pl $line > logs/$outF";

    $pm->finish; # Terminates the child process
}

$pm->wait_all_children;
    system "cat *.outputMarkov.txt>allResultsMarkov.txt";  
    print "Processing completed for " . scalar(@files) . " files\n";


#-----------------------------------------------------------------------------------------------

# Subroutine to detect available CPUs
sub get_available_cpus {
    my $cpus = 1;
    
    # Try different methods to detect CPU count
    if ($^O eq 'linux') {
        if (open my $proc, '<', '/proc/cpuinfo') {
            $cpus = grep /^processor\s+:/, <$proc>;
            close $proc;
        }
    }
    elsif ($^O eq 'darwin') { # macOS
        $cpus = `sysctl -n hw.ncpu`;
        chomp $cpus;
    }
    elsif ($^O eq 'MSWin32') { # Windows
        $cpus = $ENV{NUMBER_OF_PROCESSORS} || 1;
    }
    
    # Ensure at least 1 CPU
    $cpus = 1 if $cpus < 1;
    
    return $cpus;
}

# Subroutine to display help
sub print_help {
    print <<"HELP";
Usage: Parallel_markov.pl [OPTIONS]

Description:
  Parallel processor for running markovM.pl on multiple FASTA/FNA files
  using multiple concurrent processes. Automatically uses maximum available
  CPUs by default.

Options:
  -p N    Maximum number of parallel processes (default: auto-detect CPUs)
  -h, -help  Show this help message and exit

Examples:
  perl Parallel_markov.pl                 # Auto-detect CPUs, no logging
  perl Parallel_markov.pl -p 4            # Use exactly 4 processes
  perl Parallel_markov.pl -h              # Show help

Notes:
  - Automatically detects and uses all available CPU cores
  - Manual override with -p N option
  - Searches for files with .fasta and .fna extensions
  - Creates 'logs' directory automatically 
  - Log files are named: [filename].markov.log
  - Requires markovM.pl in the same directory

CPU Detection:
  - Linux: /proc/cpuinfo
  - macOS: sysctl hw.ncpu
  - Windows: NUMBER_OF_PROCESSORS environment variable
  - Fallback: 4 processes if detection fails
HELP
}
