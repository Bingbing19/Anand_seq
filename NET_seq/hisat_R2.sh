#!/bin/bash
#
#SBATCH --job-name=hisat2_alignment
#SBATCH -n 1
#SBATCH -t 1-00:00 

module load hisat2/2.1.0

for f1 in *cutadapt.fastq; do echo $f1 && hisat2 -q --phred33 --max-intronlen 4000 --known-splicesite-infile --no-unal /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index/spo_sce_splicesites.txt --rna-strandness F --secondary --no-mixed --summary-file ${f1/UMI_cutadapt.fastq/hs2.txt} -x /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index/ht2_spo_sce_index ${f1} -S ${f1/UMI_cutadapt.fastq/hs2.sam}; done

