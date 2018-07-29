##code from MDH,EMB

#PBS -S /bin/bash
#PBS -q batch
#PBS -N fastqc
#PBS -l nodes=1:ppn=24:AMD
#PBS -l mem=20gb
#PBS -l walltime=24:00:00

cd /lustre1/sb61937/STIM_READS
mkdir /lustre1/sb61937/STIM_fastqc_output

set -ueo pipefail
FILES="
138599-110-47576580
138599-23-47580598
138599-68-47581561
138599-8-47580595
138599-134-47587572
138599-63-47586581
138599-69-47569618
138599-90-47571617"
i=1
for FNAME in $FILES
do
cd $FNAME ##same four loop to navigate through sample subdirectories
##load fastqc
module load FastQC/0.11.5-Java-1.8.0_144

time fastqc * -o /lustre1/sb61937/STIM_fastqc_output -f fastq ##run fastqc with fastq input
cd .. ##this next three lines are part of the for-loop
let "i+=1"
done
