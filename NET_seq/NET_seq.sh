
#!/bin/sh

# This is a script Bingbing used to alignment Anand's NETseq sequencing data.

# Usage: each command could be run in terminal.

# count raw reads in Miseq data; reads would be count in two replicate files seperately.

for file in Replicates; do echo $file $(( $(cat *R1.fastq | wc -l | awk '{print $1}') / 4 )); done 

for file in Replicates_2; do echo $file $(( $(cat *R2.fastq | wc -l | awk '{print $1}') / 4 )); done

# count raw reads in Hiseq data; reads would be count in two replicate files seperately.

for file in 18314Kap_N19007; do echo $file $(( $(cat *R1_001.fastq | wc -l | awk '{print $1}') /4 )); done

for file in 18314Kap_N19007; do echo $file $(( $(cat *R2_001.fastq | wc -l | awk '{print $1}') /4 )); done

for file in 18314Kap_N19007_2; do echo $file $(( $(cat *R1_001.fastq | wc -l | awk '{print $1}') /4 )); done

for file in 18314Kap_N19007_2; do echo $file $(( $(cat *R2_001.fastq | wc -l | awk '{print $1}') /4 )); done

# Use awk command to extract reads that contain "Y" in 8th feilds representing bad quality reads in Miseq and Hiseq, command are ready to run in each folder.Path are here: \ /bgfs/ckaplan/Anand_seq/NET_seq/Hiseq/18314Kap_N19007; \ /bgfs/ckaplan/Anand_seq/NET_seq/Hiseq/18314Kap_N19007_2; \ /bgfs/ckaplan/Anand_seq/NET_seq/Miseq/Replicates; \ /bgfs/ckaplan/Anand_seq/NET_seq/Miseq/Replicates_2
## Y if the read is filtered (did not pass), N otherwise.

cat *fastq | awk -v FS=: '{ getline a; getline b; getline c; if ($8=="Y") { print $0; print a; print b; print c; } }' > R1R2_illumina_Y.fastq


### INDEX

#1. Index exons and splicesite of Spo. Sce has been down in 092718.
# File path: /bgfs/ckaplan/Anand_seq/Genomes/Spo

#1.0 Switch chromosome name in pombe gff file from "I" to "chromosome_1", this is to be identical with pombe genome fastq file.

sed 's/III/chromosome_3/' schizosaccharomyces_pombe.genome.gff3 | sed 's/II/chromosome_2/'  - > schizosaccharomyces_pombe_chr.genome.gff

sed 's/IT/3T/' schizosaccharomyces_pombe_chr.genome.gff | sed 's/ID/TD/'  - > schizosaccharomyces_pombe_chr_1.genome.gff

sed 's/I/chromosome_1/' schizosaccharomyces_pombe_chr_1.genome.gff | sed 's/TD/ID/' | sed 's/3T/IT/' - > schizosaccharomyces_pombe_chr_2.genome.gff

sed 's/SPMchromosome_1T/SPMIT/' schizosaccharomyces_pombe_chr_2.genome.gff | sed 's/RNAchromosome_1LE/RNAILE/' - > schizosaccharomyces_pombe_chr_3.genome.gff

sed 's/RNAHchromosome_1S/RNAHIS/' schizosaccharomyces_pombe_chr_3.genome.gff > schizosaccharomyces_pombe_chr_4.genome.gff

#1.0.1, Convert gff to gtf: # different between gtf (general transfer format) and gff(general feature format): https://useast.ensembl.org/info/website/upload/gff.html
module load cufflinks/2.2.1 
gffread -T schizosaccharomyces_pombe.genome_chr.gff -o schizosaccharomyces_pombe_chr.genome.gtf

#1.1 Extract exons and splicesite in Spo by HISAT2.

module load hisat2/2.1.0

hisat2_extract_exons.py /bgfs/ckaplan/Anand_seq/Genomes/Spo/schizosaccharomyces_pombe_chr.genome.gtf > /bgfs/ckaplan/Anand_seq/Genomes/Spo/spo_chr_exons.txt

