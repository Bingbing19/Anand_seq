#!/bin/bash
#
#SBATCH --job-name=samtools_bamtools_SE_R1.sh
#SBATCH -n 1
#SBATCH -t 1-00:00 
#SBATCH --output=samtools_bamtools_SE_R1.out

module load gcc/8.2.0
module load samtools/1.9
module load bedtools/2.27.1


for file in *hs2.sam; do echo $file && samtools view -S -b ${file} > ${file/sam/bam}; done


for file in *bam; do echo $file && samtools view -H ${file} > ${file/.bam/_header.sam}; done


for f1 in *bam; do f2=${f1/.bam/_header.sam} && echo $f1 $f2 && samtools view ${f1} | grep -w "NH:i:1" | cat ${f2} - | samtools view -Sb - > ${f1/.bam/_unique.bam}; done


for file in *unique.bam; do echo $file && samtools sort $file -o ${file/.bam/_sorted.bam} && rm $file; done

 
for file in *sorted.bam; do echo $file && samtools index -b $file; done

for file in *sorted.bam; do echo $file && samtools idxstats $file | cut -f 1 | grep -v chrM | xargs samtools view -b $file > ${file/.bam/_mt.bam}; done


for file in *_unique_sorted_mt.bam; do echo $file && bedtools bamtobed -cigar -i $file > ${file/_unique_sorted_mt.bam/.bed}; done


for str in "+" "-"; do [ "$str" = "+" ] && n="rev" || n="fw"; for file in *bed; do sample=${file} && echo $n $sample && bedtools genomecov -g /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_new.genome -i $file -bg -5 -strand $str > ${sample}_${n}.bg; done; done

f_str="fw"; r_str="rev"; ext=".bg"; for file1 in *${f_str}${ext}; do file2=${file1/${f_str}/${r_str}} && outfile=${file1/${f_str}${ext}/fw_rev.bedgraph} && echo $file1 "+" $file2 "=" $outfile && awk 'BEGIN{OFS="\t"}{print $1,$2,$3,"-"$4}' $file2 | cat $file1 - | sort -k1,1 -k2,2n > $outfile; done
