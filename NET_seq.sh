
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
module load cufflinks/2.2.1

#   -T  -o option will output GTF format instead of GFF3
# different between gtf (general transfer format) and gff(general feature format): https://useast.ensembl.org/info/website/upload/gff.html

gffread -T schizosaccharomyces_pombe.genome.gff3 -o schizosaccharomyces_pombe.genome.gtf

#1.1 Extract exons and splicesite in Spo by HISAT2.

module load hisat2/2.1.0

hisat2_extract_exons.py /bgfs/ckaplan/Anand_seq/Genomes/Spo/schizosaccharomyces_pombe.genome.gtf > /bgfs/ckaplan/Anand_seq/Genomes/Spo/spo_chr_exons.txt

hisat2_extract_splice_sites.py /bgfs/ckaplan/Anand_seq/Genomes/Spo/schizosaccharomyces_pombe.genome.gtf > spo_chr_splicesites.txt

#1.2 Index exons and splicesite of Spo

hisat2-build -f --ss spo_chr_splicesites.txt --exon spo_chr_exons.txt /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_chr.fa ht2_Budding_Fission_spo > ht2_Budding_Fission_index_spo.txt &

 
### UMI trimming

module load umi-tools/0.5.5

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
