#!/bin/bash
#
#SBATCH --job-name=cutadapt
#SBATCH -n 1
#SBATCH -t 1-00:00 
#SBATCH --output=cutadapt_trimmed_only_R2.out
 
module load cutadapt/1.18

for f1 in *R2.fastq; do echo $f1 && cutadapt -a A{50}X -O 5 --discard-untrimmed -o ${f1/.fastq/_trimmed.fastq} ${f1} > ${f1/.fastq/_catrimmed.txt}; done




