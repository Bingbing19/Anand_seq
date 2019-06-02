#!/bin/bash
#
#SBATCH --job-name=samtools_RNAseq
#SBATCH -n 1
#SBATCH -t 1-00:00 

module load gcc/8.2.0
module load samtools/1.9


for file in *hs2.sam; do echo $file && samtools view -S -b ${file} > ${file/sam/bam}; done


for file in *bam; do echo $file && samtools view -H ${file} > ${file/.bam/_header.sam}; done


for f1 in *bam; do f2=${f1/.bam/_header.sam} && echo $f1 $f2 && samtools view ${f1} | grep -w "NH:i:1" | cat ${f2} - | samtools view -Sb - > ${f1/.bam/_unique.bam}; done


for file in *unique.bam; do echo $file && samtools sort $file -o ${file/.bam/_sorted.bam} && rm $file; done

 
