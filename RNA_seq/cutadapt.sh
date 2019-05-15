#!/bin/bash
#
#SBATCH --job-name=cutadapt
#SBATCH -n 1
#SBATCH -t 1-00:00 
#SBATCH --output=cutadapt.out
 
module load cutadapt/1.18

for f1 in *R1.fastq; do f2=${f1/R1/R2} && echo $f1 $f2; cutadapt -g XT{50} -A A{50}X -O 5 -o ${f1/.fastq/_cutadapt.fastq} -p ${f2/.fastq/_cutadapt.fastq} ${f1} ${f2} > ${f1/.fastq/cutadapt.txt}; done




