#!/bin/bash
#
#SBATCH --job-name=samtools_RNAseq
#SBATCH -n 1
#SBATCH -t 1-00:00 

module load gcc/8.2.0
module load samtools/1.9


for file in *hs2.sam; do echo $file && samtools view -S -b ${file} > ${file/sam/bam}; done


for file in *bam; do echo $file && samtools view -H ${file} > ${file/.bam/_header.sam}; done




 
