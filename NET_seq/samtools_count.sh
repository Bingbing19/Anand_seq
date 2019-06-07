#!/bin/bash
#
#SBATCH --job-name=samtools_count
#SBATCH -n 1
#SBATCH -t 1-00:00 
#SBATCH --output=samtools_count.out

module load gcc/8.2.0
module load samtools/1.9


for file in *sorted.bam; do echo $file && samtools flagstat $file; done


for file in *mt.bam; do echo $file && samtools flagstat $file; done

