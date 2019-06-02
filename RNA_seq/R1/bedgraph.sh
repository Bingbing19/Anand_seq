#!/bin/bash
#
#SBATCH --job-name=bamTobed
#SBATCH -n 1
#SBATCH -t 1-00:00 

module load gcc/8.2.0
module load bedtools/2.27.1

for str in "+" "-"; do [ "$str" = "+" ] && n="rev" || n="fw"; for file in *bed; do sample=${file} && echo $n $sample && bedtools genomecov -g /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_new.genome -i $file -bg -5 -strand $str > ${sample}_${n}.bg; done; done
