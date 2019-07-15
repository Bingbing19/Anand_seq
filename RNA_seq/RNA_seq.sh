#This is for RNA seq
#1. Raw counts counting

for file in *WT*; do echo $file $(( $(cat $file | wc -l | awk '{print $1}') / 4 )); done

for file in *PAM*; do echo $file $(( $(cat $file | wc -l | awk '{print $1}') / 4 )); done

for file in *E1103G*; do echo $file $(( $(cat $file | wc -l | awk '{print $1}') / 4 )); done

for file in *N1082S*; do echo $file $(( $(cat $file | wc -l | awk '{print $1}') / 4 )); done

for file in *H1085Q*; do echo $file $(( $(cat $file | wc -l | awk '{print $1}') / 4 )); done

for file in *G1097D*; do echo $file $(( $(cat $file | wc -l | awk '{print $1}') / 4 )); done

for file in *H1085Y*; do echo $file $(( $(cat $file | wc -l | awk '{print $1}') / 4 )); done

#2. Any read does not pass the Ibllumina filter "Y"

cat *.fastq | awk -v FS=: '{ getline a; getline b; getline c; if ($8=="Y") {print $0; print a; print b; print c; }}' > illumina_Y.fastq

#3. print those line which 4 field !=-1.
cat filename  | awk -F"\t" '$4 != -1 {print $0}'

#4. Test sam to bam.
samtools view -S -b 9_CKY3284_WT_C2_R1_hs2.sam > 9_CKY3284_WT_C2_R1_hs2.bam

samtools view 9_CKY3284_WT_C2_R1_hs2.bam | grep -w "NH:i:1" | cat header.sam - | samtools view -Sb - > 9_CKY3284_WT_C2_R1_hs2_unique_2.bam

samtools sort 9_CKY3284_WT_C2_R1_hs2_unique_2.bam > 9_CKY3284_WT_C2_R1_hs2_unique_sorted.bam
##4.1 count aligned reads

for file in *bam; do echo $file $(samtools flagstat $file | sed -n '1p' | awk '{print $1}'); done

## 4.1.1
samtools flagstat 9_CKY3284_WT_C2_R1_hs2_unique_sorted.bam
#51368 + 0 in total
#0 + 0 secondary
#0 + 0 supplementary
#0 + 0 duplicates

## 4.1.2
samtools idxstats 9_CKY3284_WT_C2_R1_hs2_unique_sorted.bam | cut -f 1,3
#AB3256911
#MISPCG6
#chromosome_11771
#chromosome_21255
#chromosome_3572
#mating_type_region0
#chrI647
#chrII3694
#chrIII1088
#chrIV6231
#chrV2442
#chrVI837
#chrVII5975
#chrVIII2148
#chrIX1093
#chrX2343
#chrXI2903
#chrXII4797
#chrXIII3284
#chrXIV2433
#chrXV4418
#chrXVI3417
#chrM13
#*0


#5. bam to bedgraph
bamtobed -cigar -i 9_CKY3284_WT_C2_R1_hs2_unique_sorted.bam > 9_CKY3284_WT_C2_R1_hs2_unique_sorted.bed


bedtools genomecov -g /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_chr.fa.fai -i 9_CKY3284_WT_C2_R1_hs2_unique_sorted.bed -bg > 9_CKY3284_WT_C2_R1_hs2_unique_sorted.bedgraph


bedtools genomecov -g /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_chr.fa.fai -i 9_CKY3284_WT_C2_R1_hs2_unique_sorted.bed -bg -5 -strand - > 9_CKY3284_WT_C2_R1_hs2_unique_rs.bedgraph

 bedtools genomecov -g /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_chr.fa.fai -i 9_CKY3284_WT_C2_R1_hs2_unique_sorted.bed -bg -5 -strand + > 9_CKY3284_WT_C2_R1_hs2_unique_fw.bedgraph

scp bid14@@htc.crc.pitt.edu:/bgfs/ckaplan/Anand_seq/Genomes/INDEX_HISAT2/spo_sce_index/ht2_spo_sce_index* /Users/bingbingduan/Documents/Anand_Sequencing/Genomes/combined_index


#6. bedgraph to bigwig

##Modules could be load

module load kentutils/v370
module load bedops/2.4.35
module load deeptools/3.1.2
module load gcc/8.2.0 samtools/1.9
##This must start from fw or rev bedgraph, not the merged file.

#6.1 "LC_COLLATE=" sort bedgraph

for file in *.bg; do echo $file && LC_COLLATE=C sort -k1,1 -k2,2n ${file} > ${file/.bg/_sorted.bg}; done

#6.1 bedgraph to bigwig

for file in *sorted.bg; do echo $file && bedGraphToBigWig ${file} /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Budding_Fission_new.genome ${file/bg/bigwig}; done

gff2bed --keep-header --do-not-sort < Spo_Sce_chr_genome.gff3 > Spo_Sce_chr_genome.bed

awk 'BEGIN{FS=OFS="\t"} {print $1,$2,$3,$4,$5,$6}' Spo_Sce_chr_genome.bed > Spo_Sce_chr_genome_6.bed

awk 'BEGIN{FS=OFS="\t"} {$5="."} {print}' Spo_Sce_chr_genome_6.bed > Spo_Sce_chr_genome_6_INDX.bed

grep "+" /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Spo_Sce_chr_genome_6_INDX.bed > Spo_Sce_chr_genome_6_fs.bed

grep "-" /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Spo_Sce_chr_genome_6_INDX.bed > Spo_Sce_chr_genome_6_rev.bed

for file in *fw_sorted.bigwig; do echo $file; computeMatrix reference-point --referencePoint TES -S ${file} -R Spo_Sce_chr_genome_6_fs.bed -p 3 -b 250 -a 250 --sortRegions keep --missingDataAsZero --binSize 1 --averageTypeBins sum -o ${file/_sorted.bigwig/.gz} --outFileNameMatrix ${file/_sorted.bigwig/.tab}; done

for file in *rev_sorted.bigwig; do echo $file; computeMatrix reference-point --referencePoint TES -S ${file} -R Spo_Sce_chr_genome_6_rev.bed -p 3 -b 250 -a 250 --sortRegions keep --missingDataAsZero --binSize 1 --averageTypeBins sum -o ${file/_sorted.bigwig/.gz} --outFileNameMatrix ${file/_sorted.bigwig/.tab}; done

for file in *gz; do echo ${file} && plotHeatmap -m ${file} --sortRegions keep --colorMap RdBu --yMax 0.02 --zMin -1 --zMax 3 -out ${file/_hs2.bed_fw.gz/.png}; done

plotHeatmap -m 10_CKY3624_G1097D_C2_R1_hs2.bed_fw.gz --sortRegions keep --colorList white,red --yMax 0.05 --zMin 0 --zMax 1 -out 10_CKY3624_G1097D_2.png

for f1 in *fw.gz; do f2=${f1/fw.gz/rev.gz} && echo $f1 $f2 && computeMatrixOperations rbind -m $f1 $f2 -o ${f1/_hs2.bed_fw.gz/.gz}; done

for file in *R1.gz; do echo $file && computeMatrixOperations sort -m $file -R /bgfs/ckaplan/Anand_seq/Genomes/Combined_yeast/Spo_Sce_chr_genome_6_INDX.bed -o ${file/.gz/_sorted.gz}; done
