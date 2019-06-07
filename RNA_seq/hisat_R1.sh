#!/bin/bash
#
#SBATCH --job-name=hisat2_SE
#SBATCH -n 1
#SBATCH -t 1-00:00 

module load hisat2/2.1.0

for f1 in *R1_trimmed.fastq; do echo $f1 && hisat2 -q --phred33 --max-intronlen 4000 --known-splicesite-infile --no-unal /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index/spo_sce_splicesites_chr.txt --rna-strandness R --secondary --no-mixed --summary-file ${f1/R1_trimmed.fastq/R1_hs2.txt} -x /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index/ht2_spo_sce_index ${f1} -S ${f1/trimmed.fastq/hs2.sam}; done

