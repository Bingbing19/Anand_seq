#This script is used to do sam to bam to bedgraph
#!/bin/bash
#
#SBATCH --job-name=samtools_R1
#SBATCH -n 1
#SBATCH -t 1-00:00 

module load gcc/8.2.0
module load samtools/1.9
