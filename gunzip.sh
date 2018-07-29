##using parameters from MDH, code from EMB

#PBS -S /bin/bash
#PBS -q batch
#PBS -N gunzip
#PBS -l nodes=1:ppn=1:tcgnode
#PBS -l mem=50gb
#PBS -l walltime=24:00:00
#PBS -M samantha.bock@uga.edu


#building for loop to unzip all files in all directories
cd /lustre1/sb61937/STIM_READS
set -ueo pipefail
## -ueo pipefail is to make the bash script safer:
## -e immediately exit if command fails
## -o pipefail sets exit code of a pipeline to the rightmost command -- allows for immediate exit even if the exti code does not come from the last command of pipeline
## -u treat unset variables as error and cause immediate exit

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
for FNAME in $files
do
cd $FNAME
gunzip *
cd ..
let "i+=1"
done
#i=1 tells it to start with the first item in the directory $FILES and then i+=1 tells it to go to the next item
