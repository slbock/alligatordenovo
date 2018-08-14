#PBS -S /bin/bash
#PBS -q batch
#PBS -N gunzip
#PBS -l walltime=24:00:00
#PBS -M samantha.bock@uga.edu


cd /lustre1/sb61937/YATSU_READS

gunzip *.fastq.gz
