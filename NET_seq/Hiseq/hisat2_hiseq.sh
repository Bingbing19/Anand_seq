#!/bin/bash
#
#SBATCH --job-name=hisat2_alignment
#SBATCH -n 1
#SBATCH -t 1-00:00 

module load hisat2/2.1.0

for f1 in *R1_001_UMI.fastq; do f2=${f1/R1/R2} && echo $f1 $f2 && hisat2 -q --phred33 --max-intronlen 4000 --known-splicesite-infile --no-unal /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index/spo_sce_splicesites.txt --rna-strandness RF --secondary --no-mixed --summary-file ${f1/R1_001_UMI.fastq/hs2.txt} -x /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index/ht2_spo_sce_index -1 ${f1} -2 ${f2} -S ${f1/R1_001_UMI.fastq/001_hs2.sam}; done

