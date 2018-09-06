#PBS -S /bin/bash
#PBS -N SAMtools1.0
#PBS -q batch
#PBS -l nodes=1:ppn=2
#PBS -l walltime=48:00:00
#PBS -l mem=20gb

module load SAMtools/1.6-foss-2016b

cd /lustre1/sb61937/STIM_READS_postqc

#use samtools to merge the sorted bam files for all samples
samtools merge STIM2014.sort.bam *.sort.bam
