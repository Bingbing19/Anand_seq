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
cat *fastq | awk -v FS=: '{ getline a; getline b; getline c; if ($8=="Y") { print $0; print a; print b; print c; } }' > R1R2_illumina_Y.fastq
