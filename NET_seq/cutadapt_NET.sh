#!/bin/bash
#
#SBATCH --job-name=cutadapt_trimming
#SBATCH -n 1
#SBATCH -t 1-00:00 # Runtime in D-HH:MM
 
module load cutadapt/1.18

for f1 in *R2_001_UMI.fastq; do echo $f1 && cutadapt -a GATCGTCGGACTGTAGAACTCTGAAC -O 5 -o ${f1/.fastq/_cutadapt.fastq} ${f1} > cutadapt.txt; done
