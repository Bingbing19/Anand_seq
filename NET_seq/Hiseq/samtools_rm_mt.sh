#!/bin/bash
#
#SBATCH --job-name=samtools_Hiseq_rm_chrM
#SBATCH -n 1
#SBATCH -t 1-00:00 
#SBATCH --output=samtools_Hiseq_chrM.out

module load gcc/8.2.0
module load samtools/1.9

for file in *sorted.bam; do echo $file && samtools index -b $file; done

for file in *sorted.bam; do echo $file && samtools idxstats $file | cut -f 1 | grep -v chrM | xargs samtools view -b $file > ${file/.bam/_mt.bam}; done

 
