#!/bin/bash
#
#SBATCH --job-name=fastqc
#SBATCH -n 1
#SBATCH -t 1-00:00 # Runtime in D-HH:MM
#SBATCH --output=fastqc.out
 
module load FastQC/0.11.7
 
fastqc -o ./fastqc_pretrim/ *_R1.fastq
fastqc -o ./fastqc_pretrim/ *_R2.fastq