hisat2_extract_splice_sites.py /bgfs/ckaplan/Anand_seq/Genomes/Spo/schizosaccharomyces_pombe.genome_chr.gtf > spo_chr_splicesites.txt

#1.2 Index exons and splicesite of Spo

hisat2-build -f --ss spo_chr_splicesites.txt --exon spo_chr_exons.txt /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_chr.fa ht2_Budding_Fission_spo > ht2_Budding_Fission_index_spo.txt &

#1.3 Cat chr in the mixed genome. This is to know the order of Spo and Sce in the mixed genome.

cat Budding_Fission_chr.fa | grep "chr"

##Spo first then Sce.

#1.4 Cat Sco and Sce exon and splicesite together in the path: /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index

cat /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_index_2019/spo_chr_exons.txt /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/sce_index_2019/R64-1-1_chr_exons.txt > spo_sce_exons.txt

cat /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_index_2019/spo_chr_splicesites.txt /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/sce_index_2019/R64-1-1_chr_splicesites.txt > spo_sce_splicesites.txt

#1.5 Index exons and splicesite of Spo and Sce in mixed genome.

hisat2-build -f --ss spo_sce_splicesites_chr.txt --exon spo_sce_exons_chr.txt /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_chr.fa ht2_spo_sce_index > ht2_spo_sce_index.txt &

### UMI trimming

module load umi-tools/0.5.5

#### 1. Miseq
umi_tools extract --stdin=ck01_R1.fastq --read2-in=ck01_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck01_R1_UMI.fastq --read2-out=ck01_R2_UMI.fastq

umi_tools extract --stdin=ck03_R1.fastq --read2-in=ck03_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck03_R1_UMI.fastq --read2-out=ck03_R2_UMI.fastq

umi_tools extract --stdin=ck05_R1.fastq --read2-in=ck05_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck05_R1_UMI.fastq --read2-out=ck05_R2_UMI.fastq

umi_tools extract --stdin=ck07_R1.fastq --read2-in=ck07_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck07_R1_UMI.fastq --read2-out=ck07_R2_UMI.fastq

umi_tools extract --stdin=ck09_R1.fastq --read2-in=ck09_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck09_R1_UMI.fastq --read2-out=ck09_R2_UMI.fastq

umi_tools extract --stdin=ck11_R1.fastq --read2-in=ck11_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck11_R1_UMI.fastq --read2-out=ck11_R2_UMI.fastq

umi_tools extract --stdin=ck13_R1.fastq --read2-in=ck13_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck13_R1_UMI.fastq --read2-out=ck13_R2_UMI.fastq

umi_tools extract --stdin=ck15_R1.fastq --read2-in=ck15_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck15_R1_UMI.fastq --read2-out=ck15_R2_UMI.fastq

umi_tools extract --stdin=ck02_R1.fastq --read2-in=ck02_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck02_R1_UMI.fastq --read2-out=ck02_R2_UMI.fastq

umi_tools extract --stdin=ck04_R1.fastq --read2-in=ck04_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck04_R1_UMI.fastq --read2-out=ck04_R2_UMI.fastq

umi_tools extract --stdin=ck06_R1.fastq --read2-in=ck06_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck06_R1_UMI.fastq --read2-out=ck06_R2_UMI.fastq

umi_tools extract --stdin=ck08_R1.fastq --read2-in=ck08_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck08_R1_UMI.fastq --read2-out=ck08_R2_UMI.fastq 

umi_tools extract --stdin=ck10_R1.fastq --read2-in=ck10_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck10_R1_UMI.fastq --read2-out=ck10_R2_UMI.fastq 

umi_tools extract --stdin=ck12_R1.fastq --read2-in=ck12_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck12_R1_UMI.fastq --read2-out=ck12_R2_UMI.fastq

umi_tools extract --stdin=ck14_R1.fastq --read2-in=ck14_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck14_R1_UMI.fastq --read2-out=ck14_R2_UMI.fastq

