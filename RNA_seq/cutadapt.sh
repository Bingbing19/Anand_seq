#!/bin/bash
#
#SBATCH --job-name=cutadapt
#SBATCH -n 1
#SBATCH -t 1-00:00 # Runtime in D-HH:MM
#SBATCH --output=cutadapt.out
 
module load cutadapt/1.18

for f1 in *R1.fastq; do f2=${f1/R1/R2} && echo $f1 $f2; cutadapt -g XT{50} -G XT{50} -O 5 -o ${f2/.fastq/_cutadapt.fastq} -p ${f1/.fastq/_cutadapt.fastq} ${f2} ${f1} > cutadapt.txt; done



