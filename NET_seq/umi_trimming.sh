#!/bin/bash
#
#SBATCH --job-name=umi_tools_trimming
#SBATCH -n 1
#SBATCH -t 1-00:00 # Runtime in D-HH:MM
 
module load umi-tools/0.5.5

for f1 in *R1_001.fastq; do f2=${f1/R1/R2} && echo $f1 $f2 && umi_tools extract --stdin=${f1} --read2-in=${f2} --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=${f1/.fastq/_UMI.fastq} --read2-out=${f2/.fastq/_UMI.fastq}; done
