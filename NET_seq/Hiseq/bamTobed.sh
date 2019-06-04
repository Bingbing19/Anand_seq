#!/bin/bash
#
#SBATCH --job-name=bamTobed_Hiseq
#SBATCH -n 1
#SBATCH -t 1-00:00 
#SBATCH --output=bamtobed_Hiseq.out
module load gcc/8.2.0
module load bedtools/2.27.1


for file in *_unique_sorted_mt.bam; do echo $file && bedtools bamtobed -cigar -i $file > ${file/_unique_sorted_mt.bam/.bed}; done


for str in "+" "-"; do [ "$str" = "+" ] && n="rev" || n="fw"; for file in *bed; do sample=${file} && echo $n $sample && bedtools genomecov -g /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_new.genome -i $file -bg -strand $str > ${sample}_${n}.bg; done; done

f_str="fw"; r_str="rev"; ext=".bg"; for file1 in *${f_str}${ext}; do file2=${file1/${f_str}/${r_str}} && outfile=${file1/${f_str}${ext}/fw_rev.bedgraph} && echo $file1 "+" $file2 "=" $outfile && awk 'BEGIN{OFS="\t"}{print $1,$2,$3,"-"$4}' $file2 | cat $file1 - | sort -k1,1 -k2,2n | sed '1i track type=bedGraph color=0,100,200 altColor=200,100,0' > $outfile; done


