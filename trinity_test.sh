#PBS -S /bin/bash
#PBS -N Trinity1.0
#PBS -q batch
#PBS -l nodes=1:ppn=16
#PBS -l walltime=48:00:00
#PBS -l mem=100gb

module load Trinity/2.6.6-foss-2016b

cd /lustre1/sb61937/STIM_READS_postqc

#run trinity with merged sorted bam file
Trinity --genome_guided_bam STIM2014.sort.bam --genome_guided_max_intron 10000 --seqType fq --max_memory 100G --CPU 8 --no_version_check --full_cleanup --SS_lib_type RF --output /lustre1/sb61937/TRINITY
