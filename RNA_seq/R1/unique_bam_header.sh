#!/bin/bash
#
#SBATCH --job-name=unique_bam_header
#SBATCH -n 1
#SBATCH -t 1-00:00 

module load gcc/8.2.0
module load samtools/1.9

for file in *bam; do echo $file && samtools view -H ${file} > ${file/.bam/_header.sam}; done

