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

 
