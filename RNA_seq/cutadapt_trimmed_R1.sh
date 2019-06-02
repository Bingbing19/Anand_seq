#!/bin/bash
#
#SBATCH --job-name=cutadapt_trimmed_R1
#SBATCH -n 1
#SBATCH -t 1-00:00 
#SBATCH --output=cutadapt_trimmed_only.out
 
module load cutadapt/1.18

for f1 in *R1.fastq; do echo $f1 && cutadapt -g XT{50} -O 5 --discard-untrimmed -o ${f1/.fastq/_trimmed.fastq} ${f1} > ${f1/.fastq/_catrimmed.txt}; done