umi_tools extract --stdin=ck16_R1.fastq --read2-in=ck16_R2.fastq --bc-pattern=NNNN --bc-pattern2=NNNN --stdout=ck16_R1_UMI.fastq --read2-out=ck16_R2_UMI.fastq


####2. Hiseq2 Alignment

#2.1 test alignment on Miseq ck01

hisat2 -q --phred33 --max-intronlen 4000 --known-splicesite-infile --no-unal /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index/spo_sce_splicesites.txt --rna-strandness RF --secondary --no-mixed --summary-file CK01_test.txt -x /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index/ht2_spo_sce_index -1 ck01_R1_UMI.fastq -2 ck01_R2_UMI.fastq -S ck01_test.sam &

# Too fewer reads aligned (<1%)
# 3355650 (100.00%) were paired; of these:
# 3233530 (96.36%) aligned concordantly 0 times
# 14148 (0.42%) aligned concordantly exactly 1 time
# 107972 (3.22%) aligned concordantly >1 times

#2.1.1 test alignment on FR mode, got same results.3.78% overall alignment rate.
#2.1.2 test alignment on mixed genome but indexed by sce spliceste and using sce splicesite, same result.
#2.1.3 test alignment on sce genome indexed by sce exons and splicesite:

hisat2 -q --phred33 --max-intronlen 4000 --known-splicesite-infile --no-unal /bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/sce_index_2019/R64-1-1_chr_splicesites.txt --rna-strandness RF --secondary --no-mixed --summary-file CK011_test.txt -x /bgfs/ckaplan/Anand_seq/indexed_r64_r64trans_2018/HISAT2_Sce/r64/genome -1 ck01_R1_UMI.fastq -2 ck01_R2_UMI.fastq -S ck011_test.sam &  

##2.94% overall alignment rate

#summary: ck01 is the no tag control, so, low alignment rate is reasonable.

#2.2 
#2.2.1 Adapter Trimming in R2.Adapter=GATCGTCGGACTGTAGAACTCTGAAC

cutadapt -a GATCGTCGGACTGTAGAACTCTGAAC -o ck03_R2_UMI_adapter.fastq  ck03_R2_UMI.fastq > cutadapt_ck03_R2.txt
#97.3% trimmed


cutadapt -a GATCGTCGGACTGTAGAACTCTGAAC -o ck03_S2_L003_UMI_adapter_R2_001.fastq  ck03_S2_L003_UMI_R2_001.fastq > cutadapt_ck03_L003_R2.txt
#74.7% trimmed

cutadapt -a GATCGTCGGACTGTAGAACTCTGAAC -O 5 -o ck03_S2_L003_UMI_adapter_R2_001.fastq  ck03_S2_L003_UMI_R2_001.fastq > cutadapt_ck03_L003_R2.txt
#97.2% trimmed 


cutadapt -a GATCGTCGGACTGTAGAACTCTGAAC -O 5 -o ck03_R2_UMI_adapter.fastq  ck03_R2_UMI.fastq > cutadapt_ck03_R2.txt
#72.7% trimmed

##2.2.2 Adapter trimming in R1: NNNNACAGGTTCAGAGTTCTACAGTCCGAC; GTTCAGAGTTCTACAGTCCGACGATC

#3. remove mitochondrial RNA.

samtools index -b input ck16_R2_hs2_unique_sorted.bam

samtools idxstats ck16_R2_hs2_unique_sorted.bam | cut -f 1 | grep -v chrM | xargs samtools view -b ck16_R2_hs2_unique_sorted.bam > ck16_R2_hs2_unique_sorted_mt.bam

##Another command, removes Pombe mt RNA, gap filling RNA.

samtools view -b ck16_R2_hs2_unique_sorted.bam chromosome_1 chromosome_2 chromosome_3 chrI chrII chrIII chrIV chrV chrVI chrVII chrVIII chrIX chrX chrXI chrXII chrXIII chrXIV chrXV chrXVI > ck16_R2_hs2_unique_sorted_mt.bam

