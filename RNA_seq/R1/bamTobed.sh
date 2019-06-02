#!/bin/bash
#
#SBATCH --job-name=bamTobed
#SBATCH -n 1
#SBATCH -t 1-00:00 

module load gcc/8.2.0
module load bedtools/2.27.1

for file in *unique_sorted.bam; do echo $file && bedtools bamtobed -cigar -i $file > ${file/unique_sorted.bam/.bed}; done


